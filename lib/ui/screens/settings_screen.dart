import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../logic/promoter_provider.dart';
import '../modes/promoter/promoter_home_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // Local state for the sliders
  double _musicVolume = 0.7;
  double _sfxVolume = 0.8;
  String _difficulty = "NORMAL";

  void _showFactoryResetDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text("Factory Reset?", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          "This will delete all your roster data, title history, and cash. This action cannot be undone.\n\nAre you sure?", 
          style: TextStyle(color: Colors.white70)
        ),
        actions: [
          TextButton(child: const Text("Cancel", style: TextStyle(color: Colors.grey)), onPressed: () => Navigator.pop(ctx)),
          TextButton(
            child: const Text("RESET UNIVERSE", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onPressed: () async {
              Navigator.pop(ctx); // Close dialog
              await ref.read(rosterProvider.notifier).factoryReset();
              
              if (mounted) {
                // Pop the settings screen and route back to a fresh dashboard
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PromoterHomeScreen()));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Universe Reset Complete!"), backgroundColor: Colors.red));
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.grey), 
          onPressed: () => Navigator.pop(context)
        ),
        title: const Text("SETTINGS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- AUDIO SECTION ---
            const Text("AUDIO", style: TextStyle(color: Colors.amber, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            const SizedBox(height: 16),
            _buildSliderRow("Music Volume", _musicVolume, Icons.music_note_rounded, (val) => setState(() => _musicVolume = val)),
            const SizedBox(height: 16),
            _buildSliderRow("Sound Effects", _sfxVolume, Icons.volume_up_rounded, (val) => setState(() => _sfxVolume = val)),
            
            const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Divider(color: Colors.white10, thickness: 2)),

            // --- GAMEPLAY SECTION ---
            const Text("GAMEPLAY EXPERIENCE", style: TextStyle(color: Colors.amber, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Difficulty Level", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    value: _difficulty,
                    dropdownColor: const Color(0xFF202020),
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.amber),
                    style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                    items: ["EASY", "NORMAL", "HARD", "TYCOON"].map((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _difficulty = val);
                    },
                  ),
                ],
              ),
            ),

            const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Divider(color: Colors.white10, thickness: 2)),

            // --- DANGER ZONE ---
            const Text("DANGER ZONE", style: TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent),
                label: const Text("FACTORY RESET UNIVERSE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.redAccent, letterSpacing: 1.0)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  side: const BorderSide(color: Colors.redAccent, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _showFactoryResetDialog,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Warning: This will permanently delete your promotion, roster, and cash. You will start back at Year 1.",
              style: TextStyle(color: Colors.white30, fontSize: 12),
              textAlign: TextAlign.center,
            ),
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
              Text("${(value * 100).toInt()}%", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
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