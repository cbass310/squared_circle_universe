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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.cyanAccent,
              onPrimary: Colors.black,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future _saveEvent() async {
    final eventName = _eventNameController.text.trim();
    if (eventName.isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Name and Date are required!", style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.redAccent));
      return;
    }
    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Add at least one match/question!", style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.redAccent));
      return;
    }

    for (var q in _questions) {
      if ((q['question'] as String).trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("A question field is empty!", style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.redAccent));
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Event Created Successfully! 🏆", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)), backgroundColor: Colors.cyanAccent));
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
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

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
  // --- LEFT PANE: THE EVENT CREATOR DASHBOARD
  // =====================================================================
  Widget _buildLeftDashboard(bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        // 🛠️ AAA Black Borders
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
                const Text("EVENT CREATOR", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5)),
              ],
            ),
          ),
          
          Container(height: 3, color: Colors.black), 

          // --- EVENT METADATA ---
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("EVENT IDENTIFIER", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                const SizedBox(height: 8),
                TextField(
                  controller: _eventNameController,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1.0),
                  decoration: InputDecoration(
                    hintText: "e.g. WRESTLEMANIA 41",
                    hintStyle: const TextStyle(color: Colors.white24),
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black, width: 2)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.cyanAccent, width: 2)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
                const SizedBox(height: 16),
                
                const Text("LOCK-IN DEADLINE", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate == null ? "TAP TO SELECT DATE" : "LOCKS ON: ${_selectedDate!.toLocal().toString().split(' ')[0]}", 
                          style: TextStyle(color: _selectedDate == null ? Colors.redAccent : Colors.cyanAccent, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1.0)
                        ),
                        const Icon(Icons.calendar_today, color: Colors.white54, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- MATCH LIST HEADER ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.cyanAccent.withOpacity(0.1),
              border: const Border(top: BorderSide(color: Colors.cyanAccent, width: 1), bottom: BorderSide(color: Colors.cyanAccent, width: 1))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("MATCHES & PROPS", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 14)),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.cyanAccent, size: 28), 
                  onPressed: _addQuestion,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // --- MATCH BUILDER LIST ---
          Expanded(
            child: _questions.isEmpty
              ? const Center(child: Text("TAP + TO ADD MATCHES TO THE CARD", style: TextStyle(color: Colors.white30, fontWeight: FontWeight.bold, letterSpacing: 1.0)))
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Row(
                        children: [
                          // Points Dropdown (Left side to look like a rank/number)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(6), bottomLeft: Radius.circular(6)),
                              border: Border(right: BorderSide(color: Colors.white10))
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                dropdownColor: const Color(0xFF121212),
                                value: _questions[index]['points'],
                                icon: const SizedBox.shrink(), // Hides the arrow for a cleaner look
                                style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.w900, fontSize: 16),
                                items: [1, 2, 3, 5, 10].map((e) => DropdownMenuItem(value: e, child: Text("${e}x", textAlign: TextAlign.center))).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _questions[index]['points'] = val);
                                },
                              ),
                            ),
                          ),
                          
                          // Match Input
                          Expanded(
                            child: TextField(
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              decoration: const InputDecoration(
                                hintText: "e.g. Cody vs Roman",
                                hintStyle: TextStyle(color: Colors.white24, fontSize: 13),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                              onChanged: (val) => _questions[index]['question'] = val,
                            ),
                          ),
                          
                          // Delete Button
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.redAccent, size: 20),
                            onPressed: () => _removeQuestion(index),
                          )
                        ],
                      ),
                    );
                  },
                ),
          ),

          // --- DEPLOY BUTTON ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF121212),
              border: Border(top: BorderSide(color: Colors.black, width: 3)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent, 
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                icon: _isLoading ? const SizedBox.shrink() : const Icon(Icons.cloud_upload),
                label: _isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3))
                    : const Text("DEPLOY EVENT TO NETWORK", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                onPressed: _isLoading ? null : _saveEvent,
              ),
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
          "assets/images/event_creator_bg.png", // Web3 / Network / Stadium artwork
          fit: BoxFit.cover,
          alignment: Alignment.centerLeft,
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
              const Icon(Icons.edit_document, size: 50, color: Colors.white10),
              const SizedBox(height: 10),
              Text("CARD BUILDER", style: TextStyle(fontSize: isMobile ? 20 : 32, fontWeight: FontWeight.w900, color: Colors.white24, letterSpacing: 4.0)),
              Text("SUPABASE NODE ACTIVE", style: TextStyle(fontSize: isMobile ? 10 : 14, color: Colors.purpleAccent.withOpacity(0.5), letterSpacing: 2.0, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}