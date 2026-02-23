import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/promoter_provider.dart';
import '../../../logic/game_state_provider.dart';
import '../../../data/models/wrestler.dart';
import '../../components/wrestler_avatar.dart';
import 'contract_negotiation_dialog.dart';

class ScoutingScreen extends ConsumerWidget {
  const ScoutingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rosterState = ref.watch(rosterProvider);
    final notifier = ref.read(rosterProvider.notifier);
    final gameRef = ref.watch(gameProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          title: const Text("GLOBAL SCOUTING", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0)),
          backgroundColor: Colors.transparent,
          bottom: const TabBar(
            indicatorColor: Colors.amber,
            labelColor: Colors.amber,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "INDIE PROSPECTS"),
              Tab(text: "VETERAN FREE AGENTS"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // ==========================================
            // TAB 1: INDIE PROSPECTS (THE FOG OF WAR)
            // ==========================================
            rosterState.isLoading 
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: rosterState.unscoutedProspects.length,
                itemBuilder: (context, index) {
                  final w = rosterState.unscoutedProspects[index];
                  return _buildProspectCard(context, w, notifier);
                },
              ),

            // ==========================================
            // TAB 2: VETERAN FREE AGENTS (OPEN MARKET)
            // ==========================================
            rosterState.isLoading 
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: rosterState.freeAgents.length,
                itemBuilder: (context, index) {
                  final w = rosterState.freeAgents[index];
                  return _buildVeteranCard(context, w, notifier);
                },
              ),
          ],
        ),
      ),
    );
  }

  // --- THE FOG OF WAR CARD ---
  Widget _buildProspectCard(BuildContext context, Wrestler w, RosterNotifier notifier) {
    bool isScouted = w.isScouted;

    // Mask the stats if they aren't scouted yet!
    String popText = isScouted ? "${w.pop}" : "???";
    String ringText = isScouted ? "${w.ringSkill}" : "???";
    String potentialText = isScouted ? "${w.potentialSkill}" : "???";
    
    // Generate 'Buzz' based on their hidden potential
    String buzz = "Unknown Indie Worker";
    Color buzzColor = Colors.grey;
    if (!isScouted) {
       if (w.potentialSkill >= 85) { buzz = "⭐⭐⭐⭐⭐ Next Big Thing"; buzzColor = Colors.amber; }
       else if (w.potentialSkill >= 70) { buzz = "⭐⭐⭐ Solid Indie Buzz"; buzzColor = Colors.lightBlueAccent; }
       else { buzz = "⭐ Local Backyarder"; buzzColor = Colors.white54; }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isScouted ? Colors.greenAccent : Colors.white10),
      ),
      child: Row(
        children: [
          // If unscouted, show a greyed-out silhouette!
          Opacity(
            opacity: isScouted ? 1.0 : 0.3,
            child: WrestlerAvatar(wrestler: w, size: 60),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(w.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                
                if (!isScouted) ...[
                  Text("Rumor: $buzz", style: TextStyle(color: buzzColor, fontStyle: FontStyle.italic, fontSize: 12)),
                  const SizedBox(height: 4),
                  const Text("Pay for a Deep Scout to reveal true stats.", style: TextStyle(color: Colors.white30, fontSize: 10)),
                ] else ...[
                  Text("${w.style.name.toUpperCase()} • ${w.isHeel ? 'HEEL' : 'FACE'}", style: const TextStyle(color: Colors.white70, fontSize: 10)),
                  const SizedBox(height: 4),
                  Text("CURRENT SKILL: $ringText", style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)),
                  Text("POTENTIAL CEILING: $potentialText", style: const TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                ]
              ],
            ),
          ),
          
          // --- THE DYNAMIC ACTION BUTTON ---
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: isScouted ? const Color(0xFF6200EE) : Colors.grey[800], borderRadius: BorderRadius.circular(4)),
                child: Text("POP $popText", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              
              if (!isScouted)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, padding: const EdgeInsets.symmetric(horizontal: 16), minimumSize: const Size(0, 30)),
                  onPressed: () async {
                    try {
                      await notifier.scoutProspect(w, 2000);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Scouting Report Completed!"), backgroundColor: Colors.green));
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
                      }
                    }
                  },
                  child: const Text("SCOUT \$2K", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                )
              else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 16), minimumSize: const Size(0, 30)),
                  onPressed: () {
                    // Once scouted, you can launch the Negotiation UI!
                    showDialog(context: context, builder: (_) => ContractNegotiationDialog(wrestler: w));
                  },
                  child: const Text("NEGOTIATE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                )
            ],
          ),
        ],
      ),
    );
  }

  // --- THE REGULAR VETERAN CARD (No Fog of War) ---
  Widget _buildVeteranCard(BuildContext context, Wrestler w, RosterNotifier notifier) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          WrestlerAvatar(wrestler: w, size: 60),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(w.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text("${w.style.name.toUpperCase()} • ${w.isHeel ? 'HEEL' : 'FACE'}", style: const TextStyle(color: Colors.white70, fontSize: 10)),
                const SizedBox(height: 4),
                Text("Ring: ${w.ringSkill} | Mic: ${w.micSkill}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF6200EE), borderRadius: BorderRadius.circular(4)),
                child: Text("POP ${w.pop}", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 16), minimumSize: const Size(0, 30)),
                onPressed: () {
                  showDialog(context: context, builder: (_) => ContractNegotiationDialog(wrestler: w));
                },
                child: const Text("NEGOTIATE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ],
      ),
    );
  }
}