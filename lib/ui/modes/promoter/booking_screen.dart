import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/booking_provider.dart';
import '../../../logic/promoter_provider.dart';
import '../../../data/models/match.dart';
import '../../../data/models/wrestler.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final String segmentLabel; 

  const BookingScreen({super.key, required this.segmentLabel});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  // FIX: We now store the ID integers instead of the full objects to prevent memory crashes!
  int? selectedWrestler1Id;
  int? selectedWrestler2Id;

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingProvider);
    final bookingNotifier = ref.read(bookingProvider.notifier);
    final rosterState = ref.watch(rosterProvider);

    // Filter to only show active, healthy wrestlers
    final availableRoster = rosterState.roster.where((w) => !w.isOnIR).toList();

    // SAFETY CHECK: If a selected ID is somehow no longer in the roster, clear it
    if (selectedWrestler1Id != null && !availableRoster.any((w) => w.id == selectedWrestler1Id)) {
      selectedWrestler1Id = null;
    }
    if (selectedWrestler2Id != null && !availableRoster.any((w) => w.id == selectedWrestler2Id)) {
      selectedWrestler2Id = null;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text("BOOKING: ${widget.segmentLabel.toUpperCase()}", style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: bookingState.isSimulating 
          ? _buildSimulationView(bookingState, bookingNotifier) 
          : _buildSetupView(availableRoster, bookingState, bookingNotifier),
    );
  }

  // =====================================================================
  // --- VIEW 1: THE MATCH SETUP SCREEN ---
  // =====================================================================
  Widget _buildSetupView(List<Wrestler> roster, BookingState state, BookingNotifier notifier) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("SELECT PARTICIPANTS", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 10),
          
          // WRESTLER 1 DROPDOWN
          _buildRosterDropdown(
            hint: "Select Wrestler 1",
            value: selectedWrestler1Id,
            roster: roster,
            onChanged: (id) => setState(() => selectedWrestler1Id = id),
          ),
          const SizedBox(height: 10),
          const Center(child: Text("VS", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16))),
          const SizedBox(height: 10),
          
          // WRESTLER 2 DROPDOWN
          _buildRosterDropdown(
            hint: "Select Wrestler 2",
            value: selectedWrestler2Id,
            roster: roster,
            onChanged: (id) => setState(() => selectedWrestler2Id = id),
          ),
          
          const SizedBox(height: 30),
          const Text("MATCH SETTINGS", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 10),

          // MATCH TYPE DROPDOWN
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white10)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<MatchType>(
                dropdownColor: const Color(0xFF1E1E1E),
                isExpanded: true,
                value: state.selectedType,
                style: const TextStyle(color: Colors.white),
                items: MatchType.values.map((type) => DropdownMenuItem(value: type, child: Text(type.name.toUpperCase()))).toList(),
                onChanged: (val) { if (val != null) notifier.setMatchType(val); },
              ),
            ),
          ),
          
          const SizedBox(height: 15),

          // AGENT NOTES DROPDOWN
          const Text("AGENT NOTES (FINISH)", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 10)),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.blueAccent)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<AgentNote>(
                dropdownColor: const Color(0xFF1E1E1E),
                isExpanded: true,
                value: state.selectedNote,
                style: const TextStyle(color: Colors.white),
                items: const [
                  DropdownMenuItem(value: AgentNote.standard, child: Text("Call It In The Ring (Standard)")),
                  DropdownMenuItem(value: AgentNote.cleanFinish, child: Text("Clean Finish (+Rating, -Loser Momentum)")),
                  DropdownMenuItem(value: AgentNote.screwjob, child: Text("Screwjob / Interference (-Rating, ++Heat)")),
                ],
                onChanged: (val) { if (val != null) notifier.setAgentNote(val); },
              ),
            ),
          ),

          const SizedBox(height: 30),

          // SIMULATE BUTTON
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              onPressed: () {
                        HapticFeedback.selectionClick();
                if (selectedWrestler1Id != null && selectedWrestler2Id != null && selectedWrestler1Id != selectedWrestler2Id) {
                  
                  // Rebuild the Wrestler objects from the selected IDs right before simulating!
                  Wrestler w1 = roster.firstWhere((w) => w.id == selectedWrestler1Id);
                  Wrestler w2 = roster.firstWhere((w) => w.id == selectedWrestler2Id);

                  notifier.setWinner(null); // Letting the engine decide based on momentum
                  notifier.startMatchSimulation([w1, w2]);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select two different wrestlers!"), backgroundColor: Colors.red));
                }
              },
              child: const Text("RUN MATCH", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            ),
          )
        ],
      ),
    );
  }

  // FIX: Added the null-safety fallback for wrestlers without images yet!
  Widget _buildRosterDropdown({required String hint, required int? value, required List<Wrestler> roster, required ValueChanged<int?> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          hint: Text(hint, style: const TextStyle(color: Colors.grey)),
          dropdownColor: const Color(0xFF1E1E1E),
          isExpanded: true,
          value: value,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          items: roster.map((w) => DropdownMenuItem(
            value: w.id, 
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: _getStyleColor(w.style),
                  // Render the image if we have one...
                  backgroundImage: w.imagePath != null ? AssetImage(w.imagePath!) : null,
                  // ...Otherwise just show a standard icon as a fallback!
                  child: w.imagePath == null ? const Icon(Icons.person, color: Colors.white, size: 20) : null,
                ),
                const SizedBox(width: 12),
                Text("${w.name} (Pop: ${w.pop})", style: const TextStyle(color: Colors.white)),
              ],
            )
          )).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // Helper to color-code rings around avatars based on style
  Color _getStyleColor(WrestlingStyle style) {
      switch (style) {
          case WrestlingStyle.powerhouse: return Colors.redAccent;
          case WrestlingStyle.highFlyer: return Colors.cyanAccent;
          case WrestlingStyle.technician: return Colors.blueAccent;
          case WrestlingStyle.brawler: return Colors.orangeAccent;
          case WrestlingStyle.entertainer: return Colors.purpleAccent;
          case WrestlingStyle.hardcore: return Colors.brown;
          case WrestlingStyle.luchador: return Colors.greenAccent;
          case WrestlingStyle.giant: return Colors.grey;
          default: return Colors.white10;
      }
  }

  // =====================================================================
  // --- VIEW 2: THE LIVE SIMULATION VIEW ---
  // =====================================================================
  Widget _buildSimulationView(BookingState state, BookingNotifier notifier) {
    return Column(
      children: [
        // THE JUMBOTRON (Live Match Rating)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E1E),
            border: Border(bottom: BorderSide(color: Colors.amber, width: 3)),
          ),
          child: Column(
            children: [
              const Text("LIVE MATCH RATING", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Icon(
                    index < state.currentMatchRating.floor() ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 40,
                  );
                }),
              ),
              const SizedBox(height: 5),
              Text("${state.currentMatchRating.toStringAsFixed(1)} STARS", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ),

        // THE COMMENTARY LOG
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.liveLogs.length,
            itemBuilder: (context, index) {
              final log = state.liveLogs[index];
              Color textColor = Colors.white70;
              if (log.type == "INFO") textColor = Colors.blueAccent;
              if (log.type == "FINISH") textColor = Colors.greenAccent;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("[${log.speaker}]", style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    Expanded(child: Text(log.message, style: TextStyle(color: textColor, fontSize: 14))),
                  ],
                ),
              );
            },
          ),
        ),

        // FINISH BUTTON
        if (state.isFinished)
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: const EdgeInsets.symmetric(vertical: 16)),
              onPressed: () {
                        HapticFeedback.selectionClick();
                notifier.reset();
                Navigator.pop(context); 
              },
              child: const Text("RETURN TO CARD", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          )
      ],
    );
  }
}