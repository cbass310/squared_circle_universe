import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommissionerEventCreatorScreen extends StatefulWidget {
  final String leagueId;
  const CommissionerEventCreatorScreen({super.key, required this.leagueId});

  @override
  State<CommissionerEventCreatorScreen> createState() => _CommissionerEventCreatorScreenState();
}

class _CommissionerEventCreatorScreenState extends State<CommissionerEventCreatorScreen> {
  final _supabase = Supabase.instance.client;
  final _eventNameController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading = false;

  // List to hold matches/questions before saving
  final List<Map<String, dynamic>> _questions = [];

  void _addQuestion() {
    setState(() => _questions.add({'question': '', 'points': 1}));
  }

  void _removeQuestion(int index) {
    setState(() => _questions.removeAt(index));
  }

  Future _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future _saveEvent() async {
    final eventName = _eventNameController.text.trim();
    if (eventName.isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Name and Date are required!"), backgroundColor: Colors.red));
      return;
    }
    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Add at least one match/question!"), backgroundColor: Colors.red));
      return;
    }

    for (var q in _questions) {
      if ((q['question'] as String).trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("A question field is empty!"), backgroundColor: Colors.red));
        return;
      }
    }
    setState(() => _isLoading = true);
    try {
      // 1. Insert Event
      final eventResponse = await _supabase.from('pickem_events').insert({
        'league_id': widget.leagueId,
        'event_name': eventName,
        'event_date': _selectedDate!.toIso8601String(),
      }).select().single();
      final eventId = eventResponse['id'];
      // 2. Insert Questions
      final List<Map<String, dynamic>> questionInserts = _questions.map((q) => {
        'event_id': eventId,
        'question_text': q['question'],
        'points': q['points'],
      }).toList();
      await _supabase.from('pickem_questions').insert(questionInserts);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Event Created Successfully! 🏆"), backgroundColor: Colors.green));
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Error saving event: $e");
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.cyanAccent), onPressed: () => Navigator.pop(context)),
        title: const Text("CREATE EVENT", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
        centerTitle: true,
        actions: [
          if (!_isLoading)
            IconButton(icon: const Icon(Icons.save, color: Colors.greenAccent), onPressed: _saveEvent)
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.cyanAccent))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _eventNameController,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    decoration: const InputDecoration(
                      labelText: "Event Name (e.g. WrestleMania)",
                      labelStyle: TextStyle(color: Colors.white54),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.cyanAccent)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.cyanAccent, width: 2)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(_selectedDate == null ? "Select Lock-In Date" : "Locks on: ${_selectedDate!.toLocal().toString().split(' ')[0]}", style: TextStyle(color: _selectedDate == null ? Colors.redAccent : Colors.white)),
                    trailing: const Icon(Icons.calendar_today, color: Colors.cyanAccent),
                    onTap: _selectDate,
                  ),
                  const Divider(color: Colors.white10, height: 32, thickness: 2),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("MATCHES & PROPS", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                      IconButton(icon: const Icon(Icons.add_circle, color: Colors.greenAccent, size: 28), onPressed: _addQuestion),
                    ],
                  ),

                  Expanded(
                    child: _questions.isEmpty
                      ? const Center(child: Text("Tap + to add matches", style: TextStyle(color: Colors.white38)))
                      : ListView.builder(
                          itemCount: _questions.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: const Color(0xFF1E1E1E),
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: TextField(
                                        style: const TextStyle(color: Colors.white),
                                        decoration: const InputDecoration(
                                          hintText: "e.g. Cody vs Roman",
                                          hintStyle: TextStyle(color: Colors.white24),
                                          border: InputBorder.none,
                                        ),
                                        onChanged: (val) => _questions[index]['question'] = val,
                                      ),
                                    ),
                                    Container(width: 1, height: 40, color: Colors.white10),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<int>(
                                            dropdownColor: const Color(0xFF121212),
                                            value: _questions[index]['points'],
                                            style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                                            items: [1, 2, 3, 5, 10].map((e) => DropdownMenuItem(value: e, child: Text("${e} pts"))).toList(),
                                            onChanged: (val) {
                                              if (val != null) setState(() => _questions[index]['points'] = val);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                                      onPressed: () => _removeQuestion(index),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                  ),
                ],
              ),
            ),
    );
  }
}
