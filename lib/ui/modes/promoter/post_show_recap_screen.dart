import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/match.dart';
import '../../../logic/game_state_provider.dart';
import 'report_screen.dart';
import 'promoter_home_screen.dart'; 
import '../../screens/hub_screen.dart'; 

// --- IMPORT FOR THE WATERMARK ---
import '../../components/tv_watermark.dart';

class PostShowRecapScreen extends ConsumerWidget {
  final List<Match> completedCard;

  const PostShowRecapScreen({super.key, required this.completedCard});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    
    // Grab the exact financial/rating data from the week we just simulated
    final lastLedger = gameState.ledger.isNotEmpty ? gameState.ledger.first : null;

    // 🚨 SMART LAYOUT BUILDER 🚨
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 600; // 600 allows tablets to be side-by-side!

        if (isDesktop) {
          // 💻 PC/TABLET LAYOUT (Wide Side-by-Side)
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Row(
                children: [
                  Expanded(flex: 4, child: _buildDashboard(context, completedCard, lastLedger, true)),
                  Expanded(flex: 6, child: _buildArtworkPane(isMobile: false)),
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
                // TOP 40%: The Cinematic Viewport
                Expanded(
                  flex: 4,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildArtworkPane(isMobile: true),
                      const SafeArea(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("POST-SHOW", style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                              SizedBox(height: 4),
                              Text("WEEKLY GM RECAP", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // BOTTOM 60%: The Dashboard Data
                Expanded(
                  flex: 6,
                  child: Container(
                    color: Colors.black,
                    width: double.infinity,
                    child: _buildDashboard(context, completedCard, lastLedger, false),
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
  // --- THE DASHBOARD (Shared by Desktop & Mobile)
  // =====================================================================
  Widget _buildDashboard(BuildContext context, List<Match> completedCard, dynamic lastLedger, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        border: isDesktop ? const Border(right: BorderSide(color: Colors.white10, width: 2)) : const Border(top: BorderSide(color: Colors.white10, width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER (PC ONLY - Mobile uses the image overlay) ---
          if (isDesktop)
            const SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("WEEKLY GM RECAP", style: TextStyle(color: Colors.amber, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                    Text("Squared Circle Wrestling", style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 2.0)),
                  ],
                ),
              ),
            ),
          
          if (isDesktop) Container(height: 1, color: Colors.white10), 

          // --- CONTENT ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                              Text(lastLedger.warResult, style: TextStyle(color: lastLedger.warResult == "VICTORY" ? Colors.greenAccent : (lastLedger.warResult == "DEFEAT" ? Colors.redAccent : Colors.grey), fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.0)),
                              Icon(
                                lastLedger.warResult == "VICTORY" ? Icons.arrow_upward : (lastLedger.warResult == "DEFEAT" ? Icons.arrow_downward : Icons.drag_handle),
                                color: lastLedger.warResult == "VICTORY" ? Colors.greenAccent : (lastLedger.warResult == "DEFEAT" ? Colors.redAccent : Colors.grey),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text("RIVAL RATING", style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                              Text("${lastLedger.rivalRating} ⭐", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: 24),
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

                  const SizedBox(height: 16),

                  // --- PROCEED BUTTON ---
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        
                        // Reset stack to Dashboard, then push Finances!
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
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text("FINALIZE FINANCES & ADVANCE", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0, fontSize: 14))
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // --- ARTWORK PANE (Shared)
  // =====================================================================
  Widget _buildArtworkPane({required bool isMobile}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/images/office_bg.png", 
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (c, e, s) => Container(color: Colors.grey[900], child: const Center(child: Icon(Icons.desk, size: 100, color: Colors.white10))),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              // 🛠️ Adjust gradient direction based on device
              begin: isMobile ? Alignment.topCenter : Alignment.centerLeft,
              end: isMobile ? Alignment.bottomCenter : Alignment.centerRight,
              colors: [
                Colors.black.withOpacity(0.9), 
                Colors.black.withOpacity(0.4), 
                if (!isMobile) Colors.black.withOpacity(0.8) else Colors.transparent
              ],
              stops: isMobile ? const [0.0, 0.6, 1.0] : const [0.0, 0.4, 1.0],
            ),
          ),
        ),
        
        // 🛠️ THE FIX: Only show watermark if NOT on mobile!
        if (!isMobile)
          const TVWatermark(isMobile: false),
      ],
    );
  }
}