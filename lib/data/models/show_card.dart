import 'package:isar/isar.dart';
import 'match.dart'; // We will link the matches to the show!

part 'show_card.g.dart'; // REQUIRED FOR ISAR

@collection
class ShowCard {
  Id id = Isar.autoIncrement;
  
  late String showName; // e.g., "Monday Night TV" or "Starcade Showcase"
  late int week; // 1 through 52
  
  bool isPPV = false; 
  bool isShowcaseEvent = false; 
  
  // The calculated pacing modifier based on how the player ordered the slots
  double pacingMultiplier = 1.0; 
  
  // Post-Simulation Results
  double finalRating = 0.0;
  int totalRevenue = 0; 
  
  // ISAR LINK: This securely links the matches to this specific show in the database
  final bookedMatches = IsarLinks<Match>(); 
}