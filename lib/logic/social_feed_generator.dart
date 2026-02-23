import 'dart:math';
import '../data/models/match.dart';
import '../data/models/sponsorship_deal.dart';
import 'game_state_provider.dart';

class SocialFeedGenerator {
  static final Random _rng = Random();

  static List<String> generateLivingFeed(List<Match> currentCard, GameState state) {
    List<String> feed = [];
    if (currentCard.isEmpty) return feed;

    // Evaluate the Main Event (the last match on the card)
    Match mainEvent = currentCard.last;
    double rating = mainEvent.rating;

    // 1. POOL A: The Parody Podcasters (Blue Checkmarks)
    feed.add(_getPodcasterReaction(rating, state.isPPV));

    // 2. POOL B: The Everyday Fan Archetypes
    if (rating >= 4.5) {
      feed.addAll([
        "@SmarkyMark: THIS IS AWESOME! 👏👏 👏👏👏",
        "@WrestleGod99: Match of the year contender. Absolute masterpiece.",
      ]);
    } else if (rating >= 3.0) {
      feed.addAll([
        "@Section102: Solid main event tonight. Crowd was definitely into it.",
        "@CasualFan: Good stuff. Wish they had a bit more time though.",
      ]);
    } else {
      feed.addAll([
        "@Section102: I want a refund. That match was terrible. #Boring",
        "@CasualFan: 😴 Absolutely plodding. Changing the channel.",
      ]);
    }

    // 3. POOL C: Economy & Tycoon Reactions
    if (state.activeSponsors.any((s) => s.slotTarget == RealEstateSlot.canvas)) {
      String sponsorName = state.activeSponsors.firstWhere((s) => s.slotTarget == RealEstateSlot.canvas).sponsorName;
      feed.add("@AntiCorpFan: Why is there a giant $sponsorName logo painted on the canvas? Looks so tacky. #Sellouts");
    }

    if (state.techBroadcast >= 3) {
      feed.add("@ProductionNerd: The pyro and camera work tonight looked INSANE. Terminal Software dropping bags on production! 💰");
    }

    // Shuffle the feed so it feels chaotic and organic
    feed.shuffle(_rng);

    // Return the top 4 posts for the UI
    return feed.take(4).toList();
  }

  static String _getPodcasterReaction(double rating, bool isPPV) {
    List<String> podcasters = [];

    // Dave Delta (Workrate obsession)
    if (rating >= 4.0) podcasters.add("⭐️ Dave Delta: Fantastic workrate in the main event. Easily 4.5 stars in the Tokyo Dome.");
    if (rating <= 2.5) podcasters.add("⭐️ Dave Delta: Sloppy transitions and missed spots. The booking here makes zero sense.");

    // The NY Smark (Hostile)
    if (rating >= 3.5) podcasters.add("🎙️ NY Smark: Okay, I'll admit it. They cooked tonight. But don't mess it up next week!");
    if (rating < 3.5) podcasters.add("🎙️ NY Smark: FIRE THE BOOKER. What an absolute embarrassment to the business.");

    // Vinnie Rome (Crash TV)
    podcasters.add("💥 Vinnie Rome: Bro, listen to me. Needs more swerves. Why wasn't there a forklift involved? Bro.");

    // King T (Hype!)
    if (rating >= 4.0 && isPPV) podcasters.add("👑 King T: SHUCKY DUCKY QUACK QUACK! What a Pay-Per-View! We are making history tonight, baby!");
    if (rating >= 3.5 && !isPPV) podcasters.add("👑 King T: Now THAT is how you close a television show! Awwww yeah!");

    return podcasters[_rng.nextInt(podcasters.length)];
  }
}