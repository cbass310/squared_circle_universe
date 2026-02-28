import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- DATA MODEL ---
class AppSettings {
  final double musicVolume;
  final double sfxVolume;
  final String difficulty;

  AppSettings({
    this.musicVolume = 0.7,
    this.sfxVolume = 0.8,
    this.difficulty = "NORMAL",
  });

  AppSettings copyWith({double? musicVolume, double? sfxVolume, String? difficulty}) {
    return AppSettings(
      musicVolume: musicVolume ?? this.musicVolume,
      sfxVolume: sfxVolume ?? this.sfxVolume,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}

// --- NOTIFIER ---
class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(AppSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = state.copyWith(
      musicVolume: prefs.getDouble('musicVolume') ?? 0.7,
      sfxVolume: prefs.getDouble('sfxVolume') ?? 0.8,
      difficulty: prefs.getString('difficulty') ?? "NORMAL",
    );
  }

  Future<void> setMusicVolume(double volume) async {
    state = state.copyWith(musicVolume: volume);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('musicVolume', volume);
    // TODO: Eventually trigger an AudioController here to actually lower the volume!
  }

  Future<void> setSfxVolume(double volume) async {
    state = state.copyWith(sfxVolume: volume);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('sfxVolume', volume);
  }

  Future<void> setDifficulty(String diff) async {
    state = state.copyWith(difficulty: diff);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('difficulty', diff);
  }
}

// --- PROVIDER ---
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});