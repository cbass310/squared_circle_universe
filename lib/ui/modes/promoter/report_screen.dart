import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../logic/game_state_provider.dart';
import '../../../data/models/financial_record.dart';

final financialHistoryProvider = FutureProvider.autoDispose<List<FinancialRecord>>((ref) async {
  final isar = Isar.getInstance();
  if (isar == null) return [];
  // Grab the last 4 weeks
  return await isar.financialRecords.where().sortByYearDesc().thenByWeekDesc().limit(4).findAll();
});

class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final historyAsync = ref.watch(financialHistoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("EXECUTIVE LEDGER", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        backgroundColor: Colors.transparent,
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.amber)),
        error: (err, stack) => Center(child: Text("Error: $err", style: const TextStyle(color: Colors.red))),
        data: (records) {
          if (records.isEmpty) {
            return const Center(child: Text("No financial data yet. Run your first show!", style: TextStyle(color: Colors.grey)));
          }

          final lastWeek = records.first;
          
          // Calculate Runway based on average of up to last 3 weeks
          int totalNet = 0;
          int count = records.length > 3 ? 3 : records.length;
          for (int i = 0; i < count; i++) {
            totalNet += records[i].netProfit;
          }
          int avgNet = totalNet ~/ count;
          
          String runwayText;
          Color runwayColor;
          if (avgNet >= 0) {
            runwayText = "RUNWAY: INFINITE (PROFITABLE)";
            runwayColor = Colors.greenAccent;
          } else {
            int weeksLeft = gameState.cash ~/ avgNet.abs();
            runwayText = "WARNING: BUDGET EXHAUSTED IN $weeksLeft WEEKS";
            runwayColor = Colors.redAccent;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==========================================
                // ZONE 1: THE BOTTOM LINE
                // ==========================================
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
                  child: Column(
                    children: [
                      const Text("CASH ON HAND", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                      const SizedBox(height: 5),
                      Text("\$${_format(gameState.cash)}", style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Last Wk Delta: ", style: TextStyle(color: Colors.white.withOpacity(0.7))),
                          Text("${lastWeek.netProfit >= 0 ? '+' : ''}\$${_format(lastWeek.netProfit)}", style: TextStyle(color: lastWeek.netProfit >= 0 ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                      const Divider(color: Colors.white10, height: 30),
                      Text(runwayText, style: TextStyle(color: runwayColor, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // ==========================================
                // ZONE 2: VISUAL BALANCE SHEET (BUCKETS)
                // ==========================================
                const Text("LAST WEEK'S BUCKETS", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                const SizedBox(height: 10),
                
                // INCOME BAR
                const Text("TOTAL INCOME", style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 5),
                _buildStackedBar([
                  _BarSegment(lastWeek.tvRevenue, Colors.blue),
                  _BarSegment(lastWeek.ticketSales, Colors.green),
                  _BarSegment(lastWeek.ppvRevenue, Colors.orange),
                  _BarSegment(lastWeek.sponsorshipRevenue, Colors.purple),
                  _BarSegment(lastWeek.merchandiseSales, Colors.yellow),
                ]),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10, runSpacing: 10,
                  children: [
                    _buildLegend("TV/Network", Colors.blue, lastWeek.tvRevenue),
                    _buildLegend("Tickets", Colors.green, lastWeek.ticketSales),
                    if (lastWeek.ppvRevenue > 0) _buildLegend("PPV Buys", Colors.orange, lastWeek.ppvRevenue),
                    if (lastWeek.sponsorshipRevenue > 0) _buildLegend("Sponsors", Colors.purple, lastWeek.sponsorshipRevenue),
                    _buildLegend("Merch", Colors.yellow, lastWeek.merchandiseSales),
                  ],
                ),
                const SizedBox(height: 25),

                // EXPENSE BAR
                const Text("TOTAL EXPENSES", style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 5),
                _buildStackedBar([
                  _BarSegment(lastWeek.rosterPayroll, Colors.redAccent),
                  _BarSegment(lastWeek.productionCosts, Colors.orangeAccent),
                  _BarSegment(lastWeek.logisticsCosts, Colors.brown),
                  _BarSegment(lastWeek.facilityCosts, Colors.teal),
                ]),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10, runSpacing: 10,
                  children: [
                    _buildLegend("Payroll", Colors.redAccent, lastWeek.rosterPayroll),
                    _buildLegend("Production/Pyro", Colors.orangeAccent, lastWeek.productionCosts),
                    _buildLegend("Venue Rent", Colors.brown, lastWeek.logisticsCosts),
                    _buildLegend("Facilities", Colors.teal, lastWeek.facilityCosts),
                  ],
                ),
                const SizedBox(height: 30),

                // ==========================================
                // ZONE 3: TRANSACTION LOG
                // ==========================================
                const Text("HISTORICAL LEDGER", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                const SizedBox(height: 10),
                ...records.map((r) => _buildHistoryCard(r)),
              ],
            ),
          );
        }
      )
    );
  }

  // --- NATIVE STACKED BAR CHART ---
  Widget _buildStackedBar(List<_BarSegment> segments) {
    int total = segments.fold(0, (sum, seg) => sum + seg.amount);
    if (total == 0) return Container(height: 25, decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(12)));
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 25,
        child: Row(
          children: segments.map((seg) {
            if (seg.amount <= 0) return const SizedBox.shrink();
            return Expanded(
              flex: seg.amount,
              child: Container(color: seg.color),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildLegend(String label, Color color, int amount) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text("$label: \$${_format(amount)}", style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  Widget _buildHistoryCard(FinancialRecord r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      // FIX: Corrected BorderSide Syntax!
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), 
        borderRadius: BorderRadius.circular(8), 
        border: Border(
          left: BorderSide(color: r.netProfit >= 0 ? Colors.green : Colors.red, width: 4)
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Year ${r.year}, Week ${r.week}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text("${r.netProfit >= 0 ? '+' : ''}\$${_format(r.netProfit)}", style: TextStyle(color: r.netProfit >= 0 ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _format(int number) => number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
}

class _BarSegment {
  final int amount;
  final Color color;
  _BarSegment(this.amount, this.color);
}