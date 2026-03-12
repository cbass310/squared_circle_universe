import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/wrestler.dart';
import '../../../logic/promoter_provider.dart';
import '../../components/wrestler_avatar.dart'; 

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

  bool get _isSpecialAttraction => widget.wrestler.pop >= 90; // 🚨 THE 90+ POP RULE

  @override
  void initState() {
    super.initState();
    // Set baseline sliders based on their current stats
    _offeredSalary = (widget.wrestler.pop * 10.0).clamp(500, 10000);
    if (widget.wrestler.salary > _offeredSalary) {
      _offeredSalary = widget.wrestler.salary.toDouble();
    }
    // Hard-cap the initial weeks if they are a Special Attraction
    if (_isSpecialAttraction && _offeredWeeks > 12) {
      _offeredWeeks = 12;
    }
  }

  // --- THE AI NEGOTIATION ALGORITHM ---
  void _submitOffer() {
    HapticFeedback.mediumImpact();
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

    final bool isDesktop = MediaQuery.of(context).size.width > 600;

    return Dialog(
      backgroundColor: const Color(0xFF1E1E1E),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.white10, width: 2),
      ),
      child: Container(
        width: isDesktop ? 800 : double.infinity, 
        height: isDesktop ? 500 : MediaQuery.of(context).size.height * 0.85, 
        padding: const EdgeInsets.all(20),
        child: isDesktop 
          ? Row(
              children: [
                Expanded(flex: 3, child: _buildDossier(trait, isDesktop: true)),
                const SizedBox(width: 20),
                Expanded(flex: 5, child: _buildSandbox(rosterState, isDesktop: true)),
              ],
            )
          : Column(
              children: [
                _buildDossier(trait, isDesktop: false),
                const SizedBox(height: 16),
                Expanded(child: _buildSandbox(rosterState, isDesktop: false)),
              ],
            ),
      ),
    );
  }

  Widget _buildDossier(String trait, {required bool isDesktop}) {
    if (isDesktop) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.amber, width: 2)), child: WrestlerAvatar(wrestler: widget.wrestler, size: 100)),
            const SizedBox(height: 15),
            FittedBox(fit: BoxFit.scaleDown, child: Text(widget.wrestler.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            Text("Pop: ${widget.wrestler.pop}  |  Skill: ${widget.wrestler.ringSkill}", style: const TextStyle(color: Colors.amber, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Divider(color: Colors.white24),
            const SizedBox(height: 10),
            const Text("SCOUTING REPORT", style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text("Personality: $trait", style: const TextStyle(color: Colors.white70, fontSize: 14, fontStyle: FontStyle.italic), textAlign: TextAlign.center),
            if (widget.wrestler.isHoldingOut) ...[
              const SizedBox(height: 20),
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.red.withOpacity(0.2), borderRadius: BorderRadius.circular(8)), child: const Text("CURRENTLY HOLDING OUT", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12))),
            ]
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(2), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.amber, width: 2)), child: WrestlerAvatar(wrestler: widget.wrestler, size: 60)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text(widget.wrestler.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.0))),
                  const SizedBox(height: 2),
                  Text("POP: ${widget.wrestler.pop}  |  RING: ${widget.wrestler.ringSkill}", style: const TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text("Trait: $trait", style: const TextStyle(color: Colors.white54, fontSize: 10, fontStyle: FontStyle.italic), maxLines: 1, overflow: TextOverflow.ellipsis),
                  if (widget.wrestler.isHoldingOut) const Padding(padding: EdgeInsets.only(top: 2), child: Text("⚠ HOLDING OUT", style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildSandbox(dynamic rosterState, {required bool isDesktop}) {
    int maxWeeks = _isSpecialAttraction ? 12 : 52; // 🚨 MAX 12 WEEKS FOR BOSSES

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("NEGOTIATION", style: TextStyle(color: Colors.white, fontSize: isDesktop ? 20 : 16, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
            Text("Budget: \$${rosterState.bankAccount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}", style: const TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: Divider(color: Colors.white24)),
        
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(fit: BoxFit.scaleDown, child: Text("Upfront Signing Bonus: \$${_offeredBonus.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                Slider(value: _offeredBonus, min: 0, max: 100000, divisions: 100, activeColor: Colors.green, onChanged: _isNegotiating ? (val) => setState(() => _offeredBonus = val) : null),
                const SizedBox(height: 10),

                FittedBox(fit: BoxFit.scaleDown, child: Text("Weekly Appearance Pay: \$${_offeredSalary.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                Slider(value: _offeredSalary, min: 500, max: 20000, divisions: 195, activeColor: Colors.blueAccent, onChanged: _isNegotiating ? (val) => setState(() => _offeredSalary = val) : null),
                const SizedBox(height: 10),

                // 🚨 SPECIAL ATTRACTION WARNING UI 
                if (_isSpecialAttraction)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.redAccent.withOpacity(0.5))),
                    child: const Text("SPECIAL ATTRACTION: Refuses to sign long-term deals. Maximum 12-week contract.", style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(child: FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text("Duration (Weeks)", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12)))),
                      Row(
                        children: [
                          IconButton(icon: const Icon(Icons.remove_circle_outline, color: Colors.amber), onPressed: (_isNegotiating && _offeredWeeks > 4) ? () { HapticFeedback.selectionClick(); setState(() => _offeredWeeks -= 4); } : null),
                          SizedBox(width: 30, child: Text("$_offeredWeeks", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900))),
                          IconButton(icon: const Icon(Icons.add_circle_outline, color: Colors.amber), onPressed: (_isNegotiating && _offeredWeeks < maxWeeks) ? () { HapticFeedback.selectionClick(); setState(() => _offeredWeeks += 4); } : null),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(8), border: Border.all(color: _creativeControl ? Colors.purpleAccent : Colors.transparent)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text("Creative Control (Veto)", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
                            const SizedBox(height: 4),
                            Text("Lowers asking price by 15%.", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10)),
                          ],
                        ),
                      ),
                      Switch(
                        value: _creativeControl,
                        activeColor: Colors.purpleAccent,
                        onChanged: _isNegotiating ? (val) { HapticFeedback.selectionClick(); setState(() => _creativeControl = val); } : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: _feedbackColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: _feedbackColor, width: 2)),
          child: Text(_aiFeedback, style: TextStyle(color: _feedbackColor, fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: () => Navigator.pop(context),
                  child: const FittedBox(fit: BoxFit.scaleDown, child: Text("CANCEL", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12))),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[700], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: _isNegotiating ? _submitOffer : null,
                  child: const FittedBox(fit: BoxFit.scaleDown, child: Text("SUBMIT OFFER", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1.5))),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}