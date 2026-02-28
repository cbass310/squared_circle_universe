import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommissionerEventGraderScreen extends StatefulWidget {
  final String leagueId;
  const CommissionerEventGraderScreen({super.key, required this.leagueId});

  @override
  State<CommissionerEventGraderScreen> createState() => _CommissionerEventGraderScreenState();
}

class _CommissionerEventGraderScreenState extends State<CommissionerEventGraderScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  Map<String, dynamic>? _eventToGrade;
  List _questions = [];
  final Map<String, TextEditingController> _correctAnswers = {};

  @override
  void initState() {
    super.initState();
    _loadUngradedEvent();
  }

  Future _loadUngradedEvent() async {
    try {
      // 1. Find the oldest ungraded event for this league
      final event = await _supabase
          .from('pickem_events')
          .select()
          .eq('league_id', widget.leagueId)
          .eq('is_graded', false)
          .order('event_date')
          .limit(1)
          .maybeSingle();

      if (event == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      // 2. Load the matches/questions for that event
      final questions = await _supabase
          .from('pickem_questions')
          .select()
          .eq('event_id', event['id'])
          .order('created_at');

      for (var q in questions) {
        _correctAnswers[q['id'].toString()] = TextEditingController();
      }

      if (mounted) {
        setState(() {
          _eventToGrade = event;
          _questions = questions;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading event to grade: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // =========================================================================
  // 🧮 THE SCORING ENGINE (Calculates player points based on correct answers)
  // =========================================================================
  Future _gradeEvent() async {
    HapticFeedback.heavyImpact();
    // Validate that the commissioner filled out every box
    for (var q in _questions) {
      if (_correctAnswers[q['id'].toString()]!.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter the correct answer for every match!", style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.redAccent));
        return;
      }
    }
    
    setState(() => _isLoading = true);
    
    try {
      // Step 1: Save the correct answers to the database
      for (var q in _questions) {
        await _supabase.from('pickem_questions').update({
          'correct_answer': _correctAnswers[q['id'].toString()]!.text.trim(),
        }).eq('id', q['id']);
      }

      // Step 2: Fetch ALL player picks for these matches
      List<dynamic> allPicks = [];
      for (var q in _questions) {
        final picksForMatch = await _supabase.from('pickem_picks').select().eq('question_id', q['id']);
        allPicks.addAll(picksForMatch);
      }

      // Step 3: Calculate points for each user
      Map<String, int> userPointsEarned = {}; 
      
      for (var pick in allPicks) {
        String userId = pick['user_id'];
        int questionId = pick['question_id'];
        
        // Clean up the text to avoid typos (lowercase and remove extra spaces)
        String playerGuess = pick['user_answer'].toString().trim().toLowerCase();
        String actualWinner = _correctAnswers[questionId.toString()]!.text.trim().toLowerCase();

        // If they guessed right, find out how many points the match was worth and add it!
        if (playerGuess == actualWinner) {
          final questionData = _questions.firstWhere((q) => q['id'] == questionId);
          int pointsForMatch = questionData['points'];
          
          userPointsEarned[userId] = (userPointsEarned[userId] ?? 0) + pointsForMatch;
        }
      }

      // Step 4: Update the Global Pick 'Em Leaderboard!
      for (var entry in userPointsEarned.entries) {
        String userId = entry.key;
        int pointsEarned = entry.value;

        // Check if player already has a score on the board
        final existingScore = await _supabase.from('pickem_scores').select().eq('user_id', userId).maybeSingle();

        if (existingScore != null) {
          // Add to their existing total
          await _supabase.from('pickem_scores').update({
            'score': (existingScore['score'] as int) + pointsEarned
          }).eq('user_id', userId);
        } else {
          // First time scoring points! Insert a new row.
          await _supabase.from('pickem_scores').insert({
            'user_id': userId,
            'score': pointsEarned
          });
        }
      }

      // Step 5: Mark the event as fully graded so it closes out
      await _supabase.from('pickem_events').update({
        'is_graded': true,
      }).eq('id', _eventToGrade!['id']);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Event Graded! Points Awarded! 🏆", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)), backgroundColor: Colors.purpleAccent));
        Navigator.pop(context); // Send commissioner back to the desk
      }
    } catch (e) {
      debugPrint("Error grading event: $e");
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: isDesktop
            ? Row(
                children: [
                  Expanded(flex: 4, child: _buildLeftDashboard(isDesktop)),
                  Expanded(flex: 6, child: _buildRightArtworkPane(isMobile: false)),
                ],
              )
            : Column(
                children: [
                  Expanded(flex: 4, child: _buildRightArtworkPane(isMobile: true)),
                  Expanded(flex: 6, child: _buildLeftDashboard(isDesktop)),
                ],
              ),
      ),
    );
  }

  // =====================================================================
  // --- LEFT PANE: THE GRADING DASHBOARD
  // =====================================================================
  Widget _buildLeftDashboard(bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        border: isDesktop ? const Border(right: BorderSide(color: Colors.black, width: 3)) : const Border(top: BorderSide(color: Colors.black, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER ---
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.purpleAccent, size: 20), onPressed: () => Navigator.pop(context)),
                const SizedBox(width: 8),
                const Text("EVENT AUDITOR", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5)),
              ],
            ),
          ),
          
          Container(height: 3, color: Colors.black), 

          // --- CONTENT ---
          Expanded(
            child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.purpleAccent))
              : _eventToGrade == null
                  ? _buildEmptyState()
                  : Column(
                      children: [
                        // Metadata Header
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.black, width: 3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("PENDING RESULTS", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                              const SizedBox(height: 4),
                              Text(_eventToGrade!['event_name'].toString().toUpperCase(), style: const TextStyle(color: Colors.purpleAccent, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                              const SizedBox(height: 8),
                              const Text("TYPE IN THE EXACT WINNER FOR EACH MATCH TO CALCULATE PLAYER SCORES.", style: TextStyle(color: Colors.white70, fontSize: 10, height: 1.5)),
                            ],
                          ),
                        ),

                        // Match List
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: _questions.length,
                            itemBuilder: (context, index) {
                              final q = _questions[index];
                              final qId = q['id'].toString();
                              
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E1E1E),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.black, width: 2),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.purpleAccent.withOpacity(0.1),
                                        border: const Border(bottom: BorderSide(color: Colors.black, width: 2)),
                                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6))
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: Text(q['question_text'].toString().toUpperCase(), style: const TextStyle(color: Colors.purpleAccent, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.0))),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)),
                                            child: Text("${q['points']} PTS", style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 10)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: TextField(
                                        controller: _correctAnswers[qId],
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                          hintText: "Enter official winner...",
                                          hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
                                          filled: true,
                                          fillColor: const Color(0xFF121212),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.white10)),
                                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.purpleAccent)),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        // Grade Button
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Color(0xFF121212),
                            border: Border(top: BorderSide(color: Colors.black, width: 3)),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purpleAccent, 
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                elevation: 0,
                              ),
                              icon: const Icon(Icons.gavel),
                              label: const Text("FINALIZE EVENT GRADES", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                              onPressed: _gradeEvent,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.white24, size: 60),
          const SizedBox(height: 20),
          const Text("ALL CAUGHT UP", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          Text("NO EVENTS PENDING GRADES.", textAlign: TextAlign.center, style: TextStyle(color: Colors.purpleAccent.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
        ],
      ),
    );
  }

  // =====================================================================
  // --- RIGHT PANE: ARTWORK
  // =====================================================================
  Widget _buildRightArtworkPane({bool isMobile = false}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/images/event_grader_bg.png", 
          fit: BoxFit.cover,
          alignment: Alignment.centerLeft,
          errorBuilder: (c, e, s) => Image.asset("assets/images/office_background.png", fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(color: const Color(0xFF0A0A0A))),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.black.withOpacity(0.95), Colors.black.withOpacity(0.4), Colors.black.withOpacity(0.8)],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
        Positioned(
          bottom: 40, right: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.fact_check, size: 50, color: Colors.white10),
              const SizedBox(height: 10),
              Text("DATA AUDITOR", style: TextStyle(fontSize: isMobile ? 20 : 32, fontWeight: FontWeight.w900, color: Colors.white24, letterSpacing: 4.0)),
              Text("SUPABASE NODE ACTIVE", style: TextStyle(fontSize: isMobile ? 10 : 14, color: Colors.purpleAccent.withOpacity(0.5), letterSpacing: 2.0, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}