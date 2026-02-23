import 'package:flutter/material.dart';
import '../../../data/models/wrestler.dart';

class WrestlerAvatar extends StatelessWidget {
  final Wrestler wrestler;
  final double radius;

  const WrestlerAvatar({
    Key? key,
    required this.wrestler,
    this.radius = 20.0,
  }) : super(key: key);

  String get initials {
    if (wrestler.name.isEmpty) return "?";
    List<String> parts = wrestler.name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else {
      return wrestler.name.substring(0, wrestler.name.length >= 2 ? 2 : 1).toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'avatar_${wrestler.id}',
      child: ClipOval(
        child: Image.asset(
          'assets/images/roster/${wrestler.id}.png',
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return CircleAvatar(
              radius: radius,
              backgroundColor: const Color(0xFF1E1E1E),
              child: Text(
                initials,
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: radius * 0.8,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
