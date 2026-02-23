import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/promoter_provider.dart'; // For Awards Logic
import '../../../logic/game_state_provider.dart';
import 'promoter_home_screen.dart'; 

class SeasonRecapScreen extends ConsumerStatefulWidget {
  const SeasonRecapScreen({super.key});

  @override
  ConsumerState<SeasonRecapScreen> createState() => _SeasonRecapScreenState();
}

class _SeasonRecapScreenState extends ConsumerState<SeasonRecapScreen> {
  AwardResult? awards;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  Future<void> _calculate() async {
    // 1. Run the heavy calculation from your existing logic
    final result = ref.read(rosterProvider.notifier).calculateYearEndAwards();
    if (mounted) {
      setState(() {
        awards = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    
    // If loading, show spinner
    if (awards == null) {
        return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator(color: Colors.amber)),
        );
    }

    // --- CALCULATE SEASON RESULT ---
    // Fixed: Removed missing rivalryProvider. Using safe defaults for now.
    final int wins = 0; // Placeholder until Rivalry system is built
    final int losses = 0;
    final double winPct = (wins + losses) > 0 ? (wins / (wins + losses)) * 100 : 0;
    
    bool isChampion = wins >= losses;
    String titleText = isChampion ? "SEASON CHAMPION" : "SEASON COMPLETE";
    Color themeColor = isChampion ? Colors.amber : Colors.grey;
    String imagePath = isChampion ? "assets/images/trophy.png" : "assets/images/game_over.png";

    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          // ------------------------------------------------
          // LEFT COLUMN: THE DATA REPORT (40%)
          // ------------------------------------------------
          Expanded(
            flex: 4,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                border: Border(right: BorderSide(color: Colors.white10)),
              ),
              child: Column(
                children: [
                   // HEADER
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.emoji_events, color: themeColor),
                          const SizedBox(width: 10),
                          Text("YEAR ${gameState.year} RECAP", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
                        ],
                      ),
                    ),
                  ),
                  
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        // 1. SEASON OUTCOME CARD
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [themeColor.withOpacity(0.2), Colors.black],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: themeColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("FINAL STANDING", style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 10, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),
                              Text(titleText, style: TextStyle(color: themeColor, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 1)),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildStatItem("WINS", "$wins", Colors.green),
                                  _buildStatItem("LOSSES", "$losses", Colors.red),
                                  _buildStatItem("WIN %", "${winPct.toStringAsFixed(0)}%", Colors.blue),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 2. THE AWARDS (From your Logic)
                        const Text("ACCOLADES //", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        
                        _buildAwardTile("WRESTLER OF THE YEAR", awards!.wrestlerOfTheYear, Icons.person, Colors.purpleAccent),
                        const SizedBox(height: 10),
                        _buildAwardTile("MATCH OF THE YEAR", "${awards!.matchOfTheYear} (${awards!.matchRating}⭐)", Icons.star, Colors.orangeAccent),
                        
                        const SizedBox(height: 20),

                        // 3. FINANCIALS
                          Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("FINANCIAL GROWTH //", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 15),
                              _buildFinanceRow("TOTAL PROFIT", "\$${awards!.totalProfit}", awards!.totalProfit > 0 ? Colors.green : Colors.red),
                              const SizedBox(height: 8),
                              _buildFinanceRow("FAN BASE", "${gameState.fans} FANS", Colors.blueAccent),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // START NEXT SEASON BUTTON
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.fast_forward),
                        label: Text("BEGIN YEAR ${gameState.year + 1}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor, 
                          foregroundColor: Colors.black, 
                          padding: const EdgeInsets.all(20)
                        ),
                        onPressed: () {
                           // 1. Reset Logic (Safe Call)
                           // ref.read(gameProvider.notifier).startNewSeason(); // Uncomment when function exists
                           
                           // 2. Go Home
                           Navigator.pushAndRemoveUntil(
                             context, 
                             MaterialPageRoute(builder: (_) => const PromoterHomeScreen()), 
                             (route) => false
                           );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          // ------------------------------------------------
          // RIGHT COLUMN: VISUALS (60%)
          // ------------------------------------------------
          Expanded(
            flex: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background
                Image.asset(
                  imagePath, 
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(color: const Color(0xFF101010)),
                ),
                // Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.black, Colors.transparent],
                      stops: const [0.0, 0.4],
                    ),
                  ),
                ),
                // Text Overlay
                Positioned(
                  bottom: 50,
                  right: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                        Text(isChampion ? "VICTORY" : "COMPLETE", style: TextStyle(fontSize: 60, fontWeight: FontWeight.w900, color: themeColor.withOpacity(0.9), letterSpacing: 2)),
                        Text("PREPARE FOR NEXT SEASON", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.5), letterSpacing: 5)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildAwardTile(String label, String value, IconData icon, Color color) {
      return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(8),
              border: Border(left: BorderSide(color: color, width: 4))
          ),
          child: Row(
              children: [
                  Icon(icon, color: color),
                  const SizedBox(width: 15),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                  )
              ],
          ),
      );
  }

  Widget _buildFinanceRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}