import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../logic/game_state_provider.dart';
import '../../../data/models/financial_record.dart';

final financialHistoryProvider = FutureProvider.autoDispose<List<FinancialRecord>>((ref) async {
  final isar = Isar.getInstance();
  if (isar == null) return [];
  // Grab the last 12 weeks for a deeper history log
  return await isar.financialRecords.where().sortByYearDesc().thenByWeekDesc().limit(12).findAll();
});

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  FinancialRecord? _selectedRecord;

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final historyAsync = ref.watch(financialHistoryProvider);
    
    // Responsive Check
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: isDesktop
            ? Row(
                children: [
                  // LEFT COLUMN: Summary & History List (40%)
                  Expanded(flex: 4, child: _buildLeftColumn(gameState, historyAsync, isDesktop)),
                  // RIGHT COLUMN: Detailed Breakdown (60%)
                  Expanded(flex: 6, child: _buildRightColumn()),
                ],
              )
            // MOBILE LAYOUT
            : _selectedRecord == null 
                ? _buildLeftColumn(gameState, historyAsync, isDesktop) 
                : _buildMobileDetailPane(),
      ),
    );
  }

  // ----------------------------------------------------------------
  // WIDGET: LEFT COLUMN (Summary & History List)
  // ----------------------------------------------------------------
  Widget _buildLeftColumn(GameState gameState, AsyncValue<List<FinancialRecord>> historyAsync, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        border: isDesktop ? const Border(right: BorderSide(color: Colors.white10, width: 2)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER AREA
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.amber, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                const Text("EXECUTIVE LEDGER", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              ],
            ),
          ),

          // THE DATA
          Expanded(
            child: historyAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: Colors.amber)),
              error: (err, stack) => Center(child: Text("Error: $err", style: const TextStyle(color: Colors.red))),
              data: (records) {
                if (records.isEmpty) {
                  return _buildEmptyState(gameState);
                }

                // If on desktop and nothing selected, default to the most recent week
                if (isDesktop && _selectedRecord == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() => _selectedRecord = records.first);
                  });
                }

                return Column(
                  children: [
                    _buildTopLineSummary(gameState, records),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("HISTORICAL LEDGER", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          final r = records[index];
                          final isSelected = _selectedRecord?.id == r.id;

                          return GestureDetector(
                            onTap: () => setState(() => _selectedRecord = r),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.amber.withOpacity(0.05) : const Color(0xFF1A1A1A),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: isSelected ? Colors.amber : Colors.white10, width: isSelected ? 2 : 1),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Year ${r.year}, Week ${r.week}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                      const SizedBox(height: 4),
                                      Text(r.netProfit >= 0 ? "PROFIT" : "LOSS", style: TextStyle(color: r.netProfit >= 0 ? Colors.green : Colors.red, fontSize: 10, fontWeight: FontWeight.w900)),
                                    ],
                                  ),
                                  Text("${r.netProfit >= 0 ? '+' : ''}\$${_format(r.netProfit)}", style: TextStyle(color: r.netProfit >= 0 ? Colors.greenAccent : Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(GameState gameState) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
            child: Column(
              children: [
                const Text("STARTING CAPITAL", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                const SizedBox(height: 10),
                Text("\$${_format(gameState.cash)}", style: const TextStyle(color: Colors.greenAccent, fontSize: 40, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          const Spacer(),
          const Center(child: Text("No financial data yet.\nRun your first show to generate a ledger.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white30, fontSize: 16))),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildTopLineSummary(GameState gameState, List<FinancialRecord> records) {
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
      int weeksLeft = avgNet == 0 ? 999 : gameState.cash ~/ avgNet.abs();
      runwayText = "WARNING: BUDGET EXHAUSTED IN $weeksLeft WEEKS";
      runwayColor = Colors.redAccent;
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1E1E1E), Color(0xFF151515)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(12), 
        border: Border.all(color: Colors.white12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          const Text("TOTAL TREASURY", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          Text("\$${_format(gameState.cash)}", style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900, fontFamily: "Monospace")),
          const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(color: Colors.white10, height: 1)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: runwayColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6), border: Border.all(color: runwayColor.withOpacity(0.3))),
            child: Text(runwayText, style: TextStyle(color: runwayColor, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.0)),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------
  // WIDGET: RIGHT COLUMN (Desktop Detail Pane)
  // ----------------------------------------------------------------
  Widget _buildRightColumn() {
    if (_selectedRecord == null) return Container(color: Colors.black);
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(40.0),
      child: _buildDetailContent(),
    );
  }

  // ----------------------------------------------------------------
  // WIDGET: MOBILE DETAIL PANE (Slide over)
  // ----------------------------------------------------------------
  Widget _buildMobileDetailPane() {
    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.amber, size: 20),
                  onPressed: () => setState(() => _selectedRecord = null), 
                ),
                const Text("BACK TO LEDGER", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
              child: _buildDetailContent(),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------
  // WIDGET: THE ACTUAL DETAIL CONTENT (CHARTS)
  // ----------------------------------------------------------------
  Widget _buildDetailContent() {
    final r = _selectedRecord!;
    
    // 🛠️ THE FIX: We calculate the totals right here in the UI!
    final int calcTotalIncome = r.tvRevenue + r.ticketSales + r.ppvRevenue + r.sponsorshipRevenue + r.merchandiseSales;
    final int calcTotalExpenses = r.rosterPayroll + r.productionCosts + r.logisticsCosts + r.facilityCosts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.bar_chart_rounded, color: Colors.amber, size: 30),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("WEEKLY BREAKDOWN", style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                Text("Year ${r.year} • Week ${r.week}", style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
              ],
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 30), child: Divider(color: Colors.white10, thickness: 2)),

        // INCOME BAR
        Row(
          children: [
            const Icon(Icons.arrow_circle_down_rounded, color: Colors.greenAccent, size: 20),
            const SizedBox(width: 8),
            const Text("TOTAL REVENUE", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const Spacer(),
            // Using the calculated total
            Text("\$${_format(calcTotalIncome)}", style: const TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.w900, fontFamily: "Monospace")),
          ],
        ),
        const SizedBox(height: 12),
        _buildStackedBar([
          _BarSegment(r.tvRevenue, Colors.blue),
          _BarSegment(r.ticketSales, Colors.green),
          _BarSegment(r.ppvRevenue, Colors.orange),
          _BarSegment(r.sponsorshipRevenue, Colors.purple),
          _BarSegment(r.merchandiseSales, Colors.yellow),
        ]),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12, runSpacing: 12,
          children: [
            _buildLegend("TV Deal", Colors.blue, r.tvRevenue),
            _buildLegend("Tickets", Colors.green, r.ticketSales),
            if (r.ppvRevenue > 0) _buildLegend("PPV Buys", Colors.orange, r.ppvRevenue),
            if (r.sponsorshipRevenue > 0) _buildLegend("Sponsors", Colors.purple, r.sponsorshipRevenue),
            _buildLegend("Merch", Colors.yellow, r.merchandiseSales),
          ],
        ),
        
        const SizedBox(height: 40),

        // EXPENSE BAR
        Row(
          children: [
            const Icon(Icons.arrow_circle_up_rounded, color: Colors.redAccent, size: 20),
            const SizedBox(width: 8),
            const Text("TOTAL EXPENSES", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const Spacer(),
            // Using the calculated total
            Text("\$${_format(calcTotalExpenses)}", style: const TextStyle(color: Colors.redAccent, fontSize: 18, fontWeight: FontWeight.w900, fontFamily: "Monospace")),
          ],
        ),
        const SizedBox(height: 12),
        _buildStackedBar([
          _BarSegment(r.rosterPayroll, Colors.redAccent),
          _BarSegment(r.productionCosts, Colors.orangeAccent),
          _BarSegment(r.logisticsCosts, Colors.brown),
          _BarSegment(r.facilityCosts, Colors.teal),
        ]),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12, runSpacing: 12,
          children: [
            _buildLegend("Payroll", Colors.redAccent, r.rosterPayroll),
            _buildLegend("Production", Colors.orangeAccent, r.productionCosts),
            _buildLegend("Venue Rent", Colors.brown, r.logisticsCosts),
            _buildLegend("Facilities", Colors.teal, r.facilityCosts),
          ],
        ),
      ],
    );
  }

  // --- CHART HELPERS ---
  Widget _buildStackedBar(List<_BarSegment> segments) {
    int total = segments.fold(0, (sum, seg) => sum + seg.amount);
    if (total == 0) return Container(height: 30, decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(8)));
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 30,
        child: Row(
          children: segments.map((seg) {
            if (seg.amount <= 0) return const SizedBox.shrink();
            return Expanded(flex: seg.amount, child: Container(color: seg.color));
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildLegend(String label, Color color, int amount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6), border: Border.all(color: color.withOpacity(0.3))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text("$label: ", style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
          Text("\$${_format(amount)}", style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w900)),
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