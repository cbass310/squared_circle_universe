import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../data/models/wrestler.dart';
import '../data/models/news_item.dart';

class RivalState {
  final double rating;
  final int cash;
  RivalState({this.rating = 2.0, this.cash = 100000});
  
  RivalState copyWith({double? rating, int? cash}) {
    return RivalState(rating: rating ?? this.rating, cash: cash ?? this.cash);
  }
}

class RivalNotifier extends StateNotifier<RivalState> {
  final Ref ref;
  Isar? _isar;
  final Random _rng = Random();

  RivalNotifier(this.ref) : super(RivalState()) {
    _init();
  }

  Future<void> _init() async {
    _isar = Isar.getInstance();
  }

  Future<void> runAIWeeklyLogic() async {
    if (_isar == null) return;
    
    bool madeBigMove = false;

    if (_rng.nextDouble() < 0.3) {
       madeBigMove = await _attemptSignFreeAgent();
    }

    if (!madeBigMove && _rng.nextDouble() < 0.1) {
       madeBigMove = await _attemptPoach();
    }
    
    double newRating = 2.0; 
    final aiRoster = await _isar!.wrestlers.filter().companyIdEqualTo(1).and().isOnIREqualTo(false).findAll();

    if (aiRoster.isNotEmpty) {
      aiRoster.sort((a, b) => b.pop.compareTo(a.pop));
      
      int numStars = min(5, aiRoster.length);
      double totalStarPower = 0.0;
      
      for (int i = 0; i < numStars; i++) {
        totalStarPower += aiRoster[i].pop;
      }
      
      double avgStarPower = totalStarPower / numStars; 
      double baseRating = (avgStarPower / 100.0) * 4.5;
      double variance = (_rng.nextDouble() * 1.0) - 0.5;
      
      newRating = (baseRating + variance).clamp(1.0, 5.0);
    } else {
      newRating = 1.0 + (_rng.nextDouble() * 1.0);
    }

    if (madeBigMove && _rng.nextDouble() < 0.5) {
      final mockNews = NewsItem()
        ..type = "DIRT_SHEET"
        ..subject = "Empire Wrestling Champion Mocks SCW!"
        ..body = "On Empire Wrestling TV, their top star cut a massive promo calling Squared Circle Wrestling a minor league."
        ..sender = "TheInsider"
        ..timestamp = DateTime.now()
        ..actionRequired = false
        ..isRead = false;

      await _isar!.writeTxn(() async {
        await _isar!.newsItems.put(mockNews);
      });
    }

    state = state.copyWith(rating: double.parse(newRating.toStringAsFixed(1)));
  }

  Future<bool> _attemptSignFreeAgent() async {
    final currentRivalRoster = await _isar!.wrestlers.filter().companyIdEqualTo(1).findAll();
    final freeAgents = await _isar!.wrestlers.filter().companyIdEqualTo(-1).and().isRookieEqualTo(false).findAll();
    if (freeAgents.isEmpty) return false;

    // 🚨 ROSTER ROLES: Count Bosses (85+ Pop)
    int currentBosses = currentRivalRoster.where((w) => w.pop >= 85).length;
    List<Wrestler> validTargets = freeAgents;
    
    // If they already have 3 Bosses, they are FORCED to sign mid-carders/openers
    if (currentBosses >= 3) {
      validTargets = freeAgents.where((w) => w.pop < 85).toList();
    }
    
    if (validTargets.isEmpty) return false;

    validTargets.shuffle();
    final newSigning = validTargets.first;
    
    Wrestler? releasedWrestler;

    if (currentRivalRoster.length >= 12) {
      currentRivalRoster.sort((a, b) => a.pop.compareTo(b.pop));
      releasedWrestler = currentRivalRoster.first; 
      releasedWrestler.companyId = -1;
      releasedWrestler.morale = 50;
    }

    newSigning.companyId = 1;
    newSigning.morale = 100;
    // 🚨 MERCENARY CONTRACT: 90+ pop guys only sign for 12 weeks!
    newSigning.contractWeeks = newSigning.pop >= 90 ? 12 : 48; 

    final signNews = NewsItem()
        ..type = "DIRT_SHEET"
        ..subject = "Rivals Sign ${newSigning.name}"
        ..body = "Empire Wrestling continues their spending spree by picking up ${newSigning.name} off the free agent market."
        ..sender = "WrestlingObserver"
        ..timestamp = DateTime.now()
        ..actionRequired = false
        ..isRead = false;

    await _isar!.writeTxn(() async {
      if (releasedWrestler != null) await _isar!.wrestlers.put(releasedWrestler);
      await _isar!.wrestlers.put(newSigning);
      await _isar!.newsItems.put(signNews);
    });
    return true;
  }

  Future<bool> _attemptPoach() async {
    final currentRivalRoster = await _isar!.wrestlers.filter().companyIdEqualTo(1).findAll();
    final playerRoster = await _isar!.wrestlers.filter().companyIdEqualTo(0).findAll();
    final unhappy = playerRoster.where((w) => w.morale < 40 || w.isHoldingOut).toList();
    
    if (unhappy.isEmpty) return false;

    // 🚨 ROSTER ROLES: Count Bosses (85+ Pop)
    int currentBosses = currentRivalRoster.where((w) => w.pop >= 85).length;
    List<Wrestler> validTargets = unhappy;
    
    if (currentBosses >= 3) {
      validTargets = unhappy.where((w) => w.pop < 85).toList();
    }
    
    if (validTargets.isEmpty) return false;

    validTargets.shuffle();
    final traitor = validTargets.first;
    
    Wrestler? releasedWrestler;

    if (currentRivalRoster.length >= 12) {
      currentRivalRoster.sort((a, b) => a.pop.compareTo(b.pop));
      releasedWrestler = currentRivalRoster.first; 
      releasedWrestler.companyId = -1;
      releasedWrestler.morale = 50;
    }

    traitor.companyId = 1;
    traitor.morale = 100;
    // 🚨 MERCENARY CONTRACT: 90+ pop guys only sign for 12 weeks!
    traitor.contractWeeks = traitor.pop >= 90 ? 12 : 48; 
    traitor.isHoldingOut = false;
    traitor.isChampion = false;
    traitor.isTVChampion = false;

    final poachNews = NewsItem()
        ..type = "DIRT_SHEET"
        ..subject = "BREAKING: ${traitor.name} JUMPS SHIP!"
        ..body = "In a shocking betrayal, ${traitor.name} has left Squared Circle Wrestling and signed an exclusive deal with Empire Wrestling!"
        ..sender = "WrestlingObserver"
        ..timestamp = DateTime.now()
        ..actionRequired = false
        ..isRead = false;

    await _isar!.writeTxn(() async {
      if (releasedWrestler != null) await _isar!.wrestlers.put(releasedWrestler);
      await _isar!.wrestlers.put(traitor);
      await _isar!.newsItems.put(poachNews);
    });
    return true;
  }
}

final rivalProvider = StateNotifierProvider<RivalNotifier, RivalState>((ref) => RivalNotifier(ref));