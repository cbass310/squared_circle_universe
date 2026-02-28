import 'package:isar/isar.dart';
import 'wrestler.dart';

part 'match.g.dart';

// EXPANDED MATCH TYPES
enum MatchType { 
  standard, 
  hardcore, 
  submission, 
  ladder, 
  cage, 
  promo, 
  ambush 
}

// --- NEW: AGENT NOTES (Controls the Finish & Heat Generation) ---
enum AgentNote {
  standard,      // Default: Let them call it in the ring
  cleanFinish,   // Boosts Rating. Winner gets momentum, Loser drops momentum.
  screwjob       // Drops Rating. Generates massive Heat. Loser is protected.
}

@Collection()
class Match {
  Id id = Isar.autoIncrement;

  @Enumerated(EnumType.name)
  late MatchType type;

  // NEW: The Agent Note selected by the player
  @Enumerated(EnumType.name)
  AgentNote agentNote = AgentNote.standard;

  late String winnerName;
  late String loserName; // 🚨 THE FIX: We now permanently store the loser's name!
  late String finishType; // "Pinfall", "Submission", "KO", "Escaped Cage"
  
  double rating = 0.0;
  int duration = 0;
  int heat = 0;

  final wrestlers = IsarLinks<Wrestler>();

  Match({
    this.type = MatchType.standard,
    this.agentNote = AgentNote.standard,
    this.winnerName = "",
    this.loserName = "Unknown", // 🚨 Added to the constructor
    this.finishType = "Pinfall",
    this.rating = 0.0,
    this.duration = 10,
    this.heat = 0,
  });
}