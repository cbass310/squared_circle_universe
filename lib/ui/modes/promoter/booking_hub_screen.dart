import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/wrestler_avatar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/game_state_provider.dart';
import '../../../logic/promoter_provider.dart';
import '../../../logic/news_provider.dart';
import '../../../logic/rival_provider.dart';
import '../../../logic/sound_manager.dart'; 
import '../../../logic/social_feed_generator.dart';
import '../../../logic/communications_provider.dart'; 
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

    if (gameState.isPPV && !_hasPassedPreShow && gameState.currentCard.isEmpty) {
      return _buildPreShowPanel(gameState);
    }

    return _buildBookingInterface(gameState);
  }

  // ========================================================================
  // 🎙️ THE DYNAMIC PRE-SHOW DESK PANEL
  // ========================================================================
  Widget _buildPreShowPanel(dynamic gameState) {
    
    // Safety check for sponsors
    SponsorshipDeal? eventSponsor;
    try {
      final matchingSponsors = gameState.activeSponsors.where((s) => s.slotTarget == RealEstateSlot.eventName);
      if (matchingSponsors.isNotEmpty) {
        eventSponsor = matchingSponsors.first;
      }
    } catch (_) {}

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. The Arena / Desk Background
          Image.asset(
            "assets/images/preshow_desk.png", 
            fit: BoxFit.cover, 
            errorBuilder: (c, e, s) => Container(color: const Color(0xFF121212))
          ),
          
          // 2. Broadcast Gradients (Dark on the left for text readability)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft, 
                end: Alignment.centerRight, 
                colors: [Colors.black.withOpacity(0.95), Colors.black.withOpacity(0.8), Colors.transparent], 
                stops: const [0.0, 0.4, 1.0]
              ),
            ),
          ),
          
          // 3. The Content Overlay
          Row(
            children: [
              // LEFT COLUMN: Show Details & Button
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("KICKOFF SHOW", style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 3.0)),
                      const SizedBox(height: 8),
                      Text(gameState.nextPPVName.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                      
                      if (eventSponsor != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text("Presented by ${eventSponsor.sponsorName}", style: const TextStyle(color: Colors.amber, fontSize: 16, fontStyle: FontStyle.italic)),
                        ),
                      
                      const SizedBox(height: 40),
                      
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          border: const Border(left: BorderSide(color: Colors.amber, width: 4))
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("THE STAKES TONIGHT:", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                            SizedBox(height: 8),
                            Text("Premium Live Event", style: TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),

                      const Spacer(),
                      
                      SizedBox(
                        width: double.infinity,
                        height: 65,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.edit_document, color: Colors.black, size: 24),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber, 
                            foregroundColor: Colors.black, 
                            elevation: 10,
                            shadowColor: Colors.amber.withOpacity(0.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                          ),
                          label: const Text("ENTER BOOKING HUB", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1.5)),
                          onPressed: () {
                            HapticFeedback.heavyImpact();
                            
                            // 🚨 TIER 2 IDIOT CHECK: Safely verify TV & Sponsors before letting them pass
                            bool missingTv = false;
                            bool missingSponsors = false;

                            try {
                              if (!gameState.isPPV) {
                                try { missingTv = gameState.activeTvDeals.isEmpty; } 
                                catch (_) {
                                  try { missingTv = gameState.tvDeals.isEmpty; } 
                                  catch (_) {
                                    try { missingTv = gameState.activeTvDeal == null; } 
                                    catch (_) { missingTv = false; }
                                  }
                                }
                              }
                            } catch (_) {}

                            try {
                              missingSponsors = gameState.activeSponsors.isEmpty;
                            } catch (_) {}

                            if (missingTv || missingSponsors) {
                              _showMissingInfrastructureWarning(context, missingTv, missingSponsors);
                            } else {
                              setState(() {
                                _hasPassedPreShow = true;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // RIGHT COLUMN: The Expert Panel
              Expanded(
                flex: 6,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(right: 32.0, top: 40.0, bottom: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
                        child: const Text("THE EXPERTS PREDICT:", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
                      ),
                      const SizedBox(height: 24),
                      
                      // 🎙️ Host
                      _buildExpertAvatarQuote("assets/images/host.png", "Sarah Styles", "Host", "Welcome to the Kickoff! The crowd is filling in, and anticipation is at an all-time high. Let's get right to our panel—gentlemen, what are we expecting tonight?", Colors.blueAccent),
                      
                      // 📊 Dave Delta
                      _buildExpertAvatarQuote("assets/images/delta.png", "Dave Delta", "Analyst", "The build to this event has been mechanically sound. Now it's on the promoter to execute. If the Main Event psychology holds up, we are looking at 5 stars.", Colors.greenAccent),
                      
                      // 🕶️ NY Smirk
                      _buildExpertAvatarQuote("assets/images/smirk.png", "The NY Smark", "Superfan", "Look, I paid good money for these seats. If they don't deliver a clean finish tonight, me and the boys in section 104 are hijacking this show!", Colors.redAccent),
                      
                      // 👑 King T
                      _buildExpertAvatarQuote("assets/images/king_t.png", "King T", "Legend", "SHUCKY DUCKY QUACK QUACK! The electricity in this building is off the charts! It's time to book some magic, boss!", Colors.amber),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🚨 THE NEW TIER 2 WARNING POPUP
  void _showMissingInfrastructureWarning(BuildContext context, bool missingTv, bool missingSponsors) {
    String warningMessage = "You are about to run a show with massive infrastructure gaps. This will result in heavy financial losses!\n\n";
    if (missingTv) warningMessage += "• NO ACTIVE TV DEAL: You will not receive any broadcast revenue.\n";
    if (missingSponsors) warningMessage += "• NO ACTIVE SPONSORS: You are leaving thousands of dollars in ad revenue on the table.";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.redAccent, width: 2)),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
            SizedBox(width: 10),
            Text("WARNING: REVENUE LOSS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
          ],
        ),
        content: Text(warningMessage, style: const TextStyle(color: Colors.white70, height: 1.5)),
        actions: [
          TextButton(
            child: const Text("GO FIX IT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.withOpacity(0.2), foregroundColor: Colors.redAccent, elevation: 0),
            child: const Text("PROCEED ANYWAY", style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _hasPassedPreShow = true;
              });
            },
          ),
        ],
      ),
    );
  }

  // 🛠️ The New Avatar + Text Bubble Layout for the Experts
  Widget _buildExpertAvatarQuote(String imagePath, String name, String role, String quote, Color brandColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The Text Bubble
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(role.toUpperCase(), style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                    const SizedBox(width: 8),
                    Text(name.toUpperCase(), style: TextStyle(color: brandColor, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1.0)),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.85),
                    border: Border.all(color: brandColor.withOpacity(0.3), width: 1.5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: Text('"$quote"', style: const TextStyle(color: Colors.white, fontStyle: FontStyle.italic, height: 1.5, fontSize: 13), textAlign: TextAlign.right),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          
          // The Expert Avatar
          Container(
            width: 65, 
            height: 65,
            decoration: BoxDecoration(
              shape: BoxShape.circle, 
              border: Border.all(color: brandColor, width: 2), 
              color: const Color(0xFF1E1E1E),
              boxShadow: [BoxShadow(color: brandColor.withOpacity(0.3), blurRadius: 10)]
            ),
            child: ClipOval(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                alignment: const Alignment(0.0, -0.6), // Frames the AI portrait properly!
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: Text(name[0], style: TextStyle(color: brandColor, fontWeight: FontWeight.w900, fontSize: 24)));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========================================================================
  // 📝 THE MATCH BOOKING INTERFACE
  // ========================================================================
  Widget _buildBookingInterface(dynamic gameState) {
    final rosterState = ref.watch(rosterProvider);
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
                                icon: const Icon(Icons.videocam, color: Colors.white),
                                label: const Text("GO LIVE!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red[800], 
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () async {
                                  HapticFeedback.heavyImpact();
                                  ref.read(soundProvider).playSound("bell.mp3");

                                  if (context.mounted) {
                                    final socialFeed = SocialFeedGenerator.generateLivingFeed(gameState.currentCard, gameState);
                                    final completedCardToPass = List<Match>.from(gameState.currentCard); 

                                    // 🛠️ THE FIX: Show the Social Feed Dialog FIRST. 
                                    await showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) => _buildSocialFeedDialog(context, socialFeed),
                                    );

                                    // 🛠️ THE FIX: Process the week AFTER they dismiss the dialog.
                                    await rosterNotifier.decayRivalries();
                                    await rosterNotifier.processContracts(); 
                                    await ref.read(rivalProvider.notifier).runAIWeeklyLogic();
                                    await ref.read(newsProvider.notifier).generateWeeklyNews(gameState.currentCard, rosterState.roster);
                                    
                                    await notifier.processWeek(rosterState.roster);
                                    
                                    final newWeek = ref.read(gameProvider).week;
                                    ref.read(communicationsProvider.notifier).generateWeeklyContent(newWeek);

                                    // 🛠️ THE FIX: Navigate to the recap screens immediately so they don't see the Booking Hub reset
                                    if (context.mounted) {
                                      if (isCareerFinale) {
                                        await Navigator.push(context, MaterialPageRoute(builder: (_) => const EndGameScreen()));
                                      } else if (isSeasonFinale) {
                                        await Navigator.push(context, MaterialPageRoute(builder: (_) => const SeasonRecapScreen()));
                                      } else {
                                        await Navigator.push(context, MaterialPageRoute(builder: (_) => PostShowRecapScreen(completedCard: completedCardToPass)));
                                      }

                                      // 🛠️ THE FIX: Reset the Pre-Show state when they eventually return to the booking hub!
                                      setState(() {
                                        _hasPassedPreShow = false;
                                      });
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
        HapticFeedback.selectionClick();
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
                  if (isBooked && bookedMatch!.wrestlers.isNotEmpty)
                    Row(
                      children: [
                        ...bookedMatch!.wrestlers.take(2).map((w) => Padding(padding: const EdgeInsets.only(right: 6.0), child: WrestlerAvatar(wrestler: w, radius: 12))),
                        Expanded(child: Text(matchTitle, style: TextStyle(color: titleColor, fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      ],
                    )
                  else
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