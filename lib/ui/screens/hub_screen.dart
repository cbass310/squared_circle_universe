import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../modes/promoter/promoter_home_screen.dart'; // Dashboard
import 'show_history_screen.dart'; // History
import '../../logic/promoter_provider.dart'; // Logic
import '../../logic/roster_importer.dart'; // Importer

// IMPORT THE NEW LEADERBOARD SCREEN
import '../modes/leaderboard/leaderboard_screen.dart';
import '../modes/network/global_network_auth_screen.dart';
import '../modes/network/player_join_screen.dart';
import 'promoter_auth_gate_screen.dart';
import '../modes/network/commissioner_dashboard_screen.dart'; 

// --- THE GREAT PIVOT IMPORTS ---
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../logic/csv_import_service.dart';

class HubScreen extends ConsumerWidget {
  const HubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Check for Save File
    final rosterState = ref.watch(rosterProvider);
    bool hasSaveFile = rosterState.roster.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          // ------------------------------------------------
          // LEFT COLUMN: MENU & LOGO (40%)
          // ------------------------------------------------
          Expanded(
            flex: 4,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                border: Border(right: BorderSide(color: Colors.white10)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
                // 🚀 THE FIX: SingleChildScrollView destroys the Yellow Tape!
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // GAME LOGO
                      Center(
                        child: Image.asset(
                          "assets/images/imagelogo.png", 
                          height: 140,
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => const Icon(Icons.sports_mma, size: 80, color: Colors.amber),
                        ),
                      ),
                      const SizedBox(height: 60),

                      // SECTION TITLE
                      const Text(
                        "SELECT MODE",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- MAIN MENU BUTTONS ---

                      // 1. PROMOTER MODE
                      _buildMenuButton(
                        context,
                        icon: Icons.business_center_rounded,
                        title: "PROMOTER MODE",
                        subtitle: hasSaveFile
                            ? "Continue Year ${rosterState.titleHistory.isEmpty ? 1 : 'Current'}"
                            : "Build your empire. Manage your roster.",
                        color: Colors.amber,
                        onTap: () => _showCareerOptions(context, ref, hasSaveFile),
                      ),
                      const SizedBox(height: 16),

                      // 2. LEAGUE PICK 'EM
                      _buildMenuButton(
                        context,
                        icon: Icons.public,
                        title: "LEAGUE PICK 'EM",
                        subtitle: "Compete online. Predict winners.",
                        color: Colors.blueAccent,
                        onTap: () {
        final user = Supabase.instance.client.auth.currentUser;
        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Routing to Online Promoter Mode... (Coming Soon)"), backgroundColor: Colors.cyan));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const PromoterAuthGateScreen()));
        }
      },
                      const SizedBox(height: 16),

                      // 3. GLOBAL LEADERBOARDS
                      _buildMenuButton(
                        context,
                        icon: Icons.leaderboard_rounded,
                        title: "GLOBAL LEADERBOARDS",
                        subtitle: "See where you rank in the world.",
                        color: Colors.purpleAccent,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardScreen()));
                        },
                      ),
                      const SizedBox(height: 16),

                      // 4. COMMISSIONER TOOLS (Phase 4.2 CSV Import)
                      _buildMenuButton(
                        context,
                        icon: Icons.upload_file,
                        title: "COMMISSIONER MODE",
                        subtitle: "Import custom CSV rosters.",
                        color: Colors.greenAccent,
                        onTap: () async {
                          try {
                            final supabase = Supabase.instance.client;
                            final user = supabase.auth.currentUser;

                            // 🚀 THE FIX: Red SnackBar for Security Check
                            if (user == null) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("🚨 Access Denied: Please sign in to the Global Network first!"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                              return;
                            }

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Building League Room... Please wait."),
                                  backgroundColor: Colors.blue,
                                ),
                              );
                            }

                            // Generate the League
                            final leagueResponse = await supabase.from('leagues').insert({
                              'commissioner_id': user.id,
                              'name': 'Squared Circle Alpha',
                              'invite_code': 'ALPHA_${DateTime.now().millisecondsSinceEpoch}',
                              'max_players': 12
                            }).select('id').single();

                            final newLeagueId = leagueResponse['id'];

                            // Open File Picker and Upload
                            await CsvImportService.importRosterCSV(newLeagueId);

                            if (context.mounted) {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (_) => CommissionerDashboardScreen(leagueId: newLeagueId)
                              ));
                            }

                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("🚨 System Error: $e"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                      ),

                      const SizedBox(height: 40),
                      const Center(child: Text("v1.0.0 RELEASE", style: TextStyle(color: Colors.white10, fontSize: 10))),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ------------------------------------------------
          // RIGHT COLUMN: HERO IMAGE (60%)
          // ------------------------------------------------
          Expanded(
            flex: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // BACKGROUND
                Image.asset(
                  "assets/images/imagepromoter.png",
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(color: const Color(0xFF101010)),
                ),
                
                // GRADIENT OVERLAY
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.black, Colors.black.withOpacity(0.4), Colors.transparent],
                      stops: const [0.0, 0.3, 1.0],
                    ),
                  ),
                ),
                
                // TITLE TEXT
                Positioned(
                  bottom: 60,
                  right: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "SQUARED CIRCLE",
                        style: TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.w900,
                          color: Colors.white.withOpacity(0.95),
                          letterSpacing: 1.5,
                          height: 0.9,
                          shadows: [Shadow(color: Colors.black.withOpacity(0.8), blurRadius: 20, offset: const Offset(0, 5))]
                        ),
                      ),
                      Text(
                        "TYCOON",
                        style: TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.w900,
                          color: Colors.amber.withOpacity(0.95),
                          letterSpacing: 1.5,
                          height: 0.9,
                          shadows: [Shadow(color: Colors.black.withOpacity(0.8), blurRadius: 20, offset: const Offset(0, 5))]
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

  // --- HELPER WIDGETS ---

  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFF151515),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        hoverColor: color.withOpacity(0.05),
        splashColor: color.withOpacity(0.1),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.3)),
            ],
          ),
        ),
      ),
    );
  }

  // --- CAREER OPTIONS DIALOG ---
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
            // OPTION 1: CONTINUE
            if (hasSaveFile)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildDialogButton(context, "CONTINUE CAREER", Icons.play_arrow_rounded, Colors.greenAccent, () {
                  Navigator.pop(ctx);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PromoterHomeScreen()));
                }),
              ),

            // OPTION 2: ARCHIVES
            if (hasSaveFile)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildDialogButton(context, "VIEW ARCHIVES", Icons.history_rounded, Colors.amberAccent, () {
                  Navigator.pop(ctx);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ShowHistoryScreen()));
                }),
              ),

            // OPTION 3: NEW GAME
            Padding(
               padding: const EdgeInsets.only(bottom: 12.0),
               child: _buildDialogButton(context, "NEW CAREER", Icons.add_circle_outline_rounded, Colors.blueAccent, () {
                 Navigator.pop(ctx);
                 _confirmNewGame(context, ref);
               }),
            ),

            // OPTION 4: IMPORT
            _buildDialogButton(context, "IMPORT ROSTER", Icons.file_upload_rounded, Colors.purpleAccent, () async {
               Navigator.pop(ctx);
               final importer = RosterImporter(ref, context);
               await importer.pickAndImport();
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("CANCEL", style: TextStyle(color: Colors.white.withOpacity(0.5))),
          ),
        ],
      ),
    );
  }

  // --- CONFIRM NEW GAME DIALOG ---
  void _confirmNewGame(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("Start New Career?", style: TextStyle(color: Colors.white)),
        content: const Text(
          "This will delete your current progress and generate a new roster.\n\nAre you sure?", 
          style: TextStyle(color: Colors.white70)
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(ctx),
          ),
          TextButton(
            child: const Text("START NEW GAME", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onPressed: () async {
              Navigator.pop(ctx); 
              await ref.read(rosterProvider.notifier).factoryReset();
              if (context.mounted) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PromoterHomeScreen()));
              }
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildDialogButton(BuildContext context, String text, IconData icon, Color color, VoidCallback onPressed) {
      return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF303030),
                  foregroundColor: color,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  alignment: Alignment.centerLeft,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
              ),
              icon: Icon(icon, size: 24),
              label: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.0)),
              onPressed: onPressed,
          ),
      );
  }
}