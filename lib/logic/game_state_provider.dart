import 'dart:math'; 
import 'package:flutter/material.dart'; // 🚨 Added for IconData
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; 

import '../data/models/wrestler.dart';
import '../data/models/match.dart';
import '../data/models/show_history.dart';
import '../data/models/game_save.dart'; 
import '../data/models/tv_network_deal.dart'; 
import '../data/models/sponsorship_deal.dart'; 
import '../data/models/financial_record.dart'; 
import '../data/models/news_item.dart';
import '../data/models/rivalry.dart'; 
import '../data/models/milestone.dart'; // 🚨 NEW: Trophy Data Model

import 'rival_provider.dart'; 
import 'promoter_provider.dart'; 
import 'settings_provider.dart'; 

@Embedded()
class FinancialEntry {
  int week = 1;
  int year = 1;
  int incomeTickets = 0;
  int incomeMerch = 0;
  int incomeSponsors = 0;
  int incomeTvDeal = 0; 
  int expenseSalaries = 0;
  int expenseProduction = 0;
  int expenseRent = 0;
  int profit = 0;
  double showRating = 0.0;
  double rivalRating = 0.0; 
  String warResult = "DRAW"; 
}

class GameState {
  final String promotionName;
  final String tvShowName;
  final int cash;
  final int fans;
  final int reputation;
  final int week;
  final int year;
  final List<Match> currentCard;
  final List<bool> titleMatchFlags; 
  final List<FinancialEntry> ledger;
  final List<String> ppvNames;
  final List<String> venueCustomNames; 
  
  final List<SponsorshipDeal> activeSponsors;
  final List<SponsorshipDeal> availableOffers;
  
  final TvNetworkDeal? activeTvDeal; 
  final bool isBiddingWarActive; 
  
  final bool isSandboxMode;
  final int techBroadcast; 
  final int techPyro; 
  final int techAudio;
  final int techMedical;
  final int venueLevel; 
  final int premierPpvIndex; 
  final bool isLoading; 

  GameState({
    this.promotionName = "Squared Circle Universe",
    this.tvShowName = "Adrenaline",
    this.cash = 50000,
    this.fans = 100,
    this.reputation = 10,
    this.week = 1,
    this.year = 1,
    this.currentCard = const [],
    this.titleMatchFlags = const [], 
    this.ledger = const [],
    this.ppvNames = const [
      "Winter Warfare", "Valentine's Vengeance", "March Massacre",
      "Spring Spectacular", "Total Anarchy", "June Justice", "Summer Scorcher",
      "August Armageddon", "September Slam", "Fright Night",
      "November Nightmare", "Squared Circle Summit"
    ],
    this.venueCustomNames = const ["High School Gym", "Civic Center", "City Arena", "Global Stadium"],
    this.activeSponsors = const [],
    this.availableOffers = const [], 
    
    this.activeTvDeal,
    this.isBiddingWarActive = false,

    this.isSandboxMode = false,
    this.techBroadcast = 1,
    this.techPyro = 1,
    this.techAudio = 1,
    this.techMedical = 1,
    this.venueLevel = 1, 
    this.premierPpvIndex = 11, 
    this.isLoading = true,
  });

  int get playerWins => ledger.where((e) => e.warResult == "VICTORY").length;
  int get rivalWins => ledger.where((e) => e.warResult == "DEFEAT").length;
  int get draws => ledger.where((e) => e.warResult == "DRAW").length;

  int get currentWeek => week; 

  double get productionQualityBonus => ((techBroadcast - 1) * 0.1) + ((techPyro - 1) * 0.1) + ((techAudio - 1) * 0.1);

  Map<String, dynamic> get currentVenueDetails {
    switch (venueLevel) {
      case 4: return {"name": venueCustomNames[3], "capacity": 60000};
      case 3: return {"name": venueCustomNames[2], "capacity": 15000};
      case 2: return {"name": venueCustomNames[1], "capacity": 2500};
      case 1: 
      default: return {"name": venueCustomNames[0], "capacity": 500};
    }
  }

  bool get isPPV => week % 4 == 0;
  String get nextPPVName => ppvNames[((week - 1) ~/ 4) % 12];

  GameState copyWith({
    String? promotionName, String? tvShowName, int? cash, int? fans, int? reputation,
    int? week, int? year, List<Match>? currentCard, List<bool>? titleMatchFlags, List<FinancialEntry>? ledger,
    List<String>? ppvNames, List<String>? venueCustomNames, List<SponsorshipDeal>? activeSponsors,
    List<SponsorshipDeal>? availableOffers, TvNetworkDeal? activeTvDeal, bool? isBiddingWarActive, 
    bool? isSandboxMode, int? techBroadcast, int? techPyro, int? techAudio, int? techMedical, 
    int? venueLevel, int? premierPpvIndex, bool? isLoading,
  }) {
    return GameState(
      promotionName: promotionName ?? this.promotionName,
      tvShowName: tvShowName ?? this.tvShowName,
      cash: cash ?? this.cash,
      fans: fans ?? this.fans,
      reputation: reputation ?? this.reputation,
      week: week ?? this.week,
      year: year ?? this.year,
      currentCard: currentCard ?? this.currentCard,
      titleMatchFlags: titleMatchFlags ?? this.titleMatchFlags,
      ledger: ledger ?? this.ledger,
      ppvNames: ppvNames ?? this.ppvNames,
      venueCustomNames: venueCustomNames ?? this.venueCustomNames,
      activeSponsors: activeSponsors ?? this.activeSponsors,
      availableOffers: availableOffers ?? this.availableOffers,
      activeTvDeal: activeTvDeal ?? this.activeTvDeal,
      isBiddingWarActive: isBiddingWarActive ?? this.isBiddingWarActive,
      isSandboxMode: isSandboxMode ?? this.isSandboxMode,
      techBroadcast: techBroadcast ?? this.techBroadcast,
      techPyro: techPyro ?? this.techPyro,
      techAudio: techAudio ?? this.techAudio,
      techMedical: techMedical ?? this.techMedical,
      venueLevel: venueLevel ?? this.venueLevel,
      premierPpvIndex: premierPpvIndex ?? this.premierPpvIndex,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class GameNotifier extends StateNotifier<GameState> {
  final Ref ref;
  Isar? _isarInstance; 
  final Random _rng = Random(); 
  
  bool _stagedTitleMatchFlag = false;

  GameNotifier(this.ref) : super(GameState()) {
    _initDb();
  }

  Future<Isar> _getDb() async {
    if (_isarInstance != null) return _isarInstance!;
    
    if (Isar.instanceNames.isNotEmpty) {
      _isarInstance = Isar.getInstance();
      if (_isarInstance != null) return _isarInstance!;
    }
    
    final dir = await getApplicationDocumentsDirectory();
    _isarInstance = await Isar.open(
      [WrestlerSchema, MatchSchema, ShowHistorySchema, GameSaveSchema, TvNetworkDealSchema, SponsorshipDealSchema, FinancialRecordSchema, NewsItemSchema, RivalrySchema, MilestoneSchema], // 🚨 NEW SCHEMA
      directory: dir.path
    );
    return _isarInstance!;
  }

  Future<void> _initDb() async {
    final db = await _getDb(); 
    
    final networkCount = await db.tvNetworkDeals.count();
    if (networkCount == 0) await _seedNetworks();
    
    await _seedMilestones(); // 🚨 SEED TROPHIES

    final currentDeal = await db.tvNetworkDeals.filter().promotionIdEqualTo(0).findFirst();
    final currentSponsors = await db.sponsorshipDeals.filter().promotionIdEqualTo(0).findAll();
    final existingSave = await db.gameSaves.get(1); 

    if (existingSave != null) {
      state = state.copyWith(
        week: existingSave.week, year: existingSave.year, cash: existingSave.cash, fans: existingSave.fans,
        reputation: existingSave.reputation, promotionName: existingSave.promotionName, tvShowName: existingSave.tvShowName,
        venueLevel: existingSave.venueLevel, techBroadcast: existingSave.techBroadcast, techPyro: existingSave.techPyro,
        techAudio: existingSave.techAudio, techMedical: existingSave.techMedical, premierPpvIndex: existingSave.premierPpvIndex, 
        activeTvDeal: currentDeal, activeSponsors: currentSponsors, isBiddingWarActive: currentDeal == null, isLoading: false,
      );
    } else {
      state = state.copyWith(isLoading: false, isBiddingWarActive: true, activeTvDeal: null, activeSponsors: []);
    }
    _generateInitialSponsors();
  }

  // =========================================================================
  // 🏆 THE TROPHY ENGINE
  // =========================================================================
  Future<void> _seedMilestones() async {
    final db = await _getDb();
    final count = await db.milestones.count();
    if (count == 0) {
      List<Milestone> badges = [
        Milestone()..key = "first_show"..title = "Curtain Jerker"..description = "Book and run your very first show."..iconCode = Icons.theater_comedy.codePoint,
        Milestone()..key = "tv_deal"..title = "Prime Time"..description = "Sign your first Television Broadcasting Deal."..iconCode = Icons.tv.codePoint,
        Milestone()..key = "sponsor"..title = "Corporate Backing"..description = "Sign your first Corporate Sponsorship."..iconCode = Icons.handshake.codePoint,
        Milestone()..key = "five_star"..title = "Five Star Classic"..description = "Book a 5-Star Match."..iconCode = Icons.star.codePoint,
        Milestone()..key = "win_war"..title = "Ratings Winner"..description = "Beat the Rival Promotion in the weekly TV ratings."..iconCode = Icons.trending_up.codePoint,
        Milestone()..key = "rich"..title = "Million Dollar Man"..description = "Accumulate \$1,000,000 in your bank account."..iconCode = Icons.attach_money.codePoint,
        Milestone()..key = "stadium"..title = "Stadium Stampede"..description = "Upgrade your arena to the Global Stadium (Level 4)."..iconCode = Icons.stadium.codePoint,
      ];
      await db.writeTxn(() async { await db.milestones.putAll(badges); });
    }
  }

  Future<void> unlockMilestone(String key) async {
    final db = await _getDb();
    final badge = await db.milestones.filter().keyEqualTo(key).findFirst();
    if (badge != null && !badge.isUnlocked) {
      await db.writeTxn(() async {
        badge.isUnlocked = true;
        badge.unlockDate = DateTime.now();
        await db.milestones.put(badge);
      });
      
      // 🚨 Shoot an email to the inbox to notify the player!
      final item = NewsItem()
        ..timestamp = DateTime.now()
        ..isRead = false
        ..actionRequired = false
        ..sender = "System Alert"
        ..type = "EMAIL"
        ..subject = "🏆 MILESTONE UNLOCKED: ${badge.title}"
        ..body = "Congratulations! You have unlocked a Promoter Milestone:\n\n'${badge.description}'\n\nCheck the Trophy Room on your Home Dashboard to view your accomplishments.";
      
      await db.writeTxn(() async { await db.newsItems.put(item); });
    }
  }
  // =========================================================================

  Future<void> _seedNetworks() async {
    final db = await _getDb();
    List<TvNetworkDeal> networks = [
      TvNetworkDeal()..networkName="Action 21 TV"..description="High pay, strict minimum."..tierLevel=1..durationInWeeks=12..weeklyPayout=15000..targetMinimumRating=2.0..cannibalizesPPVs=false..ppvBonusMultiplier=1.0,
      TvNetworkDeal()..networkName="Public Access"..description="Safe fallback. No rating demand."..tierLevel=1..durationInWeeks=12..weeklyPayout=5000..targetMinimumRating=0.0..cannibalizesPPVs=false..ppvBonusMultiplier=1.0,
      TvNetworkDeal()..networkName="Combat TV"..description="Premium Cable. Massive payouts."..tierLevel=2..durationInWeeks=24..weeklyPayout=50000..targetMinimumRating=3.0..cannibalizesPPVs=false..ppvBonusMultiplier=1.2,
      TvNetworkDeal()..networkName="Midnight Action"..description="Late night. Great PPV cuts."..tierLevel=2..durationInWeeks=24..weeklyPayout=25000..targetMinimumRating=1.5..cannibalizesPPVs=false..ppvBonusMultiplier=1.5,
      TvNetworkDeal()..networkName="StreamFlix"..description="The Netflix Model. Massive flat fee, eats PPV buys."..tierLevel=3..durationInWeeks=48..weeklyPayout=250000..targetMinimumRating=4.5..cannibalizesPPVs=true..ppvBonusMultiplier=0.0,
      TvNetworkDeal()..networkName="Wrestle+"..description="The AMC+ Model. Standard pay, massive PPV upside."..tierLevel=3..durationInWeeks=48..weeklyPayout=100000..targetMinimumRating=4.0..cannibalizesPPVs=false..ppvBonusMultiplier=2.0,
      TvNetworkDeal()..networkName="Global Prime"..description="Absolute peak broadcasting. The world is watching."..tierLevel=4..durationInWeeks=48..weeklyPayout=500000..targetMinimumRating=4.8..cannibalizesPPVs=true..ppvBonusMultiplier=0.0,
      TvNetworkDeal()..networkName="PPV Worldwide"..description="Smaller weekly take, astronomical PPV bonuses."..tierLevel=4..durationInWeeks=48..weeklyPayout=200000..targetMinimumRating=4.5..cannibalizesPPVs=false..ppvBonusMultiplier=3.0,
    ];
    await db.writeTxn(() async { await db.tvNetworkDeals.putAll(networks); });
  }

  Future<void> resetGame() async {
    final db = await _getDb();
    
    await db.writeTxn(() async {
      await db.gameSaves.clear();
      await db.sponsorshipDeals.clear(); 
      await db.financialRecords.clear(); 
      await db.newsItems.clear(); 
      await db.milestones.clear(); // 🚨 Reset Trophies!
      
      final deals = await db.tvNetworkDeals.where().findAll();
      for (var d in deals) { d.promotionId = -1; }
      await db.tvNetworkDeals.putAll(deals);
    });

    state = GameState(
      week: 1, year: 1, cash: 50000, fans: 100, reputation: 10, 
      ledger: [], isLoading: false, isBiddingWarActive: true, premierPpvIndex: 11,
      activeSponsors: [], availableOffers: []
    );

    final networkCount = await db.tvNetworkDeals.count();
    if (networkCount == 0) await _seedNetworks();

    await _seedMilestones();
    _generateInitialSponsors();
    await saveGame(); 
  }

  void startNewSeason() => state = state.copyWith(week: 1, year: state.year + 1, currentCard: [], titleMatchFlags: []);
  void renamePromotion(String name) { state = state.copyWith(promotionName: name); saveGame(); } 
  void renameTVShow(String name) { state = state.copyWith(tvShowName: name); saveGame(); } 
  void setPremierPpv(int index) { state = state.copyWith(premierPpvIndex: index); saveGame(); } 
  void renamePPV(int i, String n) {
    final list = List<String>.from(state.ppvNames); list[i] = n;
    state = state.copyWith(ppvNames: list); saveGame(); 
  }

  Future<void> signSponsor(SponsorshipDeal deal) async {
    final db = await _getDb();
    bool slotTaken = state.activeSponsors.any((s) => s.slotTarget == deal.slotTarget);
    if (slotTaken) return; 
    
    int newCash = state.cash + deal.upfrontBonus;
    deal.promotionId = 0; 
    
    await db.writeTxn(() async { await db.sponsorshipDeals.put(deal); });
    
    state = state.copyWith(
      cash: newCash, 
      activeSponsors: [...state.activeSponsors, deal], 
      availableOffers: state.availableOffers.where((d) => d.slotTarget != deal.slotTarget).toList()
    );

    await unlockMilestone("sponsor"); // 🚨 TROPHY HOOK
    await saveGame(); 
  }

  Future<void> signTvDeal(TvNetworkDeal deal) async {
    final db = await _getDb();
    await db.writeTxn(() async {
      final oldDeals = await db.tvNetworkDeals.filter().promotionIdEqualTo(0).findAll();
      for (var d in oldDeals) { d.promotionId = -1; await db.tvNetworkDeals.put(d); }
      deal.promotionId = 0; 
      await db.tvNetworkDeals.put(deal);
    });
    
    state = state.copyWith(activeTvDeal: deal, isBiddingWarActive: false);
    
    await unlockMilestone("tv_deal"); // 🚨 TROPHY HOOK
    await saveGame(); 
  }

  void buyTechUpgrade(String type, int cost) {
    if (state.cash < cost) return;
    int cash = state.cash - cost;
    if (type == "BROADCAST") state = state.copyWith(cash: cash, techBroadcast: state.techBroadcast + 1);
    if (type == "PYRO") state = state.copyWith(cash: cash, techPyro: state.techPyro + 1);
    if (type == "AUDIO") state = state.copyWith(cash: cash, techAudio: state.techAudio + 1);
    if (type == "MEDICAL") state = state.copyWith(cash: cash, techMedical: state.techMedical + 1);
    saveGame(); 
  }

  bool purchaseVenueUpgrade() {
    int next = state.venueLevel + 1;
    int cost = next == 2 ? 25000 : (next == 3 ? 250000 : 1000000); 
    if (state.cash >= cost && next <= 4) {
      state = state.copyWith(cash: state.cash - cost, venueLevel: next, isBiddingWarActive: true); 
      _generateInitialSponsors(); 
      if (next == 4) unlockMilestone("stadium"); // 🚨 TROPHY HOOK
      saveGame(); 
      return true;
    }
    return false;
  }

  void spendCash(int amount) { state = state.copyWith(cash: state.cash - amount); saveGame(); } 

  void stageTitleMatch(bool isTitle) {
    _stagedTitleMatchFlag = isTitle;
  }

  void addMatchToCard(Match m) {
    state = state.copyWith(
      currentCard: [...state.currentCard, m],
      titleMatchFlags: [...state.titleMatchFlags, _stagedTitleMatchFlag]
    );
    _stagedTitleMatchFlag = false; 
  }
  
  void clearCard() => state = state.copyWith(currentCard: [], titleMatchFlags: []);

  void _generateInitialSponsors() {
    final List<SponsorshipDeal> newOffers = [];
    final currentLevel = state.venueLevel;

    if (!state.activeSponsors.any((s) => s.slotTarget == RealEstateSlot.turnbuckle)) {
      newOffers.add(SponsorshipDeal()..id = 100000..sponsorName = "Luigi's Pizza"..description="Consistent local payout."..logoPath="assets/images/sponsor_pizza.png"..slotTarget=RealEstateSlot.turnbuckle..archetype=SponsorArchetype.consistency..durationInWeeks=12..weeksLeft=12..upfrontBonus=0..weeklyPayout=500..performanceBonusThreshold=2.0..performanceBonusAmount=0);
      newOffers.add(SponsorshipDeal()..id = 100001..sponsorName = "Muscle Mass"..description="High bonus for 4+ star Main Events."..logoPath="assets/images/sponsor_gym.png"..slotTarget=RealEstateSlot.turnbuckle..archetype=SponsorArchetype.performance..durationInWeeks=12..weeksLeft=12..upfrontBonus=0..weeklyPayout=100..performanceBonusThreshold=4.0..performanceBonusAmount=2500);
      newOffers.add(SponsorshipDeal()..id = 100002..sponsorName = "CryptoCoin"..description="Massive upfront cash. No weekly pay."..logoPath="assets/images/sponsor_crypto.png"..slotTarget=RealEstateSlot.turnbuckle..archetype=SponsorArchetype.upfrontCash..durationInWeeks=24..weeksLeft=24..upfrontBonus=15000..weeklyPayout=0..performanceBonusThreshold=0.0..performanceBonusAmount=0);
    }

    if (currentLevel >= 2 && !state.activeSponsors.any((s) => s.slotTarget == RealEstateSlot.canvas)) {
      newOffers.add(SponsorshipDeal()..id = 100003..sponsorName = "Monster Energy"..description="Premium energy drink. Wants their massive logo center-ring."..weeklyPayout=4500..upfrontBonus=5000..durationInWeeks=24..weeksLeft=24..slotTarget=RealEstateSlot.canvas..archetype=SponsorArchetype.upfrontCash);
      newOffers.add(SponsorshipDeal()..id = 100004..sponsorName = "Grip Fitness Gear"..description="Performance brand. Pays huge bonuses for 4+ Star main events."..weeklyPayout=2500..upfrontBonus=0..performanceBonusThreshold=4.0..performanceBonusAmount=5000..durationInWeeks=12..weeksLeft=12..slotTarget=RealEstateSlot.canvas..archetype=SponsorArchetype.performance);
    }

    if (currentLevel >= 3 && !state.activeSponsors.any((s) => s.slotTarget == RealEstateSlot.eventName)) {
      newOffers.add(SponsorshipDeal()..id = 100005..sponsorName = "Brosweiser Beer"..description="'Brosweiser Presents: Squared Circle TV'. Massive weekly payouts."..weeklyPayout=15000..upfrontBonus=20000..durationInWeeks=48..weeksLeft=48..slotTarget=RealEstateSlot.eventName..archetype=SponsorArchetype.upfrontCash);
    }

    if (currentLevel >= 4 && !state.activeSponsors.any((s) => s.slotTarget == RealEstateSlot.titantron)) {
      newOffers.add(SponsorshipDeal()..id = 100006..sponsorName = "Globex Tech Corp"..description="Silicon Valley giant wants the entire entrance Titantron video board."..weeklyPayout=50000..upfrontBonus=100000..durationInWeeks=48..weeksLeft=48..slotTarget=RealEstateSlot.titantron..archetype=SponsorArchetype.upfrontCash);
      newOffers.add(SponsorshipDeal()..id = 100007..sponsorName = "Prime Video Streaming"..description="Huge performance bonuses if your Stadium shows hit 4.5 Stars."..weeklyPayout=30000..upfrontBonus=0..performanceBonusThreshold=4.5..performanceBonusAmount=40000..durationInWeeks=24..weeksLeft=24..slotTarget=RealEstateSlot.titantron..archetype=SponsorArchetype.performance);
    }

    state = state.copyWith(availableOffers: newOffers);
  }

  Future<void> generatePlayerRosterNews(String wrestlerName, bool isSigning) async {
    final db = await _getDb();
    final item = NewsItem()..timestamp = DateTime.now()..isRead = false..actionRequired = false;
      
    if (isSigning) {
      item.sender = "Social Media";
      item.type = "SOCIAL";
      item.subject = "Trending: #Welcome${wrestlerName.replaceAll(' ', '')}";
      item.body = "Fans are losing their minds online! $wrestlerName just signed a massive deal with ${state.promotionName}! The landscape has officially changed.";
    } else {
      item.sender = "Dirt Sheet";
      item.type = "DIRT_SHEET";
      item.subject = "$wrestlerName Released by ${state.promotionName}";
      item.body = "Confirmed: ${state.promotionName} has officially come to terms with the release of $wrestlerName. Sources say budget cuts were the primary factor.";
    }
    await db.writeTxn(() async { await db.newsItems.put(item); });
  }

  Future<void> generateAiReleaseNews(String wrestlerName) async {
    final db = await _getDb();
    final item = NewsItem()
      ..timestamp = DateTime.now()
      ..isRead = false
      ..actionRequired = false
      ..sender = "Wrestling Observer"
      ..type = "DIRT_SHEET"
      ..subject = "Contract Expired: $wrestlerName"
      ..body = "The Rival Promotion failed to reach a new deal with $wrestlerName. They are officially a Free Agent!";
    await db.writeTxn(() async { await db.newsItems.put(item); });
  }

  Future<void> generateHoldoutNews(String wrestlerName) async {
    final db = await _getDb();
    final item = NewsItem()
      ..timestamp = DateTime.now()
      ..isRead = false
      ..actionRequired = false
      ..sender = wrestlerName
      ..type = "EMAIL"
      ..subject = "Pay Me What I'm Worth!"
      ..body = "Boss, my popularity has skyrocketed since I signed my last deal. I'm officially holding out. Pay me a Cash Bonus to renegotiate, or I'm sitting out!";
    await db.writeTxn(() async { await db.newsItems.put(item); });
  }

  Future<void> generateVacantTitleNews(String beltName) async {
    final db = await _getDb();
    final item = NewsItem()
      ..timestamp = DateTime.now()
      ..isRead = false
      ..actionRequired = false
      ..sender = "Assistant GM"
      ..type = "EMAIL"
      ..subject = "URGENT: $beltName Vacated!"
      ..body = "Disaster! Our champion's contract expired and they walked out! The $beltName Title is now VACANT. Book a Championship Match immediately to crown a new champion.";
    await db.writeTxn(() async { await db.newsItems.put(item); });
  }

  // =========================================================================
  // 🚀 PROCESS WEEK ENGINE 
  // =========================================================================
  Future<void> processWeek(List<Wrestler> roster) async {
    final db = await _getDb(); 

    int sal = roster.fold(0, (sum, w) => sum + w.salary);
    int prod = 0;
    if (state.techBroadcast == 2) prod += 10000;
    if (state.techBroadcast >= 3) prod += 50000;

    int rent;
    switch(state.venueLevel) {
      case 2: rent = 5000; break; case 3: rent = 50000; break; case 4: rent = 250000; break; case 1: default: rent = 500; break;
    }
    
    int facCosts = state.techMedical * 2500; 
    int totalExpenses = sal + prod + rent + facCosts;

    double totalRatingScore = 0.0;
    List<String> weeklyHighlights = []; 

    for (int i = 0; i < state.currentCard.length; i++) {
      var match = state.currentCard[i];
      double matchScore = match.rating;
      
      String matchPosition = "MATCH";
      if (i == 0) matchPosition = "OPENER";
      else if (i == state.currentCard.length - 1) matchPosition = "MAIN EVENT";
      else matchPosition = "MID-CARD";

      String winnerName = match.winnerName;
      String loserName = match.loserName;

      if (winnerName == "Draw" || winnerName.isEmpty) {
        weeklyHighlights.add("$matchPosition: Match ended in a Draw ($matchScore ⭐)");
      } else {
        weeklyHighlights.add("$matchPosition: $winnerName defeated $loserName ($matchScore ⭐)");
      }
      
      bool isTitleMatch = state.titleMatchFlags.length > i ? state.titleMatchFlags[i] : false;
      
      if (isTitleMatch) {
        matchScore += 0.5;
        if (matchScore > 5.0) matchScore = 5.0;
        
        if (match.winnerName.isNotEmpty && match.winnerName != "Draw") {
          Wrestler? winner = roster.where((w) => w.name == match.winnerName).firstOrNull;
          Wrestler? loser = roster.where((w) => w.name == match.loserName).firstOrNull;

          if (winner != null && loser != null) {
            if (loser.isChampion) {
              loser.isChampion = false;
              winner.isChampion = true;
              ref.read(rosterProvider.notifier).recordTitleChange("World Heavyweight", winner.name);
            }
            else if (loser.isTVChampion) {
              loser.isTVChampion = false;
              winner.isTVChampion = true;
              ref.read(rosterProvider.notifier).recordTitleChange("Television Title", winner.name);
            }
            else {
              bool worldExists = roster.any((w) => w.isChampion && w.companyId == 0);
              bool tvExists = roster.any((w) => w.isTVChampion && w.companyId == 0);
              
              if (!worldExists) {
                winner.isChampion = true;
                ref.read(rosterProvider.notifier).recordTitleChange("World Heavyweight", winner.name);
              } else if (!tvExists) {
                winner.isTVChampion = true;
                ref.read(rosterProvider.notifier).recordTitleChange("Television Title", winner.name);
              }
            }
          }
        }
      }
      totalRatingScore += matchScore;
      
      // 🚨 TROPHY HOOK: 5 STAR MATCH
      if (matchScore >= 5.0) await unlockMilestone("five_star");
    }

    for (var match in state.currentCard) {
      if (match.wrestlers.length >= 2) {
        await ref.read(rosterProvider.notifier).addMatchInteraction(
            match.wrestlers.elementAt(0).name, 
            match.wrestlers.elementAt(1).name
        );
      }
    }

    double rawRating = state.currentCard.isEmpty ? 0 : (totalRatingScore / state.currentCard.length);
    double rating = rawRating;
    if (state.techBroadcast == 1 && rawRating > 3.5) {
      rating = 3.5;
    } else if (state.techBroadcast == 2 && rawRating > 4.2) rating = 4.2; 
    rating = double.parse(rating.toStringAsFixed(1));

    int tvPayout = 0; int ppvPayout = 0; int gate = (state.fans * 15); int merch = (state.fans * 8); 

    if (state.activeTvDeal != null) {
      tvPayout = state.activeTvDeal!.weeklyPayout;
      if (!state.isPPV && rating < state.activeTvDeal!.targetMinimumRating) tvPayout = (tvPayout * 0.5).toInt(); 
      if (state.isPPV) {
        int currentPpvIndex = ((state.week - 1) ~/ 4) % 12;
        bool isPremier = currentPpvIndex == state.premierPpvIndex;
        double prestigeBonus = isPremier ? 1.5 : 1.0; 

        if (state.activeTvDeal!.cannibalizesPPVs) {
          tvPayout = (state.activeTvDeal!.weeklyPayout * 2 * prestigeBonus).toInt();
        } else {
          ppvPayout = (state.fans * 30 * state.activeTvDeal!.ppvBonusMultiplier * prestigeBonus).toInt();
        }
      }
    } else {
        tvPayout = 1000; 
    }

    int sponPay = 0; List<SponsorshipDeal> dealsToKeep = [];
    double mainEventRating = state.currentCard.isNotEmpty ? state.currentCard.last.rating : 0.0;

    for (var s in state.activeSponsors) {
      bool voidContract = false;
      if (s.archetype == SponsorArchetype.consistency) { if (rating < 2.5) {
        voidContract = true;
      } else {
        sponPay += s.weeklyPayout;
      } } 
      else if (s.archetype == SponsorArchetype.performance) { sponPay += s.weeklyPayout; if (mainEventRating >= s.performanceBonusThreshold) sponPay += s.performanceBonusAmount; }
      else if (s.archetype == SponsorArchetype.upfrontCash) sponPay += s.weeklyPayout; 

      if (!voidContract) { s.weeksLeft -= 1; if (s.weeksLeft > 0) dealsToKeep.add(s); }
    }

    await db.writeTxn(() async {
      final currentDbSponsors = await db.sponsorshipDeals.filter().promotionIdEqualTo(0).findAll();
      for(var dbSponsor in currentDbSponsors) { dbSponsor.promotionId = -1; await db.sponsorshipDeals.put(dbSponsor); }
      for(var keeper in dealsToKeep) { keeper.promotionId = 0; await db.sponsorshipDeals.put(keeper); }
    });

    int prof = (gate + merch + tvPayout + ppvPayout + sponPay) - totalExpenses;

    final finRecord = FinancialRecord()..year = state.year..week = state.week..tvRevenue = tvPayout..ppvRevenue = ppvPayout..ticketSales = gate..merchandiseSales = merch..sponsorshipRevenue = sponPay..rosterPayroll = sal..productionCosts = prod..facilityCosts = facCosts..logisticsCosts = rent;
    await db.writeTxn(() async { await db.financialRecords.put(finRecord); });

    List<String> bookedNames = [];
    for (var match in state.currentCard) { 
      if (match.winnerName.isNotEmpty) bookedNames.add(match.winnerName);
      if (match.loserName.isNotEmpty && match.loserName != "Unknown") bookedNames.add(match.loserName);
    }

    for (var w in roster) {
        if (w.isInjured) {
            w.injuryWeeks -= 1;
            if (w.injuryWeeks <= 0) { w.isInjured = false; w.injuryWeeks = 0; w.stamina = 50; } else {
              w.stamina += 10;
            } 
        } else {
            if (bookedNames.contains(w.name)) {
                w.stamina -= 15; w.morale += 5;
                if (w.stamina < 20 && _rng.nextDouble() < 0.40) { w.isInjured = true; w.injuryWeeks = _rng.nextInt(3) + 2; }
            } else { w.stamina += 15; w.morale -= 2; }
        }

        w.contractWeeks -= 1;
        if (w.contractWeeks < 0) w.contractWeeks = 0;

        if (w.companyId == 0) { 
          if (w.activePromise.isNotEmpty) {
            bool isFulfilled = false;
            if (w.activePromise == "TITLE_RUN" && (w.isChampion || w.isTVChampion)) {
              isFulfilled = true;
            }

            if (isFulfilled) {
              w.activePromise = "";
              w.promiseDeadline = 0;
              w.morale += 30; 
              w.isHoldingOut = false;
            } else {
              w.promiseDeadline -= 1;
              
              if (w.promiseDeadline <= 0) {
                w.activePromise = "";
                w.morale -= 50; 
                
                if (w.morale < 30) {
                  w.isHoldingOut = true; 
                }
              }
            }
          } else {
            if (w.pop > 75 && !w.isChampion && !w.isInjured && !w.isHoldingOut) {
              if (_rng.nextDouble() < 0.05) {
                w.activePromise = "TITLE_RUN";
                w.promiseDeadline = 4; 
              }
            }
          }
        }

        w.stamina = w.stamina.clamp(0, 100);
        w.morale = w.morale.clamp(0, 100);
    }

    final currentDifficultyForAI = ref.read(settingsProvider).difficulty;
    
    double signChance = 0.10; 
    int releasePopThreshold = 20;
    int maxRivalRosterSize = 12;

    switch (currentDifficultyForAI) {
      case "EASY":
        signChance = 0.02; 
        releasePopThreshold = 10; 
        break;
      case "HARD":
        signChance = 0.25; 
        releasePopThreshold = 35; 
        break;
      case "TYCOON":
        signChance = 0.50; 
        releasePopThreshold = 50; 
        break;
      case "NORMAL":
      default:
        break;
    }

    List<Wrestler> rivalRoster = roster.where((w) => w.companyId == 1).toList();
    List<Wrestler> freeAgents = roster.where((w) => w.companyId == -1).toList();
    List<Wrestler> newlySignedByAI = [];
    List<Wrestler> newlyReleasedByAI = [];

    rivalRoster.sort((a, b) => a.pop.compareTo(b.pop));

    for (var w in rivalRoster.toList()) {
      if (w.pop < releasePopThreshold || rivalRoster.length > maxRivalRosterSize) {
        w.companyId = -1; 
        w.morale = 50; 
        newlyReleasedByAI.add(w);
        rivalRoster.remove(w);
      }
    }

    freeAgents.sort((a, b) => b.pop.compareTo(a.pop));
    
    for (var fa in freeAgents) {
      if (rivalRoster.length < maxRivalRosterSize) {
        if (fa.pop > 65 && _rng.nextDouble() < signChance) {
          fa.companyId = 1; 
          fa.contractWeeks = 48;
          fa.morale = 100;
          rivalRoster.add(fa);
          newlySignedByAI.add(fa);
        }
      } else if (rivalRoster.length == maxRivalRosterSize) {
        var worstGuy = rivalRoster.first;
        if (fa.pop >= 80 && fa.pop > worstGuy.pop + 15 && _rng.nextDouble() < signChance) {
          worstGuy.companyId = -1;
          worstGuy.morale = 50;
          newlyReleasedByAI.add(worstGuy);
          rivalRoster.remove(worstGuy);

          fa.companyId = 1;
          fa.contractWeeks = 48;
          fa.morale = 100;
          rivalRoster.add(fa);
          newlySignedByAI.add(fa);
          rivalRoster.sort((a, b) => a.pop.compareTo(b.pop));
        }
      }
    }

    await db.writeTxn(() async { await db.wrestlers.putAll(roster); });

    final currentDifficulty = ref.read(settingsProvider).difficulty;
    
    double rival = 3.0;
    try { rival = ref.read(rivalProvider).rating; } catch(e) {}
    
    double fanGrowthMultiplier = 1.0;

    switch (currentDifficulty) {
      case "EASY":
        rival -= 0.5; 
        rating += 0.5; 
        fanGrowthMultiplier = 1.5; 
        break;
      case "HARD":
        rival += 0.5; 
        fanGrowthMultiplier = 0.8; 
        break;
      case "TYCOON":
        rival += 1.0; 
        fanGrowthMultiplier = 0.5; 
        totalExpenses = (totalExpenses * 1.2).toInt(); 
        break;
      case "NORMAL":
      default:
        break;
    }

    int fChange = 0;
    int repChange = 0;

    if (rating >= 4.5) { fChange = 500 * state.venueLevel; repChange = 2; }
    else if (rating >= 3.5) { fChange = 250 * state.venueLevel; repChange = 1; }
    else if (rating >= 2.5) { fChange = 75 * state.venueLevel; repChange = 0; }
    else if (rating >= 1.5) { fChange = -25 * state.venueLevel; repChange = -1; }
    else { fChange = -100 * state.venueLevel; repChange = -2; }

    double diff = rating - rival;
    if (diff > 0) {
      fChange += (diff * 200 * state.venueLevel).toInt(); 
      if (diff >= 1.0) repChange += 1; 
      
      // 🚨 TROPHY HOOK: Win the TV Rating
      await unlockMilestone("win_war"); 
    } else if (diff < 0) {
      fChange += (diff * 75 * state.venueLevel).toInt(); 
    }

    if (state.fans < 500 && rating >= 2.5 && fChange < 25) {
      fChange = 25;
    }

    fChange = (fChange * fanGrowthMultiplier).toInt();
    int newFans = (state.fans + fChange).clamp(10, 10000000); 
    int newRep = (state.reputation + repChange).clamp(0, 100);

    if (state.currentCard.isNotEmpty) {
      final historyEntry = ShowHistory()
        ..timestamp = DateTime.now()
        ..week = state.week
        ..year = state.year
        ..showName = state.isPPV ? state.nextPPVName : state.tvShowName
        ..avgRating = rating
        ..totalProfit = prof
        ..attendance = gate ~/ 20
        ..highlights = weeklyHighlights; 
      await db.writeTxn(() async { await db.showHistorys.put(historyEntry); });
    }

    // 🚨 TROPHY HOOK: Complete a Show
    await unlockMilestone("first_show");

    // 🚨 TROPHY HOOK: Millionaire
    if (state.cash + prof >= 1000000) {
      await unlockMilestone("rich");
    }

    await _generateWeeklyCommunications(rating, rival, roster, state.currentCard, newlySignedByAI, newlyReleasedByAI);

    state = state.copyWith(
      cash: state.cash + prof, 
      fans: newFans, 
      reputation: newRep, 
      week: state.week + 1,
      ledger: [ FinancialEntry()..week = state.week..year = state.year..incomeTickets = gate..incomeMerch = merch..incomeSponsors = sponPay..incomeTvDeal = tvPayout..expenseSalaries = sal..expenseProduction = prod..expenseRent = rent..profit = prof..showRating = rating..rivalRating = rival..warResult = (rating > rival ? "VICTORY" : (rating < rival ? "DEFEAT" : "DRAW")), ...state.ledger ],
      currentCard: [], 
      titleMatchFlags: [], 
      activeSponsors: dealsToKeep,
    );

    _generateInitialSponsors();
    await saveGame(); 
    
    ref.read(rosterProvider.notifier).advanceTitleReigns();
    ref.read(rosterProvider.notifier).loadRoster(); 
  }
  
  Future<void> saveGame() async {
      final db = await _getDb(); 
      final save = GameSave()..id = 1..week = state.week..year = state.year..cash = state.cash..fans = state.fans..reputation = state.reputation..promotionName = state.promotionName..tvShowName = state.tvShowName..venueLevel = state.venueLevel..techBroadcast = state.techBroadcast..techPyro = state.techPyro..techAudio = state.techAudio..techMedical = state.techMedical..premierPpvIndex = state.premierPpvIndex; 
      await db.writeTxn(() async { await db.gameSaves.put(save); });
  }

  Future<void> processYearEnd() async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      
      if (user != null) {
        final int legacyScore = (state.cash ~/ 1000) + state.fans + (state.reputation * 100);
        await supabase.from('tycoon_scores').insert({
          'user_id': user.id,
          'promotion_name': state.promotionName,
          'score': legacyScore,
        });
      }
    } catch (e) {
      print("Cloud Sync Failed: $e"); 
    }

    state = state.copyWith(week: 1, year: state.year + 1, ledger: []);
    await saveGame();
  }

  Future<void> _generateWeeklyCommunications(double showRating, double rivalRating, List<Wrestler> roster, List<Match> card, List<Wrestler> aiSignings, List<Wrestler> aiReleases) async {
    final db = await _getDb();
    List<NewsItem> newMessages = [];

    if (state.week == 1) {
      newMessages.add(NewsItem()..sender = "Assistant GM"..subject = "Welcome to the Office!"..body = "Boss, welcome to the big leagues! Before you book a show, check the Broadcasting tab to secure a TV deal, and visit the Sponsors tab to get some upfront cash. We need that money to pay the talent!"..timestamp = DateTime.now()..isRead = false..actionRequired = false..type = "EMAIL");
    } else if (state.week == 3) {
      newMessages.add(NewsItem()..sender = "Assistant GM"..subject = "PPV Approaching!"..body = "Just a heads up—our first Pay-Per-View is next week! PPVs generate massive revenue, but only if the matches are hot. Use the Creative Hub to build up Rivalry Heat before the big show!"..timestamp = DateTime.now()..isRead = false..actionRequired = false..type = "EMAIL");
    } else if (state.week == 10) {
      newMessages.add(NewsItem()..sender = "HR Department"..subject = "Contract Expirations"..body = "Keep an eye on the Roster screen. Some of our talent's contracts are expiring soon. If they hit Free Agency, the Rival AI might snatch them up!"..timestamp = DateTime.now()..isRead = false..actionRequired = false..type = "EMAIL");
    }

    if (state.week == 12 || state.week == 24 || state.week == 36) {
      String performance = "";
      if (state.playerWins > state.rivalWins && state.cash >= 100000) {
        performance = "Excellent work, Boss. You are dominating the rival promotion in the TV ratings and our profit margins are fantastic. Keep this momentum going into the next quarter.";
      } else if (state.playerWins > state.rivalWins) {
        performance = "We are very pleased that we are winning the ratings war against the competition. However, keep a close eye on the budget. Ratings don't matter if we go bankrupt.";
      } else if (state.cash >= 100000) {
        performance = "Financially, the company is in a great spot and your budget management is commendable. But we are getting absolutely crushed in the TV ratings! You need to book hotter storylines and better matches.";
      } else {
        performance = "UNACCEPTABLE. We are losing the ratings war AND bleeding cash. This company is a sinking ship. If you don't turn this around by the end of the year, the Board will find someone else who can.";
      }

      newMessages.add(NewsItem()..sender = "Board of Directors"..subject = "Q${state.week ~/ 12} Performance Review"..body = performance..timestamp = DateTime.now()..isRead = false..actionRequired = false..type = "EMAIL");
    }

    if (state.cash < 15000 && state.week > 2) {
      newMessages.add(NewsItem()..sender = "Accounting"..subject = "URGENT: Financial Warning"..body = "We are bleeding cash! You need to put on better shows to boost ticket sales, or release some expensive dead-weight from the roster. If we hit \$0, it's game over."..timestamp = DateTime.now()..isRead = false..actionRequired = false..type = "EMAIL");
    }

    var angryWrestler = roster.where((w) => w.companyId == 0 && w.morale <= 30).firstOrNull;
    if (angryWrestler != null && _rng.nextDouble() < 0.3) { 
      newMessages.add(NewsItem()..sender = angryWrestler.name..subject = "My Booking..."..body = "I'm sick of sitting in the back or losing matches. Use me better, put me in a real storyline, or I'm walking out."..timestamp = DateTime.now()..isRead = false..actionRequired = false..type = "EMAIL");
    }

    var banger = card.where((m) => m.rating >= 4.5).firstOrNull;
    if (banger != null && banger.winnerName.isNotEmpty && banger.winnerName != "Draw") {
      newMessages.add(NewsItem()..sender = "Wrestling Observer"..subject = "Match of the Year Contender?"..body = "Fans are absolutely buzzing about the ${banger.winnerName} vs ${banger.loserName} match this week. An absolute masterclass in ring psychology. Ratings gold!"..timestamp = DateTime.now()..isRead = false..actionRequired = false..type = "DIRT_SHEET");
    }

    if (rivalRating > showRating && state.week > 1 && _rng.nextDouble() < 0.4) {
      newMessages.add(NewsItem()..sender = "Wrestling Observer"..subject = "Rival Promotion Wins The Week"..body = "The Rival Promotion crushed it in the TV ratings this week. Sources say their Main Event drew massive numbers. Your promotion needs a hotter Main Event next week!"..timestamp = DateTime.now()..isRead = false..actionRequired = false..type = "DIRT_SHEET");
    }

    for(var w in aiSignings) {
      if (w.pop >= 85) {
        newMessages.add(NewsItem()..sender = "Wrestling Observer"..subject = "MAJOR SIGNING: ${w.name} to Rival Promo!"..body = "The wrestling world is shocked! The Rival Promotion just backed up the Brinks truck to sign ${w.name} to an exclusive deal. This shifts the balance of power!"..timestamp = DateTime.now()..isRead = false..actionRequired = false..type = "DIRT_SHEET");
        newMessages.add(NewsItem()..sender = "Assistant GM"..subject = "Boss, did you see this?!"..body = "They just signed ${w.name}! We completely missed out on a top star. We need to counter-program this immediately."..timestamp = DateTime.now()..isRead = false..actionRequired = false..type = "EMAIL");
      } else if (w.pop >= 70) {
        newMessages.add(NewsItem()..sender = "Wrestling Observer"..subject = "Rival Promo signs ${w.name}"..body = "Solid mid-card acquisition for the competition as they pick up ${w.name} from free agency."..timestamp = DateTime.now()..isRead = false..actionRequired = false..type = "DIRT_SHEET");
      }
    }

    for(var w in aiReleases) {
      if (w.pop >= 75) {
        newMessages.add(NewsItem()..sender = "Wrestling Observer"..subject = "SHOCKING RELEASE: ${w.name}"..body = "We can confirm the Rival Promotion has officially released ${w.name}. Management cited 'budget cuts', but rumors say there was backstage heat. Could be a huge pickup for us!"..timestamp = DateTime.now()..isRead = false..actionRequired = false..type = "DIRT_SHEET");
      }
    }

    if (newMessages.isNotEmpty) {
      await db.writeTxn(() async { await db.newsItems.putAll(newMessages); });
    }
  }
}

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) => GameNotifier(ref));