import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../logic/game_state_provider.dart';
import '../../../data/models/wrestler.dart';
import '../../screens/hub_screen.dart';

// --- IMPORT FOR THE WATERMARK ---
import '../../components/tv_watermark.dart';

class SeasonRecapScreen extends ConsumerStatefulWidget {
  const SeasonRecapScreen({super.key});

  @override
  ConsumerState<SeasonRecapScreen> createState() => _SeasonRecapScreenState();
}

class _SeasonRecapScreenState extends ConsumerState<SeasonRecapScreen> {
  Wrestler? woty;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final isar = Isar.getInstance();
    if (isar != null) {
      final roster = await isar.wrestlers.where().findAll();
      roster.sort((a, b) => b.pop.compareTo(a.pop));
      if (roster.isNotEmpty) {
        woty = roster.first;
      }
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final ledger = gameState.ledger;

    double highestRating = 0.0;
    if (ledger.isNotEmpty) {
      highestRating = ledger.reduce((a, b) => a.showRating > b.showRating ? a : b).showRating;
    }

    final totalProfit = ledger.fold(0, (sum, e) => sum + e.profit);
    // Format the profit to look like real money (e.g. $1,250,000)
    final formattedProfit = totalProfit.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    
    final nextYear = gameState.year + 1;

    // 🚨 SMART LAYOUT BUILDER 🚨
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 800;

        if (isDesktop) {
          // 💻 PC LAYOUT (Wide Side-by-Side)
          return Scaffold(
            backgroundColor: const Color(0xFF121212),
            body: Row(
              children: [
                Expanded(flex: 4, child: _buildDesktopDataColumn(highestRating, formattedProfit, nextYear)),
                Expanded(flex: 6, child: _buildArtworkPane(isMobile: false)),
              ],
            ),
          );
        } else {
          // 📱 MOBILE LAYOUT (40/60 Vertical Split)
          return Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              children: [
                // TOP 40%: The Cinematic Viewport
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
                      const SafeArea(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.stars, color: Colors.amber, size: 24),
                                  SizedBox(width: 8),
                                  Text("SEASON FINALE", style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text("YEAR-END AWARDS", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // BOTTOM 60%: The Dashboard Data
                Expanded(
                  flex: 6,
                  child: Container(
                    color: Colors.black,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildStatRow('Event of the Year', '⭐ ${highestRating.toStringAsFixed(1)} Rating', isMobile: true),
                                  const SizedBox(height: 30),
                                  _buildStatRow('Wrestler of the Year', isLoading ? 'Loading...' : (woty?.name ?? 'N/A'), isMobile: true),
                                  const SizedBox(height: 30),
                                  _buildStatRow('Total Annual Profit', '\$$formattedProfit', isMobile: true),
                                ],
                              ),
                            ),
                          ),
                          _buildAdvanceButton(nextYear),
                          const SizedBox(height: 16), // Bottom safe area
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }
    );
  }

  // =====================================================================
  // --- 💻 DESKTOP SPECIFIC WIDGETS
  // =====================================================================
  Widget _buildDesktopDataColumn(double highestRating, String formattedProfit, int nextYear) {
    return Container(
      color: const Color(0xFF121212),
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'YEAR-END AWARDS GALA',
            style: TextStyle(
              fontSize: 32, 
              fontWeight: FontWeight.bold, 
              color: Colors.amber,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 50),
          _buildStatRow('Event of the Year', '⭐ ${highestRating.toStringAsFixed(1)} Rating', isMobile: false),
          const SizedBox(height: 30),
          _buildStatRow('Wrestler of the Year', isLoading ? 'Loading...' : (woty?.name ?? 'N/A'), isMobile: false),
          const SizedBox(height: 30),
          _buildStatRow('Total Annual Profit', '\$$formattedProfit', isMobile: false),
          const Spacer(),
          _buildAdvanceButton(nextYear),
        ],
      ),
    );
  }

  // =====================================================================
  // --- 🧩 MODULAR COMPONENTS (Shared by Mobile and Desktop)
  // =====================================================================
  Widget _buildAdvanceButton(int nextYear) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 10,
          shadowColor: Colors.amber.withOpacity(0.5),
        ),
        onPressed: () async {
          HapticFeedback.heavyImpact();
          await ref.read(gameProvider.notifier).processYearEnd();
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HubScreen()),
              (route) => false,
            );
          }
        },
        child: Text(
          'ADVANCE TO YEAR $nextYear',
          style: const TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String title, String value, {required bool isMobile}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(), 
            style: const TextStyle(fontSize: 12, color: Colors.white54, fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ),
          const SizedBox(height: 8),
          Text(
            value, 
            style: TextStyle(fontSize: isMobile ? 24 : 32, fontWeight: FontWeight.w900, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildArtworkPane({required bool isMobile}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/awards_gala.png',
          fit: BoxFit.cover,
          alignment: isMobile ? Alignment.topCenter : Alignment.center,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[900],
              child: const Center(
                child: Icon(Icons.emoji_events, size: 100, color: Colors.amber),
              ),
            );
          },
        ),
        if (!isMobile)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF121212), Colors.transparent],
                begin: Alignment.centerLeft,
                end: Alignment.center,
              ),
            ),
          ),
        
        // --- THE GLOBAL WATERMARK ---
        TVWatermark(isMobile: isMobile),
      ],
    );
  }
}