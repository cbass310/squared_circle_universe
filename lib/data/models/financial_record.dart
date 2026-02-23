import 'package:isar/isar.dart';

part 'financial_record.g.dart';

@collection
class FinancialRecord {
  Id id = Isar.autoIncrement;
  
  late int year;
  late int week;
  
  // Income Buckets
  late int tvRevenue;
  late int ticketSales;
  late int merchandiseSales;
  late int sponsorshipRevenue;
  late int ppvRevenue; 
  
  // Expense Buckets
  late int rosterPayroll;
  late int productionCosts;
  late int facilityCosts;
  late int logisticsCosts;
  
  // Computed Properties (Ignored by Isar, used by UI)
  @ignore
  int get totalIncome => tvRevenue + ticketSales + merchandiseSales + sponsorshipRevenue + ppvRevenue;
  
  @ignore
  int get totalExpense => rosterPayroll + productionCosts + facilityCosts + logisticsCosts;
  
  @ignore
  int get netProfit => totalIncome - totalExpense;
}