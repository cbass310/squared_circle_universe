import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart'; 
import '../../../logic/game_state_provider.dart';
import '../../../logic/promoter_provider.dart';
import '../../../data/models/wrestler.dart';
import '../../../data/models/show_history.dart'; 
import '../../../data/models/rivalry.dart'; 
import '../../components/wrestler_avatar.dart';

// --- IMPORT FOR THE WATERMARK ---
import '../../components/tv_watermark.dart';

// 🚨 THE FIX: Direct Database Pipeline for Feuds
final liveRivalriesProvider = StreamProvider<List<Rivalry>>((ref) async* {
  final isar = Isar.getInstance();
  if (isar == null) yield [];
  yield* isar!.rivalrys.filter().statusEqualTo(RivalryStatus.active).sortByHeatDesc().watch(fireImmediately: true);
});

// 🚨 THE FIX: Direct Database Pipeline for History
final liveHistoryProvider = StreamProvider<List<ShowHistory>>((ref) async* {
  final isar = Isar.getInstance();
  if (isar == null) yield [];
  yield* isar!.showHistorys.where().sortByWeekDesc().watch(fireImmediately: true);
});

class RivalryScreen extends ConsumerWidget {
  const RivalryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final rosterState = ref.watch(rosterProvider);

    return DefaultTabController(
      length: 3, 
      // 🚨 SMART LAYOUT BUILDER 🚨
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = constraints.maxWidth > 800;

          if (isDesktop) {
            // 💻 PC LAYOUT (Wide Side-by-Side)
            return Scaffold(
              backgroundColor: Colors.black,
              body: SafeArea(
                child: Row(
                  children: [
                    Expanded(flex: 4, child: _buildDashboard(context, gameState, rosterState, ref, true)),
                    Expanded(flex: 6, child: _buildArtworkPane(gameState, isMobile: false)),
                  ],
                ),
              ),
            );
          } else {
            // 📱 MOBILE LAYOUT (40/60 Vertical Split)
            return Scaffold(
              backgroundColor: Colors.black,
              body: Column(
                children: [
                  // TOP 40%: The Cinematic Viewport
                  Expanded(
                    flex: 4,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _buildArtworkPane(gameState, isMobile: true),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.black.withOpacity(0.4), Colors.black],
                              stops: const [0.5, 1.0],
                            ),
                          ),
                        ),
                        // SAFE AREA FOR BACK BUTTON & TITLE
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.amber, size: 20), 
                                  onPressed: () => Navigator.pop(context),
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.topLeft,
                                ),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.lightbulb, color: Colors.amber, size: 24),
                                        SizedBox(width: 8),
                                        Text("WRITER'S ROOM", style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Text("CREATIVE HUB", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // BOTTOM 60%: The Dashboard Data
                  Expanded(
                    flex: 6,
                    child: Container(
                      color: Colors.black,
                      width: double.infinity,
                      child: _buildDashboard(context, gameState, rosterState, ref, false),
                    ),
                  ),
                ],
              ),
            );
          }
        }
      ),
    );
  }

  // =====================================================================
  // --- THE CREATIVE DASHBOARD (Shared)
  // =====================================================================
  Widget _buildDashboard(BuildContext context, dynamic gameState, dynamic rosterState, WidgetRef ref, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: isDesktop ? const Color(0xFF121212) : Colors.black,
        border: isDesktop ? const Border(right: BorderSide(color: Colors.white10, width: 2)) : null,
      ),
      child: Column(
        children: [
          // HEADER (PC ONLY - Mobile handles this in the image overlay)
          if (isDesktop)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.amber, size: 20), onPressed: () => Navigator.pop(context)),
                  const SizedBox(width: 8),
                  const Text("CREATIVE HUB", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                ],
              ),
            ),
          
          // --- TABS ---
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: isDesktop ? Colors.black : Colors.white10, width: isDesktop ? 3 : 1)),
              color: isDesktop ? const Color(0xFF121212) : Colors.black,
            ),
            child: const TabBar(
              dividerColor: Colors.transparent, 
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

          // --- TAB CONTENT ---
          Expanded(
            child: TabBarView(
              children: [
                _buildRivalriesTab(ref, rosterState.roster),
                _buildHistoryTab(ref),
                _buildAssistantGMTab(context, rosterState),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // --- ARTWORK PANE (Shared)
  // =====================================================================
  Widget _buildArtworkPane(dynamic gameState, {required bool isMobile}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/images/gorilla_position.png", 
          fit: BoxFit.cover,
          alignment: Alignment.centerRight,
          errorBuilder: (c, e, s) => Container(color: const Color(0xFF0A0A0A)),
        ),
        if (!isMobile)
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
        TVWatermark(isMobile: isMobile),
      ],
    );
  }

  // =====================================================================
  // --- TAB 1: RIVALRIES
  // =====================================================================
  Widget _buildRivalriesTab(WidgetRef ref, List<Wrestler> roster) {
    final rivalriesAsync = ref.watch(liveRivalriesProvider);

    return rivalriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(color: Colors.amber)),
      error: (err, stack) => const Center(child: Text("Error loading rivalries.", style: TextStyle(color: Colors.red))),
      data: (feuds) {
        if (feuds.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
          itemCount: feuds.length,
          itemBuilder: (context, index) {
            final feud = feuds[index];
            
            // 🚨 Re-attach the Wrestler objects from the DB names
            Wrestler? w1 = roster.where((w) => w.name == feud.wrestler1Name).firstOrNull;
            Wrestler? w2 = roster.where((w) => w.name == feud.wrestler2Name).firstOrNull;
            
            // If they got released, we skip drawing the feud card
            if (w1 == null || w2 == null) return const SizedBox.shrink();

            return _buildFeudCard(w1, w2, feud);
          },
        );
      }
    );
  }

  Widget _buildFeudCard(Wrestler w1, Wrestler w2, Rivalry feud) {
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
        border: Border.all(color: heatColor.withOpacity(0.5), width: 1), 
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

  // =====================================================================
  // --- TAB 2: HISTORY
  // =====================================================================
  Widget _buildHistoryTab(WidgetRef ref) {
    final historyAsync = ref.watch(liveHistoryProvider);

    return historyAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(color: Colors.amber)),
      error: (err, stack) => const Center(child: Text("Error loading archive.", style: TextStyle(color: Colors.red))),
      data: (history) {
        if (history.isEmpty) {
          return const Center(child: Text("No booking history available.", style: TextStyle(color: Colors.white54)));
        }

        final topHistory = history.take(6).toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: topHistory.length,
          itemBuilder: (context, index) {
            final entry = topHistory[index];
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
                      Text("WEEK ${entry.week} - ${entry.showName.toUpperCase()}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      const Spacer(),
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text("${entry.avgRating}", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.w900, fontSize: 14)),
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
                          
                          if (entry.highlights.isEmpty)
                            _buildArchivedMatchRow("N/A", "No segment data found for this week."),
                          
                          ...entry.highlights.map((highlightStr) {
                            List<String> parts = highlightStr.split(':');
                            String slot = parts.length > 1 ? parts[0].trim() : "MATCH";
                            String desc = parts.length > 1 ? parts.sublist(1).join(':').trim() : highlightStr;
                            return _buildArchivedMatchRow(slot, desc);
                          }),
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
    );
  }

  Widget _buildArchivedMatchRow(String slot, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 75, 
            child: Text(slot.toUpperCase(), style: const TextStyle(color: Colors.amber, fontSize: 9, fontWeight: FontWeight.bold))
          ),
          Expanded(
            child: Text(description, style: const TextStyle(color: Colors.white70, fontSize: 11, fontStyle: FontStyle.italic)),
          )
        ],
      ),
    );
  }

  // =====================================================================
  // --- TAB 3: ASSISTANT GM
  // =====================================================================
  Widget _buildAssistantGMTab(BuildContext context, dynamic rosterState) {
    dynamic topFeud;
    if (rosterState.activeRivalries.isNotEmpty) {
      final sortedFeuds = List<dynamic>.from(rosterState.activeRivalries);
      sortedFeuds.sort((dynamic a, dynamic b) => (b.heat as num).compareTo(a.heat as num));
      topFeud = sortedFeuds.first;
    }

    final List<Wrestler> activeRoster = List<Wrestler>.from(
      rosterState.roster.where((w) => w.companyId == 0 && w.isInjured == false)
    );
    
    activeRoster.sort((Wrestler a, Wrestler b) => b.pop.compareTo(a.pop));

    String mainEventText = topFeud != null ? "${topFeud.wrestlerA.name} vs ${topFeud.wrestlerB.name}" : "N/A - Start a Feud First!";
    String midCardText = "Need more active wrestlers.";
    String openerText = "Need more active wrestlers.";

    if (activeRoster.length >= 4) {
      var champ = activeRoster.firstWhere((w) => w.isTVChampion, orElse: () => activeRoster[1]);
      var challenger = activeRoster.firstWhere((w) => 
        w.id != champ.id && 
        (topFeud == null || (w.id != topFeud.wrestlerA.id && w.id != topFeud.wrestlerB.id)), 
        orElse: () => activeRoster[2]
      );
      midCardText = "${champ.name} vs ${challenger.name}";
    }

    if (activeRoster.length >= 6) {
      var opener1 = activeRoster[activeRoster.length - 3];
      var opener2 = activeRoster[activeRoster.length - 2];
      openerText = "${opener1.name} vs ${opener2.name}";
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
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.smart_toy, color: Colors.blueAccent, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ASSISTANT GM PROJECTION", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                      SizedBox(height: 4),
                      Text("Based on your active roster and active heat, here is the optimal 3-match card.", style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _buildDraftBoardSlot(
            slotName: "MAIN EVENT", 
            logicReason: "Climax of hottest active rivalry.",
            matchText: mainEventText,
            color: Colors.amber,
          ),
          _buildDraftBoardSlot(
            slotName: "MID-CARD SHOWCASE", 
            logicReason: "Secondary Title Defense or Top Contender Match.",
            matchText: midCardText,
            color: Colors.greenAccent,
          ),
          _buildDraftBoardSlot(
            slotName: "HOT OPENER", 
            logicReason: "Fast-paced match between mid-card talent to pop the crowd.",
            matchText: openerText,
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
              label: const Text("CLOSE & GO BOOK", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0)),
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(height: 40), 
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
        border: Border(left: BorderSide(color: color.withOpacity(0.8), width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(slotName, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              Icon(Icons.auto_awesome, color: color.withOpacity(0.3), size: 14),
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
}