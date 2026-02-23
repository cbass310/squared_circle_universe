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

    // AI logic for poaching
    if (!madeBigMove && _rng.nextDouble() < 0.1) {
       madeBigMove = await _attemptPoach();
    }

    // Generate a random rating for the week
    double newRating = 2.0 + (_rng.nextDouble() * 2.5); 
    
    // --- FIX: AI WRITES TO NEW DIRT SHEET SCHEMA ---
    if (madeBigMove && _rng.nextDouble() < 0.5) {
      final mockNews = NewsItem()
        ..type = "DIRT_SHEET"
        ..subject = "Empire Champion Mocks YOU!"
        ..body = "On Empire TV, their top star cut a massive promo calling your promotion minor league."
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
    newSigning.companyId = 2;
    newSigning.morale = 100;

    final signNews = NewsItem()
        ..type = "DIRT_SHEET"
        ..subject = "Empire Signs ${newSigning.name}"
        ..body = "The Empire continues their spending spree by picking up ${newSigning.name}."
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
    traitor.companyId = 2;
    traitor.morale = 100;
    traitor.isHoldingOut = false;

    final poachNews = NewsItem()
        ..type = "DIRT_SHEET"
        ..subject = "BREAKING: ${traitor.name} JUMPS SHIP!"
        ..body = "In a shocking betrayal, ${traitor.name} has left for the Empire."
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