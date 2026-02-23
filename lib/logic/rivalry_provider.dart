import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeeklyResult {
  final int week;
  final double playerRating;
  final double rivalRating;

  WeeklyResult({required this.week, required this.playerRating, required this.rivalRating});

  bool get playerWon => playerRating > rivalRating;
}

class RivalryState {
  final List<WeeklyResult> history;
  
  RivalryState({this.history = const []});

  int get playerWins => history.where((r) => r.playerRating > r.rivalRating).length;
  int get rivalWins => history.where((r) => r.rivalRating > r.playerRating).length;
  
  // Calculate current record string (e.g., "2-1")
  String get recordString => "$playerWins - $rivalWins";
}

class RivalryNotifier extends StateNotifier<RivalryState> {
  RivalryNotifier() : super(RivalryState(history: [
    // --- TEMP: REAL DATA MOCK ---
    // Since we don't have a database yet, I am putting in data that matches 
    // your "Week 5" scenario. (1 win for Empire, 3 wins for you?)
    // You can edit these numbers to match your actual memory of the last 4 weeks.
    WeeklyResult(week: 1, playerRating: 3.5, rivalRating: 3.2),
    WeeklyResult(week: 2, playerRating: 4.0, rivalRating: 3.8),
    WeeklyResult(week: 3, playerRating: 4.2, rivalRating: 4.5), // They won this one
    WeeklyResult(week: 4, playerRating: 4.6, rivalRating: 4.2),
  ]));

  void addResult(int week, double playerRating, double rivalRating) {
    state = RivalryState(history: [
      ...state.history,
      WeeklyResult(week: week, playerRating: playerRating, rivalRating: rivalRating),
    ]);
  }
}

final rivalryProvider = StateNotifierProvider<RivalryNotifier, RivalryState>((ref) {
  return RivalryNotifier();
});