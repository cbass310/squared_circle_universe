import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'commissioner_event_creator_screen.dart';
import 'commissioner_event_grader_screen.dart';

class CommissionerDashboardScreen extends StatefulWidget {
  // We keep the parameter so your navigation doesn't break, but we will default to 'global'
  final String? leagueId;
  const CommissionerDashboardScreen({super.key, this.leagueId});

  @override
  State<CommissionerDashboardScreen> createState() => _CommissionerDashboardScreenState();
}

class _CommissionerDashboardScreenState extends State<CommissionerDashboardScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  int _activeEventsCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchGlobalData();
  }

  Future _fetchDashboardData() async {
    // Legacy method - keeping empty to prevent errors if called elsewhere
  }

  Future _fetchGlobalData() async {
    try {
      // Just fetching a quick count of ungraded events to show on the dashboard
      final events = await _supabase
          .from('pickem_events')
          .select('id')
          .eq('league_id', 'global') // Hardcoded to global
          .eq('is_graded', false);

      if (mounted) {
        setState(() {
          _activeEventsCount = events.length;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Global Dashboard Error: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.cyanAccent)),
      );
    }

    return Scaffold(
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
    );
  }

  // =====================================================================
  // --- LEFT PANE: THE COMMISSIONER CONTROLS
  // =====================================================================
  Widget _buildLeftDashboard(bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        border: isDesktop ? const Border(right: BorderSide(color: Colors.black, width: 3)) : const Border(top: BorderSide(color: Colors.black, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER ---
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.cyanAccent, size: 20), onPressed: () => Navigator.pop(context)),
                const SizedBox(width: 8),
                const Text("COMMISSIONER DESK", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5)),
              ],
            ),
          ),
          
          Container(height: 3, color: Colors.black), 

          // --- CONTENT ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // 1. GLOBAL STATUS CARD (Replaced the old Invite Code card)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.cyanAccent, width: 2),
                    boxShadow: [BoxShadow(color: Colors.cyanAccent.withOpacity(0.1), blurRadius: 10)],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("SYSTEM STATUS", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                            const SizedBox(height: 4),
                            const Text("GLOBAL PICK 'EM NETWORK", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.circle, color: _activeEventsCount > 0 ? Colors.greenAccent : Colors.redAccent, size: 12),
                                const SizedBox(width: 8),
                                Text(
                                  "$_activeEventsCount ACTIVE EVENTS PENDING", 
                                  style: TextStyle(color: _activeEventsCount > 0 ? Colors.greenAccent : Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0)
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.public, color: Colors.cyanAccent, size: 40),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                const Text("EVENT MANAGEMENT", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                const SizedBox(height: 12),

                // 2. CONTROL BUTTONS
                _buildControlButton(
                  icon: Icons.event_available, 
                  label: "CREATE GLOBAL EVENT", 
                  color: Colors.cyanAccent, 
                  onTap: () {
                    HapticFeedback.selectionClick();
                    // Pass 'global' instead of a private invite code
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CommissionerEventCreatorScreen(leagueId: 'global')));
                  }
                ),
                const SizedBox(height: 12),
                _buildControlButton(
                  icon: Icons.gavel, 
                  label: "GRADE COMPLETED EVENT", 
                  color: Colors.purpleAccent, 
                  onTap: () {
                    HapticFeedback.selectionClick();
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CommissionerEventGraderScreen(leagueId: 'global')));
                  }
                ),
                
                const SizedBox(height: 30),
                const Text("LIVEOPS & COMMUNITY", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                const SizedBox(height: 12),

                // 3. NEW LIVEOPS BUTTON
                _buildControlButton(
                  icon: Icons.campaign, 
                  label: "SEND GLOBAL PUSH NOTIFICATION", 
                  color: const Color(0xFF1E1E1E), 
                  textColor: Colors.amber,
                  borderColor: Colors.amber,
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Push Notification Engine connecting to Firebase/OneSignal... (Coming Soon)", style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.amber, behavior: SnackBarBehavior.floating),
                    );
                  }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({required IconData icon, required String label, required Color color, required VoidCallback onTap, Color textColor = Colors.black, Color? borderColor}) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: textColor),
        label: Text(label, style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0, color: textColor, fontSize: 13)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: borderColor != null ? BorderSide(color: borderColor, width: 2) : BorderSide.none,
          ),
          elevation: 0,
        ),
        onPressed: onTap,
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
          "assets/images/online_hub_background.png", // Web3 / Server / Globe artwork
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
              const Icon(Icons.admin_panel_settings, size: 50, color: Colors.white10),
              const SizedBox(height: 10),
              Text("LEAGUE OVERSIGHT", style: TextStyle(fontSize: isMobile ? 20 : 32, fontWeight: FontWeight.w900, color: Colors.white24, letterSpacing: 4.0)),
              Text("SUPABASE SECURE CONNECTION", style: TextStyle(fontSize: isMobile ? 10 : 14, color: Colors.cyanAccent.withOpacity(0.5), letterSpacing: 2.0, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}