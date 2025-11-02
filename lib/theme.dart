import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFFB67BE6); // playful lavender
  static const Color accent = Color(0xFFFF8FB3); // soft pink
  static const Color bg = Color(0xFFFFFBFF);

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: bg,
    primaryColor: primary,
    colorScheme: ColorScheme.fromSwatch().copyWith(primary: primary, secondary: accent),
    appBarTheme: const AppBarTheme(backgroundColor: primary, elevation: 0),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    useMaterial3: true,
    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(fontSize: 14),
    ),
  );
}
