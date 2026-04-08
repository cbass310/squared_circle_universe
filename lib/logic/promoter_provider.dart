import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../data/models/wrestler.dart';
import '../data/models/match.dart'; 
import '../data/models/show_history.dart';
import '../data/models/game_save.dart';
import '../data/models/rivalry.dart'; 
import '../data/models/news_item.dart'; 
import '../data/models/show_card.dart'; 
import '../data/models/tv_network_deal.dart'; 
import '../data/models/sponsorship_deal.dart'; 
import '../data/models/financial_record.dart';
import 'game_state_provider.dart'; 
import 'rival_provider.dart';      

class UIRivalry {
  final Wrestler wrestlerA;
  final Wrestler wrestlerB;
  final String name;
  final int heat;
  final int durationWeeks;

  UIRivalry({
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
  final List<UIRivalry> activeRivalries; 
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
    List<UIRivalry>? activeRivalries, 
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
        [WrestlerSchema, MatchSchema, ShowHistorySchema, GameSaveSchema, RivalrySchema, NewsItemSchema, ShowCardSchema, TvNetworkDealSchema, SponsorshipDealSchema, FinancialRecordSchema], 
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

  // 🚨 THE NEW DYNAMIC ECONOMY CALCULATOR 🚨
  int calculateDynamicSalary(int pop, int greed, int venueLevel, int companyCash) {
    // 1. Base Scale: Exponential growth for top stars
    double baseValue = pop * 12.0;
    if (pop >= 70) baseValue = pop * 25.0;
    if (pop >= 85) baseValue = pop * 60.0;
    if (pop >= 95) baseValue = pop * 100.0;

    // 2. The Venue Tax: Richer companies pay more
    double venueMultiplier = 1.0;
    if (venueLevel == 2) venueMultiplier = 2.0;
    if (venueLevel == 3) venueMultiplier = 5.0;
    if (venueLevel == 4) venueMultiplier = 12.0;

    // 3. The Greed Factor (0.7x to 1.7x)
    double greedMultiplier = 0.7 + (greed / 100.0);

    // 4. The Wealth Tax (or Desperation Discount)
    double wealthTax = 1.0;
    if (companyCash > 5000000) wealthTax = 1.5;
    else if (companyCash > 1000000) wealthTax = 1.25;
    else if (companyCash < 25000) wealthTax = 0.85; // Wrestlers take a cut to help a struggling company!

    int finalSalary = (baseValue * venueMultiplier * greedMultiplier * wealthTax).toInt();
    
    // Round to the nearest 100 for clean UI numbers (e.g. $15,400 instead of $15,432)
    int roundedSalary = (finalSalary / 100).round() * 100;
    if (roundedSalary < 100) roundedSalary = 100; // Absolute floor

    return roundedSalary;
  }

  Future<void> loadRoster() async {
    if (_isar == null) {
      state = state.copyWith(isLoading: false);
      return;
    }
    
    try {
      final allWrestlers = await _isar!.wrestlers.where().findAll();
      final gameState = ref.read(gameProvider);
      int absoluteWeek = (gameState.year * 48) + gameState.week;
      
      final rosterList = allWrestlers.where((w) => w.companyId == 0 && w.isOnIR != true).toList();
      final irList = allWrestlers.where((w) => w.companyId == 0 && w.isOnIR == true).toList();
      
      final freeAgentList = allWrestlers.where((w) => 
        w.companyId == -1 && 
        w.isRookie != true && 
        absoluteWeek >= w.cooldownUntilWeek
      ).toList();
      
      final prospectList = allWrestlers.where((w) => w.companyId == -1 && w.isRookie == true).toList();
      
      List<UIRivalry> mappedRivalries = [];
      
      try {
        final allDbRivalries = await _isar!.rivalrys.where().findAll();
        final allTalent = [...rosterList, ...irList, ...freeAgentList];

        for (var r in allDbRivalries) {
          if (r.status == RivalryStatus.active) {
            Wrestler? wA;
            Wrestler? wB;
            
            for (var w in allTalent) {
              if (w.name == r.wrestler1Name) wA = w;
              if (w.name == r.wrestler2Name) wB = w;
            }
            
            if (wA != null && wB != null) {
              mappedRivalries.add(
                UIRivalry( 
                  wrestlerA: wA,
                  wrestlerB: wB,
                  name: "${wA.name} vs ${wB.name}",
                  heat: r.heat,
                  durationWeeks: r.durationWeeks,
                )
              );
            }
          }
        }
      } catch (e) {
        print("Rivalry Schema Missing: $e");
      }

      state = state.copyWith(
        roster: rosterList, 
        injuredReserve: irList,
        freeAgents: freeAgentList, 
        unscoutedProspects: prospectList,
        activeRivalries: mappedRivalries, 
        isLoading: false
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void _initTitles() {
    if (state.titleHistory.isEmpty && state.roster.isNotEmpty) {
      Wrestler? worldChamp;
      Wrestler? tvChamp;
      
      for (var w in state.roster) {
        if (w.isChampion == true) worldChamp = w;
        if (w.isTVChampion == true) tvChamp = w;
      }

      state = state.copyWith(titleHistory: [
        if (worldChamp != null) TitleInfo(beltName: "World Heavyweight", championName: worldChamp.name, reignWeeks: 1),
        if (tvChamp != null) TitleInfo(beltName: "Television Title", championName: tvChamp.name, reignWeeks: 1),
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
    
    await ref.read(gameProvider.notifier).unlockMilestone("medical_ward");
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

  Future<void> triggerWeek27FreeAgencyDump() async {
    if (_isar == null) return;
    
    await _isar!.writeTxn(() async {
      final allUnsigned = await _isar!.wrestlers.filter().companyIdEqualTo(-1).findAll();
      final unsignedProspects = allUnsigned.where((w) => w.isRookie == true).toList();
      
      for (var prospect in unsignedProspects) {
        prospect.isRookie = false; 
        prospect.isScouted = true; 
      }
      await _isar!.wrestlers.putAll(unsignedProspects);
    });
    
    await loadRoster();
  }

  Future<void> evaluateShowForNewFeuds(List<Match> completedCard) async {
    if (completedCard.isEmpty || _isar == null) return;
    
    final gameState = ref.read(gameProvider);

    await _isar!.writeTxn(() async {
      final allWrestlers = await _isar!.wrestlers.where().findAll();
      
      for (var m in completedCard) {
        for (String wName in [m.winnerName, m.loserName]) {
          if (wName.isEmpty || wName == "Draw") continue;

          try {
            final w = allWrestlers.firstWhere((w) => w.name == wName);
            w.matchesWorked += 1;

            // Every 5 matches, they grow +1 POP (Up to their potential cap)
            if (w.matchesWorked % 5 == 0 && w.pop < w.popPotential) {
              w.pop += 1;
              
              // 🚨 The Fair Market Update: They demand more money when they evolve naturally!
              if (w.pop >= 90 && w.contractType != ContractType.specialAttraction) {
                w.contractType = ContractType.specialAttraction;
                w.hasCreativeControl = true;
                w.salary = calculateDynamicSalary(w.pop, w.greed, gameState.venueLevel, gameState.cash);
              }
            }
            await _isar!.wrestlers.put(w);
          } catch (e) {
            // Ignored if generic opponent
          }
        }
      }
    });

    Match mainEvent = completedCard.last;
    String w1 = mainEvent.winnerName;
    String w2 = mainEvent.loserName;
    
    if (mainEvent.rating >= 3.0 && w1.isNotEmpty && w2.isNotEmpty && w1 != "Draw" && w2 != "Draw") {
      await addMatchInteraction(w1, w2);
    }

    for (int i = 0; i < completedCard.length - 1; i++) {
      Match m = completedCard[i];
      String mw1 = m.winnerName;
      String mw2 = m.loserName;

      if (m.rating >= 4.0 && mw1.isNotEmpty && mw2.isNotEmpty && mw1 != "Draw" && mw2 != "Draw") {
        await addMatchInteraction(mw1, mw2);
      }
    }
  }

  Future<void> addMatchInteraction(String w1, String w2) async {
    if (_isar == null || w1 == w2) return;
    
    try {
      await _isar!.writeTxn(() async {
        final allRivalries = await _isar!.rivalrys.where().findAll();
        
        Rivalry? existing;
        for (var r in allRivalries) {
          if ((r.wrestler1Name == w1 && r.wrestler2Name == w2) ||
              (r.wrestler1Name == w2 && r.wrestler2Name == w1)) {
            existing = r;
            break;
          }
        }

        if (existing != null) {
          existing.heat = (existing.heat + 25).clamp(0, 100);
          existing.status = RivalryStatus.active;
          await _isar!.rivalrys.put(existing);
          
          if (existing.heat >= 60) await ref.read(gameProvider.notifier).unlockMilestone("red_hot");
          if (existing.heat >= 90) await ref.read(gameProvider.notifier).unlockMilestone("legendary_grudge");
          
        } else {
          var newRiv = Rivalry(
            wrestler1Name: w1,
            wrestler2Name: w2,
            heat: 45, 
            durationWeeks: 0,
            status: RivalryStatus.active,
          );
          await _isar!.rivalrys.put(newRiv);
          
          await ref.read(gameProvider.notifier).unlockMilestone("first_feud");
        }
      });
    } catch (e) {
      print("Safe Fail: Rivalry write skipped due to missing schema.");
    }
    await loadRoster();
  }

  Future<void> decayRivalries() async {
    if (_isar == null) return;
    
    try {
      await _isar!.writeTxn(() async {
        final allRivalries = await _isar!.rivalrys.where().findAll();
        for (var r in allRivalries) {
          if (r.status == RivalryStatus.active) {
            r.heat -= 10; 
            r.durationWeeks += 1;
            if (r.heat <= 0) {
              r.heat = 0;
              r.status = RivalryStatus.concluded; 
            }
            await _isar!.rivalrys.put(r);
          }
        }
      });
    } catch (e) {
      print("Safe Fail: Rivalry decay skipped due to missing schema.");
    }
    await loadRoster();
  }
  
  Future<void> processContracts() async {
    if (_isar == null) return;
    
    List<String> playerExpired = [];
    List<String> rivalExpired = [];
    List<String> playerHoldouts = [];
    bool worldVacated = false;
    bool tvVacated = false;

    final gameState = ref.read(gameProvider);
    int absoluteWeek = (gameState.year * 48) + gameState.week;

    await _isar!.writeTxn(() async {
      final allWrestlers = await _isar!.wrestlers.where().findAll();
      List<Wrestler> toUpdate = [];

      for (var w in allWrestlers) {
        if (w.companyId != -1) {
          w.contractWeeks -= 1;

          // Contract Expired!
          if (w.contractWeeks <= 0) {
            if (w.companyId == 0) {
              playerExpired.add(w.name);
              if (w.isChampion) worldVacated = true;
              if (w.isTVChampion) tvVacated = true;
            } else if (w.companyId == 1) {
              rivalExpired.add(w.name);
            }

            w.companyId = -1; 
            w.morale = 50;
            w.isHoldingOut = false;
            w.isChampion = false;
            w.isTVChampion = false;
            w.isOnIR = false; 

            if (w.pop >= 90 || w.contractType == ContractType.specialAttraction) {
              w.cooldownUntilWeek = absoluteWeek + 8;
            } else {
              w.cooldownUntilWeek = 0;
            }
          } 
          // Contract Still Active -> Check for Holdouts!
          else {
            if (!w.isHoldingOut && w.companyId == 0) {
              int currentMarketValue = calculateDynamicSalary(w.pop, w.greed, gameState.venueLevel, gameState.cash);
              
              bool popSpikeHoldout = w.pop >= (w.contractedPop + 15);
              // 🚨 THE FIX: If they are making less than 50% of what they deserve at your new venue level, they hold out!
              bool severelyUnderpaid = w.salary < (currentMarketValue * 0.5);

              if ((popSpikeHoldout || severelyUnderpaid) && w.greed >= 60) {
                w.isHoldingOut = true; 
                w.morale = 0; 
                playerHoldouts.add(w.name);
              }
            } else if (w.isHoldingOut) {
              w.morale = 0; 
            }
          }
          toUpdate.add(w);
        }
      }
      await _isar!.wrestlers.putAll(toUpdate);
    });
    
    final gameNotifier = ref.read(gameProvider.notifier);
    
    for (String name in playerExpired) { await gameNotifier.generatePlayerRosterNews(name, false); }
    for (String name in rivalExpired) { await gameNotifier.generateAiReleaseNews(name); }
    for (String name in playerHoldouts) { await gameNotifier.generateHoldoutNews(name); }
    if (worldVacated) await gameNotifier.generateVacantTitleNews("World Heavyweight");
    if (tvVacated) await gameNotifier.generateVacantTitleNews("Television");

    await loadRoster();
  }

  Future<void> hireWrestler(Wrestler wrestler) async {
    if (_isar == null) return;
    if (state.roster.length >= 12) {
      throw Exception("Roster Full! Place an injured star on the IR or release someone first.");
    }

    final gameState = ref.read(gameProvider);

    await _isar!.writeTxn(() async { 
      wrestler.companyId = 0; 
      wrestler.contractedPop = wrestler.pop;
      wrestler.contractWeeks = 12 + _rng.nextInt(12);
      
      // 🚨 THE FIX: When you hire them, their salary adjusts to YOUR promotion's wealth/venue!
      wrestler.salary = calculateDynamicSalary(wrestler.pop, wrestler.greed, gameState.venueLevel, gameState.cash);
      
      wrestler.isHoldingOut = false; 
      wrestler.isRookie = false; 
      wrestler.isScouted = true;
      wrestler.isOnIR = false;
      await _isar!.wrestlers.put(wrestler); 
    });
    
    await ref.read(gameProvider.notifier).generatePlayerRosterNews(wrestler.name, true);
    await ref.read(gameProvider.notifier).unlockMilestone("first_signing");
    await loadRoster();
  }

  Future<void> releaseWrestler(Wrestler wrestler) async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async { 
      wrestler.companyId = -1; 
      wrestler.morale = 50; 
      wrestler.isHoldingOut = false;
      wrestler.isOnIR = false;
      wrestler.isChampion = false;
      wrestler.isTVChampion = false;
      await _isar!.wrestlers.put(wrestler); 
    });

    await ref.read(gameProvider.notifier).generatePlayerRosterNews(wrestler.name, false);
    await ref.read(gameProvider.notifier).unlockMilestone("future_endeavors");
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

  Future<void> _seedInitialRoster() async {
    if (_isar == null) return;
    List<Wrestler> databaseInjection = [];

    databaseInjection.addAll(_generateBossCharacters());
    List<Wrestler> generatedPool = _generateRandomRoster(60);
    generatedPool.sort((a, b) => b.pop.compareTo(a.pop));

    for (int i = 0; i < 12; i++) {
      generatedPool[i * 2].companyId = 0;
      generatedPool[i * 2].cardPosition = i < 3 ? "Main Eventer" : i < 8 ? "Mid-Carder" : "Opener"; 
      
      if (i == 0) generatedPool[i * 2].isChampion = true; 
      if (i == 3) generatedPool[i * 2].isTVChampion = true; 
      
      generatedPool[(i * 2) + 1].companyId = 1;
      generatedPool[(i * 2) + 1].cardPosition = i < 3 ? "Main Eventer" : i < 8 ? "Mid-Carder" : "Opener";
    }

    List<Wrestler> prospectPool = _generateRandomRoster(20, isRookie: true);

    databaseInjection.addAll(generatedPool);
    databaseInjection.addAll(prospectPool);

    await _isar!.writeTxn(() async {
      await _isar!.wrestlers.putAll(databaseInjection);
    });
  }

  List<Wrestler> _generateBossCharacters() {
    return [
      _buildBoss("Kid Ariel", WrestlingStyle.highFlyer, 92, 90, 88, greed: 70, imagePath: "assets/images/kid_ariel.png"),
      _buildBoss("Richard Sterling", WrestlingStyle.technician, 94, 98, 95, isHeel: true, greed: 90, imagePath: "assets/images/richard_sterling.png"),
      _buildBoss("Major Tom Justice", WrestlingStyle.powerhouse, 96, 85, 90, loyalty: 95, imagePath: "assets/images/major_tom.png"),
      _buildBoss("Jax Cassidy", WrestlingStyle.brawler, 93, 88, 85, imagePath: "assets/images/jax_cassidy.png"),
      _buildBoss("Smiley Pete Carnage", WrestlingStyle.hardcore, 89, 75, 80, greed: 40, imagePath: "assets/images/smiley_pete.png"),
      _buildBoss("Malachi the Harbinger", WrestlingStyle.powerhouse, 98, 80, 85, isHeel: true, imagePath: "assets/images/malachi.png"),
      _buildBoss("The Iron Saint", WrestlingStyle.technician, 95, 99, 70, loyalty: 80, imagePath: "assets/images/iron_saint.png"),
      _buildBoss("Velvet Rico", WrestlingStyle.entertainer, 91, 75, 99, isHeel: true, greed: 95, imagePath: "assets/images/velvet_rico.png"),
      _buildBoss("Tank Abbott", WrestlingStyle.brawler, 90, 85, 60, loyalty: 40, imagePath: "assets/images/tank_abbott.png"),
      _buildBoss("Chuck The Hammer", WrestlingStyle.powerhouse, 88, 80, 60, greed: 85, imagePath: "assets/images/chuck_hammer.png"),
    ];
  }

  Wrestler _buildBoss(String name, WrestlingStyle style, int pop, int ring, int mic, {bool isHeel = false, int greed = 75, int loyalty = 50, required String imagePath}) {
    return Wrestler()
      ..name = name
      ..style = style
      ..pop = pop
      ..ringSkill = ring
      ..micSkill = mic
      ..popPotential = 99 
      ..contractType = pop >= 90 ? ContractType.specialAttraction : ContractType.standard
      ..salary = calculateDynamicSalary(pop, greed, 1, 50000) 
      ..companyId = -1 
      ..isHeel = isHeel
      ..greed = greed
      ..loyalty = loyalty
      ..contractWeeks = 0
      ..isScouted = true 
      ..isRookie = false
      ..isOnIR = false
      ..isChampion = false
      ..isTVChampion = false
      ..isHoldingOut = false
      ..imagePath = imagePath
      ..cardPosition = "Main Eventer";
  }

  List<Wrestler> _generateRandomRoster(int count, {bool isRookie = false}) {
    List<Wrestler> pool = [];
    List<String> firstNames = ["Rex", "Jimmy", "Johnny", "Tommy", "Big", "Sly", "Mad", "King", "El", "Kid", "Doc", "Shadow", "Ace", "Duke", "Jack", "Max", "Zack", "Blade", "Axel", "Steel"];
    List<String> lastNames = ["Danger", "Flash", "Strong", "Storm", "Black", "Justice", "Ruckus", "Steele", "Havoc", "Viper", "Gato", "Cross", "Stone", "Wolf", "Hunter", "Rage", "Knight", "Blood"];
    
    if (isRookie && count == 20) {
      List<String> archetypes = [
        "GENERATIONAL", 
        "DECENT", "DECENT", "DECENT", "DECENT",
        "SCRUB", "SCRUB", "SCRUB", "SCRUB", "SCRUB", 
        "SCRUB", "SCRUB", "SCRUB", "SCRUB", "SCRUB", 
        "SCRUB", "SCRUB", "SCRUB", "SCRUB", "SCRUB"
      ];
      archetypes.shuffle(_rng); 

      for (int i = 0; i < count; i++) {
        String name = "${firstNames[_rng.nextInt(firstNames.length)]} ${lastNames[_rng.nextInt(lastNames.length)]}";
        WrestlingStyle style = WrestlingStyle.values[_rng.nextInt(WrestlingStyle.values.length)];
        
        int basePop;
        int baseRing;
        int potential;

        if (archetypes[i] == "GENERATIONAL") {
          basePop = 60 + _rng.nextInt(15); 
          baseRing = 70 + _rng.nextInt(15); 
          potential = 99; 
        } else if (archetypes[i] == "DECENT") {
          basePop = 35 + _rng.nextInt(15); 
          baseRing = 45 + _rng.nextInt(15); 
          potential = 85 + _rng.nextInt(10); 
        } else {
          basePop = 15 + _rng.nextInt(15); 
          baseRing = 20 + _rng.nextInt(15); 
          potential = 60 + _rng.nextInt(20); 
        }
        
        int greedVal = 40 + _rng.nextInt(60);

        pool.add(
          Wrestler()
            ..name = name
            ..style = style
            ..pop = basePop
            ..ringSkill = baseRing
            ..micSkill = (basePop * 0.8).toInt() + _rng.nextInt(15)
            ..popPotential = potential 
            ..salary = calculateDynamicSalary(basePop, greedVal, 1, 50000)
            ..companyId = -1 
            ..isHeel = _rng.nextBool()
            ..greed = greedVal
            ..loyalty = 40 + _rng.nextInt(60)
            ..contractWeeks = 12 + _rng.nextInt(40)
            ..contractedPop = basePop
            ..isRookie = true
            ..isScouted = false 
            ..isOnIR = false 
            ..isChampion = false
            ..isTVChampion = false
            ..isHoldingOut = false
            ..cardPosition = "Opener" 
        );
      }
      return pool;
    }

    for (int i = 0; i < count; i++) {
      String name = "${firstNames[_rng.nextInt(firstNames.length)]} ${lastNames[_rng.nextInt(lastNames.length)]}";
      WrestlingStyle style = WrestlingStyle.values[_rng.nextInt(WrestlingStyle.values.length)];
      
      int basePop = 30 + _rng.nextInt(40); 
      int baseRing = 40 + _rng.nextInt(40); 
      int greedVal = 40 + _rng.nextInt(60);
      
      pool.add(
        Wrestler()
          ..name = name
          ..style = style
          ..pop = basePop
          ..ringSkill = baseRing
          ..micSkill = (basePop * 0.8).toInt() + _rng.nextInt(15)
          ..popPotential = basePop + 10 + _rng.nextInt(30) 
          ..salary = calculateDynamicSalary(basePop, greedVal, 1, 50000)
          ..companyId = -1 
          ..isHeel = _rng.nextBool()
          ..greed = greedVal
          ..loyalty = 40 + _rng.nextInt(60)
          ..contractWeeks = 12 + _rng.nextInt(40)
          ..contractedPop = basePop
          ..isRookie = false
          ..isScouted = true 
          ..isOnIR = false 
          ..isChampion = false
          ..isTVChampion = false
          ..isHoldingOut = false
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
      
      try { await _isar!.rivalrys.clear(); } catch(e) {} 
      
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
        isLoading: true
    );

    try { await ref.read(gameProvider.notifier).resetGame(); } catch (e) {}
    try { ref.refresh(rivalProvider); } catch (e) {}

    await _seedInitialRoster();
    await loadRoster(); 
    _initTitles(); 
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

  Future<Wrestler?> scoutRegion(String region, int cost) async { 
    if (_isar == null) return null;
    
    Wrestler? prospect;
    
    final allUnsigned = await _isar!.wrestlers.filter().companyIdEqualTo(-1).findAll();
    final prospectList = allUnsigned.where((w) => w.isRookie == true && w.isScouted != true).toList();
    if (prospectList.isNotEmpty) {
      prospect = prospectList.first;
    }

    if (prospect != null) {
      await _isar!.writeTxn(() async {
        prospect!.isScouted = true;
        prospect.isRookie = false; 
        await _isar!.wrestlers.put(prospect);
      });
    }

    try {
      dynamic gameNotifier = ref.read(gameProvider.notifier);
      gameNotifier.spendCash(cost);
    } catch (e) {
      deductCash(cost);
    }

    await ref.read(gameProvider.notifier).unlockMilestone("developmental");
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

    await ref.read(gameProvider.notifier).unlockMilestone("developmental");
    await loadRoster();
  }

  Future<void> trainingAction(Wrestler w, String type, int cost) async {
    if (_isar == null) return;
    
    final gameState = ref.read(gameProvider);
    bool hitCap = false;

    await _isar!.writeTxn(() async {
      if (type == "MIC" || type == "MIC SKILL") w.micSkill = (w.micSkill + 2).clamp(0, 100);
      
      if (type == "POP" || type == "POPULARITY") {
        if (w.pop >= w.popPotential) {
          hitCap = true; 
        } else {
          w.pop = (w.pop + 1).clamp(0, w.popPotential);
          
          if (w.pop >= 90 && w.contractType != ContractType.specialAttraction) {
            w.contractType = ContractType.specialAttraction;
            w.greed = (w.greed + 25).clamp(0, 100);
            w.hasCreativeControl = true;
            // 🚨 THE FIX: Their salary dynamically skyrockets when they evolve into a special attraction!
            w.salary = calculateDynamicSalary(w.pop, w.greed, gameState.venueLevel, gameState.cash);
          }
        }
      }

      if (type == "RING" || type == "RING SKILL") w.ringSkill = (w.ringSkill + 2).clamp(0, 100);
      if (type == "HEAL" || type == "MEDICAL") { w.stamina = 100; w.condition = 100; } 
      
      if (type == "BONUS" || type == "MORALE") { 
        w.morale = 100; 
        w.isHoldingOut = false; 
        w.contractedPop = w.pop; 
        // 🚨 THE FIX: When you pay their bonus, you are signing them to a new deal at Current Market Value!
        w.salary = calculateDynamicSalary(w.pop, w.greed, gameState.venueLevel, gameState.cash);
      }

      if (!hitCap) {
        await _isar!.wrestlers.put(w);
      }
    });

    if (hitCap) {
      throw Exception("${w.name} has already reached their maximum popularity potential!");
    }

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