import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../data/models/wrestler.dart';
import '../data/models/news_item.dart';
import 'game_state_provider.dart';

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

    // AI logic for signing free agents
    if (_rng.nextDouble() < 0.3) {
       madeBigMove = await _attemptSignFreeAgent();
    }

    // AI logic for poaching your unhappy stars
    if (!madeBigMove && _rng.nextDouble() < 0.1) {
       madeBigMove = await _attemptPoach();
    }

    // ====================================================================
    // 🧠 LIVING AI RATING ENGINE
    // Instead of random math, the AI calculates a rating based on its actual roster!
    // ====================================================================
    
    double newRating = 2.0; // Fallback baseline
    final aiRoster = await _isar!.wrestlers.filter().companyIdEqualTo(1).and().isOnIREqualTo(false).findAll();

    if (aiRoster.isNotEmpty) {
      // Sort by highest popularity
      aiRoster.sort((a, b) => b.pop.compareTo(a.pop));
      
      // Take the top 5 stars (or less if the roster is small) to calculate their "Main Event Draw"
      int numStars = min(5, aiRoster.length);
      double totalStarPower = 0.0;
      
      for (int i = 0; i < numStars; i++) {
        totalStarPower += aiRoster[i].pop;
      }
      
      double avgStarPower = totalStarPower / numStars; // Scale of 0 - 100
      
      // Convert 100 popularity into a 4.5 star base rating
      double baseRating = (avgStarPower / 100.0) * 4.5;
      
      // Add a slight RNG variance so it's not identical every week (-0.5 to +0.5)
      double variance = (_rng.nextDouble() * 1.0) - 0.5;
      
      newRating = (baseRating + variance).clamp(1.0, 5.0);
    } else {
      // If the AI has literally zero wrestlers, their shows are terrible.
      newRating = 1.0 + (_rng.nextDouble() * 1.0);
    }

    // --- DIRT SHEET INTEGRATION ---
    if (madeBigMove && _rng.nextDouble() < 0.5) {
      final mockNews = NewsItem()
        ..type = "DIRT_SHEET"
        ..subject = "Rival Champion Mocks YOU!"
        ..body = "On Rival TV, their top star cut a massive promo calling your promotion minor league."
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
    final freeAgents = await _isar!.wrestlers.filter().companyIdEqualTo(-1).and().isRookieEqualTo(false).findAll();
    if (freeAgents.isEmpty) return false;

    freeAgents.shuffle();
    final newSigning = freeAgents.first;
    
    // 🚨 FIX: Ensure they sign to Company 1 (The AI Rival)
    newSigning.companyId = 1;
    newSigning.morale = 100;
    newSigning.contractWeeks = 48; // Give them a standard 1 year deal

    final signNews = NewsItem()
        ..type = "DIRT_SHEET"
        ..subject = "Rivals Sign ${newSigning.name}"
        ..body = "The Rival Promotion continues their spending spree by picking up ${newSigning.name} off the free agent market."
        ..sender = "WrestlingObserver"
        ..timestamp = DateTime.now()
        ..actionRequired = false
        ..isRead = false;

    await _isar!.writeTxn(() async {
      await _isar!.wrestlers.put(newSigning);
      await _isar!.newsItems.put(signNews);
    });
    return true;
  }

  Future<bool> _attemptPoach() async {
    final playerRoster = await _isar!.wrestlers.filter().companyIdEqualTo(0).findAll();
    final unhappy = playerRoster.where((w) => w.morale < 40 || w.isHoldingOut).toList();
    
    if (unhappy.isEmpty) return false;

    unhappy.shuffle();
    final traitor = unhappy.first;
    
    // 🚨 FIX: The traitor jumps to Company 1
    traitor.companyId = 1;
    traitor.morale = 100;
    traitor.isHoldingOut = false;
    traitor.isChampion = false;
    traitor.isTVChampion = false;

    final poachNews = NewsItem()
        ..type = "DIRT_SHEET"
        ..subject = "BREAKING: ${traitor.name} JUMPS SHIP!"
        ..body = "In a shocking betrayal, ${traitor.name} has left your promotion and signed an exclusive deal with your Rivals!"
        ..sender = "WrestlingObserver"
        ..timestamp = DateTime.now()
        ..actionRequired = false
        ..isRead = false;

    await _isar!.writeTxn(() async {
      await _isar!.wrestlers.put(traitor);
      await _isar!.newsItems.put(poachNews);
    });
    return true;
  }
}

final rivalProvider = StateNotifierProvider<RivalNotifier, RivalState>((ref) => RivalNotifier(ref));