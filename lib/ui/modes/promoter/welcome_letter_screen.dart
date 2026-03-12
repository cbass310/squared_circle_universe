import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/game_state_provider.dart';
import 'promoter_home_screen.dart';

class WelcomeLetterScreen extends ConsumerWidget {
  const WelcomeLetterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    
    // Check if the device is a phone (narrow screen) to adjust padding
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            "assets/images/office_background.png", // Fallback to whatever you have, or just dark
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.8),
            colorBlendMode: BlendMode.darken,
            errorBuilder: (c, e, s) => Container(color: const Color(0xFF0A0A0A)),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Container(
                    // Reduced margins for smaller screens
                    margin: EdgeInsets.all(isMobile ? 16.0 : 24.0),
                    // Reduced padding for smaller screens
                    padding: EdgeInsets.all(isMobile ? 24.0 : 32.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.amber.withOpacity(0.5), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.8),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.business, color: Colors.amber, size: 40),
                            Flexible(
                              child: Text(
                                "OFFICIAL MEMORANDUM",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5), 
                                  letterSpacing: isMobile ? 1.5 : 3.0, // Tighter letter spacing on mobile
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 12
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.white24, height: 40, thickness: 1),
                        
                        // Address
                        Text("TO: Head Promoter / General Manager", style: _metaStyle(isMobile)),
                        const SizedBox(height: 5),
                        Text("FROM: The Board of Directors", style: _metaStyle(isMobile)),
                        const SizedBox(height: 5),
                        Text("SUBJECT: The Future of Squared Circle Wrestling", style: _metaStyle(isMobile)),
                        
                        const Divider(color: Colors.white24, height: 40, thickness: 1),

                        // Body Paragraphs
                        Text(
                          "Congratulations on assuming the position of Head Promoter. The Board of Directors expects massive growth from you this fiscal year.",
                          style: TextStyle(color: Colors.white, fontSize: isMobile ? 14 : 16, height: 1.5),
                          softWrap: true,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "You will work hand-in-hand with your Assistant GM, Alex O'Kannon, to ensure operations run smoothly. However, the final booking decisions—and the financial consequences—rest entirely on your shoulders.",
                          style: TextStyle(color: Colors.white, fontSize: isMobile ? 14 : 16, height: 1.5),
                          softWrap: true,
                        ),
                        const SizedBox(height: 15),
                        Container(
                          width: double.infinity, // Ensures the container stays within bounds
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            border: Border(left: BorderSide(color: Colors.redAccent.shade400, width: 4)),
                          ),
                          child: Text(
                            "WARNING: Do not blindly rush to the ring to book matches. Before your first event, you MUST review your Roster, negotiate a lucrative TV Deal in the Broadcasting Hub, and secure ring Sponsorships to cover your payroll.",
                            style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic, height: 1.5, fontSize: isMobile ? 13 : 14),
                            softWrap: true,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Good luck making Squared Circle Wrestling the top promotion in the world. Do not let us down.",
                          style: TextStyle(color: Colors.white, fontSize: isMobile ? 14 : 16, height: 1.5),
                          softWrap: true,
                        ),
                        
                        const SizedBox(height: 30),
                        const Text("Best Regards,", style: TextStyle(color: Colors.white70)),
                        const Text("The Executive Board", style: TextStyle(color: Colors.amber, fontSize: 18, fontFamily: "DancingScript", fontStyle: FontStyle.italic)), 

                        const SizedBox(height: 40),

                        // Action Button
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.draw, color: Colors.black),
                            label: Text(
                              "SIGN CONTRACT & ENTER", 
                              style: TextStyle(
                                fontWeight: FontWeight.w900, 
                                fontSize: isMobile ? 14 : 16, // Slightly smaller text on small phones
                                letterSpacing: 1.0
                              )
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {
                              HapticFeedback.heavyImpact();
                              // Push to the Main Dashboard, replacing the current screen
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const PromoterHomeScreen()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Adjusts the meta text size based on if it's a mobile screen
  TextStyle _metaStyle(bool isMobile) {
    return TextStyle(
      color: Colors.white70, 
      fontSize: isMobile ? 10 : 12, 
      fontWeight: FontWeight.bold, 
      letterSpacing: isMobile ? 0.5 : 1.0
    );
  }
}