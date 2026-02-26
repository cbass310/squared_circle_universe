import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/match.dart';
import '../../../logic/game_state_provider.dart';
import 'report_screen.dart';
import 'promoter_home_screen.dart'; // 🚀 IMPORT ADDED FOR ROUTING FIX
import '../../screens/hub_screen.dart'; 

class PostShowRecapScreen extends ConsumerWidget {
  final List<Match> completedCard;

  const PostShowRecapScreen({super.key, required this.completedCard});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    
    // Grab the exact financial/rating data from the week we just simulated
    final lastLedger = gameState.ledger.isNotEmpty ? gameState.ledger.first : null;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          // =========================================================
          // LEFT COLUMN: THE DATA & DASHBOARD (40%)
          // =========================================================
          Expanded(
            flex: 4,
            child: Container(
              color: const Color(0xFF121212),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("WEEKLY GM RECAP", style: TextStyle(color: Colors.amber, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                  const Text("Squared Circle Wrestling", style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 2.0)),
                  const SizedBox(height: 20),

                  // --- THE RATINGS WAR PANEL ---
                  if (lastLedger != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: lastLedger.warResult == "VICTORY" ? Colors.greenAccent : (lastLedger.warResult == "DEFEAT" ? Colors.redAccent : Colors.grey),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("SCW RATING", style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                              Text("${lastLedger.showRating} ⭐", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            children: [
                              Text(lastLedger.warResult, style: TextStyle(color: lastLedger.warResult == "VICTORY" ? Colors.greenAccent : (lastLedger.warResult == "DEFEAT" ? Colors.redAccent : Colors.grey), fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1.5)),
                              Icon(
                                lastLedger.warResult == "VICTORY" ? Icons.arrow_upward : (lastLedger.warResult == "DEFEAT" ? Icons.arrow_downward : Icons.drag_handle),
                                color: lastLedger.warResult == "VICTORY" ? Colors.greenAccent : (lastLedger.warResult == "DEFEAT" ? Colors.redAccent : Colors.grey),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text("EMPIRE RATING", style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                              Text("${lastLedger.rivalRating} ⭐", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: 30),
                  const Text("OFFICIAL MATCH RESULTS", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                  const SizedBox(height: 10),

                  // --- THE MATCH LIST ---
                  Expanded(
                    child: ListView.builder(
                      itemCount: completedCard.length,
                      itemBuilder: (context, index) {
                        final match = completedCard[index];
                        String matchup = match.wrestlers.map((w) => w.name).join(" vs ");
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(6), border: Border(left: BorderSide(color: match.rating >= 4.0 ? Colors.amber : Colors.blueAccent, width: 4))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(matchup, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Winner: ${match.winnerName.isEmpty ? 'DRAW' : match.winnerName}", style: const TextStyle(color: Colors.greenAccent, fontSize: 12)),
                                  Text("${match.rating} ⭐", style: TextStyle(color: match.rating >= 4.0 ? Colors.amber : Colors.white, fontWeight: FontWeight.bold)),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // --- PROCEED BUTTON ---
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        
                        // 🛠️ THE FIX: Reset stack to Dashboard, then push Finances!
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const PromoterHomeScreen()),
                          (route) => route.isFirst, 
                        );
                        
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (_) => const ReportScreen())
                        );
                      },
                      child: const Text("FINALIZE FINANCES & ADVANCE", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // =========================================================
          // RIGHT COLUMN: IMMERSIVE ARTWORK (60%)
          // =========================================================
          Expanded(
            flex: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  "assets/images/office_bg.png", 
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(color: Colors.grey[900], child: const Center(child: Icon(Icons.desk, size: 100, color: Colors.white10))),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [const Color(0xFF121212), Colors.transparent],
                      stops: const [0.0, 0.2],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}