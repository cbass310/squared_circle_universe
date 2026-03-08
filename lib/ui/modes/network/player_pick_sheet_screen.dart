import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../leaderboard/leaderboard_screen.dart'; 

// --- IMPORT FOR THE WATERMARK ---
import '../../components/tv_watermark.dart';

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
  List<dynamic> _questions = [];
  final Map<String, TextEditingController> _answers = {};
  bool _alreadySubmitted = false;

  @override
  void initState() {
    super.initState();
    _loadEventData();
  }

  Future<void> _loadEventData() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

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

      final questions = await _supabase
          .from('pickem_questions')
          .select()
          .eq('event_id', event['id'])
          .order('created_at');

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

  Future<void> _submitPicks() async {
    HapticFeedback.heavyImpact();
    for (var q in _questions) {
      if (_answers[q['id'].toString()]!.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please answer all questions!", style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.redAccent));
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

      // Save the answers
      await _supabase.from('pickem_picks').insert(inserts);

      // 🛠️ THE FIX: Instantly register them on the Leaderboard with 0 points!
      final existingScore = await _supabase.from('pickem_scores').select().eq('user_id', user.id).maybeSingle();
      if (existingScore == null) {
        await _supabase.from('pickem_scores').insert({
          'user_id': user.id,
          'player_name': user.email?.split('@')[0].toUpperCase() ?? 'PLAYER',
          'score': 0
        });
      }

      if (mounted) {
        setState(() => _alreadySubmitted = true);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Picks Locked In! 🔒", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)), backgroundColor: Colors.cyanAccent));
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
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.cyanAccent)),
      );
    }

    // 🚨 SMART LAYOUT BUILDER 🚨
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 800;

        if (isDesktop) {
          // 💻 PC LAYOUT (Wide Side-by-Side)
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Row(
                children: [
                  Expanded(flex: 4, child: _buildDashboard(true)),
                  Expanded(flex: 6, child: _buildArtworkPane(isMobile: false)),
                ],
              ),
            ),
          );
        } else {
          // 📱 MOBILE LAYOUT (40/60 Vertical Split)
          return Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              children: [
                // TOP 40%: The Cinematic Viewport
                Expanded(
                  flex: 4,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildArtworkPane(isMobile: true),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black.withOpacity(0.4), Colors.black],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.cyanAccent, size: 20),
                                onPressed: () => Navigator.pop(context),
                                padding: EdgeInsets.zero,
                                alignment: Alignment.topLeft,
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.online_prediction, color: Colors.cyanAccent, size: 24),
                                      SizedBox(width: 8),
                                      Text("GLOBAL NETWORK", style: TextStyle(color: Colors.cyanAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text("PICK 'EM CARD", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // BOTTOM 60%: The Dashboard Data
                Expanded(
                  flex: 6,
                  child: Container(
                    color: Colors.black,
                    width: double.infinity,
                    child: _buildDashboard(false),
                  ),
                ),
              ],
            ),
          );
        }
      }
    );
  }

  // =====================================================================
  // --- THE DASHBOARD (Shared by Desktop & Mobile)
  // =====================================================================
  Widget _buildDashboard(bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: isDesktop ? const Color(0xFF121212) : Colors.black,
        border: isDesktop ? const Border(right: BorderSide(color: Colors.white10, width: 2)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER (PC ONLY - Mobile uses the image overlay) ---
          if (isDesktop)
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.cyanAccent, size: 20), onPressed: () => Navigator.pop(context)),
                    const SizedBox(width: 8),
                    const Text("PICK 'EM CARD", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5)),
                  ],
                ),
              ),
            ),
            
          if (isDesktop) Container(height: 1, color: Colors.white10), 

          // --- CONTENT ---
          Expanded(
            child: _activeEvent == null
                ? _buildEmptyState()
                : Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white10, width: 1))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("UPCOMING EVENT", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                            const SizedBox(height: 4),
                            Text(_activeEvent!['event_name'].toString().toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.timer, color: Colors.redAccent, size: 16),
                                const SizedBox(width: 8),
                                Text("LOCKS ON: ${_activeEvent!['event_date'].toString().split('T')[0]}", style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.0)),
                              ],
                            ),
                            if (_alreadySubmitted) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(color: Colors.cyanAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.cyanAccent)),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.lock, color: Colors.cyanAccent, size: 16),
                                    SizedBox(width: 8),
                                    Text("YOUR PICKS ARE LOCKED IN", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1.0)),
                                  ],
                                ),
                              )
                            ]
                          ],
                        ),
                      ),

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
                                border: Border.all(color: _alreadySubmitted ? Colors.white10 : Colors.white24, width: 1),
                                boxShadow: _alreadySubmitted ? [] : [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10)],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.cyanAccent.withOpacity(0.05),
                                      border: const Border(bottom: BorderSide(color: Colors.white10, width: 1)),
                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7))
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: Text(q['question_text'].toString().toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.0))),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)),
                                          child: Text("${q['points']} PTS", style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 10)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: TextField(
                                      controller: _answers[qId],
                                      enabled: !_alreadySubmitted,
                                      style: TextStyle(color: _alreadySubmitted ? Colors.white54 : Colors.white, fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        hintText: "Who wins?",
                                        hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
                                        filled: true,
                                        fillColor: const Color(0xFF121212),
                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.white10)),
                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.cyanAccent)),
                                        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
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

                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Color(0xFF121212),
                          border: Border(top: BorderSide(color: Colors.white10, width: 1)),
                        ),
                        child: Column(
                          children: [
                            if (!_alreadySubmitted) ...[
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.cyanAccent, 
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    elevation: 0,
                                  ),
                                  icon: const Icon(Icons.check_circle_outline),
                                  label: const Text("LOCK IN PICKS", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                                  onPressed: _submitPicks,
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                            
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.leaderboard, color: Colors.purpleAccent),
                                label: const Text("VIEW GLOBAL LEADERBOARD", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1.5, color: Colors.purpleAccent)),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.purpleAccent, width: 2),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () {
                                  HapticFeedback.selectionClick();
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardScreen()));
                                },
                              ),
                            ),
                          ],
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
          const Icon(Icons.event_busy, color: Colors.white24, size: 60),
          const SizedBox(height: 20),
          const Text("NO ACTIVE EVENTS", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          Text("THE COMMISSIONER HAS NOT POSTED A CARD YET.", textAlign: TextAlign.center, style: TextStyle(color: Colors.cyanAccent.withOpacity(0.8), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
        ],
      ),
    );
  }

  // =====================================================================
  // --- ARTWORK PANE (Shared)
  // =====================================================================
  Widget _buildArtworkPane({required bool isMobile}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/images/pickem_bg.png", 
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (c, e, s) => Image.asset("assets/images/office_background.png", fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(color: const Color(0xFF0A0A0A))),
        ),
        if (!isMobile)
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

        // --- THE GLOBAL WATERMARK ---
        TVWatermark(isMobile: isMobile),
      ],
    );
  }
}