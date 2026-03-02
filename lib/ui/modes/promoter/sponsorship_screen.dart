import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/game_state_provider.dart';
import '../../../data/models/sponsorship_deal.dart';

// --- IMPORT FOR THE WATERMARK ---
import '../../components/tv_watermark.dart';

class SponsorshipScreen extends ConsumerStatefulWidget {
  const SponsorshipScreen({super.key});

  @override
  ConsumerState<SponsorshipScreen> createState() => _SponsorshipScreenState();
}

class _SponsorshipScreenState extends ConsumerState<SponsorshipScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;
    final gameState = ref.watch(gameProvider);
    final notifier = ref.read(gameProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: isDesktop
            ? Row(
                children: [
                  Expanded(flex: 4, child: _buildLeftDashboard(gameState, notifier, isDesktop)),
                  Expanded(flex: 6, child: _buildRightArtworkPane(isMobile: false)),
                ],
              )
            : Column(
                children: [
                  Expanded(flex: 4, child: _buildRightArtworkPane(isMobile: true)),
                  Expanded(flex: 6, child: _buildLeftDashboard(gameState, notifier, isDesktop)),
                ],
              ),
      ),
    );
  }

  Widget _buildLeftDashboard(GameState gameState, GameNotifier notifier, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        border: isDesktop ? const Border(right: BorderSide(color: Colors.black, width: 3)) : const Border(top: BorderSide(color: Colors.black, width: 3)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.amber, size: 20), onPressed: () => Navigator.pop(context)),
                const SizedBox(width: 8),
                const Text("CORPORATE PARTNERS", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5)),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black, width: 3)), 
              color: Color(0xFF121212),
            ),
            child: TabBar(
              dividerColor: Colors.transparent, 
              controller: _tabController,
              indicatorColor: Colors.amber,
              indicatorWeight: 3,
              labelColor: Colors.amber,
              unselectedLabelColor: Colors.white54,
              labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.5),
              tabs: const [
                Tab(text: "RING INVENTORY"),
                Tab(text: "OPEN MARKET"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildInventoryTab(gameState),
                _buildMarketTab(gameState, notifier),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightArtworkPane({bool isMobile = false}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/images/sponsor_background.png", 
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (c, e, s) => Image.asset("assets/images/office_background.png", fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(color: const Color(0xFF0A0A0A))),
        ),
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
        TVWatermark(isMobile: isMobile),
      ],
    );
  }

  Widget _buildInventoryTab(GameState gameState) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(color: Colors.greenAccent.withOpacity(0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.greenAccent.withOpacity(0.3))),
          child: Row(
            children: const [
              Icon(Icons.info_outline, color: Colors.greenAccent, size: 20),
              SizedBox(width: 12),
              Expanded(child: Text("Sell physical space on your broadcast to corporate partners. Upgrade your Home Venue to unlock premium real estate!", style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.5))),
            ],
          ),
        ),
        
        _buildRealEstateSlot(
          title: "TURNBUCKLE PADS",
          slot: RealEstateSlot.turnbuckle,
          isUnlocked: true, 
          gameState: gameState,
        ),
        
        _buildRealEstateSlot(
          title: "RING CANVAS",
          slot: RealEstateSlot.canvas,
          isUnlocked: gameState.venueLevel >= 2, 
          unlockRequirement: "REQUIRES LEVEL 2 VENUE (CIVIC CENTER)",
          gameState: gameState,
        ),

        _buildRealEstateSlot(
          title: "EVENT NAMING RIGHTS",
          slot: RealEstateSlot.eventName,
          isUnlocked: gameState.venueLevel >= 3, 
          unlockRequirement: "REQUIRES LEVEL 3 VENUE (ARENA)",
          gameState: gameState,
        ),

        // 🚨 NEW LEVEL 4 SLOT ADDED HERE 🚨
        _buildRealEstateSlot(
          title: "TITANTRON BRANDING",
          slot: RealEstateSlot.titantron,
          isUnlocked: gameState.venueLevel >= 4, 
          unlockRequirement: "REQUIRES LEVEL 4 VENUE (STADIUM)",
          gameState: gameState,
        ),
      ],
    );
  }

  Widget _buildRealEstateSlot({required String title, required RealEstateSlot slot, required bool isUnlocked, String? unlockRequirement, required GameState gameState}) {
    final activeDeal = gameState.activeSponsors.where((s) => s.slotTarget == slot).firstOrNull;
    if (!isUnlocked) return _buildLockedSlot(title, unlockRequirement!);
    if (activeDeal == null) return _buildEmptySlot(title);
    return _buildOccupiedSlot(title, activeDeal);
  }

  Widget _buildLockedSlot(String title, String requirement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF151515), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lock, color: Colors.white24, size: 20),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(color: Colors.white30, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
            ],
          ),
          const SizedBox(height: 8),
          Text(requirement, style: const TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildEmptySlot(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
          const SizedBox(height: 8),
          const Text("AVAILABLE REAL ESTATE", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1.0)),
          const SizedBox(height: 4),
          const Text("Check the Open Market tab to sign a partner.", style: TextStyle(color: Colors.white54, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildOccupiedSlot(String title, SponsorshipDeal deal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.greenAccent, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Colors.greenAccent.withOpacity(0.15), borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
            child: Text("$title - SOLD", style: const TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(deal.sponsorName.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                    _buildArchetypeBadge(deal.archetype),
                  ],
                ),
                const SizedBox(height: 4),
                Text("${deal.weeksLeft} WEEKS REMAINING", style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                const Divider(color: Colors.white10, height: 30, thickness: 2),
                
                _buildDealDetailRow("WEEKLY PAYOUT", "\$${deal.weeklyPayout}", Colors.greenAccent),
                if (deal.archetype == SponsorArchetype.performance)
                  _buildDealDetailRow("PERFORMANCE BONUS (${deal.performanceBonusThreshold}⭐)", "+\$${deal.performanceBonusAmount}", Colors.amber),
                if (deal.archetype == SponsorArchetype.consistency)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text("WARNING: Contract voids if show rating drops below 2.5 Stars.", style: TextStyle(color: Colors.redAccent, fontSize: 10, fontStyle: FontStyle.italic)),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMarketTab(GameState gameState, GameNotifier notifier) {
    if (gameState.availableOffers.isEmpty) {
      return const Center(child: Text("No corporate sponsors are currently bidding.", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: gameState.availableOffers.length,
      itemBuilder: (context, index) {
        final deal = gameState.availableOffers[index];
        
        bool hasVenueLevel = true;
        if (deal.slotTarget == RealEstateSlot.canvas && gameState.venueLevel < 2) hasVenueLevel = false;
        if (deal.slotTarget == RealEstateSlot.eventName && gameState.venueLevel < 3) hasVenueLevel = false;
        if (deal.slotTarget == RealEstateSlot.titantron && gameState.venueLevel < 4) hasVenueLevel = false; // 🚨 LEVEL 4 CHECK ADDED

        bool slotTaken = gameState.activeSponsors.any((s) => s.slotTarget == deal.slotTarget);

        return _buildOfferCard(deal, notifier, hasVenueLevel, slotTaken);
      },
    );
  }

  Widget _buildOfferCard(SponsorshipDeal deal, GameNotifier notifier, bool hasVenueLevel, bool slotTaken) {
    bool canSign = hasVenueLevel && !slotTaken;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(deal.sponsorName.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.0))),
              _buildArchetypeBadge(deal.archetype),
            ],
          ),
          const SizedBox(height: 8),
          Text("TARGET REAL ESTATE: ${_getSlotName(deal.slotTarget).toUpperCase()}", style: const TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
          const SizedBox(height: 8),
          Text(deal.description, style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.5)),
          const Divider(color: Colors.white10, height: 30, thickness: 2),
          
          if (deal.upfrontBonus > 0) _buildDealDetailRow("SIGNING BONUS (UPFRONT)", "\$${deal.upfrontBonus}", Colors.greenAccent),
          _buildDealDetailRow("WEEKLY BASE PAY", "\$${deal.weeklyPayout}", Colors.white),
          if (deal.archetype == SponsorArchetype.performance) _buildDealDetailRow("MAIN EVENT BONUS (${deal.performanceBonusThreshold}⭐)", "+\$${deal.performanceBonusAmount}", Colors.greenAccent),
          
          const SizedBox(height: 20),
          
          if (!hasVenueLevel)
            Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(6)), child: const Center(child: Text("VENUE LEVEL TOO LOW", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.0))))
          else if (slotTaken)
            Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(6)), child: const Center(child: Text("SLOT ALREADY SOLD", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.0))))
          else
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                onPressed: () {
                  notifier.signSponsor(deal);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signed ${deal.sponsorName}!"), backgroundColor: Colors.green));
                },
                child: const Text("SIGN CONTRACT", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0, fontSize: 12)),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildDealDetailRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
          Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.w900, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildArchetypeBadge(SponsorArchetype type) {
    Color bg;
    String label;
    if (type == SponsorArchetype.consistency) { bg = Colors.blueAccent; label = "CONSISTENCY"; }
    else if (type == SponsorArchetype.performance) { bg = Colors.orangeAccent; label = "PERFORMANCE"; }
    else { bg = Colors.greenAccent; label = "UPFRONT CASH"; }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg.withOpacity(0.15), borderRadius: BorderRadius.circular(4), border: Border.all(color: bg, width: 1.5)),
      child: Text(label, style: TextStyle(color: bg, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
    );
  }

  String _getSlotName(RealEstateSlot slot) {
    if (slot == RealEstateSlot.turnbuckle) return "Turnbuckle Pads";
    if (slot == RealEstateSlot.canvas) return "Ring Canvas";
    if (slot == RealEstateSlot.eventName) return "Event Naming Rights";
    return "Titantron Branding"; // 🚨 NEW NAME TRANSLATION ADDED
  }
}