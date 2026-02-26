import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/game_state_provider.dart';
import '../../../logic/sound_manager.dart';

class VenueScreen extends ConsumerStatefulWidget {
  const VenueScreen({super.key});

  @override
  ConsumerState<VenueScreen> createState() => _VenueScreenState();
}

class _VenueScreenState extends ConsumerState<VenueScreen> {
  int _selectedVenueLevel = 1;

  @override
  void initState() {
    super.initState();
    // Default to currently owned venue on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selectedVenueLevel = ref.read(gameProvider).venueLevel;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final notifier = ref.read(gameProvider.notifier);
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: isDesktop
            ? Row(
                children: [
                  Expanded(flex: 4, child: _buildLeftListColumn(gameState, isDesktop)),
                  Expanded(flex: 6, child: _buildRightDetailPane(gameState, notifier)),
                ],
              )
            // On mobile, just stack the selected venue right on top of the list
            : Column(
                children: [
                  _buildMobileHeader(),
                  Expanded(flex: 1, child: _buildRightDetailPane(gameState, notifier)),
                  Expanded(flex: 1, child: _buildLeftListColumn(gameState, false)),
                ],
              ),
      ),
    );
  }

  Widget _buildMobileHeader() {
    return Container(
      color: const Color(0xFF121212),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.amber, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Text("REAL ESTATE", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------
  // LEFT COLUMN: List of available venues
  // ----------------------------------------------------------------
  Widget _buildLeftListColumn(GameState gameState, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        border: isDesktop ? const Border(right: BorderSide(color: Colors.white10, width: 2)) : const Border(top: BorderSide(color: Colors.white10, width: 2)),
      ),
      child: Column(
        children: [
          if (isDesktop)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.amber, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text("REAL ESTATE", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                ],
              ),
            ),
          
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white10))),
            child: const Text("AVAILABLE PROPERTIES", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 12)),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildListTile(1, gameState.venueCustomNames[0], "500 Fans", "assets/images/venue_gym.png", gameState.venueLevel),
                _buildListTile(2, gameState.venueCustomNames[1], "2,500 Fans", "assets/images/venue_civic.png", gameState.venueLevel),
                _buildListTile(3, gameState.venueCustomNames[2], "15,000 Fans", "assets/images/venue_arena.png", gameState.venueLevel),
                _buildListTile(4, gameState.venueCustomNames[3], "60,000 Fans", "assets/images/venue_stadium.png", gameState.venueLevel),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(int level, String name, String capacity, String imagePath, int currentLevel) {
    bool isSelected = _selectedVenueLevel == level;
    bool isOwned = level <= currentLevel;
    bool isLocked = level > currentLevel + 1;

    return GestureDetector(
      onTap: () => setState(() => _selectedVenueLevel = level),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 80,
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber.withOpacity(0.05) : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.amber : (isOwned ? Colors.greenAccent.withOpacity(0.5) : Colors.white10), width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(11), bottomLeft: Radius.circular(11)),
              child: SizedBox(
                width: 80, height: 80,
                child: ColorFiltered(
                  colorFilter: isLocked ? const ColorFilter.mode(Colors.black87, BlendMode.saturation) : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                  child: Image.asset(imagePath, fit: BoxFit.cover, errorBuilder: (c, o, s) => Container(color: Colors.grey[800], child: const Icon(Icons.business, color: Colors.white24))),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name.toUpperCase(), style: TextStyle(color: isLocked ? Colors.white54 : Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(isLocked ? "LOCKED" : capacity, style: TextStyle(color: isOwned ? Colors.greenAccent : Colors.amber, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                ],
              ),
            ),
            if (isOwned && level == currentLevel)
               const Padding(padding: EdgeInsets.only(right: 16.0), child: Icon(Icons.check_circle, color: Colors.greenAccent)),
            if (isLocked)
               const Padding(padding: EdgeInsets.only(right: 16.0), child: Icon(Icons.lock, color: Colors.white24)),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------
  // RIGHT COLUMN: The Immersive Detail Pane
  // ----------------------------------------------------------------
  Widget _buildRightDetailPane(GameState gameState, GameNotifier notifier) {
    String name; String cap; String cost; String desc; String img; int rent;
    switch (_selectedVenueLevel) {
      case 4: 
        name = gameState.venueCustomNames[3]; cap = "60,000 Fans"; cost = "\$1,000,000"; rent = 250000;
        desc = "The grandest stage of them all. Legends are made here. Unlocks maximum TV and Sponsorship potential."; 
        img = "assets/images/venue_stadium.png"; break;
      case 3: 
        name = gameState.venueCustomNames[2]; cap = "15,000 Fans"; cost = "\$250,000"; rent = 50000;
        desc = "A massive televised arena with luxury boxes and pyrotechnics. Capable of hosting major PPV events."; 
        img = "assets/images/venue_arena.png"; break;
      case 2: 
        name = gameState.venueCustomNames[1]; cap = "2,500 Fans"; cost = "\$25,000"; rent = 5000;
        desc = "A respectable local hall with proper lighting and seating. The first step out of the indies."; 
        img = "assets/images/venue_civic.png"; break;
      case 1: 
      default: 
        name = gameState.venueCustomNames[0]; cap = "500 Fans"; cost = "FREE"; rent = 500;
        desc = "A sweaty, gritty gym. It smells like hard work. Maximum capacity is strictly enforced by the fire marshal."; 
        img = "assets/images/venue_gym.png"; break;
    }

    bool isCurrent = _selectedVenueLevel == gameState.venueLevel;
    bool isNext = _selectedVenueLevel == gameState.venueLevel + 1;
    bool isLocked = _selectedVenueLevel > gameState.venueLevel + 1;

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // THE MASSIVE BACKGROUND IMAGE
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              width: double.infinity,
              child: ColorFiltered(
                colorFilter: isLocked ? const ColorFilter.mode(Colors.black87, BlendMode.saturation) : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                child: Image.asset(img, fit: BoxFit.cover, errorBuilder: (c, o, s) => Container(color: Colors.grey[900])),
              ),
            ),
          ),
          
          // THE FADE GRADIENT
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.2), Colors.black.withOpacity(0.8), Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.4, 0.7],
              ),
            ),
          ),

          // THE CONTENT
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white24)), child: Text("TIER $_selectedVenueLevel", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                      const SizedBox(width: 12),
                      if (isCurrent) Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.greenAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.greenAccent)), child: const Text("CURRENT HQ", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 12))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(name.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: 1.5, height: 1.1)),
                  const SizedBox(height: 16),
                  
                  // STATS ROW
                  Row(
                    children: [
                      _buildStatBadge(Icons.groups_rounded, "CAPACITY", cap, Colors.amber),
                      const SizedBox(width: 20),
                      _buildStatBadge(Icons.receipt_long_rounded, "WEEKLY RENT", "\$${rent.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}", Colors.redAccent),
                    ],
                  ),
                  
                  const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Divider(color: Colors.white24, thickness: 1)),
                  Text(desc, style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 40),

                  // CALL TO ACTION BUTTON
                  if (isNext)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        icon: const Icon(Icons.shopping_cart),
                        label: Text("PURCHASE DEED ($cost)", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.0)),
                        onPressed: () {
                          bool success = notifier.purchaseVenueUpgrade();
                          if (success) {
                            ref.read(soundProvider).playSound("bell.mp3"); 
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("UPGRADE SUCCESSFUL! WELCOME TO THE BIG LEAGUES!"), backgroundColor: Colors.green));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("NOT ENOUGH CASH IN THE TREASURY!"), backgroundColor: Colors.red));
                          }
                        },
                      ),
                    )
                  else if (isLocked)
                    Container(
                      width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 20), alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white24)),
                      child: const Text("LOCKED - UPGRADE PREVIOUS TIER FIRST", style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                    )
                  else if (isCurrent)
                    Container(
                      width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 20), alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.greenAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.greenAccent)),
                      child: const Text("PROPERTY OWNED & ACTIVE", style: TextStyle(color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatBadge(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w900)),
          ],
        )
      ],
    );
  }
}