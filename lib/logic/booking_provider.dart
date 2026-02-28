import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/wrestler.dart';
import '../data/models/match.dart';
import 'game_state_provider.dart';
import 'sound_manager.dart'; 
import 'promoter_provider.dart';
import 'match_rating_engine.dart';
import '../data/models/rivalry.dart' as db; 

class CommentaryLog {
  final String message;
  final String type; 
  final String speaker; 
  CommentaryLog(this.message, [this.type = "MOVE", this.speaker = "VIC"]);
}

class BookingState {
  final List<CommentaryLog> liveLogs;
  final List<Wrestler> participants; 
  final bool isSimulating;
  final bool isFinished; 
  final double currentMatchRating;
  final double momentum;
  final MatchType selectedType;
  final AgentNote selectedNote; 
  final bool isTitleMatch; 
  final Wrestler? selectedWinner;

  BookingState({
    this.liveLogs = const [],
    this.participants = const [],
    this.isSimulating = false,
    this.isFinished = false,
    this.currentMatchRating = 0.0,
    this.momentum = 0.5,
    this.selectedType = MatchType.standard,
    this.selectedNote = AgentNote.standard,
    this.isTitleMatch = false,
    this.selectedWinner,
  });

  BookingState copyWith({
    List<CommentaryLog>? liveLogs,
    List<Wrestler>? participants,
    bool? isSimulating,
    bool? isFinished,
    double? currentMatchRating,
    double? momentum,
    MatchType? selectedType,
    AgentNote? selectedNote,
    bool? isTitleMatch,
    Wrestler? selectedWinner,
  }) {
    return BookingState(
      liveLogs: liveLogs ?? this.liveLogs,
      participants: participants ?? this.participants,
      isSimulating: isSimulating ?? this.isSimulating,
      isFinished: isFinished ?? this.isFinished,
      currentMatchRating: currentMatchRating ?? this.currentMatchRating,
      momentum: momentum ?? this.momentum,
      selectedType: selectedType ?? this.selectedType,
      selectedNote: selectedNote ?? this.selectedNote,
      isTitleMatch: isTitleMatch ?? this.isTitleMatch,
      selectedWinner: selectedWinner ?? this.selectedWinner,
    );
  }
}

class BookingNotifier extends StateNotifier<BookingState> {
  final Ref ref; 
  final Random _rng = Random();
  Timer? _simTimer;

  BookingNotifier(this.ref) : super(BookingState());

  void addParticipant(Wrestler w) {
    if (state.participants.length < 2 && !state.participants.contains(w)) {
      state = state.copyWith(participants: [...state.participants, w]);
    }
  }

  void removeParticipant(Wrestler w) {
    state = state.copyWith(participants: state.participants.where((p) => p != w).toList());
  }

  void setMatchType(MatchType type) => state = state.copyWith(selectedType: type);
  void setAgentNote(AgentNote note) => state = state.copyWith(selectedNote: note); 
  void setTitleMatch(bool isTitle) => state = state.copyWith(isTitleMatch: isTitle);
  void setWinner(Wrestler? w) => state = state.copyWith(selectedWinner: w);
  
  void reset() {
    state = BookingState(participants: []); 
  }

  double calculateShowPacingModifier(List<Match> bookedMatches) {
    double pacingMultiplier = 1.0;
    
    if (bookedMatches.isEmpty) return pacingMultiplier;

    Match opener = bookedMatches.first;
    if (opener.wrestlers.isNotEmpty && opener.wrestlers.length >= 2) {
      Wrestler w1 = opener.wrestlers.elementAt(0);
      Wrestler w2 = opener.wrestlers.elementAt(1);
      
      bool hasFastPaced = (w1.style == WrestlingStyle.highFlyer || w2.style == WrestlingStyle.highFlyer || w1.style == WrestlingStyle.brawler || w2.style == WrestlingStyle.brawler);
      bool isSluggish = (w1.style == WrestlingStyle.powerhouse && w2.style == WrestlingStyle.powerhouse);

      if (hasFastPaced) pacingMultiplier += 0.15; 
      if (isSluggish) pacingMultiplier -= 0.10; 
    }
    
    if (bookedMatches.length == 4) {
      Match slot3 = bookedMatches[2]; 
      Match slot4 = bookedMatches[3]; 
      
      if (slot3.wrestlers.length >= 2 && slot4.wrestlers.length >= 2) {
        int slot3Pop = slot3.wrestlers.elementAt(0).pop + slot3.wrestlers.elementAt(1).pop;
        int slot4Pop = slot4.wrestlers.elementAt(0).pop + slot4.wrestlers.elementAt(1).pop;
        
        if (slot3Pop > slot4Pop) {
          pacingMultiplier -= 0.20; 
        }
      }
    }
    
    return pacingMultiplier;
  }

  Future<void> startMatchSimulation(List<Wrestler> participants) async {
    if (participants.isEmpty) return;
    final gameState = ref.read(gameProvider);
    final rosterState = ref.read(rosterProvider);
    
    double targetRating = 1.0;
    double startRating = 0.5;

    if (participants.length == 2 && state.selectedType != MatchType.promo && state.selectedType != MatchType.ambush) {
      
      List<db.Rivalry> engineRivalries = [];
      for (var localRivalry in rosterState.activeRivalries) {
        engineRivalries.add(
          db.Rivalry(
            wrestler1Name: localRivalry.wrestlerA.name,
            wrestler2Name: localRivalry.wrestlerB.name,
            heat: localRivalry.heat,
            status: db.RivalryStatus.active,
          )
        );
      }

      targetRating = MatchRatingEngine.calculateMatchRating(
        wrestlerA: participants[0],
        wrestlerB: participants[1],
        activeRivalries: engineRivalries, 
        venueLevel: gameState.venueLevel,
        currentFans: gameState.fans, 
      );

      if (state.selectedNote == AgentNote.cleanFinish) targetRating += 0.25; 
      if (state.selectedNote == AgentNote.screwjob) targetRating -= 0.50;    

      if (state.selectedType == MatchType.cage || state.selectedType == MatchType.ladder) targetRating += 0.5;
      if (state.selectedType == MatchType.hardcore) targetRating += 0.25;
      if (state.isTitleMatch) targetRating += 0.5;

    } else {
      double avgMic = participants.fold(0, (sum, w) => sum + w.micSkill) / participants.length;
      targetRating = (avgMic / 20.0); 
    }

    targetRating = targetRating.clamp(0.5, 5.0);

    List<CommentaryLog> initialLogs = [];
    if (targetRating >= 4.0) {
       initialLogs.add(CommentaryLog("The atmosphere in the building is absolutely electric!", "INFO", "VIC"));
    } else if (targetRating <= 1.5) {
       initialLogs.add(CommentaryLog("The crowd seems a bit dead tonight. They need to work hard to win them over.", "INFO", "CYRUS"));
    }

    if (state.selectedNote == AgentNote.screwjob) {
       initialLogs.add(CommentaryLog("I have a bad feeling about this one, Vic. Keep your eyes peeled.", "INFO", "CYRUS"));
    }

    state = state.copyWith(
      isSimulating: true, 
      isFinished: false, 
      liveLogs: initialLogs, 
      currentMatchRating: startRating, 
      momentum: 0.5
    );

    try { ref.read(soundProvider).playSound("bell.mp3"); } catch(e) {}

    List<String> moves = ["Headlock", "Suplex", "DDT", "Chop", "Powerbomb", "Top Rope Move", "Submission Hold"];
    List<String> hardcore = ["Hit with a Trash Can!", "Kendo Stick Shot!", "Thrown through a Table!", "Hit with a Chair!"];
    List<String> cage = ["Thrown into the steel!", "Climbing the cage...", "Diving off the top!", "Smashed into the mesh!"];
    List<String> promos = ["Grabs the mic...", "Insults the local sports team!", "Calls out the champion!", "Crowd is erupting!"];
    List<String> ambushes = ["Attacks from behind!", "It's a chaotic brawl!", "Security is rushing out!", "Low blow!"];

    List<String> currentPool = moves;
    if (state.selectedType == MatchType.hardcore) currentPool = hardcore;
    if (state.selectedType == MatchType.cage) currentPool = cage;
    if (state.selectedType == MatchType.promo) currentPool = promos;
    if (state.selectedType == MatchType.ambush) currentPool = ambushes;

    int duration = 8 + _rng.nextInt(6); 
    int currentTick = 0;
    
    double ratingIncrement = (targetRating - startRating) / duration;
    if (ratingIncrement < 0) ratingIncrement = 0;

    _simTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (!mounted) { timer.cancel(); return; }
      currentTick++;
      
      Wrestler actor = participants[_rng.nextInt(participants.length)];
      String action = currentPool[_rng.nextInt(currentPool.length)];
      
      if (action.contains("Suplex") || action.contains("Powerbomb") || action.contains("Table") || action.contains("steel")) {
         try { ref.read(soundProvider).playSound("slam.mp3"); } catch(e) {}
      }

      if (currentTick >= duration) {
        timer.cancel();
        _finishMatch(participants, targetRating); 
      } else {
        String logText = "${actor.name} performs: $action";
        if (state.selectedType == MatchType.promo) logText = "${actor.name}: $action";
        
        String speaker = _rng.nextBool() ? "VIC" : "CYRUS";

        state = state.copyWith(
          liveLogs: [...state.liveLogs, CommentaryLog(logText, "MOVE", speaker)],
          momentum: (state.momentum + (_rng.nextDouble() * 0.2 - 0.1)).clamp(0.0, 1.0),
          currentMatchRating: (state.currentMatchRating + ratingIncrement).clamp(0.0, 5.0)
        );
      }
    });
  }

  void _finishMatch(List<Wrestler> participants, double finalEngineScore) {
    Wrestler winner = state.selectedWinner ?? participants[_rng.nextInt(participants.length)];
    
    // 🚨 NEW FIX: We now definitively find the loser and save it as a variable!
    String designatedLoser = "Unknown";
    
    if (participants.length == 2) {
      // Find the guy who isn't the winner
      Wrestler loserObj = participants.firstWhere((p) => p.name != winner.name, orElse: () => participants[0]);
      
      // Check for Creative Control Hijack
      if (loserObj.hasCreativeControl && state.selectedWinner != null) {
        winner = loserObj; // Winner is swapped!
        designatedLoser = participants.firstWhere((p) => p.name != winner.name).name;
        state = state.copyWith(
          liveLogs: [...state.liveLogs, CommentaryLog("WAIT! ${loserObj.name} is refusing to follow the script! They just hijacked the match!", "INFO", "VIC")]
        );
      } else {
        designatedLoser = loserObj.name; // Normal finish
      }
    } else if (participants.length == 1) {
      designatedLoser = "Local Jobber";
    }

    String finishText = "🔔 Winner: ${winner.name}!";
    if (state.isTitleMatch) finishText = "🏆 AND NEW CHAMPION: ${winner.name}!";

    if (state.selectedNote == AgentNote.screwjob) {
       finishText = "WAIT! We have a Screwjob! Outside interference costs the match!";
       state = state.copyWith(liveLogs: [...state.liveLogs, CommentaryLog("This is a travesty! The fans are throwing garbage into the ring!", "INFO", "VIC")]);
       try { ref.read(soundProvider).playCrowd("BOO"); } catch(e) {} 
    } else {
       try {
         ref.read(soundProvider).playSound("bell.mp3"); 
         Future.delayed(const Duration(milliseconds: 600), () {
           if (winner.isHeel) ref.read(soundProvider).playCrowd("BOO"); 
           else ref.read(soundProvider).playCrowd("POP");
         });
       } catch(e) {}
    }
    
    final match = Match()
      ..id = 100000
      ..winnerName = winner.name
      ..loserName = designatedLoser // 🚨 THE FIX: Permanently stamp the loser's name here!
      ..type = state.selectedType
      ..agentNote = state.selectedNote 
      ..rating = double.parse(finalEngineScore.toStringAsFixed(1)); 
    
    match.wrestlers.addAll(participants);

    if (participants.length >= 2) {
      if (state.selectedNote == AgentNote.screwjob) {
         ref.read(rosterProvider.notifier).addMatchInteraction(participants[0].name, participants[1].name); 
         ref.read(rosterProvider.notifier).addMatchInteraction(participants[0].name, participants[1].name); 
      } else {
         ref.read(rosterProvider.notifier).addMatchInteraction(participants[0].name, participants[1].name);
      }
    }

    ref.read(gameProvider.notifier).addMatchToCard(match);
    
    state = state.copyWith(
      isSimulating: true, 
      isFinished: true,
      currentMatchRating: finalEngineScore, 
      liveLogs: [...state.liveLogs, CommentaryLog(finishText, "FINISH", "RING")],
    );
  }

  @override
  void dispose() { _simTimer?.cancel(); super.dispose(); }
}

final bookingProvider = StateNotifierProvider.autoDispose<BookingNotifier, BookingState>((ref) => BookingNotifier(ref));