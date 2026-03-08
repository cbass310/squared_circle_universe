import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../logic/roster_importer.dart';
// 🛠️ THE FIX: Added '../' so it correctly finds the modes folder!
import '../modes/promoter/promoter_home_screen.dart'; 

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
    
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("OVERWRITE SAVE?", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
        content: Text("Downloading '${rosterData['mod_name']}' will permanently wipe your current universe and start a new career. Are you sure?", style: const TextStyle(color: Colors.white70, height: 1.4)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("CANCEL", style: TextStyle(color: Colors.white54))),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("DOWNLOAD & PLAY", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold))),
        ],
      ),
    );

    if (confirm != true) return;
    setState(() => _isDownloading = true);

    try {
      final importer = RosterImporter(ref, context);
      await importer.importFromCloud(rosterData['json_data']);

      int newCount = (rosterData['downloads'] ?? 0) + 1;
      await _supabase.from('community_rosters').update({'downloads': newCount}).eq('id', rosterData['id']);

      if (mounted) {
        Navigator.pop(context); 
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 600;

        if (isDesktop) {
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
          return Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              children: [
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
                                      Icon(Icons.download, color: Colors.cyanAccent, size: 24),
                                      SizedBox(width: 8),
                                      Text("GLOBAL DATABASE", style: TextStyle(color: Colors.cyanAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text("COMMUNITY MODS", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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

  Widget _buildDashboard(bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: isDesktop ? const Color(0xFF121212) : Colors.black,
        border: isDesktop ? const Border(right: BorderSide(color: Colors.white10, width: 2)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop)
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.cyanAccent, size: 20), onPressed: () => Navigator.pop(context)),
                    const SizedBox(width: 8),
                    const Text("COMMUNITY MODS", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5)),
                  ],
                ),
              ),
            ),
            
          if (isDesktop) Container(height: 1, color: Colors.white10), 

          Expanded(
            child: _isLoading 
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
                          color: Colors.black.withOpacity(0.9),
                          child: const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(color: Colors.cyanAccent),
                                SizedBox(height: 20),
                                Text("DOWNLOADING UNIVERSE...", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
                              ],
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

  Widget _buildArtworkPane({required bool isMobile}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/images/leaderboard_bg.png", 
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
      ],
    );
  }
}