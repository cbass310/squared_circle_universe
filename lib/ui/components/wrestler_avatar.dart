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
      case WrestlingStyle.powerhouse:
        styleColor = Colors.deepPurple;
        styleIcon = Icons.fitness_center;
        defaultImage = 'assets/images/avatar_powerhouse.png'; 
        break;
      case WrestlingStyle.luchador:
        styleColor = Colors.greenAccent;
        styleIcon = Icons.masks; 
        defaultImage = 'assets/images/avatar_luchador.png';   
        break;
      case WrestlingStyle.hardcore:
        styleColor = Colors.deepOrange;
        styleIcon = Icons.dangerous;
        defaultImage = 'assets/images/avatar_hardcore.png';   
        break;
    }

    // 🛠️ AAA CHAMPIONSHIP GLOW LOGIC
    Color borderColor = styleColor.withOpacity(0.5);
    double borderWidth = 2.0;
    List<BoxShadow> glowEffect = [
      BoxShadow(color: Colors.black.withOpacity(0.8), blurRadius: 6, offset: const Offset(0, 3))
    ];

    if (wrestler.isChampion) {
      borderColor = const Color(0xFFFFD700); // Pure Gold
      borderWidth = 3.5;
      glowEffect = [
        BoxShadow(color: Colors.amberAccent.withOpacity(0.6), blurRadius: 15, spreadRadius: 2),
        BoxShadow(color: const Color(0xFFFFD700).withOpacity(0.3), blurRadius: 30, spreadRadius: 1),
      ];
    } else if (wrestler.isTVChampion) {
      borderColor = Colors.grey.shade300; // Bright Silver
      borderWidth = 3.5;
      glowEffect = [
        BoxShadow(color: Colors.white.withOpacity(0.5), blurRadius: 12, spreadRadius: 2),
        BoxShadow(color: Colors.blueAccent.withOpacity(0.3), blurRadius: 25, spreadRadius: 1),
      ];
    }

    // Generate Initials for the Fallback
    String initials = wrestler.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
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
                color: const Color(0xFF1E1E1E), 
                boxShadow: glowEffect, // Applies the dynamic aura!
              ),
              child: ClipOval(
                child: Image.asset(
                  wrestler.imagePath ?? defaultImage,
                  fit: BoxFit.cover,
                  // 🚨 THE FIX: Switched to exact coordinates to save their faces!
                  alignment: const Alignment(0.0, -0.6), 
                  errorBuilder: (context, error, stackTrace) {
                    // 🛠️ PREMIUM FALLBACK AVATAR
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            styleColor.withOpacity(0.8),
                            styleColor.withOpacity(0.2),
                          ],
                        ),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Faint background icon representing their style
                          Positioned(
                            right: -size * 0.1,
                            bottom: -size * 0.1,
                            child: Icon(styleIcon, color: Colors.black.withOpacity(0.3), size: size * 0.7),
                          ),
                          // Crisp Initials
                          Center(
                            child: Text(
                              initials,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: size * 0.4,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // WORLD TITLE ICON
            if (wrestler.isChampion)
              Positioned(
                right: -4,
                bottom: -4,
                child: Container(
                  padding: EdgeInsets.all(size * 0.08),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                    boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 4)]
                  ),
                  child: Icon(Icons.emoji_events, color: Colors.black, size: size * 0.25),
                ),
              ),
            
            // TV TITLE ICON
            if (wrestler.isTVChampion)
              Positioned(
                right: -4,
                bottom: -4,
                child: Container(
                  padding: EdgeInsets.all(size * 0.08),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300, 
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                    boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 4)]
                  ),
                  child: Icon(Icons.tv, color: Colors.black, size: size * 0.25),
                ),
              ),

            // INJURY STATUS
            if (wrestler.condition < 60)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: EdgeInsets.all(size * 0.06),
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 1.5)
                  ),
                  child: Icon(Icons.local_hospital, color: Colors.red, size: size * 0.2),
                ),
              ),
          ],
        ),
        if (showLabel) ...[
          const SizedBox(height: 6),
          SizedBox(
            width: size + 20, // Prevents long names from wrapping weirdly
            child: Text(
              wrestler.name.split(' ').last.toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ]
      ],
    );
  }
}