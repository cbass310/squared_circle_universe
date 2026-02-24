import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class WeeklyEventAuditorScreen extends StatefulWidget {
final String leagueId;
const WeeklyEventAuditorScreen({super.key, required this.leagueId});

@override
State createState() => _WeeklyEventAuditorScreenState();
}

class _WeeklyEventAuditorScreenState extends
 State<WeeklyEventAuditorScreen> {
final _supabase = Supabase.instance.client;
bool _isLoading = true;
List _wrestlers = [];
List _rules = [];

String? _selectedWrestler;
Map<String, dynamic>? _selectedRule;
int _weekNumber = 1;

@override
void initState() {
super.initState();
_fetchDropdownData();
}

Future _fetchDropdownData() async {
try {
final wData = await _supabase.from('wrestlers').select().eq('league_id', widget.leagueId).order('name');
final rData = await _supabase.from('scoring_rules').select().eq('league_id', widget.leagueId).order('action_name');

  if (mounted) {
    setState(() {
      _wrestlers = wData;
      _rules = rData;
      _isLoading = false;
    });
  }
} catch (e) {
  debugPrint("Error fetching auditor data: $e");
  if (mounted) setState(() => _isLoading = false);
}
}

Future _logEvent() async {
if (_selectedWrestler == null || _selectedRule == null) {
ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Select a wrestler and an action!"), backgroundColor: Colors.red));
return;
}

setState(() => _isLoading = true);
try {
  await _supabase.from('weekly_events').insert({
    'league_id': widget.leagueId,
    'wrestler_name': _selectedWrestler,
    'action_name': _selectedRule!['action_name'],
    'points': _selectedRule!['point_value'],
    'week_number': _weekNumber,
  });
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Event Logged! 📝"), backgroundColor: Colors.green));
    setState(() {
      _selectedWrestler = null;
      _selectedRule = null;
      _isLoading = false;
    });
  }
} catch (e) {
  debugPrint("Error logging event: $e");
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
    setState(() => _isLoading = false);
  }
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFF121212),
appBar: AppBar(
backgroundColor: Colors.transparent,
elevation: 0,
leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.amber), onPressed: () => Navigator.pop(context)),
title: const Text("WEEKLY AUDITOR", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
centerTitle: true,
),
body: _isLoading
? const Center(child: CircularProgressIndicator(color: Colors.amber))
: Padding(
padding: const EdgeInsets.all(24.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text("WEEK NUMBER", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
const SizedBox(height: 8),
Row(
children: [
IconButton(icon: const Icon(Icons.remove_circle, color: Colors.redAccent), onPressed: () => setState(() => _weekNumber > 1 ? _weekNumber-- : null)),
Text("$_weekNumber", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
IconButton(icon: const Icon(Icons.add_circle, color: Colors.greenAccent), onPressed: () => setState(() => _weekNumber++)),
],
),
const SizedBox(height: 24),

            const Text("SELECT WRESTLER", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              dropdownColor: const Color(0xFF1E1E1E),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(filled: true, fillColor: const Color(0xFF1E1E1E), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
              value: _selectedWrestler,
              items: _wrestlers.map((w) => DropdownMenuItem<String>(value: w['name'], child: Text(w['name']))).toList(),
              onChanged: (val) => setState(() => _selectedWrestler = val),
            ),
            const SizedBox(height: 24),

            const Text("SELECT ACTION", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<Map<String, dynamic>>(
              dropdownColor: const Color(0xFF1E1E1E),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(filled: true, fillColor: const Color(0xFF1E1E1E), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
              value: _selectedRule,
              items: _rules.map((r) => DropdownMenuItem<Map<String, dynamic>>(value: r, child: Text("${r['action_name']} (${r['point_value']} pts)"))).toList(),
              onChanged: (val) => setState(() => _selectedRule = val),
            ),

            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.check_circle, color: Colors.black),
              label: const Text("LOG EVENT", style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, minimumSize: const Size(double.infinity, 60)),
              onPressed: _logEvent,
            )
          ],
        ),
      ),
);
}
}
