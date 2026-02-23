import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/leaderboard_entry.dart';
import 'game_state_provider.dart';

class LeaderboardNotifier extends StateNotifier<List<LeaderboardEntry>> {
  final Ref ref;

  LeaderboardNotifier(this.ref) : super([]) {
    _loadMockData();
  }

  // 1. GENERATE FAKE GLOBAL PLAYERS (So the board isn't empty)
  void _loadMockData() {
    state = [
      LeaderboardEntry(id: "1", promoterName: "CryptoKing", companyName: "BlockChain Wrestling", score: 850000, walletAddress: "8x92...kd2"),
      LeaderboardEntry(id: "2", promoterName: "Vince R.", companyName: "Titan Sports", score: 720000, walletAddress: "3j21...la9"),
      LeaderboardEntry(id: "3", promoterName: "The Booker", companyName: "AEW Galaxy", score: 650000, walletAddress: "9s81...kk0"),
      LeaderboardEntry(id: "4", promoterName: "SmarkSlayer", companyName: "Indy Darling", score: 450000, walletAddress: "2a11...pp4"),
      LeaderboardEntry(id: "5", promoterName: "SolanaWhale", companyName: "DeFi Dojo", score: 300000, walletAddress: "5h55...mm1"),
    ];
  }

  // 2. CALCULATE & ADD USER SCORE
  void submitUserScore() {
    final game = ref.read(gameProvider);

    // THE FORMULA:
    // Cash is worth 10% (div by 10)
    // Fans are worth 5 points each
    // Reputation is worth 500 points each (Hard to get!)
    int calculatedScore = (game.cash ~/ 10) + (game.fans * 5) + (game.reputation * 500);

    final userEntry = LeaderboardEntry(
      id: "user_1",
      promoterName: "YOU",
      companyName: game.promotionName,
      score: calculatedScore,
      walletAddress: "Connecting...", // Placeholder for real wallet
      isUser: true,
    );

    // Add user, sort by score (Highest first), and update state
    final newList = [...state.where((e) => !e.isUser), userEntry];
    newList.sort((a, b) => b.score.compareTo(a.score)); // Sort descending

    state = newList;
  }
}

final leaderboardProvider = StateNotifierProvider<LeaderboardNotifier, List<LeaderboardEntry>>((ref) {
  return LeaderboardNotifier(ref);
});