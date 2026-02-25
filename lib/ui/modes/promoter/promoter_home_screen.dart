import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/game_state_provider.dart';
import '../../../logic/promoter_provider.dart'; 
import '../../../logic/cloud_sync_service.dart'; // ☁️ IMPORT THE SYNC ENGINE!

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

// 🛠️ CONVERTED TO STATEFUL TO ALLOW AUTO-SYNC ON LOAD
class DashboardTab extends ConsumerStatefulWidget {
  const DashboardTab({super.key});

  @override
  ConsumerState<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends ConsumerState<DashboardTab> {

  @override
  void initState() {
    super.initState();
    // ☁️ SILENTLY SYNC TO CLOUD THE SECOND THE DASHBOARD OPENS!
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameState = ref.read(gameProvider);
      CloudSyncService.syncScoreToCloud(
        promotionName: "SCW", // Default Tycoon name
        cash: gameState.cash,
        fans: gameState.fans,
        rep: gameState.reputation,
      );
    });
  }

  // --- FACTORY RESET DIALOG ---
  void _showFactoryResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("Factory Reset?", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          "This will delete all data. Are you sure?", 
          style: TextStyle(color: Colors.white70)
        ),
        actions: [
          TextButton(
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            onPressed: () => Navigator.pop(ctx),
          ),
          TextButton(
            child: const Text("RESET NOW", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(rosterProvider.notifier).factoryReset();
              
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Universe Reset Complete!"), backgroundColor: Colors.red),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    
    // 🛠️ FIX: Determine if it is currently a PPV Week
    final bool isPPVWeek = gameState.isPPV; 

    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          // ------------------------------------------------
          // LEFT COLUMN: DASHBOARD MENUS (40%)
          // ------------------------------------------------
          Expanded(
            flex: 4,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                border: Border(right: BorderSide(color: Colors.white10)),
              ),
              child: Column(
                children: [
                  // TOP APP BAR AREA
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.dashboard, color: Colors.amber),
                          const SizedBox(width: 10),
                          const Text("DASHBOARD", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.settings, color: Colors.grey), 
                            onPressed: () => _showFactoryResetDialog(context, ref)
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // SCROLLABLE CONTENT
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. TOP METRICS
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white12),
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

                          // 2. HERO CARD: REACTIVE BANNER
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                // 🛠️ FIX: Turn banner GOLD on PPV weeks, BLUE on TV weeks!
                                colors: isPPVWeek 
                                  ? [Colors.amber.shade900, Colors.black] 
                                  : [Colors.blue.shade900, Colors.black],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: isPPVWeek ? Colors.amber : Colors.blueAccent.withOpacity(0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("WEEK ${gameState.week}", style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                                    Icon(isPPVWeek ? Icons.bolt : Icons.live_tv, color: Colors.white30, size: 16),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                
                                // 🛠️ FIX: Show PPV Name if it's PPV Week, otherwise TV Name!
                                Text(
                                  isPPVWeek ? gameState.nextPPVName.toUpperCase() : gameState.tvShowName.toUpperCase(), 
                                  style: TextStyle(
                                    color: isPPVWeek ? Colors.amberAccent : Colors.white, 
                                    fontSize: 22, 
                                    fontWeight: FontWeight.bold, 
                                    letterSpacing: 1.0
                                  )
                                ),
                                
                                const SizedBox(height: 2),
                                Text(
                                  isPPVWeek ? "PREMIUM LIVE EVENT" : "${gameState.currentVenueDetails['name']}", 
                                  style: const TextStyle(color: Colors.white70, fontSize: 12)
                                ),
                                const SizedBox(height: 12),
                                
                                // Warning Text to emphasize PPV Week
                                if (isPPVWeek)
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                    decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(4)),
                                    child: const Text("⚠️ EXPECTED BUYRATE: HIGH", style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
                                  )
                                else
                                  Row(
                                    children: [
                                      const Icon(Icons.event, size: 12, color: Colors.amber),
                                      const SizedBox(width: 5),
                                      Text("Next PPV: ${gameState.nextPPVName}", style: const TextStyle(color: Colors.amber, fontSize: 11, fontStyle: FontStyle.italic)),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),

                          // 3. UNIFIED MANAGEMENT LIST
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text("MANAGEMENT", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                          ),
                          
                          _buildMenuButton(
                            context,
                            icon: Icons.groups,
                            title: "ROSTER",
                            subtitle: "Manage talent, morale, and active rivalries.",
                            color: Colors.blueAccent,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RosterScreen())),
                          ),
                          
                          _buildMenuButton(
                            context,
                            icon: Icons.article_rounded,
                            title: "NEWS",
                            subtitle: "Latest dirt sheet rumors and actions.",
                            color: Colors.orangeAccent,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewsScreen())),
                          ),
                          
                          _buildMenuButton(
                            context,
                            icon: Icons.stadium_rounded,
                            title: "VENUES",
                            subtitle: "Upgrade production and capacity.",
                            color: Colors.greenAccent,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VenueScreen())),
                          ),
                          
                          _buildMenuButton(
                            context,
                            icon: Icons.cell_tower,
                            title: "BROADCASTING",
                            subtitle: "TV Deals, Production Values, and Show Naming.",
                            color: Colors.purpleAccent,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BroadcastingHubScreen())),
                          ),
                          
                          _buildMenuButton(
                            context,
                            icon: Icons.attach_money_rounded,
                            title: "FINANCES",
                            subtitle: "View the financial ledger and profits.",
                            color: Colors.tealAccent,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportScreen())),
                          ),
                          
                          _buildMenuButton(
                            context,
                            icon: Icons.bar_chart_rounded,
                            title: "RANKINGS",
                            subtitle: "Check the Ratings War Room.",
                            color: Colors.redAccent,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RatingsWarScreen())),
                          ),
                          
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ------------------------------------------------
          // RIGHT COLUMN: HERO BACKGROUND (60%)
          // ------------------------------------------------
          Expanded(
            flex: 6,
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
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.black, Colors.black.withOpacity(0.6), Colors.transparent],
                      stops: const [0.0, 0.2, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  right: 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset("assets/images/logo_scw.png", width: 150, errorBuilder: (c, e, s) => const Icon(Icons.sports_mma, size: 80, color: Colors.white10)),
                      const SizedBox(height: 20),
                      Text("SQUARED CIRCLE", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white.withOpacity(0.9), letterSpacing: 2)),
                      Text("TYCOON", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: const Color(0xFFFFD740).withOpacity(0.9), letterSpacing: 2)),
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

  // --- HELPER FORMATTING ---

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "Monospace")),
      ],
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
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
}