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

  // --- STATUS ---
  bool isHeel = false;
  bool isChampion = false;
  bool isTVChampion = false;
  String cardPosition = "Opener"; 
  int companyId = -1; // -1 = Free Agent, 0 = Player, 2 = Empire
  String? imagePath;

  // --- INJURY & REHAB SYSTEM ---
  bool isInjured = false;
  int injuryWeeks = 0;
  bool isOnIR = false; // <-- The query builder needs this!

  // --- SCOUTING & DEVELOPMENT ---
  int potentialSkill = 80;   
  bool isScouted = true;     
  bool isRookie = false;     // <-- The query builder needs this!

  // =========================================================
  // --- NEW UNIVERSAL CONTRACT ENGINE ---
  // =========================================================
  
  int salary = 500;            
  int upfrontBonus = 0;        
  int contractWeeks = 12;      

  bool hasCreativeControl = false; 
  bool isHoldingOut = false;       
  int contractedPop = 50;          

  int greed = 50;         
  int loyalty = 50;       
  int desireToWin = 50;   
}