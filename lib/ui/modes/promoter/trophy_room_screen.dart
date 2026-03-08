import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/milestone.dart';

class TrophyRoomScreen extends StatefulWidget {
  const TrophyRoomScreen({super.key});

  @override
  State<TrophyRoomScreen> createState() => _TrophyRoomScreenState();
}

class _TrophyRoomScreenState extends State<TrophyRoomScreen> {
  List<Milestone> _milestones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMilestones();
  }

  Future<void> _loadMilestones() async {
    final isar = Isar.getInstance();
    if (isar != null) {
      final milestones = await isar.milestones.where().findAll();
      if (mounted) {
        setState(() {
          _milestones = milestones;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int unlockedCount = _milestones.where((m) => m.isUnlocked).length;
    double progress = _milestones.isEmpty ? 0 : unlockedCount / _milestones.length;

    // 🚨 RESPONSIVE CHECK: Are we on Mobile or PC?
    final bool isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("PROMOTER MILESTONES", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.amber),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.amber))
        : Column(
            children: [
              // HEADER PROGRESS BAR
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF151515),
                  border: const Border(bottom: BorderSide(color: Colors.white10)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("CAREER COMPLETION", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                        Text("$unlockedCount / ${_milestones.length}", style: const TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.w900)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 12,
                        backgroundColor: Colors.white10,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),

              // THE GRID OF BADGES
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    // 🚨 RESPONSIVE GRID: 4 columns on PC, 2 columns on Mobile!
                    crossAxisCount: isDesktop ? 4 : 2, 
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    // Square on PC, slightly taller on mobile to fit the text
                    childAspectRatio: isDesktop ? 1.0 : 0.85, 
                  ),
                  itemCount: _milestones.length,
                  itemBuilder: (context, index) {
                    final m = _milestones[index];
                    return _buildBadgeCard(m);
                  },
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildBadgeCard(Milestone m) {
    return Container(
      decoration: BoxDecoration(
        color: m.isUnlocked ? const Color(0xFF1E1E1E) : const Color(0xFF121212),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: m.isUnlocked ? Colors.amber.withOpacity(0.5) : Colors.white10, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: m.isUnlocked ? Colors.amber.withOpacity(0.1) : Colors.white.withOpacity(0.05),
            ),
            child: Icon(
              IconData(m.iconCode, fontFamily: 'MaterialIcons'), 
              size: 32, 
              color: m.isUnlocked ? Colors.amber : Colors.white24
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              m.title, 
              textAlign: TextAlign.center, 
              style: TextStyle(
                color: m.isUnlocked ? Colors.white : Colors.white30, 
                fontWeight: FontWeight.bold, 
                fontSize: 13
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              m.description, 
              textAlign: TextAlign.center, 
              style: TextStyle(
                color: m.isUnlocked ? Colors.white70 : Colors.white12, // Made the text slightly visible when locked
                fontSize: 10,
                height: 1.3
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          if (m.isUnlocked && m.unlockDate != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(14), bottomRight: Radius.circular(14))
              ),
              child: Text(
                "UNLOCKED: ${DateFormat('MM/dd/yy').format(m.unlockDate!)}", 
                textAlign: TextAlign.center, 
                style: const TextStyle(color: Colors.amber, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.0)
              ),
            ),
          ] else ...[
            // Keep the spacing even if it's not unlocked
            const SizedBox(height: 25),
          ]
        ],
      ),
    );
  }
}