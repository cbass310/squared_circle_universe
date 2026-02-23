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
    
    // Safer Champion Lookup Logic
    Wrestler? worldChamp;
    try {
      worldChamp = rosterState.roster.firstWhere((w) => w.isChampion);
    } catch (_) {}

    Wrestler? tvChamp;
    try {
      tvChamp = rosterState.roster.firstWhere((w) => w.isTVChampion);
    } catch (_) {}

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("CHAMPIONSHIP COMMITTEE"),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // WORLD TITLE CARD
            _buildBeltCard(
              context, 
              "WORLD HEAVYWEIGHT", 
              "The richest prize in the game.", 
              "assets/images/belt_world.png", 
              Colors.amber, 
              worldChamp
            ),
            
            const SizedBox(height: 20),
            
            // TV TITLE CARD
            _buildBeltCard(
              context, 
              "TELEVISION TITLE", 
              "The workhorse championship.", 
              "assets/images/belt_tv.png", 
              Colors.redAccent, 
              tvChamp
            ),
            
            const SizedBox(height: 30),
            const Divider(color: Colors.white24),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("CURRENT REIGNS", style: TextStyle(color: Colors.grey, letterSpacing: 2)),
            ),
            
            // HISTORY LIST
            if (rosterState.titleHistory.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("No title history established.", style: TextStyle(color: Colors.white30, fontStyle: FontStyle.italic)),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rosterState.titleHistory.length,
                itemBuilder: (context, index) {
                  final entry = rosterState.titleHistory[index];
                  return ListTile(
                    leading: Icon(
                      Icons.emoji_events, 
                      color: entry.beltName.contains("World") ? Colors.amber : Colors.redAccent
                    ),
                    title: Text(
                      entry.beltName.toUpperCase(), 
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                    ),
                    subtitle: Text(
                      "${entry.championName} • ${entry.reignWeeks} Weeks", 
                      style: const TextStyle(color: Colors.white70)
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBeltCard(BuildContext context, String name, String desc, String imagePath, Color color, Wrestler? champ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5), width: 2),
        boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 20)],
      ),
      child: Column(
        children: [
          // HEADER IMAGE
          SizedBox(
            height: 140,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (c, o, s) => Container(
                      color: Colors.grey[900], 
                      child: Icon(Icons.emoji_events, size: 50, color: color)
                    ),
                  ),
                ),
                // Gradient Overlay (FIXED SYNTAX HERE)
                Positioned(
                  bottom: 0, 
                  left: 0, 
                  right: 0,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.9), Colors.transparent], 
                        begin: Alignment.bottomCenter, 
                        end: Alignment.topCenter
                      )
                    ),
                  ),
                ),
                // Title Name
                Positioned(
                  bottom: 10, left: 15,
                  child: Text(
                    name, 
                    style: TextStyle(
                      color: color, 
                      fontSize: 20, 
                      fontWeight: FontWeight.bold, 
                      fontStyle: FontStyle.italic
                    )
                  ),
                )
              ],
            ),
          ),
          
          // CHAMPION INFO
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                if (champ != null) ...[
                  WrestlerAvatar(wrestler: champ, size: 60),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("CURRENT CHAMPION", style: TextStyle(color: Colors.grey, fontSize: 10)),
                      Text(
                        champ.name, 
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                      ),
                      Text("Prestige: A+", style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                    ],
                  )
                ] else ...[
                  const Icon(Icons.person_off, size: 50, color: Colors.grey),
                  const SizedBox(width: 15),
                  const Text("VACANT", style: TextStyle(color: Colors.white38, fontSize: 24, fontWeight: FontWeight.bold)),
                ]
              ],
            ),
          )
        ],
      ),
    );
  }
}