import 'package:isar/isar.dart'; // <--- THIS LINE IS CRITICAL
import 'match.dart'; 

part 'event.g.dart';

@collection
class Event {
  Id id = Isar.autoIncrement;

  late int weekNumber;
  late String name;
  
  final matches = IsarLinks<Match>();

  late double showRating;
  late int attendance;
  late int revenue;

  Event({
    required this.weekNumber,
    this.name = "Weekly TV Show",
    this.showRating = 0.0,
    this.attendance = 0,
    this.revenue = 0,
  });
}