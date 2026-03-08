import 'package:isar/isar.dart';

part 'milestone.g.dart';

@collection
class Milestone {
  Id id = Isar.autoIncrement;
  
  @Index(unique: true)
  late String key; 
  
  late String title;
  late String description;
  
  // We will store the Flutter Icon code point here so we can draw cool icons
  late int iconCode; 
  
  bool isUnlocked = false;
  DateTime? unlockDate;
}