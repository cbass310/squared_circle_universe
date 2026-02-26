import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/promoter_provider.dart';
import '../../../data/models/wrestler.dart';
import '../../components/wrestler_avatar.dart';
import 'contract_negotiation_dialog.dart';
import '../../../logic/game_state_provider.dart';

class RosterScreen extends ConsumerStatefulWidget {
  const RosterScreen({super.key});

  @override
  ConsumerState<RosterScreen> createState() => _RosterScreenState();
}

class _RosterScreenState extends ConsumerState<RosterScreen> {
  Wrestler? _selectedWrestler;
  bool _isMyRosterSelected = true; 
  bool _isIRSelected = false;
  
  // 🚀 THE FIX: Custom Tab Index just like Communications!
  int _selectedTabIndex = 0; 

  void _selectWrestler(Wrestler w, bool isMyRoster, bool isIR, bool isDesktop) {
    setState(() {
      _selectedWrestler = w;
      _isMyRosterSelected = isMyRoster;
      _isIRSelected = isIR;
    });

    if (!isDesktop) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true, 
        backgroundColor: Colors.transparent, 
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.9, 
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) => Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(top: BorderSide(color: Colors.white24, width: 2)),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  height: 4, width: 40,
                  decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(2)),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: controller,
                    child: _buildRightDetailPanelContent(), 
                  ),
                ),
              ],
            ),
          ),
        ),
      ).whenComplete(() {
        _clearSelection();
      });
    }
  }

  void _clearSelection() {
    setState(() {
      _selectedWrestler = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("ROSTER MANAGEMENT", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.amber),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isDesktop
          ? Row(
              children: [
                Expanded(flex: 4, child: _buildLeftListPanel(isDesktop)),
                Expanded(flex: 6, child: _buildRightDetailPanelContent()), 
              ],
            )
          : _buildLeftListPanel(isDesktop), 
    );
  }

  // ----------------------------------------------------------------
  // LEFT PANEL (40%): THE LIST & TABS
  // ----------------------------------------------------------------
  Widget _buildLeftListPanel(bool isDesktop) {
    final rosterState = ref.watch(rosterProvider);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        border: isDesktop ? const Border(right: BorderSide(color: Colors.white10, width: 2)) : null,
      ),
      child: Column(
        children: [
          // 🚀 THE FIX: Exact same custom tab structure as Communications
          Container(
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white10))),
            child: Row(
              children: [
                _buildTab(0, "ACTIVE (${rosterState.roster.length}/12)"),
                _buildTab(1, "REHAB (${rosterState.injuredReserve.length}/3)"),
                _buildTab(2, "FREE AGENTS"),
              ],
            ),
          ),
          Expanded(
            child: _selectedTabIndex == 0 
                ? _buildListView(rosterState.roster, rosterState.isLoading, isMyRoster: true, isIR: false, isDesktop: isDesktop)
                : _selectedTabIndex == 1 
                    ? _buildListView(rosterState.injuredReserve, rosterState.isLoading, isMyRoster: false, isIR: true, isDesktop: isDesktop)
                    : _buildListView(rosterState.freeAgents, rosterState.isLoading, isMyRoster: false, isIR: false, isDesktop: isDesktop),
          ),
        ],
      ),
    );
  }

  // 🚀 THE FIX: Custom instant-click tab widget
  Widget _buildTab(int index, String title) {
    bool isSelected = _selectedTabIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
            _clearSelection(); 
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: isSelected ? Colors.amber : Colors.transparent, width: 3)),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.amber : Colors.grey,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                fontSize: 11,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListView(List<Wrestler> wrestlers, bool isLoading, {required bool isMyRoster, required bool isIR, required bool isDesktop}) {
    if (isLoading) return const Center(child: CircularProgressIndicator(color: Colors.amber));
    if (wrestlers.isEmpty) return const Center(child: Text("No wrestlers found in this section.", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)));

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: wrestlers.length,
      itemBuilder: (context, index) {
        final w = wrestlers[index];
        final isSelected = _selectedWrestler?.id == w.id;

        return GestureDetector(
          onTap: () => _selectWrestler(w, isMyRoster, isIR, isDesktop),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.amber.withOpacity(0.05) : const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.amber : (w.isHoldingOut ? Colors.redAccent : (w.isInjured ? Colors.orangeAccent : Colors.white10)),
                width: isSelected || w.isHoldingOut || w.isInjured ? 2.0 : 1.0,
              ),
            ),
            child: Row(
              children: [
                WrestlerAvatar(wrestler: w, size: 50),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(w.name, style: TextStyle(color: (w.isChampion || w.isTVChampion) ? Colors.amber : Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text("${w.style.name.toUpperCase()} • ${w.cardPosition.toUpperCase()}", style: const TextStyle(color: Colors.white54, fontSize: 10)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xFF6200EE).withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: Text("POP ${w.pop}", style: const TextStyle(color: Colors.purpleAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ----------------------------------------------------------------
  // RIGHT PANEL (60%): THE LOCKER ROOM DETAILS & ATTRIBUTES
  // ----------------------------------------------------------------
  Widget _buildRightDetailPanelContent() {
    if (_selectedWrestler == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.groups_rounded, size: 80, color: Colors.white10),
            SizedBox(height: 16),
            Text("SELECT A WRESTLER", style: TextStyle(color: Colors.white30, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
          ],
        ),
      );
    }

    final w = _selectedWrestler!;
    final notifier = ref.read(rosterProvider.notifier);
    final rosterState = ref.watch(rosterProvider);

    IconData moraleIcon = Icons.sentiment_satisfied_alt;
    Color moraleColor = Colors.greenAccent;
    if (w.morale < 40) { moraleIcon = Icons.sentiment_very_dissatisfied; moraleColor = Colors.redAccent; } 
    else if (w.morale < 75) { moraleIcon = Icons.sentiment_neutral; moraleColor = Colors.amber; }

    return Container(
      color: Colors.black,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. HERO PROFILE CARD ---
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.amber, width: 2)),
                  child: WrestlerAvatar(wrestler: w, size: 100),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(w.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                      const SizedBox(height: 4),
                      Text("${w.style.name.toUpperCase()} • ${w.isHeel ? 'HEEL' : 'FACE'} • ${w.cardPosition.toUpperCase()}", style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      if (w.isHoldingOut) const Text("⚠ HOLDING OUT", style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                      if (w.isInjured) Text("🚑 INJURED: ${w.injuryWeeks} WEEKS", style: const TextStyle(color: Colors.orangeAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // --- 2. KEY ATTRIBUTES GRID ---
            const Text("ATTRIBUTES", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildAttributeBox("POPULARITY", w.pop.toString(), Colors.purpleAccent)),
                const SizedBox(width: 12),
                Expanded(child: _buildAttributeBox("STAMINA", "${w.stamina}%", w.stamina < 50 ? Colors.redAccent : Colors.greenAccent)),
                const SizedBox(width: 12),
                Expanded(child: _buildAttributeBox("MORALE", "${w.morale}%", moraleColor, icon: moraleIcon)),
              ],
            ),
            const SizedBox(height: 32),

            // --- 3. CONTRACT & RELEASE SECTION (THE BUYOUT MECHANIC) ---
            const Text("CONTRACT STATUS", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isMyRosterSelected || _isIRSelected) ...[
                    Text("Wrestler is currently under a ${w.contractWeeks} week contract.", style: const TextStyle(color: Colors.white, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text("Salary: \$${w.salary} / week", style: const TextStyle(color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 16)),
                            icon: const Icon(Icons.monetization_on),
                            label: const Text("RENEGOTIATE", style: TextStyle(fontWeight: FontWeight.bold)),
                            onPressed: () => showDialog(context: context, builder: (_) => ContractNegotiationDialog(wrestler: w)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // 🔴 THE 50% BUYOUT RELEASE BUTTON 🔴
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent, side: const BorderSide(color: Colors.redAccent), padding: const EdgeInsets.symmetric(vertical: 16)),
                            icon: const Icon(Icons.person_remove),
                            label: const Text("RELEASE", style: TextStyle(fontWeight: FontWeight.bold)),
                            onPressed: () => _confirmRelease(context, w, notifier),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Free Agent View
                    const Text("Wrestler is currently a Free Agent.", style: TextStyle(color: Colors.white, fontSize: 14)),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 16)),
                        icon: const Icon(Icons.edit_document),
                        label: const Text("SIGN FREE AGENT", style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () {
                          if (rosterState.roster.length >= 12) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Roster Full! Release someone first."), backgroundColor: Colors.red));
                          } else {
                            showDialog(context: context, builder: (_) => ContractNegotiationDialog(wrestler: w));
                          }
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- 4. MANAGEMENT & CREATIVE CONTROL ---
            if (_isMyRosterSelected || _isIRSelected) ...[
              const Text("MANAGEMENT & CREATIVE", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
              const SizedBox(height: 12),
              
              if (_isIRSelected)
                _buildActionTile("ACTIVATE TO ROSTER", "Move back to active competition.", Icons.local_hospital, Colors.blueAccent, () async {
                  if (rosterState.roster.length >= 12) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Roster Full! Free up a slot first."), backgroundColor: Colors.red));
                    return;
                  }
                  await notifier.removeFromIR(w);
                  _clearSelection();
                  if (mounted) Navigator.pop(context); // Close mobile sheet if open
                }),

              if (_isMyRosterSelected && w.isInjured)
                _buildActionTile("MOVE TO REHAB (IR)", "Frees up an active slot.", Icons.warning, Colors.orangeAccent, () {
                  notifier.moveToIR(w);
                  _clearSelection();
                  if (mounted) Navigator.pop(context); // Close mobile sheet if open
                }),

              _buildActionTile("💊 MEDICAL REHAB (\$5,000)", "Heals Fatigue/Injury.", Icons.healing, Colors.greenAccent, () => notifier.trainingAction(w, "HEAL", 5000)),
              _buildActionTile("💰 CASH BONUS (\$2,000)", "Morale +15.", Icons.attach_money, Colors.amber, () => notifier.trainingAction(w, "BONUS", 2000)),
              _buildActionTile("🏋️ RING TRAINING (\$10,000)", "Ring Skill +1.", Icons.fitness_center, Colors.blue, () => notifier.trainingAction(w, "RING", 10000)),
              _buildActionTile("🎤 PROMO CLASS (\$10,000)", "Mic Skill +1.", Icons.mic, Colors.purple, () => notifier.trainingAction(w, "MIC", 10000)),
              _buildActionTile("TURN ${w.isHeel ? 'FACE' : 'HEEL'}", "Switch alignment instantly.", Icons.compare_arrows, Colors.white, () {
                notifier.turnHeelFace(w);
                setState(() {}); 
              }),
              _buildActionTile("REPACKAGE STYLE", "Change wrestling style.", Icons.accessibility_new, Colors.cyan, () => _showStyleDialog(context, w, notifier)),
              _buildActionTile("RENAME WRESTLER", "Change their ring name.", Icons.edit, Colors.grey, () => _showRenameDialog(context, w, notifier)),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------
  // HELPER WIDGETS & DIALOGS
  // ----------------------------------------------------------------

  Widget _buildAttributeBox(String label, String value, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.3))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[Icon(icon, color: color, size: 14), const SizedBox(width: 4)],
              Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildActionTile(String title, String subtitle, IconData icon, Color iconColor, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white10)),
      child: ListTile(
        leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: iconColor, size: 20)),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 10)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white24),
        onTap: () {
          onTap();
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$title applied."), backgroundColor: Colors.green));
        },
      ),
    );
  }

  void _confirmRelease(BuildContext context, Wrestler w, RosterNotifier notifier) {
    final int buyoutCost = (w.contractWeeks * w.salary) ~/ 2;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("RELEASE WRESTLER?", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          "Are you sure you want to release ${w.name}?\n\nTo break the contract early, you must buy out 50% of their remaining balance.\n\nBuyout Cost: \$${buyoutCost.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}", 
          style: const TextStyle(color: Colors.white70)
        ),
        actions: [
          TextButton(child: const Text("Cancel", style: TextStyle(color: Colors.grey)), onPressed: () => Navigator.pop(ctx)),
          TextButton(
            child: const Text("PAY BUYOUT & RELEASE", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.pop(ctx); 
              notifier.releaseWrestler(w);
              _clearSelection();
              if (mounted) {
                Navigator.pop(context); // Close mobile sheet if open
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${w.name} released. \$$buyoutCost buyout paid."), backgroundColor: Colors.red));
              }
            },
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(BuildContext context, Wrestler w, RosterNotifier notifier) {
    final txtController = TextEditingController(text: w.name);
    showDialog(context: context, builder: (dialogContext) => AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      title: const Text("RENAME WRESTLER", style: TextStyle(color: Colors.white)),
      content: TextField(controller: txtController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)))),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text("CANCEL", style: TextStyle(color: Colors.amber))),
        TextButton(
          onPressed: () {
            if (txtController.text.isNotEmpty) {
              notifier.renameWrestler(w, txtController.text);
              setState(() {}); 
            }
            Navigator.pop(dialogContext); 
          }, 
          child: const Text("SAVE", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))
        ),
      ],
    ));
  }

  void _showStyleDialog(BuildContext context, Wrestler w, RosterNotifier notifier) {
    showModalBottomSheet(context: context, backgroundColor: const Color(0xFF1E1E1E), builder: (sheetContext) => Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("SELECT NEW FIGHTING STYLE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildStyleOption(context, "BRAWLER (Puncher)", WrestlingStyle.brawler, notifier, w),
          _buildStyleOption(context, "TECHNICIAN (Grappler)", WrestlingStyle.technician, notifier, w),
          _buildStyleOption(context, "HIGH FLYER (Speed)", WrestlingStyle.highFlyer, notifier, w),
          _buildStyleOption(context, "GIANT (Power)", WrestlingStyle.giant, notifier, w),
          _buildStyleOption(context, "ENTERTAINER (Charisma)", WrestlingStyle.entertainer, notifier, w),
        ],
      ),
    ));
  }

  Widget _buildStyleOption(BuildContext context, String label, WrestlingStyle style, RosterNotifier notifier, Wrestler w) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.white)),
      leading: Icon(Icons.circle, color: style == w.style ? Colors.amber : Colors.grey, size: 10),
      onTap: () {
        notifier.repackageWrestler(w, style);
        setState(() {}); 
        Navigator.pop(context); 
      },
    );
  }
}