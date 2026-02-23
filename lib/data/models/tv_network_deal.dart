import 'package:isar/isar.dart';

part 'tv_network_deal.g.dart'; // REQUIRED FOR ISAR

@collection
class TvNetworkDeal {
  Id id = Isar.autoIncrement;

  late String networkName;
  late String description;
  
  late int tierLevel; // 1 (Local), 2 (Cable), 3 (Streaming)

  // Economy
  late int durationInWeeks; 
  late int weeklyPayout;
  
  // Constraints
  late double targetMinimumRating; 
  bool cannibalizesPPVs = false; // True = Flat fee for PPVs, False = Traditional Buyrates
  double ppvBonusMultiplier = 1.0; 

  // State Tracking
  int promotionId = -1; // -1 = Unsigned, 0 = Player, 2 = Empire Rival
}