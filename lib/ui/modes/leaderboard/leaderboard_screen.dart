import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/leaderboard_provider.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh score every time we open this screen
    Future.microtask(() => ref.read(leaderboardProvider.notifier).submitUserScore());
  }

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(leaderboardProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("GLOBAL RANKINGS", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // MOCK SOLANA CONNECT BUTTON
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.purpleAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.purpleAccent),
            ),
            child: const Row(
              children: [
                Icon(Icons.wallet, size: 16, color: Colors.purpleAccent),
                SizedBox(width: 5),
                Text("Connect", style: TextStyle(fontSize: 12, color: Colors.purpleAccent)),
              ],
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.all(20),
            color: const Color(0xFF1E1E1E),
            child: const Row(
              children: [
                SizedBox(width: 40, child: Text("RNK", style: TextStyle(color: Colors.grey, fontSize: 10))),
                Expanded(child: Text("PROMOTER", style: TextStyle(color: Colors.grey, fontSize: 10))),
                Text("SCORE", style: TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          ),

          // LIST
          Expanded(
            child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                final rank = index + 1;
                final isTop3 = rank <= 3;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    color: entry.isUser ? Colors.green.withOpacity(0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: entry.isUser ? Border.all(color: Colors.green, width: 1) : null,
                  ),
                  child: Row(
                    children: [
                      // RANK COLUMN
                      SizedBox(
                        width: 40,
                        child: isTop3 
                          ? Icon(Icons.emoji_events, color: _getRankColor(rank), size: 20)
                          : Text("#$rank", style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
                      ),
                      
                      // AVATAR
                      CircleAvatar(
                        backgroundColor: entry.isUser ? Colors.blueAccent : Colors.grey[800],
                        radius: 16,
                        child: Text(entry.promoterName[0], style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                      const SizedBox(width: 12),

                      // NAME COLUMN
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(entry.companyName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            Text(entry.promoterName, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11)),
                          ],
                        ),
                      ),

                      // SCORE COLUMN
                      Text(
                        _formatScore(entry.score),
                        style: TextStyle(
                          color: isTop3 ? _getRankColor(rank) : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: "Monospace"
                        ),
                      ),
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

  Color _getRankColor(int rank) {
    if (rank == 1) return const Color(0xFFFFD700); // Gold
    if (rank == 2) return const Color(0xFFC0C0C0); // Silver
    if (rank == 3) return const Color(0xFFCD7F32); // Bronze
    return Colors.white;
  }

  String _formatScore(int score) {
    return score.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}