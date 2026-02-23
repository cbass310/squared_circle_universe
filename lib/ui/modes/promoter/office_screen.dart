import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/game_state_provider.dart';
import '../../../logic/promoter_provider.dart';
import 'sponsorship_screen.dart'; 
import 'calendar_screen.dart';
import 'venue_screen.dart'; 
import 'title_screen.dart'; 
import 'rivalry_screen.dart'; 
import 'broadcasting_hub_screen.dart'; // <-- FIX: Imported the new Broadcasting Hub!
import 'ratings_war_screen.dart'; 

class OfficeScreen extends ConsumerWidget {
  const OfficeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final gameNotifier = ref.read(gameProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          // ---------------------------------------------------------
          // LEFT COLUMN: CONTROL PANEL (40% Width)
          // ---------------------------------------------------------
          Expanded(
            flex: 4,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                border: Border(right: BorderSide(color: Colors.white10)),
              ),
              child: Column(
                children: [
                  // --- HEADER ---
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.business_center, color: Colors.amber),
                          const SizedBox(width: 10),
                          const Text("FRONT OFFICE", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
                        ],
                      ),
                    ),
                  ),

                  // --- SCROLLABLE MENU ---
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. RATINGS WAR STATUS (Compact)
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RatingsWarScreen())),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.amber.shade900, Colors.black],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight
                                ),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.amber.withOpacity(0.5)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.trending_up, color: Colors.white, size: 24),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text("RATINGS WAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                      Text("View Status >", style: TextStyle(color: Colors.amberAccent, fontSize: 10)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),

                          // 2. GROWTH & EXPANSION
                          _buildSectionHeader("GROWTH & EXPANSION"),
                          _buildActionTile(context, "VENUE", "Current: ${gameState.currentVenueDetails['name']}", Icons.domain_add, Colors.cyan, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VenueScreen()))),
                          _buildActionTile(context, "TITLES", "Manage Belts", Icons.emoji_events, Colors.amber, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TitleScreen()))),
                          _buildActionTile(context, "RIVALRIES", "Active Feuds", Icons.local_fire_department, Colors.red, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RivalryScreen()))),
                          
                          // --- FIX: Updated this button to route to Broadcasting Hub ---
                          _buildActionTile(context, "BROADCASTING", "TV Deals, Pyro, & Brands", Icons.cell_tower, Colors.purpleAccent, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BroadcastingHubScreen()))),

                          const SizedBox(height: 25),

                          // 3. FINANCIALS
                          _buildSectionHeader("FINANCIALS"),
                          _buildActionTile(context, "SPONSORS", "Active Deals: ${gameState.activeSponsors.length}/3", Icons.monetization_on, Colors.green, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SponsorshipScreen()))),

                          const SizedBox(height: 25),

                          // 4. CORPORATE BRANDING
                          _buildSectionHeader("CORPORATE BRANDING"),
                          _buildActionTile(context, "CALENDAR", "Edit PPV Names", Icons.calendar_month, Colors.redAccent, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CalendarScreen()))),
                          _buildActionTile(context, "RENAME CO.", gameState.promotionName, Icons.edit, Colors.blue, () => _showRenameDialog(context, "New Promotion Name", gameState.promotionName, (val) => gameNotifier.renamePromotion(val))),
                          _buildActionTile(context, "RENAME TV", gameState.tvShowName, Icons.tv, Colors.purple, () => _showRenameDialog(context, "New TV Show Name", gameState.tvShowName, (val) => gameNotifier.renameTVShow(val))),
                          
                          // 5. DANGER ZONE
                          const SizedBox(height: 30),
                          const Divider(color: Colors.white24),
                          _buildActionTile(
                            context, 
                            "FACTORY RESET", 
                            "Wipe Data", 
                            Icons.warning_amber_rounded, 
                            Colors.red, 
                            () => _showResetConfirmation(context, ref)
                          ),
                          const SizedBox(height: 50), // Bottom padding
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---------------------------------------------------------
          // RIGHT COLUMN: OFFICE VISUALS (60% Width)
          // ---------------------------------------------------------
          Expanded(
            flex: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 1. BACKGROUND IMAGE
                Image.asset(
                  "assets/images/office_background.png", // Ensure this matches your file!
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(color: const Color(0xFF151515)),
                ),

                // 2. GRADIENT OVERLAY
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black,
                        Colors.black.withOpacity(0.4),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.3, 1.0],
                    ),
                  ),
                ),

                // 3. OVERLAY CONTENT (Logo & Info)
                Positioned(
                  bottom: 40,
                  right: 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Logo
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24)
                        ),
                        child: Image.asset("assets/images/logo_scw.png", width: 80, height: 80, fit: BoxFit.contain, errorBuilder: (c,o,s) => const Icon(Icons.business, size: 50, color: Colors.white)),
                      ),
                      const SizedBox(height: 15),
                      Text("OFFICE OF THE", style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.7), letterSpacing: 2)),
                      Text("PRESIDENT", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: const Color(0xFFFFD740).withOpacity(0.9), letterSpacing: 2)),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
    );
  }

  Widget _buildActionTile(BuildContext context, String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 10), overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 12),
          ],
        ),
      ),
    );
  }

  // --- DIALOGS ---
  
  void _showRenameDialog(BuildContext context, String title, String currentVal, Function(String) onSave) {
    final txtController = TextEditingController(text: currentVal);
    showDialog(context: context, builder: (ctx) => AlertDialog(backgroundColor: const Color(0xFF1E1E1E), title: Text(title, style: const TextStyle(color: Colors.white)), content: TextField(controller: txtController, style: const TextStyle(color: Colors.white)), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("CANCEL")), TextButton(onPressed: () { if(txtController.text.isNotEmpty) onSave(txtController.text); Navigator.pop(ctx); }, child: const Text("SAVE"))]));
  }

  void _showResetConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("Factory Reset?", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          "This will delete all data. Are you sure?", 
          style: TextStyle(color: Colors.white70)
        ),
        actions: [
          TextButton(
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)), 
            onPressed: () => Navigator.pop(ctx)
          ),
          TextButton(
            child: const Text("RESET NOW", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onPressed: () async {
              Navigator.pop(ctx); 
              // 1. Run the Reset Logic
              await ref.read(rosterProvider.notifier).factoryReset(); 
              
              // 2. Show success message
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Universe Reset Complete!"), backgroundColor: Colors.red)
                );
              }
            },
          ),
        ],
      ),
    );
  }
}