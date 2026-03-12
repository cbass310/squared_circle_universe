import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart'; 
import '../../../data/models/news_item.dart';

// --- IMPORT FOR THE WATERMARK ---
import '../../components/tv_watermark.dart';

// 🚨 THE FIX: Direct Database Pipeline. No more ghost providers!
final liveNewsProvider = StreamProvider<List<NewsItem>>((ref) async* {
  final isar = Isar.getInstance();
  if (isar == null) yield [];
  
  yield* isar!.newsItems.where().sortByTimestampDesc().watch(fireImmediately: true);
});

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({super.key});

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  int _selectedTabIndex = 0;
  NewsItem? _selectedMessage;

  Future<void> _deleteMessage(int id) async {
    HapticFeedback.heavyImpact();
    
    final isar = Isar.getInstance();
    if (isar != null) {
      await isar.writeTxn(() async {
        await isar.newsItems.delete(id);
      });
    }
  }

  void _openMessage(NewsItem msg, bool isDesktop) {
    HapticFeedback.selectionClick();
    
    // Mark as read instantly in the DB
    if (!msg.isRead) {
      final isar = Isar.getInstance();
      if (isar != null) {
        isar.writeTxn(() async {
          msg.isRead = true;
          await isar.newsItems.put(msg);
        });
      }
    }
    
    if (isDesktop) {
      setState(() => _selectedMessage = msg);
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true, 
        backgroundColor: Colors.transparent, 
        builder: (bottomSheetContext) => DraggableScrollableSheet(
          initialChildSize: 0.85, 
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) => Container(
            decoration: BoxDecoration(
              color: const Color(0xFF151515),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(top: BorderSide(color: _getCategoryColor(msg.type), width: 2)),
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
                    child: _buildMessageContent(msg, bottomSheetContext), 
                  ),
                ),
              ],
            ),
          ),
        ),
      ).whenComplete(() {
        setState(() => _selectedMessage = null);
      });
    }
  }

  Color _getCategoryColor(String type) {
    switch (type) {
      case "EMAIL": return Colors.blueAccent;
      case "DIRT_SHEET": return Colors.redAccent;
      case "SOCIAL": return Colors.purpleAccent;
      default: return Colors.orangeAccent;
    }
  }

  IconData _getCategoryIcon(String type) {
    switch (type) {
      case "EMAIL": return Icons.email;
      case "DIRT_SHEET": return Icons.newspaper;
      case "SOCIAL": return Icons.tag;
      default: return Icons.message;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🚨 THE FIX: Watch the live Isar stream!
    final newsAsync = ref.watch(liveNewsProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 800;

        return newsAsync.when(
          loading: () => const Scaffold(backgroundColor: Colors.black, body: Center(child: CircularProgressIndicator(color: Colors.amber))),
          error: (err, stack) => Scaffold(backgroundColor: Colors.black, body: Center(child: Text("Error: $err", style: const TextStyle(color: Colors.red)))),
          data: (allMessages) {
            
            // 🚨 THE FIX: Map the live database records to the correct tabs
            List<NewsItem> filteredMessages = [];
            if (_selectedTabIndex == 0) filteredMessages = allMessages.where((m) => m.type == "EMAIL").toList();
            if (_selectedTabIndex == 1) filteredMessages = allMessages.where((m) => m.type == "DIRT_SHEET").toList();
            if (_selectedTabIndex == 2) filteredMessages = allMessages.where((m) => m.type == "SOCIAL").toList();

            if (isDesktop) {
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
                                child: _buildMessageContent(_selectedMessage!, context),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Scaffold(
                backgroundColor: Colors.black,
                body: Column(
                  children: [
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
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
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
          
          const SizedBox(height: 8), 

          // INBOX LIST
          Expanded(
            child: messages.isEmpty
                ? const Center(child: Text("No new messages in this folder.", style: TextStyle(color: Colors.white54)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isSelected = _selectedMessage?.id == msg.id;

                      Color msgColor = _getCategoryColor(msg.type);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? msgColor.withOpacity(0.05) : const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected 
                            ? Border.all(color: msgColor, width: 2)
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(color: msgColor.withOpacity(0.15), shape: BoxShape.circle),
                                    child: Icon(_getCategoryIcon(msg.type), color: msgColor, size: 20),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(msg.sender.toUpperCase(), style: TextStyle(color: msg.isRead ? Colors.white54 : msgColor, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                                        const SizedBox(height: 6),
                                        Text(msg.subject, style: TextStyle(color: msg.isRead ? Colors.white70 : Colors.white, fontSize: 14, fontWeight: msg.isRead ? FontWeight.normal : FontWeight.w800)),
                                      ],
                                    ),
                                  ),
                                  if (!msg.isRead)
                                    Container(
                                      margin: const EdgeInsets.only(left: 8, right: 12), 
                                      width: 10, 
                                      height: 10, 
                                      decoration: BoxDecoration(color: msgColor, shape: BoxShape.circle)
                                    ),
                                  
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.white24, size: 22),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      _deleteMessage(msg.id);
                                      if (_selectedMessage?.id == msg.id) {
                                        setState(() => _selectedMessage = null);
                                      }
                                    },
                                  )
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
  Widget _buildMessageContent(NewsItem msg, BuildContext localContext) {
    Color msgColor = _getCategoryColor(msg.type);
    bool isDesktop = MediaQuery.of(localContext).size.width > 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: msgColor.withOpacity(0.1), shape: BoxShape.circle), child: Icon(_getCategoryIcon(msg.type), color: msgColor, size: 30)),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(msg.subject, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, height: 1.2)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text("From: ", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12, fontWeight: FontWeight.bold)),
                      Text(msg.sender.toUpperCase(), style: TextStyle(color: msgColor, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
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

        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent),
            label: const Text("DELETE MESSAGE", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Colors.redAccent, width: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              backgroundColor: Colors.redAccent.withOpacity(0.05),
            ),
            onPressed: () {
              _deleteMessage(msg.id);
              if (isDesktop) {
                setState(() => _selectedMessage = null);
              } else {
                setState(() => _selectedMessage = null);
                Navigator.pop(localContext); // Safely closes the bottom sheet
              }
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}