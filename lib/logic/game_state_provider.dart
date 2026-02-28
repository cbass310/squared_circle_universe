import 'dart:math'; 
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
import '../data/models/news_item.dart'; // 🚨 NEW IMPORT!

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
      "New Year's Revolution", "Valentine's Vengeance", "March Massacre",
      "Spring Stampede", "Mayhem", "June Justice", "Heatwave",
      "Summer Showdown", "September Slam", "Halloween Havoc",
      "November Nightmare", "Starrcade"
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
  Isar? _isar;
  final Random _rng = Random(); 
  
  bool _stagedTitleMatchFlag = false;

  GameNotifier(this.ref) : super(GameState()) {
    _initDb();
  }

  Future<void> _initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      _isar = await Isar.open(
        [WrestlerSchema, MatchSchema, ShowHistorySchema, GameSaveSchema, TvNetworkDealSchema, SponsorshipDealSchema, FinancialRecordSchema, NewsItemSchema], 
        directory: dir.path
      );
    } else {
      _isar = Isar.getInstance();
    }
    
    final networkCount = await _isar!.tvNetworkDeals.count();
    if (networkCount == 0) await _seedNetworks();

    final currentDeal = await _isar!.tvNetworkDeals.filter().promotionIdEqualTo(0).findFirst();
    final currentSponsors = await _isar!.sponsorshipDeals.filter().promotionIdEqualTo(0).findAll();
    final existingSave = await _isar!.gameSaves.get(1); 

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

  Future<void> _seedNetworks() async {
    if (_isar == null) return;
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
    await _isar!.writeTxn(() async { await _isar!.tvNetworkDeals.putAll(networks); });
  }

  Future<void> resetGame() async {
    if (_isar == null) return;
    
    await _isar!.writeTxn(() async {
      await _isar!.gameSaves.clear();
      await _isar!.sponsorshipDeals.clear(); 
      await _isar!.financialRecords.clear(); 
      await _isar!.newsItems.clear(); // Clear old news!
      
      final deals = await _isar!.tvNetworkDeals.where().findAll();
      for (var d in deals) { d.promotionId = -1; }
      await _isar!.tvNetworkDeals.putAll(deals);
    });

    state = GameState(
      week: 1, year: 1, cash: 50000, fans: 100, reputation: 10, 
      ledger: [], isLoading: false, isBiddingWarActive: true, premierPpvIndex: 11,
      activeSponsors: [], availableOffers: []
    );

    final networkCount = await _isar!.tvNetworkDeals.count();
    if (networkCount == 0) await _seedNetworks();

    _generateInitialSponsors();
    await _saveGame();
  }

  void startNewSeason() => state = state.copyWith(week: 1, year: state.year + 1, currentCard: [], titleMatchFlags: []);
  void renamePromotion(String name) { state = state.copyWith(promotionName: name); _saveGame(); }
  void renameTVShow(String name) { state = state.copyWith(tvShowName: name); _saveGame(); }
  void setPremierPpv(int index) { state = state.copyWith(premierPpvIndex: index); _saveGame(); }
  void renamePPV(int i, String n) {
    final list = List<String>.from(state.ppvNames); list[i] = n;
    state = state.copyWith(ppvNames: list); _saveGame();
  }

  Future<void> signSponsor(SponsorshipDeal deal) async {
    if (_isar == null) return;
    bool slotTaken = state.activeSponsors.any((s) => s.slotTarget == deal.slotTarget);
    if (slotTaken) return; 
    int newCash = state.cash + deal.upfrontBonus;
    await _isar!.writeTxn(() async { deal.promotionId = 0; await _isar!.sponsorshipDeals.put(deal); });
    state = state.copyWith(cash: newCash, activeSponsors: [...state.activeSponsors, deal], availableOffers: state.availableOffers.where((d) => d.id != deal.id).toList());
    _saveGame();
  }

  Future<void> signTvDeal(TvNetworkDeal deal) async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async {
      final oldDeals = await _isar!.tvNetworkDeals.filter().promotionIdEqualTo(0).findAll();
      for (var d in oldDeals) { d.promotionId = -1; await _isar!.tvNetworkDeals.put(d); }
      deal.promotionId = 0; await _isar!.tvNetworkDeals.put(deal);
    });
    state = state.copyWith(activeTvDeal: deal, isBiddingWarActive: false);
  }

  void buyTechUpgrade(String type, int cost) {
    if (state.cash < cost) return;
    int cash = state.cash - cost;
    if (type == "BROADCAST") state = state.copyWith(cash: cash, techBroadcast: state.techBroadcast + 1);
    if (type == "PYRO") state = state.copyWith(cash: cash, techPyro: state.techPyro + 1);
    if (type == "AUDIO") state = state.copyWith(cash: cash, techAudio: state.techAudio + 1);
    if (type == "MEDICAL") state = state.copyWith(cash: cash, techMedical: state.techMedical + 1);
    _saveGame();
  }

  bool purchaseVenueUpgrade() {
    int next = state.venueLevel + 1;
    int cost = next == 2 ? 25000 : (next == 3 ? 250000 : 1000000); 
    if (state.cash >= cost && next <= 4) {
      state = state.copyWith(cash: state.cash - cost, venueLevel: next, isBiddingWarActive: true); 
      _saveGame(); return true;
    }
    return false;
  }

  void spendCash(int amount) { state = state.copyWith(cash: state.cash - amount); _saveGame(); }

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
    if (state.availableOffers.isEmpty && state.activeSponsors.isEmpty) {
        state = state.copyWith(availableOffers: [
          SponsorshipDeal()..id = 100000..sponsorName = "Luigi's Pizza"..description="Consistent local payout."..logoPath="assets/images/sponsor_pizza.png"..slotTarget=RealEstateSlot.turnbuckle..archetype=SponsorArchetype.consistency..durationInWeeks=12..weeksLeft=12..upfrontBonus=0..weeklyPayout=500..performanceBonusThreshold=2.0..performanceBonusAmount=0,
          SponsorshipDeal()..id = 100001..sponsorName = "Muscle Mass"..description="High bonus for 4+ star Main Events."..logoPath="assets/images/sponsor_gym.png"..slotTarget=RealEstateSlot.turnbuckle..archetype=SponsorArchetype.performance..durationInWeeks=12..weeksLeft=12..upfrontBonus=0..weeklyPayout=100..performanceBonusThreshold=4.0..performanceBonusAmount=2500,
          SponsorshipDeal()..id = 100002..sponsorName = "CryptoCoin"..description="Massive upfront cash. No weekly pay."..logoPath="assets/images/sponsor_crypto.png"..slotTarget=RealEstateSlot.turnbuckle..archetype=SponsorArchetype.upfrontCash..durationInWeeks=24..weeksLeft=24..upfrontBonus=15000..weeklyPayout=0..performanceBonusThreshold=0.0..performanceBonusAmount=0,
        ]);
    }
  }

  // =========================================================================
  // 🚀 PROCESS WEEK ENGINE 
  // =========================================================================
  Future<void> processWeek(List<Wrestler> roster) async {
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
        weeklyHighlights.add("$matchPosition: Match ended in a Draw (${matchScore} ⭐)");
      } else {
        weeklyHighlights.add("$matchPosition: $winnerName defeated $loserName (${matchScore} ⭐)");
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
          }
        }
      }
      totalRatingScore += matchScore;
    }

    double rawRating = state.currentCard.isEmpty ? 0 : (totalRatingScore / state.currentCard.length);
    double rating = rawRating;
    if (state.techBroadcast == 1 && rawRating > 3.5) rating = 3.5; 
    else if (state.techBroadcast == 2 && rawRating > 4.2) rating = 4.2; 
    rating = double.parse(rating.toStringAsFixed(1));

    int tvPayout = 0; int ppvPayout = 0; int gate = (state.fans * 15); int merch = (state.fans * 8); 

    if (state.activeTvDeal != null) {
      tvPayout = state.activeTvDeal!.weeklyPayout;
      if (!state.isPPV && rating < state.activeTvDeal!.targetMinimumRating) tvPayout = (tvPayout * 0.5).toInt(); 
      if (state.isPPV) {
        int currentPpvIndex = ((state.week - 1) ~/ 4) % 12;
        bool isPremier = currentPpvIndex == state.premierPpvIndex;
        double prestigeBonus = isPremier ? 1.5 : 1.0; 

        if (state.activeTvDeal!.cannibalizesPPVs) tvPayout = (state.activeTvDeal!.weeklyPayout * 2 * prestigeBonus).toInt(); 
        else ppvPayout = (state.fans * 30 * state.activeTvDeal!.ppvBonusMultiplier * prestigeBonus).toInt();
      }
    } else tvPayout = 1000;

    int sponPay = 0; List<SponsorshipDeal> dealsToKeep = [];
    double mainEventRating = state.currentCard.isNotEmpty ? state.currentCard.last.rating : 0.0;

    for (var s in state.activeSponsors) {
      bool voidContract = false;
      if (s.archetype == SponsorArchetype.consistency) { if (rating < 2.5) voidContract = true; else sponPay += s.weeklyPayout; } 
      else if (s.archetype == SponsorArchetype.performance) { sponPay += s.weeklyPayout; if (mainEventRating >= s.performanceBonusThreshold) sponPay += s.performanceBonusAmount; }
      else if (s.archetype == SponsorArchetype.upfrontCash) sponPay += s.weeklyPayout; 

      if (!voidContract) { s.weeksLeft -= 1; if (s.weeksLeft > 0) dealsToKeep.add(s); }
    }

    if (_isar != null) {
      await _isar!.writeTxn(() async {
        final currentDbSponsors = await _isar!.sponsorshipDeals.filter().promotionIdEqualTo(0).findAll();
        for(var dbSponsor in currentDbSponsors) { dbSponsor.promotionId = -1; await _isar!.sponsorshipDeals.put(dbSponsor); }
        for(var keeper in dealsToKeep) { keeper.promotionId = 0; await _isar!.sponsorshipDeals.put(keeper); }
      });
    }

    int prof = (gate + merch + tvPayout + ppvPayout + sponPay) - totalExpenses;

    if (_isar != null) {
      final finRecord = FinancialRecord()..year = state.year..week = state.week..tvRevenue = tvPayout..ppvRevenue = ppvPayout..ticketSales = gate..merchandiseSales = merch..sponsorshipRevenue = sponPay..rosterPayroll = sal..productionCosts = prod..facilityCosts = facCosts..logisticsCosts = rent;
      await _isar!.writeTxn(() async { await _isar!.financialRecords.put(finRecord); });
    }

    if (_isar != null) {
      List<String> bookedNames = [];
      for (var match in state.currentCard) { 
        if (match.winnerName.isNotEmpty) bookedNames.add(match.winnerName);
        if (match.loserName.isNotEmpty && match.loserName != "Unknown") bookedNames.add(match.loserName);
      }

      for (var w in roster) {
          if (w.isInjured) {
              w.injuryWeeks -= 1;
              if (w.injuryWeeks <= 0) { w.isInjured = false; w.injuryWeeks = 0; w.stamina = 50; } else w.stamina += 10; 
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
      int maxRivalRosterSize = 15;

      switch (currentDifficultyForAI) {
        case "EASY":
          signChance = 0.02; 
          releasePopThreshold = 10; 
          break;
        case "HARD":
          signChance = 0.25; 
          releasePopThreshold = 35; 
          maxRivalRosterSize = 18;
          break;
        case "TYCOON":
          signChance = 0.50; 
          releasePopThreshold = 50; 
          maxRivalRosterSize = 20;
          break;
        case "NORMAL":
        default:
          break;
      }

      List<Wrestler> rivalRoster = roster.where((w) => w.companyId == 1).toList();
      List<Wrestler> freeAgents = roster.where((w) => w.companyId == -1).toList();

      for (var w in rivalRoster.toList()) {
        if (w.pop < releasePopThreshold && rivalRoster.length > 10) {
          w.companyId = -1; 
          w.morale = 50; 
          rivalRoster.remove(w);
        }
      }

      if (rivalRoster.length < maxRivalRosterSize) {
        freeAgents.sort((a, b) => b.pop.compareTo(a.pop));
        
        for (var fa in freeAgents) {
          if (fa.pop > 65) {
            if (_rng.nextDouble() < signChance) {
              fa.companyId = 1; 
              fa.contractWeeks = 48;
              fa.morale = 100;
              rivalRoster.add(fa);
              break; 
            }
          }
        }
      }

      await _isar!.writeTxn(() async { await _isar!.wrestlers.putAll(roster); });
    }

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
    } else if (diff < 0) {
      fChange += (diff * 75 * state.venueLevel).toInt(); 
    }

    if (state.fans < 500 && rating >= 2.5 && fChange < 25) {
      fChange = 25;
    }

    fChange = (fChange * fanGrowthMultiplier).toInt();
    int newFans = (state.fans + fChange).clamp(10, 10000000); 
    int newRep = (state.reputation + repChange).clamp(0, 100);

    if (state.currentCard.isNotEmpty && _isar != null) {
      final historyEntry = ShowHistory()
        ..timestamp = DateTime.now()
        ..week = state.week
        ..year = state.year
        ..showName = state.isPPV ? state.nextPPVName : state.tvShowName
        ..avgRating = rating
        ..totalProfit = prof
        ..attendance = gate ~/ 20
        ..highlights = weeklyHighlights; 
      await _isar!.writeTxn(() async { await _isar!.showHistorys.put(historyEntry); });
    }

    // 🚨 NEW: Trigger the Smart Communications Engine!
    await _generateWeeklyCommunications(rating, rival, roster, state.currentCard);

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
    _saveGame();
    
    ref.read(rosterProvider.notifier).advanceTitleReigns();
    ref.read(rosterProvider.notifier).loadRoster(); 
  }
  
  Future<void> _saveGame() async {
      if (_isar == null) return;
      final save = GameSave()..id = 1..week = state.week..year = state.year..cash = state.cash..fans = state.fans..reputation = state.reputation..promotionName = state.promotionName..tvShowName = state.tvShowName..venueLevel = state.venueLevel..techBroadcast = state.techBroadcast..techPyro = state.techPyro..techAudio = state.techAudio..techMedical = state.techMedical..premierPpvIndex = state.premierPpvIndex; 
      await _isar!.writeTxn(() async { await _isar!.gameSaves.put(save); });
  }

  Future<void> processYearEnd() async {
    if (_isar == null) return;
    
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
    await _saveGame();
  }

  // =========================================================================
  // 📧 SMART COMMUNICATIONS ENGINE
  // =========================================================================
  Future<void> _generateWeeklyCommunications(double showRating, double rivalRating, List<Wrestler> roster, List<Match> card) async {
    if (_isar == null) return;
    List<NewsItem> newMessages = [];

    // --- 1. MILESTONE ONBOARDING ---
    if (state.week == 1) {
      newMessages.add(NewsItem()
        ..sender = "Assistant GM"
        ..subject = "Welcome to the Office!"
        ..body = "Boss, welcome to the big leagues! Before you book a show, check the Broadcasting tab to secure a TV deal, and visit the Sponsors tab to get some upfront cash. We need that money to pay the talent!"
        ..timestamp = DateTime.now()
        ..isRead = false
        ..actionRequired = false
        ..type = "EMAIL"
      );
    } else if (state.week == 3) {
      newMessages.add(NewsItem()
        ..sender = "Assistant GM"
        ..subject = "PPV Approaching!"
        ..body = "Just a heads up—our first Pay-Per-View is next week! PPVs generate massive revenue, but only if the matches are hot. Use the Creative Hub to build up Rivalry Heat before the big show!"
        ..timestamp = DateTime.now()
        ..isRead = false
        ..actionRequired = false
        ..type = "EMAIL"
      );
    } else if (state.week == 10) {
      newMessages.add(NewsItem()
        ..sender = "HR Department"
        ..subject = "Contract Expirations"
        ..body = "Keep an eye on the Roster screen. Some of our talent's contracts are expiring soon. If they hit Free Agency, the Rival AI might snatch them up!"
        ..timestamp = DateTime.now()
        ..isRead = false
        ..actionRequired = false
        ..type = "EMAIL"
      );
    }

    // --- 2. REACTIVE TRIGGERS ---
    
    // Financial Warning
    if (state.cash < 15000 && state.week > 2) {
      newMessages.add(NewsItem()
        ..sender = "Accounting"
        ..subject = "URGENT: Financial Warning"
        ..body = "We are bleeding cash! You need to put on better shows to boost ticket sales, or release some expensive dead-weight from the roster. If we hit \$0, it's game over."
        ..timestamp = DateTime.now()
        ..isRead = false
        ..actionRequired = false
        ..type = "EMAIL"
      );
    }

    // Low Morale Threat (30% chance to trigger)
    var angryWrestler = roster.where((w) => w.companyId == 0 && w.morale <= 30).firstOrNull;
    if (angryWrestler != null && _rng.nextDouble() < 0.3) { 
      newMessages.add(NewsItem()
        ..sender = angryWrestler.name
        ..subject = "My Booking..."
        ..body = "I'm sick of sitting in the back or losing matches. Use me better, put me in a real storyline, or I'm walking out."
        ..timestamp = DateTime.now()
        ..isRead = false
        ..actionRequired = false
        ..type = "EMAIL"
      );
    }

    // 5-Star Match Praise (Dirt Sheet)
    var banger = card.where((m) => m.rating >= 4.5).firstOrNull;
    if (banger != null && banger.winnerName.isNotEmpty && banger.winnerName != "Draw") {
      newMessages.add(NewsItem()
        ..sender = "Wrestling Observer"
        ..subject = "Match of the Year Contender?"
        ..body = "Fans are absolutely buzzing about the ${banger.winnerName} vs ${banger.loserName} match this week. An absolute masterclass in ring psychology. Ratings gold!"
        ..timestamp = DateTime.now()
        ..isRead = false
        ..actionRequired = false
        ..type = "DIRT_SHEET"
      );
    }

    // Rival Ratings War Update (Dirt Sheet)
    if (rivalRating > showRating && state.week > 1 && _rng.nextDouble() < 0.4) {
      newMessages.add(NewsItem()
        ..sender = "Wrestling Observer"
        ..subject = "Rival Promotion Wins The Week"
        ..body = "The Rival Promotion crushed it in the TV ratings this week. Sources say their Main Event drew massive numbers. Your promotion needs a hotter Main Event next week!"
        ..timestamp = DateTime.now()
        ..isRead = false
        ..actionRequired = false
        ..type = "DIRT_SHEET"
      );
    }

    if (newMessages.isNotEmpty) {
      await _isar!.writeTxn(() async {
        await _isar!.newsItems.putAll(newMessages);
      });
    }
  }
}

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) => GameNotifier(ref));