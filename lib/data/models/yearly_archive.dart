import 'package:isar/isar.dart';

part 'yearly_archive.g.dart';

@collection
class YearlyArchive {
  Id id = Isar.autoIncrement;
  
  int year = 1;
  int wins = 0;
  int losses = 0;
  int draws = 0;
  int totalProfit = 0;
  
  String bestShowName = "";
  double bestShowRating = 0.0;
  String wrestlerOfTheYear = "";
}