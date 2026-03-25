import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart'; 

// --- THE GREAT PIVOT IMPORTS ---
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// 🚨 IMPORT THE SPLASH SCREEN
import 'ui/screens/splash_screen.dart'; 

void main() async {
  // 1. Initialize core Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Wake up the translation engine
  await EasyLocalization.ensureInitialized(); 

  // ====================================================================
  // 🚨 THE FIX: COMPLETELY UNLOCK ALL ORIENTATIONS 🚨
  // ====================================================================
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  // 3. Unlock the vault to get your keys
  await dotenv.load(fileName: ".env");
  
  // 4. Fire up the pure-Dart Supabase Engine
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  
  // 5. Run the app: ProviderScope wraps EasyLocalization, which wraps MyApp
  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [
          Locale('en'), 
          Locale('es'), 
          Locale('pt')
        ],
        path: 'assets/translations', // Points to your dictionary folder
        fallbackLocale: const Locale('en'), 
        child: const MyApp(), 
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Squared Circle Tycoon',
      debugShowCheckedModeBanner: false,

      // 🚨 CRITICAL LOCALIZATION HOOKS 🚨
      // These tell your app to actually use the dictionaries we set up
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      theme: ThemeData(
        // NOIR THEME CONFIGURATION
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212), // Charcoal Black
        cardColor: const Color(0xFF1E1E1E), // Card Grey
        primaryColor: const Color(0xFFFFD740), // Gold Accent
        
        // SMOOTH PAGE TRANSITIONS
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
            TargetPlatform.linux: ZoomPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: ZoomPageTransitionsBuilder(), 
          },
        ),

        // Font Styles (Clean Sans-Serif)
        fontFamily: 'Roboto', 
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFEEEEEE), letterSpacing: 1.5),
          displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFEEEEEE)),
          bodyLarge: TextStyle(fontSize: 16, color: Color(0xFFEEEEEE)),
          bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFAAAAAA)), // Subtitles
        ),

        // Button Styles (Rectangular, Physical feel)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFD740), // Gold default
            foregroundColor: Colors.black, // Black text on Gold
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Slight curve
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),

        // AppBar Style
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFFFFD740), 
            fontSize: 22, 
            fontWeight: FontWeight.bold, 
            letterSpacing: 2.0
          ),
        ), 
        colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark).copyWith(secondary: const Color(0xFF18FFFF)), // Cyan Accent
      ),
      
      // Set the Entry Point to the Splash Screen
      home: const SplashScreen(), 
    );
  }
}