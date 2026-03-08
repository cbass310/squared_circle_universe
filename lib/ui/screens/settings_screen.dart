import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../logic/promoter_provider.dart';
import '../../logic/game_state_provider.dart'; 
import '../../logic/settings_provider.dart'; 
import 'hub_screen.dart'; 
import '../modes/promoter/trophy_room_screen.dart'; // 🚨 FIXED: Added ../ to the path

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  
  void _showFactoryResetDialog() {
    final confirmController = TextEditingController();
    bool isConfirmed = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder( 
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.redAccent, width: 2)),
            title: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
                SizedBox(width: 8),
                Text("FACTORY RESET", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "This will permanently delete your promotion, roster, and cash. This action cannot be undone.", 
                  style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)
                ),
                const SizedBox(height: 20),
                const Text("Type RESET to confirm:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 8),
                TextField(
                  controller: confirmController,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2.0),
                  onChanged: (val) {
                    setState(() {
                      isConfirmed = val.trim().toUpperCase() == "RESET";
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black,
                    enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white24), borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(child: const Text("CANCEL", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)), onPressed: () => Navigator.pop(ctx)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: isConfirmed ? Colors.redAccent : Colors.white10),
                onPressed: isConfirmed 
                  ? () async {
                      // 1. Capture the exact navigator BEFORE we wipe the database
                      final nav = Navigator.of(context, rootNavigator: true);
                      
                      // 2. Pop the warning dialog
                      nav.pop(); 

                      // 3. Nuke the Universe
                      await ref.read(gameProvider.notifier).resetGame();
                      await ref.read(rosterProvider.notifier).factoryReset();
                      
                      // 4. Safely transport the player back to the main Hub Screen!
                      nav.pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const HubScreen()), 
                        (route) => false,
                      );
                    } 
                  : null,
                child: const Text("NUKE SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
              ),
            ],
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.grey), 
          onPressed: () => Navigator.pop(context)
        ),
        title: const Text("SYSTEM CONFIG", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- AUDIO SECTION ---
            const Text("AUDIO", style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
            const SizedBox(height: 16),
            _buildSliderRow("Sound Effects", settings.sfxVolume, Icons.volume_up_rounded, (val) => settingsNotifier.setSfxVolume(val)),
            
            const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Divider(color: Colors.white10, thickness: 2)),

            // --- GAMEPLAY SECTION ---
            const Text("GAMEPLAY EXPERIENCE", style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Difficulty Level", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    value: settings.difficulty,
                    dropdownColor: const Color(0xFF202020),
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.amber),
                    style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.w900, letterSpacing: 1.0),
                    items: ["EASY", "NORMAL", "HARD", "TYCOON"].map((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) settingsNotifier.setDifficulty(val);
                    },
                  ),
                ],
              ),
            ),

            const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Divider(color: Colors.white10, thickness: 2)),

            // --- DATA MANAGEMENT ---
            const Text("DATA MANAGEMENT", style: TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
            const SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text("MANUAL SAVE", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent.shade700,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () async {
                  HapticFeedback.lightImpact();
                  await ref.read(gameProvider.notifier).saveGame();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Game Progress Saved!"), backgroundColor: Colors.greenAccent)
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 12),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.exit_to_app, color: Colors.white),
                label: const Text("SAVE & QUIT TO MENU", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () async {
                  HapticFeedback.heavyImpact();
                  // 1. Force the database to save right now
                  await ref.read(gameProvider.notifier).saveGame();
                  
                  // 2. Safely boot the player back to the title screen
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context, 
                      MaterialPageRoute(builder: (_) => const HubScreen()), 
                      (route) => false
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 12),

            // 🚨 THE NEW TROPHY BUTTON 🚨
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.emoji_events, color: Colors.black),
                label: const Text("VIEW PROMOTER MILESTONES", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0, color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber, 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (_) => const TrophyRoomScreen())
                  );
                },
              ),
            ),

            const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Divider(color: Colors.white10, thickness: 2)),

            // --- DANGER ZONE ---
            const Text("DANGER ZONE", style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent),
                label: const Text("FACTORY RESET UNIVERSE", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Colors.redAccent, letterSpacing: 1.0)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  side: const BorderSide(color: Colors.redAccent, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.redAccent.withOpacity(0.05),
                ),
                onPressed: _showFactoryResetDialog,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Warning: This will permanently delete your promotion, roster, and cash. You will start completely from scratch.",
              style: TextStyle(color: Colors.white30, fontSize: 10, fontWeight: FontWeight.bold, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderRow(String label, double value, IconData icon, Function(double) onChanged) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white54, size: 20),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              Text("${(value * 100).toInt()}%", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.w900)),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.amber,
              inactiveTrackColor: Colors.white10,
              thumbColor: Colors.amber,
              overlayColor: Colors.amber.withOpacity(0.2),
              trackHeight: 6.0,
            ),
            child: Slider(value: value, min: 0.0, max: 1.0, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}