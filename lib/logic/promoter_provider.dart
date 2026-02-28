import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../data/models/wrestler.dart';
import '../data/models/match.dart'; 
import '../data/models/show_history.dart';
import '../data/models/game_save.dart';
import '../data/models/rivalry.dart' as db; 
import '../data/models/news_item.dart'; 
import '../data/models/show_card.dart'; 
import '../data/models/tv_network_deal.dart'; 
import '../data/models/sponsorship_deal.dart'; 
import '../data/models/financial_record.dart';
import 'game_state_provider.dart'; 
import 'rival_provider.dart';      

// --- DATA MODELS ---

class Rivalry {
  final Wrestler wrestlerA;
  final Wrestler wrestlerB;
  final String name;
  final int heat;
  final int durationWeeks;

  Rivalry({
    required this.wrestlerA,
    required this.wrestlerB,
    required this.name,
    this.heat = 50,
    this.durationWeeks = 0,
  });
}

class TitleInfo {
  final String beltName;
  final String championName;
  final int reignWeeks;

  TitleInfo({
    required this.beltName,
    required this.championName,
    required this.reignWeeks,
  });
}

class AwardResult {
  final String wrestlerOfTheYear;
  final String matchOfTheYear;
  final double matchRating;
  final String tagTeamOfTheYear;
  final String mostImproved;
  final int totalProfit;

  AwardResult({
    required this.wrestlerOfTheYear,
    required this.matchOfTheYear,
    required this.matchRating,
    required this.tagTeamOfTheYear,
    required this.mostImproved,
    required this.totalProfit,
  });
}

class RandomEvent {
  final String title;
  final String description;
  final String optionA;
  final String optionB;
  final Function(WidgetRef) onOptionA;
  final Function(WidgetRef) onOptionB;

  RandomEvent({
    required this.title,
    required this.description,
    required this.optionA,
    required this.optionB,
    required this.onOptionA,
    required this.onOptionB,
  });
}

class RosterState {
  final List<Wrestler> roster;
  final List<Wrestler> injuredReserve; 
  final List<Wrestler> freeAgents;
  final List<Wrestler> unscoutedProspects; 
  final List<Rivalry> activeRivalries; 
  final List<TitleInfo> titleHistory; 
  final int venueLevel; 
  final int bankAccount; 
  final bool isLoading;

  RosterState({
    this.roster = const [], 
    this.injuredReserve = const [],
    this.freeAgents = const [], 
    this.unscoutedProspects = const [],
    this.activeRivalries = const [],
    this.titleHistory = const [], 
    this.venueLevel = 1, 
    this.bankAccount = 50000, 
    this.isLoading = true
  });

  RosterState copyWith({
    List<Wrestler>? roster, 
    List<Wrestler>? injuredReserve,
    List<Wrestler>? freeAgents, 
    List<Wrestler>? unscoutedProspects,
    List<Rivalry>? activeRivalries,
    List<TitleInfo>? titleHistory,
    int? venueLevel,
    int? bankAccount,
    bool? isLoading
  }) {
    return RosterState(
      roster: roster ?? this.roster,
      injuredReserve: injuredReserve ?? this.injuredReserve,
      freeAgents: freeAgents ?? this.freeAgents,
      unscoutedProspects: unscoutedProspects ?? this.unscoutedProspects,
      activeRivalries: activeRivalries ?? this.activeRivalries,
      titleHistory: titleHistory ?? this.titleHistory,
      venueLevel: venueLevel ?? this.venueLevel,
      bankAccount: bankAccount ?? this.bankAccount,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// --- PROVIDER LOGIC ---

class RosterNotifier extends StateNotifier<RosterState> {
  final Ref ref;
  Isar? _isar;
  final Random _rng = Random();

  RosterNotifier(this.ref) : super(RosterState()) {
    _init();
  }

  Future<void> _init() async {
    final dir = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      _isar = await Isar.open(
        [WrestlerSchema, MatchSchema, ShowHistorySchema, GameSaveSchema, db.RivalrySchema, NewsItemSchema, ShowCardSchema, TvNetworkDealSchema, SponsorshipDealSchema, FinancialRecordSchema], 
        directory: dir.path
      );
    } else {
      _isar = Isar.getInstance();
    }

    final count = await _isar!.wrestlers.count();
    if (count < 12) { 
      await factoryReset(); 
    } else {
      await loadRoster();
      _initTitles(); 
    }
  }

  Future<void> loadRoster() async {
    if (_isar == null) return;
    
    final rosterList = await _isar!.wrestlers.filter().companyIdEqualTo(0).and().isOnIREqualTo(false).findAll();
    final irList = await _isar!.wrestlers.filter().companyIdEqualTo(0).and().isOnIREqualTo(true).findAll();
    
    final freeAgentList = await _isar!.wrestlers.filter().companyIdEqualTo(-1).and().isRookieEqualTo(false).findAll();
    final prospectList = await _isar!.wrestlers.filter().companyIdEqualTo(-1).and().isRookieEqualTo(true).findAll();
    
    // 🚨 THE RIVAL AI TAB NOW PULLS FROM ID 1!
    final empireList = await _isar!.wrestlers.filter().companyIdEqualTo(1).findAll();
    
    // 🛠️ SMART AUTO-CROWNING ENGINE
    bool hasWorldChamp = rosterList.any((w) => w.isChampion);
    bool hasTvChamp = rosterList.any((w) => w.isTVChampion);

    if (rosterList.isNotEmpty && (!hasWorldChamp || !hasTvChamp)) {
      await _isar!.writeTxn(() async {
        if (!hasWorldChamp) {
          var mainEventers = rosterList.where((w) => w.cardPosition == "Main Eventer").toList();
          mainEventers.sort((a, b) => b.pop.compareTo(a.pop));
          var worldChamp = mainEventers.isNotEmpty ? mainEventers.first : rosterList.first;
          worldChamp.isChampion = true;
          await _isar!.wrestlers.put(worldChamp);
        }
        if (!hasTvChamp) {
          var midCarders = rosterList.where((w) => w.cardPosition == "Mid-Carder").toList();
          midCarders.sort((a, b) => b.pop.compareTo(a.pop));
          var tvChamp = midCarders.isNotEmpty ? midCarders.first : rosterList.last;
          tvChamp.isTVChampion = true;
          await _isar!.wrestlers.put(tvChamp);
        }
      });
      // Titles assigned! Re-run load to grab the updated data.
      return loadRoster(); 
    }

    final allDbRivalries = await _isar!.rivalrys.where().findAll();
    List<Rivalry> mappedRivalries = [];

    final allTalent = [...rosterList, ...irList, ...freeAgentList, ...empireList];

    for (var r in allDbRivalries) {
      if (r.status == db.RivalryStatus.active) {
        var wA = allTalent.where((w) => w.name == r.wrestler1Name).firstOrNull;
        var wB = allTalent.where((w) => w.name == r.wrestler2Name).firstOrNull;
        
        wA ??= Wrestler()..name = r.wrestler1Name;
        wB ??= Wrestler()..name = r.wrestler2Name;
        
        mappedRivalries.add(
          Rivalry(
            wrestlerA: wA,
            wrestlerB: wB,
            name: "${wA.name} vs ${wB.name}",
            heat: r.heat,
            durationWeeks: r.durationWeeks,
          )
        );
      }
    }

    state = state.copyWith(
      roster: rosterList, 
      injuredReserve: irList,
      freeAgents: freeAgentList, 
      unscoutedProspects: prospectList,
      activeRivalries: mappedRivalries, 
      isLoading: false
    );
  }

  // =========================================================================
  // 🛠️ THE NEW LINEAGE ENGINE
  // =========================================================================

  void _initTitles() {
    if (state.titleHistory.isEmpty && state.roster.isNotEmpty) {
      var w = state.roster.where((w) => w.isChampion).firstOrNull;
      var t = state.roster.where((w) => w.isTVChampion).firstOrNull;
      
      state = state.copyWith(titleHistory: [
        if (w != null) TitleInfo(beltName: "World Heavyweight", championName: w.name, reignWeeks: 1),
        if (t != null) TitleInfo(beltName: "Television Title", championName: t.name, reignWeeks: 1),
      ]);
    }
  }

  void advanceTitleReigns() {
    List<TitleInfo> updated = List.from(state.titleHistory);
    if (updated.isNotEmpty) {
      var wIdx = updated.lastIndexWhere((t) => t.beltName.contains("World"));
      if (wIdx != -1) {
        updated[wIdx] = TitleInfo(beltName: updated[wIdx].beltName, championName: updated[wIdx].championName, reignWeeks: updated[wIdx].reignWeeks + 1);
      }

      var tIdx = updated.lastIndexWhere((t) => t.beltName.contains("Television"));
      if (tIdx != -1) {
        updated[tIdx] = TitleInfo(beltName: updated[tIdx].beltName, championName: updated[tIdx].championName, reignWeeks: updated[tIdx].reignWeeks + 1);
      }
    }
    state = state.copyWith(titleHistory: updated);
  }

  void recordTitleChange(String belt, String newChamp) {
    List<TitleInfo> updated = List.from(state.titleHistory);
    updated.add(TitleInfo(beltName: belt, championName: newChamp, reignWeeks: 1));
    state = state.copyWith(titleHistory: updated);
  }

  // =========================================================================
  // --- INJURED RESERVE LOGIC ---
  // =========================================================================

  Future<void> moveToIR(Wrestler w) async {
    if (_isar == null) return;
    if (state.injuredReserve.length >= 3) return; 
    if (!w.isInjured) return; 

    await _isar!.writeTxn(() async {
      w.isOnIR = true;
      w.isChampion = false; 
      w.isTVChampion = false;
      await _isar!.wrestlers.put(w);
    });
    await loadRoster();
  }

  Future<void> removeFromIR(Wrestler w) async {
    if (_isar == null) return;
    if (state.roster.length >= 12) return; 

    await _isar!.writeTxn(() async {
      w.isOnIR = false;
      await _isar!.wrestlers.put(w);
    });
    await loadRoster();
  }

  // =========================================================================
  // --- WEEK 27 SCOUTING DUMP TRIGGER ---
  // =========================================================================

  Future<void> triggerWeek27FreeAgencyDump() async {
    if (_isar == null) return;
    
    await _isar!.writeTxn(() async {
      final unsignedProspects = await _isar!.wrestlers.filter().companyIdEqualTo(-1).and().isRookieEqualTo(true).findAll();
      for (var prospect in unsignedProspects) {
        prospect.isRookie = false; 
        prospect.isScouted = true; 
      }
      await _isar!.wrestlers.putAll(unsignedProspects);
    });
    
    await loadRoster();
  }

  // =========================================================================
  // --- RIVALRY ENGINE ---
  // =========================================================================
  
  Future<void> addMatchInteraction(String w1, String w2) async {
    if (_isar == null || w1 == w2) return;
    await _isar!.writeTxn(() async {
      final allRivalries = await _isar!.rivalrys.where().findAll();
      var existing = allRivalries.where((r) =>
        (r.wrestler1Name == w1 && r.wrestler2Name == w2) ||
        (r.wrestler1Name == w2 && r.wrestler2Name == w1)
      ).firstOrNull;

      if (existing != null) {
        existing.heat = (existing.heat + 25).clamp(0, 100);
        existing.status = db.RivalryStatus.active;
        await _isar!.rivalrys.put(existing);
      } else {
        var newRiv = db.Rivalry(
          wrestler1Name: w1,
          wrestler2Name: w2,
          heat: 25, 
          durationWeeks: 1,
          status: db.RivalryStatus.active,
        );
        await _isar!.rivalrys.put(newRiv);
      }
    });
    await loadRoster();
  }

  Future<void> decayRivalries() async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async {
      final allRivalries = await _isar!.rivalrys.where().findAll();
      for (var r in allRivalries) {
        if (r.status == db.RivalryStatus.active) {
          r.heat -= 10; 
          r.durationWeeks += 1;
          if (r.heat <= 0) {
            r.heat = 0;
            r.status = db.RivalryStatus.concluded; 
          }
          await _isar!.rivalrys.put(r);
        }
      }
    });
    await loadRoster();
  }

  // =========================================================================
  // --- UNIVERSAL CONTRACT ENGINE ---
  // =========================================================================
  
  Future<void> processContracts() async {
    if (_isar == null) return;
    
    await _isar!.writeTxn(() async {
      final allWrestlers = await _isar!.wrestlers.where().findAll();
      List<Wrestler> toUpdate = [];

      for (var w in allWrestlers) {
        if (w.companyId != -1) {
          w.contractWeeks -= 1;

          if (w.contractWeeks <= 0) {
            w.companyId = -1; 
            w.morale = 50;
            w.isHoldingOut = false;
            w.isChampion = false;
            w.isTVChampion = false;
            w.isOnIR = false; 
          } 
          else {
            if (!w.isHoldingOut && w.pop >= (w.contractedPop + 15) && w.greed >= 75) {
              w.isHoldingOut = true; 
            }
          }
          toUpdate.add(w);
        }
      }
      await _isar!.wrestlers.putAll(toUpdate);
    });
    
    await loadRoster();
  }

  Future<void> hireWrestler(Wrestler wrestler) async {
    if (_isar == null) return;
    if (state.roster.length >= 12) {
      throw Exception("Roster Full! Place an injured star on the IR or release someone first.");
    }

    await _isar!.writeTxn(() async { 
      wrestler.companyId = 0; 
      wrestler.contractedPop = wrestler.pop;
      wrestler.contractWeeks = 12 + _rng.nextInt(12);
      wrestler.isHoldingOut = false; 
      wrestler.isRookie = false; 
      wrestler.isScouted = true;
      await _isar!.wrestlers.put(wrestler); 
    });
    await loadRoster();
  }

  Future<void> releaseWrestler(Wrestler wrestler) async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async { 
      wrestler.companyId = -1; 
      wrestler.morale = 50; 
      wrestler.isHoldingOut = false;
      wrestler.isOnIR = false;
      await _isar!.wrestlers.put(wrestler); 
    });
    await loadRoster();
  }

  void upgradeVenue() {
    if (state.venueLevel < 4) {
      state = state.copyWith(venueLevel: state.venueLevel + 1);
    }
  }

  void deductCash(int amount) {
    state = state.copyWith(bankAccount: state.bankAccount - amount);
  }

  // =========================================================================
  // --- THE AUTO-DRAFT & SPECIAL ATTRACTIONS ENGINE ---
  // =========================================================================

  Future<void> _seedInitialRoster() async {
    if (_isar == null) return;
    List<Wrestler> databaseInjection = [];

    // 1. INJECT BOSSES
    databaseInjection.addAll(_generateBossCharacters());

    // 2. GENERATE RANDOM POOL
    List<Wrestler> generatedPool = _generateRandomRoster(60);
    
    // Sort pool by POPULARITY so we can draft evenly!
    generatedPool.sort((a, b) => b.pop.compareTo(a.pop));

    // 3. 🚨 THE FIX: AUTO-DRAFT PROPERLY FOR BOTH COMPANIES
    for (int i = 0; i < 12; i++) {
      // Draft a guy for the player
      generatedPool[i * 2].companyId = 0;
      generatedPool[i * 2].cardPosition = i < 3 ? "Main Eventer" : i < 8 ? "Mid-Carder" : "Opener"; 
      
      // Draft a similar guy for the CPU AI (Company 1!)
      generatedPool[(i * 2) + 1].companyId = 1;
      generatedPool[(i * 2) + 1].cardPosition = i < 3 ? "Main Eventer" : i < 8 ? "Mid-Carder" : "Opener";
    }

    // 4. GENERATE 20 ROOKIE PROSPECTS FOR SCOUTING REGIONS
    List<Wrestler> prospectPool = _generateRandomRoster(20, isRookie: true);

    databaseInjection.addAll(generatedPool);
    databaseInjection.addAll(prospectPool);

    await _isar!.writeTxn(() async {
      await _isar!.wrestlers.putAll(databaseInjection);
    });
  }

  List<Wrestler> _generateBossCharacters() {
    return [
      _buildBoss("The Iron Saint", WrestlingStyle.technician, 95, 98, 85, loyalty: 80),
      _buildBoss("Kid Aerial", WrestlingStyle.highFlyer, 92, 90, 88, greed: 70),
      _buildBoss("Velvet Rico", WrestlingStyle.entertainer, 98, 75, 99, greed: 95),
      _buildBoss("Tank Abbott", WrestlingStyle.brawler, 90, 85, 70, loyalty: 40),
      _buildBoss("Chuck the Hammer", WrestlingStyle.powerhouse, 88, 80, 60, greed: 85),
      _buildBoss("Richard Sterling", WrestlingStyle.technician, 94, 92, 95, isHeel: true, greed: 90),
      _buildBoss("Major Tom Justice", WrestlingStyle.powerhouse, 96, 85, 90, loyalty: 95),
      _buildBoss("Jax Cassidy", WrestlingStyle.brawler, 93, 88, 85),
      _buildBoss("Malachi The Harbinger", WrestlingStyle.powerhouse, 91, 80, 85, isHeel: true),
      _buildBoss("Smiley Pete Carnage", WrestlingStyle.hardcore, 89, 75, 80, greed: 40),
    ];
  }

  Wrestler _buildBoss(String name, WrestlingStyle style, int pop, int ring, int mic, {bool isHeel = false, int greed = 75, int loyalty = 50}) {
    return Wrestler()
      ..name = name
      ..style = style
      ..pop = pop
      ..ringSkill = ring
      ..micSkill = mic
      ..potentialSkill = 99 
      ..salary = (pop * 25) 
      ..companyId = -1 
      ..isHeel = isHeel
      ..greed = greed
      ..loyalty = loyalty
      ..contractWeeks = 0
      ..isScouted = true 
      ..cardPosition = "Main Eventer";
  }

  List<Wrestler> _generateRandomRoster(int count, {bool isRookie = false}) {
    List<Wrestler> pool = [];
    List<String> firstNames = ["Rex", "Jimmy", "Johnny", "Tommy", "Big", "Sly", "Mad", "King", "El", "Kid", "Doc", "Shadow"];
    List<String> lastNames = ["Danger", "Flash", "Strong", "Storm", "Black", "Justice", "Ruckus", "Steele", "Havoc", "Viper", "Gato"];
    
    for (int i = 0; i < count; i++) {
      String name = "${firstNames[_rng.nextInt(firstNames.length)]} ${lastNames[_rng.nextInt(lastNames.length)]}";
      WrestlingStyle style = WrestlingStyle.values[_rng.nextInt(WrestlingStyle.values.length)];
      
      int basePop = isRookie ? 15 + _rng.nextInt(20) : 30 + _rng.nextInt(40); 
      int baseRing = isRookie ? 25 + _rng.nextInt(20) : 40 + _rng.nextInt(40); 
      
      pool.add(
        Wrestler()
          ..name = name
          ..style = style
          ..pop = basePop
          ..ringSkill = baseRing
          ..micSkill = (basePop * 0.8).toInt() + _rng.nextInt(15)
          ..potentialSkill = baseRing + 10 + _rng.nextInt(30) 
          ..salary = (basePop * 10) + _rng.nextInt(500)
          ..companyId = -1 
          ..isHeel = _rng.nextBool()
          ..greed = 40 + _rng.nextInt(60)
          ..loyalty = 40 + _rng.nextInt(60)
          ..contractWeeks = 12 + _rng.nextInt(40)
          ..contractedPop = basePop
          ..isRookie = isRookie
          ..isScouted = !isRookie 
          ..cardPosition = "Opener" 
      );
    }
    return pool;
  }

  Future<void> factoryReset() async {
    if (_isar == null) return;
    
    await _isar!.writeTxn(() async {
      await _isar!.wrestlers.clear();
      await _isar!.matchs.clear();        
      await _isar!.showHistorys.clear(); 
      await _isar!.gameSaves.clear();    
      await _isar!.rivalrys.clear(); 
      await _isar!.newsItems.clear(); 
      await _isar!.tvNetworkDeals.clear(); 
      await _isar!.sponsorshipDeals.clear(); 
      await _isar!.financialRecords.clear(); 
    });

    state = RosterState(
        roster: [], 
        injuredReserve: [],
        freeAgents: [], 
        unscoutedProspects: [],
        activeRivalries: [], 
        titleHistory: [], 
        venueLevel: 1, 
        bankAccount: 50000, 
        isLoading: false
    );

    try { await ref.read(gameProvider.notifier).resetGame(); } catch (e) { ref.refresh(gameProvider); }
    ref.refresh(rivalProvider);

    await _seedInitialRoster();
    _initTitles(); 
    await loadRoster();
  }

  Future<void> renameWrestler(Wrestler w, String newName) async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async { w.name = newName; await _isar!.wrestlers.put(w); });
    await loadRoster();
  }

  Future<void> repackageWrestler(Wrestler w, WrestlingStyle newStyle) async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async { w.style = newStyle; await _isar!.wrestlers.put(w); });
    await loadRoster();
  }

  AwardResult calculateYearEndAwards() {
      return AwardResult(
          wrestlerOfTheYear: "Kid Aerial",
          matchOfTheYear: "Main Event",
          matchRating: 4.5,
          tagTeamOfTheYear: "N/A",
          mostImproved: "The Rookie",
          totalProfit: 100000
      );
  }

  RandomEvent? checkForRandomEvent() { return null; }

  // ===========================================================================
  // 🚀 RESTORED DEVELOPMENT SCREEN HOOKS 
  // ===========================================================================

  Future<Wrestler?> scoutRegion(String region, int cost) async { 
    if (_isar == null) return null;
    
    Wrestler? prospect;
    
    await _isar!.writeTxn(() async {
      prospect = await _isar!.wrestlers.filter()
          .companyIdEqualTo(-1)
          .and()
          .isRookieEqualTo(true)
          .and()
          .isScoutedEqualTo(false)
          .findFirst();

      if (prospect != null) {
        prospect!.isScouted = true;
        prospect!.isRookie = false; 
        await _isar!.wrestlers.put(prospect!);
      }
    });

    try {
      dynamic gameNotifier = ref.read(gameProvider.notifier);
      gameNotifier.spendCash(cost);
    } catch (e) {
      deductCash(cost);
    }

    await loadRoster();
    return prospect; 
  }
  
  Future<void> scoutProspect(Wrestler w, int cost) async {
    if (_isar == null) return;
    
    await _isar!.writeTxn(() async {
      w.isScouted = true;
      await _isar!.wrestlers.put(w);
    });

    try {
      dynamic gameNotifier = ref.read(gameProvider.notifier);
      gameNotifier.spendCash(cost);
    } catch (e) {
      deductCash(cost);
    }

    await loadRoster();
  }

  Future<void> trainingAction(Wrestler w, String type, int cost) async {
    if (_isar == null) return;
    
    await _isar!.writeTxn(() async {
      if (type == "MIC" || type == "MIC SKILL") w.micSkill = (w.micSkill + 2).clamp(0, w.potentialSkill); 
      if (type == "POP" || type == "POPULARITY") w.pop = (w.pop + 1).clamp(0, 100);
      if (type == "RING" || type == "RING SKILL") w.ringSkill = (w.ringSkill + 2).clamp(0, w.potentialSkill); 
      if (type == "HEAL") { w.stamina = 100; w.condition = 100; } 
      await _isar!.wrestlers.put(w);
    });

    try {
      dynamic gameNotifier = ref.read(gameProvider.notifier);
      gameNotifier.spendCash(cost);
    } catch (e) {
      deductCash(cost);
    }

    await loadRoster();
  }

  Future<String> runPracticeMatch(Wrestler a, Wrestler b) async { 
    if (_isar == null) return "Database Error.";

    await _isar!.writeTxn(() async {
      a.ringSkill = (a.ringSkill + 2).clamp(0, 100);
      a.stamina = (a.stamina - 25).clamp(0, 100);
      
      b.ringSkill = (b.ringSkill + 2).clamp(0, 100);
      b.stamina = (b.stamina - 25).clamp(0, 100);
      
      await _isar!.wrestlers.putAll([a, b]);
    });
    
    await loadRoster();
    return "${a.name} and ${b.name} completed a grueling sparring session!"; 
  }
  
  // ===========================================================================

  Future<void> turnHeelFace(Wrestler w) async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async { w.isHeel = !w.isHeel; await _isar!.wrestlers.put(w); });
    await loadRoster();
  }

  Future<void> clearDatabaseForImport() async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async { await _isar!.wrestlers.clear(); });
    state = state.copyWith(roster: [], freeAgents: [], isLoading: true);
  }

  Future<void> importWrestlers(List<Wrestler> newRoster) async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async { await _isar!.wrestlers.putAll(newRoster); });
    await loadRoster();
  }
}

final rosterProvider = StateNotifierProvider<RosterNotifier, RosterState>((ref) {
  return RosterNotifier(ref);
});