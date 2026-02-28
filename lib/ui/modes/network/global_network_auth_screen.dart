import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../../../logic/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState; 

class GlobalNetworkAuthScreen extends ConsumerWidget {
  const GlobalNetworkAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final isAuthenticating = authState == AuthState.authenticating;
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: isDesktop
            ? Row(
                children: [
                  Expanded(flex: 4, child: _buildLeftDashboard(context, ref, isAuthenticating, isDesktop)),
                  Expanded(flex: 6, child: _buildRightArtworkPane(isMobile: false)),
                ],
              )
            : Column(
                children: [
                  Expanded(flex: 4, child: _buildRightArtworkPane(isMobile: true)),
                  Expanded(flex: 6, child: _buildLeftDashboard(context, ref, isAuthenticating, isDesktop)),
                ],
              ),
      ),
    );
  }

  // =====================================================================
  // --- LEFT PANE: THE AUTHENTICATION PORTAL
  // =====================================================================
  Widget _buildLeftDashboard(BuildContext context, WidgetRef ref, bool isAuthenticating, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        border: isDesktop ? const Border(right: BorderSide(color: Colors.black, width: 3)) : const Border(top: BorderSide(color: Colors.black, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER ---
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.cyanAccent, size: 20), onPressed: () => Navigator.pop(context)),
                const SizedBox(width: 8),
                const Text("CONNECTION PORTAL", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5)),
              ],
            ),
          ),
          
          Container(height: 3, color: Colors.black), 

          // --- CONTENT ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'THE GLOBAL NETWORK',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.cyanAccent, letterSpacing: 2.0),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Sync your offline legacy. Predict real-world PPV results. Dominate the global leaderboards and claim your spot on the blockchain.",
                    style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.5, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 50),
                  
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
  // --- RIGHT PANE: ARTWORK
  // =====================================================================
  Widget _buildRightArtworkPane({bool isMobile = false}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/global_stadium.png', // Try to map to a globe or server room
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[900],
              child: const Center(child: Icon(Icons.public, size: 100, color: Colors.cyanAccent)),
            );
          },
        ),
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
        Positioned(
          bottom: 40, right: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.security, size: 50, color: Colors.white10),
              const SizedBox(height: 10),
              Text("AUTHENTICATION", style: TextStyle(fontSize: isMobile ? 20 : 32, fontWeight: FontWeight.w900, color: Colors.white24, letterSpacing: 4.0)),
              Text("SUPABASE IDENTITY SERVICES", style: TextStyle(fontSize: isMobile ? 10 : 14, color: Colors.cyanAccent.withOpacity(0.5), letterSpacing: 2.0, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}