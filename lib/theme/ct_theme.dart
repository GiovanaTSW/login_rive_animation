import 'package:flutter/material.dart';

/// Click & Tap brand constants.
class CT {
  static const navy = Color(0xFF02364A);
  static const prussian = Color(0xFF1C4EA7);
  static const midnight = Color(0xFF024D60);
  static const sea = Color(0xFF2CACAD);
  static const sky = Color(0xFF75E2E0);
  static const water = Color(0xFFD9F5F0);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: prussian,
          primary: prussian,
          secondary: sea,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: water,
        appBarTheme: const AppBarTheme(
          backgroundColor: navy,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
}
