import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/game_state_provider.dart';
import '../../../logic/promoter_provider.dart'; 
import '../../../logic/cloud_sync_service.dart';
import '../../../logic/communications_provider.dart'; 

// --- SCREEN IMPORTS ---
import 'booking_hub_screen.dart';       
import 'office_screen.dart';            
import 'development_screen.dart';       
import 'roster_screen.dart';            
import 'broadcasting_hub_screen.dart'; 
import 'news_screen.dart'; 
import '../leaderboard/leaderboard_screen.dart';               
import 'report_screen.dart'; 
import 'ratings_war_screen.dart'; 
import '../../screens/settings_screen.dart'; 

// --- WIDGET IMPORTS ---
import '../../components/global_network_button.dart'; 

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
    // 🚨 SMART LAYOUT BUILDER ADAPTED FOR RESPONSIVE SCALING 🚨
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 600; // Allow tablets to get PC UI

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              IndexedStack(
                index: _selectedIndex,
                children: _mainTabs,
              ),
              
              // THE UNIVERSAL GLOBAL COMPONENT
              Positioned(
                top: isDesktop ? 40 : 50, 
                right: isDesktop ? 40 : 20,
                child: const GlobalNetworkButton(),
              ),
            ],
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
    );
  }
}

class DashboardTab extends ConsumerStatefulWidget {
  const DashboardTab({super.key});

  @override
  ConsumerState<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends ConsumerState<DashboardTab> with SingleTickerProviderStateMixin {
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Setup the glowing pulse animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); 
    
    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameState = ref.read(gameProvider);
      
      CloudSyncService.syncScoreToCloud(
        promotionName: "SCW", 
        cash: gameState.cash,
        fans: gameState.fans,
        rep: gameState.reputation,
      );

      final currentNews = ref.read(communicationsProvider);
      if (currentNews.isEmpty) {
        ref.read(communicationsProvider.notifier).generateWeeklyContent(gameState.week);
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final bool isPPVWeek = gameState.isPPV; 

    // 🚨 40/60 MOBILE SPLIT ARCHITECTURE 🚨
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 600; // 🛠️ 600 For Tablets

        if (isDesktop) {
          // 💻 PC / TABLET LAYOUT (Wide Side-by-Side)
          return Scaffold(
            backgroundColor: Colors.transparent, 
            body: Row(
              children: [
                Expanded(flex: 4, child: _buildDashboardContent(context, gameState, isPPVWeek, true)), 
                _buildHeroBackground(true) // Takes remaining flex 6 internally
              ]
            ),
          );
        } else {
          // 📱 PHONE LAYOUT (40/60 Vertical Split)
          return Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              children: [
                // 🛠️ THE FIX: Top 40% Image NOW INCLUDES THE HEADER TEXT
                Expanded(
                  flex: 4, 
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildHeroBackground(false),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black.withOpacity(0.4), Colors.black],
                            stops: const [0.5, 1.0],
                          )
                        )
                      ),
                      // THE MOVED HEADER
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.settings, color: Colors.white70),
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.zero,
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.dashboard, color: Colors.amber, size: 20),
                                      SizedBox(width: 8),
                                      Text("EXECUTIVE OVERVIEW", style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text("DASHBOARD", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 🛠️ THE FIX: Bottom 60% Dashboard is now completely free of the header!
                Expanded(
                  flex: 6,
                  child: Container(
                    color: Colors.black,
                    width: double.infinity,
                    child: _buildDashboardContent(context, gameState, isPPVWeek, false),
                  ),
                ),
              ],
            ),
          );
        }
      }
    );
  }

  // ------------------------------------------------
  // WIDGET: THE MAIN DASHBOARD CONTENT
  // ------------------------------------------------
  Widget _buildDashboardContent(BuildContext context, dynamic gameState, bool isPPVWeek, bool isDesktop) {
    bool isMissingTvDeal = false;
    bool isMissingSponsors = false;

    if (!isPPVWeek) {
      try { isMissingTvDeal = gameState.activeTvDeals == null || gameState.activeTvDeals.isEmpty; } catch (e) {
         try { isMissingTvDeal = gameState.tvDeals == null || gameState.tvDeals.isEmpty; } catch (e) { isMissingTvDeal = false; }
      }
    }

    try { isMissingSponsors = gameState.activeSponsors == null || gameState.activeSponsors.isEmpty; } catch (e) { isMissingSponsors = false; }

    return Container(
      decoration: BoxDecoration(
        color: isDesktop ? Colors.black : Colors.transparent,
        border: isDesktop ? const Border(right: BorderSide(color: Colors.white10)) : null,
      ),
      child: Column(
        children: [
          // TOP APP BAR AREA - ONLY COMPILES ON DESKTOP NOW
          if (isDesktop)
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 24.0, right: 24.0, top: 24.0, bottom: 16.0
                ),
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
              padding: EdgeInsets.only(
                left: isDesktop ? 24.0 : 16.0,
                right: isDesktop ? 24.0 : 16.0,
                top: isDesktop ? 0 : 16.0, // Adds top padding on mobile since header is gone
              ),
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

                  // 2. INTERACTIVE EVENT BANNER
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
                                // 🚨 THE FIX: Added the Draws variable directly to this widget!
                                Text("${gameState.playerWins}-${gameState.rivalWins}-${gameState.draws}", style: const TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.w900)), 
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // 3. MANAGEMENT LIST
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
                    isPulsing: false, 
                  ),
                  
                  _buildPremiumMenuButton(
                    context,
                    icon: Icons.article_rounded,
                    title: "COMMUNICATIONS",
                    subtitle: "Latest dirt sheet rumors and company actions.",
                    baseColor: Colors.orangeAccent,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewsScreen())),
                    isPulsing: false, 
                  ),
                  
                  _buildPremiumMenuButton(
                    context,
                    icon: Icons.attach_money_rounded,
                    title: "FINANCES",
                    subtitle: isMissingSponsors ? "ACTION REQUIRED: Sign Sponsors!" : "View the financial ledger and profits.",
                    baseColor: isMissingSponsors ? Colors.redAccent : Colors.tealAccent,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportScreen())),
                    isPulsing: isMissingSponsors,
                  ),

                  _buildPremiumMenuButton(
                    context,
                    icon: Icons.cell_tower_rounded,
                    title: "BROADCASTING",
                    subtitle: isMissingTvDeal ? "URGENT: No Active TV Deal!" : "TV Deals, Production Values, and Show Naming.",
                    baseColor: isMissingTvDeal ? Colors.redAccent : Colors.purpleAccent,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BroadcastingHubScreen())),
                    isPulsing: isMissingTvDeal,
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

  // ------------------------------------------------
  // WIDGET: RESPONSIVE HERO BACKGROUND
  // ------------------------------------------------
  Widget _buildHeroBackground(bool isDesktop) {
    if (!isDesktop) {
      // Phone Background (No Expanded wrapper needed inside Stack)
      return Image.asset(
        "assets/images/crowd_background.png", 
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => Container(color: const Color(0xFF151515)),
      );
    }
    
    // PC Background
    return Expanded(
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
                colors: [Colors.black, Colors.black.withOpacity(0.5), Colors.transparent],
                stops: const [0.0, 0.3, 1.0],
              ),
            ),
          ),
          if (isDesktop)
            Positioned(
              bottom: 20, 
              right: 20,
              child: IgnorePointer( 
                child: Opacity(
                  opacity: 0.6, 
                  child: Image.asset(
                    "assets/images/logo_watermark.png", 
                    width: 120, 
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => const SizedBox.shrink(),
                  ),
                ),
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
    required bool isPulsing,
  }) {
    
    Widget buttonContent = Container(
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
                      Row(
                        children: [
                          Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                          if (isPulsing) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(4)),
                              child: const Text("!", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
                            )
                          ]
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(subtitle, style: TextStyle(color: isPulsing ? Colors.redAccent : Colors.white.withOpacity(0.5), fontSize: 11, fontWeight: isPulsing ? FontWeight.bold : FontWeight.w500)),
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

    if (!isPulsing) return buttonContent;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withOpacity(_pulseAnimation.value * 0.4),
                blurRadius: 15,
                spreadRadius: 2,
              )
            ]
          ),
          child: child,
        );
      },
      child: buttonContent,
    );
  }
}