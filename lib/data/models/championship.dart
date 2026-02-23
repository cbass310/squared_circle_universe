import 'package:isar/isar.dart';
import 'wrestler.dart'; // Make sure this points to your wrestler.dart file

part 'championship.g.dart'; // This line will be red until you run the generator

@collection
class Championship {
  Id id = Isar.autoIncrement;

  late String name; // e.g., "SCU World Heavyweight"
  
  @Enumerated(EnumType.ordinal)
  TitleStatus status = TitleStatus.active; 

  int prestige = 50; // 0-100. Higher prestige = better match ratings.

  // Link to the wrestler holding the belt
  final champion = IsarLink<Wrestler>();

  // A list of strings to track history: "Week 5: Chuck def. Vic"
  List<String> history = [];
}

enum TitleStatus { active, vacant, retired }