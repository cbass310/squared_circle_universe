import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/game_state_provider.dart';
import '../../../logic/promoter_provider.dart'; 
import '../../../logic/cloud_sync_service.dart';
// --- SCREEN IMPORTS ---
import 'booking_hub_screen.dart';
import 'office_screen.dart';
import 'development_screen.dart';
import 'roster_screen.dart';
import 'venue_screen.dart';
import 'broadcasting_hub_screen.dart';
import 'news_screen.dart';
import '../leaderboard/leaderboard_screen.dart';
import 'report_screen.dart';
import 'ratings_war_screen.dart';
import '../../screens/settings_screen.dart';

class PromoterHomeScreen extends ConsumerStatefulWidget {
  const PromoterHomeScreen({super.key});

  @override
  ConsumerState<PromoterHomeScreen> createState() => _PromoterHomeScreenState();
}

class _PromoterHomeScreenState extends ConsumerState<PromoterHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _mainTabs = [
    const DashboardTab(),
    const BookingHubScreen(),
    const OfficeScreen(),
    const DevelopmentScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: _selectedIndex,
        children: _mainTabs,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white10)),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF121212),
          selectedItemColor: const Color(0xFFFFD740),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "HOME"),
            BottomNavigationBarItem(icon: Icon(Icons.tv), label: "BOOKING"),
            BottomNavigationBarItem(icon: Icon(Icons.business), label: "OFFICE"),
            BottomNavigationBarItem(icon: Icon(Icons.flash_on), label: "POWER PLANT"),
          ],
        ),
      ),
    );
  }
}

class DashboardTab extends ConsumerStatefulWidget {
  const DashboardTab({super.key});

  @override
  ConsumerState<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends ConsumerState<DashboardTab> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameState = ref.read(gameProvider);
      CloudSyncService.syncScoreToCloud(
        promotionName: "SCW",
        cash: gameState.cash,
        fans: gameState.fans,
        rep: gameState.reputation,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final bool isPPVWeek = gameState.isPPV;
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: Colors.black,
      body: isDesktop 
          ? Row(children: [_buildDashboardColumn(context, gameState, isPPVWeek, true), _buildHeroBackground(true)])
          : Stack(
              children: [
                _buildHeroBackground(false),
                Container(color: Colors.black.withOpacity(0.85)), 
                _buildDashboardColumn(context, gameState, isPPVWeek, false),
              ],
            ),
    );
  }

  // ------------------------------------------------
  // WIDGET: THE MAIN DASHBOARD COLUMN
  // ------------------------------------------------
  Widget _buildDashboardColumn(BuildContext context, dynamic gameState, bool isPPVWeek, bool isDesktop) {
    return Expanded(
      flex: isDesktop ? 4 : 1,
      child: Container(
        decoration: BoxDecoration(
          color: isDesktop ? Colors.black : Colors.transparent,
          border: isDesktop ? const Border(right: BorderSide(color: Colors.white10)) : null,
        ),
        child: Column(
          children: [
            // TOP APP BAR AREA
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
                child: Row(
                  children: [
                    const Icon(Icons.dashboard, color: Colors.amber),
                    const SizedBox(width: 10),
                    const Text("DASHBOARD", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.grey),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))
                    ),
                  ],
                ),
              ),
            ),

            // SCROLLABLE CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 24.0 : 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. TOP METRICS
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
                          _buildStatItem("CASH", "\$${_formatNumber(gameState.cash)}", Colors.greenAccent),
                          Container(width: 1, height: 30, color: Colors.white10),
                          _buildStatItem("FANS", _formatNumber(gameState.fans), Colors.blueAccent),
                          Container(width: 1, height: 30, color: Colors.white10),
                          _buildStatItem("REP", "${gameState.reputation}", Colors.amber),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // 2. INTERACTIVE EVENT BANNER (War Room Embedded)
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
                            // LEFT SIDE: EVENT INFO
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
                            // RIGHT SIDE: WAR ROOM RANKINGS
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: const Column(
                                children: [
                                  Icon(Icons.bar_chart_rounded, color: Colors.redAccent, size: 20),
                                  SizedBox(height: 4),
                                  Text("WAR ROOM", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 2),
                                  Text("0 - 0", style: TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.w900)), 
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    // 3. REORDERED MANAGEMENT LIST
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text("MANAGEMENT", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    ),

                    _buildPremiumMenuButton(
                      context,
                      icon: Icons.groups_rounded,
                      title: "ROSTER",
                      subtitle: "Manage talent, morale, and active rivalries.",
                      baseColor: Colors.blueAccent,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RosterScreen())),
                    ),

                    _buildPremiumMenuButton(
                      context,
                      icon: Icons.article_rounded,
                      title: "COMMUNICATIONS",
                      subtitle: "Latest dirt sheet rumors and company actions.",
                      baseColor: Colors.orangeAccent,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewsScreen())),
                    ),

                    _buildPremiumMenuButton(
                      context,
                      icon: Icons.attach_money_rounded,
                      title: "FINANCES",
                      subtitle: "View the financial ledger and profits.",
                      baseColor: Colors.tealAccent,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportScreen())),
                    ),
                    _buildPremiumMenuButton(
                      context,
                      icon: Icons.cell_tower_rounded,
                      title: "BROADCASTING",
                      subtitle: "TV Deals, Production Values, and Show Naming.",
                      baseColor: Colors.purpleAccent,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BroadcastingHubScreen())),
                    ),
                    _buildPremiumMenuButton(
                      context,
                      icon: Icons.stadium_rounded,
                      title: "VENUES",
                      subtitle: "Upgrade production and capacity.",
                      baseColor: Colors.greenAccent,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VenueScreen())),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------
  // WIDGET: RESPONSIVE HERO BACKGROUND
  // ------------------------------------------------
  Widget _buildHeroBackground(bool isDesktop) {
    return Expanded(
      flex: isDesktop ? 6 : 1,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/crowd_background.png",
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(color: const Color(0xFF151515)),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: isDesktop ? Alignment.centerLeft : Alignment.topCenter,
                end: isDesktop ? Alignment.centerRight : Alignment.bottomCenter,
                colors: [Colors.black, Colors.black.withOpacity(0.5), Colors.transparent],
                stops: const [0.0, 0.3, 1.0],
              ),
            ),
          ),
          if (isDesktop)
            Positioned(
              bottom: 40,
              right: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset("assets/images/logo_scw.png", width: 150, errorBuilder: (c, e, s) => const Icon(Icons.sports_mma, size: 80, color: Colors.white10)),
                  const SizedBox(height: 20),
                  Text("SQUARED CIRCLE", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white.withOpacity(0.95), letterSpacing: 2, shadows: [Shadow(color: Colors.black.withOpacity(0.8), blurRadius: 10, offset: const Offset(0, 4))])),
                  Text("TYCOON", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: const Color(0xFFFFD740).withOpacity(0.95), letterSpacing: 2, shadows: [Shadow(color: Colors.black.withOpacity(0.8), blurRadius: 10, offset: const Offset(0, 4))])),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ------------------------------------------------
  // HELPER FORMATTING & WIDGETS
  // ------------------------------------------------
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
