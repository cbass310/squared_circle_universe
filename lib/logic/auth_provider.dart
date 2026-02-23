import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthState { initial, unauthenticated, authenticating, authenticated }

// 1. The Supabase Engine
class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Listen to the cloud to see if the user is logged in
  Stream<AuthState> get authStateChanges {
    return _supabase.auth.onAuthStateChange.map((event) {
      if (event.session != null) {
        return AuthState.authenticated;
      } else {
        return AuthState.unauthenticated;
      }
    });
  }

  // Supabase makes Google Sign-In a one-liner!
  Future<void> signInWithGoogle() async {
    await _supabase.auth.signInWithOAuth(OAuthProvider.google);
  }

  // Supabase makes Apple Sign-In a one-liner too!
  Future<void> signInWithApple() async {
    await _supabase.auth.signInWithOAuth(OAuthProvider.apple);
  }
  
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}

// 2. The Riverpod Providers
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});

// 3. The State Manager
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState.initial) {
    // Automatically update the UI if the login status changes
    _authService.authStateChanges.listen((state) {
      this.state = state;
    });
  }

  Future<void> signInWithGoogle() async {
    state = AuthState.authenticating;
    try {
      await _authService.signInWithGoogle();
    } catch (e) {
      state = AuthState.unauthenticated;
    }
  }

  Future<void> signInWithApple() async {
    state = AuthState.authenticating;
    try {
      await _authService.signInWithApple();
    } catch (e) {
      state = AuthState.unauthenticated;
    }
  }
  
  Future<void> signOut() async {
    await _authService.signOut();
  }
}