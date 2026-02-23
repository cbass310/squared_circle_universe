import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/game_state_provider.dart';
import '../../../logic/promoter_provider.dart';
import '../../../logic/news_provider.dart';
import '../../../logic/rival_provider.dart';
import '../../../logic/sound_manager.dart'; 
import '../../../data/models/match.dart'; 
import 'roster_screen.dart';
import 'booking_screen.dart';
import 'development_screen.dart'; 
import 'office_screen.dart'; 
import 'news_screen.dart';
import 'report_screen.dart'; 
import 'season_recap_screen.dart'; 
import 'end_game_screen.dart'; 
import 'venue_screen.dart';       
import 'broadcasting_hub_screen.dart'; // <-- FIX: Imported the new Hub!
import 'sponsorship_screen.dart'; 

class PromoterDashboard extends ConsumerWidget {
  const PromoterDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final notifier = ref.read(gameProvider.notifier);
    final rosterState = ref.watch(rosterProvider);
    final rosterNotifier = ref.read(rosterProvider.notifier); 
    final newsState = ref.watch(newsProvider);

    // Venue & Event Info
    final venueInfo = gameState.currentVenueDetails; 
    int weeksUntilPPV = 4 - (gameState.week % 4);
    if (weeksUntilPPV == 4) weeksUntilPPV = 0;
    
    bool isSeasonFinale = gameState.week == 52;
    bool isCareerFinale = gameState.year == 3 && gameState.week == 52; 
    
    // Logic: Only allow running the show if 3 segments are booked
    bool isCardFull = gameState.currentCard.length >= 3;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text("${gameState.promotionName} DASHBOARD (Year ${gameState.year})", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. STATUS BAR (Cash & Fans)
            _buildStatusBar(gameState),
            const SizedBox(height: 20),

            // 2. VENUE HEADER
            _buildVenueHeader(context, gameState, venueInfo, weeksUntilPPV, notifier),
            const SizedBox(height: 20),

            // 3. BOOKING SLOTS
            const Text("TONIGHT'S CARD", style: TextStyle(color: Colors.grey, letterSpacing: 1.5, fontSize: 12)),
            const SizedBox(height: 10),
            
            _buildSegmentSlot(context, 1, "OPENER", gameState.currentCard.isNotEmpty ? gameState.currentCard[0] : null),
            _buildSegmentSlot(context, 2, "MID-CARD", gameState.currentCard.length > 1 ? gameState.currentCard[1] : null),
            _buildSegmentSlot(context, 3, "MAIN EVENT", gameState.currentCard.length > 2 ? gameState.currentCard[2] : null),

            const SizedBox(height: 20),

            // 4. RUN SHOW BUTTON (Hidden until card is full)
            if (isCardFull)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCareerFinale ? Colors.purpleAccent : (isSeasonFinale ? Colors.amber : Colors.green),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () async {
                    // A. Play Bell Sound
                    ref.read(soundProvider).playSound("bell.mp3");
                    
                    // B. Check for Random Event (Scenario Popup)
                    final event = rosterNotifier.checkForRandomEvent();
                    if (event != null && context.mounted) {
                      await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => AlertDialog(
                          backgroundColor: const Color(0xFF252525),
                          title: Row(children: [const Icon(Icons.warning, color: Colors.amber), const SizedBox(width: 10), Text(event.title, style: const TextStyle(color: Colors.white))]),
                          content: Text(event.description, style: const TextStyle(color: Colors.white70)),
                          actions: [
                            TextButton(onPressed: () { event.onOptionA(ref); Navigator.pop(context); }, child: Text(event.optionA)),
                            TextButton(onPressed: () { event.onOptionB(ref); Navigator.pop(context); }, child: Text(event.optionB)),
                          ],
                        )
                      );
                    }

                    if (context.mounted) {
                      // C. Run Rival AI (The Empire makes their moves)
                      await ref.read(rivalProvider.notifier).runAIWeeklyLogic();

                      // D. GENERATE NEWS (Pass matches AND roster before clearing)
                      await ref.read(newsProvider.notifier).generateWeeklyNews(gameState.currentCard, rosterState.roster);

                      // E. Process Week (Calculates finances, clears card, saves history)
                      await notifier.processWeek(rosterState.roster);
                      
                      // F. Navigate to appropriate screen
                      if (isCareerFinale) {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const EndGameScreen()));
                      } else if (isSeasonFinale) {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const SeasonRecapScreen()));
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportScreen()));
                      }
                    }
                  },
                  child: Text(isCareerFinale ? "RUN CAREER FINALE!" : (isSeasonFinale ? "RUN SEASON FINALE!" : "RUN SHOW & ADVANCE WEEK"), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              )
            else
              const Center(child: Text("Book all 3 segments to run the show.", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic))),

            const SizedBox(height: 30),

            // 5. MANAGEMENT GRID
            const Text("MANAGEMENT", style: TextStyle(color: Colors.grey, letterSpacing: 1.5, fontSize: 12)),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.5,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildActionCard(context, "ROSTER", Icons.groups, Colors.blue, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RosterScreen()))),
                
                // News Card with Notification Dot
                Stack(
                  fit: StackFit.expand, 
                  children: [
                    _buildActionCard(context, "NEWS", Icons.newspaper, Colors.purple, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewsScreen()))),
                    if (newsState.isNotEmpty) Positioned(right: 10, top: 10, child: Container(width: 12, height: 12, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle))),
                  ],
                ),
                
                _buildActionCard(context, "POWER PLANT", Icons.fitness_center, Colors.cyan, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DevelopmentScreen()))),
                
                _buildActionCard(context, "OFFICE", Icons.bar_chart, Colors.amber, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OfficeScreen()))),
                
                _buildActionCard(context, "VENUE", Icons.stadium, Colors.orange, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VenueScreen()))),
                
                // --- FIX: UPDATED THIS BUTTON TO ROUTE TO THE BROADCASTING HUB ---
                _buildActionCard(context, "BROADCASTING", Icons.cell_tower, Colors.teal, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BroadcastingHubScreen()))),
                
                _buildActionCard(context, "SPONSORS", Icons.monetization_on, Colors.green, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SponsorshipScreen()))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPERS ---

  String _getMatchTypeString(MatchType type) {
    switch (type) {
      case MatchType.standard: return "MATCH";
      case MatchType.promo: return "PROMO";
      case MatchType.ambush: return "AMBUSH";
      case MatchType.hardcore: return "HARDCORE";
      case MatchType.submission: return "SUBMISSION";
      case MatchType.ladder: return "LADDER";
      case MatchType.cage: return "CAGE";
      default: return "SEGMENT";
    }
  }

  Widget _buildSegmentSlot(BuildContext context, int index, String label, Match? match) { 
    bool isBooked = match != null;
    return GestureDetector(
      onTap: () {
        if (!isBooked) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => BookingScreen(segmentLabel: label)));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isBooked ? Colors.green : Colors.grey.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: isBooked ? Colors.green : Colors.grey[800], child: Text("$index", style: const TextStyle(color: Colors.white))),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  isBooked ? "${_getMatchTypeString(match.type)}: ${match.rating}⭐" : "Empty Slot",
                  style: TextStyle(color: isBooked ? Colors.white : Colors.white38, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                if (isBooked) Text("Winner: ${match.winnerName}", style: const TextStyle(color: Colors.amber, fontSize: 12)),
              ],
            ),
            const Spacer(),
            if (!isBooked) const Icon(Icons.add_circle_outline, color: Colors.blueAccent),
            if (isBooked) const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar(dynamic gameState) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("CASH ON HAND", style: TextStyle(color: Colors.grey, fontSize: 10)), Text("\$${gameState.cash}", style: const TextStyle(color: Colors.greenAccent, fontSize: 24, fontWeight: FontWeight.bold))]),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [const Text("FANBASE", style: TextStyle(color: Colors.grey, fontSize: 10)), Row(children: [const Icon(Icons.people, color: Colors.blueAccent, size: 16), Text("${gameState.fans}", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))])]),
        ],
      ),
    );
  }

  Widget _buildVenueHeader(BuildContext context, dynamic gameState, Map<String, dynamic> venueInfo, int weeksUntilPPV, dynamic notifier) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const VenueScreen()));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gameState.isPPV ? [Colors.amber.shade900.withOpacity(0.8), Colors.red.shade900.withOpacity(0.8)] : [Colors.purple.shade900.withOpacity(0.5), Colors.blue.shade900.withOpacity(0.5)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: gameState.isPPV ? Colors.amber : Colors.white24, width: gameState.isPPV ? 2 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(gameState.isPPV ? gameState.nextPPVName.toUpperCase() : "WEEK ${gameState.week} ${gameState.tvShowName}", style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                if (gameState.isPPV) const Icon(Icons.star, color: Colors.amber, size: 30)
            ]),
            const SizedBox(height: 5),
            Text("${venueInfo['name']} (${venueInfo['capacity']} Fans)", style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 10),
            if (!gameState.isPPV) Text("Building to: ${gameState.nextPPVName} (in $weeksUntilPPV weeks)", style: const TextStyle(color: Colors.amberAccent, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.3)), boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 5, offset: const Offset(0, 5))]),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 30, color: color), const SizedBox(height: 10), Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0))]),
      ),
    );
  }
}