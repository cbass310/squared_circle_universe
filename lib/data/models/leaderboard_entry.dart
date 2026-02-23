class LeaderboardEntry {
  final String id;
  final String promoterName;
  final String companyName;
  final int score; // The calculated metric (Cash + Fans + Rep)
  final String walletAddress; // Placeholder for Solana later (e.g., "7xKZ...9s")
  final bool isUser; // To highlight YOUR score

  LeaderboardEntry({
    required this.id,
    required this.promoterName,
    required this.companyName,
    required this.score,
    this.walletAddress = "CPU",
    this.isUser = false,
  });
}