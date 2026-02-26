import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/booking_provider.dart';
import '../../../logic/promoter_provider.dart';
import '../../../logic/game_state_provider.dart'; 
import '../../../data/models/match.dart';
import '../../../data/models/wrestler.dart';
import '../../components/wrestler_avatar.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final String segmentLabel; 

  const BookingScreen({super.key, required this.segmentLabel});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  int? selectedWrestler1Id;
  int? selectedWrestler2Id;
  
  int _activeDraftSlot = 1;
  
  // 🛠️ THE FIX: Player controls the Title Match toggle!
  bool _isTitleMatchToggled = false;

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingProvider);
    final bookingNotifier = ref.read(bookingProvider.notifier);
    final rosterState = ref.watch(rosterProvider);
    final gameState = ref.watch(gameProvider); 

    final availableRoster = rosterState.roster.where((w) => !w.isOnIR).toList();

    if (selectedWrestler1Id != null && !availableRoster.any((w) => w.id == selectedWrestler1Id)) selectedWrestler1Id = null;
    if (selectedWrestler2Id != null && !availableRoster.any((w) => w.id == selectedWrestler2Id)) selectedWrestler2Id = null;

    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(bookingState.isSimulating ? "LIVE BROADCAST" : "BOOKING: ${widget.segmentLabel.toUpperCase()}", style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, color: Colors.white)),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.amber),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(color: Colors.black, height: 3), 
        ),
      ),
      body: bookingState.isSimulating 
          ? _buildSimulationView(bookingState, bookingNotifier, isDesktop) 
          : isDesktop 
              ? Row(
                  children: [
                    Expanded(flex: 4, child: _buildLeftRosterPane(availableRoster)),
                    Expanded(flex: 6, child: _buildRightBookingPane(availableRoster, bookingState, bookingNotifier, gameState)),
                  ],
                )
              : Column(
                  children: [
                    Expanded(flex: 6, child: _buildRightBookingPane(availableRoster, bookingState, bookingNotifier, gameState)),
                    Expanded(flex: 4, child: _buildLeftRosterPane(availableRoster)),
                  ],
                )
    );
  }

  // =====================================================================
  // --- LEFT PANE: THE LOCKER ROOM
  // =====================================================================
  Widget _buildLeftRosterPane(List<Wrestler> roster) {
    int? otherId = _activeDraftSlot == 1 ? selectedWrestler2Id : selectedWrestler1Id;
    List<Wrestler> validRoster = roster.where((w) => w.id != otherId).toList();

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        border: Border(right: BorderSide(color: Colors.black, width: 3)), 
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), border: const Border(bottom: BorderSide(color: Colors.amber, width: 2))),
            child: Row(
              children: [
                const Icon(Icons.person_add_alt_1_rounded, color: Colors.amber, size: 20),
                const SizedBox(width: 8),
                Text("DRAFTING CONTENDER $_activeDraftSlot", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              ],
            ),
          ),
          Expanded(
            child: validRoster.isEmpty 
                ? const Center(child: Text("No healthy roster members available!", style: TextStyle(color: Colors.white54)))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: validRoster.length,
                    itemBuilder: (ctx, index) {
                      final w = validRoster[index];
                      bool isSelected = (_activeDraftSlot == 1 && selectedWrestler1Id == w.id) || (_activeDraftSlot == 2 && selectedWrestler2Id == w.id);

                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() {
                            if (_activeDraftSlot == 1) {
                              selectedWrestler1Id = w.id;
                              if (selectedWrestler2Id == null) _activeDraftSlot = 2;
                            } else {
                              selectedWrestler2Id = w.id;
                            }
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.amber.withOpacity(0.1) : const Color(0xFF1E1E1E), 
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isSelected ? Colors.amber : Colors.black, width: 2), 
                          ),
                          child: Row(
                            children: [
                              WrestlerAvatar(wrestler: w, size: 40), 
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(w.name.toUpperCase(), style: TextStyle(color: isSelected ? Colors.amber : Colors.white, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1.0)),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text("POP ${w.pop.toInt()}", style: const TextStyle(color: Colors.purpleAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                                        const Text(" • ", style: TextStyle(color: Colors.white54, fontSize: 10)),
                                        Text("STA ${w.stamina.toInt()}%", style: TextStyle(color: w.stamina < 40 ? Colors.redAccent : Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Icon(isSelected ? Icons.check_circle : Icons.add_circle_outline, color: isSelected ? Colors.amber : Colors.white24)
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // --- RIGHT PANE: THE MATCHUP GRAPHIC
  // =====================================================================
  Widget _buildRightBookingPane(List<Wrestler> roster, BookingState state, BookingNotifier notifier, GameState gameState) {
    bool canRunMatch = selectedWrestler1Id != null && selectedWrestler2Id != null;

    bool hasChampion = false;
    if (canRunMatch) {
      Wrestler w1 = roster.firstWhere((w) => w.id == selectedWrestler1Id);
      Wrestler w2 = roster.firstWhere((w) => w.id == selectedWrestler2Id);
      if (w1.isChampion || w1.isTVChampion || w2.isChampion || w2.isTVChampion) {
        hasChampion = true;
      }
    }

    String venueBackground;
    switch (gameState.venueLevel) {
      case 4: venueBackground = "assets/images/venue_stadium.png"; break;
      case 3: venueBackground = "assets/images/venue_arena.png"; break;
      case 2: venueBackground = "assets/images/venue_civic.png"; break;
      case 1: 
      default: venueBackground = "assets/images/venue_gym.png"; 
    }

    final agentNotesList = [AgentNote.standard, AgentNote.cleanFinish, AgentNote.screwjob];

    return Stack(
      fit: StackFit.expand,
      children: [
        Opacity(
          opacity: 0.35, 
          child: Image.asset(
            venueBackground,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (c, e, s) => Container(color: Colors.black), 
          ),
        ),
        
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.6), Colors.transparent, Colors.black.withOpacity(0.8)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.4, 1.0],
            ),
          ),
        ),

        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("TALE OF THE TAPE", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 2.0)),
                    const SizedBox(height: 20),
                    
                    SizedBox(
                      height: 180,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildContenderSlot(1, selectedWrestler1Id, roster)),
                              const SizedBox(width: 20),
                              Expanded(child: _buildContenderSlot(2, selectedWrestler2Id, roster)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.amber, width: 3),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.8), blurRadius: 15)],
                            ),
                            child: const Text("VS", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w900, fontSize: 20, fontStyle: FontStyle.italic)),
                          )
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 30),

                    if (canRunMatch) _buildChemistryMeter(roster),

                    const SizedBox(height: 30),
                    const Text("MATCH STIPULATION", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 2.0)),
                    const SizedBox(height: 12),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E), 
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<MatchType>(
                          isExpanded: true,
                          dropdownColor: const Color(0xFF1A1A1A),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.amber, size: 30),
                          value: state.selectedType,
                          items: MatchType.values.map((type) {
                            return DropdownMenuItem<MatchType>(
                              value: type,
                              child: Row(
                                children: [
                                  const Icon(Icons.sports_kabaddi, color: Colors.white54, size: 20),
                                  const SizedBox(width: 16),
                                  Text(type.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (MatchType? newType) {
                            if (newType != null) {
                              HapticFeedback.lightImpact();
                              notifier.setMatchType(newType);
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    const Text("ROAD AGENT NOTES (THE FINISH)", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 2.0)),
                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E), 
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<AgentNote>(
                          isExpanded: true,
                          itemHeight: 65, 
                          dropdownColor: const Color(0xFF1A1A1A),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.amber, size: 30),
                          value: state.selectedNote,
                          items: agentNotesList.map((note) {
                            String title = "";
                            String subtitle = "";
                            if (note == AgentNote.standard) { title = "Call It In The Ring"; subtitle = "Standard psychology & risks."; }
                            else if (note == AgentNote.cleanFinish) { title = "Clean Finish (+Rating)"; subtitle = "Decisive win. Loser loses momentum."; }
                            else if (note == AgentNote.screwjob) { title = "Screwjob / Interference (++Heat)"; subtitle = "Boosts rivalry heat, risks angering fans."; }

                            return DropdownMenuItem<AgentNote>(
                              value: note,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                                  const SizedBox(height: 2),
                                  Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 10)),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (AgentNote? newNote) {
                            if (newNote != null) {
                              HapticFeedback.lightImpact();
                              notifier.setAgentNote(newNote);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // 🛠️ THE FIX: DYNAMIC TITLE TOGGLE SWITCH
                    if (hasChampion)
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _isTitleMatchToggled ? Colors.amber : Colors.black, width: 2),
                        ),
                        child: SwitchListTile(
                          activeColor: Colors.black,
                          activeTrackColor: Colors.amber,
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.black45,
                          title: Text("PUT CHAMPIONSHIP ON THE LINE", style: TextStyle(color: _isTitleMatchToggled ? Colors.amber : Colors.white54, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                          value: _isTitleMatchToggled,
                          onChanged: (val) {
                            HapticFeedback.selectionClick();
                            setState(() => _isTitleMatchToggled = val);
                          },
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // 🛠️ DYNAMIC TITLE MATCH BANNER 🏆
            if (hasChampion && _isTitleMatchToggled)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.amber.shade700, Colors.orangeAccent.shade400]),
                  boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, -3))]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.workspace_premium, color: Colors.black, size: 24),
                    SizedBox(width: 10),
                    Text("CHAMPIONSHIP ON THE LINE!", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 2.0)),
                    SizedBox(width: 10),
                    Icon(Icons.workspace_premium, color: Colors.black, size: 24),
                  ],
                ),
              ),

            // --- THE MASSIVE SIMULATE BUTTON ---
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.black, border: const Border(top: BorderSide(color: Colors.black, width: 3)), boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -10))]),
              child: SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canRunMatch ? Colors.amber : const Color(0xFF1E1E1E), 
                    foregroundColor: canRunMatch ? Colors.black : Colors.white30,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                  ),
                  icon: Icon(canRunMatch ? Icons.sports_mma_rounded : Icons.lock),
                  label: const Text("RING THE BELL", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                  onPressed: canRunMatch ? () {
                    HapticFeedback.heavyImpact();
                    Wrestler w1 = roster.firstWhere((w) => w.id == selectedWrestler1Id);
                    Wrestler w2 = roster.firstWhere((w) => w.id == selectedWrestler2Id);
                    
                    // 🛠️ Hand the toggle over to the game engine silently!
                    ref.read(gameProvider.notifier).stageTitleMatch(hasChampion && _isTitleMatchToggled);
                    
                    notifier.setWinner(null); 
                    notifier.startMatchSimulation([w1, w2]); 
                  } : null,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ----------------------------------------------------------------
  // WIDGET: THE MATCHUP CONTENDER CARD 
  // ----------------------------------------------------------------
  Widget _buildContenderSlot(int slot, int? currentId, List<Wrestler> roster) {
    bool isEmpty = currentId == null;
    bool isActiveSlot = _activeDraftSlot == slot;
    Wrestler? w = !isEmpty ? roster.firstWhere((wrestler) => wrestler.id == currentId) : null;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _activeDraftSlot = slot);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isEmpty ? (isActiveSlot ? Colors.amber.withOpacity(0.05) : Colors.transparent) : const Color(0xFF1E1E1E), 
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isActiveSlot ? Colors.amber : Colors.black, width: isActiveSlot ? 3 : 2),
          boxShadow: isActiveSlot ? [BoxShadow(color: Colors.amber.withOpacity(0.2), blurRadius: 10)] : [],
        ),
        child: isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_add_alt_1_rounded, color: isActiveSlot ? Colors.amber : Colors.white30, size: 40),
                    const SizedBox(height: 8),
                    Text(isActiveSlot ? "SELECT FROM ROSTER" : "TAP TO DRAFT", style: TextStyle(color: isActiveSlot ? Colors.amber : Colors.white30, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1.0)),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WrestlerAvatar(wrestler: w!, size: 70),
                  const SizedBox(height: 12),
                  Text(w.name.toUpperCase(), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)),
                    child: Text("POP ${w.pop.toInt()}", style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
      ),
    );
  }

  // ----------------------------------------------------------------
  // WIDGET: THE CHEMISTRY METER
  // ----------------------------------------------------------------
  Widget _buildChemistryMeter(List<Wrestler> roster) {
    Wrestler w1 = roster.firstWhere((w) => w.id == selectedWrestler1Id);
    Wrestler w2 = roster.firstWhere((w) => w.id == selectedWrestler2Id);
    
    int chemistryScore = 50; 
    String chemLabel = "AVERAGE FIT";
    Color chemColor = Colors.amber;
    IconData chemIcon = Icons.sentiment_neutral;

    if (w1.isHeel != w2.isHeel) chemistryScore += 20;

    if (w1.style == w2.style) chemistryScore -= 10; 
    if (w1.style == WrestlingStyle.highFlyer && w2.style == WrestlingStyle.giant) chemistryScore += 30; 
    if (w1.style == WrestlingStyle.technician && w2.style == WrestlingStyle.technician) chemistryScore += 25; 

    if (chemistryScore >= 75) { chemLabel = "EXCELLENT CHEMISTRY"; chemColor = Colors.greenAccent; chemIcon = Icons.local_fire_department; }
    else if (chemistryScore <= 40) { chemLabel = "POOR STYLE CLASH"; chemColor = Colors.redAccent; chemIcon = Icons.warning_amber_rounded; }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), 
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Row(
        children: [
          Icon(chemIcon, color: chemColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("AGENT ANALYSIS", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                Text(chemLabel, style: TextStyle(color: chemColor, fontWeight: FontWeight.w900, fontSize: 16)),
              ],
            ),
          ),
          Text("${chemistryScore}%", style: TextStyle(color: chemColor, fontWeight: FontWeight.w900, fontSize: 24, fontFamily: "Monospace"))
        ],
      ),
    );
  }

  // =====================================================================
  // --- VIEW 2: THE LIVE SIMULATION VIEW ---
  // =====================================================================
  Widget _buildSimulationView(BookingState state, BookingNotifier notifier, bool isDesktop) {
    if (isDesktop) {
      return Row(
        children: [
          Expanded(flex: 4, child: _buildTickerColumn(state)),
          Expanded(flex: 6, child: _buildJumbotronColumn(state, notifier)),
        ],
      );
    } else {
      return Column(
        children: [
          _buildJumbotronColumn(state, notifier, isMobile: true),
          Expanded(child: _buildTickerColumn(state)),
        ],
      );
    }
  }

  Widget _buildTickerColumn(BookingState state) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        border: Border(right: BorderSide(color: Colors.black, width: 3)), 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), border: const Border(bottom: BorderSide(color: Colors.amber, width: 2))),
            child: Row(
              children: const [
                Icon(Icons.mic_external_on, color: Colors.amber, size: 20),
                SizedBox(width: 8),
                Text("LIVE PLAY-BY-PLAY", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: state.liveLogs.length,
              itemBuilder: (context, index) {
                final log = state.liveLogs[index];
                Color iconColor = Colors.white54;
                IconData icon = Icons.mic;
                
                if (log.type == "INFO") { iconColor = Colors.white70; icon = Icons.info_outline; }
                if (log.type == "FINISH") { iconColor = Colors.greenAccent; icon = Icons.sports_score; }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(icon, color: iconColor, size: 18),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: "${log.speaker}: ", style: TextStyle(color: iconColor, fontWeight: FontWeight.bold, fontSize: 14)),
                              TextSpan(text: log.message, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJumbotronColumn(BookingState state, BookingNotifier notifier, {bool isMobile = false}) {
    return Container(
      height: isMobile ? 300 : null,
      decoration: const BoxDecoration(color: Colors.black),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.35,
            child: Image.asset(
              "assets/images/commentary_booth.png", 
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Image.asset("assets/images/crowd_background.png", fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.black)),
            ),
          ),
          
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.8), Colors.transparent, Colors.black.withOpacity(0.95)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Icon(Icons.videocam, color: Colors.redAccent, size: 40),
              const SizedBox(height: 12),
              Text(state.isFinished ? "FINAL MATCH RATING" : "LIVE BROADCAST RATING", style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
              const SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  IconData starIcon;
                  if (index < state.currentMatchRating.floor()) {
                    starIcon = Icons.star;
                  } else if (index < state.currentMatchRating) {
                    starIcon = Icons.star_half;
                  } else {
                    starIcon = Icons.star_border;
                  }
                  return Icon(starIcon, color: Colors.amber, size: isMobile ? 40 : 60, shadows: [Shadow(color: Colors.amber.withOpacity(0.5), blurRadius: 15)]);
                }),
              ),
              const SizedBox(height: 12),
              Text("${state.currentMatchRating.toStringAsFixed(1)} STARS", style: TextStyle(color: Colors.white, fontSize: isMobile ? 32 : 48, fontWeight: FontWeight.w900)),
              
              const Spacer(),
              
              if (state.isFinished)
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 65,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      icon: const Icon(Icons.check_circle),
                      label: const Text("RETURN TO CARD", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        notifier.reset();
                        Navigator.pop(context); 
                      },
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}