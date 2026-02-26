import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/communications_provider.dart'; // 🔌 IMPORT THE NEW ENGINE!

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({super.key});

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  int _selectedTabIndex = 0;
  NewsItem? _selectedMessage;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    
    // 🔌 READ THE LIVE MESSAGES FROM THE ENGINE
    final allMessages = ref.watch(communicationsProvider);

    // Filter messages based on selected tab
    final currentCategory = _selectedTabIndex == 0 ? "inbox" : _selectedTabIndex == 1 ? "dirtsheet" : "social";
    final filteredMessages = allMessages.where((msg) => msg.category == currentCategory).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: isDesktop
            ? Row(
                children: [
                  Expanded(flex: 4, child: _buildLeftColumn(filteredMessages, isDesktop)),
                  Expanded(flex: 6, child: _buildRightColumn()),
                ],
              )
            : _selectedMessage == null 
                ? _buildLeftColumn(filteredMessages, isDesktop) 
                : _buildMobileDetailPane(),
      ),
    );
  }

  Widget _buildLeftColumn(List<NewsItem> messages, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        border: isDesktop ? const Border(right: BorderSide(color: Colors.white10, width: 2)) : null,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.grey, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                const Text("COMMUNICATIONS", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white10))),
            child: Row(
              children: [
                _buildTab(0, "INBOX"),
                _buildTab(1, "DIRT SHEET"),
                _buildTab(2, "SOCIAL"),
              ],
            ),
          ),
          Expanded(
            child: messages.isEmpty
                ? const Center(child: Text("No new messages.", style: TextStyle(color: Colors.white54)))
                : ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isSelected = _selectedMessage?.id == msg.id;

                      return InkWell(
                        onTap: () {
                          setState(() => _selectedMessage = msg);
                          ref.read(communicationsProvider.notifier).markAsRead(msg.id); // Mark as read!
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white.withOpacity(0.05) : Colors.transparent,
                            border: isSelected 
                                ? Border(left: BorderSide(color: msg.color, width: 4), bottom: const BorderSide(color: Colors.white10)) 
                                : const Border(bottom: BorderSide(color: Colors.white10)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(msg.icon, color: msg.color, size: 24),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(msg.sender, style: TextStyle(color: msg.isRead ? Colors.white54 : Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                        Text(msg.date, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10)),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(msg.title, style: TextStyle(color: msg.isRead ? Colors.white70 : Colors.white, fontSize: 14, fontWeight: msg.isRead ? FontWeight.normal : FontWeight.w800)),
                                  ],
                                ),
                              ),
                              if (!msg.isRead) // Unread dot indicator
                                Container(width: 8, height: 8, margin: const EdgeInsets.only(top: 6), decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle))
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String title) {
    bool isSelected = _selectedTabIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
            _selectedMessage = null; 
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: isSelected ? Colors.amber : Colors.transparent, width: 3))),
          child: Center(
            child: Text(title, style: TextStyle(color: isSelected ? Colors.amber : Colors.grey, fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold, fontSize: 11, letterSpacing: 1.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildRightColumn() {
    if (_selectedMessage == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mail_outline_rounded, color: Colors.white10, size: 80),
              SizedBox(height: 16),
              Text("Select a message to read.", style: TextStyle(color: Colors.white30, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      );
    }
    return Container(color: Colors.black, padding: const EdgeInsets.all(40.0), child: _buildMessageContent());
  }

  Widget _buildMobileDetailPane() {
    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.amber, size: 20), onPressed: () => setState(() => _selectedMessage = null)),
                const Text("BACK", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
          Expanded(child: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10), child: _buildMessageContent())),
        ],
      ),
    );
  }

  Widget _buildMessageContent() {
    final msg = _selectedMessage!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: msg.color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(msg.icon, color: msg.color, size: 30)),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(msg.title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text("From: ", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14)),
                      Text(msg.sender, style: TextStyle(color: msg.color, fontSize: 14, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Text(msg.date, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 30), child: Divider(color: Colors.white10, thickness: 2)),
        Text(msg.body, style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.6, letterSpacing: 0.5)),
      ],
    );
  }
}