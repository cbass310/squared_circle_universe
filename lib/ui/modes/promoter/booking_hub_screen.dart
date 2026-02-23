import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/game_state_provider.dart';
import '../../../logic/promoter_provider.dart';
import '../../../logic/news_provider.dart';
import '../../../logic/rival_provider.dart';
import '../../../logic/sound_manager.dart'; 
import '../../../logic/inbox_provider.dart';
import '../../../logic/social_feed_generator.dart';
import '../../../data/models/match.dart';
import '../../../data/models/sponsorship_deal.dart';
import 'booking_screen.dart'; 
import 'post_show_recap_screen.dart';
import 'season_recap_screen.dart'; 
import 'end_game_screen.dart'; 

class BookingHubScreen extends ConsumerStatefulWidget {
  const BookingHubScreen({super.key});

  @override
  ConsumerState<BookingHubScreen> createState() => _BookingHubScreenState();
}

class _BookingHubScreenState extends ConsumerState<BookingHubScreen> {
  bool _hasPassedPreShow = false;

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);

    // 🌟 NEW FLOW: If it's a PPV, and you haven't booked anything yet, show the Hype Matrix!
    if (gameState.isPPV && !_hasPassedPreShow && gameState.currentCard.isEmpty) {
      return _buildPreShowPanel(gameState);
    }

    // Otherwise, show the normal Booking Interface!
    return _buildBookingInterface(gameState);
  }

  // ========================================================================
  // 🎙️ THE PRE-SHOW PANEL (Shows BEFORE Booking!)
  // ========================================================================
  Widget _buildPreShowPanel(dynamic gameState) {
    final eventSponsor = gameState.activeSponsors.where((s) => s.slotTarget == RealEstateSlot.eventName).firstOrNull;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              color: const Color(0xFF121212),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("KICKOFF SHOW", style: TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                  const SizedBox(height: 5),
                  Text(gameState.nextPPVName.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                  
                  if (eventSponsor != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text("Presented by ${eventSponsor.sponsorName}", style: const TextStyle(color: Colors.amber, fontStyle: FontStyle.italic)),
                    ),
                  
                  const Divider(color: Colors.white24, height: 30),
                  
                  const Text("THE STAKES TONIGHT:", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  const Text("Premium Live Event", style: TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold)),
                  
                  const SizedBox(height: 30),
                  const Text("THE EXPERTS PREDICT:", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                  const SizedBox(height: 15),

                  _buildPredictionQuote("⭐️ Dave Delta", "The build to this event has been solid. Now it's on the promoter to deliver a 5-star main event. No pressure."),
                  _buildPredictionQuote("🎙️ The NY Smark", "I paid good money to be in the arena tonight. The pacing better be perfect, or we are hijacking this show!"),
                  _buildPredictionQuote("👑 King T", "SHUCKY DUCKY QUACK QUACK! The electricity in this building is off the charts! It's time to book some magic, boss!"),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit_document, color: Colors.black),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                      label: const Text("ENTER BOOKING HUB", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                      onPressed: () {
                        setState(() {
                          _hasPassedPreShow = true;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset("assets/images/preshow_desk.png", fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.grey[900])),
                Container(
                  decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [const Color(0xFF121212), Colors.transparent], stops: const [0.0, 0.3])),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionQuote(String author, String quote) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(8), border: const Border(left: BorderSide(color: Colors.amber, width: 3))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(author, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 4),
            Text('"$quote"', style: const TextStyle(color: Colors.white70, fontStyle: FontStyle.italic, height: 1.4)),
          ],
        ),
      ),
    );
  }

  // ========================================================================
  // 📝 THE MATCH BOOKING INTERFACE
  // ========================================================================
  Widget _buildBookingInterface(dynamic gameState) {
    final rosterState = ref.watch(rosterProvider);
    final inboxState = ref.watch(inboxProvider);
    final notifier = ref.read(gameProvider.notifier);
    final rosterNotifier = ref.read(rosterProvider.notifier);

    String venueBackground;
    switch (gameState.venueLevel) {
      case 4: venueBackground = "assets/images/venue_stadium.png"; break;
      case 3: venueBackground = "assets/images/venue_arena.png"; break;
      case 2: venueBackground = "assets/images/venue_civic.png"; break;
      case 1: 
      default: venueBackground = "assets/images/venue_gym.png"; 
    }

    bool isCardFull = gameState.currentCard.length >= 3;
    bool isSeasonFinale = gameState.week == 52;
    bool isCareerFinale = gameState.year == 3 && gameState.week == 52; 

    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              decoration: const BoxDecoration(color: Colors.black, border: Border(right: BorderSide(color: Colors.white10))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: const [
                          Icon(Icons.tv, color: Colors.amber),
                          SizedBox(width: 10),
                          Text("BROADCAST HUB", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("OFFICIAL CARD", style: TextStyle(color: Colors.amber[700], fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 11)),
                          const SizedBox(height: 15),
                          _buildMatchSlot(context, gameState, 1, "OPENING CONTEST", 0),
                          const SizedBox(height: 10),
                          _buildMatchSlot(context, gameState, 2, "MID-CARD SHOWCASE", 1),
                          const SizedBox(height: 10),
                          _buildMatchSlot(context, gameState, 3, "MAIN EVENT", 2),
                          const SizedBox(height: 30),

                          if (isCardFull)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: Icon(inboxState.hasActionRequired ? Icons.lock : Icons.videocam, color: Colors.white),
                                label: Text(inboxState.hasActionRequired ? "INBOX BLOCKED" : "GO LIVE!", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: inboxState.hasActionRequired ? Colors.grey.shade800 : Colors.red[800], 
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: inboxState.hasActionRequired
                                  ? () {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("⚠️ ACTION REQUIRED: Check your Front Office Inbox before advancing!"), backgroundColor: Colors.redAccent));
                                    }
                                  : () async {
                                      ref.read(soundProvider).playSound("bell.mp3");

                                      if (context.mounted) {
                                        final socialFeed = SocialFeedGenerator.generateLivingFeed(gameState.currentCard, gameState);
                                        final completedCardToPass = List<Match>.from(gameState.currentCard); 

                                        await rosterNotifier.decayRivalries();
                                        await rosterNotifier.processContracts(); 
                                        await ref.read(rivalProvider.notifier).runAIWeeklyLogic();
                                        await ref.read(newsProvider.notifier).generateWeeklyNews(gameState.currentCard, rosterState.roster);
                                        await notifier.processWeek(rosterState.roster);
                                        
                                        if (context.mounted) {
                                          await showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (_) => _buildSocialFeedDialog(context, socialFeed),
                                          );

                                          if (isCareerFinale) {
                                            Navigator.push(context, MaterialPageRoute(builder: (_) => const EndGameScreen()));
                                          } else if (isSeasonFinale) {
                                            Navigator.push(context, MaterialPageRoute(builder: (_) => const SeasonRecapScreen()));
                                          } else {
                                            Navigator.push(context, MaterialPageRoute(builder: (_) => PostShowRecapScreen(completedCard: completedCardToPass)));
                                          }
                                        }
                                      }
                                  },
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(venueBackground, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.grey[900])),
                Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.black.withOpacity(0.9), Colors.transparent], stops: const [0.0, 0.4]))),
                if (isCardFull)
                  Positioned(
                    bottom: 40, right: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(Icons.videocam, size: 40, color: Colors.redAccent),
                        Text("LIVE BROADCAST", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white.withOpacity(0.9), letterSpacing: 1.5)),
                        Text("READY TO AIR", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent.withOpacity(0.9), letterSpacing: 1.5)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchSlot(BuildContext context, dynamic gameState, int index, String label, int listIndex) {
    Match? bookedMatch;
    if (gameState.currentCard.length > listIndex) bookedMatch = gameState.currentCard[listIndex];
    bool isBooked = bookedMatch != null;
    
    String matchTitle = "EMPTY SLOT";
    String statusText = "Tap to book segment";
    Color titleColor = Colors.white24;

    if (isBooked) {
      if (bookedMatch.rating > 0) {
          matchTitle = bookedMatch.winnerName.isNotEmpty ? "Winner: ${bookedMatch.winnerName}" : "Draw / No Contest";
          statusText = "${bookedMatch.rating} Stars";
          titleColor = Colors.greenAccent; 
      } else if (bookedMatch.wrestlers.isNotEmpty) {
         try {
            String p1 = bookedMatch.wrestlers.elementAt(0).name;
            String p2 = bookedMatch.wrestlers.length > 1 ? bookedMatch.wrestlers.elementAt(1).name : "???";
            matchTitle = "$p1 vs $p2";
            statusText = "${bookedMatch.type.name.toUpperCase()} MATCH";
            titleColor = Colors.white;
         } catch (e) {
            matchTitle = "Error Loading Names";
            titleColor = Colors.red;
         }
      } 
    }

    return GestureDetector(
      onTap: () {
        if (!isBooked) Navigator.push(context, MaterialPageRoute(builder: (_) => BookingScreen(segmentLabel: label)));
      },
      child: Container(
        height: 90, padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(8), border: Border.all(color: isBooked ? const Color(0xFFFFD740) : Colors.white10)),
        child: Row(
          children: [
            CircleAvatar(radius: 14, backgroundColor: isBooked ? const Color(0xFFFFD740) : Colors.grey[800], child: Text("$index", style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold))),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1.0)),
                  const SizedBox(height: 4),
                  Text(matchTitle, style: TextStyle(color: titleColor, fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(statusText, style: const TextStyle(color: Colors.amber, fontSize: 12)),
                ],
              ),
            ),
            if (!isBooked) const Icon(Icons.add, color: Colors.blueAccent) else const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialFeedDialog(BuildContext context, List<String> feed) {
    return AlertDialog(
      backgroundColor: const Color(0xFF121212),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.white10)),
      title: Row(children: const [Icon(Icons.tag, color: Colors.blueAccent), SizedBox(width: 10), Text("SOCIAL FEED REACTION", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))]),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true, itemCount: feed.length,
          itemBuilder: (ctx, i) {
            return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white12)), child: Text(feed[i], style: const TextStyle(color: Colors.white70, height: 1.4)));
          }
        ),
      ),
      actions: [
        SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 16)), onPressed: () => Navigator.pop(context), child: const Text("VIEW OFFICIAL RESULTS", style: TextStyle(fontWeight: FontWeight.bold))))
      ]
    );
  }
}