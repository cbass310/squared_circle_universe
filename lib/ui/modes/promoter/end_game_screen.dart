import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // 🚨 NEW: Added Supabase
import '../../../logic/game_state_provider.dart';

// --- IMPORT FOR THE WATERMARK ---
import '../../components/tv_watermark.dart';

// 🚨 CHANGED TO STATEFUL WIDGET SO WE CAN UPLOAD THE SCORE ONCE
class EndGameScreen extends ConsumerStatefulWidget {
  const EndGameScreen({super.key});

  @override
  ConsumerState<EndGameScreen> createState() => _EndGameScreenState();
}

class _EndGameScreenState extends ConsumerState<EndGameScreen> {
  bool _scoreUploaded = false;

  @override
  void initState() {
    super.initState();
    // Upload the score to the global leaderboard as soon as the screen opens
    _uploadFinalScore();
  }

  Future<void> _uploadFinalScore() async {
    try {
      final gameState = ref.read(gameProvider);
      final session = Supabase.instance.client.auth.currentSession;
      
      // Only upload if they are logged in to the Global Network
      if (session != null && !_scoreUploaded) {
        await Supabase.instance.client.from('tycoon_scores').insert({
          'user_id': session.user.id,
          'promotion_name': gameState.promotionName,
          'score': gameState.cash,
        });
        setState(() => _scoreUploaded = true);
        debugPrint("Score successfully uploaded to Tycoon Legacy Board!");
      }
    } catch (e) {
      debugPrint("Failed to upload score: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    
    // LOGIC: Determine Rank
    String rank = "ROOKIE";
    if (gameState.cash > 100000) {
      rank = "LEGEND";
    } else if (gameState.cash > 50000) {
      rank = "ICON";
    } else if (gameState.cash > 10000) {
      rank = "PRO";
    }

    Color themeColor = const Color(0xFFFFD740); // Gold
    
    // Format the final score to look like real money (e.g., $1,000,000)
    String formattedScore = "\$${gameState.cash.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}";

    // 🚨 SMART LAYOUT BUILDER 🚨
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 800;

        if (isDesktop) {
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
          return Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              children: [
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
                      const SafeArea(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.stars, color: Colors.amber, size: 28),
                                  SizedBox(width: 8),
                                  Text("HALL OF FAME", style: TextStyle(color: Colors.amber, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text("CAREER COMPLETE", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
    
    String boardTitle = "";
    String boardMessage = "";
    Color letterColor = Colors.white;

    switch (rank) {
      case "LEGEND":
        boardTitle = "EVALUATION: OUTSTANDING";
        boardMessage = "The Board of Directors is absolutely astounded. You didn't just run a wrestling promotion; you built an empire that will be remembered for decades. Your contract has been renewed indefinitely. You are a legend in this industry.";
        letterColor = Colors.amber;
        break;
      case "ICON":
        boardTitle = "EVALUATION: EXCELLENT";
        boardMessage = "Excellent work. You consistently delivered profitable shows, grew our market share, and managed the locker room effectively. The Board is highly impressed with your leadership.";
        letterColor = Colors.greenAccent;
        break;
      case "PRO":
        boardTitle = "EVALUATION: SATISFACTORY";
        boardMessage = "You survived the grueling world of professional wrestling and turned a modest profit. The Board acknowledges your competence, though there is still plenty of room for growth.";
        letterColor = Colors.blueAccent;
        break;
      default: // ROOKIE
        boardTitle = "EVALUATION: TERMINATED";
        boardMessage = "Frankly, the Board is deeply disappointed. We expected a wrestling revolution, but we barely kept the lights on. Please pack your desk. Your services are no longer required.";
        letterColor = Colors.redAccent;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: isDesktop ? const Border(right: BorderSide(color: Colors.white10)) : null,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isDesktop) ...[
              const SizedBox(height: 60),
              const Icon(Icons.stars, color: Colors.amber, size: 60),
              const SizedBox(height: 20),
              const Text("CAREER COMPLETE", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2)),
              const SizedBox(height: 40),
            ],
            
            if (!isDesktop) const SizedBox(height: 20),

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

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: letterColor.withOpacity(0.5), width: 2),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.mail, color: letterColor, size: 18),
                      const SizedBox(width: 8),
                      const Text("FROM: THE BOARD OF DIRECTORS", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    ],
                  ),
                  const Divider(color: Colors.white10, height: 20),
                  Text(boardTitle, style: TextStyle(color: letterColor, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                  const SizedBox(height: 8),
                  Text(boardMessage, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.token, color: Colors.black),
                  label: const Text("MINT CAREER NFT", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor, 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 10,
                    shadowColor: themeColor.withOpacity(0.5),
                  ),
                  onPressed: () => _mintCareerNFT(context, gameState.cash, rank),
                ),
              ),
            ),
            
            // 🚨 THE FIX: Reset game state AND return to main menu
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
                  onPressed: () async {
                     // 1. Wipe the local save so they don't load into a finished game!
                     await ref.read(gameProvider.notifier).resetGame();
                     
                     // 2. Safely pop back to the Hub Screen
                     if (context.mounted) {
                       Navigator.of(context).popUntil((route) => route.isFirst);
                     }
                  },
                  child: const Text("RETURN TO MAIN MENU", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                ),
              ),
            ),
            
            if (!isDesktop) const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // =====================================================================
  // --- ARTWORK PANE
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
        TVWatermark(isMobile: isMobile),
      ],
    );
  }

  // --- MOCK NFT LOGIC ---
  void _mintCareerNFT(BuildContext context, int score, String rank) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Connecting to Blockchain... Minting Career NFT..."),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.purple,
      )
    );

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