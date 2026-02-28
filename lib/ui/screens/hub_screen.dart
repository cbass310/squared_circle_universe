import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// --- LOGIC IMPORTS ---
import '../../logic/promoter_provider.dart';
import '../../logic/roster_importer.dart';
import '../../logic/game_state_provider.dart'; 

// --- SCREEN IMPORTS ---
import '../modes/promoter/promoter_home_screen.dart';
import 'show_history_screen.dart';
import '../modes/leaderboard/leaderboard_screen.dart';
import '../modes/network/player_pick_sheet_screen.dart'; 
import '../modes/network/commissioner_dashboard_screen.dart';
import 'community_rosters_screen.dart';

// 🚨 NEW WIDGET IMPORT!
import '../components/global_network_button.dart'; 

class HubScreen extends ConsumerStatefulWidget {
  const HubScreen({super.key});

  @override
  ConsumerState<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends ConsumerState<HubScreen> {
  // 🚨 YOUR SECRET ADMIN LIST 🚨
  final List<String> adminEmails = const [
    'test@test.com', 
    'your_real_email@gmail.com', 
  ];

  @override
  Widget build(BuildContext context) {
    final rosterState = ref.watch(rosterProvider);
    final bool hasSaveFile = rosterState.roster.isNotEmpty;
    final bool isDesktop = MediaQuery.of(context).size.width > 800;
    
    final session = Supabase.instance.client.auth.currentSession;
    final user = session?.user;
    final bool isLoggedIn = user != null;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. THE MAIN LAYOUT
          isDesktop 
            ? Row(children: [_buildMenuColumn(hasSaveFile, isDesktop, isLoggedIn, user), _buildHeroImage(true)])
            : Stack(
                children: [
                  _buildHeroImage(false),
                  Container(color: Colors.black.withOpacity(0.7)), 
                  _buildMenuColumn(hasSaveFile, false, isLoggedIn, user),
                ],
              ),
              
          // 2. 🚨 THE NEW UNIVERSAL GLOBAL COMPONENT!
          Positioned(
            top: isDesktop ? 40 : 50, 
            right: isDesktop ? 40 : 20,
            child: const GlobalNetworkButton(), // It is now just one line of code!
          ),
        ],
      ),
    );
  }

  // ====================================================================
  // WIDGET: THE MAIN MENU
  // ====================================================================
  Widget _buildMenuColumn(bool hasSaveFile, bool isDesktop, bool isLoggedIn, User? user) {
    final rosterState = ref.watch(rosterProvider);

    return Expanded(
      flex: isDesktop ? 4 : 1, 
      child: Container(
        decoration: BoxDecoration(
          color: isDesktop ? Colors.black : Colors.transparent,
          border: isDesktop ? const Border(right: BorderSide(color: Colors.white10)) : null,
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32.0 : 24.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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

                const Text("SELECT MODE", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                const SizedBox(height: 20),

                // 1. PROMOTER MODE
                _buildMenuButton(
                  icon: Icons.business_center_rounded,
                  title: "PROMOTER MODE",
                  subtitle: hasSaveFile ? "Continue Year ${rosterState.titleHistory.isEmpty ? 1 : 'Current'}" : "Build your empire. Manage your roster.",
                  baseColor: Colors.amber,
                  onTap: () {
                    _showCareerOptions(hasSaveFile);
                  },
                ),
                const SizedBox(height: 16),

                // 2. GLOBAL NETWORK
                _buildMenuButton(
                  icon: Icons.public,
                  title: "GLOBAL NETWORK",
                  subtitle: "Predict real-world PPVs & earn rewards.",
                  baseColor: Colors.cyanAccent,
                  onTap: () {
                    if (isLoggedIn) {
                      if (adminEmails.contains(user!.email)) {
                        _showNetworkOptions(); 
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerPickSheetScreen(leagueId: 'global')));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Connect your profile in the top right to access the network!", style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.cyanAccent));
                      // Note: They have to click the top right button to auth now!
                    }
                  },
                ),
                const SizedBox(height: 16),

                // 3. GLOBAL LEADERBOARDS
                _buildMenuButton(
                  icon: Icons.leaderboard_rounded,
                  title: "HALL OF FAME",
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

  Widget _buildMenuButton({required IconData icon, required String title, required String subtitle, required Color baseColor, required VoidCallback onTap}) {
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

  // ====================================================================
  // DIALOGS
  // ====================================================================

  void _showNetworkOptions() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF202020),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("ADMIN CONTROL", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildDialogButton("PLAY AS USER", Icons.sports_esports, Colors.cyanAccent, () {
                Navigator.pop(ctx);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerPickSheetScreen(leagueId: 'global')));
              }),
            ),
            _buildDialogButton("COMMISSIONER DESK", Icons.admin_panel_settings, Colors.purpleAccent, () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CommissionerDashboardScreen(leagueId: 'global')));
            }),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text("CANCEL", style: TextStyle(color: Colors.white.withOpacity(0.5))))],
      ),
    );
  }

  void _showCareerOptions(bool hasSaveFile) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF202020),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("CAREER OPTIONS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasSaveFile) Padding(padding: const EdgeInsets.only(bottom: 12.0), child: _buildDialogButton("CONTINUE CAREER", Icons.play_arrow_rounded, Colors.greenAccent, () { Navigator.pop(ctx); Navigator.push(context, MaterialPageRoute(builder: (_) => const PromoterHomeScreen())); })),
            if (hasSaveFile) Padding(padding: const EdgeInsets.only(bottom: 12.0), child: _buildDialogButton("VIEW ARCHIVES", Icons.history_rounded, Colors.amberAccent, () { Navigator.pop(ctx); Navigator.push(context, MaterialPageRoute(builder: (_) => const ShowHistoryScreen())); })),
            Padding(padding: const EdgeInsets.only(bottom: 12.0), child: _buildDialogButton("NEW CAREER", Icons.add_circle_outline_rounded, Colors.blueAccent, () { Navigator.pop(ctx); _confirmNewGame(); })),
            
            // ☁️ NEW: THE COMMUNITY CLOUD MOD HUB
            Padding(padding: const EdgeInsets.only(bottom: 12.0), child: _buildDialogButton("COMMUNITY MODS", Icons.cloud_download, Colors.cyanAccent, () { Navigator.pop(ctx); Navigator.push(context, MaterialPageRoute(builder: (_) => const CommunityRostersScreen())); })),
            
            // 📂 ORIGINAL: LOCAL FILE IMPORT
            _buildDialogButton("IMPORT LOCAL FILE", Icons.folder, Colors.purpleAccent, () async { Navigator.pop(ctx); final importer = RosterImporter(ref, context); await importer.pickAndImport(); }),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text("CANCEL", style: TextStyle(color: Colors.white.withOpacity(0.5))))],
      ),
    );
  }

  void _confirmNewGame() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("Start New Career?", style: TextStyle(color: Colors.white)),
        content: const Text("This will delete your current progress and generate a new roster.\n\nAre you sure?", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(child: const Text("Cancel"), onPressed: () => Navigator.pop(ctx)),
          TextButton(
            child: const Text("START NEW GAME", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)), 
            onPressed: () async { 
              Navigator.pop(ctx); 
              await ref.read(rosterProvider.notifier).factoryReset(); 
              await ref.read(gameProvider.notifier).resetGame(); 
              
              if (context.mounted) { 
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PromoterHomeScreen())); 
              } 
            }
          ),
        ],
      ),
    );
  }

  Widget _buildDialogButton(String text, IconData icon, Color baseColor, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(colors: [const Color(0xFF1A1A1A), baseColor.withOpacity(0.1)], begin: Alignment.centerLeft, end: Alignment.centerRight),
        border: Border.all(color: baseColor.withOpacity(0.4), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              children: [
                Icon(icon, color: baseColor, size: 20),
                const SizedBox(width: 16),
                Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.0))),
                Icon(Icons.chevron_right_rounded, color: baseColor.withOpacity(0.5), size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}