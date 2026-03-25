import 'package:easy_localization/easy_localization.dart';
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
import '../modes/promoter/welcome_letter_screen.dart'; 
import 'show_history_screen.dart';
import '../modes/leaderboard/leaderboard_screen.dart';
import '../modes/network/player_pick_sheet_screen.dart'; 
import '../modes/network/commissioner_dashboard_screen.dart';
import 'community_rosters_screen.dart';
import 'settings_screen.dart'; // 🚨 NEW IMPORT ADDED HERE!

// --- WIDGET IMPORTS ---
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
    final gameState = ref.watch(gameProvider);
    
    // A save file only exists if the player has advanced past week 1, 
    // moved to a new year, or has generated financial ledger history.
    final bool hasSaveFile = gameState.week > 1 || gameState.year > 1 || gameState.ledger.isNotEmpty;
    
    final session = Supabase.instance.client.auth.currentSession;
    final user = session?.user;
    final bool isLoggedIn = user != null;

    // LAYOUT BUILDER ADAPTS TO PHONE VS TABLET
    return LayoutBuilder(
      builder: (context, constraints) {
        // 600 Breakpoint ensures Tablets get the Desktop Menu!
        final bool isDesktop = constraints.maxWidth > 600;

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // 1. DYNAMIC LAYOUT
              isDesktop 
                  ? Row(children: [_buildDesktopMenu(hasSaveFile, isLoggedIn, user, gameState), _buildHeroImage(true)])
                  : _buildMobileLayout(hasSaveFile, isLoggedIn, user, gameState),
                  
              // 2. THE GLOBAL NETWORK PROFILE BUTTON
              Positioned(
                top: isDesktop ? 40 : 50, 
                right: isDesktop ? 40 : 20,
                child: const GlobalNetworkButton(), 
              ),
            ],
          ),
        );
      }
    );
  }

  // ====================================================================
  // MOBILE LAYOUT
  // ====================================================================
  Widget _buildMobileLayout(bool hasSaveFile, bool isLoggedIn, User? user, dynamic gameState) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/images/imagepromoter.png",
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(color: const Color(0xFF101010)),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.95)],
                stops: const [0.0, 0.8],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildMenuButtons(hasSaveFile, isLoggedIn, user, false, gameState),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ====================================================================
  // DESKTOP/TABLET LAYOUT
  // ====================================================================
  Widget _buildDesktopMenu(bool hasSaveFile, bool isLoggedIn, User? user, dynamic gameState) {
    return Expanded(
      flex: 4, 
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          border: Border(right: BorderSide(color: Colors.white10)),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildMenuButtons(hasSaveFile, isLoggedIn, user, true, gameState),
            ),
          ),
        ),
      ),
    );
  }

  // ====================================================================
  // THE REUSABLE MENU ITEMS
  // ====================================================================
  List<Widget> _buildMenuButtons(bool hasSaveFile, bool isLoggedIn, User? user, bool isDesktop, dynamic gameState) {
    return [
      Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 40,
                spreadRadius: -10,
                offset: const Offset(0, 10),
              )
            ]
          ),
          child: Image.asset(
            "assets/images/imagelogo.png", 
            height: isDesktop ? 180 : 120, 
            fit: BoxFit.contain,
            errorBuilder: (c, e, s) => Icon(Icons.sports_mma, size: isDesktop ? 100 : 80, color: Colors.amber),
          ),
        ),
      ),
      SizedBox(height: isDesktop ? 25 : 15), 

      const Text("SELECT MODE", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
      const SizedBox(height: 20),

      // 1. PROMOTER MODE
      _buildMenuButton(
        icon: Icons.business_center_rounded,
        title: "PROMOTER MODE",
        subtitle: hasSaveFile ? "Continue Year ${gameState.year}" : "Build your empire. Manage your roster.",
        baseColor: Colors.amber,
        onTap: () => _showCareerOptions(hasSaveFile),
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
      const SizedBox(height: 16),

      // 4. SETTINGS & LOCALIZATION 
      _buildMenuButton(
        icon: Icons.settings,
        title: "SETTINGS",
        subtitle: "Preferences.",
        baseColor: Colors.grey,
        // 🚨 THIS NOW ROUTES TO YOUR FULL SETTINGS SCREEN 🚨
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
        },
      ),

      const SizedBox(height: 40),
      const Center(child: Text("v1.0.0 RELEASE", style: TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 2.0))),
    ];
  }

  // ====================================================================
  // WIDGET: RIGHT HERO IMAGE 
  // ====================================================================
  Widget _buildHeroImage(bool isDesktop) {
    return Expanded(
      flex: 6,
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
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.black, Colors.black.withOpacity(0.4), Colors.transparent],
                stops: const [0.0, 0.4, 1.0],
              ),
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
  // THE BOTTOM SHEET ENGINE
  // ====================================================================
  void _openBottomSheet(BuildContext context, String title, List<Widget> children, Color accentColor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E1E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [BoxShadow(color: Colors.black87, blurRadius: 15, spreadRadius: 5)],
          ),
          child: SafeArea( 
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white12, width: 1))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: accentColor, letterSpacing: 1.2)),
                      IconButton(icon: const Icon(Icons.close, color: Colors.white54), onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(children: children),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showNetworkOptions() {
    _openBottomSheet(context, "ADMIN CONTROL", [
      _buildBottomSheetButton("PLAY AS USER", Icons.sports_esports, Colors.cyanAccent, () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerPickSheetScreen(leagueId: 'global')));
      }),
      const SizedBox(height: 12),
      _buildBottomSheetButton("COMMISSIONER DESK", Icons.admin_panel_settings, Colors.purpleAccent, () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CommissionerDashboardScreen(leagueId: 'global')));
      }),
    ], Colors.redAccent);
  }

  void _showCareerOptions(bool hasSaveFile) {
    List<Widget> options = [];
    
    if (hasSaveFile) {
      options.add(_buildBottomSheetButton("CONTINUE CAREER", Icons.play_arrow_rounded, Colors.greenAccent, () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const PromoterHomeScreen())); }));
      options.add(const SizedBox(height: 12));
      options.add(_buildBottomSheetButton("VIEW ARCHIVES", Icons.history_rounded, Colors.amberAccent, () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const ShowHistoryScreen())); }));
      options.add(const SizedBox(height: 12));
    }
    
    options.add(_buildBottomSheetButton("NEW CAREER", Icons.add_circle_outline_rounded, Colors.blueAccent, () { 
      Navigator.pop(context); 
      if (hasSaveFile) {
        _confirmNewGame(); 
      } else {
        _startFreshGame();
      }
    }));
    
    options.add(const SizedBox(height: 12));
    options.add(_buildBottomSheetButton("COMMUNITY MODS", Icons.cloud_download, Colors.cyanAccent, () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const CommunityRostersScreen())); }));
    options.add(const SizedBox(height: 12));
    options.add(_buildBottomSheetButton("IMPORT LOCAL FILE", Icons.folder, Colors.purpleAccent, () async { Navigator.pop(context); final importer = RosterImporter(ref, context); await importer.pickAndImport(); }));

    _openBottomSheet(context, "CAREER OPTIONS", options, Colors.white);
  }

  Widget _buildBottomSheetButton(String text, IconData icon, Color baseColor, VoidCallback onTap) {
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

  Future<void> _startFreshGame() async {
    HapticFeedback.heavyImpact();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator(color: Colors.amber)),
    );

    await ref.read(gameProvider.notifier).resetGame(); 
    await ref.read(rosterProvider.notifier).factoryReset(); 
    
    if (context.mounted) { 
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (_) => const WelcomeLetterScreen())); 
    } 
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
            child: const Text("START NEW GAME", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)), 
            onPressed: () { 
              Navigator.pop(ctx); 
              _startFreshGame(); 
            }
          ),
        ],
      ),
    );
  }
}