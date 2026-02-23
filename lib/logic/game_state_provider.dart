import 'dart:math'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../data/models/wrestler.dart';
import '../data/models/match.dart';
import '../data/models/show_history.dart';
import '../data/models/game_save.dart'; 
import '../data/models/tv_network_deal.dart'; 
import '../data/models/sponsorship_deal.dart'; 
import '../data/models/financial_record.dart'; 
import 'rival_provider.dart'; 

// --- DATA MODELS ---

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
    int? week, int? year, List<Match>? currentCard, List<FinancialEntry>? ledger,
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

// --- NOTIFIER ---

class GameNotifier extends StateNotifier<GameState> {
  final Ref ref;
  Isar? _isar;
  final Random _rng = Random(); 

  GameNotifier(this.ref) : super(GameState()) {
    _initDb();
  }

  Future<void> _initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      _isar = await Isar.open(
        [WrestlerSchema, MatchSchema, ShowHistorySchema, GameSaveSchema, TvNetworkDealSchema, SponsorshipDealSchema, FinancialRecordSchema], 
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
        week: existingSave.week,
        year: existingSave.year,
        cash: existingSave.cash,
        fans: existingSave.fans,
        reputation: existingSave.reputation,
        promotionName: existingSave.promotionName,
        tvShowName: existingSave.tvShowName,
        venueLevel: existingSave.venueLevel,
        techBroadcast: existingSave.techBroadcast,
        techPyro: existingSave.techPyro,
        techAudio: existingSave.techAudio,
        techMedical: existingSave.techMedical,
        premierPpvIndex: existingSave.premierPpvIndex, 
        activeTvDeal: currentDeal,
        activeSponsors: currentSponsors,
        isBiddingWarActive: currentDeal == null, 
        isLoading: false,
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
      final deals = await _isar!.tvNetworkDeals.where().findAll();
      for (var d in deals) { d.promotionId = -1; }
      await _isar!.tvNetworkDeals.putAll(deals);
      await _isar!.sponsorshipDeals.clear(); 
      await _isar!.financialRecords.clear(); 
    });

    state = GameState(
      week: 1, year: 1, cash: 50000, fans: 100, reputation: 10, ledger: [], isLoading: false, isBiddingWarActive: true, premierPpvIndex: 11
    );
    await _saveGame();
  }

  void startNewSeason() => state = state.copyWith(week: 1, year: state.year + 1, currentCard: []);
  void renamePromotion(String name) { state = state.copyWith(promotionName: name); _saveGame(); }
  void renameTVShow(String name) { state = state.copyWith(tvShowName: name); _saveGame(); }
  void setPremierPpv(int index) { state = state.copyWith(premierPpvIndex: index); _saveGame(); }
  void renamePPV(int i, String n) {
    final list = List<String>.from(state.ppvNames);
    list[i] = n;
    state = state.copyWith(ppvNames: list);
    _saveGame();
  }

  Future<void> signSponsor(SponsorshipDeal deal) async {
    if (_isar == null) return;
    
    bool slotTaken = state.activeSponsors.any((s) => s.slotTarget == deal.slotTarget);
    if (slotTaken) return; 

    int newCash = state.cash + deal.upfrontBonus;

    await _isar!.writeTxn(() async {
      deal.promotionId = 0;
      await _isar!.sponsorshipDeals.put(deal);
    });

    state = state.copyWith(
      cash: newCash,
      activeSponsors: [...state.activeSponsors, deal],
      availableOffers: state.availableOffers.where((d) => d.id != deal.id).toList()
    );
    _saveGame();
  }

  Future<void> signTvDeal(TvNetworkDeal deal) async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async {
      final oldDeals = await _isar!.tvNetworkDeals.filter().promotionIdEqualTo(0).findAll();
      for (var d in oldDeals) { d.promotionId = -1; await _isar!.tvNetworkDeals.put(d); }
      deal.promotionId = 0;
      await _isar!.tvNetworkDeals.put(deal);
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
      _saveGame();
      return true;
    }
    return false;
  }

  void addMatchToCard(Match m) => state = state.copyWith(currentCard: [...state.currentCard, m]);
  void clearCard() => state = state.copyWith(currentCard: []);

  void _generateInitialSponsors() {
    if (state.availableOffers.isEmpty && state.activeSponsors.isEmpty) {
        state = state.copyWith(availableOffers: [
          SponsorshipDeal()..id = 100000..sponsorName = "Luigi's Pizza"..description="Consistent local payout."..logoPath="assets/images/sponsor_pizza.png"..slotTarget=RealEstateSlot.turnbuckle..archetype=SponsorArchetype.consistency..durationInWeeks=12..weeksLeft=12..upfrontBonus=0..weeklyPayout=500..performanceBonusThreshold=2.0..performanceBonusAmount=0,
          SponsorshipDeal()..id = 100001..sponsorName = "Muscle Mass"..description="High bonus for 4+ star Main Events."..logoPath="assets/images/sponsor_gym.png"..slotTarget=RealEstateSlot.turnbuckle..archetype=SponsorArchetype.performance..durationInWeeks=12..weeksLeft=12..upfrontBonus=0..weeklyPayout=100..performanceBonusThreshold=4.0..performanceBonusAmount=2500,
          SponsorshipDeal()..id = 100002..sponsorName = "CryptoCoin"..description="Massive upfront cash. No weekly pay."..logoPath="assets/images/sponsor_crypto.png"..slotTarget=RealEstateSlot.turnbuckle..archetype=SponsorArchetype.upfrontCash..durationInWeeks=24..weeksLeft=24..upfrontBonus=15000..weeklyPayout=0..performanceBonusThreshold=0.0..performanceBonusAmount=0,
        ]);
    }
  }

  Future<void> processWeek(List<Wrestler> roster) async {
    // 1. EXPENSES
    int sal = roster.fold(0, (sum, w) => sum + w.salary);
    int prod = 0;
    if (state.techBroadcast == 2) prod += 10000;
    if (state.techBroadcast >= 3) prod += 50000;

    int rent;
    switch(state.venueLevel) {
      case 2: rent = 5000; break;
      case 3: rent = 50000; break;
      case 4: rent = 250000; break;
      case 1:
      default: rent = 500; break;
    }
    
    int facCosts = state.techMedical * 2500; 
    int totalExpenses = sal + prod + rent + facCosts;

    // 2. RATINGS
    double rawRating = state.currentCard.isEmpty ? 0 : (state.currentCard.fold(0.0, (s, m) => s + m.rating) / state.currentCard.length);
    
    // --- FIX: MUCH MORE FORGIVING PRODUCTION PENALTY ---
    double rating = rawRating;
    
    if (state.techBroadcast == 1 && rawRating > 3.5) {
      // If you have Level 1 cameras, you max out at 3.5 stars (Local Indie Cap)
      rating = 3.5; 
    } else if (state.techBroadcast == 2 && rawRating > 4.2) {
      // If you have Level 2 cameras, you max out at 4.2 stars (Regional TV Cap)
      rating = 4.2;
    } 
    // If you have Level 3 cameras, there is NO cap. You can hit 5.0!

    rating = double.parse(rating.toStringAsFixed(1));

    // 3. INCOME
    int tvPayout = 0;
    int ppvPayout = 0;
    int gate = (state.fans * 15); 
    int merch = (state.fans * 8); 

    if (state.activeTvDeal != null) {
      tvPayout = state.activeTvDeal!.weeklyPayout;
      if (!state.isPPV && rating < state.activeTvDeal!.targetMinimumRating) {
        tvPayout = (tvPayout * 0.5).toInt(); 
      }
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

    // 4. SPONSORS
    int sponPay = 0;
    List<SponsorshipDeal> dealsToKeep = [];
    double mainEventRating = state.currentCard.isNotEmpty ? state.currentCard.last.rating : 0.0;

    for (var s in state.activeSponsors) {
      bool voidContract = false;
      if (s.archetype == SponsorArchetype.consistency) {
        if (rating < 2.5) voidContract = true;
        else sponPay += s.weeklyPayout;
      } 
      else if (s.archetype == SponsorArchetype.performance) {
        sponPay += s.weeklyPayout; 
        if (mainEventRating >= s.performanceBonusThreshold) sponPay += s.performanceBonusAmount;
      }
      else if (s.archetype == SponsorArchetype.upfrontCash) {
        sponPay += s.weeklyPayout; 
      }

      if (!voidContract) {
        s.weeksLeft -= 1;
        if (s.weeksLeft > 0) dealsToKeep.add(s);
      }
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
      final finRecord = FinancialRecord()
        ..year = state.year
        ..week = state.week
        ..tvRevenue = tvPayout
        ..ppvRevenue = ppvPayout
        ..ticketSales = gate
        ..merchandiseSales = merch
        ..sponsorshipRevenue = sponPay
        ..rosterPayroll = sal
        ..productionCosts = prod
        ..facilityCosts = facCosts
        ..logisticsCosts = rent;

      await _isar!.writeTxn(() async {
        await _isar!.financialRecords.put(finRecord);
      });
    }

    // 5. STAMINA & ROSTER
    if (_isar != null) {
      List<int> bookedIds = [];
      for (var match in state.currentCard) {
          for (var w in match.wrestlers) { bookedIds.add(w.id); }
      }

      for (var w in roster) {
          if (w.isInjured) {
              w.injuryWeeks -= 1;
              if (w.injuryWeeks <= 0) {
                  w.isInjured = false;
                  w.injuryWeeks = 0;
                  w.stamina = 50; 
              } else { w.stamina += 10; }
          } else {
              if (bookedIds.contains(w.id)) {
                  w.stamina -= 15; w.morale += 5;
                  if (w.stamina < 20 && _rng.nextDouble() < 0.40) { 
                      w.isInjured = true; w.injuryWeeks = _rng.nextInt(3) + 2; 
                  }
              } else { w.stamina += 15; w.morale -= 2; }
          }
          w.stamina = w.stamina.clamp(0, 100);
          w.morale = w.morale.clamp(0, 100);
          w.contractWeeks -= 1;
          if (w.contractWeeks < 0) w.contractWeeks = 0;
      }
      await _isar!.writeTxn(() async { await _isar!.wrestlers.putAll(roster); });
    }

    double rival = 3.0;
    try { rival = ref.read(rivalProvider).rating; } catch(e) {}
    int fChange = rating > rival ? 15 + ((rating - rival) * 50).toInt() : (state.fans < 1000 ? 5 : -10 - ((rival - rating) * 20).toInt());
    
    if (state.currentCard.isNotEmpty && _isar != null) {
      final historyEntry = ShowHistory()..timestamp = DateTime.now()..week = state.week..year = state.year..showName = state.isPPV ? state.nextPPVName : state.tvShowName..avgRating = rating..totalProfit = prof..attendance = gate ~/ 20..highlights = _generateHighlights();
      await _isar!.writeTxn(() async { await _isar!.showHistorys.put(historyEntry); });
    }

    // --- FIX: DETAILED FINANCIAL ENTRY CAPTURES RATINGS ---
    state = state.copyWith(
      cash: state.cash + prof, 
      fans: (state.fans + fChange).clamp(0, 1000000), 
      week: state.week + 1,
      ledger: [
        FinancialEntry()
          ..week = state.week
          ..year = state.year
          ..incomeTickets = gate
          ..incomeMerch = merch 
          ..incomeSponsors = sponPay
          ..incomeTvDeal = tvPayout 
          ..expenseSalaries = sal
          ..expenseProduction = prod
          ..expenseRent = rent
          ..profit = prof
          ..showRating = rating       // Captures the actual show rating
          ..rivalRating = rival       // Captures the actual rival rating
          ..warResult = (rating > rival ? "VICTORY" : (rating < rival ? "DEFEAT" : "DRAW")), 
        ...state.ledger
      ],
      currentCard: [], 
      activeSponsors: dealsToKeep,
    );
    _saveGame();
  }
  
  Future<void> _saveGame() async {
      if (_isar == null) return;
      
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
        ..premierPpvIndex = state.premierPpvIndex; 

      await _isar!.writeTxn(() async {
          await _isar!.gameSaves.put(save);
      });
  }


  Future<void> processYearEnd() async {
    if (_isar == null) return;

    // Evaluate the 52-week ledger for Event of the Year
    double highestRating = 0.0;
    if (state.ledger.isNotEmpty) {
      highestRating = state.ledger.reduce((a, b) => a.showRating > b.showRating ? a : b).showRating;
    }

    // Calculate Total Annual Profit
    int totalProfit = state.ledger.fold(0, (sum, e) => sum + e.profit);

    // Evaluate Roster for Wrestler of the Year
    final roster = await _isar!.wrestlers.where().findAll();
    roster.sort((a, b) => b.pop.compareTo(a.pop));
    Wrestler? woty = roster.isNotEmpty ? roster.first : null;

    // Clear the ledger, reset week to 1, increment year by 1
    state = state.copyWith(
      week: 1,
      year: state.year + 1,
      ledger: [],
    );

    await _saveGame();
  }

  List<String> _generateHighlights() {
    List<String> notes = [];
    for (var m in state.currentCard) {
      if (m.rating >= 4.5) {
        notes.add("⭐ 5-STAR CLASSIC: ${m.winnerName} put on a masterpiece!");
      }
    }
    return notes;
  }
}

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) => GameNotifier(ref));