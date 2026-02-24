import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlayerPickSheetScreen extends StatefulWidget {
  final String leagueId;
  const PlayerPickSheetScreen({super.key, required this.leagueId});

  @override
  State<PlayerPickSheetScreen> createState() => _PlayerPickSheetScreenState();
}

class _PlayerPickSheetScreenState extends State<PlayerPickSheetScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  Map<String, dynamic>? _activeEvent;
  List _questions = [];
  final Map<String, TextEditingController> _answers = {};
  bool _alreadySubmitted = false;

  @override
  void initState() {
    super.initState();
    _loadEventData();
  }

  Future _loadEventData() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;
      // 1. Get the next active event
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
      // 2. Get the questions for this event
      final questions = await _supabase
          .from('pickem_questions')
          .select()
          .eq('event_id', event['id'])
          .order('created_at');
      // 3. Check if user already submitted picks
      if (questions.isNotEmpty) {
        final firstQ = questions[0]['id'];
        final existingPick = await _supabase
            .from('pickem_picks')
            .select()
            .eq('question_id', firstQ)
            .eq('user_id', user.id)
            .maybeSingle();
        if (existingPick != null) {
          _alreadySubmitted = true;
        }
      }
      // Initialize controllers
      for (var q in questions) {
        _answers[q['id'].toString()] = TextEditingController();
      }
      if (mounted) {
        setState(() {
          _activeEvent = event;
          _questions = questions;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading pick sheet: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future _submitPicks() async {
    // Validate
    for (var q in _questions) {
      if (_answers[q['id'].toString()]!.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please answer all questions!"), backgroundColor: Colors.red));
        return;
      }
    }
    setState(() => _isLoading = true);
    try {
      final user = _supabase.auth.currentUser!;
      final List<Map<String, dynamic>> inserts = _questions.map((q) => {
        'question_id': q['id'],
        'user_id': user.id,
        'user_answer': _answers[q['id'].toString()]!.text.trim(),
      }).toList();
      await _supabase.from('pickem_picks').insert(inserts);
      if (mounted) {
        setState(() => _alreadySubmitted = true);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Picks Locked In! 🔒"), backgroundColor: Colors.green));
      }
    } catch (e) {
      debugPrint("Error submitting picks: $e");
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
    } finally {
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
        title: const Text("MATCH CARD", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.cyanAccent))
          : _activeEvent == null
              ? const Center(child: Text("NO UPCOMING EVENTS", style: TextStyle(color: Colors.white54, fontSize: 18, fontWeight: FontWeight.bold)))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_activeEvent!['event_name'].toString().toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
                      const SizedBox(height: 8),
                      Text("LOCKS ON: ${_activeEvent!['event_date'].toString().split('T')[0]}", style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                      const Divider(color: Colors.white10, height: 32, thickness: 2),
                      if (_alreadySubmitted)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            children: [
                              Icon(Icons.lock, color: Colors.amber),
                              SizedBox(width: 8),
                              Text("YOUR PICKS ARE LOCKED IN", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
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
                                        Text("${q['points']} PTS", style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: _answers[qId],
                                      enabled: !_alreadySubmitted,
                                      style: TextStyle(color: _alreadySubmitted ? Colors.white54 : Colors.white),
                                      decoration: InputDecoration(
                                        hintText: "Who wins?",
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
                      if (!_alreadySubmitted)
                        ElevatedButton.icon(
                          icon: const Icon(Icons.check_circle, color: Colors.black),
                          label: const Text("LOCK IN PICKS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyanAccent,
                            minimumSize: const Size(double.infinity, 60),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _submitPicks,
                        ),
                    ],
                  ),
                ),
    );
  }
}
