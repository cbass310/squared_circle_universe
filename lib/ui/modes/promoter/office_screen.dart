import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/game_state_provider.dart';
import '../../../logic/promoter_provider.dart';
import 'sponsorship_screen.dart'; 
import 'title_screen.dart'; 
import 'rivalry_screen.dart'; 
import 'ratings_war_screen.dart'; 
import 'venue_screen.dart'; // 🚀 Brought Venues over!

class OfficeScreen extends ConsumerWidget {
  const OfficeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final gameNotifier = ref.read(gameProvider.notifier);
    
    final bool isDesktop = MediaQuery.of(context).size.width > 800;
    final bool isPPVWeek = gameState.isPPV; 

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: isDesktop
            ? Row(
                children: [
                  Expanded(flex: 4, child: _buildLeftMenu(context, gameState, gameNotifier, ref, isPPVWeek, isDesktop)),
                  Expanded(flex: 6, child: _buildRightArtPane(gameState)),
                ],
              )
            : Stack(
                children: [
                  _buildRightArtPane(gameState, isMobile: true),
                  Container(color: Colors.black.withOpacity(0.85)),
                  _buildLeftMenu(context, gameState, gameNotifier, ref, isPPVWeek, isDesktop),
                ],
              ),
      ),
    );
  }

  // =====================================================================
  // --- LEFT PANE: THE UNIFIED CONTROL PANEL
  // =====================================================================
  Widget _buildLeftMenu(BuildContext context, dynamic gameState, GameNotifier gameNotifier, WidgetRef ref, bool isPPVWeek, bool isDesktop) {
    String formattedCash = "\$${gameState.cash.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}";

    return Container(
      decoration: BoxDecoration(
        color: isDesktop ? Colors.black : Colors.transparent,
        border: isDesktop ? const Border(right: BorderSide(color: Colors.white10)) : null,
      ),
      child: Column(
        children: [
          // --- EXACT MATCH HEADER ---
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
              child: Row(
                children: const [
                  Icon(Icons.business_center, color: Colors.amber),
                  SizedBox(width: 10),
                  Text("FRONT OFFICE", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
                  Spacer(),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 24.0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. MIRRORED HOME STATS BLOCK
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 5))],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatItem("CASH", formattedCash, Colors.greenAccent),
                        Container(width: 1, height: 30, color: Colors.white10),
                        _buildStatItem("FANS", _formatNumber(gameState.fans), Colors.blueAccent),
                        Container(width: 1, height: 30, color: Colors.white10),
                        _buildStatItem("REP", "${gameState.reputation}", Colors.amber),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2. MIRRORED INTERACTIVE EVENT BANNER
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RatingsWarScreen())),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isPPVWeek 
                            ? [Colors.amber.shade900, const Color(0xFF1E1E1E)] 
                            : [Colors.blue.shade900, const Color(0xFF1E1E1E)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isPPVWeek ? Colors.amber : Colors.blueAccent.withOpacity(0.5), width: 1.5),
                        boxShadow: [BoxShadow(color: (isPPVWeek ? Colors.amber : Colors.blueAccent).withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4))],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text("WEEK ${gameState.week}", style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 8),
                                    Icon(isPPVWeek ? Icons.bolt : Icons.live_tv, color: Colors.white54, size: 14),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isPPVWeek ? gameState.nextPPVName.toUpperCase() : gameState.tvShowName.toUpperCase(), 
                                  style: TextStyle(color: isPPVWeek ? Colors.amberAccent : Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1.0)
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isPPVWeek ? "PREMIUM LIVE EVENT" : "${gameState.currentVenueDetails['name']}", 
                                  style: const TextStyle(color: Colors.white70, fontSize: 12)
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Column(
                              children: [
                                const Icon(Icons.bar_chart_rounded, color: Colors.redAccent, size: 20),
                                const SizedBox(height: 4),
                                const Text("WAR ROOM", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text("${gameState.playerWins} - ${gameState.rivalWins}", style: const TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.w900)), 
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // 3. EXACT MATCH MANAGEMENT LIST (Ratings War removed, 4 perfect buttons)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text("CREATIVE & BRANDING", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  ),

                  _buildPremiumMenuButton(
                    context,
                    icon: Icons.lightbulb,
                    title: "CREATIVE",
                    subtitle: "Manage storylines and active feuds.",
                    baseColor: Colors.purpleAccent,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RivalryScreen())),
                  ),
                  
                  _buildPremiumMenuButton(
                    context,
                    icon: Icons.emoji_events,
                    title: "CHAMPIONSHIPS",
                    subtitle: "View title lineages and belt holders.",
                    baseColor: Colors.amber,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TitleScreen())),
                  ),
                  
                  _buildPremiumMenuButton(
                    context,
                    icon: Icons.handshake,
                    title: "CORPORATE SPONSORS",
                    subtitle: "Active Brand Deals: ${gameState.activeSponsors.length}/3",
                    baseColor: Colors.tealAccent, // Synced to teal to match
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SponsorshipScreen())),
                  ),

                  _buildPremiumMenuButton(
                    context,
                    icon: Icons.stadium_rounded,
                    title: "VENUES",
                    subtitle: "Upgrade production and capacity.",
                    baseColor: Colors.greenAccent, // Synced to green
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VenueScreen())),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // --- RIGHT PANE: CLEAN ARTWORK PANE
  // =====================================================================
  Widget _buildRightArtPane(dynamic gameState, {bool isMobile = false}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/images/office_background.png", 
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => Container(color: const Color(0xFF0A0A0A)),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.black.withOpacity(0.6), Colors.transparent, Colors.black.withOpacity(0.4)],
              stops: const [0.0, 0.2, 1.0],
            ),
          ),
        ),
        Positioned(
          bottom: 40, right: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.amber.withOpacity(0.5), width: 2)
                ),
                child: Image.asset("assets/images/logo_scw.png", width: isMobile ? 50 : 80, height: isMobile ? 50 : 80, fit: BoxFit.contain, errorBuilder: (c,o,s) => Icon(Icons.business, size: isMobile ? 40 : 60, color: Colors.amber)),
              ),
              const SizedBox(height: 15),
              Text("OFFICE OF THE PRESIDENT", style: TextStyle(fontSize: isMobile ? 12 : 16, color: Colors.white54, letterSpacing: 2.0, fontWeight: FontWeight.bold)),
              Text(gameState.promotionName.toUpperCase(), style: TextStyle(fontSize: isMobile ? 24 : 32, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2.0)),
            ],
          ),
        ),
      ],
    );
  }

  // --- HELPER FORMATTING & WIDGETS ---
  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w900, fontFamily: "Monospace")),
      ],
    );
  }

  // EXACTLY synced with Home Screen style
  Widget _buildPremiumMenuButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color baseColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [const Color(0xFF1A1A1A), baseColor.withOpacity(0.05)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        border: Border.all(color: baseColor.withOpacity(0.3), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          hoverColor: baseColor.withOpacity(0.1),
          splashColor: baseColor.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: baseColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: baseColor.withOpacity(0.2), blurRadius: 8)],
                  ),
                  child: Icon(icon, color: baseColor, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: baseColor.withOpacity(0.5), size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}