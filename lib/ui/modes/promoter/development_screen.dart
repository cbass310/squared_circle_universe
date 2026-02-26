import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/promoter_provider.dart';
import '../../../logic/game_state_provider.dart'; 
import '../../../data/models/wrestler.dart';

class DevelopmentScreen extends ConsumerStatefulWidget {
  const DevelopmentScreen({super.key});

  @override
  ConsumerState<DevelopmentScreen> createState() => _DevelopmentScreenState();
}

class _DevelopmentScreenState extends ConsumerState<DevelopmentScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Sparring Selection State
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
    
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: isDesktop
            ? Row(
                children: [
                  Expanded(flex: 4, child: _buildLeftDashboard(gameState, rosterState, isDesktop)),
                  Expanded(flex: 6, child: _buildRightArtworkPane(isMobile: false)),
                ],
              )
            : Column(
                children: [
                  Expanded(flex: 4, child: _buildRightArtworkPane(isMobile: true)),
                  Expanded(flex: 6, child: _buildLeftDashboard(gameState, rosterState, isDesktop)),
                ],
              ),
      ),
    );
  }

  // =====================================================================
  // --- LEFT PANE: THE POWER PLANT DASHBOARD
  // =====================================================================
  Widget _buildLeftDashboard(dynamic gameState, dynamic rosterState, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        border: isDesktop ? const Border(right: BorderSide(color: Colors.black, width: 3)) : const Border(top: BorderSide(color: Colors.black, width: 3)),
      ),
      child: Column(
        children: [
          // --- HEADER ---
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: const [
                Icon(Icons.flash_on, color: Colors.amber, size: 28),
                SizedBox(width: 12),
                Text("POWER PLANT", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
              ],
            ),
          ),
          
          // --- TABS ---
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black, width: 3)), 
              color: Color(0xFF121212),
            ),
            child: TabBar(
              dividerColor: Colors.transparent, 
              controller: _tabController,
              indicatorColor: Colors.amber,
              indicatorWeight: 3,
              labelColor: Colors.amber,
              unselectedLabelColor: Colors.white54,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.5),
              tabs: const [
                Tab(text: "SCOUTING"),
                Tab(text: "TRAINING"),
                Tab(text: "SPARRING"),
              ],
            ),
          ),
          
          // --- TAB CONTENT ---
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildScoutingTab(gameState),
                _buildTrainingTab(rosterState, gameState),
                _buildSparringTab(rosterState),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // --- RIGHT PANE: ARTWORK
  // =====================================================================
  Widget _buildRightArtworkPane({bool isMobile = false}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/images/gym_background.png", 
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (c, e, s) => Image.asset("assets/images/office_background.png", fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(color: const Color(0xFF0A0A0A))),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.black.withOpacity(0.95), Colors.black.withOpacity(0.4), Colors.black.withOpacity(0.8)],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
        Positioned(
          bottom: 40, right: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.fitness_center, size: 50, color: Colors.white10),
              const SizedBox(height: 10),
              Text("FUTURE STARS", style: TextStyle(fontSize: isMobile ? 20 : 32, fontWeight: FontWeight.bold, color: Colors.white24, letterSpacing: 4.0)),
              Text("DEVELOPMENT CENTER", style: TextStyle(fontSize: isMobile ? 10 : 14, color: Colors.amber.withOpacity(0.5), letterSpacing: 2.0, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // TAB 1: SCOUTING 
  // ===========================================================================
  Widget _buildScoutingTab(dynamic gameState) {
    bool isScoutingClosed = gameState.week > 26;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("GLOBAL SCOUTING NETWORK", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            Text(isScoutingClosed ? "SEASON CLOSED" : "SEASON ACTIVE (Wks 1-26)", style: TextStyle(color: isScoutingClosed ? Colors.redAccent : Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        
        _buildRegionCard(gameState, "North America", 1, 500, "Gym", "assets/images/scout_usa.png", isScoutingClosed),
        _buildRegionCard(gameState, "Mexico & Canada", 2, 1000, "Civic Center", "assets/images/scout_mexico.png", isScoutingClosed),
        _buildRegionCard(gameState, "Japan & Asia", 3, 2500, "Arena", "assets/images/scout_japan.png", isScoutingClosed),
        _buildRegionCard(gameState, "United Kingdom & Europe", 4, 5000, "Stadium", "assets/images/scout_uk.png", isScoutingClosed),
        
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isScoutingClosed ? Colors.red.withOpacity(0.05) : Colors.amber.withOpacity(0.05), 
            borderRadius: BorderRadius.circular(8), 
            border: Border.all(color: isScoutingClosed ? Colors.red.withOpacity(0.3) : Colors.amber.withOpacity(0.3))
          ),
          child: Row(
            children: [
              Icon(isScoutingClosed ? Icons.warning_amber_rounded : Icons.info_outline, color: isScoutingClosed ? Colors.redAccent : Colors.amber, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isScoutingClosed 
                    ? "The scouting season is over! Remaining prospects have entered the global Free Agent pool. Check back in Week 1!" 
                    : "Each region holds 5 hidden prospects. At Week 26, all unscouted prospects enter Global Free Agency!", 
                  style: TextStyle(color: isScoutingClosed ? Colors.redAccent : Colors.amber, fontSize: 11)
                )
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRegionCard(dynamic gameState, String name, int requiredLevel, int cost, String venueName, String imagePath, bool isScoutingClosed) {
    bool isLockedByVenue = gameState.venueLevel < requiredLevel;
    bool isCardDisabled = isLockedByVenue || isScoutingClosed;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 80, 
      decoration: BoxDecoration(
        color: isCardDisabled ? const Color(0xFF151515) : const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 2), 
        boxShadow: isCardDisabled ? [] : [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(
            width: 90,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
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
                  Text(name.toUpperCase(), style: TextStyle(color: isCardDisabled ? Colors.white30 : Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                  const SizedBox(height: 4),
                  if (isScoutingClosed)
                    const Text("OFF-SEASON", style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold))
                  else if (isLockedByVenue)
                    Text("REQUIRES: ${venueName.toUpperCase()}", style: const TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold))
                  else
                    Text("COST: \$$cost", style: const TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.bold)),
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
                child: const Text("SCOUT", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                onPressed: () => _runScoutingLogic(name, cost, gameState), 
              ),
            ),
        ],
      ),
    );
  }

  // 🚀 ENGINE HOOK: SCOUTING 
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
        String potentialGrade = _getPotentialGrade(newlyScoutedWrestler.potentialSkill);

        showDialog(
          context: context,
          barrierDismissible: false, 
          builder: (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.blueAccent, width: 2)),
            title: Column(
              children: const [
                Icon(Icons.public, color: Colors.blueAccent, size: 40),
                SizedBox(height: 10),
                Text("NEW PROSPECT FOUND!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1.5)),
              ]
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Your scouts in $regionName have discovered:", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 15),
                Text(newlyScoutedWrestler.name.toUpperCase(), style: const TextStyle(color: Colors.amber, fontSize: 24, fontWeight: FontWeight.bold)),
                
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("POP: ${newlyScoutedWrestler.pop.toInt()} | RING: ${newlyScoutedWrestler.ringSkill.toInt()}", style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                    const Text("  •  ", style: TextStyle(color: Colors.white24)),
                    Text("POTENTIAL: $potentialGrade", style: const TextStyle(color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
                
                const SizedBox(height: 20),
                const Text("You hold exclusive signing rights until Week 26.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic, fontSize: 11)),
              ]
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text("DECIDE LATER", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
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
                    child: const Text("SIGN NOW", style: TextStyle(fontWeight: FontWeight.bold)),
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
            title: const Text("REGION DEPLETED", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            content: const Text("Your scouts scoured the area, but the 5 regional prospects have already been found. Check a different region!", style: TextStyle(color: Colors.white70)),
            actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK", style: TextStyle(color: Colors.grey)))],
          )
        );
      }
    }
  }

  // ===========================================================================
  // TAB 2: TRAINING 
  // ===========================================================================
  Widget _buildTrainingTab(dynamic state, dynamic gameState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Text("ROSTER DEVELOPMENT", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: state.roster.length,
            padding: const EdgeInsets.all(20),
            itemBuilder: (context, index) {
              final wrestler = state.roster[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E), 
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 2), 
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    iconColor: Colors.amber,
                    collapsedIconColor: Colors.white54,
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[800],
                      radius: 20,
                      child: Text(wrestler.name[0], style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold))
                    ),
                    title: Text(wrestler.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
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
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          border: Border(top: BorderSide(color: Colors.black, width: 2)) 
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

  Widget _buildTrainButton(Wrestler w, String type, int cost, Color color, dynamic gameState) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color.withOpacity(0.1), 
            foregroundColor: color,
            side: BorderSide(color: color.withOpacity(0.5)),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          child: Column(
            children: [
              Text(type, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
              const SizedBox(height: 4),
              Text("\$$cost", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          onPressed: () => _runTrainingLogic(w, type, cost, gameState, color), 
        ),
      ),
    );
  }

  void _runTrainingLogic(Wrestler w, String type, int cost, dynamic gameState, Color color) {
    if (gameState.cash < cost) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Insufficient Funds!"), backgroundColor: Colors.red));
      return;
    }

    HapticFeedback.lightImpact();

    setState(() {
      try {
        if (type == "POPULARITY") {
          w.pop += 3;
          if (w.pop > 100) w.pop = 100;
        } else if (type == "RING SKILL") {
          w.ringSkill += 3;
          if (w.ringSkill > 100) w.ringSkill = 100;
        } else {
          w.pop += 1; 
        }
      } catch (e) {
      }
    });

    ref.read(rosterProvider.notifier).trainingAction(w, type, cost);
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: color, width: 2)),
        title: Row(
          children: [
            Icon(Icons.fitness_center, color: color),
            const SizedBox(width: 10),
            const Text("TRAINING COMPLETE", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ]
        ),
        content: Text("${w.name} successfully leveled up their $type!", style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("AWESOME", style: TextStyle(color: color, fontWeight: FontWeight.bold))),
        ],
      )
    );
  }

  // ===========================================================================
  // TAB 3: SPARRING
  // ===========================================================================
  Widget _buildSparringTab(dynamic state) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.redAccent.withOpacity(0.3))),
            child: Column(
              children: const [
                Icon(Icons.sports_mma, color: Colors.redAccent, size: 24),
                SizedBox(height: 8),
                Text("PRACTICE MATCH SIMULATOR", style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                SizedBox(height: 4),
                Text("Select 2 Wrestlers to spar. They will gain Ring XP but lose Stamina.", style: TextStyle(color: Colors.white70, fontSize: 11), textAlign: TextAlign.center),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildSparringList(state, true)),
                const SizedBox(width: 16),
                const Text("VS", style: TextStyle(color: Colors.white24, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 20)),
                const SizedBox(width: 16),
                Expanded(child: _buildSparringList(state, false)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.flash_on, size: 24),
              label: const Text("START SPARRING SESSION", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 14)),
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
          child: Text(isSideA ? "CORNER A" : "CORNER B", textAlign: TextAlign.center, style: TextStyle(color: isSideA ? Colors.blueAccent : Colors.amber, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)), border: Border.all(color: Colors.black, width: 2)), 
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
                    child: Text(w.name.toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: isSelected ? activeColor : Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _runSparringEngineHook() async {
    HapticFeedback.heavyImpact();

    setState(() {
      try {
        _selectedA!.ringSkill += 2;
        if (_selectedA!.ringSkill > 100) _selectedA!.ringSkill = 100;
        _selectedA!.stamina -= 25;
        if (_selectedA!.stamina < 0) _selectedA!.stamina = 0;

        _selectedB!.ringSkill += 2;
        if (_selectedB!.ringSkill > 100) _selectedB!.ringSkill = 100;
        _selectedB!.stamina -= 25;
        if (_selectedB!.stamina < 0) _selectedB!.stamina = 0;
      } catch (e) {}
    });

    final result = await ref.read(rosterProvider.notifier).runPracticeMatch(_selectedA!, _selectedB!);
    
    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.redAccent, width: 2)),
          title: Row(
            children: const [
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