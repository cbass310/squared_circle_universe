import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/promoter_provider.dart';
import '../../../data/models/wrestler.dart';
import '../../components/wrestler_avatar.dart';
import 'contract_negotiation_dialog.dart';

class RosterScreen extends ConsumerWidget {
  const RosterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rosterState = ref.watch(rosterProvider);
    final notifier = ref.read(rosterProvider.notifier);

    return DefaultTabController(
      length: 3, 
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          title: const Text("ROSTER MANAGEMENT", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0)),
          backgroundColor: Colors.transparent,
          bottom: TabBar(
            indicatorColor: Colors.amber,
            labelColor: Colors.amber,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: "ACTIVE (${rosterState.roster.length}/12)"), 
              Tab(text: "REHAB (${rosterState.injuredReserve.length}/3)"), 
              const Tab(text: "FREE AGENTS"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // TAB 1: ACTIVE ROSTER
            rosterState.isLoading 
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: rosterState.roster.length,
                itemBuilder: (context, index) {
                  final w = rosterState.roster[index];
                  // FIX: Passed rosterState down to the card
                  return _buildRosterCard(context, w, notifier, rosterState, isMyRoster: true, isIR: false);
                },
              ),

            // TAB 2: INJURED RESERVE (THE REHAB CENTER)
            rosterState.isLoading 
              ? const Center(child: CircularProgressIndicator())
              : rosterState.injuredReserve.isEmpty 
                  ? const Center(child: Text("Rehab Center is empty.", style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: rosterState.injuredReserve.length,
                      itemBuilder: (context, index) {
                        final w = rosterState.injuredReserve[index];
                        // FIX: Passed rosterState down to the card
                        return _buildRosterCard(context, w, notifier, rosterState, isMyRoster: false, isIR: true);
                      },
                    ),
              
            // TAB 3: FREE AGENTS
            rosterState.isLoading 
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: rosterState.freeAgents.length,
                itemBuilder: (context, index) {
                  final w = rosterState.freeAgents[index];
                  // FIX: Passed rosterState down to the card
                  return _buildRosterCard(context, w, notifier, rosterState, isMyRoster: false, isIR: false);
                },
              ),
          ],
        ),
      ),
    );
  }

  // FIX: Added 'RosterState state' to the parameters so we can check the hard cap!
  Widget _buildRosterCard(BuildContext context, Wrestler w, RosterNotifier notifier, RosterState state, {required bool isMyRoster, required bool isIR}) {
    IconData moraleIcon = Icons.sentiment_satisfied_alt;
    Color moraleColor = Colors.green;
    if (w.morale < 40) { moraleIcon = Icons.sentiment_very_dissatisfied; moraleColor = Colors.red; } 
    else if (w.morale < 75) { moraleIcon = Icons.sentiment_neutral; moraleColor = Colors.amber; }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: w.isHoldingOut ? Colors.redAccent : w.isInjured ? Colors.orangeAccent : Colors.white10,
          width: w.isHoldingOut || w.isInjured ? 2.0 : 1.0
        ),
      ),
      child: Row(
        children: [
          WrestlerAvatar(wrestler: w, size: 60),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(w.name, style: TextStyle(color: (w.isChampion || w.isTVChampion) ? Colors.amber : Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text("${w.style.name.toUpperCase()} • ${w.cardPosition.toUpperCase()}", style: const TextStyle(color: Colors.white70, fontSize: 10)),
                const SizedBox(height: 5),
                
                if (isMyRoster || isIR)
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(value: w.stamina / 100, backgroundColor: Colors.grey[800], color: Colors.greenAccent, minHeight: 4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(moraleIcon, color: moraleColor, size: 18),
                    ],
                  ),
                const SizedBox(height: 5),
                
                // Status Indicators
                if (w.isHoldingOut)
                  const Text("⚠ HOLDOUT: RENEGOTIATE NOW", style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold))
                else if (w.isInjured)
                  Text("🚑 INJURED: ${w.injuryWeeks} WEEKS LEFT", style: const TextStyle(color: Colors.orangeAccent, fontSize: 10, fontWeight: FontWeight.bold))
                else if (isMyRoster)
                  Row(
                    children: [
                       Icon(Icons.timer, size: 12, color: w.contractWeeks < 4 ? Colors.red : Colors.grey),
                       Text(" ${w.contractWeeks} wks left • \$${w.salary}/wk", style: TextStyle(color: w.contractWeeks < 4 ? Colors.red : Colors.grey, fontSize: 10)),
                    ],
                  ),
              ],
            ),
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF6200EE), borderRadius: BorderRadius.circular(4)),
                child: Text("POP ${w.pop}", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              
              // --- DYNAMIC ACTION BUTTONS ---
              if (isIR)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0), minimumSize: const Size(0, 30)),
                  onPressed: () async {
                    // FIX: Blocks activating if roster is 12/12
                    if (state.roster.length >= 12) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Roster Full! Free up a slot first."), backgroundColor: Colors.red));
                      return;
                    }
                    try {
                      await notifier.removeFromIR(w);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Activated to Main Roster!"), backgroundColor: Colors.green));
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
                      }
                    }
                  },
                  child: const Text("ACTIVATE", style: TextStyle(fontSize: 10)),
                )
              else if (!isMyRoster)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0), minimumSize: const Size(0, 30)),
                  onPressed: () {
                    // FIX: Blocks opening the Negotiation Dialog if roster is 12/12
                    if (state.roster.length >= 12) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Roster Full! Release someone or move them to IR first.", style: TextStyle(fontWeight: FontWeight.bold)), 
                          backgroundColor: Colors.red
                        )
                      );
                    } else {
                      showDialog(context: context, builder: (_) => ContractNegotiationDialog(wrestler: w));
                    }
                  },
                  child: const Text("NEGOTIATE", style: TextStyle(fontSize: 10)),
                )
              else 
                Row(
                  children: [
                    InkWell(
                      onTap: () => _showManagementMenu(context, w, notifier),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.blue.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                        child: const Icon(Icons.settings, color: Colors.blueAccent, size: 20),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        showDialog(context: context, builder: (_) => ContractNegotiationDialog(wrestler: w));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                        child: const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
                      ),
                    )
                  ],
                )
            ],
          ),
        ],
      ),
    );
  }

  void _showManagementMenu(BuildContext context, Wrestler w, RosterNotifier notifier) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      backgroundColor: const Color(0xFF1E1E1E),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("MANAGE: ${w.name.toUpperCase()}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              const Divider(color: Colors.grey),
              const SizedBox(height: 10),
              
              ListTile(
                leading: const Icon(Icons.local_hospital, color: Colors.orangeAccent),
                title: const Text("MOVE TO INJURED RESERVE", style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
                subtitle: const Text("Frees up 1 active roster slot. (Requires active injury)", style: TextStyle(color: Colors.white70, fontSize: 10)),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
                onTap: () {
                  Navigator.pop(sheetContext); 
                  if (w.isInjured) {
                    notifier.moveToIR(w);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You cannot place a healthy wrestler on IR!"), backgroundColor: Colors.red));
                  }
                },
              ),
              const Divider(color: Colors.white10),

              const Text("TRAINING & BONUSES", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              _buildManageOption(sheetContext, "💊 MEDICAL REHAB", "Heals Fatigue/Injury", 5000, () => notifier.trainingAction(w, "HEAL", 5000)),
              _buildManageOption(sheetContext, "💰 CASH BONUS", "Morale +15", 2000, () => notifier.trainingAction(w, "BONUS", 2000)),
              _buildManageOption(sheetContext, "🏋️ RING TRAINING", "Ring Skill +1 (Permanent)", 10000, () => notifier.trainingAction(w, "RING", 10000)),
              _buildManageOption(sheetContext, "🎤 PROMO CLASS", "Mic Skill +1 (Permanent)", 10000, () => notifier.trainingAction(w, "MIC", 10000)),
              
              const SizedBox(height: 20),
              
              const Text("CREATIVE CONTROL", style: TextStyle(color: Colors.blueAccent, fontSize: 10, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text("RENAME WRESTLER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: const Text("Change name instantly", style: TextStyle(color: Colors.white70, fontSize: 10)),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
                onTap: () {
                  Navigator.pop(sheetContext); 
                  _showRenameDialog(context, w, notifier); 
                },
              ),

              ListTile(
                leading: const Icon(Icons.compare_arrows, color: Colors.purple),
                title: Text("TURN ${w.isHeel ? 'FACE (GOOD)' : 'HEEL (BAD)'}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: const Text("Switch alignment (Free)", style: TextStyle(color: Colors.white70, fontSize: 10)),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
                onTap: () {
                  notifier.turnHeelFace(w);
                  Navigator.pop(sheetContext); 
                },
              ),

              ListTile(
                leading: const Icon(Icons.accessibility_new, color: Colors.orange),
                title: const Text("REPACKAGE (CHANGE STYLE)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text("Current: ${w.style.name.toUpperCase()}", style: const TextStyle(color: Colors.white70, fontSize: 10)),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
                onTap: () {
                  Navigator.pop(sheetContext); 
                  _showStyleDialog(context, w, notifier); 
                },
              ),

              ListTile(
                leading: const Icon(Icons.person_remove, color: Colors.red),
                title: const Text("RELEASE CONTRACT", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                subtitle: const Text("Drop to Free Agency (Lose upfront bonus)", style: TextStyle(color: Colors.white70, fontSize: 10)),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
                onTap: () {
                  Navigator.pop(sheetContext); 
                  notifier.releaseWrestler(w);
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        );
      }
    );
  }

  Widget _buildManageOption(BuildContext context, String title, String sub, int cost, Future<void> Function() action) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(8)),
        child: Text("\$$cost", style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: Text(sub, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
      onTap: () async {
        await action();
        
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Action Complete!"), backgroundColor: Colors.green)
          );
        }
      },
    );
  }

  void _showRenameDialog(BuildContext context, Wrestler w, RosterNotifier notifier) {
    final txtController = TextEditingController(text: w.name);
    showDialog(
      context: context, 
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("RENAME WRESTLER", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: txtController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue))),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text("CANCEL")),
          TextButton(
            onPressed: () {
              if (txtController.text.isNotEmpty) {
                notifier.renameWrestler(w, txtController.text);
              }
              Navigator.pop(dialogContext); 
            }, 
            child: const Text("SAVE")
          ),
        ],
      )
    );
  }

  void _showStyleDialog(BuildContext context, Wrestler w, RosterNotifier notifier) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("SELECT NEW FIGHTING STYLE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            Column(
              children: [
                _buildStyleOption(context, "BRAWLER (Puncher)", WrestlingStyle.brawler, notifier, w),
                _buildStyleOption(context, "TECHNICIAN (Grappler)", WrestlingStyle.technician, notifier, w),
                _buildStyleOption(context, "HIGH FLYER (Speed)", WrestlingStyle.highFlyer, notifier, w),
                _buildStyleOption(context, "GIANT (Power)", WrestlingStyle.giant, notifier, w),
                _buildStyleOption(context, "ENTERTAINER (Charisma)", WrestlingStyle.entertainer, notifier, w),
              ],
            )
          ],
        ),
      )
    );
  }

  Widget _buildStyleOption(BuildContext context, String label, WrestlingStyle style, RosterNotifier notifier, Wrestler w) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.white)),
      leading: Icon(Icons.circle, color: style == w.style ? Colors.green : Colors.grey, size: 10),
      onTap: () {
        notifier.repackageWrestler(w, style);
        Navigator.pop(context); 
      },
    );
  }
}