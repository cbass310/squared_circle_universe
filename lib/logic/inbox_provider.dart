import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../data/models/news_item.dart';

class InboxState {
  final List<NewsItem> messages;
  final bool isLoading;

  InboxState({this.messages = const [], this.isLoading = true});

  int get unreadCount => messages.where((m) => !m.isRead).length;
  bool get hasActionRequired => messages.any((m) => m.actionRequired && !m.isRead);

  List<NewsItem> get emails => messages.where((m) => m.type == "EMAIL").toList();
  List<NewsItem> get dirtSheets => messages.where((m) => m.type == "DIRT_SHEET").toList();
}

class InboxNotifier extends StateNotifier<InboxState> {
  InboxNotifier() : super(InboxState()) {
    _loadInbox();
  }

  Future<void> _loadInbox() async {
    final isar = Isar.getInstance();
    if (isar == null) return;

    final items = await isar.newsItems.where().sortByTimestampDesc().findAll();
    
    // --- NEW: AUTO-GENERATE WELCOME EMAILS ON NEW GAME ---
    if (items.isEmpty) {
      await _injectWelcomeMessages(isar);
      final newItems = await isar.newsItems.where().sortByTimestampDesc().findAll();
      state = InboxState(messages: newItems, isLoading: false);
    } else {
      state = InboxState(messages: items, isLoading: false);
    }
  }

  Future<void> _injectWelcomeMessages(Isar isar) async {
    final welcomeEmail = NewsItem()
      ..sender = "Alex O'Cannon (Asst. GM)"
      ..subject = "Welcome to the Front Office, Boss"
      ..body = "The Board expects big things this year. Keep an eye on your roster's stamina, monitor your finances closely, and check the Dirt Sheet for rumors on the Empire's movements. Let's make some money!\n\n(P.S. Make sure to book 3 matches and hit 'GO LIVE' to see what the fans think on social media!)"
      ..timestamp = DateTime.now()
      ..isRead = false
      ..actionRequired = true // <-- Will block "GO LIVE" until read!
      ..type = "EMAIL";

    final welcomeRumor = NewsItem()
      ..sender = "The Observer Wire"
      ..subject = "A New Challenger Appears"
      ..body = "Rumors are swirling that a new management team has taken over Terminal Software. We will see if they have the budget and the booking skills to compete with The Empire."
      ..timestamp = DateTime.now().subtract(const Duration(minutes: 5)) 
      ..isRead = false
      ..actionRequired = false
      ..type = "DIRT_SHEET";

    await isar.writeTxn(() async {
      await isar.newsItems.putAll([welcomeEmail, welcomeRumor]);
    });
  }

  Future<void> sendAlert({required String sender, required String subject, required String body, bool actionRequired = false, String type = "EMAIL"}) async {
    final isar = Isar.getInstance();
    if (isar == null) return;

    final newItem = NewsItem()
      ..sender = sender
      ..subject = subject
      ..body = body
      ..timestamp = DateTime.now()
      ..isRead = false
      ..actionRequired = actionRequired
      ..type = type;

    await isar.writeTxn(() async {
      await isar.newsItems.put(newItem);
    });

    _loadInbox();
  }

  Future<void> markAsRead(int id) async {
    final isar = Isar.getInstance();
    if (isar == null) return;

    await isar.writeTxn(() async {
      final item = await isar.newsItems.get(id);
      if (item != null) {
        item.isRead = true;
        await isar.newsItems.put(item);
      }
    });

    _loadInbox();
  }

  Future<void> deleteMessage(int id) async {
    final isar = Isar.getInstance();
    if (isar == null) return;

    await isar.writeTxn(() async {
      await isar.newsItems.delete(id);
    });

    _loadInbox();
  }
}

final inboxProvider = StateNotifierProvider<InboxNotifier, InboxState>((ref) => InboxNotifier());