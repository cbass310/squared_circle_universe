import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// --- LOGIC IMPORTS ---
import '../../logic/promoter_provider.dart';
import '../../logic/roster_importer.dart';
import '../../logic/csv_import_service.dart';

// --- SCREEN IMPORTS ---
import '../modes/promoter/promoter_home_screen.dart';
import 'show_history_screen.dart';
import '../modes/leaderboard/leaderboard_screen.dart';
import '../modes/network/global_network_auth_screen.dart';
import '../modes/network/player_join_screen.dart';
import 'promoter_auth_gate_screen.dart';
import '../modes/network/commissioner_dashboard_screen.dart';

class HubScreen extends ConsumerWidget {
  const HubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rosterState = ref.watch(rosterProvider);
    bool hasSaveFile = rosterState.roster.isNotEmpty;
    
    // 📱 RESPONSIVE CHECK: Is this a narrow phone screen or a wide tablet/desktop?
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: Colors.black,
      body: isDesktop 
          ? Row(children: [_buildMenuColumn(context, ref, hasSaveFile, true), _buildHeroImage(true)])
          : Stack(
              children: [
                _buildHeroImage(false),
                Container(color: Colors.black.withOpacity(0.7)), // Darken background for readability on mobile
                _buildMenuColumn(context, ref, hasSaveFile, false),
              ],
            ),
    );
  }

  // ------------------------------------------------
  // WIDGET: THE MAIN MENU
  // ------------------------------------------------
  Widget _buildMenuColumn(BuildContext context, WidgetRef ref, bool hasSaveFile, bool isDesktop) {
    final rosterState = ref.watch(rosterProvider);

    return Expanded(
      flex: isDesktop ? 4 : 1, // Take up 40% on desktop, 100% on mobile
      child: Container(
        decoration: BoxDecoration(
          color: isDesktop ? Colors.black : Colors.transparent,
          border: isDesktop ? const Border(right: BorderSide(color: Colors.white10)) : null,
        ),
        // 🛠️ THE PIXEL OVERFLOW FIX: Center + SingleChildScrollView
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32.0 : 24.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // GAME LOGO
                SafeArea(
                  child: Center(
                    child: Image.asset(
                      "assets/images/imagelogo.png", 
                      height: isDesktop ? 120 : 100,
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => const Icon(Icons.sports_mma, size: 80, color: Colors.amber),
                    ),
                  ),
                ),
                SizedBox(height: isDesktop ? 50 : 30),

                const Text(
                  "SELECT MODE",
                  style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0),
                ),
                const SizedBox(height: 20),

                // 1. PROMOTER MODE
                _buildMenuButton(
                  context,
                  icon: Icons.business_center_rounded,
                  title: "PROMOTER MODE",
                  subtitle: hasSaveFile ? "Continue Year ${rosterState.titleHistory.isEmpty ? 1 : 'Current'}" : "Build your empire. Manage your roster.",
                  baseColor: Colors.amber,
                  onTap: () {
                    final user = Supabase.instance.client.auth.currentUser;
                    if (user != null) {
                      _showCareerOptions(context, ref, hasSaveFile);
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PromoterAuthGateScreen()));
                    }
                  },
                ),
                const SizedBox(height: 16),

                // 2. ONLINE FANTASY LEAGUES (Combined Pick 'Em & Commissioner!)
                _buildMenuButton(
                  context,
                  icon: Icons.public,
                  title: "ONLINE FANTASY LEAGUES",
                  subtitle: "Host or join competitive Pick 'Em leagues.",
                  baseColor: Colors.blueAccent,
                  onTap: () {
                    final user = Supabase.instance.client.auth.currentUser;
                    if (user != null) {
                      _showFantasyOptions(context); 
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const GlobalNetworkAuthScreen()));
                    }
                  },
                ),
                const SizedBox(height: 16),

                // 3. GLOBAL LEADERBOARDS
                _buildMenuButton(
                  context,
                  icon: Icons.leaderboard_rounded,
                  title: "GLOBAL LEADERBOARDS",
                  subtitle: "See where you rank in the world.",
                  baseColor: Colors.purpleAccent,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardScreen())),
                ),

                const SizedBox(height: 40),
                const Center(child: Text("v1.0.0 RELEASE", style: TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 2.0))),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------
  // WIDGET: THE HERO IMAGE
  // ------------------------------------------------
  Widget _buildHeroImage(bool isDesktop) {
    return Expanded(
      flex: isDesktop ? 6 : 1,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/imagepromoter.png",
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(color: const Color(0xFF101010)),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: isDesktop ? Alignment.centerLeft : Alignment.topCenter,
                end: isDesktop ? Alignment.centerRight : Alignment.bottomCenter,
                colors: [Colors.black, Colors.black.withOpacity(0.4), Colors.transparent],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),
          if (isDesktop) 
            Positioned(
              bottom: 60,
              right: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("SQUARED CIRCLE", style: TextStyle(fontSize: 56, fontWeight: FontWeight.w900, color: Colors.white.withOpacity(0.95), letterSpacing: 1.5, height: 0.9, shadows: [Shadow(color: Colors.black.withOpacity(0.8), blurRadius: 20, offset: const Offset(0, 5))])),
                  Text("TYCOON", style: TextStyle(fontSize: 56, fontWeight: FontWeight.w900, color: Colors.amber.withOpacity(0.95), letterSpacing: 1.5, height: 0.9, shadows: [Shadow(color: Colors.black.withOpacity(0.8), blurRadius: 20, offset: const Offset(0, 5))])),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ------------------------------------------------
  // WIDGET: POLISHED PREMIUM BUTTON
  // ------------------------------------------------
  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color baseColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [const Color(0xFF1A1A1A), baseColor.withOpacity(0.05)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        border: Border.all(color: baseColor.withOpacity(0.3), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          hoverColor: baseColor.withOpacity(0.1),
          splashColor: baseColor.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: baseColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: baseColor.withOpacity(0.2), blurRadius: 10)],
                  ),
                  child: Icon(icon, color: baseColor, size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: baseColor.withOpacity(0.5), size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------
  // DIALOGS & LOGIC
  // ------------------------------------------------

  // --- NEW FANTASY OPTIONS DIALOG ---
  void _showFantasyOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF202020),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("FANTASY LEAGUES", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildDialogButton(context, "JOIN A LEAGUE", Icons.login_rounded, Colors.blueAccent, () {
                Navigator.pop(ctx);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerJoinScreen()));
              }),
            ),
            _buildDialogButton(context, "HOST A LEAGUE", Icons.gavel_rounded, Colors.greenAccent, () async {
              Navigator.pop(ctx);
              _createNewLeague(context);
            }),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text("CANCEL", style: TextStyle(color: Colors.white.withOpacity(0.5))))],
      ),
    );
  }

  // --- EXTRACTED COMMISSIONER LOGIC ---
  Future<void> _createNewLeague(BuildContext context) async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("🚨 Access Denied: Please sign in!"), backgroundColor: Colors.red));
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Building League Room... Please wait."), backgroundColor: Colors.blue));

      final leagueResponse = await supabase.from('leagues').insert({
        'commissioner_id': user.id,
        'name': 'Squared Circle League',
        'invite_code': 'SCL_${DateTime.now().millisecondsSinceEpoch}',
        'max_players': 12
      }).select('id').single();

      final newLeagueId = leagueResponse['id'];
      await CsvImportService.importRosterCSV(newLeagueId);

      if (context.mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => CommissionerDashboardScreen(leagueId: newLeagueId)));
      }
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("🚨 Error: $e"), backgroundColor: Colors.red));
    }
  }

  // --- CAREER OPTIONS & CONFIRM RESET DIALOGS ---
  void _showCareerOptions(BuildContext context, WidgetRef ref, bool hasSaveFile) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF202020),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("CAREER OPTIONS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasSaveFile) Padding(padding: const EdgeInsets.only(bottom: 12.0), child: _buildDialogButton(context, "CONTINUE CAREER", Icons.play_arrow_rounded, Colors.greenAccent, () { Navigator.pop(ctx); Navigator.push(context, MaterialPageRoute(builder: (_) => const PromoterHomeScreen())); })),
            if (hasSaveFile) Padding(padding: const EdgeInsets.only(bottom: 12.0), child: _buildDialogButton(context, "VIEW ARCHIVES", Icons.history_rounded, Colors.amberAccent, () { Navigator.pop(ctx); Navigator.push(context, MaterialPageRoute(builder: (_) => const ShowHistoryScreen())); })),
            Padding(padding: const EdgeInsets.only(bottom: 12.0), child: _buildDialogButton(context, "NEW CAREER", Icons.add_circle_outline_rounded, Colors.blueAccent, () { Navigator.pop(ctx); _confirmNewGame(context, ref); })),
            _buildDialogButton(context, "IMPORT ROSTER", Icons.file_upload_rounded, Colors.purpleAccent, () async { Navigator.pop(ctx); final importer = RosterImporter(ref, context); await importer.pickAndImport(); }),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text("CANCEL", style: TextStyle(color: Colors.white.withOpacity(0.5))))],
      ),
    );
  }

  void _confirmNewGame(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("Start New Career?", style: TextStyle(color: Colors.white)),
        content: const Text("This will delete your current progress and generate a new roster.\n\nAre you sure?", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(child: const Text("Cancel"), onPressed: () => Navigator.pop(ctx)),
          TextButton(child: const Text("START NEW GAME", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)), onPressed: () async { Navigator.pop(ctx); await ref.read(rosterProvider.notifier).factoryReset(); if (context.mounted) { Navigator.push(context, MaterialPageRoute(builder: (_) => const PromoterHomeScreen())); } }),
        ],
      ),
    );
  }

  Widget _buildDialogButton(BuildContext context, String text, IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF303030), foregroundColor: color, padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20), alignment: Alignment.centerLeft, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0),
        icon: Icon(icon, size: 24),
        label: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.0)),
        onPressed: onPressed,
      ),
    );
  }
}