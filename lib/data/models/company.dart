import 'package:isar/isar.dart';

part 'company.g.dart';

@collection
class Company {
  Id id = Isar.autoIncrement;

  late int cash;
  late int week;
  late int fans;
  late String venueName; // We'll store the enum as a string

  Company({
    this.cash = 50000,
    this.week = 1,
    this.fans = 10000,
    this.venueName = "highSchoolGym",
  });
}