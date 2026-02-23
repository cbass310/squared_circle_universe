import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/screens/hub_screen.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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
        
        // 2. SMOOTH PAGE TRANSITIONS (Added this block)
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
      home: const HubScreen(), // The new Entry Point
    );
  }
}