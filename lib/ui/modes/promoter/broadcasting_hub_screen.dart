import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../logic/game_state_provider.dart';
import '../../../data/models/tv_network_deal.dart';

final availableTvDealsProvider = FutureProvider.family<List<TvNetworkDeal>, int>((ref, tier) async {
  final isar = Isar.getInstance();
  if (isar == null) return [];
  return await isar.tvNetworkDeals.filter().tierLevelEqualTo(tier).findAll();
});

class BroadcastingHubScreen extends ConsumerStatefulWidget {
  const BroadcastingHubScreen({super.key});

  @override
  ConsumerState<BroadcastingHubScreen> createState() => _BroadcastingHubScreenState();
}

class _BroadcastingHubScreenState extends ConsumerState<BroadcastingHubScreen> {
  final TextEditingController _tvNameController = TextEditingController();
  
  int _selectedTabIndex = 0;
  TvNetworkDeal? _selectedDeal;

  @override
  void dispose() {
    _tvNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;
    final gameState = ref.watch(gameProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: isDesktop
            ? Row(
                children: [
                  Expanded(flex: 4, child: _buildLeftColumn(gameState, isDesktop)),
                  Expanded(flex: 6, child: _buildRightColumn(gameState)),
                ],
              )
            : _selectedTabIndex == 0 && _selectedDeal != null
                ? _buildMobileContractDetailPane(gameState)
                : _buildLeftColumn(gameState, isDesktop),
      ),
    );
  }

  // ----------------------------------------------------------------
  // WIDGET: LEFT COLUMN
  // ----------------------------------------------------------------
  Widget _buildLeftColumn(GameState gameState, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        border: isDesktop ? const Border(right: BorderSide(color: Colors.white10, width: 2)) : null,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.amber, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                const Text("BROADCASTING", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white10))),
            child: Row(
              children: [
                _buildTab(0, "CONTRACTS"),
                _buildTab(1, "PRODUCTION"),
                _buildTab(2, "BRANDING"),
              ],
            ),
          ),
          Expanded(
            child: _selectedTabIndex == 0 
                ? _buildContractsList(gameState)
                : _selectedTabIndex == 1
                    ? _buildProductionTab(gameState)
                    : _buildBrandingTab(gameState),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String title) {
    bool isSelected = _selectedTabIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
            _selectedDeal = null; 
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: isSelected ? Colors.amber : Colors.transparent, width: 3))),
          child: Center(
            child: Text(title, style: TextStyle(color: isSelected ? Colors.amber : Colors.grey, fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold, fontSize: 11, letterSpacing: 1.0)),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------
  // RIGHT COLUMN: IMMERSIVE IMAGES & CONTRACT PANE
  // ----------------------------------------------------------------
  Widget _buildRightColumn(GameState gameState) {
    // 📸 NEW IMMERSIVE IMAGE DISPLAY FOR TABS 2 & 3
    if (_selectedTabIndex != 0) {
      String imagePath = _selectedTabIndex == 1 ? "assets/images/production_bg.png" : "assets/images/branding_bg.png";
      String titleText = _selectedTabIndex == 1 ? "PRODUCTION & EQUIPMENT" : "BRANDING & EVENTS";
      
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            imagePath, 
            fit: BoxFit.cover, 
            // Fallback to office if you haven't loaded the production/branding images yet
            errorBuilder: (c, e, s) => Image.asset("assets/images/office_bg.png", fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: const Color(0xFF0A0A0A))),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.black.withOpacity(0.4), Colors.transparent], 
                begin: Alignment.centerLeft, 
                end: Alignment.centerRight, 
                stops: const [0.0, 0.3, 1.0]
              )
            )
          ),
          // Sleek subtle label in the bottom right
          Positioned(
            bottom: 40, right: 40,
            child: Text(titleText, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
          ),
        ],
      );
    }

    if (!gameState.isBiddingWarActive && gameState.activeTvDeal != null) {
      return Container(color: Colors.black, padding: const EdgeInsets.all(40), child: _buildActiveContractDetail(gameState.activeTvDeal!));
    }

    if (_selectedDeal == null) {
      return Container(color: Colors.black, child: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.handshake_rounded, color: Colors.white10, size: 80), SizedBox(height: 16), Text("SELECT A NETWORK OFFER", style: TextStyle(color: Colors.white30, fontWeight: FontWeight.bold, letterSpacing: 2.0))])));
    }

    return Container(color: Colors.black, padding: const EdgeInsets.all(40.0), child: _buildContractProposal(_selectedDeal!, ref.read(gameProvider.notifier)));
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
              child: _buildContractProposal(_selectedDeal!, ref.read(gameProvider.notifier)),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------
  // UI LOGIC: DYNAMIC LOGO GENERATOR
  // ----------------------------------------------------------------
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

  // ----------------------------------------------------------------
  // TAB 1: CONTRACTS LIST 
  // ----------------------------------------------------------------
  Widget _buildContractsList(GameState gameState) {
    if (!gameState.isBiddingWarActive && gameState.activeTvDeal != null) {
      final deal = gameState.activeTvDeal!;
      bool isDesktop = MediaQuery.of(context).size.width > 800;
      
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
      onTap: isActive ? null : () => setState(() => _selectedDeal = deal),
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
                  Text(deal.networkName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text("Payout: \$${deal.weeklyPayout} / wk", style: const TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)),
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
  // RIGHT PANE: CONTRACT PROPOSAL DETAILS
  // ----------------------------------------------------------------
  Widget _buildContractProposal(TvNetworkDeal deal, GameNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildNetworkLogo(deal.networkName, size: 80),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("OFFICIAL PROPOSAL", style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                  const SizedBox(height: 4),
                  Text(deal.networkName.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 30), child: Divider(color: Colors.white10, thickness: 2)),
        
        Text(deal.description, style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5, fontStyle: FontStyle.italic)),
        const SizedBox(height: 40),

        _buildDetailRow(Icons.payments_rounded, "Weekly Rights Fee", "\$${deal.weeklyPayout}", Colors.greenAccent),
        const SizedBox(height: 20),
        _buildDetailRow(Icons.star_rounded, "Minimum Rating Target", "${deal.targetMinimumRating} Stars", Colors.amber),
        const SizedBox(height: 20),
        _buildDetailRow(Icons.percent_rounded, "PPV Buyrate Share", deal.cannibalizesPPVs ? "0% (Cannibalized)" : "${(deal.ppvBonusMultiplier * 100).toInt()}%", deal.cannibalizesPPVs ? Colors.redAccent : Colors.blueAccent),
        
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            icon: const Icon(Icons.edit_document),
            label: const Text("SIGN EXCLUSIVE CONTRACT", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.0)),
            onPressed: () {
              notifier.signTvDeal(deal);
              setState(() => _selectedDeal = null);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signed with ${deal.networkName}!"), backgroundColor: Colors.green));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActiveContractDetail(TvNetworkDeal deal) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.greenAccent.withOpacity(0.5), width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildNetworkLogo(deal.networkName, size: 60),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("ACTIVE BROADCAST PARTNER", style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    Text(deal.networkName.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Divider(color: Colors.white10)),
          _buildDealStatRow("Weekly Payout:", "\$${deal.weeklyPayout}", Colors.greenAccent),
          _buildDealStatRow("Target Rating:", "${deal.targetMinimumRating} Stars", Colors.amber),
          _buildDealStatRow("PPV Terms:", deal.cannibalizesPPVs ? "Flat Fee (No Buyrates)" : "${deal.ppvBonusMultiplier}x Buyrate Cut", Colors.blueAccent),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 24)),
        const SizedBox(width: 16),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold)),
        const Spacer(),
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w900, fontFamily: "Monospace")),
      ],
    );
  }

  Widget _buildDealStatRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.w900, fontSize: 16)),
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
          decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.blueAccent)),
          child: const Text("Upgrading Production Values increases your maximum Show Rating cap and generates a flat bonus to all matches. Note: Higher tiers require weekly maintenance fees!", style: TextStyle(color: Colors.white70)),
        ),
        _buildTechCard("BROADCAST & CAMERAS", "Unlocks higher show ratings. Required for top-tier TV networks.", gameState.techBroadcast, () => notifier.buyTechUpgrade("BROADCAST", _getTechCost(gameState.techBroadcast)), gameState.cash),
        _buildTechCard("STAGE & PYROTECHNICS", "Increases crowd energy and boosts the Match Rating of your openers.", gameState.techPyro, () => notifier.buyTechUpgrade("PYRO", _getTechCost(gameState.techPyro)), gameState.cash),
        _buildTechCard("MEDICAL & REHAB", "Reduces the severity of injuries and increases weekly stamina recovery.", gameState.techMedical, () => notifier.buyTechUpgrade("MEDICAL", _getTechCost(gameState.techMedical)), gameState.cash),
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
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(6)), child: Text("LVL $level", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.w900, fontSize: 12))),
            ],
          ),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4)),
          const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(color: Colors.white10)),
          isMaxed 
            ? const Center(child: Text("MAXIMUM LEVEL REACHED", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, letterSpacing: 1.0)))
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Upgrade Cost: \$${cost.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}", style: TextStyle(color: canAfford ? Colors.white : Colors.redAccent, fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: canAfford ? Colors.amber : Colors.grey.shade800),
                    onPressed: canAfford ? onUpgrade : null,
                    child: Text("UPGRADE", style: TextStyle(color: canAfford ? Colors.black : Colors.grey, fontWeight: FontWeight.bold)),
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
        const Text("WEEKLY TELEVISION", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _tvNameController,
                style: const TextStyle(color: Colors.white),
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              onPressed: () {
                notifier.renameTVShow(_tvNameController.text);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("TV Show Renamed!"), backgroundColor: Colors.green));
              },
              child: const Icon(Icons.save, color: Colors.white),
            )
          ],
        ),
        const SizedBox(height: 40),
        
        const Text("PREMIUM LIVE EVENTS", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        const SizedBox(height: 6),
        const Text("Tap the number icon to assign your Premier Showcase (WrestleMania) for a massive revenue boost!", style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic)),
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
                  notifier.setPremierPpv(index);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${gameState.ppvNames[index]} is now your Premier Showcase!"), backgroundColor: Colors.amber));
                },
                child: CircleAvatar(
                  backgroundColor: isPremier ? Colors.amber : Colors.white10, 
                  child: isPremier ? const Icon(Icons.star, color: Colors.black, size: 20) : Text(month.toString(), style: const TextStyle(color: Colors.white))
                ),
              ),
              title: Text(gameState.ppvNames[index], style: TextStyle(color: isPremier ? Colors.amber : Colors.white, fontWeight: FontWeight.bold)),
              subtitle: isPremier ? const Text("PREMIER SHOWCASE (+50% REVENUE)", style: TextStyle(color: Colors.amberAccent, fontSize: 10, fontWeight: FontWeight.bold)) : null,
              trailing: IconButton(icon: const Icon(Icons.edit, color: Colors.grey), onPressed: () => _showRenameDialog(context, index, gameState.ppvNames[index], notifier)),
            ),
          );
        })
      ],
    );
  }

  void _showRenameDialog(BuildContext context, int index, String currentName, GameNotifier notifier) {
    final TextEditingController dialogController = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("Rename Event", style: TextStyle(color: Colors.white)),
        content: TextField(controller: dialogController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL", style: TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () {
              notifier.renamePPV(index, dialogController.text);
              Navigator.pop(context);
            }, 
            child: const Text("SAVE", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))
          ),
        ],
      ),
    );
  }
}