import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../logic/auth_provider.dart';

class GlobalNetworkButton extends ConsumerWidget {
  const GlobalNetworkButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = Supabase.instance.client.auth.currentSession;
    final user = session?.user;
    final bool isLoggedIn = user != null;
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        if (isLoggedIn) {
          _showProfileMenu(context, ref, user);
        } else {
          _showQuickAuthModal(context, ref);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 16 : 10, 
          vertical: 10
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: isLoggedIn ? Colors.cyanAccent.withOpacity(0.5) : Colors.white24, width: 2),
          boxShadow: isLoggedIn ? [BoxShadow(color: Colors.cyanAccent.withOpacity(0.2), blurRadius: 10)] : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 28, width: 28,
              decoration: BoxDecoration(
                color: isLoggedIn ? Colors.cyanAccent.withOpacity(0.2) : Colors.white10,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isLoggedIn ? Icons.person : Icons.person_outline, 
                color: isLoggedIn ? Colors.cyanAccent : Colors.white54, 
                size: 16
              ),
            ),
            
            if (isDesktop) ...[
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLoggedIn ? "ONLINE NETWORK" : "OFFLINE GUEST",
                    style: TextStyle(color: isLoggedIn ? Colors.cyanAccent : Colors.white54, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                  ),
                  Text(
                    isLoggedIn ? (user?.email?.split('@')[0].toUpperCase() ?? "PLAYER") : "CONNECT PROFILE",
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white.withOpacity(0.5), size: 18),
            ],
          ],
        ),
      ),
    );
  }

  // --- DIALOGS EXTRACTED FROM HUB SCREEN ---

  void _showQuickAuthModal(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF121212),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.cyanAccent, width: 2)),
        title: const Center(child: Text("CONNECT PROFILE", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.w900, letterSpacing: 1.5))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Join the Global Network to play Pick 'Ems and sync to the blockchain.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 24),
            _buildDialogButton("SIGN IN WITH GOOGLE", Icons.g_mobiledata, Colors.white, () {
              Navigator.pop(ctx);
              ref.read(authStateProvider.notifier).signInWithGoogle();
            }),
            const SizedBox(height: 12),
            _buildDialogButton("SIGN IN WITH APPLE", Icons.apple, Colors.white, () {
              Navigator.pop(ctx);
              ref.read(authStateProvider.notifier).signInWithApple();
            }),
            const SizedBox(height: 24),
            _buildDialogButton("DEV BYPASS (TEST ACCOUNT)", Icons.bug_report, Colors.redAccent, () async {
              Navigator.pop(ctx);
              try {
                await Supabase.instance.client.auth.signInWithPassword(email: 'test@test.com', password: 'password123');
              } catch (e) {
                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("🚨 Error: $e")));
              }
            }),
          ],
        ),
      ),
    );
  }

  void _showProfileMenu(BuildContext context, WidgetRef ref, User? user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.white24, width: 1)),
        title: Column(
          children: [
            const Icon(Icons.account_circle, color: Colors.cyanAccent, size: 50),
            const SizedBox(height: 10),
            Text(user?.email ?? "User", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const Text("STATUS: ONLINE", style: TextStyle(color: Colors.greenAccent, fontSize: 10, letterSpacing: 1.0, fontWeight: FontWeight.w900)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(color: Colors.white10),
            const SizedBox(height: 10),
            _buildDialogButton("CONNECT SOLANA WALLET", Icons.account_balance_wallet, Colors.purpleAccent, () async {
              Navigator.pop(ctx);
              await ref.read(authStateProvider.notifier).connectSolanaWallet(context);
            }),
            const SizedBox(height: 12),
            _buildDialogButton("LOG OUT", Icons.logout, Colors.redAccent, () async {
              Navigator.pop(ctx);
              await Supabase.instance.client.auth.signOut();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogButton(String text, IconData icon, Color baseColor, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(colors: [const Color(0xFF1A1A1A), baseColor.withOpacity(0.1)], begin: Alignment.centerLeft, end: Alignment.centerRight),
        border: Border.all(color: baseColor.withOpacity(0.4), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              children: [
                Icon(icon, color: baseColor, size: 20),
                const SizedBox(width: 16),
                Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.0))),
                Icon(Icons.chevron_right_rounded, color: baseColor.withOpacity(0.5), size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}