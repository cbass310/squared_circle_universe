import 'package:flutter/material.dart';
import '../../data/models/wrestler.dart';

class WrestlerAvatar extends StatelessWidget {
  final Wrestler wrestler;
  final double size;
  final bool showLabel;

  const WrestlerAvatar({
    super.key,
    required this.wrestler,
    this.size = 60,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    Color styleColor;
    IconData styleIcon;
    // Fallback if nothing else matches
    String defaultImage = 'assets/images/avatar_default.png'; 

    switch (wrestler.style) {
      case WrestlingStyle.brawler:
        styleColor = Colors.redAccent;
        styleIcon = Icons.sports_mma;
        defaultImage = 'assets/images/avatar_brawler.png';
        break;
      case WrestlingStyle.technician:
        styleColor = Colors.blueAccent;
        styleIcon = Icons.settings;
        defaultImage = 'assets/images/avatar_technician.png';
        break;
      case WrestlingStyle.highFlyer:
        styleColor = Colors.cyanAccent;
        styleIcon = Icons.flight;
        defaultImage = 'assets/images/avatar_highflyer.png';
        break;
      case WrestlingStyle.giant:
        styleColor = Colors.purpleAccent;
        styleIcon = Icons.landscape; 
        defaultImage = 'assets/images/avatar_giant.png';
        break;
      case WrestlingStyle.entertainer:
        styleColor = Colors.amber;
        styleIcon = Icons.mic;
        defaultImage = 'assets/images/avatar_entertainer.png';
        break;
      
      // --- NEW STYLES (Fixed: Now they have images!) ---
      case WrestlingStyle.powerhouse:
        styleColor = Colors.deepPurple;
        styleIcon = Icons.fitness_center;
        defaultImage = 'assets/images/avatar_powerhouse.png'; // <--- Added
        break;
      case WrestlingStyle.luchador:
        styleColor = Colors.green;
        styleIcon = Icons.masks; 
        defaultImage = 'assets/images/avatar_luchador.png';   // <--- Added
        break;
      case WrestlingStyle.hardcore:
        styleColor = Colors.deepOrange;
        styleIcon = Icons.dangerous;
        defaultImage = 'assets/images/avatar_hardcore.png';   // <--- Added
        break;
    }

    // DETERMINE BORDER COLOR
    Color borderColor = styleColor;
    double borderWidth = 2;
    if (wrestler.isChampion) {
      borderColor = const Color(0xFFFFD700); // GOLD for World
      borderWidth = 4;
    } else if (wrestler.isTVChampion) {
      borderColor = const Color(0xFFC0C0C0); // SILVER for TV
      borderWidth = 4;
    }

    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: borderColor,
                  width: borderWidth,
                ),
                color: styleColor.withOpacity(0.2), 
                boxShadow: (wrestler.isChampion || wrestler.isTVChampion)
                  ? [BoxShadow(color: borderColor.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)]
                  : [],
              ),
              child: ClipOval(
                child: Image.asset(
                  wrestler.imagePath ?? defaultImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(child: Icon(styleIcon, color: styleColor, size: size * 0.5));
                  },
                ),
              ),
            ),
            
            // TITLE ICONS
            if (wrestler.isChampion)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD700), // Gold
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 2)]
                  ),
                  child: const Icon(Icons.emoji_events, color: Colors.black, size: 14),
                ),
              ),
            
            if (wrestler.isTVChampion)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFC0C0C0), // Silver
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 2)]
                  ),
                  child: const Icon(Icons.tv, color: Colors.black, size: 14),
                ),
              ),

            // INJURY STATUS
            if (wrestler.condition < 60)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.local_hospital, color: Colors.red, size: 12),
                ),
              ),
          ],
        ),
        if (showLabel) ...[
          const SizedBox(height: 4),
          Text(
            wrestler.name.split(' ').last,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          )
        ]
      ],
    );
  }
}