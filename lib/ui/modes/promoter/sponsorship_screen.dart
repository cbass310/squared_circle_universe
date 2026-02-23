import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/game_state_provider.dart';
import '../../../data/models/sponsorship_deal.dart';

class SponsorshipScreen extends ConsumerStatefulWidget {
  const SponsorshipScreen({super.key});

  @override
  ConsumerState<SponsorshipScreen> createState() => _SponsorshipScreenState();
}

class _SponsorshipScreenState extends ConsumerState<SponsorshipScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          title: const Text("CORPORATE SPONSORS", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0)),
          backgroundColor: Colors.transparent,
          bottom: const TabBar(
            indicatorColor: Colors.greenAccent,
            labelColor: Colors.greenAccent,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "RING INVENTORY"),
              Tab(text: "OPEN MARKET"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildInventoryTab(),
            _buildMarketTab(),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // --- TAB 1: PHYSICAL RING INVENTORY (WHAT IS SOLD?) ---
  // =========================================================================
  Widget _buildInventoryTab() {
    final gameState = ref.watch(gameProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(color: Colors.greenAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.greenAccent)),
          child: const Text("Sell physical space on your broadcast to corporate partners. Upgrade your Home Venue to unlock premium real estate!", style: TextStyle(color: Colors.white70)),
        ),
        
        _buildRealEstateSlot(
          title: "TURNBUCKLE PADS",
          slot: RealEstateSlot.turnbuckle,
          isUnlocked: true, // Always unlocked
          gameState: gameState,
        ),
        
        _buildRealEstateSlot(
          title: "RING CANVAS",
          slot: RealEstateSlot.canvas,
          isUnlocked: gameState.venueLevel >= 2, // Civic Center or higher
          unlockRequirement: "Requires Level 2 Venue (Civic Center)",
          gameState: gameState,
        ),

        _buildRealEstateSlot(
          title: "EVENT NAMING RIGHTS",
          slot: RealEstateSlot.eventName,
          isUnlocked: gameState.venueLevel >= 3, // Arena or higher
          unlockRequirement: "Requires Level 3 Venue (Arena)",
          gameState: gameState,
        ),
      ],
    );
  }

  Widget _buildRealEstateSlot({required String title, required RealEstateSlot slot, required bool isUnlocked, String? unlockRequirement, required GameState gameState}) {
    // Find if a sponsor occupies this slot
    final activeDeal = gameState.activeSponsors.where((s) => s.slotTarget == slot).firstOrNull;

    if (!isUnlocked) {
      return _buildLockedSlot(title, unlockRequirement!);
    }

    if (activeDeal == null) {
      return _buildEmptySlot(title);
    }

    return _buildOccupiedSlot(title, activeDeal);
  }

  Widget _buildLockedSlot(String title, String requirement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lock, color: Colors.grey, size: 20),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(requirement, style: const TextStyle(color: Colors.redAccent, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _buildEmptySlot(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white24, style: BorderStyle.solid)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("AVAILABLE REAL ESTATE", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
          const Text("Check the Open Market tab to sign a partner.", style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildOccupiedSlot(String title, SponsorshipDeal deal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(8), border: Border.all(color: _getArchetypeColor(deal.archetype), width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: _getArchetypeColor(deal.archetype).withOpacity(0.2), borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6))),
            child: Text("$title - SOLD", style: TextStyle(color: _getArchetypeColor(deal.archetype), fontWeight: FontWeight.bold, letterSpacing: 1.0)),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(deal.sponsorName, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                Text("${deal.weeksLeft} Weeks Remaining", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const Divider(color: Colors.white10, height: 30),
                _buildDealDetailRow("Weekly Payout:", "\$${deal.weeklyPayout}", Colors.green),
                if (deal.archetype == SponsorArchetype.performance)
                  _buildDealDetailRow("Performance Bonus (${deal.performanceBonusThreshold}⭐):", "+\$${deal.performanceBonusAmount}", Colors.amber),
                if (deal.archetype == SponsorArchetype.consistency)
                  const Text("WARNING: Contract voids if show rating drops below 2.5 Stars.", style: TextStyle(color: Colors.redAccent, fontSize: 11, fontStyle: FontStyle.italic)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // =========================================================================
  // --- TAB 2: OPEN MARKET (BIDDING WAR) ---
  // =========================================================================
  Widget _buildMarketTab() {
    final gameState = ref.watch(gameProvider);
    final notifier = ref.read(gameProvider.notifier);

    if (gameState.availableOffers.isEmpty) {
      return const Center(child: Text("No corporate sponsors are currently bidding.", style: TextStyle(color: Colors.grey)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: gameState.availableOffers.length,
      itemBuilder: (context, index) {
        final deal = gameState.availableOffers[index];
        
        // Determine if player has the required venue level for this slot
        bool hasVenueLevel = true;
        if (deal.slotTarget == RealEstateSlot.canvas && gameState.venueLevel < 2) hasVenueLevel = false;
        if (deal.slotTarget == RealEstateSlot.eventName && gameState.venueLevel < 3) hasVenueLevel = false;

        // Determine if slot is already full
        bool slotTaken = gameState.activeSponsors.any((s) => s.slotTarget == deal.slotTarget);

        return _buildOfferCard(deal, notifier, hasVenueLevel, slotTaken);
      },
    );
  }

  Widget _buildOfferCard(SponsorshipDeal deal, dynamic notifier, bool hasVenueLevel, bool slotTaken) {
    bool canSign = hasVenueLevel && !slotTaken;

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
              Text(deal.sponsorName, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              _buildArchetypeBadge(deal.archetype),
            ],
          ),
          const SizedBox(height: 4),
          Text("Target Real Estate: ${_getSlotName(deal.slotTarget)}", style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(deal.description, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const Divider(color: Colors.white10, height: 30),
          
          if (deal.upfrontBonus > 0) _buildDealDetailRow("Signing Bonus (Upfront):", "\$${deal.upfrontBonus}", Colors.greenAccent),
          _buildDealDetailRow("Weekly Base Pay:", "\$${deal.weeklyPayout}", Colors.green),
          if (deal.archetype == SponsorArchetype.performance) _buildDealDetailRow("Main Event Bonus (${deal.performanceBonusThreshold}⭐):", "+\$${deal.performanceBonusAmount}", Colors.amberAccent),
          
          const SizedBox(height: 16),
          
          if (!hasVenueLevel)
            const Center(child: Text("VENUE LEVEL TOO LOW", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)))
          else if (slotTaken)
            const Center(child: Text("SLOT ALREADY SOLD", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)))
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent, foregroundColor: Colors.black),
                onPressed: () {
                  notifier.signSponsor(deal);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signed ${deal.sponsorName}!")));
                },
                child: const Text("SIGN CONTRACT", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
        ],
      ),
    );
  }

  // --- HELPERS ---

  Widget _buildDealDetailRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildArchetypeBadge(SponsorArchetype type) {
    Color bg;
    String label;
    if (type == SponsorArchetype.consistency) { bg = Colors.blue; label = "CONSISTENCY"; }
    else if (type == SponsorArchetype.performance) { bg = Colors.orange; label = "PERFORMANCE"; }
    else { bg = Colors.green; label = "UPFRONT CASH"; }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg.withOpacity(0.2), borderRadius: BorderRadius.circular(4), border: Border.all(color: bg)),
      child: Text(label, style: TextStyle(color: bg, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Color _getArchetypeColor(SponsorArchetype type) {
    if (type == SponsorArchetype.consistency) return Colors.blueAccent;
    if (type == SponsorArchetype.performance) return Colors.orangeAccent;
    return Colors.greenAccent;
  }

  String _getSlotName(RealEstateSlot slot) {
    if (slot == RealEstateSlot.turnbuckle) return "Turnbuckle Pads";
    if (slot == RealEstateSlot.canvas) return "Ring Canvas";
    return "Event Naming Rights";
  }
}