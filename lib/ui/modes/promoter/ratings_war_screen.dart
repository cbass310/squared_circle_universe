import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/game_state_provider.dart';

// --- IMPORT FOR THE WATERMARK ---
import '../../components/tv_watermark.dart';

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

    // Override "Universe" to "Wrestling" for this screen specifically
    String pName = gameState.promotionName.toUpperCase();
    if (pName == "SQUARED CIRCLE UNIVERSE") {
      pName = "SQUARED CIRCLE WRESTLING";
    }

    // 🚨 SMART LAYOUT BUILDER 🚨
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 600; // 🛠️ Updated to 600 for Tablets!

        if (isDesktop) {
          // 💻 PC LAYOUT (Wide Side-by-Side)
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Row(
                children: [
                  Expanded(flex: 4, child: _buildDesktopLeftLog(history, context)),
                  Expanded(flex: 6, child: _buildDesktopRightDashboard(gameState, pName, wins, losses, draws, recentHistory)),
                ],
              ),
            ),
          );
        } else {
          // 📱 MOBILE LAYOUT (40/60 Vertical Split)
          return Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              children: [
                // TOP 40%: The Cinematic Viewport (Scoreboard)
                Expanded(
                  flex: 4,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        "assets/images/crowd_background.png", 
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(color: const Color(0xFF151515)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.8), Colors.black],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                      const TVWatermark(isMobile: true),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.amber, size: 20),
                                    onPressed: () => Navigator.pop(context),
                                    padding: EdgeInsets.zero,
                                    alignment: Alignment.topLeft,
                                  ),
                                  const Text("WAR ROOM", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                                ],
                              ),
                              const Spacer(),
                              _buildScoreboard(gameState, pName, wins, losses, draws, isMobile: true),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // BOTTOM 60%: The Dashboard Data (Chart + Ledger)
                Expanded(
                  flex: 6,
                  child: Container(
                    color: Colors.black,
                    width: double.infinity,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildChart(recentHistory, isMobile: true),
                          const SizedBox(height: 32),
                          const Text("BATTLE LEDGER", style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                          const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(color: Colors.white10, thickness: 1)),
                          
                          if (history.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Center(child: Text("No data yet. Book your first show!", style: TextStyle(color: Colors.white54))),
                            )
                          else
                            ...history.map((entry) => _buildHistoryItem(entry)),
                            
                          const SizedBox(height: 40), 
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }
    );
  }

  // =====================================================================
  // --- 💻 DESKTOP SPECIFIC WIDGETS
  // =====================================================================
  Widget _buildDesktopLeftLog(List<dynamic> history, BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        border: Border(right: BorderSide(color: Colors.white10, width: 2)),
      ),
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.amber, size: 20), onPressed: () => Navigator.pop(context)),
                  const SizedBox(width: 8),
                  const Text("WAR ROOM", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white10))),
            child: const Row(
              children: [
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
                      return _buildHistoryItem(history[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopRightDashboard(dynamic gameState, String pName, int wins, int losses, int draws, List<dynamic> recentHistory) {
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.15,
            child: Image.asset("assets/images/crowd_background.png", fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.black)),
          ),
          const TVWatermark(isMobile: false),
          SingleChildScrollView(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildScoreboard(gameState, pName, wins, losses, draws, isMobile: false),
                const SizedBox(height: 40),
                _buildChart(recentHistory, isMobile: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // --- 🧩 MODULAR COMPONENTS (Shared by Mobile and Desktop)
  // =====================================================================
  
  Widget _buildScoreboard(dynamic gameState, String pName, int wins, int losses, int draws, {required bool isMobile}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 12 : 32.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue.shade900.withOpacity(0.8), Colors.black, Colors.red.shade900.withOpacity(0.8)], begin: Alignment.centerLeft, end: Alignment.centerRight),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24, width: 2),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.8), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("LIFETIME RECORD", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 3.0)),
          const SizedBox(height: 4),
          
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "$wins - $losses - $draws", 
              style: TextStyle(color: Colors.white, fontSize: isMobile ? 26 : 48, fontWeight: FontWeight.w900, fontFamily: "Monospace")
            ),
          ),
          
          Padding(padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 24), child: const Divider(color: Colors.white24)),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4, 
                child: _buildTeamColumn(pName, "assets/images/logo_scw.png", Colors.blueAccent, isMobile)
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: isMobile ? 10 : 20), 
                    Text("VS", style: TextStyle(color: Colors.white30, fontSize: isMobile ? 20 : 36, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
                    SizedBox(height: isMobile ? 10 : 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), 
                      decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(6)), 
                      child: Text("WEEK ${gameState.week}", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 10))
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4, 
                child: _buildTeamColumn("EMPIRE WRESTLING", "assets/images/logo_empire.png", Colors.redAccent, isMobile)
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🚨 FIX 2: WRAP EACH BAR IN AN EXPANDED WIDGET SO THEY DON'T CROWD
  Widget _buildChart(List<dynamic> recentHistory, {required bool isMobile}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("RECENT RATINGS TREND", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 2.0)),
        const SizedBox(height: 16),
        
        if (recentHistory.isEmpty)
          Container(
            height: isMobile ? 160 : 250, width: double.infinity,
            decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
            child: const Center(child: Text("NO DATA COLLECTED", style: TextStyle(color: Colors.white30, fontWeight: FontWeight.bold, letterSpacing: 2.0))),
          )
        else
          Container(
            height: isMobile ? 160 : 250,
            padding: const EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
            decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              // 🚨 The mapping now wraps the result in an Expanded
              children: recentHistory.map((entry) {
                return Expanded(
                  child: _buildComparisonBar(entry.week, entry.showRating, entry.rivalRating, isMobile ? 100 : 170),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildHistoryItem(dynamic entry) {
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
  }

  // 🚨 FIX 1: CONSTRICT THE HEIGHT OF THE TEXT BOX SO LOGOS STAY EVEN
  Widget _buildTeamColumn(String name, String logoPath, Color color, bool isMobile) {
    return Column(
      children: [
        Container(
          height: isMobile ? 50 : 100, width: isMobile ? 50 : 100,
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
              errorBuilder: (c, o, s) => Icon(Icons.shield, color: color, size: isMobile ? 24 : 50),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: isMobile ? 32 : 40, // 🚨 FORCES UNIFORM HEIGHT NO MATTER HOW IT WRAPS
          child: Center(
            child: Text(
              name.replaceFirst(" ", "\n"), 
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: isMobile ? 11 : 14, letterSpacing: 1.0, height: 1.1)
            ),
          ),
        ),
      ],
    );
  }

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
          mainAxisAlignment: MainAxisAlignment.center, // Keeps the two bars tightly grouped together
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // My Bar
            Column(
              children: [
                Text(myScore.toString(), style: TextStyle(color: won ? Colors.greenAccent : Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Container(
                  width: 14, height: h1, // Slightly thinner to guarantee they fit on tiny screens
                  decoration: BoxDecoration(
                      color: won ? Colors.greenAccent : Colors.blueAccent.withOpacity(0.5),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      boxShadow: won ? [BoxShadow(color: Colors.greenAccent.withOpacity(0.3), blurRadius: 5)] : []
                  ),
                ),
              ],
            ),
            const SizedBox(width: 4),
            // Rival Bar
            Column(
              children: [
                Text(rivalScore.toString(), style: TextStyle(color: !won ? Colors.redAccent : Colors.white30, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Container(
                  width: 14, height: h2, // Slightly thinner to guarantee they fit on tiny screens
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