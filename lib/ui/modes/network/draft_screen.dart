import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DraftScreen extends StatefulWidget {
  final String leagueId;
  const DraftScreen({super.key, required this.leagueId});

  @override
  State<DraftScreen> createState() => _DraftScreenState();
}

class _DraftScreenState extends State<DraftScreen> {
  final _supabase = Supabase.instance.client;
  List _availableRoster = [];
  final List _myStable = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRoster();
  }

  Future _fetchRoster() async {
    try {
      final data = await _supabase.from('wrestlers').select().eq('league_id', widget.leagueId).order('popularity', ascending: false);
      if (mounted) {
        setState(() {
          _availableRoster = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching roster: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _draftWrestler(dynamic wrestler) {
    if (_myStable.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Your stable is full! (Max 5)"), backgroundColor: Colors.red));
      return;
    }
    if (_myStable.contains(wrestler)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You already drafted this superstar!"), backgroundColor: Colors.red));
      return;
    }
    setState(() => _myStable.add(wrestler));
  }

  void _removeWrestler(dynamic wrestler) {
    setState(() => _myStable.remove(wrestler));
  }

  Future _confirmStable() async {
    if (_myStable.length != 5) return;
    setState(() => _isLoading = true);
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception("Not logged in");
      final List<Map<String, dynamic>> inserts = _myStable.map((w) => {
        'league_id': widget.leagueId,
        'user_id': user.id,
        'wrestler_name': w['name'],
      }).toList();
      await _supabase.from('player_stables').insert(inserts);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Stable Locked In! 🏆"), backgroundColor: Colors.green));
        Navigator.pop(context); // Go back to Join Screen
        Navigator.pop(context); // Go back to Hub Screen
      }
    } catch (e) {
      debugPrint("Error saving stable: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
        setState(() => _isLoading = false);
      }
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
        title: const Text("DRAFT ROOM", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.cyanAccent))
          : Column(
              children: [
                // TOP HALF: Available Free Agents
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text("FREE AGENTS", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                        ),
                        Expanded(
                          child: ListView.separated(
                            itemCount: _availableRoster.length,
                            separatorBuilder: (_, __) => const Divider(color: Colors.white10, height: 1),
                            itemBuilder: (context, index) {
                              final w = _availableRoster[index];
                              final isDrafted = _myStable.contains(w);
                              return ListTile(
                                title: Text(w['name'], style: TextStyle(color: isDrafted ? Colors.white38 : Colors.white, fontWeight: FontWeight.bold)),
                                subtitle: Text("Pop: ${w['popularity']} • ${w['faction'] ?? 'Indy'}", style: TextStyle(color: isDrafted ? Colors.white24 : Colors.white70, fontSize: 12)),
                                trailing: isDrafted
                                    ? const Icon(Icons.check_circle, color: Colors.green)
                                    : ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent, foregroundColor: Colors.black),
                                        onPressed: () => _draftWrestler(w),
                                        child: const Text("DRAFT", style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // BOTTOM HALF: My Stable
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Colors.black, border: Border(top: BorderSide(color: Colors.cyanAccent, width: 2))),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Text("MY STABLE (${_myStable.length}/5)", style: const TextStyle(color: Colors.cyanAccent, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              if (index < _myStable.length) {
                                final w = _myStable[index];
                                return Container(
                                  width: 100,
                                  margin: const EdgeInsets.only(right: 8, bottom: 16),
                                  decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.cyanAccent.withOpacity(0.5))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.person, color: Colors.cyanAccent, size: 32),
                                      const SizedBox(height: 8),
                                      Text(w['name'], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                                      IconButton(icon: const Icon(Icons.remove_circle, color: Colors.redAccent, size: 20), onPressed: () => _removeWrestler(w)),
                                    ],
                                  ),
                                );
                              } else {
                                return Container(
                                  width: 100,
                                  margin: const EdgeInsets.only(right: 8, bottom: 16),
                                  decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10, style: BorderStyle.solid)),
                                  child: const Center(child: Icon(Icons.add, color: Colors.white24, size: 32)),
                                );
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.lock, color: Colors.black),
                            label: const Text("CONFIRM STABLE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.5)),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, minimumSize: const Size(double.infinity, 50)),
                            onPressed: _myStable.length == 5 ? _confirmStable : null,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
