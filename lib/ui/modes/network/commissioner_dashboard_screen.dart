import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'scoring_rules_screen.dart';
import 'weekly_event_auditor_screen.dart';
import 'commissioner_event_creator_screen.dart';
import 'commissioner_event_grader_screen.dart';
class CommissionerDashboardScreen extends StatefulWidget {
final String leagueId;
const CommissionerDashboardScreen({super.key, required this.leagueId});

@override
State createState() => _CommissionerDashboardScreenState();
}

class _CommissionerDashboardScreenState extends 
State<CommissionerDashboardScreen> {
final _supabase = Supabase.instance.client;
Map<String, dynamic>? _league;
List _roster = [];
bool _isLoading = true;

@override
void initState() {
super.initState();
_fetchDashboardData();
}

Future _fetchDashboardData() async {
try {
final leagueData = await _supabase.from('leagues').select().eq('id', widget.leagueId).single();
final rosterData = await _supabase.from('wrestlers').select().eq('league_id', widget.leagueId).order('popularity', ascending: false);

  if (mounted) {
    setState(() {
      _league = leagueData;
      _roster = rosterData;
      _isLoading = false;
    });
  }
} catch (e) {
  debugPrint("Dashboard Error: $e");
}
}

@override
Widget build(BuildContext context) {
if (_isLoading) {
return const Scaffold(
backgroundColor: Colors.black,
body: Center(child: CircularProgressIndicator(color: Colors.amber)),
);
}

return Scaffold(
  backgroundColor: const Color(0xFF121212),
  appBar: AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.amber),
      onPressed: () => Navigator.pop(context),
    ),
    title: const Text("COMMISSIONER ROOM", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
    centerTitle: true,
  ),
  body: Padding(
    padding: const EdgeInsets.all(24.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. LEAGUE INFO CARD
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("LEAGUE: ${_league?['name']?.toUpperCase() ?? 'UNKNOWN'}", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.vpn_key, color: Colors.cyanAccent, size: 16),
                      const SizedBox(width: 8),
                      Text("INVITE CODE: ${_league?['invite_code']}", style: const TextStyle(color: Colors.cyanAccent, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    ],
                  ),
                ],
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.copy, size: 16, color: Colors.black),
                label: const Text("COPY CODE"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _league?['invite_code'] ?? ''));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invite Code Copied!"), backgroundColor: Colors.green));
                },
              )
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 2. SCORING RULES BUTTON
        ElevatedButton.icon(
          icon: const Icon(Icons.rule, color: Colors.black),
          label: const Text("EDIT SCORING RULES"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ScoringRulesScreen(leagueId: widget.leagueId)));
          },
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          icon: const Icon(Icons.event_available, color: Colors.black),
          label: const Text("CREATE PICK 'EM EVENT", style: TextStyle(fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.cyanAccent,
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => CommissionerEventCreatorScreen(leagueId: widget.leagueId)));
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.gavel, color: Colors.black),
          label: const Text("GRADE COMPLETED EVENT", style: TextStyle(fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => CommissionerEventGraderScreen(leagueId: widget.leagueId)));
          },
        ),
        const SizedBox(height: 24),
        // 3. ROSTER DATA TABLE
        const Text("ACTIVE ROSTER", style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
        const SizedBox(height: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF151515),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: ListView.separated(
              itemCount: _roster.length,
              separatorBuilder: (context, index) => const Divider(color: Colors.white10, height: 1),
              itemBuilder: (context, index) {
                final wrestler = _roster[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.amber.withOpacity(0.1),
                    child: const Icon(Icons.person, color: Colors.amber),
                  ),
                  title: Text(wrestler['name'] ?? 'Unknown', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text("${wrestler['promotion'] ?? 'Indy'} • ${wrestler['faction'] ?? 'No Faction'}", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
                    child: Text("POP: ${wrestler['popularity']}", style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    ),
  ),
);
}
}
