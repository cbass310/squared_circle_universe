import 'package:isar/isar.dart';

part 'wrestler.g.dart'; // REQUIRED FOR ISAR

enum WrestlingStyle {
  brawler,
  technician,
  highFlyer,
  powerhouse,
  giant,
  luchador,
  entertainer,
  hardcore
}

// 🚨 NEW: Track if they are a Standard worker or a Special Attraction
enum ContractType {
  standard,
  specialAttraction,
  partTime
}

@collection
class Wrestler {
  Id id = Isar.autoIncrement;

  late String name;
  
  @enumerated
  late WrestlingStyle style;

  // --- CORE STATS ---
  int pop = 50;
  int ringSkill = 50;
  int micSkill = 50;
  int stamina = 100;
  int condition = 100;
  int morale = 100;
  int gimmickStaleness = 0;

  // 🚨 NEW: The hard cap to prevent players from buying their way to 99
  int popPotential = 85; 

  // 🚨 NEW: Tracks ring time for organic growth
  int matchesWorked = 0; 

  // --- STATUS ---
  bool isHeel = false;
  bool isChampion = false;
  bool isTVChampion = false;
  String cardPosition = "Opener"; 
  int companyId = -1; // -1 = Free Agent, 0 = Player, 1 = Rival
  
  String? imagePath; // Kept for local generic default assets
  String? imageUrl;  // 🖼️ NEW: Stores the web link from the JSON mod!

  // --- INJURY & REHAB SYSTEM ---
  bool isInjured = false;
  int injuryWeeks = 0;
  bool isOnIR = false; 

  // --- SCOUTING & DEVELOPMENT ---
  int potentialSkill = 80;   
  bool isScouted = true;     
  bool isRookie = false;     

  // =========================================================
  // --- NEW UNIVERSAL CONTRACT ENGINE ---
  // =========================================================
  
  @enumerated
  ContractType contractType = ContractType.standard; // 🚨 NEW: Defaults to standard

  int salary = 500;            
  int upfrontBonus = 0;        
  int contractWeeks = 12;      

  // 🚨 NEW: The 8-week lockout timer for Mega-Stars entering Free Agency
  int cooldownUntilWeek = 0; 

  bool hasCreativeControl = false; 
  bool isHoldingOut = false;       
  int contractedPop = 50;          

  int greed = 50;         
  int loyalty = 50;       
  int desireToWin = 50;

    // --- THE PROMISES SYSTEM ---
  String activePromise = ""; // e.g., "TITLE_RUN", "PAY_RAISE"
  int promiseDeadline = 0;   // Weeks left to fulfill it
}