import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../../../logic/auth_provider.dart';

// --- PIVOT IMPORTS ---
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState; // Added for Dev Bypass

class GlobalNetworkAuthScreen extends ConsumerWidget {
  const GlobalNetworkAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // UPDATED: Now points to the new Supabase authStateProvider
    final authState = ref.watch(authStateProvider);
    final isAuthenticating = authState == AuthState.authenticating;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      
      // 🚀 THE ESCAPE HATCH (Back Button)
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      
      body: Row(
        children: [
          // LEFT COLUMN (40%) - The Gateway
          Expanded(
            flex: 4,
            child: Container(
              color: const Color(0xFF121212),
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'THE GLOBAL NETWORK',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Sync your offline legacy. Join Pick'em leagues. Dominate the world leaderboards.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 50),
                  if (isAuthenticating)
                    const Center(
                      child: CircularProgressIndicator(
                        color: Colors.amber,
                      ),
                    )
                  else ...[
                    _buildAuthButton(
                      icon: Icons.g_mobiledata,
                      label: 'Continue with Google',
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        ref.read(authStateProvider.notifier).signInWithGoogle();
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildAuthButton(
                      icon: Icons.apple,
                      label: 'Sign in with Apple',
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        ref.read(authStateProvider.notifier).signInWithApple();
                      },
                    ),
                    
                    const SizedBox(height: 40),

                    // 🚨 TEMPORARY DEV BYPASS BUTTON 🚨
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.bug_report, color: Colors.white),
                        label: const Text("DEV BYPASS: INSTANT LOGIN"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent.shade700, 
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                        onPressed: () async {
                          try {
                            // Force login using the fake account
                            await Supabase.instance.client.auth.signInWithPassword(
                              email: 'test@test.com',
                              password: 'password123',
                            );
                            
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Bypass Successful! Access Granted."), backgroundColor: Colors.green),
                              );
                              // Kick us back to the Hub Screen so we can hit the Commissioner Button
                              Navigator.pop(context); 
                            }
                          } catch (e) {
                            if (context.mounted) {
                               ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("🚨 Error: $e"), backgroundColor: Colors.red),
                              );
                            }
                          }
                        },
                      ),
                    ),
                    // ------------------------------------

                    const SizedBox(height: 30),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          HapticFeedback.selectionClick();
                        },
                        child: const Text(
                          'Connect Web3 Wallet (Coming Soon)',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // RIGHT COLUMN (60%) - The Visuals
          Expanded(
            flex: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/global_stadium.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[900],
                      child: const Center(
                        child: Icon(Icons.public, size: 100, color: Colors.amber),
                      ),
                    );
                  },
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF121212), Colors.transparent],
                      begin: Alignment.centerLeft,
                      end: Alignment.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.black, size: 28),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}