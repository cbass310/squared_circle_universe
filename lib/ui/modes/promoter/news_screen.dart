import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/inbox_provider.dart';

class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inboxState = ref.watch(inboxProvider);
    final inboxNotifier = ref.read(inboxProvider.notifier);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          title: const Text("COMMUNICATIONS HUB", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          backgroundColor: Colors.transparent,
          bottom: TabBar(
            indicatorColor: Colors.blueAccent,
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "INBOX (${inboxState.emails.where((e) => !e.isRead).length})"),
              Tab(text: "DIRT SHEET (${inboxState.dirtSheets.where((e) => !e.isRead).length})"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMessageList(inboxState.emails, inboxNotifier, context, isDirtSheet: false),
            _buildMessageList(inboxState.dirtSheets, inboxNotifier, context, isDirtSheet: true),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(List<dynamic> messages, InboxNotifier notifier, BuildContext context, {required bool isDirtSheet}) {
    if (messages.isEmpty) {
      return Center(
        child: Text(
          isDirtSheet ? "No new rumors on the Dirt Sheet." : "Your inbox is empty.",
          style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        
        // 🛠️ FIX: Native Dart Date Formatting (No 'intl' package needed!)
        final date = msg.timestamp as DateTime;
        final hr = date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
        final ampm = date.hour >= 12 ? "PM" : "AM";
        final min = date.minute.toString().padLeft(2, '0');
        final dateStr = "${date.month}/${date.day}/${date.year} - $hr:$min $ampm";

        return Card(
          color: msg.isRead ? const Color(0xFF1E1E1E) : const Color(0xFF2A2A2A),
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: msg.actionRequired && !msg.isRead ? Colors.redAccent : Colors.transparent, 
              width: 2
            ),
            borderRadius: BorderRadius.circular(8)
          ),
          child: ExpansionTile(
            onExpansionChanged: (expanded) {
              if (expanded && !msg.isRead) {
                notifier.markAsRead(msg.id);
              }
            },
            leading: Icon(
              isDirtSheet ? Icons.article : Icons.email,
              color: msg.isRead ? Colors.grey : (isDirtSheet ? Colors.purpleAccent : Colors.blueAccent),
            ),
            title: Text(
              msg.subject,
              style: TextStyle(
                color: Colors.white,
                fontWeight: msg.isRead ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("From: ${msg.sender} • $dateStr", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                if (msg.actionRequired && !msg.isRead)
                  const Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text("[ACTION REQUIRED]", style: TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.white10))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(msg.body, style: const TextStyle(color: Colors.white70, height: 1.5)),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        icon: const Icon(Icons.delete, color: Colors.grey, size: 18),
                        label: const Text("DELETE", style: TextStyle(color: Colors.grey)),
                        onPressed: () => notifier.deleteMessage(msg.id),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}