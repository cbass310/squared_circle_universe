import 'package:isar/isar.dart';

part 'rivalry.g.dart';

@collection
class Rivalry {
  Id id = Isar.autoIncrement;

  late String wrestler1Name;
  late String wrestler2Name;
  
  late int heat; // 0 to 100
  late int durationWeeks;

  // --- NEW: SVR '07 Rivalry Status ---
  @enumerated
  late RivalryStatus status;

  Rivalry({
    required this.wrestler1Name,
    required this.wrestler2Name,
    this.heat = 0,
    this.durationWeeks = 0,
    this.status = RivalryStatus.active, // Defaults to active when created
  });
}

// Tracks the state of the feud for the game loop
enum RivalryStatus {
  active,      // Currently building heat
  coolingDown, // Taking a break so fans don't get bored (-10 heat penalty if booked)
  concluded    // The feud is officially over
}