import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/game_state_provider.dart';
import '../../../logic/sound_manager.dart';

class VenueScreen extends ConsumerWidget {
  const VenueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final notifier = ref.read(gameProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("VENUE UPGRADES"),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // FIX: Shifted to Level 1
          _buildVenueHeroCard(
            context, 
            level: 1, 
            name: gameState.venueCustomNames[0], 
            capacity: "500 Fans", 
            cost: "FREE", 
            description: "A sweaty, gritty gym. It smells like hard work.",
            currentLevel: gameState.venueLevel, 
            imagePath: "assets/images/venue_gym.png", 
            onBuy: null
          ),
          // FIX: Shifted to Level 2
          _buildVenueHeroCard(
            context, 
            level: 2, 
            name: gameState.venueCustomNames[1], 
            capacity: "2,500 Fans", 
            cost: "\$25,000", 
            description: "A respectable local hall with proper lighting.",
            currentLevel: gameState.venueLevel, 
            imagePath: "assets/images/venue_civic.png", 
            onBuy: () => _attemptUpgrade(context, ref, notifier)
          ),
          // FIX: Shifted to Level 3
          _buildVenueHeroCard(
            context, 
            level: 3, 
            name: gameState.venueCustomNames[2], 
            capacity: "15,000 Fans", 
            cost: "\$250,000", 
            description: "A televised arena with luxury boxes and pyrotechnics.",
            currentLevel: gameState.venueLevel, 
            imagePath: "assets/images/venue_arena.png", 
            onBuy: () => _attemptUpgrade(context, ref, notifier)
          ),
          // FIX: Shifted to Level 4
          _buildVenueHeroCard(
            context, 
            level: 4, 
            name: gameState.venueCustomNames[3], 
            capacity: "60,000 Fans", 
            cost: "\$1,000,000", 
            description: "The grandest stage of them all. Legends are made here.",
            currentLevel: gameState.venueLevel, 
            imagePath: "assets/images/venue_stadium.png", 
            onBuy: () => _attemptUpgrade(context, ref, notifier)
          ),
        ],
      ),
    );
  }

  void _attemptUpgrade(BuildContext context, WidgetRef ref, GameNotifier notifier) {
    bool success = notifier.purchaseVenueUpgrade();
    
    if (success) {
      ref.read(soundProvider).playSound("bell.mp3"); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("UPGRADE SUCCESSFUL! WELCOME TO THE BIG LEAGUES!"), backgroundColor: Colors.green)
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("NOT ENOUGH CASH!"), backgroundColor: Colors.red)
      );
    }
  }

  Widget _buildVenueHeroCard(BuildContext context, {
    required int level,
    required String name,
    required String capacity,
    required String cost,
    required String description,
    required int currentLevel,
    required String imagePath,
    required VoidCallback? onBuy,
  }) {
    bool isCurrent = level == currentLevel;
    bool isNext = level == currentLevel + 1;
    bool isLocked = level > currentLevel + 1;

    Color borderColor = Colors.white10;
    if (isCurrent) borderColor = Colors.greenAccent;
    if (isNext) borderColor = Colors.amber;

    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: isCurrent ? 3 : 1),
        boxShadow: isCurrent || isNext 
          ? [BoxShadow(color: borderColor.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 5))]
          : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 150, 
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  child: ColorFiltered(
                    colorFilter: isLocked 
                      ? const ColorFilter.mode(Colors.black87, BlendMode.saturation) 
                      : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (c, o, s) => Container(color: Colors.grey[800], child: const Icon(Icons.broken_image)),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 15,
                  top: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white24)),
                    child: Text("LEVEL $level", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
                if (isLocked)
                  const Center(child: Icon(Icons.lock, size: 50, color: Colors.white54)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(name.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Roboto'))), 
                    if (isCurrent)
                      const Chip(label: Text("CURRENT HQ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), backgroundColor: Colors.greenAccent)
                  ],
                ),
                const SizedBox(height: 5),
                Text(capacity, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 16)),
                const SizedBox(height: 10),
                Text(description, style: const TextStyle(color: Colors.white70, fontStyle: FontStyle.italic, fontSize: 14)),
                const SizedBox(height: 20),
                
                if (isNext)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: onBuy,
                      icon: const Icon(Icons.shopping_cart, color: Colors.black),
                      label: Text("PURCHASE UPGRADE ($cost)", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  )
                else if (isLocked)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
                    child: const Text("LOCKED - UPGRADE PREVIOUS VENUE FIRST", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}