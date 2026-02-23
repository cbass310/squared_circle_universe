import 'package:isar/isar.dart';

part 'news_item.g.dart';

@collection
class NewsItem {
  Id id = Isar.autoIncrement;
  
  late String sender;
  late String subject;
  late String body;
  late DateTime timestamp;
  
  late bool isRead;
  
  // If true, the "Advance Week" button is locked until this is read/resolved!
  late bool actionRequired; 
  
  // "EMAIL" for inbox, "DIRT_SHEET" for rumors
  late String type; 
}