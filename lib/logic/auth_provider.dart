import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Note: You will eventually need to add the 'url_launcher' package to your pubspec.yaml for Solana Deep Linking

enum AuthState { initial, authenticating, authenticated, unauthenticated, error }

class AuthNotifier extends StateNotifier<AuthState> {
  final _supabase = Supabase.instance.client;

  AuthNotifier() : super(AuthState.initial) {
    _checkInitialSession();
  }

  void _checkInitialSession() {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      state = AuthState.authenticated;
    } else {
      state = AuthState.unauthenticated;
    }

    // Listen for auth changes (like when they log in or out)
    _supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        state = AuthState.authenticated;
      } else if (event == AuthChangeEvent.signedOut) {
        state = AuthState.unauthenticated;
      }
    });
  }

  // ==========================================================
  // 🍎 APPLE LOGIN
  // ==========================================================
  Future<void> signInWithApple() async {
    state = AuthState.authenticating;
    try {
      // This uses Supabase's built-in OAuth handler
      // NOTE: Requires Apple setup in Supabase Dashboard before store launch
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: 'io.supabase.squaredcircle://login-callback/', // Your app's deep link
      );
    } catch (e) {
      debugPrint('Apple Auth Error: $e');
      state = AuthState.error;
    }
  }

  // ==========================================================
  // 🇬 GOOGLE LOGIN
  // ==========================================================
  Future<void> signInWithGoogle() async {
    state = AuthState.authenticating;
    try {
      // NOTE: Requires Google Cloud Console setup before store launch
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.squaredcircle://login-callback/', 
      );
    } catch (e) {
      debugPrint('Google Auth Error: $e');
      state = AuthState.error;
    }
  }

  // ==========================================================
  // 👻 PHANTOM WALLET CONNECTION (SOLANA)
  // ==========================================================
  Future<void> connectSolanaWallet(BuildContext context) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You must be logged in to link a wallet!", style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.red));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Opening Phantom... (Dev Mode)", style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.purpleAccent));

    try {
      /* * 🚀 REAL WORLD SOLANA LOGIC (Requires url_launcher):
       * 1. You format a Phantom Deep Link URL.
       * 2. The app minimizes and opens the Phantom app on their phone.
       * 3. The player clicks "Connect" in Phantom.
       * 4. Phantom re-opens your game and passes back their Public Key.
       */
       
      // FOR NOW: We simulate a successful Phantom connection to test the database!
      await Future.delayed(const Duration(seconds: 2)); 
      String simulatedPhantomAddress = "7xV...PhantomTest...3qP";

      // Save the wallet to their Pick 'Em profile!
      await _supabase.from('pickem_scores').update({
        'wallet_address': simulatedPhantomAddress
      }).eq('user_id', user.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Wallet Linked: $simulatedPhantomAddress", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)), backgroundColor: Colors.cyanAccent)
        );
      }
    } catch (e) {
      debugPrint("Wallet Link Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to link wallet: $e"), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});