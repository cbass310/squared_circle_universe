import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ------------------------------------------------
// 1. THE DATA MODEL
// ------------------------------------------------
class NewsItem {
  final String id;
  final String category; // 'inbox', 'dirtsheet', 'social'
  final String title;
  final String sender;
  final String date;
  final String body;
  final IconData icon;
  final Color color;
  final bool isRead;

  NewsItem({
    required this.id,
    required this.category,
    required this.title,
    required this.sender,
    required this.date,
    required this.body,
    required this.icon,
    required this.color,
    this.isRead = false,
  });
}

// ------------------------------------------------
// 2. THE ENGINE (BRAIN)
// ------------------------------------------------
class CommunicationsNotifier extends StateNotifier<List<NewsItem>> {
  CommunicationsNotifier() : super([]);

  final _random = Random();

  // 🚀 THIS IS THE MASTER TRIGGER. 
  // We will call this every time the player clicks "Advance Week".
  void generateWeeklyContent(int currentWeek) {
    _generateNarrative(currentWeek);
    _generateRandomSocial(currentWeek);
    
    // 40% chance every week for a random dirt sheet rumor
    if (_random.nextDouble() > 0.6) { 
      _generateRandomRumor(currentWeek);
    }
  }

  // --- THE ASSISTANT GM TUTORIAL FLOW ---
  void _generateNarrative(int week) {
    if (week == 1) {
      _addMessage(NewsItem(id: "w1_1", category: "inbox", title: "Welcome to SCW", sender: "Alex O'Cannon (Asst. GM)", date: "Week $week", body: "Welcome to the big leagues, boss. Your main job is to book the matches, manage the egos, and keep us out of the red. Check your roster, see who is hot, and let's put on a great first TV taping!", icon: Icons.mail_rounded, color: Colors.blueAccent));
    } else if (week == 2) {
      _addMessage(NewsItem(id: "w2_1", category: "inbox", title: "Watching Stamina", sender: "SCW Medical", date: "Week $week", body: "Just a reminder: don't overwork the talent. If a wrestler's stamina drops too low, their injury risk skyrockets. Rotate your lower-card guys to give the main eventers a break.", icon: Icons.medical_services_rounded, color: Colors.redAccent));
    } else if (week == 4) {
      _addMessage(NewsItem(id: "w4_1", category: "inbox", title: "First PPV Approaching", sender: "Alex O'Cannon (Asst. GM)", date: "Week $week", body: "Our first Premium Live Event is coming up fast. PPVs generate massive revenue, but only if you put your most popular stars in the main event. Start building those rivalries now.", icon: Icons.attach_money_rounded, color: Colors.greenAccent));
    }
    // We can add weeks 5 through 156 here later!
  }

  // --- DYNAMIC SOCIAL MEDIA ---
  void _generateRandomSocial(int week) {
    List<String> positiveTweets = [
      "SCW is cooking right now! 🔥",
      "Can't wait for next week's show. Take my money! 💸",
      "Best wrestling on the planet right now, no debate.",
      "Just bought front row tickets to the next SCW taping!"
    ];
    List<String> negativeTweets = [
      "Is anyone else getting bored of SCW lately? 😴",
      "They need to push new talent. Same old stuff.",
      "I want my two hours back. Trash show.",
      "If they don't turn Johnny Strong heel soon, I'm done watching."
    ];

    // TODO: Later, we will tie this boolean to the actual Match Ratings of the show you just booked!
    bool isGoodWeek = _random.nextBool(); 
    
    String body = isGoodWeek 
        ? positiveTweets[_random.nextInt(positiveTweets.length)]
        : negativeTweets[_random.nextInt(negativeTweets.length)];
    
    Color color = isGoodWeek ? Colors.greenAccent : Colors.redAccent;
    IconData icon = isGoodWeek ? Icons.favorite_rounded : Icons.thumb_down_rounded;

    _addMessage(NewsItem(id: "soc_${DateTime.now().millisecondsSinceEpoch}", category: "social", title: "Fan Reaction", sender: "@SCWFan_${_random.nextInt(9999)}", date: "Week $week", body: body, icon: icon, color: color));
  }

  // --- RANDOM RUMORS ---
  void _generateRandomRumor(int week) {
    List<String> rumors = [
      "Backstage heat! Two top stars reportedly had to be separated after a botched spot last week.",
      "Contract talks stalling? We hear a major SCW star is exploring Free Agency options.",
      "Network executives are reportedly 'keeping a close eye' on SCW's recent demographic ratings.",
      "A major free agent was spotted near SCW headquarters this morning..."
    ];
    String body = rumors[_random.nextInt(rumors.length)];

    _addMessage(NewsItem(id: "ds_${DateTime.now().millisecondsSinceEpoch}", category: "dirtsheet", title: "Exclusive Rumor", sender: "The Wrestling Observer", date: "Week $week", body: body, icon: Icons.article_rounded, color: Colors.purpleAccent));
  }

  void _addMessage(NewsItem item) {
    // Inserts the newest message at the very top of the feed
    state = [item, ...state];
  }

  void markAsRead(String id) {
     state = [
       for (final msg in state)
         if (msg.id == id) NewsItem(id: msg.id, category: msg.category, title: msg.title, sender: msg.sender, date: msg.date, body: msg.body, icon: msg.icon, color: msg.color, isRead: true)
         else msg
     ];
  }
}

// 3. THE GLOBAL PROVIDER EXPORT
final communicationsProvider = StateNotifierProvider<CommunicationsNotifier, List<NewsItem>>((ref) {
  return CommunicationsNotifier();
});