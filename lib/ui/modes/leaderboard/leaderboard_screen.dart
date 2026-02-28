import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  
  // Two separate lists for the two different ecosystems!
  List<Map<String, dynamic>> _tycoonScores = [];
  List<Map<String, dynamic>> _pickemScores = [];

  @override
  void initState() {
    super.initState();
    _fetchLeaderboards();
  }

  Future<void> _fetchLeaderboards() async {
    try {
      // 1. Fetch Tycoon Offline Legacy Scores
      final tycoonRes = await _supabase
          .from('tycoon_scores') 
          .select()
          .order('score', ascending: false)
          .limit(100);

      // 2. Fetch Pick 'Em Prediction Scores
      final pickemRes = await _supabase
          .from('pickem_scores') 
          .select()
          .order('score', ascending: false)
          .limit(100);

      if (mounted) {
        setState(() {
          _tycoonScores = List<Map<String, dynamic>>.from(tycoonRes);
          _pickemScores = List<Map<String, dynamic>>.from(pickemRes);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching leaderboards: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Color _getRankColor(int index, bool isTycoon) {
    if (index == 0) return Colors.amber; // 1st Place Gold
    if (index == 1) return const Color(0xFFC0C0C0); // 2nd Place Silver
    if (index == 2) return const Color(0xFFCD7F32); // 3rd Place Bronze
    // Tycoon gets Amber fallback, Pick 'Em gets Purple fallback
    return isTycoon ? Colors.amber.withOpacity(0.5) : Colors.purpleAccent; 
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: isDesktop
              ? Row(
                  children: [
                    Expanded(flex: 4, child: _buildLeftDashboard(isDesktop)),
                    Expanded(flex: 6, child: _buildRightArtworkPane(isMobile: false)),
                  ],
                )
              : Column(
                  children: [
                    Expanded(flex: 4, child: _buildRightArtworkPane(isMobile: true)),
                    Expanded(flex: 6, child: _buildLeftDashboard(isDesktop)),
                  ],
                ),
        ),
      ),
    );
  }

  // =====================================================================
  // --- LEFT PANE: THE DUAL LEADERBOARD DASHBOARD
  // =====================================================================
  Widget _buildLeftDashboard(bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        // 🛠️ AAA Black Borders
        border: isDesktop ? const Border(right: BorderSide(color: Colors.black, width: 3)) : const Border(top: BorderSide(color: Colors.black, width: 3)),
      ),
      child: Column(
        children: [
          // --- HEADER ---
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20), onPressed: () => Navigator.pop(context)),
                const SizedBox(width: 8),
                const Text("HALL OF FAME", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5)),
              ],
            ),
          ),
          
          // --- TABS ---
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black, width: 3)), 
              color: Color(0xFF121212),
            ),
            child: const TabBar(
              dividerColor: Colors.transparent, 
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              labelStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.5),
              tabs: [
                Tab(text: "TYCOON LEGACY"),
                Tab(text: "PICK 'EM CHAMPIONS"),
              ],
            ),
          ),

          // --- TAB CONTENT ---
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : TabBarView(
                    children: [
                      // TAB 1: TYCOON (Amber Theme)
                      _buildLeaderboardList(_tycoonScores, isTycoon: true),
                      
                      // TAB 2: PICK 'EMS (Purple Theme)
                      _buildLeaderboardList(_pickemScores, isTycoon: false),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList(List<Map<String, dynamic>> listData, {required bool isTycoon}) {
    if (listData.isEmpty) {
      return _buildEmptyState(isTycoon);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: listData.length,
      itemBuilder: (context, index) {
        final entry = listData[index];
        final isTopThree = index < 3;
        final rankColor = _getRankColor(index, isTycoon);
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isTopThree ? rankColor.withOpacity(0.1) : const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isTopThree ? rankColor : Colors.black, width: isTopThree ? 2 : 2),
            boxShadow: isTopThree ? [BoxShadow(color: rankColor.withOpacity(0.2), blurRadius: 10)] : [],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isTopThree ? rankColor : Colors.black,
                shape: BoxShape.circle,
                border: Border.all(color: rankColor, width: 2),
              ),
              child: Center(
                child: Text(
                  "${index + 1}", 
                  style: TextStyle(
                    color: isTopThree ? Colors.black : Colors.white, 
                    fontWeight: FontWeight.w900,
                    fontSize: 16
                  )
                ),
              ),
            ),
            // 🛠️ THE FIX: Checking isTycoon to pull the correct name field from the database!
            title: Text(
              isTycoon 
                  ? (entry['promotion_name']?.toString().toUpperCase() ?? "UNKNOWN PROMOTER")
                  : (entry['player_name']?.toString().toUpperCase() ?? "UNKNOWN PLAYER"), 
              style: TextStyle(color: isTopThree ? rankColor : Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.0, fontSize: 14)
            ),
            subtitle: Text(isTycoon ? "FRANCHISE LEGACY TIER" : "GLOBAL PREDICTION TIER", style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${entry['score']}", 
                  style: TextStyle(color: isTopThree ? rankColor : (isTycoon ? Colors.amber : Colors.cyanAccent), fontSize: 18, fontWeight: FontWeight.w900, fontFamily: "Monospace")
                ),
                Text(isTycoon ? "FANS + REP" : "PICK 'EM PTS", style: const TextStyle(color: Colors.white30, fontSize: 9, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isTycoon) {
    Color themeColor = isTycoon ? Colors.amber : Colors.purpleAccent;
    String title = isTycoon ? "NO TYCOON DATA" : "NO PREDICTION DATA";
    String sub = isTycoon ? "COMPLETE A BOOKING YEAR TO RANK." : "GRADE A PPV EVENT TO RANK.";

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(isTycoon ? Icons.domain_disabled : Icons.public_off, color: Colors.white24, size: 60),
          const SizedBox(height: 20),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          Text(sub, textAlign: TextAlign.center, style: TextStyle(color: themeColor.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
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
          "assets/images/leaderboard_bg.png", // Web3 / Server / Globe artwork
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
              const Icon(Icons.public, size: 50, color: Colors.white10),
              const SizedBox(height: 10),
              Text("GLOBAL NETWORK", style: TextStyle(fontSize: isMobile ? 20 : 32, fontWeight: FontWeight.w900, color: Colors.white24, letterSpacing: 4.0)),
              Text("SYNCED TO SUPABASE MAINFRAME", style: TextStyle(fontSize: isMobile ? 10 : 14, color: Colors.cyanAccent.withOpacity(0.5), letterSpacing: 2.0, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}