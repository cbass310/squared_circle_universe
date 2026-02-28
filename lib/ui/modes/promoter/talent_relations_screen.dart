import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

// --- LOGIC IMPORTS ---
import '../../../data/models/wrestler.dart';
import '../../../logic/promoter_provider.dart';
import '../../../logic/game_state_provider.dart';

class TalentRelationsScreen extends ConsumerStatefulWidget {
  const TalentRelationsScreen({super.key});

  @override
  ConsumerState<TalentRelationsScreen> createState() => _TalentRelationsScreenState();
}

class _TalentRelationsScreenState extends ConsumerState<TalentRelationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Wrestler> _freeAgents = [];
  List<Wrestler> _rivalRoster = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTalentPool();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 📥 FETCH THE TALENT FROM ISAR
  Future<void> _loadTalentPool() async {
    setState(() => _isLoading = true);
    final isar = Isar.getInstance();
    if (isar != null) {
      final fa = await isar.wrestlers.filter().companyIdEqualTo(-1).findAll();
      final rivals = await isar.wrestlers.filter().companyIdEqualTo(1).findAll();
      
      // Sort by popularity (biggest stars at the top)
      fa.sort((a, b) => b.pop.compareTo(a.pop));
      rivals.sort((a, b) => b.pop.compareTo(a.pop));

      if (mounted) {
        setState(() {
          _freeAgents = fa;
          _rivalRoster = rivals;
          _isLoading = false;
        });
      }
    }
  }

  // ✍️ SIGN A WRESTLER LOGIC
  Future<void> _signWrestler(Wrestler w) async {
    HapticFeedback.heavyImpact();
    final gameState = ref.read(gameProvider);
    
    // We will charge a 4-week upfront signing bonus
    int signingBonus = w.salary * 4;

    if (gameState.cash < signingBonus) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Not enough cash for the signing bonus!", style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.redAccent));
      return;
    }

    // 1. Deduct Cash
    ref.read(gameProvider.notifier).spendCash(signingBonus);

    // 2. Update Database (Change companyId to 0 for Player)
    final isar = Isar.getInstance();
    if (isar != null) {
      await isar.writeTxn(() async {
        w.companyId = 0;
        w.contractWeeks = 48; // 1 Year Deal
        await isar.wrestlers.put(w);
      });
    }

    // 3. Refresh Rosters
    ref.read(rosterProvider.notifier).loadRoster(); // Updates your main roster
    await _loadTalentPool(); // Removes them from this screen

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("SIGNED ${w.name.toUpperCase()}!", style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.black)), backgroundColor: Colors.greenAccent));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 10,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.grey), onPressed: () => Navigator.pop(context)),
        title: const Text("TALENT RELATIONS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.cyanAccent,
          indicatorWeight: 4,
          labelColor: Colors.cyanAccent,
          unselectedLabelColor: Colors.white54,
          labelStyle: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5),
          tabs: const [
            Tab(text: "FREE AGENTS"),
            Tab(text: "RIVAL ROSTER"),
          ],
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.cyanAccent))
        : TabBarView(
            controller: _tabController,
            children: [
              _buildTalentList(_freeAgents, isRival: false),
              _buildTalentList(_rivalRoster, isRival: true),
            ],
          ),
    );
  }

  Widget _buildTalentList(List<Wrestler> talent, {required bool isRival}) {
    if (talent.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isRival ? Icons.security : Icons.search_off_rounded, size: 60, color: Colors.white24),
            const SizedBox(height: 16),
            Text(isRival ? "RIVAL ROSTER EMPTY" : "NO FREE AGENTS AVAILABLE", style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: talent.length,
      itemBuilder: (context, index) {
        final w = talent[index];
        final int signingBonus = w.salary * 4;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isRival ? Colors.redAccent.withOpacity(0.3) : Colors.cyanAccent.withOpacity(0.3), width: 1),
          ),
          child: Row(
            children: [
              // 🖼️ THE CUSTOM AVATAR LOADER!
              Container(
                width: 80,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(11), bottomLeft: Radius.circular(11)),
                  image: w.imageUrl != null && w.imageUrl!.isNotEmpty
                      ? DecorationImage(image: NetworkImage(w.imageUrl!), fit: BoxFit.cover)
                      : null,
                ),
                child: (w.imageUrl == null || w.imageUrl!.isEmpty) 
                    ? Icon(Icons.person, color: Colors.white24, size: 40) 
                    : null,
              ),
              const SizedBox(width: 16),
              
              // WRESTLER INFO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(w.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                    Text("${w.style.name.toUpperCase()} • POP: ${w.pop}", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.attach_money_rounded, color: Colors.greenAccent, size: 14),
                        Text("${w.salary}/wk", style: const TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 12),
                        const Icon(Icons.handshake_rounded, color: Colors.amber, size: 14),
                        Text("\$$signingBonus Bonus", style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),

              // ACTION BUTTON
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: isRival 
                  ? OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.redAccent),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        // For V1, Rivals are locked. Later we add a "Poaching" mechanic!
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Under Contract! Wait for it to expire."), backgroundColor: Colors.redAccent));
                      },
                      child: const Text("LOCKED", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w900)),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => _signWrestler(w),
                      child: const Text("SIGN", style: TextStyle(fontWeight: FontWeight.w900)),
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}