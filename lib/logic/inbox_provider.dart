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
  
  // 🚨 NEW: Added Social Posts filter for the third tab
  List<NewsItem> get socialPosts => messages.where((m) => m.type == "SOCIAL").toList();
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

  // 🚨 UPGRADED: A bustling, alive inbox on Day 1!
  Future<void> _injectWelcomeMessages(Isar isar) async {
    final welcomeEmail = NewsItem()
      ..sender = "Alex O'Cannon (Asst. GM)"
      ..subject = "Welcome to the Front Office, Boss"
      ..body = "The Board expects big things this year. Keep an eye on your roster's stamina, monitor your finances closely, and check the Dirt Sheet for rumors on the Empire's movements. Let's make some money!\n\n(P.S. Make sure to book 3 matches and hit 'GO LIVE' to see what the fans think on social media!)"
      ..timestamp = DateTime.now()
      ..isRead = false
      ..actionRequired = true // <-- Will block "GO LIVE" until read!
      ..type = "EMAIL";

    final financeEmail = NewsItem()
      ..sender = "Accounting Dept."
      ..subject = "Initial Budget Report"
      ..body = "Boss, our roster payroll is going to eat into our cash quickly. I highly recommend heading to the 'Sponsors' tab immediately to secure an upfront cash bonus."
      ..timestamp = DateTime.now().subtract(const Duration(minutes: 2))
      ..isRead = false
      ..actionRequired = false
      ..type = "EMAIL";

    final welcomeRumor = NewsItem()
      ..sender = "The Observer Wire"
      ..subject = "A New Challenger Appears"
      ..body = "Rumors are swirling that a new management team has taken over Squared Circle Wrestling. We will see if they have the budget and the booking skills to compete with The Empire."
      ..timestamp = DateTime.now().subtract(const Duration(minutes: 5)) 
      ..isRead = false
      ..actionRequired = false
      ..type = "DIRT_SHEET";

    final socialTrend = NewsItem()
      ..sender = "@SmarkyMark"
      ..subject = "Trending Topic"
      ..body = "Just bought my tickets for week 1! Let's see if the new promoter actually knows what they're doing. #ProWrestling"
      ..timestamp = DateTime.now().subtract(const Duration(hours: 2)) 
      ..isRead = false
      ..actionRequired = false
      ..type = "SOCIAL";

    await isar.writeTxn(() async {
      await isar.newsItems.putAll([welcomeEmail, financeEmail, welcomeRumor, socialTrend]);
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
      if (item != null && !item.isRead) {
        item.isRead = true;
        if (item.actionRequired) item.actionRequired = false; // Clear action required
        await isar.newsItems.put(item);
      }
    });

    _loadInbox();
  }

  // 🚨 NEW: BATCH ACTIONS FOR UI
  Future<void> markAllAsRead() async {
    final isar = Isar.getInstance();
    if (isar == null) return;

    await isar.writeTxn(() async {
      final unreadItems = await isar.newsItems.filter().isReadEqualTo(false).findAll();
      for (var item in unreadItems) {
        item.isRead = true;
        item.actionRequired = false;
      }
      await isar.newsItems.putAll(unreadItems);
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

  // 🚨 NEW: BATCH DELETE FOR UI
  Future<void> clearAllReadMessages() async {
    final isar = Isar.getInstance();
    if (isar == null) return;

    await isar.writeTxn(() async {
      final readItems = await isar.newsItems.filter().isReadEqualTo(true).findAll();
      final idsToDelete = readItems.map((e) => e.id).toList();
      await isar.newsItems.deleteAll(idsToDelete);
    });

    _loadInbox();
  }
}

final inboxProvider = StateNotifierProvider<InboxNotifier, InboxState>((ref) => InboxNotifier());