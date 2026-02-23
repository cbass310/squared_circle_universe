import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- THE GREAT PIVOT IMPORTS ---
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'ui/screens/hub_screen.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Unlock the vault to get your keys
  await dotenv.load(fileName: ".env");
  
  // 2. Fire up the pure-Dart Supabase Engine
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 1. UPDATED TITLE
      title: 'Squared Circle Tycoon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // NOIR THEME CONFIGURATION
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212), // Charcoal Black
        cardColor: const Color(0xFF1E1E1E), // Card Grey
        primaryColor: const Color(0xFFFFD740), // Gold Accent
        
        // 2. SMOOTH PAGE TRANSITIONS
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
            TargetPlatform.linux: ZoomPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: ZoomPageTransitionsBuilder(), // Zoom for Windows
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
      home: const HubScreen(), // The Entry Point
    );
  }
}