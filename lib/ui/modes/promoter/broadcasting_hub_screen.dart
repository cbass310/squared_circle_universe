import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../logic/game_state_provider.dart';
import '../../../data/models/tv_network_deal.dart';

// --- IMPORT FOR THE WATERMARK ---
import '../../components/tv_watermark.dart';

final availableTvDealsProvider = FutureProvider.family<List<TvNetworkDeal>, int>((ref, tier) async {
  final isar = Isar.getInstance();
  if (isar == null) return [];
  
  final rawDeals = await isar.tvNetworkDeals.filter().tierLevelEqualTo(tier).findAll();
  
  // 🛠️ THE FIX: Filter out duplicate TV Deals!
  // If the app was seeded multiple times, Isar might have duplicate TV Deals.
  // This ensures we only ever show one instance of each Network Name in the UI.
  final uniqueDealsMap = <String, TvNetworkDeal>{};
  for (final deal in rawDeals) {
    uniqueDealsMap[deal.networkName] = deal;
  }
  
  // Sort them by payout so the best deals are always at the top!
  final sortedDeals = uniqueDealsMap.values.toList();
  sortedDeals.sort((a, b) => b.weeklyPayout.compareTo(a.weeklyPayout));
  
  return sortedDeals;
});

class BroadcastingHubScreen extends ConsumerStatefulWidget {
  const BroadcastingHubScreen({super.key});

  @override
  ConsumerState<BroadcastingHubScreen> createState() => _BroadcastingHubScreenState();
}

class _BroadcastingHubScreenState extends ConsumerState<BroadcastingHubScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _tvNameController = TextEditingController();
  
  late TabController _tabController;
  int _selectedTabIndex = 0;
  TvNetworkDeal? _selectedDeal;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tvNameController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);

    // 🚨 SMART LAYOUT BUILDER 🚨
    return LayoutBuilder(
      builder: (context, constraints) {
        // 🛠️ THE FIX: Lowered to 600 so Tablets in portrait get the Side-by-Side layout!
        final bool isDesktop = constraints.maxWidth > 600; 

        if (isDesktop) {
          // 💻 PC / TABLET LAYOUT (Wide Side-by-Side)
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Row(
                children: [
                  Expanded(flex: 4, child: _buildDashboard(gameState, true)),
                  Expanded(
                    flex: 6, 
                    child: _selectedTabIndex == 0 && _selectedDeal != null 
                        ? Container(color: Colors.black, padding: const EdgeInsets.all(40), child: _buildContractProposal(_selectedDeal!, ref.read(gameProvider.notifier)))
                        : _buildArtworkPane(isMobile: false)
                  ),
                ],
              ),
            ),
          );
        } else {
          // 📱 MOBILE LAYOUT (40/60 Vertical Split)
          
          // Exception: If a contract proposal is open, slide it over the bottom 60%
          if (_selectedTabIndex == 0 && _selectedDeal != null) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Column(
                children: [
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
                        const TVWatermark(isMobile: true), // 🛠️ THE FIX: Watermark on TOP of gradient
                      ],
                    )
                  ),
                  Expanded(
                    flex: 6,
                    child: _buildMobileContractDetailPane(gameState),
                  )
                ],
              ),
            );
          }

          // Standard Mobile Layout
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
                      const TVWatermark(isMobile: true), // 🛠️ THE FIX: Watermark on TOP of gradient
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.amber, size: 20),
                                onPressed: () => Navigator.pop(context),
                                padding: EdgeInsets.zero,
                                alignment: Alignment.topLeft,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(_getTabIcon(), color: _getTabColor(), size: 24),
                                      const SizedBox(width: 8),
                                      Text(_getTabSubtitle(), style: TextStyle(color: _getTabColor(), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(_getTabTitle(), style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                                ],
                              ),
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
                    child: _buildDashboard(gameState, false),
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
  // --- THE DASHBOARD (Shared by Desktop & Mobile)
  // =====================================================================
  Widget _buildDashboard(GameState gameState, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: isDesktop ? const Color(0xFF121212) : Colors.black,
        border: isDesktop ? const Border(right: BorderSide(color: Colors.white10, width: 2)) : null,
      ),
      child: Column(
        children: [
          // HEADER (PC ONLY - Mobile uses the image overlay)
          if (isDesktop)
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.amber, size: 20), onPressed: () => Navigator.pop(context)),
                    const SizedBox(width: 8),
                    const Text("BROADCASTING", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  ],
                ),
              ),
            ),
          
          // --- TABS ---
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: isDesktop ? Colors.black : Colors.white10, width: isDesktop ? 3 : 1)),
              color: isDesktop ? const Color(0xFF121212) : Colors.black,
            ),
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent, 
              indicatorColor: Colors.amber,
              indicatorWeight: 3,
              labelColor: Colors.amber,
              unselectedLabelColor: Colors.white54,
              labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1.0),
              tabs: const [
                Tab(text: "CONTRACTS"),
                Tab(text: "PRODUCTION"),
                Tab(text: "BRANDING"),
              ],
            ),
          ),
          
          // --- TAB CONTENT ---
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildContractsList(gameState),
                _buildProductionTab(gameState),
                _buildBrandingTab(gameState),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // --- ARTWORK PANE (Dynamic based on Tab)
  // =====================================================================
  Widget _buildArtworkPane({required bool isMobile}) {
    String imagePath = "assets/images/office_bg.png"; // Fallback
    
    if (_selectedTabIndex == 0) imagePath = "assets/images/office_background.png"; // Contracts
    if (_selectedTabIndex == 1) imagePath = "assets/images/production_bg.png"; // Production
    if (_selectedTabIndex == 2) imagePath = "assets/images/branding_bg.png"; // Branding

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          imagePath, 
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (c, e, s) => Container(color: const Color(0xFF0A0A0A)),
        ),
        if (!isMobile) ...[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.black.withOpacity(0.95), Colors.black.withOpacity(0.4), Colors.black.withOpacity(0.8)],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          const TVWatermark(isMobile: false),
        ]
      ],
    );
  }

  // Helper strings for the Mobile Header
  String _getTabTitle() {
    if (_selectedTabIndex == 0) return "TELEVISION DEALS";
    if (_selectedTabIndex == 1) return "PRODUCTION VALUES";
    return "GLOBAL BRANDING";
  }
  
  String _getTabSubtitle() {
    if (_selectedTabIndex == 0) return "DISTRIBUTION";
    if (_selectedTabIndex == 1) return "PRESENTATION";
    return "INTELLECTUAL PROPERTY";
  }

  Color _getTabColor() {
    if (_selectedTabIndex == 0) return Colors.greenAccent;
    if (_selectedTabIndex == 1) return Colors.blueAccent;
    return Colors.amber;
  }

  IconData _getTabIcon() {
    if (_selectedTabIndex == 0) return Icons.satellite_alt_rounded;
    if (_selectedTabIndex == 1) return Icons.speaker_group_rounded;
    return Icons.auto_awesome;
  }

  // =====================================================================
  // --- TAB 1: CONTRACTS LIST 
  // =====================================================================
  Widget _buildContractsList(GameState gameState) {
    if (!gameState.isBiddingWarActive && gameState.activeTvDeal != null) {
      final deal = gameState.activeTvDeal!;
      bool isDesktop = MediaQuery.of(context).size.width > 600;
      
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.greenAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.greenAccent)),
            child: const Row(children: [Icon(Icons.check_circle, color: Colors.greenAccent), SizedBox(width: 12), Expanded(child: Text("ACTIVE CONTRACT. Upgrade your Venue to trigger a new Bidding War.", style: TextStyle(color: Colors.white)))]),
          ),
          const SizedBox(height: 20),
          if (!isDesktop) _buildActiveContractDetail(deal) else _buildNetworkListTile(deal, true),
        ],
      );
    }

    final asyncDeals = ref.watch(availableTvDealsProvider(gameState.venueLevel));
    return asyncDeals.when(
      loading: () => const Center(child: CircularProgressIndicator(color: Colors.amber)),
      error: (err, stack) => Center(child: Text('Error loading networks: $err', style: const TextStyle(color: Colors.red))),
      data: (deals) {
        if (deals.isEmpty) return const Center(child: Text("No networks found for this tier.", style: TextStyle(color: Colors.grey)));
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.amber)),
              child: const Row(children: [Icon(Icons.warning_amber_rounded, color: Colors.amber), SizedBox(width: 12), Expanded(child: Text("BIDDING WAR! The Rival promotion will take whichever network you leave behind.", style: TextStyle(color: Colors.white)))]),
            ),
            const SizedBox(height: 20),
            ...deals.map((deal) => _buildNetworkListTile(deal, false)).toList(),
          ],
        );
      },
    );
  }

  Widget _buildNetworkListTile(TvNetworkDeal deal, bool isActive) {
    bool isSelected = _selectedDeal?.id == deal.id;
    return GestureDetector(
      onTap: isActive ? null : () {
        HapticFeedback.selectionClick();
        setState(() => _selectedDeal = deal);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.05) : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.amber : (isActive ? Colors.greenAccent : Colors.white10), width: isSelected || isActive ? 2 : 1),
        ),
        child: Row(
          children: [
            _buildNetworkLogo(deal.networkName, size: 45),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(deal.networkName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text("Payout: \$${deal.weeklyPayout} / wk", style: const TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: isSelected ? Colors.amber : Colors.white24)
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------
  // CONTRACT PROPOSAL DETAILS (Right Pane / Mobile Modal)
  // ----------------------------------------------------------------
  Widget _buildContractProposal(TvNetworkDeal deal, GameNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildNetworkLogo(deal.networkName, size: 60),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("OFFICIAL PROPOSAL", style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                  const SizedBox(height: 4),
                  FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text(deal.networkName.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900))),
                ],
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Divider(color: Colors.white10, thickness: 2)),
        
        Text(deal.description, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5, fontStyle: FontStyle.italic)),
        const SizedBox(height: 30),

        _buildDetailRow(Icons.payments_rounded, "Weekly Rights Fee", "\$${deal.weeklyPayout}", Colors.greenAccent),
        const SizedBox(height: 20),
        _buildDetailRow(Icons.star_rounded, "Minimum Rating Target", "${deal.targetMinimumRating} Stars", Colors.amber),
        const SizedBox(height: 20),
        _buildDetailRow(Icons.percent_rounded, "PPV Buyrate Share", deal.cannibalizesPPVs ? "0% (Cannibalized)" : "${(deal.ppvBonusMultiplier * 100).toInt()}%", deal.cannibalizesPPVs ? Colors.redAccent : Colors.blueAccent),
        
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            icon: const Icon(Icons.edit_document),
            label: const FittedBox(fit: BoxFit.scaleDown, child: Text("SIGN EXCLUSIVE CONTRACT", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1.0))),
            onPressed: () {
              HapticFeedback.heavyImpact();
              notifier.signTvDeal(deal);
              setState(() => _selectedDeal = null);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signed with ${deal.networkName}!"), backgroundColor: Colors.green));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMobileContractDetailPane(GameState gameState) {
    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.amber, size: 20), onPressed: () => setState(() => _selectedDeal = null)),
                const Text("BACK TO OFFERS", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.45, 
                child: _buildContractProposal(_selectedDeal!, ref.read(gameProvider.notifier))
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveContractDetail(TvNetworkDeal deal) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.greenAccent.withOpacity(0.5), width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildNetworkLogo(deal.networkName, size: 50),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("ACTIVE BROADCAST PARTNER", style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text(deal.networkName.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(color: Colors.white10)),
          _buildDealStatRow("Weekly Payout:", "\$${deal.weeklyPayout}", Colors.greenAccent),
          _buildDealStatRow("Target Rating:", "${deal.targetMinimumRating} Stars", Colors.amber),
          _buildDealStatRow("PPV Terms:", deal.cannibalizesPPVs ? "Flat Fee (No Buyrates)" : "${deal.ppvBonusMultiplier}x Buyrate Cut", Colors.blueAccent),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------
  // TAB 2: PRODUCTION VALUES
  // ----------------------------------------------------------------
  Widget _buildProductionTab(GameState gameState) {
    final notifier = ref.read(gameProvider.notifier);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 20), 
          decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.blueAccent.withOpacity(0.3))),
          child: const Text("Upgrading Production Values increases your maximum Show Rating cap and generates a flat bonus to all matches. Note: Higher tiers require weekly maintenance fees!", style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.5)),
        ),
        _buildTechCard("BROADCAST & CAMERAS", "Unlocks higher show ratings. Required for top-tier TV networks.", gameState.techBroadcast, () => notifier.buyTechUpgrade("BROADCAST", _getTechCost(gameState.techBroadcast)), gameState.cash),
        _buildTechCard("STAGE & PYROTECHNICS", "Increases crowd energy and boosts the Match Rating of your openers.", gameState.techPyro, () => notifier.buyTechUpgrade("PYRO", _getTechCost(gameState.techPyro)), gameState.cash),
        _buildTechCard("MEDICAL & REHAB", "Reduces the severity of injuries and increases weekly stamina recovery.", gameState.techMedical, () => notifier.buyTechUpgrade("MEDICAL", _getTechCost(gameState.techMedical)), gameState.cash),
        const SizedBox(height: 40), // Bottom padding
      ],
    );
  }

  int _getTechCost(int currentLevel) {
    if (currentLevel == 1) return 25000;
    if (currentLevel == 2) return 100000;
    if (currentLevel == 3) return 500000;
    return 0; // Maxed out
  }

  Widget _buildTechCard(String title, String desc, int level, VoidCallback onUpgrade, int currentCash) {
    int cost = _getTechCost(level);
    bool canAfford = currentCash >= cost;
    bool isMaxed = level >= 4;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900)))),
              const SizedBox(width: 8),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(6)), child: Text("LVL $level", style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900, fontSize: 10))),
            ],
          ),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(color: Colors.white54, fontSize: 11, height: 1.4)),
          const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(color: Colors.white10)),
          isMaxed 
            ? const Center(child: Text("MAXIMUM LEVEL REACHED", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, letterSpacing: 1.0, fontSize: 11)))
            : Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text("Cost: \$${cost.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}", style: TextStyle(color: canAfford ? Colors.white : Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: canAfford ? Colors.blueAccent : Colors.grey.shade800),
                      onPressed: canAfford ? () {
                        HapticFeedback.lightImpact();
                        onUpgrade();
                      } : null,
                      child: FittedBox(fit: BoxFit.scaleDown, child: Text("UPGRADE", style: TextStyle(color: canAfford ? Colors.black : Colors.grey, fontWeight: FontWeight.bold, fontSize: 11))),
                    ),
                  )
                ],
              )
        ],
      ),
    );
  }

  // ----------------------------------------------------------------
  // TAB 3: BRANDING
  // ----------------------------------------------------------------
  Widget _buildBrandingTab(GameState gameState) {
    final notifier = ref.read(gameProvider.notifier);
    _tvNameController.text = gameState.tvShowName;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("WEEKLY TELEVISION", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 12)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _tvNameController,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  labelText: "TV Show Name",
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1A1A1A),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white10)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.amber)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              onPressed: () {
                HapticFeedback.selectionClick();
                notifier.renameTVShow(_tvNameController.text);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("TV Show Renamed!"), backgroundColor: Colors.green));
              },
              child: const Icon(Icons.save, color: Colors.black),
            )
          ],
        ),
        const SizedBox(height: 40),
        
        const Text("PREMIUM LIVE EVENTS", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 12)),
        const SizedBox(height: 6),
        const Text("Tap the number icon to assign your Premier Showcase for a massive revenue boost!", style: TextStyle(color: Colors.white54, fontSize: 11, fontStyle: FontStyle.italic)),
        const SizedBox(height: 16),
        
        ...List.generate(12, (index) {
          int month = index + 1;
          bool isPremier = index == gameState.premierPpvIndex;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A), 
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isPremier ? Colors.amber : Colors.transparent, width: isPremier ? 2 : 0),
            ),
            child: ListTile(
              leading: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  notifier.setPremierPpv(index);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${gameState.ppvNames[index]} is now your Premier Showcase!"), backgroundColor: Colors.amber));
                },
                child: CircleAvatar(
                  backgroundColor: isPremier ? Colors.amber : Colors.white10, 
                  child: isPremier ? const Icon(Icons.star, color: Colors.black, size: 20) : Text(month.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                ),
              ),
              title: FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text(gameState.ppvNames[index], style: TextStyle(color: isPremier ? Colors.amber : Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
              subtitle: isPremier ? const Text("PREMIER SHOWCASE (+50% REVENUE)", style: TextStyle(color: Colors.amberAccent, fontSize: 9, fontWeight: FontWeight.bold)) : null,
              trailing: IconButton(icon: const Icon(Icons.edit, color: Colors.grey, size: 20), onPressed: () => _showRenameDialog(context, index, gameState.ppvNames[index], notifier)),
            ),
          );
        }),
        const SizedBox(height: 40), // Bottom padding
      ],
    );
  }

  // --- HELPERS ---
  Widget _buildNetworkLogo(String networkName, {double size = 50}) {
    List<Color> palette = [Colors.blueAccent, Colors.redAccent, Colors.purpleAccent, Colors.tealAccent, Colors.orangeAccent, Colors.indigoAccent];
    Color bg = palette[networkName.length % palette.length];
    
    String init = networkName.substring(0, 1).toUpperCase();
    IconData icon = Icons.tv;
    if (networkName.toLowerCase().contains("action") || networkName.toLowerCase().contains("combat")) icon = Icons.bolt;
    if (networkName.toLowerCase().contains("stream") || networkName.toLowerCase().contains("flix")) icon = Icons.play_arrow_rounded;
    if (networkName.toLowerCase().contains("world") || networkName.toLowerCase().contains("global")) icon = Icons.public;

    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [bg, bg.withOpacity(0.5)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(size * 0.2),
        border: Border.all(color: Colors.white24, width: 2),
        boxShadow: [BoxShadow(color: bg.withOpacity(0.3), blurRadius: 8)],
      ),
      child: Stack(
        children: [
          Positioned(right: -size*0.2, bottom: -size*0.2, child: Icon(icon, size: size * 0.8, color: Colors.black26)),
          Center(child: Text(init, style: TextStyle(color: Colors.white, fontSize: size * 0.5, fontWeight: FontWeight.w900))),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 20)),
        const SizedBox(width: 16),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
        const Spacer(),
        Text(value, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w900, fontFamily: "Monospace")),
      ],
    );
  }

  Widget _buildDealStatRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.w900, fontSize: 14)),
        ],
      ),
    );
  }

  void _showRenameDialog(BuildContext context, int index, String currentName, GameNotifier notifier) {
    final TextEditingController dialogController = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.white24, width: 2)),
        title: const Text("RENAME EVENT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
        content: TextField(
          controller: dialogController, 
          style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18), 
          decoration: const InputDecoration(
            hintText: "Enter new event name",
            hintStyle: TextStyle(color: Colors.white30),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber))
          )
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
            onPressed: () {
              if (dialogController.text.isNotEmpty) {
                notifier.renamePPV(index, dialogController.text);
              }
              Navigator.pop(context);
            }, 
            child: const Text("SAVE", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0))
          ),
        ],
      ),
    );
  }
}