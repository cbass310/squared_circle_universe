import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../logic/game_state_provider.dart';
import '../../../data/models/tv_network_deal.dart';

// Dynamically fetches the networks that match your current Venue Tier
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

  @override
  void dispose() {
    _tvNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          title: const Text("BROADCASTING HUB", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0)),
          backgroundColor: Colors.transparent,
          bottom: const TabBar(
            indicatorColor: Colors.amber,
            labelColor: Colors.amber,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "CONTRACTS"),
              Tab(text: "PRODUCTION"),
              Tab(text: "BRANDING"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildContractsTab(),
            _buildProductionTab(),
            _buildBrandingTab(),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // --- TAB 1: THE RATINGS WAR & CONTRACTS ---
  // =========================================================================
  Widget _buildContractsTab() {
    final gameState = ref.watch(gameProvider);
    final gameNotifier = ref.read(gameProvider.notifier);

    if (!gameState.isBiddingWarActive && gameState.activeTvDeal != null) {
      final deal = gameState.activeTvDeal!;
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("CURRENT BROADCASTING PARTNER", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withOpacity(0.5), width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(deal.networkName.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(deal.description, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  const Divider(color: Colors.white24, height: 30),
                  _buildDealStatRow("Weekly Payout:", "\$${deal.weeklyPayout}", Colors.greenAccent),
                  _buildDealStatRow("Target Rating:", "${deal.targetMinimumRating} Stars", Colors.amber),
                  _buildDealStatRow("PPV Terms:", deal.cannibalizesPPVs ? "Flat Fee (No Buyrates)" : "${deal.ppvBonusMultiplier}x Buyrate Cut", Colors.blueAccent),
                ],
              ),
            ),
            const Spacer(),
            const Center(
              child: Text("Your contract is currently active. Upgrade your Venue to trigger a new Bidding War!", 
                textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            )
          ],
        ),
      );
    }

    // ACTIVE BIDDING WAR UI
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
              decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.redAccent)),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                  SizedBox(width: 12),
                  Expanded(child: Text("BIDDING WAR ACTIVE! Choose your broadcasting partner carefully. The Rival promotion will take whichever network you leave behind.", style: TextStyle(color: Colors.white))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ...deals.map((deal) => _buildDealOfferCard(deal, gameNotifier)).toList(),
          ],
        );
      },
    );
  }

  Widget _buildDealOfferCard(TvNetworkDeal deal, GameNotifier notifier) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(deal.networkName, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(deal.description, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const Divider(color: Colors.white10, height: 24),
          _buildDealStatRow("Weekly Payout:", "\$${deal.weeklyPayout}", Colors.green),
          _buildDealStatRow("Target Minimum Rating:", "${deal.targetMinimumRating} Stars", Colors.amber),
          _buildDealStatRow("PPV Buyrate Share:", deal.cannibalizesPPVs ? "0% (Cannibalized)" : "${(deal.ppvBonusMultiplier * 100).toInt()}%", deal.cannibalizesPPVs ? Colors.redAccent : Colors.blueAccent),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
              onPressed: () => notifier.signTvDeal(deal),
              child: const Text("SIGN EXCLUSIVE CONTRACT", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDealStatRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  // =========================================================================
  // --- TAB 2: PRODUCTION VALUES (PYRO PAGE) ---
  // =========================================================================
  Widget _buildProductionTab() {
    final gameState = ref.watch(gameProvider);
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
        _buildTechCard(
          "BROADCAST & CAMERAS", 
          "Unlocks higher show ratings. Required for top-tier TV networks.", 
          gameState.techBroadcast, 
          () => notifier.buyTechUpgrade("BROADCAST", _getTechCost(gameState.techBroadcast)), 
          gameState.cash
        ),
        _buildTechCard(
          "STAGE & PYROTECHNICS", 
          "Increases crowd energy and boosts the Match Rating of your openers.", 
          gameState.techPyro, 
          () => notifier.buyTechUpgrade("PYRO", _getTechCost(gameState.techPyro)), 
          gameState.cash
        ),
        _buildTechCard(
          "MEDICAL & REHAB", 
          "Reduces the severity of injuries and increases weekly stamina recovery.", 
          gameState.techMedical, 
          () => notifier.buyTechUpgrade("MEDICAL", _getTechCost(gameState.techMedical)), 
          gameState.cash
        ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text("LVL $level", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 6),
          Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 16),
          isMaxed 
            ? const Center(child: Text("MAXIMUM LEVEL REACHED", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, letterSpacing: 1.0)))
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Upgrade Cost: \$${cost.toString()}", style: TextStyle(color: canAfford ? Colors.white : Colors.redAccent, fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: canAfford ? Colors.amber : Colors.grey.shade800),
                    onPressed: canAfford ? onUpgrade : null,
                    child: Text("UPGRADE", style: TextStyle(color: canAfford ? Colors.black : Colors.grey)),
                  )
                ],
              )
        ],
      ),
    );
  }

  // =========================================================================
  // --- TAB 3: SHOW MANAGEMENT (BRANDING) ---
  // =========================================================================
  Widget _buildBrandingTab() {
    final gameState = ref.watch(gameProvider);
    final notifier = ref.read(gameProvider.notifier);
    _tvNameController.text = gameState.tvShowName;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("WEEKLY TELEVISION", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
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
                  fillColor: const Color(0xFF1E1E1E),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, padding: const EdgeInsets.symmetric(vertical: 20)),
              onPressed: () {
                notifier.renameTVShow(_tvNameController.text);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("TV Show Renamed!")));
              },
              child: const Icon(Icons.save, color: Colors.white),
            )
          ],
        ),
        const SizedBox(height: 30),
        
        // --- NEW WRESTLEMANIA INSTRUCTIONS ---
        const Text("PREMIUM LIVE EVENTS (PPVS)", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
        const Text("Tap the number icon to assign your Premier Showcase (WrestleMania) for a 50% revenue boost!", style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic)),
        const SizedBox(height: 10),
        
        // --- NEW DYNAMIC LIST ---
        ...List.generate(12, (index) {
          int month = index + 1;
          bool isPremier = index == gameState.premierPpvIndex; // Check if this is the Big One!

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E), 
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isPremier ? Colors.amber : Colors.transparent, width: isPremier ? 2 : 0),
            ),
            child: ListTile(
              leading: GestureDetector(
                onTap: () {
                  notifier.setPremierPpv(index);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("${gameState.ppvNames[index]} is now your Premier Showcase!"),
                    backgroundColor: Colors.amber,
                  ));
                },
                child: CircleAvatar(
                  backgroundColor: isPremier ? Colors.amber : Colors.white10, 
                  child: isPremier 
                    ? const Icon(Icons.star, color: Colors.black, size: 20)
                    : Text(month.toString(), style: const TextStyle(color: Colors.white))
                ),
              ),
              title: Text(
                gameState.ppvNames[index], 
                style: TextStyle(color: isPremier ? Colors.amber : Colors.white, fontWeight: FontWeight.bold)
              ),
              subtitle: isPremier ? const Text("PREMIER SHOWCASE (+50% REVENUE)", style: TextStyle(color: Colors.amberAccent, fontSize: 10, fontWeight: FontWeight.bold)) : null,
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.grey),
                onPressed: () => _showRenameDialog(context, index, gameState.ppvNames[index], notifier),
              ),
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
        title: const Text("Rename PPV", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: dialogController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(hintText: "Enter new name", hintStyle: TextStyle(color: Colors.grey)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL", style: TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () {
              notifier.renamePPV(index, dialogController.text);
              Navigator.pop(context);
            }, 
            child: const Text("SAVE", style: TextStyle(color: Colors.amber))
          ),
        ],
      ),
    );
  }
}