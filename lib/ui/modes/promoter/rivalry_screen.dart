import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/game_state_provider.dart';
import '../../../logic/promoter_provider.dart';
import '../../../data/models/wrestler.dart';
import '../../components/wrestler_avatar.dart';

class RivalryScreen extends ConsumerWidget {
  const RivalryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final rosterState = ref.watch(rosterProvider);

    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return DefaultTabController(
      length: 3, // 3 Tabs: Rivalries, History, Assistant GM
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: isDesktop
              ? Row(
                  children: [
                    // LEFT COLUMN: Creative Dashboard (40%)
                    Expanded(flex: 4, child: _buildLeftDashboard(context, gameState, rosterState, isDesktop)),
                    // RIGHT COLUMN: Gorilla Position Artwork (60%)
                    Expanded(flex: 6, child: _buildRightArtworkPane(gameState)),
                  ],
                )
              : Column(
                  children: [
                    _buildMobileHeader(context),
                    Expanded(flex: 5, child: _buildRightArtworkPane(gameState, isMobile: true)),
                    Expanded(flex: 6, child: _buildLeftDashboard(context, gameState, rosterState, isDesktop)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildMobileHeader(BuildContext context) {
    return Container(
      color: const Color(0xFF121212),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.amber, size: 20), onPressed: () => Navigator.pop(context)),
          const SizedBox(width: 8),
          const Text("CREATIVE HUB", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        ],
      ),
    );
  }

  // =====================================================================
  // --- LEFT PANE: THE 3-TAB CREATIVE DASHBOARD
  // =====================================================================
  Widget _buildLeftDashboard(BuildContext context, dynamic gameState, dynamic rosterState, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        border: isDesktop ? const Border(right: BorderSide(color: Colors.white10, width: 2)) : const Border(top: BorderSide(color: Colors.white10, width: 2)),
      ),
      child: Column(
        children: [
          // HEADER (Desktop only, mobile has it stacked above)
          if (isDesktop)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.amber, size: 20), onPressed: () => Navigator.pop(context)),
                  const SizedBox(width: 8),
                  const Text("CREATIVE HUB", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                ],
              ),
            ),
          
          // 🛠️ THE TAB BAR
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white10, width: 2)),
              color: Colors.black,
            ),
            child: const TabBar(
              indicatorColor: Colors.amber,
              indicatorWeight: 3,
              labelColor: Colors.amber,
              unselectedLabelColor: Colors.white54,
              labelStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.0),
              tabs: [
                Tab(text: "RIVALRIES"),
                Tab(text: "HISTORY"),
                Tab(text: "ASSISTANT GM"),
              ],
            ),
          ),

          // 🛠️ THE TAB CONTENT
          Expanded(
            child: TabBarView(
              children: [
                _buildRivalriesTab(rosterState),
                _buildHistoryTab(gameState),
                _buildAssistantGMTab(rosterState),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // TAB 1: RIVALRIES (The Whiteboard)
  // ---------------------------------------------------------------------
  Widget _buildRivalriesTab(dynamic rosterState) {
    if (rosterState.activeRivalries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.people_outline, size: 60, color: Colors.white24),
            SizedBox(height: 16),
            Text("THE WHITEBOARD IS EMPTY", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            SizedBox(height: 8),
            Text("Book matches between talent to spark feuds.", style: TextStyle(color: Colors.white30, fontSize: 12)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rosterState.activeRivalries.length,
      itemBuilder: (context, index) {
        final feud = rosterState.activeRivalries[index];
        return _buildFeudCard(feud);
      },
    );
  }

  Widget _buildFeudCard(dynamic feud) {
    final w1 = feud.wrestlerA;
    final w2 = feud.wrestlerB;

    Color heatColor = Colors.blue;
    String status = "Cold";
    IconData statusIcon = Icons.ac_unit;

    if (feud.heat > 30) { heatColor = Colors.orange; status = "Heating Up"; statusIcon = Icons.whatshot; }
    if (feud.heat > 60) { heatColor = Colors.redAccent; status = "Red Hot"; statusIcon = Icons.local_fire_department; }
    if (feud.heat > 90) { heatColor = Colors.purpleAccent; status = "LEGENDARY"; statusIcon = Icons.flash_on; }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: heatColor.withOpacity(0.5), width: 2),
        boxShadow: [BoxShadow(color: heatColor.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text("VS", style: TextStyle(fontSize: 60, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, color: Colors.white.withOpacity(0.05))),
            )
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WrestlerAvatar(wrestler: w1, size: 60),
                      const SizedBox(height: 8),
                      Text(w1.name.toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                    ],
                  ),
                ),
                Container(
                  width: 90,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: const BoxDecoration(
                    border: Border.symmetric(vertical: BorderSide(color: Colors.white10)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(statusIcon, color: heatColor, size: 24),
                      const SizedBox(height: 4),
                      Text("${feud.heat}", style: TextStyle(color: heatColor, fontSize: 24, fontWeight: FontWeight.w900)),
                      Text(status.toUpperCase(), style: TextStyle(color: heatColor, fontSize: 9, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(4)),
                        child: Text("WK ${feud.durationWeeks}", style: const TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.bold))
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WrestlerAvatar(wrestler: w2, size: 60),
                      const SizedBox(height: 8),
                      Text(w2.name.toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
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

  // ---------------------------------------------------------------------
  // TAB 2: HISTORY LOG (The Archive)
  // ---------------------------------------------------------------------
  Widget _buildHistoryTab(dynamic gameState) {
    // Grab the last 4 shows from the ledger
    final history = gameState.ledger.take(4).toList();

    if (history.isEmpty) {
      return const Center(child: Text("No booking history available.", style: TextStyle(color: Colors.white54)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final entry = history[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white12),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              iconColor: Colors.amber,
              collapsedIconColor: Colors.white54,
              title: Row(
                children: [
                  const Icon(Icons.live_tv, color: Colors.white54, size: 18),
                  const SizedBox(width: 10),
                  Text("WEEK ${entry.week}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  const Spacer(),
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 4),
                  Text("${entry.showRating}", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.w900, fontSize: 14)),
                ],
              ),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    border: Border(top: BorderSide(color: Colors.white10))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("SHOW ARCHIVE DATA", style: TextStyle(color: Colors.white30, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                      const SizedBox(height: 12),
                      // 🛠️ UI Shell: This is ready for real match data when your backend saves card arrays to the ledger!
                      _buildArchivedMatchRow("Opener", "Segment Data Locked in Archives"),
                      _buildArchivedMatchRow("Mid-Card", "Segment Data Locked in Archives"),
                      _buildArchivedMatchRow("Main Event", "Segment Data Locked in Archives"),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildArchivedMatchRow(String slot, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70, 
            child: Text(slot.toUpperCase(), style: const TextStyle(color: Colors.amber, fontSize: 9, fontWeight: FontWeight.bold))
          ),
          Expanded(
            child: Text(description, style: const TextStyle(color: Colors.white70, fontSize: 11, fontStyle: FontStyle.italic)),
          )
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // TAB 3: ASSISTANT GM (PPV Build Suggestions)
  // ---------------------------------------------------------------------
  Widget _buildAssistantGMTab(dynamic rosterState) {
    // 🛠️ Logic Shell: Grab the top feud if it exists to suggest as a main event
    dynamic topFeud;
    if (rosterState.activeRivalries.isNotEmpty) {
      // Sort to find hottest feud
      final sortedFeuds = List.from(rosterState.activeRivalries)..sort((a, b) => b.heat.compareTo(a.heat));
      topFeud = sortedFeuds.first;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.5)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.smart_toy, color: Colors.blueAccent, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("ASSISTANT GM PROJECTION", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                      SizedBox(height: 4),
                      Text("Based on active heat and roster usage, here is the mathematically optimal PPV card.", style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // THE DRAFT BOARD
          _buildDraftBoardSlot(
            slotName: "MAIN EVENT", 
            logicReason: "Climax of hottest active rivalry.",
            matchText: topFeud != null ? "${topFeud.wrestlerA.name} vs ${topFeud.wrestlerB.name}" : "N/A - Start a Feud First!",
            color: Colors.amber,
          ),
          _buildDraftBoardSlot(
            slotName: "COOLDOWN (SQUASH)", 
            logicReason: "Palate cleanser before Main Event.",
            matchText: "Monster Heel vs Local Jobber",
            color: Colors.purpleAccent,
          ),
          _buildDraftBoardSlot(
            slotName: "MID-CARD SHOWCASE", 
            logicReason: "Secondary Title Defense.",
            matchText: "Mid-Card Champion vs #1 Contender",
            color: Colors.greenAccent,
          ),
          _buildDraftBoardSlot(
            slotName: "HOT OPENER", 
            logicReason: "Fast-paced match to pop the crowd.",
            matchText: "High Flyer vs Cruiserweight",
            color: Colors.redAccent,
          ),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check_circle, color: Colors.black),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber, 
                foregroundColor: Colors.black, 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
              ),
              label: const Text("ACCEPT SUGGESTION & BOOK", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0)),
              onPressed: () {
                HapticFeedback.selectionClick();
                // 🚀 Future Backend Hook: Pre-load the currentCard array with these suggestions!
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDraftBoardSlot({required String slotName, required String logicReason, required String matchText, required Color color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: const Border(left: BorderSide(color: Colors.white10, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(slotName, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              Icon(Icons.auto_awesome, color: Colors.white24, size: 14),
            ],
          ),
          const SizedBox(height: 8),
          Text(matchText, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(logicReason, style: const TextStyle(color: Colors.white54, fontSize: 10, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  // =====================================================================
  // --- RIGHT PANE: GORILLA POSITION ARTWORK
  // =====================================================================
  Widget _buildRightArtworkPane(dynamic gameState, {bool isMobile = false}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. IMMERSIVE GORILLA POSITION ARTWORK
        Image.asset(
          "assets/images/gorilla_position.png", // 🚀 Create this moody backstage asset!
          fit: BoxFit.cover,
          alignment: Alignment.centerRight,
          errorBuilder: (c, e, s) => Image.asset("assets/images/crowd_background.png", fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(color: const Color(0xFF0A0A0A))),
        ),

        // 2. MOODY VIGNETTE OVERLAY
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.black.withOpacity(0.95), Colors.black.withOpacity(0.4), Colors.black.withOpacity(0.8)],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),

        // 3. WATERMARK
        Positioned(
          bottom: 40, right: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.lightbulb, size: 50, color: Colors.white10),
              const SizedBox(height: 10),
              Text("CREATIVE CONTROL", style: TextStyle(fontSize: isMobile ? 16 : 24, fontWeight: FontWeight.w900, color: Colors.white24, letterSpacing: 4.0)),
              Text("GORILLA POSITION", style: TextStyle(fontSize: isMobile ? 10 : 12, color: Colors.white12, letterSpacing: 2.0, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}