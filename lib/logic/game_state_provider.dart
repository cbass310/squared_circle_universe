import 'dart:io' show Platform; // 🚨 ADDED FOR PLATFORM DETECTION
import 'dart:math'; 
import 'dart:convert'; 
import 'package:flutter/material.dart'; 
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
import '../data/models/milestone.dart'; 

import 'rival_provider.dart'; 
import 'promoter_provider.dart'; 
import 'settings_provider.dart'; 

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

  FinancialEntry();

  Map<String, dynamic> toMap() => {
    'week': week, 'year': year, 'incomeTickets': incomeTickets, 'incomeMerch': incomeMerch,
    'incomeSponsors': incomeSponsors, 'incomeTvDeal': incomeTvDeal, 'expenseSalaries': expenseSalaries,
    'expenseProduction': expenseProduction, 'expenseRent': expenseRent, 'profit': profit,
    'showRating': showRating, 'rivalRating': rivalRating, 'warResult': warResult,
  };

  factory FinancialEntry.fromMap(Map<String, dynamic> map) {
    return FinancialEntry()
      ..week = map['week'] ?? 1
      ..year = map['year'] ?? 1
      ..incomeTickets = map['incomeTickets'] ?? 0
      ..incomeMerch = map['incomeMerch'] ?? 0
      ..incomeSponsors = map['incomeSponsors'] ?? 0
      ..incomeTvDeal = map['incomeTvDeal'] ?? 0
      ..expenseSalaries = map['expenseSalaries'] ?? 0
      ..expenseProduction = map['expenseProduction'] ?? 0
      ..expenseRent = map['expenseRent'] ?? 0
      ..profit = map['profit'] ?? 0
      ..showRating = (map['showRating'] ?? 0.0).toDouble()
      ..rivalRating = (map['rivalRating'] ?? 0.0).toDouble()
      ..warResult = map['warResult'] ?? "DRAW";
  }
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
  final bool isFullGameUnlocked; // 🚨 ADDED

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
    this.isFullGameUnlocked = false, // 🚨 ADDED
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
    int? venueLevel, int? premierPpvIndex, bool? isLoading, bool? isFullGameUnlocked, // 🚨 ADDED
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
      isFullGameUnlocked: isFullGameUnlocked ?? this.isFullGameUnlocked, // 🚨 ADDED
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
      [WrestlerSchema, MatchSchema, ShowHistorySchema, GameSaveSchema, TvNetworkDealSchema, SponsorshipDealSchema, FinancialRecordSchema, NewsItemSchema, RivalrySchema, MilestoneSchema], 
      directory: dir.path
    );
    return _isarInstance!;
  }

  Future<void> _injectWelcomeEmail(Isar db) async {
    final count = await db.newsItems.filter().subjectEqualTo("Welcome to SCW!").count();
    if (count == 0) {
      final welcomeMsg = NewsItem()
        ..timestamp = DateTime.now()
        ..isRead = false
        ..actionRequired = false
        ..sender = "Assistant GM"
        ..type = "EMAIL"
        ..subject = "Welcome to SCW!"
        ..body = "Boss, Welcome to Squared Circle Wrestling! I'm looking forward to working with you to build the best promotion in the world! Before you book a show, check the Broadcasting tab to secure a TV deal, and visit the Sponsors tab to get some upfront cash. We need that money to pay the talent!";
      await db.writeTxn(() async { await db.newsItems.put(welcomeMsg); });
    }
  }

  Future<void> _initDb() async {
    final db = await _getDb(); 
    
    final networkCount = await db.tvNetworkDeals.count();
    if (networkCount == 0) await _seedNetworks();
    
    await _seedMilestones(); 

    final currentDeal = await db.tvNetworkDeals.filter().promotionIdEqualTo(0).findFirst();
    final currentSponsors = await db.sponsorshipDeals.filter().promotionIdEqualTo(0).findAll();
    final existingSave = await db.gameSaves.get(1); 

    // 🚨 THE PLATFORM CHECK LOGIC 🚨
    bool isDesktop = false;
    try {
      if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        isDesktop = true;
      }
    } catch (e) {
      // Failsafe for web or weird environments
    }

    if (existingSave != null) {
      List<FinancialEntry> loadedLedger = [];
      try {
        loadedLedger = existingSave.ledgerJson.map((e) => FinancialEntry.fromMap(jsonDecode(e))).toList();
      } catch (e) {}

      // 🚨 DETERMINE UNLOCK STATUS (Auto-true for PC, checks Isar DB for mobile)
      bool unlockedStatus = isDesktop;
      if (!isDesktop) {
        try { unlockedStatus = existingSave.isFullGameUnlocked; } catch(e) { unlockedStatus = false; }
      }

      state = state.copyWith(
        week: existingSave.week, year: existingSave.year, cash: existingSave.cash, fans: existingSave.fans,
        reputation: existingSave.reputation, promotionName: existingSave.promotionName, tvShowName: existingSave.tvShowName,
        venueLevel: existingSave.venueLevel, techBroadcast: existingSave.techBroadcast, techPyro: existingSave.techPyro,
        techAudio: existingSave.techAudio, techMedical: existingSave.techMedical, premierPpvIndex: existingSave.premierPpvIndex, 
        activeTvDeal: currentDeal, activeSponsors: currentSponsors, isBiddingWarActive: currentDeal == null, isLoading: false,
        ledger: loadedLedger, 
        isFullGameUnlocked: unlockedStatus, // 🚨 LOAD UNLOCK STATUS
      );
    } else {
      state = state.copyWith(
        isLoading: false, 
        isBiddingWarActive: true, 
        activeTvDeal: null, 
        activeSponsors: [],
        isFullGameUnlocked: isDesktop, // 🚨 AUTO-UNLOCK FOR NEW PC SAVES
      );
    }
    
    _generateInitialSponsors();
    await _injectWelcomeEmail(db); 
  }

  Future<void> _seedMilestones() async {
    final db = await _getDb();
    final count = await db.milestones.count();
    if (count == 0) {
      List<Milestone> badges = [
        Milestone()..key="first_dime"..title="First Dime"..description="Reach \$10,000 in cash."..iconCode=Icons.attach_money.codePoint..isUnlocked=false,
        Milestone()..key="making_payroll"..title="Making Payroll"..description="Reach \$50,000 in cash."..iconCode=Icons.money.codePoint..isUnlocked=false,
        Milestone()..key="six_figures"..title="Six Figures"..description="Reach \$100,000 in cash."..iconCode=Icons.account_balance_wallet.codePoint..isUnlocked=false,
        Milestone()..key="quarter_mil"..title="Quarter Mil"..description="Reach \$250,000 in cash."..iconCode=Icons.savings.codePoint..isUnlocked=false,
        Milestone()..key="half_a_million"..title="Half a Million"..description="Reach \$500,000 in cash."..iconCode=Icons.price_change.codePoint..isUnlocked=false,
        Milestone()..key="rich"..title="Millionaire Club"..description="Reach \$1,000,000 in cash."..iconCode=Icons.monetization_on.codePoint..isUnlocked=false,
        Milestone()..key="big_business"..title="Big Business"..description="Reach \$2,500,000 in cash."..iconCode=Icons.trending_up.codePoint..isUnlocked=false,
        Milestone()..key="empire_builder"..title="Empire Builder"..description="Reach \$5,000,000 in cash."..iconCode=Icons.domain.codePoint..isUnlocked=false,
        Milestone()..key="wall_street_darling"..title="Wall Street Darling"..description="Reach \$10,000,000 in cash."..iconCode=Icons.account_balance.codePoint..isUnlocked=false,
        Milestone()..key="tycoon_status"..title="Tycoon Status"..description="Reach \$25,000,000 in cash."..iconCode=Icons.diamond.codePoint..isUnlocked=false,
        Milestone()..key="cult_following"..title="Cult Following"..description="Reach 10,000 Fans."..iconCode=Icons.group.codePoint..isUnlocked=false,
        Milestone()..key="selling_out_gyms"..title="Selling Out Gyms"..description="Reach 50,000 Fans."..iconCode=Icons.groups.codePoint..isUnlocked=false,
        Milestone()..key="regional_threat"..title="Regional Threat"..description="Reach 100,000 Fans."..iconCode=Icons.map.codePoint..isUnlocked=false,
        Milestone()..key="national_spotlight"..title="National Spotlight"..description="Reach 500,000 Fans."..iconCode=Icons.public.codePoint..isUnlocked=false,
        Milestone()..key="global_phenomenon"..title="Global Phenomenon"..description="Reach 1,000,000 Fans."..iconCode=Icons.language.codePoint..isUnlocked=false,
        Milestone()..key="moving_on_up"..title="Moving on Up"..description="Upgrade to the Civic Center."..iconCode=Icons.business.codePoint..isUnlocked=false,
        Milestone()..key="big_leagues"..title="The Big Leagues"..description="Upgrade to the Arena."..iconCode=Icons.location_city.codePoint..isUnlocked=false,
        Milestone()..key="stadium"..title="Grandest Stage"..description="Upgrade to the Stadium."..iconCode=Icons.stadium.codePoint..isUnlocked=false,
        Milestone()..key="sponsor"..title="Corporate Backing"..description="Sign your first Sponsor."..iconCode=Icons.handshake.codePoint..isUnlocked=false,
        Milestone()..key="sellout_board"..title="Sellout Board"..description="Max out all 3 Sponsors."..iconCode=Icons.storefront.codePoint..isUnlocked=false,
        Milestone()..key="tv_deal"..title="On The Air"..description="Sign your first TV Deal."..iconCode=Icons.tv.codePoint..isUnlocked=false,
        Milestone()..key="prime_time_player"..title="Prime Time Player"..description="Sign a Prime Time TV Deal."..iconCode=Icons.live_tv.codePoint..isUnlocked=false,
        Milestone()..key="late_night_wars"..title="Late Night Wars"..description="Sign a Late Night TV Deal."..iconCode=Icons.nightlight_round.codePoint..isUnlocked=false,
        Milestone()..key="ppv_king"..title="Pay-Per-View King"..description="Host your first PPV Event."..iconCode=Icons.confirmation_number.codePoint..isUnlocked=false,
        Milestone()..key="broadcast_tycoon"..title="Broadcast Tycoon"..description="Upgrade Production to Level 3."..iconCode=Icons.video_camera_front.codePoint..isUnlocked=false,
        Milestone()..key="decent_bout"..title="Decent Bout"..description="Book a 3-Star Match."..iconCode=Icons.star_half.codePoint..isUnlocked=false,
        Milestone()..key="show_stealer"..title="Show Stealer"..description="Book a 4-Star Match."..iconCode=Icons.star.codePoint..isUnlocked=false,
        Milestone()..key="five_star"..title="Five Star Classic"..description="Book a perfect 5-Star Match."..iconCode=Icons.workspace_premium.codePoint..isUnlocked=false,
        Milestone()..key="perfect_card"..title="Perfect Card"..description="Average Show Rating of 4.0+."..iconCode=Icons.auto_awesome.codePoint..isUnlocked=false,
        Milestone()..key="bad_night"..title="Bad Night"..description="Average Show Rating below 2.0."..iconCode=Icons.thumb_down.codePoint..isUnlocked=false,
        Milestone()..key="first_feud"..title="The First Feud"..description="Spark a Rivalry."..iconCode=Icons.people_alt.codePoint..isUnlocked=false,
        Milestone()..key="red_hot"..title="Red Hot"..description="Get a Rivalry to 60+ Heat."..iconCode=Icons.local_fire_department.codePoint..isUnlocked=false,
        Milestone()..key="legendary_grudge"..title="Legendary Grudge"..description="Get a Rivalry to 90+ Heat."..iconCode=Icons.flash_on.codePoint..isUnlocked=false,
        Milestone()..key="world_champ"..title="Changing of the Guard"..description="Crown a new World Champion."..iconCode=Icons.emoji_events.codePoint..isUnlocked=false,
        Milestone()..key="tv_champ"..title="Mid-Card Prestige"..description="Crown a new TV Champion."..iconCode=Icons.military_tech.codePoint..isUnlocked=false,
        Milestone()..key="first_signing"..title="Ink to Paper"..description="Sign a Free Agent."..iconCode=Icons.history_edu.codePoint..isUnlocked=false,
        Milestone()..key="traitor"..title="Traitor!"..description="Poach a Rival Wrestler."..iconCode=Icons.transfer_within_a_station.codePoint..isUnlocked=false,
        Milestone()..key="future_endeavors"..title="Future Endeavors"..description="Release a Wrestler."..iconCode=Icons.outbox.codePoint..isUnlocked=false,
        Milestone()..key="medical_ward"..title="Medical Ward"..description="Place a wrestler on IR."..iconCode=Icons.local_hospital.codePoint..isUnlocked=false,
        Milestone()..key="developmental"..title="Developmental"..description="Scout a Rookie."..iconCode=Icons.school.codePoint..isUnlocked=false,
        Milestone()..key="top_draw"..title="Top Draw"..description="Have a wrestler reach 90+ Pop."..iconCode=Icons.trending_up.codePoint..isUnlocked=false,
        Milestone()..key="workhorse"..title="Workhorse"..description="Have a wrestler reach 90+ Ring Skill."..iconCode=Icons.fitness_center.codePoint..isUnlocked=false,
        Milestone()..key="mic_worker"..title="Mic Worker"..description="Have a wrestler reach 90+ Mic Skill."..iconCode=Icons.mic.codePoint..isUnlocked=false,
        Milestone()..key="locker_room_leader"..title="Locker Room Leader"..description="Get a wrestler to 100 Morale."..iconCode=Icons.mood.codePoint..isUnlocked=false,
        Milestone()..key="win_war"..title="Ratings War Victory"..description="Beat the rival promotion in weekly ratings."..iconCode=Icons.show_chart.codePoint..isUnlocked=false,
        Milestone()..key="first_show"..title="Curtain Jerker"..description="Book and run your very first show."..iconCode=Icons.theater_comedy.codePoint..isUnlocked=false,
        Milestone()..key="survive_month"..title="Surviving the Month"..description="Reach Week 4."..iconCode=Icons.calendar_view_week.codePoint..isUnlocked=false,
        Milestone()..key="half_year"..title="Half a Year"..description="Reach Week 26."..iconCode=Icons.calendar_month.codePoint..isUnlocked=false,
        Milestone()..key="anniversary"..title="Anniversary"..description="Reach Year 1 (Week 52)."..iconCode=Icons.celebration.codePoint..isUnlocked=false,
        Milestone()..key="hall_of_fame"..title="Hall of Fame Tycoon"..description="Complete the Game (Week 156)."..iconCode=Icons.workspace_premium.codePoint..isUnlocked=false,
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
      await db.milestones.clear(); 
      
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
    await _injectWelcomeEmail(db); 
    
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

    await unlockMilestone("sponsor"); 
    if (state.activeSponsors.length >= 3) {
      await unlockMilestone("sellout_board"); 
    }
    
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
    
    await unlockMilestone("tv_deal"); 
    if (deal.tierLevel == 2) await unlockMilestone("prime_time_player");
    if (deal.tierLevel == 3) await unlockMilestone("late_night_wars");
    
    await saveGame(); 
  }

  void buyTechUpgrade(String type, int cost) {
    if (state.cash < cost) return;
    int cash = state.cash - cost;
    if (type == "BROADCAST") state = state.copyWith(cash: cash, techBroadcast: state.techBroadcast + 1);
    if (type == "PYRO") state = state.copyWith(cash: cash, techPyro: state.techPyro + 1);
    if (type == "AUDIO") state = state.copyWith(cash: cash, techAudio: state.techAudio + 1);
    if (type == "MEDICAL") state = state.copyWith(cash: cash, techMedical: state.techMedical + 1);
    
    if (state.techBroadcast >= 3) {
      unlockMilestone("broadcast_tycoon");
    }
    
    saveGame(); 
  }

  bool purchaseVenueUpgrade() {
    int next = state.venueLevel + 1;
    int cost = next == 2 ? 25000 : (next == 3 ? 250000 : 1000000); 
    int requiredFans = next == 2 ? 10000 : (next == 3 ? 100000 : 500000);
    
    if (state.cash >= cost && state.fans >= requiredFans && next <= 4) {
      state = state.copyWith(
        cash: state.cash - cost, 
        venueLevel: next, 
        isBiddingWarActive: state.activeTvDeal == null 
      ); 
      _generateInitialSponsors(); 
      
      if (next == 2) unlockMilestone("moving_on_up"); 
      if (next == 3) unlockMilestone("big_leagues"); 
      if (next == 4) unlockMilestone("stadium"); 
      
      saveGame(); 
      return true;
    }
    return false;
  }

  void enterTvNegotiations() {
    state = state.copyWith(isBiddingWarActive: true);
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
      newOffers.add(SponsorshipDeal()..sponsorName = "Luigi's Pizza"..description="Consistent local payout."..logoPath="assets/images/sponsor_pizza.png"..slotTarget=RealEstateSlot.turnbuckle..archetype=SponsorArchetype.consistency..durationInWeeks=12..weeksLeft=12..upfrontBonus=0..weeklyPayout=500..performanceBonusThreshold=2.0..performanceBonusAmount=0);
      newOffers.add(SponsorshipDeal()..sponsorName = "Muscle Mass"..description="High bonus for 4+ star Main Events."..logoPath="assets/images/sponsor_gym.png"..slotTarget=RealEstateSlot.turnbuckle..archetype=SponsorArchetype.performance..durationInWeeks=12..weeksLeft=12..upfrontBonus=0..weeklyPayout=100..performanceBonusThreshold=4.0..performanceBonusAmount=2500);
      newOffers.add(SponsorshipDeal()..sponsorName = "CryptoCoin"..description="Massive upfront cash. No weekly pay."..logoPath="assets/images/sponsor_crypto.png"..slotTarget=RealEstateSlot.turnbuckle..archetype=SponsorArchetype.upfrontCash..durationInWeeks=24..weeksLeft=24..upfrontBonus=15000..weeklyPayout=0..performanceBonusThreshold=0.0..performanceBonusAmount=0);
    }

    if (currentLevel >= 2 && !state.activeSponsors.any((s) => s.slotTarget == RealEstateSlot.canvas)) {
      newOffers.add(SponsorshipDeal()..sponsorName = "Monster Energy"..description="Premium energy drink. Wants their massive logo center-ring."..weeklyPayout=4500..upfrontBonus=5000..durationInWeeks=24..weeksLeft=24..slotTarget=RealEstateSlot.canvas..archetype=SponsorArchetype.upfrontCash);
      newOffers.add(SponsorshipDeal()..sponsorName = "Grip Fitness Gear"..description="Performance brand. Pays huge bonuses for 4+ Star main events."..weeklyPayout=2500..upfrontBonus=0..performanceBonusThreshold=4.0..performanceBonusAmount=5000..durationInWeeks=12..weeksLeft=12..slotTarget=RealEstateSlot.canvas..archetype=SponsorArchetype.performance);
    }

    if (currentLevel >= 3 && !state.activeSponsors.any((s) => s.slotTarget == RealEstateSlot.eventName)) {
      newOffers.add(SponsorshipDeal()..sponsorName = "Brosweiser Beer"..description="'Brosweiser Presents: Squared Circle TV'. Massive weekly payouts."..weeklyPayout=15000..upfrontBonus=20000..durationInWeeks=48..weeksLeft=48..slotTarget=RealEstateSlot.eventName..archetype=SponsorArchetype.upfrontCash);
    }

    if (currentLevel >= 4 && !state.activeSponsors.any((s) => s.slotTarget == RealEstateSlot.titantron)) {
      newOffers.add(SponsorshipDeal()..sponsorName = "Globex Tech Corp"..description="Silicon Valley giant wants the entire entrance Titantron video board."..weeklyPayout=50000..upfrontBonus=100000..durationInWeeks=48..weeksLeft=48..slotTarget=RealEstateSlot.titantron..archetype=SponsorArchetype.upfrontCash);
      newOffers.add(SponsorshipDeal()..sponsorName = "Prime Video Streaming"..description="Huge performance bonuses if your Stadium shows hit 4.5 Stars."..weeklyPayout=30000..upfrontBonus=0..performanceBonusThreshold=4.5..performanceBonusAmount=40000..durationInWeeks=24..weeksLeft=24..slotTarget=RealEstateSlot.titantron..archetype=SponsorArchetype.performance);
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
      ..body = "Empire Wrestling has failed to reach a new deal with $wrestlerName. They are officially a Free Agent!";
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
    // 🚨 THE PAYWALL ROADBLOCK 🚨
    if (!state.isFullGameUnlocked && state.week >= 12) {
      throw Exception("DEMO_LIMIT_REACHED");
    }

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
              if (winner.isTVChampion) winner.isTVChampion = false; 
              ref.read(rosterProvider.notifier).recordTitleChange("World Heavyweight", winner.name);
              await unlockMilestone("world_champ"); 
            }
            else if (loser.isTVChampion) {
              loser.isTVChampion = false;
              if (!winner.isChampion) { 
                winner.isTVChampion = true;
                ref.read(rosterProvider.notifier).recordTitleChange("Television Title", winner.name);
                await unlockMilestone("tv_champ"); 
              }
            }
            else {
              bool worldExists = roster.any((w) => w.isChampion && w.companyId == 0);
              bool tvExists = roster.any((w) => w.isTVChampion && w.companyId == 0);
              
              if (!worldExists) {
                winner.isChampion = true;
                if (winner.isTVChampion) winner.isTVChampion = false; 
                ref.read(rosterProvider.notifier).recordTitleChange("World Heavyweight", winner.name);
                await unlockMilestone("world_champ"); 
              } else if (!tvExists && !winner.isChampion) { 
                winner.isTVChampion = true;
                ref.read(rosterProvider.notifier).recordTitleChange("Television Title", winner.name);
                await unlockMilestone("tv_champ"); 
              }
            }
          }
        }
      }
      totalRatingScore += matchScore;
      
      if (matchScore >= 3.0) await unlockMilestone("decent_bout");
      if (matchScore >= 4.0) await unlockMilestone("show_stealer");
      if (matchScore >= 5.0) await unlockMilestone("five_star");
    }

    double rawRating = state.currentCard.isEmpty ? 0 : (totalRatingScore / state.currentCard.length);
    double rating = rawRating;
    if (state.techBroadcast == 1 && rawRating > 3.5) {
      rating = 3.5;
    } else if (state.techBroadcast == 2 && rawRating > 4.2) rating = 4.2; 
    rating = double.parse(rating.toStringAsFixed(1));

    if (rating >= 4.0) await unlockMilestone("perfect_card");
    if (rating < 2.0 && state.currentCard.isNotEmpty) await unlockMilestone("bad_night");

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
        
        await unlockMilestone("ppv_king"); 
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
          if (w.pop >= 90) await unlockMilestone("top_draw");
          if (w.ringSkill >= 90) await unlockMilestone("workhorse");
          if (w.micSkill >= 90) await unlockMilestone("mic_worker");
          if (w.morale >= 100) await unlockMilestone("locker_room_leader");

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
      case "EASY": signChance = 0.02; releasePopThreshold = 10; break;
      case "HARD": signChance = 0.25; releasePopThreshold = 35; break;
      case "TYCOON": signChance = 0.50; releasePopThreshold = 50; break;
      case "NORMAL": default: break;
    }

    List<Wrestler> rivalRoster = await db.wrestlers.filter().companyIdEqualTo(1).findAll();
    List<Wrestler> freeAgents = await db.wrestlers.filter().companyIdEqualTo(-1).and().isRookieEqualTo(false).findAll();
    List<Wrestler> updatedAiWrestlers = []; 
    List<Wrestler> newlySignedByAI = [];
    List<Wrestler> newlyReleasedByAI = [];

    rivalRoster.sort((a, b) => a.pop.compareTo(b.pop));

    for (var w in rivalRoster.toList()) {
      if (w.pop < releasePopThreshold || rivalRoster.length > maxRivalRosterSize) {
        w.companyId = -1; 
        w.morale = 50; 
        newlyReleasedByAI.add(w);
        updatedAiWrestlers.add(w); 
        rivalRoster.remove(w);
      }
    }

    freeAgents.sort((a, b) => b.pop.compareTo(a.pop));
    
    int aiSigningsThisWeek = 0;
    int maxSigningsPerWeek = currentDifficultyForAI == "TYCOON" ? 2 : 1; 
    double dynamicSignChance = state.week <= 4 ? (signChance * 0.5) : signChance;

    for (var fa in freeAgents) {
      if (aiSigningsThisWeek >= maxSigningsPerWeek) break; 

      int bossCount = rivalRoster.where((w) => w.pop >= 85).length;
      if (fa.pop >= 85 && bossCount >= 3) continue;

      if (rivalRoster.length < maxRivalRosterSize) {
        if (fa.pop > 65 && _rng.nextDouble() < dynamicSignChance) {
          fa.companyId = 1; 
          fa.contractWeeks = fa.pop >= 90 ? 12 : 48; 
          fa.morale = 100;
          rivalRoster.add(fa);
          newlySignedByAI.add(fa);
          updatedAiWrestlers.add(fa); 
          aiSigningsThisWeek++;
        }
      } else if (rivalRoster.length == maxRivalRosterSize) {
        var worstGuy = rivalRoster.first;
        if (fa.pop >= 80 && fa.pop > worstGuy.pop + 15 && _rng.nextDouble() < dynamicSignChance) {
          worstGuy.companyId = -1;
          worstGuy.morale = 50;
          newlyReleasedByAI.add(worstGuy);
          updatedAiWrestlers.add(worstGuy); 
          rivalRoster.remove(worstGuy);

          fa.companyId = 1;
          fa.contractWeeks = fa.pop >= 90 ? 12 : 48; 
          fa.morale = 100;
          rivalRoster.add(fa);
          newlySignedByAI.add(fa);
          updatedAiWrestlers.add(fa); 
          rivalRoster.sort((a, b) => a.pop.compareTo(b.pop));
          aiSigningsThisWeek++;
        }
      }
    }

    await db.writeTxn(() async { 
      await db.wrestlers.putAll(roster); 
      await db.wrestlers.putAll(updatedAiWrestlers); 
    });

    final currentDifficulty = ref.read(settingsProvider).difficulty;
    
    double rival = 3.0;
    try { rival = ref.read(rivalProvider).rating; } catch(e) {}
    
    double fanGrowthMultiplier = 1.0;

    switch (currentDifficulty) {
      case "EASY": rival -= 0.5; rating += 0.5; fanGrowthMultiplier = 1.5; break;
      case "HARD": rival += 0.5; fanGrowthMultiplier = 0.8; break;
      case "TYCOON": rival += 1.0; fanGrowthMultiplier = 0.5; totalExpenses = (totalExpenses * 1.2).toInt(); break;
      case "NORMAL": default: break;
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
      await unlockMilestone("win_war"); 
    } else if (diff < 0) {
      fChange += (diff * 75 * state.venueLevel).toInt(); 
    }

    if (state.fans < 500 && rating >= 2.5 && fChange < 25) fChange = 25;
    fChange = (fChange * fanGrowthMultiplier).toInt();
    int newFans = (state.fans + fChange).clamp(10, 10000000); 
    int newRep = (state.reputation + repChange).clamp(0, 100);

    if (newFans >= 10000) await unlockMilestone("cult_following");
    if (newFans >= 50000) await unlockMilestone("selling_out_gyms");
    if (newFans >= 100000) await unlockMilestone("regional_threat");
    if (newFans >= 500000) await unlockMilestone("national_spotlight");
    if (newFans >= 1000000) await unlockMilestone("global_phenomenon");

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

    await unlockMilestone("first_show");

    int newCash = state.cash + prof;
    if (newCash >= 10000) await unlockMilestone("first_dime");
    if (newCash >= 50000) await unlockMilestone("making_payroll");
    if (newCash >= 100000) await unlockMilestone("six_figures");
    if (newCash >= 250000) await unlockMilestone("quarter_mil");
    if (newCash >= 500000) await unlockMilestone("half_a_million");
    if (newCash >= 1000000) await unlockMilestone("rich");
    if (newCash >= 2500000) await unlockMilestone("big_business");
    if (newCash >= 5000000) await unlockMilestone("empire_builder");
    if (newCash >= 10000000) await unlockMilestone("wall_street_darling");
    if (newCash >= 25000000) await unlockMilestone("tycoon_status");

    if (state.week >= 4) await unlockMilestone("survive_month");
    if (state.week >= 26) await unlockMilestone("half_year");
    if (state.week >= 52) await unlockMilestone("anniversary");
    if (state.year >= 2 && state.week >= 52) await unlockMilestone("sophomore_year");

    await _generateWeeklyCommunications(rating, rival, roster, state.currentCard, newlySignedByAI, newlyReleasedByAI);

    state = state.copyWith(
      cash: newCash, 
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
    
    await ref.read(rosterProvider.notifier).decayRivalries();
    await ref.read(rosterProvider.notifier).processContracts();
    ref.read(rosterProvider.notifier).advanceTitleReigns();
    ref.read(rosterProvider.notifier).loadRoster(); 
  }
  
  Future<void> saveGame() async {
      final db = await _getDb(); 
      final save = GameSave()
          ..id = 1
          ..week = state.week
          ..year = state.year
          ..cash = state.cash
          ..fans = state.fans
          ..reputation = state.reputation
          ..promotionName = state.promotionName
          ..tvShowName = state.tvShowName
          ..venueLevel = state.venueLevel
          ..techBroadcast = state.techBroadcast
          ..techPyro = state.techPyro
          ..techAudio = state.techAudio
          ..techMedical = state.techMedical
          ..premierPpvIndex = state.premierPpvIndex
          ..ledgerJson = state.ledger.map((e) => jsonEncode(e.toMap())).toList()
          ..isFullGameUnlocked = state.isFullGameUnlocked; // 🚨 ADDED
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
    } catch (e) {}

    state = state.copyWith(week: 1, year: state.year + 1, ledger: []);
    await saveGame();
  }

  Future<void> _generateWeeklyCommunications(double showRating, double rivalRating, List<Wrestler> roster, List<Match> card, List<Wrestler> aiSignings, List<Wrestler> aiReleases) async {
    final db = await _getDb();
    List<NewsItem> newMessages = [];

    if (card.isNotEmpty) {
      var me = card.last;
      if (me.winnerName.isNotEmpty && me.winnerName != "Draw") {
        newMessages.add(NewsItem()..sender = "The Insider"..subject = "Show Recap: ${state.isPPV ? state.nextPPVName : state.tvShowName}"..body = "The main event delivered this week as ${me.winnerName} defeated ${me.loserName} in a ${me.rating}-star bout."..timestamp = DateTime.now()..isRead = false..actionRequired = false..type = "DIRT_SHEET");
      }
    }

    String socialSubject = "";
    String socialBody = "";
    if (showRating >= 4.0) {
      socialSubject = "Trending: Best Show Ever?";
      socialBody = "Just finished watching ${state.tvShowName}. Absolutely incredible wrestling tonight! ${showRating} stars easy. 📈🔥";
    } else if (showRating >= 3.0) {
      socialSubject = "Trending: Solid Show";
      socialBody = "Good matches tonight. The main event was pretty decent. Worth the watch. 👍";
    } else {
      socialSubject = "Trending: Refund Please";
      socialBody = "That was terrible. The booking makes no sense. Cancelled my subscription. 📉🗑️";
    }
    newMessages.add(NewsItem()..sender = "@SmarkyMark"..subject = socialSubject..body = socialBody..timestamp = DateTime.now()..isRead = false..actionRequired = false..type = "SOCIAL");

    if (state.week == 2) {
      newMessages.add(NewsItem()..sender = "Assistant GM"..subject = "Checking In"..body = "Good first week, Boss. Remember to keep an eye on talent stamina. If they get too tired, they will get injured!"..timestamp = DateTime.now()..isRead = false..actionRequired = false..type = "EMAIL");
    } else if (state.week == 3) {
      newMessages.add(NewsItem()..sender = "Assistant GM"..subject = "PPV Approaching!"..body = "Just a heads up—our first Pay-Per-View is next week! PPVs generate massive revenue, but only if the matches are hot. Use the Creative Hub to build up Rivalry Heat before the big show!"..timestamp = DateTime.now()..isRead = false..actionRequired = false..type = "EMAIL");
    } else if (state.week == 10) {
      newMessages.add(NewsItem()..sender = "HR Department"..subject = "Contract Expirations"..body = "Keep an eye on the Roster screen. Some of our talent's contracts are expiring soon. If they hit Free Agency, Empire Wrestling might snatch them up!"..timestamp = DateTime.now()..isRead = false..actionRequired = false..type = "EMAIL");
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
      newMessages.add(NewsItem()..sender = "Wrestling Observer"..subject = "Empire Wrestling Wins The Week"..body = "The Rival Promotion crushed it in the TV ratings this week. Sources say their Main Event drew massive numbers. Your promotion needs a hotter Main Event next week!"..timestamp = DateTime.now()..isRead = false..actionRequired = false..type = "DIRT_SHEET");
    }

    for(var w in aiSignings) {
      if (w.pop >= 85) {
        newMessages.add(NewsItem()..sender = "Wrestling Observer"..subject = "MAJOR SIGNING: ${w.name} to Empire Wrestling!"..body = "The wrestling world is shocked! Empire Wrestling just backed up the Brinks truck to sign ${w.name} to an exclusive deal. This shifts the balance of power!"..timestamp = DateTime.now()..isRead = false..actionRequired = false..type = "DIRT_SHEET");
        newMessages.add(NewsItem()..sender = "Assistant GM"..subject = "Boss, did you see this?!"..body = "They just signed ${w.name}! We completely missed out on a top star. We need to counter-program this immediately."..timestamp = DateTime.now()..isRead = false..actionRequired = false..type = "EMAIL");
      } else if (w.pop >= 70) {
        newMessages.add(NewsItem()..sender = "Wrestling Observer"..subject = "Empire Wrestling signs ${w.name}"..body = "Solid mid-card acquisition for the competition as they pick up ${w.name} from free agency."..timestamp = DateTime.now()..isRead = false..actionRequired = false..type = "DIRT_SHEET");
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