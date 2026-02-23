import 'package:isar/isar.dart';
import 'match.dart';

part 'show_history.g.dart';

@collection
class ShowHistory {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime timestamp;
  
  late int week;
  late int year;
  late String showName;
  late double avgRating;
  late int totalProfit;
  late int attendance;

  // Highlights like "Kid Aerial won the World Title"
  List<String> highlights = [];

  // Links to the matches that happened on this card
  final matches = IsarLinks<Match>();
}