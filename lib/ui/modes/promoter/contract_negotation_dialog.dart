import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/wrestler.dart';
import '../../../logic/promoter_provider.dart';
// import '../../components/wrestler_avatar.dart'; // Uncomment this once your avatar file is ready!

class ContractNegotiationDialog extends ConsumerStatefulWidget {
  final Wrestler wrestler;

  const ContractNegotiationDialog({super.key, required this.wrestler});

  @override
  ConsumerState<ContractNegotiationDialog> createState() => _ContractNegotiationDialogState();
}

class _ContractNegotiationDialogState extends ConsumerState<ContractNegotiationDialog> {
  // --- Sandbox State ---
  double _offeredSalary = 500;
  double _offeredBonus = 0;
  int _offeredWeeks = 12;
  bool _creativeControl = false;

  String _aiFeedback = "Awaiting your offer...";
  Color _feedbackColor = Colors.grey;
  bool _isNegotiating = true;

  @override
  void initState() {
    super.initState();
    // Set baseline sliders based on their current stats
    _offeredSalary = (widget.wrestler.pop * 10.0).clamp(500, 10000);
    if (widget.wrestler.salary > _offeredSalary) {
      _offeredSalary = widget.wrestler.salary.toDouble();
    }
  }

  // --- THE AI NEGOTIATION ALGORITHM ---
  void _submitOffer() {
    final rosterState = ref.read(rosterProvider);
    
    // 1. Budget Check
    if (_offeredBonus > rosterState.bankAccount) {
      setState(() {
        _aiFeedback = "INSUFFICIENT FUNDS: You don't have enough cash for that bonus!";
        _feedbackColor = Colors.redAccent;
      });
      return;
    }

    // 2. Calculate Baseline Demand (Pop * Market Rate)
    double baseDemand = widget.wrestler.pop * 15.0; 

    // 3. Apply Psychological Modifiers
    double greedMult = 1.0 + (widget.wrestler.greed / 100.0 * 0.5); // Up to 50% more!
    double loyaltyMult = (widget.wrestler.companyId == 0) ? (1.0 - (widget.wrestler.loyalty / 100.0 * 0.2)) : 1.0; // Hometown discount
    double ccDiscount = _creativeControl ? 0.85 : 1.0; // 15% discount for Creative Control

    double totalDemandWeekly = (baseDemand * greedMult * loyaltyMult * ccDiscount);

    // 4. Calculate Player's Offer Value (Amortize the bonus over the contract length)
    double offerValueWeekly = _offeredSalary + (_offeredBonus / _offeredWeeks);

    // 5. The Decision Logic
    setState(() {
      if (offerValueWeekly >= totalDemandWeekly) {
        // ACCEPTED
        _aiFeedback = "ACCEPTED: \"This is exactly what I'm looking for. I'll sign it now.\"";
        _feedbackColor = Colors.greenAccent;
        _isNegotiating = false;
        _finalizeSigning();
      } 
      else if (offerValueWeekly >= totalDemandWeekly * 0.80) {
        // COUNTER (Close, but not quite)
        _aiFeedback = "COUNTER: \"We are close, but I need a bigger upfront bonus or a higher weekly rate.\"";
        _feedbackColor = Colors.orangeAccent;
      } 
      else {
        // REJECTED (Insulting offer)
        _aiFeedback = "REJECTED: \"This is a joke. Don't insult my intelligence.\"";
        _feedbackColor = Colors.red;
        _isNegotiating = false;
        
        // Auto-close dialog after rejection
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) Navigator.pop(context);
        });
      }
    });
  }

  void _finalizeSigning() {
    // Modify the wrestler object
    final w = widget.wrestler
      ..salary = _offeredSalary.toInt()
      ..upfrontBonus = _offeredBonus.toInt()
      ..contractWeeks = _offeredWeeks
      ..hasCreativeControl = _creativeControl
      ..isHoldingOut = false
      ..contractedPop = widget.wrestler.pop;

    // Send to Database
    ref.read(rosterProvider.notifier).hireWrestler(w);

    // Deduct the upfront bonus from the player's bank account
    // (Note: To make this work, we will add a tiny spendCash function to your provider next!)
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final rosterState = ref.watch(rosterProvider);

    // Translate hidden stats for the Scouting Report
    String trait = "Professional";
    if (widget.wrestler.greed > 75) trait = "Mercenary (Follows the money)";
    if (widget.wrestler.loyalty > 75) trait = "Company Man (Values stability)";

    return Dialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 800, // Wide layout for tablet/landscape
        height: 500,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // ==========================================
            // ZONE 1: THE DOSSIER (Left Panel)
            // ==========================================
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Placeholder for your WrestlerAvatar
                    const CircleAvatar(radius: 50, backgroundColor: Colors.grey, child: Icon(Icons.person, size: 50, color: Colors.white)),
                    const SizedBox(height: 15),
                    Text(widget.wrestler.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    Text("Pop: ${widget.wrestler.pop}  |  Skill: ${widget.wrestler.ringSkill}", style: const TextStyle(color: Colors.amber, fontSize: 14)),
                    const SizedBox(height: 20),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 10),
                    const Text("SCOUTING REPORT", style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1.5)),
                    const SizedBox(height: 5),
                    Text("Personality: $trait", style: const TextStyle(color: Colors.white70, fontSize: 14), textAlign: TextAlign.center),
                    if (widget.wrestler.isHoldingOut) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.red.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                        child: const Text("CURRENTLY HOLDING OUT", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                      )
                    ]
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),

            // ==========================================
            // ZONE 2 & 3: THE SANDBOX & FEEDBACK
            // ==========================================
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("CONTRACT NEGOTIATION", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      Text("Budget: \$${rosterState.bankAccount}", style: const TextStyle(color: Colors.greenAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Slider 1: Upfront Bonus
                  Text("Upfront Signing Bonus: \$${_offeredBonus.toInt()}", style: const TextStyle(color: Colors.white70)),
                  Slider(
                    value: _offeredBonus,
                    min: 0,
                    max: 100000,
                    divisions: 100,
                    activeColor: Colors.green,
                    onChanged: _isNegotiating ? (val) => setState(() => _offeredBonus = val) : null,
                  ),

                  // Slider 2: Weekly Salary
                  Text("Weekly Appearance Pay: \$${_offeredSalary.toInt()}", style: const TextStyle(color: Colors.white70)),
                  Slider(
                    value: _offeredSalary,
                    min: 500,
                    max: 20000,
                    divisions: 195,
                    activeColor: Colors.blueAccent,
                    onChanged: _isNegotiating ? (val) => setState(() => _offeredSalary = val) : null,
                  ),

                  const SizedBox(height: 10),

                  // Term Length Stepper
                  Row(
                    children: [
                      const Text("Duration (Weeks): ", style: TextStyle(color: Colors.white70)),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.amber),
                        onPressed: (_isNegotiating && _offeredWeeks > 4) ? () => setState(() => _offeredWeeks -= 4) : null,
                      ),
                      Text("$_offeredWeeks", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, color: Colors.amber),
                        onPressed: (_isNegotiating && _offeredWeeks < 52) ? () => setState(() => _offeredWeeks += 4) : null,
                      ),
                    ],
                  ),

                  // Creative Control Toggle
                  SwitchListTile(
                    title: const Text("Creative Control (Veto Power)", style: TextStyle(color: Colors.white)),
                    subtitle: const Text("Lowers asking price by 15%, but wrestler cannot be booked to lose.", style: TextStyle(color: Colors.grey, fontSize: 10)),
                    value: _creativeControl,
                    activeColor: Colors.purpleAccent,
                    onChanged: _isNegotiating ? (val) => setState(() => _creativeControl = val) : null,
                  ),

                  const Spacer(),

                  // Feedback Engine
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: _feedbackColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: _feedbackColor)),
                    child: Text(_aiFeedback, style: TextStyle(color: _feedbackColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  ),

                  const SizedBox(height: 15),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[700]),
                      onPressed: _isNegotiating ? _submitOffer : null,
                      child: const Text("SUBMIT OFFER", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.5)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}