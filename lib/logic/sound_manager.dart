import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SoundManager {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playSound(String fileName) async {
    try {
      // FIX: Changed 'sounds' to 'audio' to match your folder structure
      await _player.stop(); 
      await _player.play(AssetSource('audio/$fileName')); 
    } catch (e) {
      print("Error playing sound $fileName: $e");
    }
  }

  Future<void> playCrowd(String type) async {
    final crowdPlayer = AudioPlayer(); 
    try {
      String file = "crowd_normal.mp3";
      if (type == "POP") file = "crowd_pop.mp3";
      if (type == "BOO") file = "crowd_boo.mp3";
      if (type == "CHANT") file = "crowd_chant.mp3"; // Ensure this file exists or remove this line
      
      // FIX: Changed 'sounds' to 'audio'
      await crowdPlayer.play(AssetSource('audio/$file'));
    } catch (e) {
      print("Error playing crowd: $e");
    }
  }
}

final soundProvider = Provider<SoundManager>((ref) {
  return SoundManager();
});