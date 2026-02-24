import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<Map<String, dynamic>> _leaderboard = [];

  @override
  void initState() {
    super.initState();
    _fetchGlobalScores();
  }

  Future<void> _fetchGlobalScores() async {
    try {
      // Fetch the top 100 promoters in the world, sorted by highest score
      final response = await _supabase
          .from('promoter_scores')
          .select()
          .order('score', ascending: false)
          .limit(100);

      if (mounted) {
        setState(() {
          _leaderboard = List<Map<String, dynamic>>.from(response);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching leaderboard: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Color _getRankColor(int index) {
    if (index == 0) return Colors.amber; // 1st Place Gold
    if (index == 1) return const Color(0xFFC0C0C0); // 2nd Place Silver
    if (index == 2) return const Color(0xFFCD7F32); // 3rd Place Bronze
    return Colors.white10; // Everyone else
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.purpleAccent), 
          onPressed: () => Navigator.pop(context)
        ),
        title: const Text(
          "GLOBAL RANKINGS", 
          style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, letterSpacing: 2.0)
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.purpleAccent))
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "TOP PROMOTERS WORLDWIDE", 
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.5)
                  ),
                ),
                const Divider(color: Colors.white10, height: 1, thickness: 2),
                Expanded(
                  child: _leaderboard.isEmpty
                      ? const Center(
                          child: Text(
                            "THE HALL OF FAME IS EMPTY.\nBE THE FIRST TO MAKE HISTORY.", 
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.bold, height: 1.5)
                          )
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 8, bottom: 24),
                          itemCount: _leaderboard.length,
                          itemBuilder: (context, index) {
                            final entry = _leaderboard[index];
                            final isTopThree = index < 3;
                            final rankColor = _getRankColor(index);
                            
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E1E1E),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: rankColor, width: isTopThree ? 2 : 1)
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: rankColor,
                                  child: Text(
                                    "${index + 1}", 
                                    style: TextStyle(
                                      color: isTopThree ? Colors.black : Colors.white, 
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                ),
                                title: Text(
                                  entry['promotion_name'].toString().toUpperCase(), 
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0)
                                ),
                                trailing: Text(
                                  "${entry['score']} PTS", 
                                  style: TextStyle(
                                    color: isTopThree ? rankColor : Colors.purpleAccent, 
                                    fontSize: 18, 
                                    fontWeight: FontWeight.w900
                                  )
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}