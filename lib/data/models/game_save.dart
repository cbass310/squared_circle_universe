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
  
  // Tracks your "WrestleMania" event
  int premierPpvIndex = 11; 

  // 🚨 THE FIX: We store the ledger as a list of JSON strings to completely bypass the Isar generation bug!
  List<String> ledgerJson = []; 
}