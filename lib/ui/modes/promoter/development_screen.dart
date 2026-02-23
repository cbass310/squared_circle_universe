import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final rosterState = ref.watch(rosterProvider);
    final gameState = ref.watch(gameProvider); 

    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          // ---------------------------------------------------------
          // LEFT COLUMN: CONTROLS (40%)
          // ---------------------------------------------------------
          Expanded(
            flex: 4,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                border: Border(right: BorderSide(color: Colors.white10)),
              ),
              child: Column(
                children: [
                  // --- HEADER ---
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: const [
                          Icon(Icons.flash_on, color: Colors.amber),
                          SizedBox(width: 10),
                          Text("THE POWER PLANT", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
                        ],
                      ),
                    ),
                  ),

                  // --- TABS ---
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.amber,
                      labelColor: Colors.amber,
                      unselectedLabelColor: Colors.grey,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                      tabs: const [
                        Tab(text: "SCOUTING", icon: Icon(Icons.public, size: 16)),
                        Tab(text: "TRAINING", icon: Icon(Icons.fitness_center, size: 16)),
                        Tab(text: "SPARRING", icon: Icon(Icons.sports_mma, size: 16)),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 10),

                  // --- TAB CONTENT ---
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // TAB 1: SCOUTING 
                        _buildScoutingTab(gameState),

                        // TAB 2: TRAINING logic
                        _buildTrainingTab(rosterState),

                        // TAB 3: SPARRING logic
                        _buildSparringTab(rosterState),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---------------------------------------------------------
          // RIGHT COLUMN: VISUALS (60%)
          // ---------------------------------------------------------
          Expanded(
            flex: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 1. BACKGROUND IMAGE
                Image.asset(
                  "assets/images/gym_background.png", // Ensure this file exists!
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(color: const Color(0xFF101010)),
                ),

                // 2. GRADIENT OVERLAY
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black,
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.3, 1.0],
                    ),
                  ),
                ),

                // 3. OVERLAY TEXT
                Positioned(
                  bottom: 40,
                  right: 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(Icons.fitness_center, size: 60, color: Colors.white12),
                      const SizedBox(height: 10),
                      Text("FUTURE STARS", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white.withOpacity(0.9), letterSpacing: 2)),
                      Text("DEVELOPMENT CENTER", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amber.withOpacity(0.8), letterSpacing: 2)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // TAB 1: SCOUTING (With Dynamic Locks!)
  // ===========================================================================
  Widget _buildScoutingTab(dynamic gameState) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // FIX: Re-aligned the required levels to map from 1 to 4!
        _buildRegionCard(gameState, "North America", 1, 500, "Gym", "assets/images/scout_usa.png"),
        const SizedBox(height: 10),
        _buildRegionCard(gameState, "Mexico & Canada", 2, 1000, "Civic Center", "assets/images/scout_mexico.png"),
        const SizedBox(height: 10),
        _buildRegionCard(gameState, "Japan & Asia", 3, 2500, "Arena", "assets/images/scout_japan.png"),
        const SizedBox(height: 10),
        _buildRegionCard(gameState, "United Kingdom & Europe", 4, 5000, "Stadium", "assets/images/scout_uk.png"),
        
        const SizedBox(height: 20),
        const Center(
          child: Text(
            "Upgrade your Venue in the Office to unlock new regions!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildRegionCard(dynamic gameState, String name, int requiredLevel, int cost, String venueName, String imagePath) {
    bool isLocked = gameState.venueLevel < requiredLevel;

    return Container(
      height: 60, 
      decoration: BoxDecoration(
        color: isLocked ? const Color(0xFF151515) : const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isLocked ? Colors.white10 : Colors.blueAccent.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          // 1. IMAGE SECTION (Left)
          Container(
            width: 80,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
                colorFilter: isLocked ? const ColorFilter.mode(Colors.grey, BlendMode.saturation) : null,
              ),
            ),
            child: isLocked ? Container(color: Colors.black54, child: const Icon(Icons.lock, color: Colors.white54)) : null,
          ),

          // 2. TEXT SECTION (Middle)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name, style: TextStyle(color: isLocked ? Colors.grey : Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  isLocked 
                    ? Text("Requires: $venueName", style: const TextStyle(color: Colors.redAccent, fontSize: 10))
                    : Text("Cost: \$$cost", style: const TextStyle(color: Colors.greenAccent, fontSize: 10)),
                ],
              ),
            ),
          ),

          // 3. ACTION BUTTON (Right)
          if (!isLocked)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, 
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  minimumSize: const Size(60, 28),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text("SCOUT", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black)),
                onPressed: () {
                  ref.read(rosterProvider.notifier).scoutRegion(name, cost);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Scouting $name... check Free Agents!")));
                },
              ),
            ),
        ],
      ),
    );
  }

  // ===========================================================================
  // TAB 2: TRAINING
  // ===========================================================================
  Widget _buildTrainingTab(dynamic state) {
    return ListView.builder(
      itemCount: state.roster.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final wrestler = state.roster[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
             color: const Color(0xFF1E1E1E),
             borderRadius: BorderRadius.circular(8),
             border: Border.all(color: Colors.white10),
          ),
          child: ExpansionTile(
            collapsedIconColor: Colors.white54,
            leading: CircleAvatar(
                backgroundColor: Colors.grey[800],
                radius: 16,
                child: Text(wrestler.name[0], style: const TextStyle(color: Colors.white, fontSize: 12))),
            title: Text(wrestler.name, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            subtitle: Text("Pop: ${wrestler.pop.toInt()} | Ring: ${wrestler.ringSkill.toInt()}", style: const TextStyle(color: Colors.white54, fontSize: 11)),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTrainButton(wrestler, "MIC", 500),
                    _buildTrainButton(wrestler, "POP", 1000),
                    _buildTrainButton(wrestler, "RING", 750),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrainButton(Wrestler w, String type, int cost) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple[900], 
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: const Size(60, 30)
      ),
      child: Column(
        children: [
          Text(type, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          Text("\$$cost", style: const TextStyle(fontSize: 9, color: Colors.white70)),
        ],
      ),
      onPressed: () {
        ref.read(rosterProvider.notifier).trainingAction(w, type, cost);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Training $type Complete!")));
      },
    );
  }

  // ===========================================================================
  // TAB 3: SPARRING
  // ===========================================================================
  Widget _buildSparringTab(dynamic state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.amber.withOpacity(0.3))),
            child: const Text("Select 2 Wrestlers for a Practice Match.\nGain XP but lose Stamina.", 
                style: TextStyle(color: Colors.amber, fontSize: 11), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildSparringList(state, true)),
                const VerticalDivider(color: Colors.white10, width: 20),
                Expanded(child: _buildSparringList(state, false)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.flash_on, size: 18),
              label: const Text("START SESSION"),
              style: ElevatedButton.styleFrom(
                backgroundColor: (_selectedA != null && _selectedB != null && _selectedA != _selectedB) ? Colors.orange : Colors.grey[800], 
                foregroundColor: Colors.black,
                padding: const EdgeInsets.all(15)
              ),
              onPressed: _selectedA != null && _selectedB != null && _selectedA != _selectedB 
                ? _runSparringSession 
                : null,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSparringList(dynamic state, bool isSideA) {
    return Column(
      children: [
        Text(isSideA ? "WRESTLER A" : "WRESTLER B", style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Expanded(
          child: Container(
            decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(8)),
            child: ListView.builder(
              itemCount: state.roster.length,
              itemBuilder: (context, index) {
                final w = state.roster[index];
                final isSelected = isSideA ? _selectedA == w : _selectedB == w;
                return ListTile(
                  dense: true,
                  tileColor: isSelected ? Colors.green.withOpacity(0.2) : null,
                  title: Text(w.name, style: TextStyle(color: isSelected ? Colors.greenAccent : Colors.white, fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                  onTap: () {
                    setState(() {
                      if (isSideA) { _selectedA = w; } else { _selectedB = w; }
                    });
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _runSparringSession() async {
    final result = await ref.read(rosterProvider.notifier).runPracticeMatch(_selectedA!, _selectedB!);
    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text("SESSION REPORT", style: TextStyle(color: Colors.white, fontSize: 16)),
          content: Text(result, style: const TextStyle(color: Colors.greenAccent, fontSize: 14)),
          actions: [TextButton(child: const Text("OK", style: TextStyle(color: Colors.white)), onPressed: () => Navigator.pop(ctx))],
        ),
      );
    }
  }
}