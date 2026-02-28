import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../logic/roster_importer.dart';
import '../modes/promoter/promoter_home_screen.dart'; // To route them to the game after download

class CommunityRostersScreen extends ConsumerStatefulWidget {
  const CommunityRostersScreen({super.key});

  @override
  ConsumerState<CommunityRostersScreen> createState() => _CommunityRostersScreenState();
}

class _CommunityRostersScreenState extends ConsumerState<CommunityRostersScreen> {
  final _supabase = Supabase.instance.client;
  List<dynamic> _rosters = [];
  bool _isLoading = true;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _fetchRosters();
  }

  Future<void> _fetchRosters() async {
    try {
      // Order by most downloaded first!
      final data = await _supabase.from('community_rosters').select().order('downloads', ascending: false);
      if (mounted) {
        setState(() {
          _rosters = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching rosters: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _downloadAndInject(Map<String, dynamic> rosterData) async {
    HapticFeedback.heavyImpact();
    
    // Safety warning!
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("OVERWRITE SAVE?", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
        content: Text("Downloading '${rosterData['mod_name']}' will permanently wipe your current universe and start a new career. Are you sure?", style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("CANCEL", style: TextStyle(color: Colors.white54))),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("DOWNLOAD & PLAY", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold))),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isDownloading = true);

    try {
      // 1. Inject the JSON into the game
      final importer = RosterImporter(ref, context);
      await importer.importFromCloud(rosterData['json_data']);

      // 2. Increment the download counter in the cloud!
      int newCount = (rosterData['downloads'] ?? 0) + 1;
      await _supabase.from('community_rosters').update({'downloads': newCount}).eq('id', rosterData['id']);

      // 3. Kick them straight into the game to play!
      if (mounted) {
        Navigator.pop(context); // Close the hub
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PromoterHomeScreen()));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
        setState(() => _isDownloading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 10,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.cyanAccent), onPressed: () => Navigator.pop(context)),
        title: const Text("COMMUNITY MODS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
        centerTitle: true,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.cyanAccent))
        : _rosters.isEmpty
            ? _buildEmptyState()
            : Stack(
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _rosters.length,
                    itemBuilder: (context, index) {
                      final r = _rosters[index];
                      return _buildModCard(r);
                    },
                  ),
                  if (_isDownloading)
                    Container(
                      color: Colors.black.withOpacity(0.8),
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(color: Colors.cyanAccent),
                            SizedBox(height: 16),
                            Text("DOWNLOADING UNIVERSE...", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off, size: 80, color: Colors.white24),
          SizedBox(height: 16),
          Text("NO MODS UPLOADED YET", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        ],
      ),
    );
  }

  Widget _buildModCard(Map<String, dynamic> mod) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(mod['mod_name'].toString().toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white24)),
                  child: Row(
                    children: [
                      const Icon(Icons.download_rounded, color: Colors.cyanAccent, size: 14),
                      const SizedBox(width: 4),
                      Text("${mod['downloads']}", style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text("Created by: ${mod['creator_name']}", style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(mod['description'], style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.cloud_download, size: 20),
                label: const Text("DOWNLOAD & PLAY", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                onPressed: () => _downloadAndInject(mod),
              ),
            ),
          ],
        ),
      ),
    );
  }
}