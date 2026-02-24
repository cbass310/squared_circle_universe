import 'package:flutter/material.dart';
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

  Future _gradeEvent() async {
    // Validate
    for (var q in _questions) {
      if (_correctAnswers[q['id'].toString()]!.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter the correct answer for every match!"), backgroundColor: Colors.red));
        return;
      }
    }
    setState(() => _isLoading = true);
    try {
      // 1. Update each question with the correct answer
      for (var q in _questions) {
        await _supabase.from('pickem_questions').update({
          'correct_answer': _correctAnswers[q['id'].toString()]!.text.trim(),
        }).eq('id', q['id']);
      }
      // 2. Mark the event as graded
      await _supabase.from('pickem_events').update({
        'is_graded': true,
      }).eq('id', _eventToGrade!['id']);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Event Graded! Points Awarded! 🏆"), backgroundColor: Colors.green));
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Error grading event: $e");
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
      setState(() => _isLoading = false);
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
        title: const Text("GRADE EVENT", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.cyanAccent))
          : _eventToGrade == null
              ? const Center(child: Text("NO EVENTS TO GRADE", style: TextStyle(color: Colors.white54, fontSize: 18, fontWeight: FontWeight.bold)))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("RESULTS: ${_eventToGrade!['event_name'].toString().toUpperCase()}", style: const TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                      const SizedBox(height: 8),
                      const Text("Type in the exact winner for each match to calculate player scores.", style: TextStyle(color: Colors.white70)),
                      const Divider(color: Colors.white10, height: 32, thickness: 2),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _questions.length,
                          itemBuilder: (context, index) {
                            final q = _questions[index];
                            final qId = q['id'].toString();
                            return Card(
                              color: const Color(0xFF1E1E1E),
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: Text(q['question_text'], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
                                        Text("${q['points']} PTS", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: _correctAnswers[qId],
                                      style: const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        hintText: "Who actually won?",
                                        hintStyle: const TextStyle(color: Colors.white24),
                                        filled: true,
                                        fillColor: const Color(0xFF121212),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.gavel, color: Colors.black),
                        label: const Text("GRADE EVENT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          minimumSize: const Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _gradeEvent,
                      ),
                    ],
                  ),
                ),
    );
  }
}
