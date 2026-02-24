import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'draft_screen.dart';

class PlayerJoinScreen extends StatefulWidget {
  const PlayerJoinScreen({super.key});

  @override
  State<PlayerJoinScreen> createState() => _PlayerJoinScreenState();
}

class _PlayerJoinScreenState extends State<PlayerJoinScreen> {
  final _supabase = Supabase.instance.client;
  final _codeController = TextEditingController();
  bool _isLoading = false;

  Future _joinLeague() async {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter an invite code!"), backgroundColor: Colors.red));
      return;
    }

    setState(() => _isLoading = true);

    // FIX: We declare 'league' out here so BOTH the try and catch blocks can see it!
    Map<String, dynamic>? league;

    try {
      // 1. Search the cloud for the League
      league = await _supabase.from('leagues').select().eq('invite_code', code).maybeSingle();

      if (league == null) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("League not found. Check the code!"), backgroundColor: Colors.red));
        setState(() => _isLoading = false);
        return;
      }

      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception("Not logged in");

      // 2. Add the player to the League Members table
      await _supabase.from('league_members').insert({
        'league_id': league['id'],
        'user_id': user.id,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Access Granted! 🏆"), backgroundColor: Colors.green));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DraftScreen(leagueId: league!['id'])));
      }
    } catch (e) {
      debugPrint("Join Error: $e");
      if (mounted) {
         if (e.toString().contains('duplicate key')) {
           // They are already in the league, let them into the draft room!
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DraftScreen(leagueId: league!['id'])));
         } else {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
         }
      }
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
        title: const Text("JOIN LEAGUE", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.group_add_rounded, size: 80, color: Colors.cyanAccent),
            const SizedBox(height: 24),
            const Text("ENTER INVITE CODE", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
            const SizedBox(height: 16),
            TextField(
              controller: _codeController,
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2.0),
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: "e.g. ALPHA_12345",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 32),
            _isLoading
              ? const CircularProgressIndicator(color: Colors.cyanAccent)
              : ElevatedButton.icon(
                  icon: const Icon(Icons.login, color: Colors.black),
                  label: const Text("JOIN NOW", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _joinLeague,
                ),
          ],
        ),
      ),
    );
  }
}
