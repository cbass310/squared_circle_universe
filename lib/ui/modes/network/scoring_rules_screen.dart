import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class ScoringRulesScreen extends StatefulWidget {
final String leagueId;
const ScoringRulesScreen({super.key, required this.leagueId});

@override
State createState() => _ScoringRulesScreenState();
}

class _ScoringRulesScreenState extends State {
final _supabase = Supabase.instance.client;
bool _isLoading = true;

// Default base rules
final Map<String, int> _rules = {
'Match Win': 5,
'Match Loss': -2,
'Title Win': 10,
'TV Appearance': 1,
'PPV Main Event': 5,
'5-Star Match': 8,
};

@override
void initState() {
super.initState();
_fetchRules();
}

Future _fetchRules() async {
try {
final response = await _supabase.from('scoring_rules').select().eq('league_id', widget.leagueId);

  if (response.isNotEmpty) {
    for (var rule in response) {
      _rules[rule['action_name']] = rule['point_value'] as int;
    }
  }
} catch (e) {
  debugPrint("Error fetching rules: $e");
} finally {
  if (mounted) setState(() => _isLoading = false);
}
}

Future _saveRules() async {
setState(() => _isLoading = true);
try {
// Wipe old rules to avoid duplicates
await _supabase.from('scoring_rules').delete().eq('league_id', widget.leagueId);

  // Map the new rules to the database schema
  final List<Map<String, dynamic>> rulesToInsert = _rules.entries.map((e) => {
    'league_id': widget.leagueId,
    'action_name': e.key,
    'point_value': e.value,
  }).toList();

  // Batch upload to cloud
  await _supabase.from('scoring_rules').insert(rulesToInsert);

  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Scoring Rules Saved! 🏆"), backgroundColor: Colors.green));
    Navigator.pop(context);
  }
} catch (e) {
  debugPrint("Error saving rules: $e");
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
leading: IconButton(
icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.amber),
onPressed: () => Navigator.pop(context),
),
title: const Text("SCORING RULES", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
centerTitle: true,
actions: [
IconButton(
icon: const Icon(Icons.save, color: Colors.cyanAccent),
onPressed: _saveRules,
)
],
),
body: _isLoading
? const Center(child: CircularProgressIndicator(color: Colors.amber))
: ListView(
padding: const EdgeInsets.all(24.0),
children: _rules.keys.map((action) {
return Card(
color: const Color(0xFF1E1E1E),
margin: const EdgeInsets.only(bottom: 16),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.white10)),
child: Padding(
padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text(action, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
Row(
children: [
IconButton(
icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
onPressed: () => setState(() => _rules[action] = (_rules[action] ?? 0) - 1),
),
SizedBox(
width: 40,
child: Text("${_rules[action]}", textAlign: TextAlign.center, style: const TextStyle(color: Colors.cyanAccent, fontSize: 20, fontWeight: FontWeight.bold)),
),
IconButton(
icon: const Icon(Icons.add_circle_outline, color: Colors.greenAccent),
onPressed: () => setState(() => _rules[action] = (_rules[action] ?? 0) + 1),
),
],
)
],
),
),
);
}).toList(),
),
);
}
}
