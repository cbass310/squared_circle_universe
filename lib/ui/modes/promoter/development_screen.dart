import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/promoter_provider.dart';
import '../../../logic/game_state_provider.dart'; 
import '../../../data/models/wrestler.dart';
import '../../components/wrestler_avatar.dart';

// --- IMPORT FOR THE WATERMARK ---
import '../../components/tv_watermark.dart';

final scoutingLimitsProvider = StateProvider<Map<String, int>>((ref) => {
  "North America": 0,
  "South America": 0,
  "Asia": 0,
  "Europe": 0,
});

class DevelopmentScreen extends ConsumerStatefulWidget {
  const DevelopmentScreen({super.key});

  @override
  ConsumerState<DevelopmentScreen> createState() => _DevelopmentScreenState();
}

class _DevelopmentScreenState extends ConsumerState<DevelopmentScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Wrestler? _selectedA;
  Wrestler? _selectedB;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getPotentialGrade(int potential) {
    if (potential >= 90) return "A";
    if (potential >= 80) return "B";
    if (potential >= 70) return "C";
    if (potential >= 60) return "D";
    return "F";
  }

  @override
  Widget build(BuildContext context) {
    final rosterState = ref.watch(rosterProvider);
    final gameState = ref.watch(gameProvider); 

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 600; 

        if (isDesktop) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Row(
              children: [
                Expanded(flex: 4, child: _buildDashboard(gameState, rosterState, true)),
                Expanded(flex: 6, child: _buildArtworkPane(isMobile: false)),
              ],
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildArtworkPane(isMobile: true),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black.withOpacity(0.3), Colors.black],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                      const SafeArea(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.school, color: Colors.blueAccent, size: 24),
                                  SizedBox(width: 8),
                                  Text("SCW PIPELINE", style: TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text("SCW ACADEMY", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    color: Colors.black,
                    width: double.infinity,
                    child: _buildDashboard(gameState, rosterState, false),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildDashboard(dynamic gameState, dynamic rosterState, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: isDesktop ? const Color(0xFF121212) : Colors.black,
        border: isDesktop ? const Border(right: BorderSide(color: Colors.black, width: 3)) : null,
      ),
      child: Column(
        children: [
          if (isDesktop)
            const SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Icon(Icons.school, color: Colors.blueAccent, size: 28),
                    SizedBox(width: 12),
                    Text("SCW ACADEMY", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
                  ],
                ),
              ),
            ),
          
          Container(
            color: Colors.black, 
            child: TabBar(
              dividerColor: Colors.transparent, 
              controller: _tabController,
              indicatorColor: Colors.blueAccent,
              indicatorWeight: 3,
              labelColor: Colors.blueAccent,
              unselectedLabelColor: Colors.white54,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.5),
              tabs: const [
                Tab(text: "SCOUTING"),
                Tab(text: "TRAINING"),
                Tab(text: "SPARRING"),
              ],
            ),
          ),
          
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildScoutingTab(gameState, rosterState),
                _buildTrainingTab(rosterState, gameState),
                _buildSparringTab(rosterState),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtworkPane({required bool isMobile}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/images/gym_background.png", 
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (c, e, s) => Container(color: const Color(0xFF151515)),
        ),
        if (!isMobile)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.black.withOpacity(0.95), Colors.black.withOpacity(0.4), Colors.transparent],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),
        TVWatermark(isMobile: isMobile),
      ],
    );
  }

  Widget _buildScoutingTab(dynamic gameState, dynamic rosterState) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("GLOBAL SCOUTING", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        const SizedBox(height: 16),
        
        _buildRegionCard(gameState, "North America", 1, 500, "Gym", "assets/images/scout_usa.png"),
        _buildRegionCard(gameState, "South America", 2, 1000, "Civic Center", "assets/images/scout_mexico.png"),
        _buildRegionCard(gameState, "Asia", 3, 2500, "State Arena", "assets/images/scout_japan.png"),
        _buildRegionCard(gameState, "Europe", 4, 5000, "Global Stadium", "assets/images/scout_uk.png"),
        
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.05), 
            borderRadius: BorderRadius.circular(8), 
            border: Border.all(color: Colors.blueAccent.withOpacity(0.3))
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blueAccent, size: 24),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  "Each region holds a hidden pool of prospects. Pay the scouting fee to pull a random prospect from the region. Will you find a generational talent, or a complete bust?", 
                  style: TextStyle(color: Colors.blueAccent, fontSize: 11, height: 1.5)
                )
              ),
            ],
          ),
        ),
        const SizedBox(height: 40), 
      ],
    );
  }

  Widget _buildRegionCard(dynamic gameState, String name, int requiredLevel, int cost, String venueName, String imagePath) {
    final scoutLimits = ref.watch(scoutingLimitsProvider);
    
    bool isLockedByVenue = gameState.venueLevel < requiredLevel;
    int scoutCount = scoutLimits[name] ?? 0;
    bool isDepleted = scoutCount >= 5;
    
    bool isCardDisabled = isLockedByVenue || isDepleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 80, 
      decoration: BoxDecoration(
        color: isCardDisabled ? const Color(0xFF151515) : const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10, width: 1), 
        boxShadow: isCardDisabled ? [] : [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(11), bottomLeft: Radius.circular(11)),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
                colorFilter: isCardDisabled ? const ColorFilter.mode(Colors.grey, BlendMode.saturation) : null,
              ),
            ),
            child: isCardDisabled ? Container(color: Colors.black.withOpacity(0.7), child: const Icon(Icons.lock, color: Colors.white54)) : null,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name.toUpperCase(), style: TextStyle(color: isCardDisabled ? Colors.white30 : Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                  const SizedBox(height: 4),
                  if (isDepleted)
                    const Text("REGION DEPLETED (5/5)", style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold))
                  else if (isLockedByVenue)
                    Text("REQUIRES: ${venueName.toUpperCase()}", style: const TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold))
                  else
                    Text("COST: \$$cost  •  FOUND: $scoutCount/5", style: const TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          if (!isCardDisabled)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent.withOpacity(0.2), 
                  foregroundColor: Colors.blueAccent,
                  side: BorderSide(color: Colors.blueAccent.withOpacity(0.5)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  elevation: 0,
                ),
                child: const Text("SCOUT", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                onPressed: () => _runScoutingLogic(name, cost, gameState), 
              ),
            ),
        ],
      ),
    );
  }

  void _runScoutingLogic(String regionName, int cost, dynamic gameState) async {
    HapticFeedback.heavyImpact();
    if (gameState.cash < cost) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Insufficient funds!"), backgroundColor: Colors.red));
      return;
    }

    showDialog(context: context, barrierDismissible: false, builder: (ctx) => const Center(child: CircularProgressIndicator(color: Colors.blueAccent)));

    final newlyScoutedWrestler = await ref.read(rosterProvider.notifier).scoutRegion(regionName, cost);
    await Future.delayed(const Duration(seconds: 1)); 
    
    if (mounted) Navigator.pop(context); 

    if (mounted) {
      if (newlyScoutedWrestler != null) {
        
        ref.read(scoutingLimitsProvider.notifier).update((state) {
          final newState = Map<String, int>.from(state);
          newState[regionName] = (newState[regionName] ?? 0) + 1;
          return newState;
        });

        String potentialGrade = _getPotentialGrade(newlyScoutedWrestler.potentialSkill);

        showDialog(
          context: context,
          barrierDismissible: false, 
          builder: (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.blueAccent, width: 2)),
            title: const Column(
              children: [
                Icon(Icons.public, color: Colors.blueAccent, size: 40),
                SizedBox(height: 10),
                Text("NEW PROSPECT FOUND!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.0)),
              ]
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Your scouts in $regionName have discovered:", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 15),
                Text(newlyScoutedWrestler.name.toUpperCase(), style: const TextStyle(color: Colors.amber, fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("POP: ${newlyScoutedWrestler.pop.toInt()} | RING: ${newlyScoutedWrestler.ringSkill.toInt()}", style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold)),
                    const Text("  •  ", style: TextStyle(color: Colors.white24)),
                    Text("POTENTIAL: $potentialGrade", style: const TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                
                const SizedBox(height: 20),
                const Text("Sign them to your active roster now, or they will walk to Global Free Agency.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic, fontSize: 11)),
              ]
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${newlyScoutedWrestler.name} entered Free Agency."), backgroundColor: Colors.grey));
                    },
                    child: const Text("FREE AGENCY", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent, foregroundColor: Colors.black),
                    onPressed: () async {
                      try {
                        await ref.read(rosterProvider.notifier).hireWrestler(newlyScoutedWrestler);
                        if (mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${newlyScoutedWrestler.name} signed to the roster!"), backgroundColor: Colors.green));
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
                        }
                      }
                    },
                    child: const Text("SIGN NOW", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              )
            ],
          )
        );
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.grey, width: 2)),
            title: const Text("SCOUTING FAILED", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
            content: const Text("Your scouts scoured the area but couldn't find anyone worth signing this week.", style: TextStyle(color: Colors.white70, height: 1.5)),
            actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK", style: TextStyle(color: Colors.grey)))],
          )
        );
      }
    }
  }

  Widget _buildTrainingTab(dynamic state, dynamic gameState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text("ROSTER DEVELOPMENT", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: state.roster.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final wrestler = state.roster[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E), 
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10, width: 1), 
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    iconColor: Colors.blueAccent,
                    collapsedIconColor: Colors.white54,
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[800],
                      radius: 20,
                      child: Text(wrestler.name[0], style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold))
                    ),
                    title: Row(
                      children: [
                        Text(wrestler.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                        if (wrestler.pop >= wrestler.popPotential)
                          const Padding(
                            padding: EdgeInsets.only(left: 6.0),
                            child: Icon(Icons.star, color: Colors.amber, size: 12),
                          ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        children: [
                          Text("POP: ${wrestler.pop.toInt()}", style: const TextStyle(color: Colors.purpleAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                          const Text(" • ", style: TextStyle(color: Colors.white24, fontSize: 10)),
                          Text("RING: ${wrestler.ringSkill.toInt()}", style: const TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          border: Border(top: BorderSide(color: Colors.white10, width: 1)) 
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildTrainButton(wrestler, "MIC SKILL", 500, Colors.purpleAccent, gameState),
                            _buildTrainButton(wrestler, "POPULARITY", 1000, Colors.orangeAccent, gameState),
                            _buildTrainButton(wrestler, "RING SKILL", 750, Colors.greenAccent, gameState),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrainButton(Wrestler w, String type, int cost, Color defaultColor, dynamic gameState) {
    // 🚨 THE FIX: Determine if the wrestler has hit their cap for this specific stat
    bool isMaxed = false;
    if (type == "POPULARITY" && w.pop >= w.popPotential) isMaxed = true;
    if (type == "RING SKILL" && w.ringSkill >= 100) isMaxed = true;
    if (type == "MIC SKILL" && w.micSkill >= 100) isMaxed = true;

    Color buttonColor = isMaxed ? Colors.redAccent : defaultColor;
    String buttonText = isMaxed ? "MAXED" : "\$$cost";

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor.withOpacity(0.1), 
            foregroundColor: buttonColor,
            side: BorderSide(color: buttonColor.withOpacity(0.5)),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          onPressed: isMaxed ? () {
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${w.name} has reached their maximum potential for $type!"), backgroundColor: Colors.redAccent));
          } : () => _runTrainingLogic(w, type, cost, gameState, buttonColor), 
          child: Column(
            children: [
              Text(type, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
              const SizedBox(height: 4),
              Text(buttonText, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isMaxed ? Colors.redAccent : Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  // 🚨 THE FIX: Removed the rogue setState that was forcing stats up artificially.
  // Now it waits for the provider to do the official math and refresh the screen.
  void _runTrainingLogic(Wrestler w, String type, int cost, dynamic gameState, Color color) async {
    if (gameState.cash < cost) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Insufficient Funds!"), backgroundColor: Colors.red));
      return;
    }

    HapticFeedback.lightImpact();

    try {
      // Let the backend handle the logic and caps
      await ref.read(rosterProvider.notifier).trainingAction(w, type, cost);
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: color, width: 2)),
            title: Row(
              children: [
                Icon(Icons.fitness_center, color: color),
                const SizedBox(width: 10),
                const Text("TRAINING COMPLETE", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              ]
            ),
            content: Text("${w.name} successfully leveled up their $type!", style: const TextStyle(color: Colors.white70)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: Text("AWESOME", style: TextStyle(color: color, fontWeight: FontWeight.bold))),
            ],
          )
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
      }
    }
  }

  Widget _buildSparringTab(dynamic state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.redAccent.withOpacity(0.3))),
            child: const Column(
              children: [
                Icon(Icons.sports_mma, color: Colors.redAccent, size: 20),
                SizedBox(height: 8),
                Text("PRACTICE MATCH SIMULATOR", style: TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                SizedBox(height: 4),
                Text("Select 2 Wrestlers to spar. They gain Ring XP but lose Stamina.", style: TextStyle(color: Colors.white70, fontSize: 10), textAlign: TextAlign.center),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildSparringList(state, true)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text("VS", style: TextStyle(color: Colors.white24, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 16)),
                ),
                Expanded(child: _buildSparringList(state, false)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.flash_on, size: 20),
              label: const Text("START SESSION", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0, fontSize: 13)),
              style: ElevatedButton.styleFrom(
                backgroundColor: (_selectedA != null && _selectedB != null && _selectedA != _selectedB) ? Colors.redAccent : const Color(0xFF1A1A1A), 
                foregroundColor: (_selectedA != null && _selectedB != null && _selectedA != _selectedB) ? Colors.white : Colors.white30,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _selectedA != null && _selectedB != null && _selectedA != _selectedB 
                ? _runSparringEngineHook 
                : null,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSparringList(dynamic state, bool isSideA) {
    Wrestler? selected = isSideA ? _selectedA : _selectedB;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(color: isSideA ? Colors.blue.withOpacity(0.2) : Colors.amber.withOpacity(0.2), borderRadius: const BorderRadius.vertical(top: Radius.circular(8))),
          child: Text(isSideA ? "CORNER A" : "CORNER B", textAlign: TextAlign.center, style: TextStyle(color: isSideA ? Colors.blueAccent : Colors.amber, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)), border: Border.all(color: Colors.white10, width: 1)), 
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: state.roster.length,
              itemBuilder: (context, index) {
                final w = state.roster[index];
                final isSelected = selected == w;
                Color activeColor = isSideA ? Colors.blueAccent : Colors.amber;

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      if (isSideA) { _selectedA = w; } else { _selectedB = w; }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? activeColor.withOpacity(0.2) : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: isSelected ? activeColor : Colors.transparent),
                    ),
                    child: Text(w.name.toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: isSelected ? activeColor : Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // 🚨 THE FIX: Removed manual UI overrides here too. Let the backend do the exact math!
  Future<void> _runSparringEngineHook() async {
    HapticFeedback.heavyImpact();

    final result = await ref.read(rosterProvider.notifier).runPracticeMatch(_selectedA!, _selectedB!);
    
    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.redAccent, width: 2)),
          title: const Row(
            children: [
              Icon(Icons.sports_mma, color: Colors.redAccent),
              SizedBox(width: 10),
              Text("SESSION REPORT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(result, style: const TextStyle(color: Colors.white70, height: 1.5)),
              const SizedBox(height: 16),
              const Text("Both wrestlers gained +2 Ring Skill and lost -25% Stamina.", style: TextStyle(color: Colors.orangeAccent, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("DISMISS", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)), 
              onPressed: () {
                setState(() { _selectedA = null; _selectedB = null; });
                Navigator.pop(ctx);
              }
            )
          ],
        ),
      );
    }
  }
}