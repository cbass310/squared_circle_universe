import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../../../logic/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState; 

// --- IMPORT FOR THE WATERMARK ---
import '../../components/tv_watermark.dart';

class GlobalNetworkAuthScreen extends ConsumerWidget {
  const GlobalNetworkAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final isAuthenticating = authState == AuthState.authenticating;

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
                  Expanded(flex: 4, child: _buildDashboard(context, ref, isAuthenticating, true)),
                  Expanded(flex: 6, child: _buildArtworkPane(isMobile: false)),
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
                                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.cyanAccent, size: 20),
                                onPressed: () => Navigator.pop(context),
                                padding: EdgeInsets.zero,
                                alignment: Alignment.topLeft,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Row(
                                    children: [
                                      Icon(Icons.public, color: Colors.cyanAccent, size: 24),
                                      SizedBox(width: 8),
                                      Text("CONNECTION PORTAL", style: TextStyle(color: Colors.cyanAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text("THE GLOBAL NETWORK", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
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
                    child: _buildDashboard(context, ref, isAuthenticating, false),
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
  // --- THE DASHBOARD (Shared by Desktop & Mobile)
  // =====================================================================
  Widget _buildDashboard(BuildContext context, WidgetRef ref, bool isAuthenticating, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: isDesktop ? const Color(0xFF121212) : Colors.black,
        border: isDesktop ? const Border(right: BorderSide(color: Colors.white10, width: 2)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER (PC ONLY - Mobile uses the image overlay) ---
          if (isDesktop)
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.cyanAccent, size: 20), onPressed: () => Navigator.pop(context)),
                    const SizedBox(width: 8),
                    const Text("CONNECTION PORTAL", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5)),
                  ],
                ),
              ),
            ),
            
          if (isDesktop) Container(height: 1, color: Colors.white10), 

          // --- CONTENT ---
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isDesktop ? 40.0 : 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isDesktop) ...[
                    const Text(
                      'THE GLOBAL NETWORK',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.cyanAccent, letterSpacing: 2.0),
                    ),
                    const SizedBox(height: 16),
                  ],
                  const Text(
                    "Sync your offline legacy. Predict real-world PPV results. Dominate the global leaderboards and claim your spot on the blockchain.",
                    style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.5, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: isDesktop ? 50 : 30),
                  
                  if (isAuthenticating)
                    const Center(child: CircularProgressIndicator(color: Colors.cyanAccent))
                  else ...[
                    _buildAuthButton(
                      icon: Icons.g_mobiledata,
                      label: 'CONTINUE WITH GOOGLE',
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        ref.read(authStateProvider.notifier).signInWithGoogle();
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildAuthButton(
                      icon: Icons.apple,
                      label: 'SIGN IN WITH APPLE',
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        ref.read(authStateProvider.notifier).signInWithApple();
                      },
                    ),
                    
                    const SizedBox(height: 50),

                    // 🚨 TEMPORARY DEV BYPASS BUTTON 🚨
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.redAccent, width: 2),
                        boxShadow: [BoxShadow(color: Colors.redAccent.withOpacity(0.2), blurRadius: 10)],
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.bug_report, color: Colors.white),
                          label: const Text("DEV BYPASS: INSTANT LOGIN", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent.shade700, 
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          onPressed: () async {
                            HapticFeedback.heavyImpact();
                            try {
                              // Force login using the fake account
                              await Supabase.instance.client.auth.signInWithPassword(
                                email: 'test@test.com',
                                password: 'password123',
                              );
                              
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Bypass Successful! Access Granted.", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)), backgroundColor: Colors.cyanAccent),
                                );
                                Navigator.pop(context); 
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("🚨 Error: $e", style: const TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.red),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    Center(
                      child: TextButton.icon(
                        icon: const Icon(Icons.account_balance_wallet, color: Colors.purpleAccent, size: 18),
                        onPressed: () {
                          HapticFeedback.selectionClick();
                        },
                        label: const Text(
                          'CONNECT SOLANA WALLET (COMING SOON)',
                          style: TextStyle(color: Colors.purpleAccent, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton.icon(
          icon: Icon(icon, color: Colors.white, size: 28),
          label: Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1.0),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E1E1E),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            elevation: 0,
          ),
          onPressed: onPressed,
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
          'assets/images/global_stadium.png', 
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[900],
              child: const Center(child: Icon(Icons.public, size: 100, color: Colors.cyanAccent)),
            );
          },
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
        
        // --- THE GLOBAL WATERMARK ---
        TVWatermark(isMobile: isMobile),
      ],
    );
  }
}