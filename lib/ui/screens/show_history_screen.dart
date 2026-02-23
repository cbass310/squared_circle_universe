import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../logic/game_state_provider.dart';
import '../../data/models/show_history.dart';

class ShowHistoryScreen extends ConsumerWidget {
  const ShowHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // You'll need to add a way to fetch this from Isar. 
    // For now, let's assume you've added a 'history' list to your GameState
    final history = ref.watch(gameProvider).ledger; 

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("OFFICIAL ARCHIVES", style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey[900],
      ),
      body: history.isEmpty 
        ? _buildEmptyState()
        : ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final entry = history[index];
              return _buildHistoryCard(entry);
            },
          ),
    );
  }

  Widget _buildHistoryCard(dynamic entry) {
    bool isVictory = entry.warResult == "VICTORY";

    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: isVictory ? Colors.green.withOpacity(0.5) : Colors.red.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12)
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: isVictory ? Colors.green : Colors.red,
          child: Text("W${entry.week}", style: const TextStyle(color: Colors.white, fontSize: 12)),
        ),
        title: Text(
          "WEEK ${entry.week} - YEAR ${entry.year}",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Rating: ${entry.showRating} ⭐ | Profit: \$${entry.profit}",
          style: TextStyle(color: Colors.grey[400]),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("TICKET SALES", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                Text("\$${entry.incomeTickets}", style: const TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 10),
                const Text("WAR STATUS", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                Text(
                  entry.warResult, 
                  style: TextStyle(color: isVictory ? Colors.greenAccent : Colors.redAccent, fontWeight: FontWeight.w900)
                ),
                // Here is where you will eventually list the minted "Hall of Fame" trophies
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text("No shows recorded yet.\nRun your first card to start your history!",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey)),
    );
  }
}