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
    List<NewsItem> generatedNews = [];

    // ==========================================================
    // 1. CARDS & MATCH REACTIONS (SOCIAL & DIRT SHEET)
    // ==========================================================
    if (currentCard.isNotEmpty) {
      // Find the highest and lowest rated matches from the show you just booked
      Match? bestMatch = currentCard.reduce((curr, next) => curr.rating > next.rating ? curr : next);
      Match? worstMatch = currentCard.reduce((curr, next) => curr.rating < next.rating ? curr : next);

      // 🔥 BANGER MATCH REACTION (4.5+ Stars)
      if (bestMatch.rating >= 4.5 && rng.nextDouble() < 0.7) {
        generatedNews.add(_createNews(
          sender: "Meltz Ratings",
          subject: "Match of the Year Candidate?",
          body: "The ${bestMatch.winnerName} vs ${bestMatch.loserName} bout from this week's card is receiving universal acclaim. I'm hearing it might get the elusive 5-star rating in this week's newsletter.",
          type: "DIRT_SHEET",
        ));
        generatedNews.add(_createNews(
          sender: "@WrestlingFan99",
          subject: "Trending: #${bestMatch.winnerName.replaceAll(' ', '')}",
          body: "Are you kidding me?! ${bestMatch.winnerName} and ${bestMatch.loserName} just put on an absolute CLINIC! Best match I've seen all year. 🔥🔥🔥",
          type: "SOCIAL",
        ));
      }

      // 🗑️ DUD MATCH REACTION (Under 2.0 Stars)
      if (worstMatch.rating <= 2.0 && rng.nextDouble() < 0.6) {
        generatedNews.add(_createNews(
          sender: "@SmarkyMark",
          subject: "Trending: #Botchfest",
          body: "That ${worstMatch.winnerName} match was absolute garbage. Total bathroom break segment. The promoter needs to do better.",
          type: "SOCIAL",
        ));
      }
    }

    // ==========================================================
    // 2. ROSTER RUMORS & GOSSIP (DIRT SHEET)
    // ==========================================================
    List<Wrestler> playerRoster = roster.where((w) => w.companyId == 0).toList();
    
    // 😡 UNHAPPY WRESTLERS
    var unhappy = playerRoster.where((w) => w.morale < 40 && !w.isHoldingOut).toList();
    if (unhappy.isNotEmpty && rng.nextDouble() < 0.5) {
      unhappy.shuffle();
      var w = unhappy.first;
      generatedNews.add(_createNews(
        sender: "The Observer Wire",
        subject: "Backstage Heat: ${w.name}",
        body: "Sources indicate that ${w.name} is extremely frustrated with their current position. If management doesn't step in with a cash bonus soon, expect a formal walkout.",
        type: "DIRT_SHEET",
      ));
    }

    // 💰 FREE AGENT BIDDING WARS
    List<Wrestler> freeAgents = roster.where((w) => w.companyId == -1 && w.pop > 70).toList();
    if (freeAgents.isNotEmpty && rng.nextDouble() < 0.4) {
      freeAgents.shuffle();
      var fa = freeAgents.first;
      generatedNews.add(_createNews(
        sender: "Wrestling Insider",
        subject: "Free Agent Market: ${fa.name}",
        body: "The hottest free agent on the market right now is ${fa.name}. Empire Wrestling is reportedly preparing a massive contract offer. Don't let the competition snatch them up!",
        type: "DIRT_SHEET",
      ));
    }

    // ==========================================================
    // 3. GENERIC INDUSTRY RUMORS (DIRT SHEET)
    // ==========================================================
    if (rng.nextDouble() < 0.25) {
      List<String> genericRumors = [
        "Network executives are reportedly paying close attention to TV ratings this month. A bad string of shows could lead to cancelled deals.",
        "Merchandise sales across the industry are up 15%. Make sure you have highly popular stars on your roster to capitalize on the boom.",
        "Rumors are swirling that Empire Wrestling is looking to aggressively expand their arena infrastructure.",
      ];
      genericRumors.shuffle();
      generatedNews.add(_createNews(
        sender: "Industry Dirt Sheet",
        subject: "Weekly Industry Roundup",
        body: genericRumors.first,
        type: "DIRT_SHEET",
      ));
    }

    // ==========================================================
    // SAVE TO DATABASE
    // ==========================================================
    if (generatedNews.isNotEmpty) {
      await isar.writeTxn(() async {
        await isar.newsItems.putAll(generatedNews);
      });
      // Optionally update the state list if needed by your UI
      state = [...state, ...generatedNews]; 
    }
  }

  // Helper function to quickly format a news item
  NewsItem _createNews({required String sender, required String subject, required String body, required String type}) {
    return NewsItem()
      ..sender = sender
      ..subject = subject
      ..body = body
      ..timestamp = DateTime.now()
      ..isRead = false
      ..actionRequired = false
      ..type = type;
  }
}

final newsProvider = StateNotifierProvider<NewsNotifier, List<NewsItem>>((ref) => NewsNotifier());