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

  // 🚨 EXPANDED ICON MAP FOR 50 TROPHIES (PREVENTS TREE-SHAKING CRASHES)
  IconData _getIcon(int codePoint) {
    // Financial
    if (codePoint == Icons.attach_money.codePoint) return Icons.attach_money;
    if (codePoint == Icons.money.codePoint) return Icons.money;
    if (codePoint == Icons.account_balance_wallet.codePoint) return Icons.account_balance_wallet;
    if (codePoint == Icons.savings.codePoint) return Icons.savings;
    if (codePoint == Icons.price_change.codePoint) return Icons.price_change;
    if (codePoint == Icons.monetization_on.codePoint) return Icons.monetization_on;
    if (codePoint == Icons.domain.codePoint) return Icons.domain;
    if (codePoint == Icons.account_balance.codePoint) return Icons.account_balance;
    if (codePoint == Icons.diamond.codePoint) return Icons.diamond;
    
    // Infrastructure & Fans
    if (codePoint == Icons.group.codePoint) return Icons.group;
    if (codePoint == Icons.groups.codePoint) return Icons.groups;
    if (codePoint == Icons.map.codePoint) return Icons.map;
    if (codePoint == Icons.public.codePoint) return Icons.public;
    if (codePoint == Icons.language.codePoint) return Icons.language;
    if (codePoint == Icons.business.codePoint) return Icons.business;
    if (codePoint == Icons.location_city.codePoint) return Icons.location_city;
    if (codePoint == Icons.stadium.codePoint) return Icons.stadium;
    if (codePoint == Icons.handshake.codePoint) return Icons.handshake;
    if (codePoint == Icons.storefront.codePoint) return Icons.storefront;
    
    // Broadcasting
    if (codePoint == Icons.tv.codePoint) return Icons.tv;
    if (codePoint == Icons.live_tv.codePoint) return Icons.live_tv;
    if (codePoint == Icons.nightlight_round.codePoint) return Icons.nightlight_round;
    if (codePoint == Icons.confirmation_number.codePoint) return Icons.confirmation_number;
    if (codePoint == Icons.video_camera_front.codePoint) return Icons.video_camera_front;
    
    // Booking & Creative
    if (codePoint == Icons.star_half.codePoint) return Icons.star_half;
    if (codePoint == Icons.star.codePoint) return Icons.star;
    if (codePoint == Icons.workspace_premium.codePoint) return Icons.workspace_premium;
    if (codePoint == Icons.auto_awesome.codePoint) return Icons.auto_awesome;
    if (codePoint == Icons.thumb_down.codePoint) return Icons.thumb_down;
    if (codePoint == Icons.people_alt.codePoint) return Icons.people_alt;
    if (codePoint == Icons.local_fire_department.codePoint) return Icons.local_fire_department;
    if (codePoint == Icons.flash_on.codePoint) return Icons.flash_on;
    if (codePoint == Icons.emoji_events.codePoint) return Icons.emoji_events;
    if (codePoint == Icons.military_tech.codePoint) return Icons.military_tech;
    
    // Roster & Management
    if (codePoint == Icons.history_edu.codePoint) return Icons.history_edu;
    if (codePoint == Icons.transfer_within_a_station.codePoint) return Icons.transfer_within_a_station;
    if (codePoint == Icons.outbox.codePoint) return Icons.outbox;
    if (codePoint == Icons.local_hospital.codePoint) return Icons.local_hospital;
    if (codePoint == Icons.school.codePoint) return Icons.school;
    if (codePoint == Icons.trending_up.codePoint) return Icons.trending_up;
    if (codePoint == Icons.fitness_center.codePoint) return Icons.fitness_center;
    if (codePoint == Icons.mic.codePoint) return Icons.mic;
    if (codePoint == Icons.mood.codePoint) return Icons.mood;
    if (codePoint == Icons.show_chart.codePoint) return Icons.show_chart;
    
    // Longevity
    if (codePoint == Icons.calendar_view_week.codePoint) return Icons.calendar_view_week;
    if (codePoint == Icons.calendar_month.codePoint) return Icons.calendar_month;
    if (codePoint == Icons.celebration.codePoint) return Icons.celebration;
    if (codePoint == Icons.cake.codePoint) return Icons.cake;
    
    return Icons.emoji_events; // Fallback
  }

  @override
  Widget build(BuildContext context) {
    int unlockedCount = _milestones.where((m) => m.isUnlocked).length;
    double progress = _milestones.isEmpty ? 0 : unlockedCount / _milestones.length;

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
                    crossAxisCount: isDesktop ? 4 : 2, 
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
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
              _getIcon(m.iconCode),
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
                color: m.isUnlocked ? Colors.white70 : Colors.white12,
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
            const SizedBox(height: 25),
          ]
        ],
      ),
    );
  }
}