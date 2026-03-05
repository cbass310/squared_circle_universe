import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/communications_provider.dart'; 

// --- IMPORT FOR THE WATERMARK ---
import '../../components/tv_watermark.dart';

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({super.key});

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  int _selectedTabIndex = 0;
  NewsItem? _selectedMessage;

  void _openMessage(NewsItem msg, bool isDesktop) {
    HapticFeedback.selectionClick();
    ref.read(communicationsProvider.notifier).markAsRead(msg.id);
    
    if (isDesktop) {
      setState(() => _selectedMessage = msg);
    } else {
      // 📱 MOBILE: Slide up the email/news content
      showModalBottomSheet(
        context: context,
        isScrollControlled: true, 
        backgroundColor: Colors.transparent, 
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.85, 
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) => Container(
            decoration: BoxDecoration(
              color: const Color(0xFF151515),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(top: BorderSide(color: msg.color, width: 2)),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  height: 4, width: 40,
                  decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(2)),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: controller,
                    padding: const EdgeInsets.all(24),
                    child: _buildMessageContent(msg), 
                  ),
                ),
              ],
            ),
          ),
        ),
      ).whenComplete(() {
        // Optional: clear selection when closing sheet
        setState(() => _selectedMessage = null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🔌 READ THE LIVE MESSAGES FROM THE ENGINE
    final allMessages = ref.watch(communicationsProvider);

    // Filter messages based on selected tab
    final currentCategory = _selectedTabIndex == 0 ? "inbox" : _selectedTabIndex == 1 ? "dirtsheet" : "social";
    final filteredMessages = allMessages.where((msg) => msg.category == currentCategory).toList();

    // 🚨 SMART LAYOUT BUILDER 🚨
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 800;

        if (isDesktop) {
          // 💻 PC LAYOUT (Wide Side-by-Side)
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Row(
                children: [
                  Expanded(flex: 4, child: _buildDashboard(filteredMessages, isDesktop)),
                  Expanded(
                    flex: 6, 
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _buildArtworkPane(isMobile: false),
                        if (_selectedMessage != null)
                          Container(
                            color: Colors.black.withOpacity(0.9),
                            padding: const EdgeInsets.all(40.0),
                            child: _buildMessageContent(_selectedMessage!),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          // 📱 MOBILE LAYOUT (40/60 Vertical Split)
          return Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              children: [
                // TOP 40%: The Cinematic Viewport
                Expanded(
                  flex: 4,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildArtworkPane(isMobile: true),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black.withOpacity(0.4), Colors.black],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.amber, size: 20),
                                onPressed: () => Navigator.pop(context),
                                padding: EdgeInsets.zero,
                                alignment: Alignment.topLeft,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Row(
                                    children: [
                                      Icon(Icons.cell_tower_rounded, color: Colors.orangeAccent, size: 24),
                                      SizedBox(width: 8),
                                      Text("GLOBAL NETWORK", style: TextStyle(color: Colors.orangeAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text("COMMUNICATIONS", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // BOTTOM 60%: The Dashboard Data
                Expanded(
                  flex: 6,
                  child: Container(
                    color: Colors.black,
                    width: double.infinity,
                    child: _buildDashboard(filteredMessages, false),
                  ),
                ),
              ],
            ),
          );
        }
      }
    );
  }

  // =====================================================================
  // --- THE DASHBOARD INBOX (Shared by Desktop & Mobile)
  // =====================================================================
  Widget _buildDashboard(List<NewsItem> messages, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: isDesktop ? const Color(0xFF121212) : Colors.black,
        border: isDesktop ? const Border(right: BorderSide(color: Colors.white10, width: 2)) : null,
      ),
      child: Column(
        children: [
          // HEADER (PC ONLY - Mobile uses the image overlay)
          if (isDesktop)
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.orangeAccent, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text("COMMUNICATIONS", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  ],
                ),
              ),
            ),
          
          // TABS
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: isDesktop ? Colors.black : Colors.white10, width: isDesktop ? 3 : 1))),
            child: Row(
              children: [
                _buildTab(0, "INBOX"),
                _buildTab(1, "DIRT SHEET"),
                _buildTab(2, "SOCIAL"),
              ],
            ),
          ),
          
          // INBOX LIST
          Expanded(
            child: messages.isEmpty
                ? const Center(child: Text("No new messages.", style: TextStyle(color: Colors.white54)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isSelected = _selectedMessage?.id == msg.id;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? msg.color.withOpacity(0.05) : const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected 
                            ? Border.all(color: msg.color, width: 2)
                            : Border.all(color: Colors.white10, width: 1),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => _openMessage(msg, isDesktop),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(color: msg.color.withOpacity(0.15), shape: BoxShape.circle),
                                    child: Icon(msg.icon, color: msg.color, size: 20),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(msg.sender.toUpperCase(), style: TextStyle(color: msg.isRead ? Colors.white54 : msg.color, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                                            Text(msg.date, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10)),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(msg.title, style: TextStyle(color: msg.isRead ? Colors.white70 : Colors.white, fontSize: 14, fontWeight: msg.isRead ? FontWeight.normal : FontWeight.w800)),
                                      ],
                                    ),
                                  ),
                                  if (!msg.isRead)
                                    Container(margin: const EdgeInsets.only(left: 8, top: 6), width: 8, height: 8, decoration: BoxDecoration(color: msg.color, shape: BoxShape.circle)),
                                ],
                              ),
                            ),
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
          HapticFeedback.selectionClick();
          setState(() {
            _selectedTabIndex = index;
            _selectedMessage = null; 
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: isSelected ? Colors.orangeAccent : Colors.transparent, width: 3))),
          child: Center(
            child: Text(title, style: TextStyle(color: isSelected ? Colors.orangeAccent : Colors.grey, fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold, fontSize: 11, letterSpacing: 1.5)),
          ),
        ),
      ),
    );
  }

  // =====================================================================
  // --- ARTWORK PANE (Shared)
  // =====================================================================
  Widget _buildArtworkPane({required bool isMobile}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/images/office_background.png", 
          fit: BoxFit.cover,
          alignment: Alignment.centerRight,
          errorBuilder: (c, e, s) => Container(color: const Color(0xFF0A0A0A)),
        ),
        if (!isMobile)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.black.withOpacity(0.95), Colors.black.withOpacity(0.4), Colors.black.withOpacity(0.8)],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        TVWatermark(isMobile: isMobile),
      ],
    );
  }

  // =====================================================================
  // --- THE MESSAGE CONTENT (Displayed in PC Right Pane or Mobile Modal)
  // =====================================================================
  Widget _buildMessageContent(NewsItem msg) {
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
                  Text(msg.title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, height: 1.2)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text("From: ", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12, fontWeight: FontWeight.bold)),
                      Text(msg.sender.toUpperCase(), style: TextStyle(color: msg.color, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                      const Spacer(),
                      Text(msg.date, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Divider(color: Colors.white10, thickness: 2)),
        Text(msg.body, style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.6, letterSpacing: 0.5)),
        const SizedBox(height: 40),
      ],
    );
  }
}