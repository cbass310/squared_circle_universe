import 'dart:math';
import '../models/wrestler.dart';

class RosterGenerator {
  final Random _rng = Random();

  final List<Map<String, dynamic>> _legends = [
    {
      "name": "The Iron Saint",
      "style": WrestlingStyle.brawler,
      "pop": 95,
      "ringSkill": 85,
      "micSkill": 80,
      "isHeel": false,
      "image": "assets/images/legend_saint.png",
      "finish": "Saint's Judgment",
      "greed": 40,
      "loyalty": 95
    },
    {
      "name": "Velvet Rico",
      "style": WrestlingStyle.entertainer,
      "pop": 92,
      "ringSkill": 75,
      "micSkill": 99,
      "isHeel": true,
      "image": "assets/images/legend_rico.png",
      "finish": "Velvet Touch",
      "greed": 95,
      "loyalty": 20
    },
    {
      "name": "Tank Smasher",
      "style": WrestlingStyle.giant,
      "pop": 88,
      "ringSkill": 60,
      "micSkill": 40,
      "isHeel": true,
      "image": "assets/images/legend_tank.png",
      "finish": "Tank Tread",
      "greed": 60,
      "loyalty": 50
    },
    {
      "name": "Kid Aerial",
      "style": WrestlingStyle.highFlyer,
      "pop": 85,
      "ringSkill": 95,
      "micSkill": 65,
      "isHeel": false,
      "image": "assets/images/avatar_highflyer.png",
      "finish": "Sky High",
      "greed": 30,
      "loyalty": 80
    }
  ];

  final List<String> _firstNames = [
    "Ace", "Axel", "Big", "Billy", "Blade", "Boomer", "Brock", "Bubba", "Butch", "Cash",
    "Chad", "Chief", "Clay", "Colt", "Crash", "Cyrus", "Dallas", "Dane", "Dash", "Deacon",
    "Duke", "Dusty", "Flash", "Gator", "Gunner", "Hank", "Hawk", "Holt", "Hulk", "Iron",
    "Jax", "Johnny", "Kane", "King", "Knox", "Lance", "Lex", "Luther", "Mack", "Magnus",
    "Max", "Mojo", "Otis", "Rex", "Rico", "Rip", "Rocco", "Rock", "Rowdy", "Ryker",
    "Sarge", "Scott", "Slash", "Spike", "Steel", "Stone", "Storm", "Tank", "Tex", "Thor",
    "Titus", "Tommy", "Tray", "Trent", "Trevor", "Tyson", "Vance", "Vic", "Viper", "Wolf"
  ];

  final List<String> _lastNames = [
    "Adams", "Anderson", "Armstrong", "Atlas", "Banks", "Barbarian", "Bass", "Bishop", "Black", "Blade",
    "Bolt", "Bones", "Bragg", "Bravo", "Cage", "Cannon", "Carter", "Castle", "Clark", "Cobb",
    "Cross", "Danger", "Daniels", "Davis", "Decker", "Drake", "Duke", "Dunn", "Evans", "Falcon",
    "Force", "Ford", "Fox", "Fury", "Gage", "Gamble", "Graves", "Griffin", "Grimm", "Gunn",
    "Hall", "Hammer", "Hart", "Hawk", "Hayes", "Hendrix", "Hogan", "Holt", "Hooks", "Hughes",
    "Hunter", "Irons", "Jackson", "James", "Jax", "Jones", "Kane", "King", "Knight", "Knox",
    "Law", "Lee", "Lewis", "Locke", "Long", "Love", "Lynch", "Mack", "Mann", "Mars",
    "Mason", "Masters", "Maxx", "Mayhem", "Michaels", "Miller", "Monroe", "Moore", "Morgan", "Moss",
    "Nash", "Nixon", "North", "Orton", "Outlaw", "Page", "Parks", "Payne", "Pierce", "Power"
  ];

  List<Wrestler> generateStartingRoster(int count) {
    List<Wrestler> roster = [];
    
    // 1. INJECT LEGENDS
    for (int i = 0; i < 2; i++) {
      if (i < _legends.length) {
        roster.add(_createLegend(i));
      }
    }

    // 2. FILL ROSTER
    for (int i = 2; i < count; i++) {
      roster.add(_createRandomWrestler(i, isStar: i < 5));
    }

    // 3. ASSIGN CHAMPIONSHIPS
    roster.sort((a, b) => b.pop.compareTo(a.pop)); 
    
    if (roster.isNotEmpty) {
      roster[0].isChampion = true; 
      roster[0].morale = 100;
      
      if (roster.length > 4) {
        roster[3].isTVChampion = true; 
        roster[3].morale = 100;
        roster[3].ringSkill = (roster[3].ringSkill + 10).clamp(0, 100); 
      }
    }
    
    return roster;
  }

  List<Wrestler> generateFreeAgents(int count) {
    List<Wrestler> agents = [];
    for (int i = 2; i < _legends.length; i++) {
      agents.add(_createLegend(i));
    }
    int needed = count - agents.length;
    for (int i = 0; i < needed; i++) {
      agents.add(_createRandomWrestler(i + 100, isStar: false));
    }
    return agents;
  }

  Wrestler _createLegend(int index) {
    final data = _legends[index];
    final w = Wrestler();
    w.name = data['name'];
    w.style = data['style'];
    w.pop = data['pop'];
    w.ringSkill = data['ringSkill'];
    w.micSkill = data['micSkill'];
    w.isHeel = data['isHeel'];
    w.imagePath = data['image'];
    w.stamina = 100;
    w.morale = 100;
    
    // Universal Contract Stats
    w.greed = data['greed'] ?? 50;
    w.loyalty = data['loyalty'] ?? 50;
    w.salary = (w.pop * 10).clamp(500, 20000); 
    w.contractedPop = w.pop; // Lock starting pop
    
    return w;
  }

  Wrestler _createRandomWrestler(int idSeed, {required bool isStar}) {
    final w = Wrestler();
    String first = _firstNames[_rng.nextInt(_firstNames.length)];
    String last = _lastNames[_rng.nextInt(_lastNames.length)];
    w.name = "$first $last";
    
    int baseStat = isStar ? 70 : 40;
    int variance = _rng.nextInt(20);
    w.pop = (baseStat + variance).clamp(10, 100);
    w.ringSkill = (baseStat + _rng.nextInt(15)).clamp(10, 100);
    w.micSkill = (baseStat + _rng.nextInt(15)).clamp(10, 100);
    w.stamina = 100;
    w.morale = 100;

    int styleRoll = _rng.nextInt(5);
    switch (styleRoll) {
      case 0:
        w.style = WrestlingStyle.brawler;
        w.imagePath = "assets/images/avatar_brawler.png";
        break;
      case 1:
        w.style = WrestlingStyle.technician;
        w.imagePath = "assets/images/avatar_technician.png";
        break;
      case 2:
        w.style = WrestlingStyle.highFlyer;
        w.imagePath = "assets/images/avatar_highflyer.png";
        break;
      case 3:
        w.style = WrestlingStyle.giant;
        w.imagePath = "assets/images/avatar_giant.png";
        break;
      case 4:
        w.style = WrestlingStyle.entertainer;
        w.imagePath = "assets/images/avatar_entertainer.png";
        break;
    }
    
    if (w.style == WrestlingStyle.giant) {
      w.ringSkill -= 10;
      w.pop += 10;
    }
    if (w.style == WrestlingStyle.highFlyer) {
      w.ringSkill += 10;
      w.pop -= 5;
    }

    w.isHeel = _rng.nextBool();
    
    // Universal Contract Stats
    w.greed = 20 + _rng.nextInt(75); // Random personality!
    w.loyalty = 20 + _rng.nextInt(75);
    w.salary = (w.pop * 10) + _rng.nextInt(500); 
    w.contractedPop = w.pop; // Lock starting pop
    
    return w;
  }
}