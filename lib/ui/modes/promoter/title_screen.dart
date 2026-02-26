import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/promoter_provider.dart';
import '../../../data/models/wrestler.dart';
import '../../components/wrestler_avatar.dart';

class TitleScreen extends ConsumerWidget {
  const TitleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rosterState = ref.watch(rosterProvider);
    
    Wrestler? worldChamp;
    try { worldChamp = rosterState.roster.firstWhere((w) => w.isChampion); } catch (_) {}

    Wrestler? tvChamp;
    try { tvChamp = rosterState.roster.firstWhere((w) => w.isTVChampion); } catch (_) {}

    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: isDesktop
              ? Row(
                  children: [
                    // 🛠️ THE FIX: Deep Black Borders
                    Expanded(flex: 4, child: _buildLeftDashboard(context, rosterState, worldChamp, tvChamp, isDesktop)),
                    Expanded(flex: 6, child: _buildRightDisplayCase(isMobile: false)),
                  ],
                )
              : Column(
                  children: [
                    Expanded(flex: 4, child: _buildRightDisplayCase(isMobile: true)),
                    Expanded(flex: 6, child: _buildLeftDashboard(context, rosterState, worldChamp, tvChamp, isDesktop)),
                  ],
                ),
        ),
      ),
    );
  }

  // =====================================================================
  // --- LEFT PANE: THE CHAMPIONSHIP DASHBOARD
  // =====================================================================
  Widget _buildLeftDashboard(BuildContext context, dynamic rosterState, Wrestler? worldChamp, Wrestler? tvChamp, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        // 🛠️ THE FIX: Match the Roster/Power Plant Black Borders
        border: isDesktop ? const Border(right: BorderSide(color: Colors.black, width: 3)) : const Border(top: BorderSide(color: Colors.black, width: 3)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.amber, size: 20), onPressed: () => Navigator.pop(context)),
                const SizedBox(width: 8),
                const Text("CHAMPIONSHIPS", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              ],
            ),
          ),
          
          // --- TABS ---
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black, width: 3)),
              color: Color(0xFF121212),
            ),
            child: const TabBar(
              dividerColor: Colors.transparent, // 🛠️ THE FIX: Kill the white line!
              indicatorColor: Colors.amber,
              indicatorWeight: 3,
              labelColor: Colors.amber,
              unselectedLabelColor: Colors.white54,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.5),
              tabs: [
                Tab(text: "ACTIVE CHAMPIONS"),
                Tab(text: "TITLE LINEAGE"),
              ],
            ),
          ),

          // --- TAB CONTENT ---
          Expanded(
            child: TabBarView(
              children: [
                // TAB 1: ACTIVE CHAMPIONS
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildBeltCard(
                        context: context, 
                        name: "WORLD HEAVYWEIGHT", 
                        desc: "The richest prize in the game.", 
                        imagePath: "assets/images/belt_world.png", 
                        color: Colors.amber, 
                        champ: worldChamp
                      ),
                      const SizedBox(height: 16),
                      _buildBeltCard(
                        context: context, 
                        name: "TELEVISION TITLE", 
                        desc: "The workhorse championship.", 
                        imagePath: "assets/images/belt_tv.png", 
                        color: Colors.grey.shade400, // Silver for TV Title
                        champ: tvChamp
                      ),
                    ],
                  ),
                ),

                // TAB 2: TITLE LINEAGE HISTORY
                rosterState.titleHistory.isEmpty
                  ? const Center(child: Text("No title history established.", style: TextStyle(color: Colors.white54)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: rosterState.titleHistory.length,
                      itemBuilder: (context, index) {
                        final entry = rosterState.titleHistory[index];
                        bool isWorld = entry.beltName.contains("World");
                        Color activeColor = isWorld ? Colors.amber : Colors.grey.shade400;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E), // 🛠️ THE FIX: Roster Card Background
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black, width: 2), // 🛠️ THE FIX: Black Borders
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: activeColor.withOpacity(0.1), shape: BoxShape.circle),
                              child: Icon(Icons.emoji_events, color: activeColor, size: 20),
                            ),
                            title: Text(entry.beltName.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            subtitle: Text("${entry.championName}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text("REIGN", style: TextStyle(color: Colors.white30, fontSize: 9, fontWeight: FontWeight.bold)),
                                Text("${entry.reignWeeks} WKS", style: TextStyle(color: activeColor, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // --- RIGHT PANE: THE DISPLAY CASE ARTWORK
  // =====================================================================
  Widget _buildRightDisplayCase({bool isMobile = false}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/images/title_case.png", 
          fit: BoxFit.cover,
          alignment: Alignment.centerRight,
          errorBuilder: (c, e, s) => Image.asset("assets/images/office_background.png", fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(color: const Color(0xFF0A0A0A))),
        ),
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
        Positioned(
          bottom: 40, right: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.workspace_premium, size: 50, color: Colors.white10),
              const SizedBox(height: 10),
              Text("CHAMPIONSHIP", style: TextStyle(fontSize: isMobile ? 20 : 32, fontWeight: FontWeight.bold, color: Colors.white24, letterSpacing: 4.0)),
              Text("COMMITTEE", style: TextStyle(fontSize: isMobile ? 10 : 14, color: Colors.white12, letterSpacing: 2.0, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildBeltCard({required BuildContext context, required String name, required String desc, required String imagePath, required Color color, required Wrestler? champ}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // 🛠️ THE FIX: Roster Card Background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 3), // 🛠️ THE FIX: Thick Black Border
        boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 20)],
      ),
      child: Column(
        children: [
          // HEADER IMAGE
          SizedBox(
            height: 120,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorBuilder: (c, o, s) => Container(color: Colors.black, child: Icon(Icons.emoji_events, size: 50, color: color)),
                  ),
                ),
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.black.withOpacity(0.95), Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter)
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12, left: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, letterSpacing: 1.0)),
                      Text(desc, style: const TextStyle(color: Colors.white54, fontSize: 9)),
                    ],
                  ),
                )
              ],
            ),
          ),
          
          // CHAMPION INFO
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black, width: 2)) // 🛠️ THE FIX: Internal Black Divider
            ),
            child: Row(
              children: [
                if (champ != null) ...[
                  WrestlerAvatar(wrestler: champ, size: 60),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("CURRENT CHAMPION", style: TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                      const SizedBox(height: 4),
                      Text(champ.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  )
                ] else ...[
                  Container(
                    height: 60, width: 60,
                    decoration: BoxDecoration(color: Colors.black45, shape: BoxShape.circle, border: Border.all(color: Colors.white24)),
                    child: const Icon(Icons.person_off, color: Colors.white30),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("CURRENT CHAMPION", style: TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                      SizedBox(height: 4),
                      Text("VACANT", style: TextStyle(color: Colors.white38, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  )
                ]
              ],
            ),
          )
        ],
      ),
    );
  }
}