import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/game_state_provider.dart';

// --- IMPORT FOR THE WATERMARK ---
import '../../components/tv_watermark.dart';

class EndGameScreen extends ConsumerWidget {
  const EndGameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    
    // LOGIC: Determine Rank
    String rank = "ROOKIE";
    if (gameState.cash > 100000) rank = "LEGEND";
    else if (gameState.cash > 50000) rank = "ICON";
    else if (gameState.cash > 10000) rank = "PRO";

    Color themeColor = const Color(0xFFFFD740); // Gold
    
    // Format the final score to look like real money (e.g., $1,000,000)
    String formattedScore = "\$${gameState.cash.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}";

    // 🚨 SMART LAYOUT BUILDER 🚨
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 800;

        if (isDesktop) {
          // 💻 PC LAYOUT (Wide Side-by-Side)
          return Scaffold(
            backgroundColor: Colors.black,
            body: Row(
              children: [
                Expanded(flex: 4, child: _buildDataPane(context, gameState, formattedScore, rank, themeColor, isDesktop: true)),
                Expanded(flex: 6, child: _buildArtworkPane(isMobile: false)),
              ],
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
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black.withOpacity(0.3), Colors.black],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.stars, color: Colors.amber, size: 28),
                                  SizedBox(width: 8),
                                  Text("HALL OF FAME", style: TextStyle(color: Colors.amber, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text("CAREER COMPLETE", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
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
                    child: _buildDataPane(context, gameState, formattedScore, rank, themeColor, isDesktop: false),
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
  // --- THE DATA PANE (Shared by both Layouts)
  // =====================================================================
  Widget _buildDataPane(BuildContext context, dynamic gameState, String formattedScore, String rank, Color themeColor, {required bool isDesktop}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: isDesktop ? const Border(right: BorderSide(color: Colors.white10)) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // PC Only Header
          if (isDesktop) ...[
            const Spacer(),
            const Icon(Icons.stars, color: Colors.amber, size: 60),
            const SizedBox(height: 20),
            const Text("CAREER COMPLETE", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2)),
            const SizedBox(height: 40),
          ],
          
          if (!isDesktop) const SizedBox(height: 20), // Mobile top padding

          // FINAL SCORE DISPLAY
          Text("FINAL SCORE", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
          Text(formattedScore, style: TextStyle(color: Colors.greenAccent, fontSize: isDesktop ? 48 : 40, fontWeight: FontWeight.w900)),
          
          const SizedBox(height: 10),
          Text(gameState.promotionName.toUpperCase(), style: const TextStyle(color: Colors.grey, fontSize: 14, letterSpacing: 2, fontWeight: FontWeight.bold)),

          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: themeColor, width: 2), 
              borderRadius: BorderRadius.circular(30),
              color: themeColor.withOpacity(0.1),
              boxShadow: [BoxShadow(color: themeColor.withOpacity(0.2), blurRadius: 10)],
            ),
            child: Text("RANK: $rank", style: TextStyle(color: themeColor, fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 16)),
          ),

          if (isDesktop) const Spacer() else const SizedBox(height: 40),

          // --- NFT LEADERBOARD BUTTON ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.token, color: Colors.black),
                label: const Text("MINT CAREER NFT", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor, // Gold Button
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 10,
                  shadowColor: themeColor.withOpacity(0.5),
                ),
                onPressed: () => _mintCareerNFT(context, gameState.cash, rank),
              ),
            ),
          ),
          
          // EXIT BUTTON
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                   // Navigate to Main Menu / Restart
                   Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text("RETURN TO MAIN MENU", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
              ),
            ),
          ),
          
          if (!isDesktop) const SizedBox(height: 20), // Bottom safe area for mobile
        ],
      ),
    );
  }

  // =====================================================================
  // --- ARTWORK PANE (Shared by both Layouts)
  // =====================================================================
  Widget _buildArtworkPane({required bool isMobile}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/images/hall_of_fame.png", 
          fit: BoxFit.cover,
          alignment: isMobile ? Alignment.topCenter : Alignment.center,
          errorBuilder: (c, e, s) => Container(color: const Color(0xFF101010)),
        ),
        if (!isMobile)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.black, Colors.transparent],
                stops: [0.0, 0.3],
              ),
            ),
          ),
        
        // --- THE GLOBAL WATERMARK ---
        TVWatermark(isMobile: isMobile),
      ],
    );
  }

  // --- MOCK NFT LOGIC ---
  void _mintCareerNFT(BuildContext context, int score, String rank) {
    // 1. Show Loading Indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Connecting to Blockchain... Minting Career NFT..."),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.purple,
      )
    );

    // 2. Simulate Success (Connect your real provider here later)
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        showDialog(
          context: context, 
          builder: (_) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: const Text("MINT SUCCESSFUL!", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.greenAccent, size: 60),
                const SizedBox(height: 16),
                Text("Your score of $score has been immortalized on the leaderboard.", style: const TextStyle(color: Colors.white70, height: 1.5), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6)),
                  child: const Text("Asset ID: #8839210", style: TextStyle(color: Colors.white54, fontFamily: "monospace")),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("VIEW ON EXPLORER", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("CLOSE", style: TextStyle(color: Colors.grey))),
            ],
          )
        );
      }
    });
  }
}