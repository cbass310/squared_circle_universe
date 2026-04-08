import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_links/app_links.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum AuthState {
  initial,
  authenticating,
  authenticated,
  unauthenticated,
  error
}

class AuthNotifier extends StateNotifier<AuthState> {
  final _supabase = Supabase.instance.client;
  late AppLinks _appLinks;
  HttpServer? _localServer; // 🚨 The PC Catcher's Mitt

  AuthNotifier() : super(AuthState.initial) {
    _checkInitialSession();
    _setupDeepLinks();

    // If we are on PC, Mac, or Linux, start the local server!
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
      _startLocalServer();
    }
  }

  // ==========================================================
  // 🚨 THE PC LOCALHOST SERVER (Catching the Web Token)
  // ==========================================================
  Future<void> _startLocalServer() async {
    try {
      // Open the port
      _localServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 3000);
      debugPrint('PC Server listening on localhost:3000');

      _localServer!.listen((HttpRequest request) async {
        final uri = request.uri;

        if (uri.path == '/auth/callback') {
          final fullUri = Uri.parse('http://localhost:3000$uri');

          try {
            await _supabase.auth.getSessionFromUrl(fullUri);
            state = AuthState.authenticated;
          } catch (e) {
            debugPrint('Supabase Session Error: $e');
          }

          request.response
            ..statusCode = HttpStatus.ok
            ..headers.contentType = ContentType.html
            ..write('''
              <html>
                <body style="background-color: #030712; color: #cbd5e1; font-family: sans-serif; display: flex; flex-direction: column; justify-content: center; align-items: center; height: 100vh; margin: 0; text-align: center;">
                  <h1 style="color: #f59e0b; font-size: 3rem; margin-bottom: 10px; text-transform: uppercase; letter-spacing: 2px;">Login Successful!</h1>
                  <p style="font-size: 1.2rem; color: #18FFFF;">You can securely close this window and return to Squared Circle Tycoon.</p>
                </body>
              </html>
            ''');
          await request.response.close();
        }
      });
    } catch (e) {
      debugPrint('Could not start local server: $e');
    }
  }

  void _setupDeepLinks() {
    _appLinks = AppLinks();
    _appLinks.uriLinkStream.listen((uri) {
      debugPrint('Deep Link Received: $uri');
      _supabase.auth.getSessionFromUrl(uri);
    });
  }

  void _checkInitialSession() {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      state = AuthState.authenticated;
    } else {
      state = AuthState.unauthenticated;
    }

    _supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        state = AuthState.authenticated;
      } else if (event == AuthChangeEvent.signedOut) {
        state = AuthState.unauthenticated;
      }
    });
  }

  String get _getRedirectUrl {
    if (kIsWeb) {
      return 'https://terminal.online/';
    }
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return 'http://localhost:3000/auth/callback';
    }
    return 'io.supabase.squaredcircle://login-callback/';
  }

  // ==========================================================
  // 🍎 APPLE LOGIN
  // ==========================================================
  Future<void> signInWithApple() async {
    state = AuthState.authenticating;
    try {
      final isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

      if (isMobile) {
        final rawNonce = _supabase.auth.generateRawNonce();
        final bytes = utf8.encode(rawNonce);
        final digest = sha256.convert(bytes);
        final hashedNonce = digest.toString();

        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: hashedNonce,
        );

        final idToken = credential.identityToken;
        if (idToken == null) throw 'No ID Token found.';

        await _supabase.auth.signInWithIdToken(
          provider: OAuthProvider.apple,
          idToken: idToken,
          nonce: rawNonce,
        );
      } else {
        await _supabase.auth.signInWithOAuth(
          OAuthProvider.apple,
          redirectTo: _getRedirectUrl,
        );
      }
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
      final isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

      if (isMobile) {
        const webClientId =
            '1516941054-u6ngjhp7qrh583k9hhs2vts8569l63uf.apps.googleusercontent.com';
        const iosClientId =
            '1516941054-5a1ovs12o1s4qhdqc62fgq240i912grr.apps.googleusercontent.com';

        final GoogleSignIn googleSignIn = GoogleSignIn(
          clientId: Platform.isIOS ? iosClientId : null,
          serverClientId: webClientId,
        );

        final googleUser = await googleSignIn.signIn();
        if (googleUser == null) {
          state = AuthState.unauthenticated;
          return;
        }

        final googleAuth = await googleUser.authentication;
        final accessToken = googleAuth.accessToken;
        final idToken = googleAuth.idToken;

        if (idToken == null) throw 'No ID Token found.';

        await _supabase.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
          accessToken: accessToken,
        );
      } else {
        await _supabase.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: _getRedirectUrl,
        );
      }
    } catch (e) {
      debugPrint('Google Auth Error: $e');
      state = AuthState.error;
    }
  }

  // ==========================================================
  // 🟣 SOLANA WEB3 WALLET CONNECTION (Phantom & Solflare)
  // ==========================================================
  Future<void> signInWithSolana(BuildContext context) async {
    // 1. Check if they are logged into a base account (Google/Apple)
    final user = _supabase.auth.currentUser;
    if (user == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Please connect with Apple or Google first to create your base profile, then link your wallet!",
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          backgroundColor: Colors.amber,
        ));
      }
      return;
    }

    // 2. Ask the user which wallet they want to use
    final String? selectedWallet = await showModalBottomSheet<String>(
        context: context,
        backgroundColor: const Color(0xFF1E1E1E),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (BuildContext ctx) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("SELECT WALLET",
                      style: TextStyle(
                          color: Colors.cyanAccent,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          letterSpacing: 1.5)),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet,
                        color: Colors.purpleAccent),
                    title: const Text("Phantom Wallet",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    tileColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.white12)),
                    onTap: () => Navigator.pop(ctx, 'phantom'),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet,
                        color: Colors.orangeAccent),
                    title: const Text("Solflare Wallet",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    tileColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.white12)),
                    onTap: () => Navigator.pop(ctx, 'solflare'),
                  ),
                ],
              ),
            ),
          );
        });

    // If they swipe down or dismiss the menu, cancel the flow
    if (selectedWallet == null) return;

    state = AuthState.authenticating;

    try {
      Uri walletUrl;
      Uri fallbackDownloadUrl;

      // 3. Set up the deep links based on their choice
      if (selectedWallet == 'phantom') {
        walletUrl = Uri.parse(
            'https://phantom.app/ul/v1/connect?app_url=https://terminal.online&redirect_link=$_getRedirectUrl');
        fallbackDownloadUrl = Uri.parse('https://phantom.app/');
      } else {
        walletUrl = Uri.parse(
            'https://solflare.com/ul/v1/connect?app_url=https://terminal.online&redirect_link=$_getRedirectUrl');
        fallbackDownloadUrl = Uri.parse('https://solflare.com/');
      }

      // 4. Launch the wallet
      if (await canLaunchUrl(walletUrl)) {
        await launchUrl(walletUrl, mode: LaunchMode.externalApplication);

        // Update Supabase with whichever wallet they used
        await _supabase.from('pickem_scores').update({
          'wallet_address': 'Web3_Wallet_Linked_$selectedWallet'
        }).eq('user_id', user.id);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "${selectedWallet == 'phantom' ? 'Phantom' : 'Solflare'} successfully linked!"),
              backgroundColor: Colors.greenAccent));
        }
      } else {
        debugPrint("No wallet detected. Routing to download page.");
        await launchUrl(fallbackDownloadUrl,
            mode: LaunchMode.externalApplication);
      }

      state = AuthState.authenticated;
    } catch (e) {
      debugPrint("Solana Auth Error: $e");
      state = AuthState.error;
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
