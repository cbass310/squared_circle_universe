import 'package:flutter/material.dart';

class TVWatermark extends StatelessWidget {
  final bool isMobile;
  
  const TVWatermark({super.key, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    // Hide the watermark on mobile if space is too tight, or render it smaller
    if (isMobile) return const SizedBox.shrink(); 

    return Positioned(
      bottom: 20,
      right: 20,
      child: IgnorePointer(
        child: Opacity(
          opacity: 0.6,
          child: Image.asset(
            "assets/images/logo_watermark.png",
            width: 120,
            fit: BoxFit.contain,
            errorBuilder: (c, e, s) => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}