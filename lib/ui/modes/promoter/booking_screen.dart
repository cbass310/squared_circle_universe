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
  String _selectedTitle = ""; // 🚨 THE FIX: Replaced _isTitleMatchToggled

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingProvider);
    final bookingNotifier = ref.read(bookingProvider.notifier);
    final rosterState = ref.watch(rosterProvider);
    final gameState = ref.watch(gameProvider); 

    // Auto-scrolling logic for the live ticker
    ref.listen(bookingProvider, (previous, next) {
      if (previous != null && next.liveLogs.length > previous.liveLogs.length) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });

    // Completely blocks anyone holding out from being booked on the card!
    final availableRoster = rosterState.roster.where((w) => !w.isOnIR && !w.isHoldingOut).toList();

    // THE FAILSAFE: Block the screen if the roster is completely depleted
    if (availableRoster.length < 2) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("CRITICAL WARNING", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5)),
          backgroundColor: const Color(0xFF121212),
          iconTheme: const IconThemeData(color: Colors.redAccent),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 80),
                const SizedBox(height: 24),
                const Text("ROSTER DEPLETED", style: TextStyle(color: Colors.redAccent, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
                const SizedBox(height: 16),
                const Text(
                  "You do not have enough active talent to book this match. You must have at least 2 healthy wrestlers who are not holding out. Go sign Free Agents, wait for injuries to heal, or pay your holdouts!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("RETURN TO OFFICE", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),
        ),
      );
    }

    if (selectedWrestler1Id != null && !availableRoster.any((w) => w.id == selectedWrestler1Id)) selectedWrestler1Id = null;
    if (selectedWrestler2Id != null && !availableRoster.any((w) => w.id == selectedWrestler2Id)) selectedWrestler2Id = null;

    // 🚨 SMART LAYOUT BUILDER 🚨
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 800;

        if (isDesktop) {
          // 💻 PC LAYOUT (Wide Side-by-Side)
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: Text(bookingState.isSimulating ? "LIVE BROADCAST" : "BOOKING: ${widget.segmentLabel.toUpperCase()}", style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, color: Colors.white)),
              backgroundColor: const Color(0xFF121212),
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.amber),
              bottom: PreferredSize(preferredSize: const Size.fromHeight(3), child: Container(color: Colors.black, height: 3)), 
            ),
            body: bookingState.isSimulating 
              ? _buildSimulationView(bookingState, bookingNotifier, true) 
              : Row(
                  children: [
                    Expanded(flex: 4, child: _buildLeftRosterPane(availableRoster)),
                    Expanded(flex: 6, child: _buildDesktopRightBookingPane(availableRoster, bookingState, bookingNotifier, gameState)),
                  ],
                ),
          );
        } else {
          // 📱 MOBILE LAYOUT (40/60 Vertical Split)
          return Scaffold(
            backgroundColor: Colors.black,
            body: bookingState.isSimulating
              ? _buildSimulationView(bookingState, bookingNotifier, false)
              : Column(
                  children: [
                    // TOP 40%: Cinematic Arena & Matchup Viewport
                    Expanded(
                      flex: 4,
                      child: _buildMobileMatchupViewport(availableRoster, gameState),
                    ),
                    // BOTTOM 60%: Roster & Control Desk
                    Expanded(
                      flex: 6,
                      child: Container(
                        color: Colors.black,
                        width: double.infinity,
                        child: _buildMobileControlDesk(availableRoster, bookingState, bookingNotifier),
                      ),
                    ),
                  ],
                ),
          );
        }
      }
    );
  }

  // =====================================================================
  // --- 📱 MOBILE SPECIFIC LAYOUTS
  // =====================================================================

  Widget _buildMobileMatchupViewport(List<Wrestler> roster, GameState gameState) {
    String venueBackground;
    switch (gameState.venueLevel) {
      case 4: venueBackground = "assets/images/venue_stadium.png"; break;
      case 3: venueBackground = "assets/images/venue_arena.png"; break;
      case 2: venueBackground = "assets/images/venue_civic.png"; break;
      case 1: 
      default: venueBackground = "assets/images/venue_gym.png"; 
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Opacity(
          opacity: 0.35, 
          child: Image.asset(venueBackground, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.black)),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.8), Colors.transparent, Colors.black.withOpacity(0.9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.4, 1.0],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
                    Text(widget.segmentLabel.toUpperCase(), style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 2.0)),
                    const SizedBox(width: 40), // Balance
                  ],
                ),
                const Spacer(),
                SizedBox(
                  height: 140, // Scaled down slightly for mobile
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildContenderSlot(1, selectedWrestler1Id, roster)),
                          const SizedBox(width: 10),
                          Expanded(child: _buildContenderSlot(2, selectedWrestler2Id, roster)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, border: Border.all(color: Colors.amber, width: 2), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.8), blurRadius: 10)]),
                        child: const Text("VS", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w900, fontSize: 14, fontStyle: FontStyle.italic)),
                      )
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileControlDesk(List<Wrestler> roster, BookingState state, BookingNotifier notifier) {
    bool canRunMatch = selectedWrestler1Id != null && selectedWrestler2Id != null;

    return Column(
      children: [
        // 1. HORIZONTAL ROSTER DRAFT BAR
        Container(
          height: 120,
          decoration: const BoxDecoration(
            color: Color(0xFF121212),
            border: Border(bottom: BorderSide(color: Colors.white10, width: 2)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                width: double.infinity,
                color: Colors.amber.withOpacity(0.1),
                child: Text("DRAFTING CONTENDER $_activeDraftSlot", textAlign: TextAlign.center, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1.5)),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: roster.length,
                  itemBuilder: (ctx, index) {
                    final w = roster[index];
                    int? otherId = _activeDraftSlot == 1 ? selectedWrestler2Id : selectedWrestler1Id;
                    if (w.id == otherId) return const SizedBox.shrink(); // Hide if already drafted in other slot

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
                        width: 80,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.amber.withOpacity(0.1) : const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: isSelected ? Colors.amber : Colors.transparent, width: 2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            WrestlerAvatar(wrestler: w, size: 40),
                            const SizedBox(height: 4),
                            Text(w.name, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: isSelected ? Colors.amber : Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // 2. SCROLLABLE AGENT SETTINGS
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (canRunMatch) _buildChemistryMeter(roster),
                if (canRunMatch) const SizedBox(height: 20),
                
                const Text("MATCH STIPULATION", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 2.0)),
                const SizedBox(height: 8),
                _buildDropdownContainer(
                  child: DropdownButton<MatchType>(
                    isExpanded: true, dropdownColor: const Color(0xFF1A1A1A), icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.amber),
                    value: state.selectedType,
                    items: MatchType.values.map((type) => DropdownMenuItem(value: type, child: Text(type.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12)))).toList(),
                    onChanged: (val) { if (val != null) { HapticFeedback.lightImpact(); notifier.setMatchType(val); } },
                  ),
                ),

                const SizedBox(height: 20),
                const Text("ROAD AGENT NOTES", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 2.0)),
                const SizedBox(height: 8),
                _buildDropdownContainer(
                  child: DropdownButton<AgentNote>(
                    isExpanded: true, dropdownColor: const Color(0xFF1A1A1A), icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.amber),
                    value: state.selectedNote,
                    items: [AgentNote.standard, AgentNote.cleanFinish, AgentNote.screwjob].map((note) {
                      String title = note == AgentNote.standard ? "Call It In The Ring" : note == AgentNote.cleanFinish ? "Clean Finish" : "Screwjob";
                      return DropdownMenuItem(value: note, child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12)));
                    }).toList(),
                    onChanged: (val) { if (val != null) { HapticFeedback.lightImpact(); notifier.setAgentNote(val); } },
                  ),
                ),
                
                const SizedBox(height: 20),
                _buildTitleToggle(roster),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),

        // 3. STATIC BOOKING BUTTON AT BOTTOM
        _buildSimulateButton(canRunMatch, roster, notifier),
      ],
    );
  }

  // =====================================================================
  // --- 💻 DESKTOP SPECIFIC LAYOUTS
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
                                    Text("${w.isHeel ? 'HEEL' : 'FACE'} • ${w.style.name.toUpperCase()}", style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
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

  Widget _buildDesktopRightBookingPane(List<Wrestler> roster, BookingState state, BookingNotifier notifier, GameState gameState) {
    bool canRunMatch = selectedWrestler1Id != null && selectedWrestler2Id != null;

    String venueBackground;
    switch (gameState.venueLevel) {
      case 4: venueBackground = "assets/images/venue_stadium.png"; break;
      case 3: venueBackground = "assets/images/venue_arena.png"; break;
      case 2: venueBackground = "assets/images/venue_civic.png"; break;
      case 1: 
      default: venueBackground = "assets/images/venue_gym.png"; 
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Opacity(
          opacity: 0.35, 
          child: Image.asset(venueBackground, fit: BoxFit.cover, alignment: Alignment.center, errorBuilder: (c, e, s) => Container(color: Colors.black)),
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
                            decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, border: Border.all(color: Colors.amber, width: 3), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.8), blurRadius: 15)]),
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
                    
                    _buildDropdownContainer(
                      child: DropdownButton<MatchType>(
                        isExpanded: true, 
                        dropdownColor: const Color(0xFF1A1A1A), 
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.amber, size: 30),
                        value: state.selectedType,
                        items: MatchType.values.map((type) {
                          return DropdownMenuItem(
                            value: type, 
                            child: Row(
                              children: [
                                const Icon(Icons.sports_kabaddi, color: Colors.white54, size: 20), 
                                const SizedBox(width: 16), 
                                Text(
                                  type.name.toUpperCase(), 
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.0)
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) { if (val != null) { HapticFeedback.lightImpact(); notifier.setMatchType(val); } },
                      ),
                    ),

                    const SizedBox(height: 30),
                    const Text("ROAD AGENT NOTES", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 2.0)),
                    const SizedBox(height: 12),

                    _buildDropdownContainer(
                      child: DropdownButton<AgentNote>(
                        isExpanded: true, 
                        itemHeight: 65, 
                        dropdownColor: const Color(0xFF1A1A1A), 
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.amber, size: 30),
                        value: state.selectedNote,
                        items: [AgentNote.standard, AgentNote.cleanFinish, AgentNote.screwjob].map((note) {
                          String title = note == AgentNote.standard ? "Call It In The Ring" : note == AgentNote.cleanFinish ? "Clean Finish (+Rating)" : "Screwjob / Interference (++Heat)";
                          String sub = note == AgentNote.standard ? "Standard psychology & risks." : note == AgentNote.cleanFinish ? "Decisive win. Loser loses momentum." : "Boosts rivalry heat, risks angering fans.";
                          return DropdownMenuItem(
                            value: note, 
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, 
                              mainAxisAlignment: MainAxisAlignment.center, 
                              children: [
                                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.0)), 
                                const SizedBox(height: 2), 
                                Text(sub, style: const TextStyle(color: Colors.white54, fontSize: 10)),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) { if (val != null) { HapticFeedback.lightImpact(); notifier.setAgentNote(val); } },
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildTitleToggle(roster),
                  ],
                ),
              ),
            ),
            _buildSimulateButton(canRunMatch, roster, notifier),
          ],
        ),
      ],
    );
  }

  // =====================================================================
  // --- 🧩 SHARED COMPONENTS
  // =====================================================================

  Widget _buildDropdownContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black, width: 2)),
      child: DropdownButtonHideUnderline(child: child),
    );
  }

  // 🚨 THE FIX: The new Vacant-Aware Title Dropdown!
  Widget _buildTitleToggle(List<Wrestler> roster) {
    if (selectedWrestler1Id == null || selectedWrestler2Id == null) return const SizedBox.shrink();

    Wrestler w1 = roster.firstWhere((w) => w.id == selectedWrestler1Id);
    Wrestler w2 = roster.firstWhere((w) => w.id == selectedWrestler2Id);

    // Check if belts are currently vacant across the entire active roster
    bool worldVacant = !roster.any((w) => w.isChampion && w.companyId == 0 && !w.isOnIR);
    bool tvVacant = !roster.any((w) => w.isTVChampion && w.companyId == 0 && !w.isOnIR);

    List<String> availableTitles = [""]; // Empty string = Non-Title Match

    // If vacant, OR if one of the booked wrestlers holds it, it can be put on the line!
    if (worldVacant || w1.isChampion || w2.isChampion) availableTitles.add("World Heavyweight");
    if (tvVacant || w1.isTVChampion || w2.isTVChampion) availableTitles.add("Television Title");

    if (availableTitles.length == 1) return const SizedBox.shrink(); 

    // Failsafe: Reset if they swap wrestlers and the selected belt is no longer valid
    if (!availableTitles.contains(_selectedTitle)) {
      _selectedTitle = "";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("CHAMPIONSHIP STAKES", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 2.0)),
        const SizedBox(height: 12),
        _buildDropdownContainer(
          child: DropdownButton<String>(
            isExpanded: true,
            dropdownColor: const Color(0xFF1A1A1A),
            icon: const Icon(Icons.emoji_events, color: Colors.amber, size: 30),
            value: _selectedTitle,
            items: availableTitles.map((title) {
              String label = title.isEmpty ? "Non-Title Match" : "$title Championship";
              return DropdownMenuItem(
                value: title,
                child: Text(label, style: TextStyle(color: title.isEmpty ? Colors.white54 : Colors.amber, fontWeight: FontWeight.w900)),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                HapticFeedback.lightImpact();
                setState(() => _selectedTitle = val);
              }
            },
          ),
        ),
      ],
    );
  }

  // 🚨 THE FIX: The Live Alignment Warning Widget!
  Widget _buildAlignmentWarning(List<Wrestler> roster) {
    if (selectedWrestler1Id == null || selectedWrestler2Id == null) return const SizedBox.shrink();

    Wrestler? w1 = roster.where((w) => w.id == selectedWrestler1Id).firstOrNull;
    Wrestler? w2 = roster.where((w) => w.id == selectedWrestler2Id).firstOrNull;

    if (w1 != null && w2 != null && w1.isHeel == w2.isHeel) {
      String matchType = w1.isHeel ? "Heel vs. Heel" : "Face vs. Face";
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "WARNING: $matchType matches lack crowd dynamics and will suffer a rating penalty.",
                style: const TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold, height: 1.3),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  // 🚨 Injecting the warning above the final simulate button
  Widget _buildSimulateButton(bool canRunMatch, List<Wrestler> roster, BookingNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.black, border: const Border(top: BorderSide(color: Colors.white10)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, -5))]),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Keep it from blowing up the layout
        children: [
          if (canRunMatch) _buildAlignmentWarning(roster), // 🚨 Warning Appears Here!
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: canRunMatch ? Colors.amber : const Color(0xFF1E1E1E), foregroundColor: canRunMatch ? Colors.black : Colors.white30, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              icon: Icon(canRunMatch ? Icons.sports_mma_rounded : Icons.lock),
              label: const Text("RING THE BELL", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              onPressed: canRunMatch ? () {
                HapticFeedback.heavyImpact();
                Wrestler w1 = roster.firstWhere((w) => w.id == selectedWrestler1Id);
                Wrestler w2 = roster.firstWhere((w) => w.id == selectedWrestler2Id);
                
                // 🚨 PASSED THE STRING TO THE BACKEND INSTEAD OF A BOOLEAN!
                ref.read(gameProvider.notifier).stageTitleMatch(_selectedTitle); 
                notifier.setTitleMatch(_selectedTitle);
                
                notifier.setWinner(null); 
                notifier.startMatchSimulation([w1, w2]); 
              } : null,
            ),
          ),
        ],
      ),
    );
  }

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
          border: Border.all(color: isActiveSlot ? Colors.amber : Colors.black, width: isActiveSlot ? 2 : 1),
          boxShadow: isActiveSlot ? [BoxShadow(color: Colors.amber.withOpacity(0.2), blurRadius: 10)] : [],
        ),
        child: isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_add_alt_1_rounded, color: isActiveSlot ? Colors.amber : Colors.white30, size: 30),
                    const SizedBox(height: 8),
                    Text(isActiveSlot ? "SELECT ROSTER" : "TAP TO DRAFT", style: TextStyle(color: isActiveSlot ? Colors.amber : Colors.white30, fontWeight: FontWeight.bold, fontSize: 9, letterSpacing: 1.0)),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WrestlerAvatar(wrestler: w!, size: 50), 
                  const SizedBox(height: 8),
                  Text(w.name.toUpperCase(), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text("${w.isHeel ? 'HEEL' : 'FACE'} • ${w.style.name.toUpperCase()}", style: const TextStyle(color: Colors.cyanAccent, fontSize: 9, fontWeight: FontWeight.w900)),
                ],
              ),
      ),
    );
  }

  Widget _buildChemistryMeter(List<Wrestler> roster) {
    if (selectedWrestler1Id == null || selectedWrestler2Id == null) return const SizedBox.shrink();
    
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black, width: 2)),
      child: Row(
        children: [
          Icon(chemIcon, color: chemColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("AGENT ANALYSIS", style: TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                Text(chemLabel, style: TextStyle(color: chemColor, fontWeight: FontWeight.w900, fontSize: 13)),
              ],
            ),
          ),
          Text("$chemistryScore%", style: TextStyle(color: chemColor, fontWeight: FontWeight.w900, fontSize: 20, fontFamily: "Monospace"))
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
          Expanded(flex: 6, child: _buildJumbotronColumn(state, notifier, isMobile: false)),
        ],
      );
    } else {
      return Column(
        children: [
          Expanded(flex: 4, child: _buildJumbotronColumn(state, notifier, isMobile: true)),
          Expanded(flex: 6, child: _buildTickerColumn(state)),
        ],
      );
    }
  }

  Widget _buildTickerColumn(BookingState state) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFF121212), border: Border(right: BorderSide(color: Colors.white10, width: 2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), border: const Border(bottom: BorderSide(color: Colors.amber, width: 2))),
            child: const Row(
              children: [
                Icon(Icons.mic_external_on, color: Colors.amber, size: 20),
                SizedBox(width: 8),
                Text("LIVE PLAY-BY-PLAY", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController, 
              padding: const EdgeInsets.all(20),
              itemCount: state.liveLogs.length,
              itemBuilder: (context, index) {
                final log = state.liveLogs[index];
                
                bool isVic = log.speaker.toUpperCase().contains("VIC");
                bool isCyrus = log.speaker.toUpperCase().contains("CYRUS");
                bool isDialogue = isVic || isCyrus;

                if (isDialogue) {
                  String avatarPath = isVic ? 'assets/images/vic.png' : 'assets/images/cyrus.png';
                  Color brandColor = isVic ? Colors.blueAccent : Colors.redAccent;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: brandColor, width: 2), color: const Color(0xFF1E1E1E)),
                          child: ClipOval(
                            child: Image.asset(avatarPath, fit: BoxFit.cover, alignment: const Alignment(0.0, -0.6), errorBuilder: (c, e, s) => Center(child: Text(isVic ? "V" : "C", style: TextStyle(color: brandColor, fontWeight: FontWeight.w900, fontSize: 20)))),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(log.speaker.toUpperCase(), style: TextStyle(color: brandColor, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.0)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1A1A1A), border: Border.all(color: Colors.white10),
                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                ),
                                child: Text(log.message, style: const TextStyle(color: Colors.white, height: 1.4, fontSize: 13)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  Color iconColor = Colors.white54;
                  IconData icon = Icons.info_outline;
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
                                TextSpan(text: "${log.speaker}: ", style: TextStyle(color: iconColor, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1.0)),
                                TextSpan(text: log.message, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4, fontStyle: FontStyle.italic)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJumbotronColumn(BookingState state, BookingNotifier notifier, {required bool isMobile}) {
    return Container(
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
              const Icon(Icons.videocam, color: Colors.redAccent, size: 30),
              const SizedBox(height: 8),
              Text(state.isFinished ? "FINAL MATCH RATING" : "LIVE BROADCAST", style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
              const SizedBox(height: 16),
              
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
                  return Icon(starIcon, color: Colors.amber, size: isMobile ? 32 : 50, shadows: [Shadow(color: Colors.amber.withOpacity(0.5), blurRadius: 10)]);
                }),
              ),
              const SizedBox(height: 8),
              Text("${state.currentMatchRating.toStringAsFixed(1)} STARS", style: TextStyle(color: Colors.white, fontSize: isMobile ? 24 : 40, fontWeight: FontWeight.w900)),
              
              const Spacer(),
              
              if (state.isFinished)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      icon: const Icon(Icons.check_circle),
                      label: const Text("RETURN TO CARD", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
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