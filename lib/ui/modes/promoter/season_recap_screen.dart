import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../logic/game_state_provider.dart';
import '../../../data/models/wrestler.dart';
import '../../screens/hub_screen.dart';

class SeasonRecapScreen extends ConsumerStatefulWidget {
  const SeasonRecapScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SeasonRecapScreen> createState() => _SeasonRecapScreenState();
}

class _SeasonRecapScreenState extends ConsumerState<SeasonRecapScreen> {
  Wrestler? woty;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final isar = Isar.getInstance();
    if (isar != null) {
      final roster = await isar.wrestlers.where().findAll();
      roster.sort((a, b) => b.pop.compareTo(a.pop));
      if (roster.isNotEmpty) {
        woty = roster.first;
      }
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final ledger = gameState.ledger;

    double highestRating = 0.0;
    if (ledger.isNotEmpty) {
      highestRating = ledger.reduce((a, b) => a.showRating > b.showRating ? a : b).showRating;
    }

    final totalProfit = ledger.fold(0, (sum, e) => sum + e.profit);
    final nextYear = gameState.year + 1;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Row(
        children: [
          // LEFT COLUMN (40%) - The Data
          Expanded(
            flex: 4,
            child: Container(
              color: const Color(0xFF121212),
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'YEAR-END AWARDS GALA',
                    style: TextStyle(
                      fontSize: 32, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 50),
                  _buildStatRow('Event of the Year', '⭐ ${highestRating.toStringAsFixed(1)} Rating'),
                  const SizedBox(height: 30),
                  _buildStatRow('Wrestler of the Year', isLoading ? 'Loading...' : (woty?.name ?? 'N/A')),
                  const SizedBox(height: 30),
                  _buildStatRow('Total Annual Profit', '\$${totalProfit.toString()}'),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        await ref.read(gameProvider.notifier).processYearEnd();
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const HubScreen()),
                            (route) => false,
                          );
                        }
                      },
                      child: Text(
                        'ADVANCE TO YEAR $nextYear',
                        style: const TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // RIGHT COLUMN (60%) - The Visuals
          Expanded(
            flex: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/awards_gala.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[900],
                      child: const Center(
                        child: Icon(Icons.emoji_events, size: 150, color: Colors.amber),
                      ),
                    );
                  },
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF121212), Colors.transparent],
                      begin: Alignment.centerLeft,
                      end: Alignment.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title, 
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Text(
          value, 
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
}
