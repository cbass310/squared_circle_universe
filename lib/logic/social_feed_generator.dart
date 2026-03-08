import 'dart:math';
import '../data/models/match.dart';
import '../data/models/sponsorship_deal.dart';
import 'game_state_provider.dart';

class SocialFeedGenerator {
  static final Random _rng = Random();

  static List<String> generateLivingFeed(List<Match> currentCard, GameState state) {
    List<String> feed = [];
    if (currentCard.isEmpty) return feed;

    Match mainEvent = currentCard.last;
    Match opener = currentCard.first;
    
    double mainRating = mainEvent.rating;
    
    // Safely grab the names of the main eventers (even if it's a draw)
    String w1 = "Competitor A";
    String w2 = "Competitor B";
    if (mainEvent.wrestlers.isNotEmpty) {
      w1 = mainEvent.wrestlers.elementAt(0).name;
      if (mainEvent.wrestlers.length > 1) {
        w2 = mainEvent.wrestlers.elementAt(1).name;
      }
    }

    // 1. POOL A: The Parody Podcasters (Blue Checkmarks)
    feed.add(_getPodcasterReaction(mainRating, state.isPPV, w1, w2));

    // 2. POOL B: The Everyday Fan Archetypes
    feed.addAll(_getFanReactions(mainRating, w1, w2, mainEvent.winnerName, mainEvent.type.name));

    // 3. POOL C: Card Dynamics (Did the opener steal the show?)
    if (currentCard.length > 1) {
      if (opener.rating >= 4.0 && opener.rating > mainRating + 1.0) {
        feed.add("@SmarkyMark: Hot take: The opening match completely overshadowed the main event. What a banger. #StoleTheShow");
      } else if (currentCard.every((m) => m.rating >= 3.5)) {
        feed.add("@WrestleAddict99: Top to bottom, this might be the most consistent card ${state.promotionName} has ever put on. No skips.");
      }
    }

    // 4. POOL D: Economy, Infrastructure & Tycoon Reactions
    String? tycoonTweet = _getTycoonReaction(state);
    if (tycoonTweet != null) feed.add(tycoonTweet);

    // Shuffle the feed so it feels chaotic and organic, then return the top 4
    feed.shuffle(_rng);
    return feed.take(4).toList();
  }

  // ====================================================================
  // THE PODCASTERS
  // ====================================================================
  static String _getPodcasterReaction(double rating, bool isPPV, String w1, String w2) {
    List<String> podcasters = [];

    // Dave Delta (Workrate obsession)
    if (rating >= 4.5) podcasters.add("⭐️ Dave Delta: The ring psychology between $w1 and $w2 tonight was exceptional. Easily 4.75 stars. Would be 5 in the Mega Dome.");
    else if (rating >= 3.5) podcasters.add("⭐️ Dave Delta: Solid main event workrate from $w1 and $w2. Mechanically sound, but lacked that final gear.");
    else podcasters.add("⭐️ Dave Delta: Sloppy transitions and missed spots. The booking of $w1 and $w2 here makes absolutely zero sense.");

    // The NY Smark (Hostile / Demanding)
    if (rating >= 4.0) podcasters.add("🎙️ NY Smark: Okay, I'll admit it. They cooked tonight. But don't mess it up next week!");
    else if (rating >= 3.0) podcasters.add("🎙️ NY Smark: It was fine. Just fine. And 'fine' doesn't draw money, bro.");
    else podcasters.add("🎙️ NY Smark: FIRE THE BOOKER. What an absolute embarrassment to the business. You can't put $w1 in that spot.");

    // Vinnie Rome (Crash TV / Attitude Era lover)
    if (rating >= 4.0) podcasters.add("💥 Vinnie Rome: Bro, what a main event! But listen to me, if they had a run-in at the end? Ratings gold, bro.");
    else podcasters.add("💥 Vinnie Rome: Bro, listen to me. Needs more swerves. Why wasn't there a forklift involved? Bro.");

    // King T (Hype / Legend)
    if (rating >= 4.0 && isPPV) podcasters.add("👑 King T: SHUCKY DUCKY QUACK QUACK! What a Pay-Per-View! We are making history tonight, baby!");
    else if (rating >= 3.5) podcasters.add("👑 King T: Now THAT is how you close a television show! Awwww yeah! $w1 is a star!");
    else podcasters.add("👑 King T: Well... they can't all be classics. We'll bounce back next week.");

    return podcasters[_rng.nextInt(podcasters.length)];
  }

  // ====================================================================
  // THE FANS
  // ====================================================================
  static List<String> _getFanReactions(double rating, String w1, String w2, String winner, String matchType) {
    List<String> feed = [];
    
    // Determine the loser for specific tweets
    String loser = (winner == w1) ? w2 : w1;
    bool isDraw = winner == "Draw" || winner.isEmpty;

    if (rating >= 4.5) {
      List<String> bangers = [
        "@Fanboy88: THIS IS AWESOME! 👏👏 👏👏👏",
        "@RingGeneral: Match of the year contender. Absolute masterpiece.",
        "@CasualFan22: I don't usually tweet about wrestling but $w1 vs $w2 just blew my mind. 🤯",
      ];
      if (!isDraw) bangers.add("@TheRealHeel: They finally strapped the rocket to $winner! IT'S ABOUT TIME.");
      bangers.shuffle();
      feed.addAll(bangers.take(2));
    } 
    else if (rating >= 3.0) {
      List<String> solid = [
        "@Section102: Solid main event tonight. Crowd was definitely into it.",
        "@IndieMark: Good stuff from $w1 and $w2. Wish they had a bit more time though.",
        "@CasualFan22: Pretty fun show overall! Worth the ticket price.",
      ];
      if (matchType.toLowerCase().contains("hardcore")) solid.add("@BloodGuts: That hardcore match was brutal in the best way possible. 🩸");
      solid.shuffle();
      feed.addAll(solid.take(2));
    } 
    else {
      List<String> duds = [
        "@Section102: I want a refund. That match was terrible. #Boring",
        "@IndieMark: 😴 Absolutely plodding. Changing the channel.",
        "@TheRealHeel: Why are they pushing $winner? The crowd is literally asleep.",
      ];
      if (!isDraw) duds.add("@SmarkyMark: Can't believe they buried $loser like that. Ruining their momentum.");
      duds.shuffle();
      feed.addAll(duds.take(2));
    }

    return feed;
  }

  // ====================================================================
  // THE INFRASTRUCTURE
  // ====================================================================
  static String? _getTycoonReaction(GameState state) {
    List<String> tycoonTweets = [];

    // Sponsor Reactions
    if (state.activeSponsors.any((s) => s.slotTarget == RealEstateSlot.canvas)) {
      String sponsorName = state.activeSponsors.firstWhere((s) => s.slotTarget == RealEstateSlot.canvas).sponsorName;
      tycoonTweets.add("@AntiCorpFan: Why is there a giant $sponsorName logo painted on the canvas? Looks so tacky. #Sellouts");
    }

    // Production Reactions
    if (state.techBroadcast >= 3) {
      tycoonTweets.add("@ProductionNerd: The pyro and camera work tonight looked INSANE. Dropping bags on production! 💰");
    } else if (state.techBroadcast == 1 && state.venueLevel >= 2) {
      tycoonTweets.add("@ProductionNerd: Great arena, but the lighting and cameras look like they were bought at a yard sale. Upgrade your tech!");
    }

    // Venue Reactions
    if (state.venueLevel == 1) {
      tycoonTweets.add("@LocalIndieGuy: Say what you want about the small gym, the acoustics make the chops sound LETHAL.");
    } else if (state.venueLevel == 4) {
      tycoonTweets.add("@CasualFan22: Seeing a wrestling ring in the middle of a massive global stadium never gets old. Chills.");
    }

    if (tycoonTweets.isNotEmpty) {
      return tycoonTweets[_rng.nextInt(tycoonTweets.length)];
    }
    return null;
  }
}