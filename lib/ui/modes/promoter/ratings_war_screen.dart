import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/game_state_provider.dart';

class RatingsWarScreen extends ConsumerWidget {
  const RatingsWarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. SINGLE SOURCE OF TRUTH: Read directly from Game State
    final gameState = ref.watch(gameProvider);
    final history = gameState.ledger; 

    // 2. Calculate Record dynamically
    int wins = gameState.playerWins;
    int losses = gameState.rivalWins;
    int draws = gameState.draws;

    // 3. Get last 5 weeks for the chart
    final recentHistory = history.take(5).toList().reversed.toList();

    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: isDesktop
            ? Row(
                children: [
                  // LEFT COLUMN: History Log (40%)
                  Expanded(flex: 4, child: _buildLeftHistoryLog(history, isDesktop, context)),
                  // RIGHT COLUMN: The War Room Dashboard (60%)
                  Expanded(flex: 6, child: _buildRightDashboard(gameState, wins, losses, draws, recentHistory, isDesktop: true)),
                ],
              )
            // MOBILE: Stack the dashboard on top of the list
            : Column(
                children: [
                  _buildMobileHeader(context),
                  Expanded(flex: 5, child: _buildRightDashboard(gameState, wins, losses, draws, recentHistory, isMobile: true)),
                  Expanded(flex: 5, child: _buildLeftHistoryLog(history, isDesktop, context)),
                ],
              ),
      ),
    );
  }

  Widget _buildMobileHeader(BuildContext context) {
    return Container(
      color: const Color(0xFF121212),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.amber, size: 20), onPressed: () => Navigator.pop(context)),
          const SizedBox(width: 8),
          const Text("WAR ROOM", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        ],
      ),
    );
  }

  // =====================================================================
  // --- LEFT PANE: HISTORY LOG 
  // =====================================================================
  Widget _buildLeftHistoryLog(List<dynamic> history, bool isDesktop, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        border: isDesktop ? const Border(right: BorderSide(color: Colors.white10, width: 2)) : const Border(top: BorderSide(color: Colors.white10, width: 2)),
      ),
      child: Column(
        children: [
          if (isDesktop)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.amber, size: 20), onPressed: () => Navigator.pop(context)),
                  const SizedBox(width: 8),
                  const Text("WAR ROOM", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                ],
              ),
            ),
          
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white10))),
            child: Row(
              children: const [
                Icon(Icons.history_edu_rounded, color: Colors.amber, size: 20),
                SizedBox(width: 8),
                Text("BATTLE LEDGER", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 12)),
              ],
            ),
          ),

          Expanded(
            child: history.isEmpty 
                ? const Center(child: Text("No data yet. Book your first show!", style: TextStyle(color: Colors.white54)))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final entry = history[index];
                      bool won = entry.warResult == "VICTORY";
                      bool lost = entry.warResult == "DEFEAT";
                      String resultText = entry.warResult;
                      
                      Color accentColor = Colors.grey;
                      if (won) accentColor = Colors.greenAccent;
                      if (lost) accentColor = Colors.redAccent;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: accentColor.withOpacity(0.5), width: 1.5),
                          boxShadow: [BoxShadow(color: accentColor.withOpacity(0.05), blurRadius: 8)],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("WEEK ${entry.week}", style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text("${entry.showRating}", style: TextStyle(color: won ? Colors.white : Colors.white54, fontWeight: FontWeight.w900, fontSize: 20)),
                                    const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text("VS", style: TextStyle(color: Colors.white24, fontSize: 12, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))),
                                    Text("${entry.rivalRating}", style: TextStyle(color: lost ? Colors.white : Colors.white54, fontWeight: FontWeight.w900, fontSize: 20)),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: accentColor.withOpacity(0.15), borderRadius: BorderRadius.circular(6), border: Border.all(color: accentColor.withOpacity(0.3))),
                              child: Text(resultText, style: TextStyle(color: accentColor, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // --- RIGHT PANE: THE MASSIVE DASHBOARD GRAPHIC
  // =====================================================================
  Widget _buildRightDashboard(dynamic gameState, int wins, int losses, int draws, List<dynamic> recentHistory, {bool isMobile = false, bool isDesktop = false}) {
    
    // 🛠️ THE FIX: Override "Universe" to "Wrestling" for this screen specifically
    String pName = gameState.promotionName.toUpperCase();
    if (pName == "SQUARED CIRCLE UNIVERSE") {
      pName = "SQUARED CIRCLE WRESTLING";
    }

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.15,
            child: Image.asset("assets/images/crowd_background.png", fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.black)),
          ),

          SingleChildScrollView(
            // 🛠️ THE FIX: Reduced overall padding so it fits without scrolling
            padding: EdgeInsets.all(isMobile ? 16 : 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // THE GIANT SCOREBOARD
                Container(
                  width: double.infinity,
                  // 🛠️ THE FIX: Reduced container padding
                  padding: EdgeInsets.all(isMobile ? 16 : 24.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.blue.shade900.withOpacity(0.8), Colors.black, Colors.red.shade900.withOpacity(0.8)], begin: Alignment.centerLeft, end: Alignment.centerRight),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24, width: 2),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.8), blurRadius: 20, offset: const Offset(0, 10))],
                  ),
                  child: Column(
                    children: [
                      const Text("LIFETIME RECORD", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 3.0)),
                      const SizedBox(height: 8),
                      // Slightly scaled down giant text
                      Text("$wins - $losses - $draws", style: TextStyle(color: Colors.white, fontSize: isMobile ? 32 : 40, fontWeight: FontWeight.w900, fontFamily: "Monospace")),
                      
                      const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Divider(color: Colors.white24)),
                      
                      // 🛠️ THE FIX: Strict symmetry using Expanded so VS is always dead-center
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2, 
                            child: _buildTeamColumn(pName, "assets/images/logo_scw.png", Colors.blueAccent, isMobile)
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 10), // Pushes VS down to align with logos
                                Text("VS", style: TextStyle(color: Colors.white30, fontSize: isMobile ? 24 : 32, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), 
                                  decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(6)), 
                                  child: Text("WEEK ${gameState.week}", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 10))
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2, 
                            child: _buildTeamColumn("EMPIRE WRESTLING", "assets/images/logo_empire.png", Colors.redAccent, isMobile)
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // 🛠️ THE FIX: Reduced gap between scoreboard and chart
                const SizedBox(height: 24),

                // THE TREND CHART
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("RECENT RATINGS TREND", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 2.0)),
                ),
                const SizedBox(height: 16),
                
                if (recentHistory.isEmpty)
                  Container(
                    height: isMobile ? 150 : 200, width: double.infinity,
                    decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
                    child: const Center(child: Text("NO DATA COLLECTED", style: TextStyle(color: Colors.white30, fontWeight: FontWeight.bold, letterSpacing: 2.0))),
                  )
                else
                  Container(
                    // 🛠️ THE FIX: Chart height is shorter so it fits on screen
                    height: isMobile ? 160 : 200,
                    padding: const EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
                    decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: recentHistory.map((entry) {
                        return _buildComparisonBar(entry.week, entry.showRating, entry.rivalRating, isMobile ? 100 : 130);
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildTeamColumn(String name, String logoPath, Color color, bool isMobile) {
    return Column(
      children: [
        // 🛠️ THE FIX: Slightly smaller avatars
        Container(
          height: isMobile ? 60 : 80, width: isMobile ? 60 : 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.5), width: 3),
            color: Colors.black,
            boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 15)],
          ),
          child: ClipOval(
            child: Image.asset(
              logoPath, 
              fit: BoxFit.cover,
              errorBuilder: (c, o, s) => Icon(Icons.shield, color: color, size: isMobile ? 30 : 40),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // 🛠️ THE FIX: Smaller font, strictly centered, max lines to force nice wrapping
        Text(
          name, 
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: isMobile ? 10 : 13, letterSpacing: 1.0, height: 1.2)
        ),
      ],
    );
  }

  // 🛠️ THE FIX: Pass maxH dynamically so the bars don't overflow the newly shortened container
  Widget _buildComparisonBar(int week, double myScore, double rivalScore, double maxH) {
    double h1 = (myScore / 5.0) * maxH;
    double h2 = (rivalScore / 5.0) * maxH;
    
    h1 = h1.clamp(5.0, maxH);
    h2 = h2.clamp(5.0, maxH);
    
    bool won = myScore >= rivalScore;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // My Bar
            Column(
              children: [
                Text(myScore.toString(), style: TextStyle(color: won ? Colors.greenAccent : Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Container(
                  width: 20, height: h1,
                  decoration: BoxDecoration(
                      color: won ? Colors.greenAccent : Colors.blueAccent.withOpacity(0.5),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      boxShadow: won ? [BoxShadow(color: Colors.greenAccent.withOpacity(0.3), blurRadius: 5)] : []
                  ),
                ),
              ],
            ),
            const SizedBox(width: 6),
            // Rival Bar
            Column(
              children: [
                Text(rivalScore.toString(), style: TextStyle(color: !won ? Colors.redAccent : Colors.white30, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Container(
                  width: 20, height: h2,
                  decoration: BoxDecoration(
                      color: !won ? Colors.redAccent : Colors.red.withOpacity(0.3),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4))
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text("WK $week", style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}