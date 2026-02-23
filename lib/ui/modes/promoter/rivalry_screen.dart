import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/promoter_provider.dart'; // Contains the Rivalry class now
import '../../../data/models/wrestler.dart';
import '../../components/wrestler_avatar.dart'; // Keeping your component

class RivalryScreen extends ConsumerWidget {
  const RivalryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the new provider
    final rosterState = ref.watch(rosterProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("ACTIVE STORYLINES"),
        backgroundColor: Colors.transparent,
      ),
      body: rosterState.activeRivalries.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text("No active feuds.", style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text("Book matches to start rivalries!", style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, // 1 Card per row (wide)
                childAspectRatio: 2.2, // Short and wide
                mainAxisSpacing: 15,
              ),
              itemCount: rosterState.activeRivalries.length,
              itemBuilder: (context, index) {
                final feud = rosterState.activeRivalries[index];
                
                // FIX: We don't need to look up names anymore. 
                // The feud object already has the wrestlers inside it!
                return _buildFeudCard(feud);
              },
            ),
    );
  }

  Widget _buildFeudCard(Rivalry feud) {
    // Extract wrestlers directly from the new Rivalry model
    final w1 = feud.wrestlerA;
    final w2 = feud.wrestlerB;

    // Heat Logic
    Color heatColor = Colors.blue;
    String status = "Cold";
    IconData statusIcon = Icons.ac_unit;

    if (feud.heat > 30) { heatColor = Colors.orange; status = "Heating Up"; statusIcon = Icons.whatshot; }
    if (feud.heat > 60) { heatColor = Colors.red; status = "Red Hot"; statusIcon = Icons.local_fire_department; }
    if (feud.heat > 90) { heatColor = Colors.purpleAccent; status = "LEGENDARY"; statusIcon = Icons.flash_on; }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: heatColor.withOpacity(0.5), width: 2),
        boxShadow: [BoxShadow(color: heatColor.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Stack(
        children: [
          // Background "VS" Graphic
          Center(
            child: Text(
              "VS", 
              style: TextStyle(
                fontSize: 80, 
                fontWeight: FontWeight.bold, 
                fontStyle: FontStyle.italic, 
                color: Colors.white.withOpacity(0.05)
              )
            )
          ),
          
          Row(
            children: [
              // WRESTLER 1
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Using your WrestlerAvatar component
                      WrestlerAvatar(wrestler: w1, size: 70),
                      const SizedBox(height: 5),
                      Text(w1.name.toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
              ),

              // STATS CENTER
              Container(
                width: 100,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  border: Border.symmetric(vertical: BorderSide(color: Colors.white10)),
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black26, Colors.transparent], 
                    begin: Alignment.topCenter, end: Alignment.bottomCenter
                  )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(statusIcon, color: heatColor, size: 30),
                    const SizedBox(height: 5),
                    Text("${feud.heat}", style: TextStyle(color: heatColor, fontSize: 24, fontWeight: FontWeight.bold)),
                    Text(status.toUpperCase(), style: TextStyle(color: heatColor, fontSize: 10)),
                    const SizedBox(height: 5),
                    Text("${feud.durationWeeks} Weeks", style: const TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
              ),

              // WRESTLER 2
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WrestlerAvatar(wrestler: w2, size: 70),
                      const SizedBox(height: 5),
                      Text(w2.name.toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}