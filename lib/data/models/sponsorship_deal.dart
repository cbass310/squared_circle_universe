import 'package:isar/isar.dart';

part 'sponsorship_deal.g.dart';

enum RealEstateSlot { turnbuckle, canvas, eventName }
enum SponsorArchetype { consistency, upfrontCash, performance }

@collection
class SponsorshipDeal {
  Id id = Isar.autoIncrement;
  
  late String sponsorName; 
  late String description;
  late String logoPath;

  @enumerated
  late RealEstateSlot slotTarget; 
  
  @enumerated
  late SponsorArchetype archetype; 
  
  late int durationInWeeks; 
  late int weeksLeft;
  
  late int upfrontBonus;
  late int weeklyPayout;
  
  late double performanceBonusThreshold; 
  late int performanceBonusAmount;

  // Tracking who owns it: -1 = Available, 0 = Player, 2 = Empire
  int promotionId = -1; 
}