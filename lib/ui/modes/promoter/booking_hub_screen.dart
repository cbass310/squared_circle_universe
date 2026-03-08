import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math'; 
import '../../widgets/wrestler_avatar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/game_state_provider.dart';
import '../../../logic/promoter_provider.dart';
import '../../../logic/news_provider.dart';
import '../../../logic/rival_provider.dart';
import '../../../logic/sound_manager.dart'; 
import '../../../logic/social_feed_generator.dart';
import '../../../logic/communications_provider.dart'; 
import '../../../logic/booking_provider.dart'; 
import '../../../data/models/match.dart';
import '../../../data/models/wrestler.dart';
import '../../../data/models/sponsorship_deal.dart';
import 'booking_screen.dart'; 
import 'post_show_recap_screen.dart';
import 'season_recap_screen.dart'; 
import 'end_game_screen.dart'; 
import 'bankruptcy_screen.dart';

class BookingHubScreen extends ConsumerStatefulWidget {
  const BookingHubScreen({super.key});

  @override
  ConsumerState<BookingHubScreen> createState() => _BookingHubScreenState();
}

class _BookingHubScreenState extends ConsumerState<BookingHubScreen> {
  bool _hasPassedPreShow = false;
  bool _isAutoBooking = false; 

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final rosterState = ref.watch(rosterProvider);

    if (gameState.isPPV && !_hasPassedPreShow && gameState.currentCard.isEmpty) {
      return _buildPreShowPanel(gameState, rosterState);
    }

    return _buildBookingInterface(gameState);
  }

  // ========================================================================
  // 🎙️ THE DYNAMIC PRE-SHOW DESK PANEL (RESPONSIVE)
  // ========================================================================
  Widget _buildPreShowPanel(dynamic gameState, dynamic rosterState) {
    SponsorshipDeal? eventSponsor;
    try {
      final matchingSponsors = gameState.activeSponsors.where((s) => s.slotTarget == RealEstateSlot.eventName);
      if (matchingSponsors.isNotEmpty) {
        eventSponsor = matchingSponsors.first;
      }
    } catch (_) {}

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 600;

        if (isDesktop) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset("assets/images/preshow_desk.png", fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: const Color(0xFF121212))),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.black.withOpacity(0.95), Colors.black.withOpacity(0.8), Colors.transparent], stops: const [0.0, 0.4, 1.0]),
                  ),
                ),
                Row(
                  children: [
                    Expanded(flex: 4, child: _buildPreShowLeftColumn(gameState, eventSponsor, isDesktop)),
                    Expanded(
                      flex: 6,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(right: 32.0, top: 40.0, bottom: 32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: _buildExpertQuotes(gameState, rosterState), 
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset("assets/images/preshow_desk.png", fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: const Color(0xFF121212))),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withOpacity(0.3), Colors.black], stops: const [0.5, 1.0]),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("KICKOFF SHOW", style: TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
                              Text(gameState.nextPPVName.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                              if (eventSponsor != null)
                                Padding(padding: const EdgeInsets.only(top: 4.0), child: Text("Presented by ${eventSponsor.sponsorName}", style: const TextStyle(color: Colors.amber, fontSize: 12, fontStyle: FontStyle.italic))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    color: Colors.black,
                    width: double.infinity,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildPreShowEnterButton(gameState, context),
                          const SizedBox(height: 24),
                          ..._buildExpertQuotes(gameState, rosterState), 
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }
    );
  }

  Widget _buildPreShowLeftColumn(dynamic gameState, SponsorshipDeal? eventSponsor, bool isDesktop) {
    return Padding(
      padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("KICKOFF SHOW", style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 3.0)),
          const SizedBox(height: 8),
          Text(gameState.nextPPVName.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
          if (eventSponsor != null)
            Padding(padding: const EdgeInsets.only(top: 8.0), child: Text("Presented by ${eventSponsor.sponsorName}", style: const TextStyle(color: Colors.amber, fontSize: 16, fontStyle: FontStyle.italic))),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), border: const Border(left: BorderSide(color: Colors.amber, width: 4))),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("THE STAKES TONIGHT:", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                SizedBox(height: 8),
                Text("Premium Live Event", style: TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Spacer(),
          _buildPreShowEnterButton(gameState, context),
        ],
      ),
    );
  }

  Widget _buildPreShowEnterButton(dynamic gameState, BuildContext context) {
    return SizedBox(
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
        label: const Text("ENTER BOOKING HUB", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.5)),
        onPressed: () {
          HapticFeedback.heavyImpact();
          bool missingTv = false;
          bool missingSponsors = false;

          try {
            if (!gameState.isPPV) {
              try { missingTv = gameState.activeTvDeals.isEmpty; } catch (_) {
                try { missingTv = gameState.tvDeals.isEmpty; } catch (_) {
                  try { missingTv = gameState.activeTvDeal == null; } catch (_) { missingTv = false; }
                }
              }
            }
          } catch (_) {}
          try { missingSponsors = gameState.activeSponsors.isEmpty; } catch (_) {}

          if (missingTv || missingSponsors) {
            _showMissingInfrastructureWarning(context, missingTv, missingSponsors);
          } else {
            setState(() { _hasPassedPreShow = true; });
          }
        },
      ),
    );
  }

  // 🚨 THE NEW DYNAMIC EXPERT QUOTES ENGINE 🚨
  List<Widget> _buildExpertQuotes(dynamic gameState, dynamic rosterState) {
    final rng = Random();

    // 1. Host Dynamic Quote (Reacts to Venue Name)
    String venueName = gameState.currentVenueDetails['name'] ?? "arena";
    String hostQuote = "Welcome to the ${gameState.nextPPVName} Kickoff! The crowd here at the $venueName is filling in, and anticipation is at an all-time high. Gentlemen, what are we expecting tonight?";

    // 2. Dave Delta Dynamic Quote (Reacts to active Rivalries)
    dynamic topFeud;
    if (rosterState.activeRivalries.isNotEmpty) {
      final sortedFeuds = List<dynamic>.from(rosterState.activeRivalries);
      sortedFeuds.sort((dynamic a, dynamic b) => (b.heat as num).compareTo(a.heat as num));
      topFeud = sortedFeuds.first;
    }
    String deltaQuote;
    if (topFeud != null && topFeud.heat >= 40) {
      deltaQuote = "The build to ${topFeud.wrestlerA.name} vs ${topFeud.wrestlerB.name} has been mechanically sound. It absolutely has to headline tonight, and if the psychology holds up, we are looking at 5 stars.";
    } else {
      deltaQuote = "To be honest, the storylines coming into this event are a bit cold. The promoter is going to have to rely on pure in-ring workrate to justify the pay-per-view price.";
    }

    // 3. The NY Smark Dynamic Quote (Reacts to Economy & Infrastructure)
    List<String> smarkQuotes = [
      "Look, I paid good money for these seats. If they don't deliver a clean finish tonight, me and the boys in section 104 are hijacking this show!",
      "If I see one more meaningless draw on this card, I'm canceling my streaming subscription. Give the fans what they want!",
    ];
    if (gameState.venueLevel == 4) {
      smarkQuotes.add("I can't believe they booked a stadium this big. The acoustics are terrible for chants. Better be a good show.");
    }
    if (gameState.cash < 20000) {
      smarkQuotes.add("Rumor on Reddit is management is bouncing checks. They better go all out tonight before the company folds.");
    }
    String smarkQuote = smarkQuotes[rng.nextInt(smarkQuotes.length)];

    // 4. King T Dynamic Quote (Hype variations)
    List<String> kingQuotes = [
      "SHUCKY DUCKY QUACK QUACK! The electricity in this building is off the charts! It's time to book some magic, boss!",
      "I just walked out of the locker room, and let me tell you, these athletes are ready for WAR tonight! Awwww yeah!",
      "It's Pay-Per-View time! The lights are bright, the stakes are high, and reputations are on the line!"
    ];
    String kingQuote = kingQuotes[rng.nextInt(kingQuotes.length)];

    return [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(4)),
        child: const Text("THE EXPERTS PREDICT:", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
      ),
      _buildExpertAvatarQuote("assets/images/host.png", "Sarah Styles", "Host", hostQuote, Colors.blueAccent),
      _buildExpertAvatarQuote("assets/images/delta.png", "Dave Delta", "Analyst", deltaQuote, Colors.greenAccent),
      _buildExpertAvatarQuote("assets/images/smirk.png", "The NY Smark", "Superfan", smarkQuote, Colors.redAccent),
      _buildExpertAvatarQuote("assets/images/king_t.png", "King T", "Legend", kingQuote, Colors.amber),
    ];
  }

  // ========================================================================
  // 📝 THE MATCH BOOKING INTERFACE (RESPONSIVE)
  // ========================================================================
  Widget _buildBookingInterface(dynamic gameState) {
    String venueBackground;
    switch (gameState.venueLevel) {
      case 4: venueBackground = "assets/images/venue_stadium.png"; break;
      case 3: venueBackground = "assets/images/venue_arena.png"; break;
      case 2: venueBackground = "assets/images/venue_civic.png"; break;
      case 1: 
      default: venueBackground = "assets/images/venue_gym.png"; 
    }

    bool isCardFull = gameState.currentCard.length >= 3;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 600; 

        if (isDesktop) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Row(
              children: [
                Expanded(flex: 4, child: Container(decoration: const BoxDecoration(color: Colors.black, border: Border(right: BorderSide(color: Colors.white10))), child: _buildMatchList(gameState, isCardFull, isDesktop))),
                Expanded(
                  flex: 6,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(venueBackground, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.grey[900])),
                      Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.black.withOpacity(0.9), Colors.transparent], stops: const [0.0, 0.4]))),
                      if (isCardFull) _buildLiveBroadcastBanner(true),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(venueBackground, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.grey[900])),
                      Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withOpacity(0.3), Colors.black], stops: const [0.5, 1.0]))),
                      
                      const SafeArea(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.tv, color: Colors.amber, size: 20),
                                  SizedBox(width: 8),
                                  Text("LIVE EVENT CONTROLS", style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text("BROADCAST HUB", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                            ],
                          ),
                        ),
                      ),
                      if (isCardFull) _buildLiveBroadcastBanner(false),
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    color: Colors.black,
                    width: double.infinity,
                    child: _buildMatchList(gameState, isCardFull, isDesktop),
                  ),
                ),
              ],
            ),
          );
        }
      }
    );
  }

  // 🚨 THE FIXED GM AUTO-BOOK ALGORITHM 🚨
  Future<void> _autoBookShow() async {
    if (_isAutoBooking) return; 
    setState(() => _isAutoBooking = true);
    
    HapticFeedback.lightImpact();
    final rosterState = ref.read(rosterProvider);
    final gameNotifier = ref.read(gameProvider.notifier);
    final bookingNotifier = ref.read(bookingProvider.notifier);

    // 1. Get healthy roster
    List<Wrestler> activeRoster = List<Wrestler>.from(
      rosterState.roster.where((w) => w.companyId == 0 && !w.isOnIR && !w.isInjured)
    );

    if (activeRoster.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Not enough healthy wrestlers to Auto-Book! (Need 6)"), backgroundColor: Colors.redAccent)
      );
      setState(() => _isAutoBooking = false);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator(color: Colors.cyanAccent)),
    );

    // 2. Sort by Popularity
    activeRoster.sort((a, b) => b.pop.compareTo(a.pop));
    
    dynamic topFeud;
    if (rosterState.activeRivalries.isNotEmpty) {
      final sortedFeuds = List<dynamic>.from(rosterState.activeRivalries);
      sortedFeuds.sort((dynamic a, dynamic b) => (b.heat as num).compareTo(a.heat as num));
      topFeud = sortedFeuds.first;
    }

    // 3. Define the 3 Matchups
    List<List<Wrestler>> suggestedMatches = [];

    // --- OPENER ---
    var opener1 = activeRoster[activeRoster.length - 3];
    var opener2 = activeRoster[activeRoster.length - 2];
    suggestedMatches.add([opener1, opener2]);

    // --- MID-CARD ---
    var champ = activeRoster.firstWhere((w) => w.isTVChampion, orElse: () => activeRoster[1]);
    var challenger = activeRoster.firstWhere((w) => 
      w.id != champ.id && 
      (topFeud == null || (w.id != topFeud.wrestlerA.id && w.id != topFeud.wrestlerB.id)), 
      orElse: () => activeRoster[2]
    );
    suggestedMatches.add([champ, challenger]);

    // --- MAIN EVENT ---
    if (topFeud != null) {
      Wrestler me1 = activeRoster.firstWhere((w) => w.id == topFeud.wrestlerA.id, orElse: () => activeRoster[0]);
      Wrestler me2 = activeRoster.firstWhere((w) => w.id == topFeud.wrestlerB.id, orElse: () => activeRoster[1]);
      suggestedMatches.add([me1, me2]);
    } else {
      suggestedMatches.add([activeRoster[0], activeRoster[1]]);
    }

    // 4. Silently Simulate the Matches (With Local Winner Logic!)
    final rng = Random();
    for (int i = 0; i < 3; i++) {
      await Future.delayed(const Duration(milliseconds: 300)); 
      
      // Randomize match types (IronMan removed!)
      MatchType type = MatchType.standard;
      if (rng.nextDouble() > 0.7) {
        List<MatchType> altTypes = [MatchType.hardcore, MatchType.submission];
        type = altTypes[rng.nextInt(altTypes.length)];
      }

      bookingNotifier.setMatchType(type);
      bookingNotifier.startMatchSimulation(suggestedMatches[i]); 
      
      await Future.delayed(const Duration(milliseconds: 100)); 
      final resultState = ref.read(bookingProvider);
      
      Wrestler p1 = suggestedMatches[i][0];
      Wrestler p2 = suggestedMatches[i][1];
      double p1Score = p1.pop + (p1.ringSkill * 0.5) + rng.nextInt(20);
      double p2Score = p2.pop + (p2.ringSkill * 0.5) + rng.nextInt(20);

      Wrestler simWinner = p1Score >= p2Score ? p1 : p2;
      Wrestler simLoser = simWinner == p1 ? p2 : p1;

      final completedMatch = Match()
        ..wrestlers.addAll(suggestedMatches[i])
        ..type = resultState.selectedType
        ..rating = resultState.currentMatchRating
        ..winnerName = simWinner.name
        ..loserName = simLoser.name;

      gameNotifier.addMatchToCard(completedMatch);
      bookingNotifier.reset(); 
    }

    if (mounted) {
      Navigator.pop(context); // Close loader
      setState(() => _isAutoBooking = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Assistant GM Auto-Booked the Show!"), backgroundColor: Colors.cyanAccent)
      );
    }
  }

  Widget _buildMatchList(dynamic gameState, bool isCardFull, bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isDesktop)
          const SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Icon(Icons.tv, color: Colors.amber),
                  SizedBox(width: 10),
                  Text("BROADCAST HUB", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
                ],
              ),
            ),
          ),
          
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: isDesktop ? 0 : 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("OFFICIAL CARD", style: TextStyle(color: Colors.amber[700], fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 11)),
                    
                    if (!isCardFull)
                      TextButton.icon(
                        icon: const Icon(Icons.auto_awesome, color: Colors.cyanAccent, size: 16),
                        label: const Text("DELEGATE TO GM", style: TextStyle(color: Colors.cyanAccent, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: Colors.cyanAccent.withOpacity(0.1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.cyanAccent)),
                        ),
                        onPressed: _autoBookShow,
                      ),
                  ],
                ),
                const SizedBox(height: 15),
                _buildMatchSlot(context, gameState, 1, "OPENING CONTEST", 0),
                const SizedBox(height: 10),
                _buildMatchSlot(context, gameState, 2, "MID-CARD SHOWCASE", 1),
                const SizedBox(height: 10),
                _buildMatchSlot(context, gameState, 3, "MAIN EVENT", 2),
                const SizedBox(height: 30),
                if (isCardFull) _buildGoLiveButton(gameState), 
                const SizedBox(height: 40), 
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLiveBroadcastBanner(bool isDesktop) {
    return SafeArea(
      child: Align(
        alignment: isDesktop ? Alignment.bottomRight : Alignment.topLeft,
        child: Padding(
          padding: isDesktop ? const EdgeInsets.all(40.0) : const EdgeInsets.only(top: 16.0, left: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: isDesktop ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.videocam, size: 24, color: Colors.redAccent),
                  SizedBox(width: 8),
                  Text("READY TO AIR", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.redAccent, letterSpacing: 1.5)),
                ],
              ),
              const SizedBox(height: 4),
              Text("LIVE BROADCAST", style: TextStyle(fontSize: isDesktop ? 28 : 20, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoLiveButton(dynamic gameState) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.videocam, color: Colors.white),
        label: const Text("GO LIVE!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[800], 
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () => _executeShow(gameState),
      ),
    );
  }

  Future<void> _executeShow(dynamic gameState) async {
    HapticFeedback.heavyImpact();
    ref.read(soundProvider).playSound("bell.mp3");

    if (!context.mounted) return;
    
    final rosterState = ref.watch(rosterProvider);
    final notifier = ref.read(gameProvider.notifier);
    final rosterNotifier = ref.read(rosterProvider.notifier);
    
    bool isSeasonFinale = gameState.week == 52;
    bool isCareerFinale = gameState.year == 3 && gameState.week == 52; 
    
    final completedCardToPass = List<Match>.from(gameState.currentCard); 
    final socialFeed = SocialFeedGenerator.generateLivingFeed(gameState.currentCard, gameState);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _buildSocialFeedDialog(context, socialFeed),
    );
    
    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator(color: Colors.redAccent)),
    );

    await rosterNotifier.decayRivalries();
    await rosterNotifier.processContracts(); 
    await ref.read(rivalProvider.notifier).runAIWeeklyLogic();
    await ref.read(newsProvider.notifier).generateWeeklyNews(completedCardToPass, rosterState.roster);
    
    await notifier.processWeek(rosterState.roster);
    
    final newWeek = ref.read(gameProvider).week;
    ref.read(communicationsProvider.notifier).generateWeeklyContent(newWeek);

    final updatedGameState = ref.read(gameProvider);

    if (context.mounted) {
      Navigator.pop(context); 

      if (updatedGameState.cash < 0) {
        await Navigator.pushAndRemoveUntil(
            context, 
            MaterialPageRoute(builder: (_) => const BankruptcyScreen()), 
            (route) => false 
        );
        return; 
      } 
      else if (isCareerFinale) {
        await Navigator.push(context, MaterialPageRoute(builder: (_) => const EndGameScreen()));
      } else if (isSeasonFinale) {
        await Navigator.push(context, MaterialPageRoute(builder: (_) => const SeasonRecapScreen()));
      } else {
        await Navigator.push(context, MaterialPageRoute(builder: (_) => PostShowRecapScreen(completedCard: completedCardToPass)));
      }

      if (mounted) {
        setState(() { _hasPassedPreShow = false; });
      }
    }
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
                  if (isBooked && bookedMatch.wrestlers.isNotEmpty)
                    Row(
                      children: [
                        ...bookedMatch.wrestlers.take(2).map((w) => Padding(padding: const EdgeInsets.only(right: 6.0), child: WrestlerAvatar(wrestler: w, radius: 12))),
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
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
            SizedBox(width: 10),
            Text("WARNING: REVENUE LOSS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
          ],
        ),
        content: Text(warningMessage, style: const TextStyle(color: Colors.white70, height: 1.5)),
        actions: [
          TextButton(child: const Text("GO FIX IT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), onPressed: () => Navigator.pop(ctx)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.withOpacity(0.2), foregroundColor: Colors.redAccent, elevation: 0),
            child: const Text("PROCEED ANYWAY", style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () { Navigator.pop(ctx); setState(() { _hasPassedPreShow = true; }); },
          ),
        ],
      ),
    );
  }

  Widget _buildExpertAvatarQuote(String imagePath, String name, String role, String quote, Color brandColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: Text('"$quote"', style: const TextStyle(color: Colors.white, fontStyle: FontStyle.italic, height: 1.5, fontSize: 13), textAlign: TextAlign.right),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: brandColor, width: 2), color: const Color(0xFF1E1E1E), boxShadow: [BoxShadow(color: brandColor.withOpacity(0.3), blurRadius: 10)]),
            child: ClipOval(
              child: Image.asset(imagePath, fit: BoxFit.cover, alignment: const Alignment(0.0, -0.6), errorBuilder: (c, e, s) => Center(child: Text(name[0], style: TextStyle(color: brandColor, fontWeight: FontWeight.w900, fontSize: 20)))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialFeedDialog(BuildContext context, List<String> feed) {
    return AlertDialog(
      backgroundColor: const Color(0xFF121212),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.white10)),
      title: const Row(children: [Icon(Icons.tag, color: Colors.blueAccent), SizedBox(width: 10), Text("SOCIAL FEED REACTION", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))]),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true, itemCount: feed.length,
          itemBuilder: (ctx, i) => Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white12)), child: Text(feed[i], style: const TextStyle(color: Colors.white70, height: 1.4))),
        ),
      ),
      actions: [SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 16)), onPressed: () => Navigator.pop(context), child: const Text("VIEW OFFICIAL RESULTS", style: TextStyle(fontWeight: FontWeight.bold))))]
    );
  }
}