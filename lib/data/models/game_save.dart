import 'package:isar/isar.dart';

part 'game_save.g.dart';

@collection
class GameSave {
  Id id = 1; 
  late int week;
  late int year;
  late int cash;
  late int fans;
  late int reputation;
  late String promotionName;
  late String tvShowName;
  late int venueLevel;
  late int techBroadcast;
  late int techPyro;
  late int techAudio;
  late int techMedical;
  
  // NEW: Tracks your "WrestleMania" event (Defaults to 11, which is Month 12 / Starrcade)
  int premierPpvIndex = 11; 
}