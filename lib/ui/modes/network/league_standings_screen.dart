import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LeagueStandingsScreen extends StatefulWidget {
  final String leagueId;
  const LeagueStandingsScreen({super.key, required this.leagueId});

  @override
  State<LeagueStandingsScreen> createState() => _LeagueStandingsScreenState();
}

class _LeagueStandingsScreenState extends State<LeagueStandingsScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<Map<String, dynamic>> _standings = [];
  String _leagueName = "LOADING...";

  @override
  void initState() {
    super.initState();
    _calculateStandings();
  }

  Future<void> _calculateStandings() async {
    try {
      // 1. Get League Name
      final leagueData = await _supabase.from('leagues').select('name').eq('id', widget.leagueId).single();
      
      // 2. Get all members of this league
      final members = await _supabase.from('league_members').select('user_id').eq('league_id', widget.leagueId);

      // 3. Get all questions from GRADED events in this league
      final gradedEvents = await _supabase.from('pickem_events').select('id').eq('league_id', widget.leagueId).eq('is_graded', true);
      final gradedEventIds = gradedEvents.map((e) => e['id']).toList();

      if (gradedEventIds.isEmpty) {
         if (mounted) setState(() { _leagueName = leagueData['name']; _isLoading = false; });
         return;
      }

      // FIX 1: Updated to .inFilter()
      final questions = await _supabase.from('pickem_questions').select().inFilter('event_id', gradedEventIds);

      // FIX 2: Removed accidental space in variable name
      List<Map<String, dynamic>> calculatedScores = [];

      for (var member in members) {
        final userId = member['user_id'];
        int totalPoints = 0;

        // FIX 3: Updated to .inFilter()
        final userPicks = await _supabase.from('pickem_picks').select().eq('user_id', userId).inFilter('question_id', questions.map((q) => q['id']).toList());

        for (var pick in userPicks) {
          final question = questions.firstWhere((q) => q['id'] == pick['question_id']);
          // Compare user answer to correct answer (case-insensitive trim just to be safe)
          if (pick['user_answer'].toString().trim().toLowerCase() == question['correct_answer'].toString().trim().toLowerCase()) {
            totalPoints += (question['points'] as num).toInt();
          }
        }
        calculatedScores.add({'user_id': userId, 'score': totalPoints});
      }

      // 5. Sort by score descending
      calculatedScores.sort((a, b) => b['score'].compareTo(a['score']));

      if (mounted) {
        setState(() {
          _leagueName = leagueData['name'];
          _standings = calculatedScores;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error calculating standings: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.cyanAccent), onPressed: () => Navigator.pop(context)),
        title: const Text("LEAGUE STANDINGS", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.cyanAccent))
          : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_leagueName.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              ),
              const Divider(color: Colors.white10, height: 1, thickness: 2),
              Expanded(
                child: _standings.isEmpty
                    ? const Center(child: Text("NO SCORES YET", style: TextStyle(color: Colors.white54, fontSize: 18, fontWeight: FontWeight.bold)))
                    : ListView.builder(
                        itemCount: _standings.length,
                        itemBuilder: (context, index) {
                          final player = _standings[index];
                          // Truncate user ID for display
                          final displayName = "Player ${player['user_id'].toString().substring(0, 6)}...";
                          final isFirst = index == 0;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isFirst ? Colors.amber : Colors.white10, width: isFirst ? 2 : 1)
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isFirst ? Colors.amber : Colors.white10,
                                child: Text("${index + 1}", style: TextStyle(color: isFirst ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
                              ),
                              title: Text(displayName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              trailing: Text("${player['score']} PTS", style: TextStyle(color: isFirst ? Colors.amber : Colors.cyanAccent, fontSize: 18, fontWeight: FontWeight.w900)),
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