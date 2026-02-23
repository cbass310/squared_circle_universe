import 'dart:math';
import '../data/models/wrestler.dart';
import '../data/models/rivalry.dart';

class MatchRatingEngine {
  
  /// Calculates the final star rating for a match (0.0 to 5.0 Stars)
  /// based on the exact SvR 2007 algorithmic blueprint.
  static double calculateMatchRating({
    required Wrestler wrestlerA,
    required Wrestler wrestlerB,
    required List<Rivalry> activeRivalries,
    required int venueLevel,
    required int currentFans,
  }) {
    // 1. BASE SKILL: Average of Ring Skill and Popularity
    double wA_Skill = (wrestlerA.ringSkill + wrestlerA.pop) / 2;
    double wB_Skill = (wrestlerB.ringSkill + wrestlerB.pop) / 2;
    double baseSkill = (wA_Skill + wB_Skill) / 2; // Range: 0 - 100

    // 2. CHEMISTRY MODIFIER: The Style Matrix
    double chemistryModifier = _getChemistryModifier(wrestlerA.style, wrestlerB.style);

    // 3. HEAT MULTIPLIER: Check if they are in an active rivalry
    double heatMultiplier = 1.0;
    final rivalry = _findActiveRivalry(wrestlerA.name, wrestlerB.name, activeRivalries);
    if (rivalry != null) {
      heatMultiplier = 1.0 + (rivalry.heat / 100.0); // e.g., 80 heat = 1.8x boost!
    }

    // 4. ATMOSPHERE MODIFIER: Venue Capacity vs Tickets Sold
    double atmosphereModifier = _getAtmosphereModifier(venueLevel, currentFans);

    // --- THE MASTER FORMULA ---
    // FinalRating = (BaseSkill * ChemistryModifier) * HeatMultiplier * AtmosphereModifier
    double finalScore = (baseSkill * chemistryModifier) * heatMultiplier * atmosphereModifier;

    // --- CONVERT TO STAR RATING (Max 5.0) ---
    // A score of 100+ equals a 5-star match.
    double starRating = (finalScore / 100.0) * 5.0;

    // Apply RNG variance (+/- 0.25 stars) to keep it slightly unpredictable
    final rng = Random();
    double variance = (rng.nextDouble() * 0.5) - 0.25; 
    starRating += variance;

    // Clamp the rating between 0.5 and 5.0 stars (Can't go below 0.5, can't exceed 5.0)
    if (starRating > 5.0) starRating = 5.0;
    if (starRating < 0.5) starRating = 0.5;

    // Round to 1 decimal place (e.g., 3.48 -> 3.5)
    return double.parse(starRating.toStringAsFixed(1));
  }

  // =========================================================================
  // HELPER: THE CHEMISTRY MATRIX
  // =========================================================================
  static double _getChemistryModifier(WrestlingStyle s1, WrestlingStyle s2) {
    // Standardize the enums to Archetypes for the math
    String getArchetype(WrestlingStyle style) {
      switch(style) {
        case WrestlingStyle.giant:
        case WrestlingStyle.powerhouse: return "Powerhouse";
        case WrestlingStyle.highFlyer:
        case WrestlingStyle.luchador: return "HighFlyer";
        case WrestlingStyle.brawler:
        case WrestlingStyle.hardcore: return "Brawler";
        case WrestlingStyle.technician: return "Technician";
        default: return "Entertainer";
      }
    }

    String a1 = getArchetype(s1);
    String a2 = getArchetype(s2);

    // Order doesn't matter (Powerhouse vs HighFlyer == HighFlyer vs Powerhouse)
    bool match(String t1, String t2) => (a1 == t1 && a2 == t2) || (a1 == t2 && a2 == t1);

    // The Official Buffs/Penalties
    if (match("Powerhouse", "HighFlyer")) return 1.25; // +25% David vs Goliath
    if (match("Technician", "Technician")) return 1.20; // +20% Wrestling Clinic
    if (match("Brawler", "Brawler")) return 1.15; // +15% Hardcore War
    if (match("Powerhouse", "Powerhouse")) return 0.80; // -20% Slow/Sluggish
    if (match("Technician", "Brawler")) return 0.90; // -10% Style Clash

    return 1.0; // Neutral (No buff, no penalty)
  }

  // =========================================================================
  // HELPER: ATMOSPHERE MODIFIER
  // =========================================================================
  static double _getAtmosphereModifier(int venueLevel, int currentFans) {
    // Venue Capacities: Gym(0)=500, Civic(1)=2500, Arena(2)=15k, Stadium(3)=60k
    int capacity;
    switch(venueLevel) {
      case 1: capacity = 2500; break;
      case 2: capacity = 15000; break;
      case 3: capacity = 60000; break;
      default: capacity = 500; break;
    }

    double fillPercentage = currentFans / capacity;

    if (fillPercentage >= 1.0) {
      return 1.2; // +20% Bonus for a Sold Out, hot crowd!
    } else if (fillPercentage < 0.5) {
      return 0.7; // -30% Penalty for an empty, dead building!
    }
    
    return 1.0; // Normal atmosphere
  }

  // =========================================================================
  // HELPER: RIVALRY FINDER
  // =========================================================================
  static Rivalry? _findActiveRivalry(String nameA, String nameB, List<Rivalry> rivalries) {
    try {
      return rivalries.firstWhere(
        (r) => r.status == RivalryStatus.active &&
              ((r.wrestler1Name == nameA && r.wrestler2Name == nameB) ||
               (r.wrestler1Name == nameB && r.wrestler2Name == nameA))
      );
    } catch (e) {
      return null; // No active rivalry found
    }
  }
}