import 'dart:async';
import 'package:flutter/material.dart';
import 'hub_screen.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // THE BOOT SEQUENCE TEXT (Wrestling Tycoon Edition)
  final List<String> _bootLog = [
    "INITIALIZING BROADCAST UPLINK...",
    "LOADING ROSTER DATABASE...",
    "VERIFYING COMMISSIONER CREDENTIALS...",
    "CONNECTING TO GLOBAL NETWORK...",
    "WE ARE LIVE."
  ];

  int _currentIndex = 0;
  String _displayText = "";
  
  @override
  void initState() {
    super.initState();
    _startBootSequence();
  }

  void _startBootSequence() async {
    for (int i = 0; i < _bootLog.length; i++) {
      await Future.delayed(const Duration(milliseconds: 600)); // Delay between lines
      if (mounted) {
        setState(() {
          _currentIndex = i;
          _displayText = _bootLog[i];
        });
      }
    }
    
    // Final pause before launch
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HubScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // --- MAIN SPLASH CONTENT ---
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // YOUR GAME LOGO
                Image.asset(
                  "assets/images/imagelogo.png", 
                  height: isDesktop ? 150 : 120,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => const Icon(Icons.sports_mma, size: 80, color: Colors.amber),
                ),
                const SizedBox(height: 40),
                
                // TYPEWRITER TEXT
                SizedBox(
                  height: 50,
                  child: Text(
                    _displayText, 
                    style: const TextStyle(
                      color: Colors.amber, // Tycoon Amber
                      fontFamily: 'Monospace', // System fallback for monospace
                      fontSize: 14, 
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // LOADING BAR
                SizedBox(
                  width: 200,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.amber.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
                ),
                
                const SizedBox(height: 10),
                Text(
                  "v1.0.0 RELEASE", 
                  style: TextStyle(color: Colors.amber.withOpacity(0.5), fontSize: 10, letterSpacing: 2.0)
                )
              ],
            ),
          ),

          // --- TERMINAL SOFTWARE STUDIO BRANDING ---
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  "A STUDIO PRODUCTION BY",
                  style: TextStyle(
                    color: Colors.white30, 
                    fontSize: 10, 
                    letterSpacing: 2.0, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.terminal, color: Colors.amber, size: 18),
                    const SizedBox(width: 8),
                    const Text(
                      "TERMINAL SOFTWARE",
                      style: TextStyle(
                        color: Colors.amber, 
                        fontSize: 16, 
                        fontWeight: FontWeight.w900, 
                        letterSpacing: 4.0, 
                        fontFamily: 'Monospace'
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}