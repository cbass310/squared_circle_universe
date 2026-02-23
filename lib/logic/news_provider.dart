import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../data/models/news_item.dart';
import '../data/models/wrestler.dart';
import '../data/models/match.dart';

class NewsNotifier extends StateNotifier<List<NewsItem>> {
  NewsNotifier() : super([]);

  // This runs every time you simulate a week!
  Future<void> generateWeeklyNews(List<Match> currentCard, List<Wrestler> roster) async {
    final isar = Isar.getInstance();
    if (isar == null) return;
    
    final rng = Random();
    
    // 30% chance each week to generate a Dirt Sheet rumor
    if (rng.nextDouble() < 0.3) {
       final item = NewsItem()
         ..sender = "The Observer Wire"
         ..subject = "Backstage Rumors & Scouting"
         ..body = "Sources indicate there might be some major contract shakeups in the coming weeks. Keep an eye on your roster's morale, and watch the Free Agent market closely. The Empire is looking to spend big."
         ..timestamp = DateTime.now()
         ..isRead = false
         ..actionRequired = false
         ..type = "DIRT_SHEET"; // Formats this as a Dirt Sheet instead of an Email
         
       await isar.writeTxn(() async {
         await isar.newsItems.put(item);
       });
    }
  }
}

final newsProvider = StateNotifierProvider<NewsNotifier, List<NewsItem>>((ref) => NewsNotifier());