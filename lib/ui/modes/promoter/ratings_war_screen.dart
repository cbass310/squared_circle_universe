import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/game_state_provider.dart';

class RatingsWarScreen extends ConsumerWidget {
  const RatingsWarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. SINGLE SOURCE OF TRUTH: Read directly from Game State
    final gameState = ref.watch(gameProvider);
    final history = gameState.ledger; // This list CLEARS automatically on reset!

    // 2. Calculate Record dynamically from the ledger
    // (We use the getters we added to GameState earlier)
    int wins = gameState.playerWins;
    int losses = gameState.rivalWins;
    int draws = gameState.draws;

    // 3. Get last 5 weeks for the chart
    // We reverse the list because 'ledger' stores newest first, but charts read left-to-right
    final recentHistory = history.take(5).toList().reversed.toList();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("RATINGS WAR ROOM", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 1. THE SCOREBOARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade900.withOpacity(0.5), Colors.red.shade900.withOpacity(0.5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTeamColumn(gameState.promotionName, "assets/images/logo_scw.png", wins, Colors.blueAccent),
                  Column(
                    children: [
                      const Text("VS", style: TextStyle(color: Colors.white30, fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text("Week ${gameState.week}", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  _buildTeamColumn("EMPIRE", "assets/images/logo_empire.png", losses, Colors.redAccent),
                ],
              ),
            ),
            
            const SizedBox(height: 10),
            Text("LIFETIME RECORD: $wins - $losses - $draws", style: const TextStyle(color: Colors.grey, letterSpacing: 2, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),

            // 2. THE TREND CHART
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("RECENT RATINGS TREND", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            const SizedBox(height: 20),
            
            if (recentHistory.isEmpty)
              const SizedBox(height: 100, child: Center(child: Text("No data yet. Run a show!", style: TextStyle(color: Colors.grey))))
            else
              Container(
                height: 200,
                padding: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                   color: const Color(0xFF1E1E1E),
                   borderRadius: BorderRadius.circular(12)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: recentHistory.map((entry) {
                    return _buildComparisonBar(entry.week, entry.showRating, entry.rivalRating);
                  }).toList(),
                ),
              ),

            const SizedBox(height: 40),

            // 3. WEEKLY LOG
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("HISTORY LOG", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            const SizedBox(height: 10),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: history.length,
              // Ledger is already Newest -> Oldest, so just print it directly
              itemBuilder: (context, index) {
                final entry = history[index];
                
                bool won = entry.warResult == "VICTORY";
                bool lost = entry.warResult == "DEFEAT";
                String resultText = entry.warResult;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(8),
                    border: Border(left: BorderSide(color: won ? Colors.green : (lost ? Colors.red : Colors.grey), width: 4)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Week ${entry.week}", style: const TextStyle(color: Colors.white70)),
                      Row(
                        children: [
                          Text("${entry.showRating}", style: TextStyle(color: won ? Colors.green : Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("-", style: TextStyle(color: Colors.grey)),
                          ),
                          Text("${entry.rivalRating}", style: TextStyle(color: lost ? Colors.red : Colors.grey, fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: won ? Colors.green.withOpacity(0.2) : (lost ? Colors.red.withOpacity(0.2) : Colors.grey.withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(4)
                        ),
                        child: Text(resultText, style: TextStyle(color: won ? Colors.green : (lost ? Colors.red : Colors.grey), fontSize: 10, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamColumn(String name, String logoPath, int score, Color color) {
    return Column(
      children: [
        Container(
          height: 60, width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
            color: Colors.black,
          ),
          child: ClipOval(
            child: Image.asset(
              logoPath, 
              fit: BoxFit.cover,
              errorBuilder: (c, o, s) => Icon(Icons.shield, color: color, size: 30),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(name, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        Text("$score", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildComparisonBar(int week, double myScore, double rivalScore) {
    double maxH = 150;
    // Normalize: 5.0 rating = full height
    double h1 = (myScore / 5.0) * maxH;
    double h2 = (rivalScore / 5.0) * maxH;
    
    // Clamp height
    h1 = h1.clamp(5.0, 150.0);
    h2 = h2.clamp(5.0, 150.0);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // My Bar
            Column(
              children: [
                Text(myScore.toString(), style: const TextStyle(color: Colors.white, fontSize: 8)),
                Container(
                  width: 15, height: h1,
                  decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(2))
                  ),
                ),
              ],
            ),
            const SizedBox(width: 4),
            // Rival Bar
            Column(
              children: [
                Text(rivalScore.toString(), style: const TextStyle(color: Colors.white54, fontSize: 8)),
                Container(
                  width: 15, height: h2,
                  decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.5),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(2))
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text("Wk $week", style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }
}