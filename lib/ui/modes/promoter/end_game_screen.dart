import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/game_state_provider.dart';

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

    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          // ------------------------------------------------
          // LEFT COLUMN: SCORE & NFT MINTING
          // ------------------------------------------------
          Expanded(
            flex: 4,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                border: Border(right: BorderSide(color: Colors.white10)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Icon(Icons.stars, color: Colors.amber, size: 60),
                  const SizedBox(height: 20),
                  const Text("CAREER COMPLETE", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2)),
                  const SizedBox(height: 40),
                  
                  // FINAL SCORE DISPLAY
                  Text("FINAL SCORE", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12, letterSpacing: 1.5)),
                  Text("\$${gameState.cash}", style: const TextStyle(color: Colors.greenAccent, fontSize: 48, fontWeight: FontWeight.w900)),
                  
                  const SizedBox(height: 10),
                  Text(gameState.promotionName.toUpperCase(), style: const TextStyle(color: Colors.grey, fontSize: 14, letterSpacing: 2, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: themeColor), 
                      borderRadius: BorderRadius.circular(30),
                      color: themeColor.withOpacity(0.1),
                    ),
                    child: Text("RANK: $rank", style: TextStyle(color: themeColor, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  ),

                  const Spacer(),

                  // --- RESTORED: NFT LEADERBOARD BUTTON ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.token, color: Colors.black),
                        label: const Text("MINT CAREER NFT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor, // Gold Button
                          padding: const EdgeInsets.all(20),
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
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(20), 
                          side: const BorderSide(color: Colors.white24),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                           // Navigate to Main Menu / Restart
                           Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        child: const Text("RETURN TO MAIN MENU", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          // ------------------------------------------------
          // RIGHT COLUMN: HALL OF FAME VISUAL
          // ------------------------------------------------
          Expanded(
            flex: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  "assets/images/hall_of_fame.png", 
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(color: const Color(0xFF101010)),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.black, Colors.transparent],
                      stops: const [0.0, 0.3],
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
            title: const Text("MINT SUCCESSFUL!", style: TextStyle(color: Colors.greenAccent)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 60),
                const SizedBox(height: 10),
                Text("Your score of $score has been immortalized on the leaderboard.", style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 10),
                const Text("Asset ID: #8839210", style: TextStyle(color: Colors.white30, fontFamily: "monospace")),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("VIEW ON EXPLORER")),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("CLOSE")),
            ],
          )
        );
      }
    });
  }
}