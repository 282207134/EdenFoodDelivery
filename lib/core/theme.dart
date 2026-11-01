import 'package:flutter/material.dart';

abstract final class EdenColors {
  static const red = Color(0xFFBF213E);
  static const gold = Color(0xFFF5AF25);
  static const ink = Color(0xFF444444);
  static const muted = Color(0xFF888888);
  static const pale = Color(0xFFF7F7F7);
  static const teal = Color(0xFF00A0AA);
}

ThemeData get edenTheme => ThemeData(
  useMaterial3: true,
  fontFamily: 'Poppins',
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.fromSeed(
    seedColor: EdenColors.red,
    primary: EdenColors.red,
    secondary: EdenColors.gold,
    surface: Colors.white,
  ),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(
      fontSize: 28,
      height: 1.3,
      fontWeight: FontWeight.w600,
      color: EdenColors.ink,
    ),
    titleLarge: TextStyle(
      fontSize: 23,
      fontWeight: FontWeight.w600,
      color: EdenColors.ink,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: EdenColors.ink,
    ),
    bodyMedium: TextStyle(fontSize: 14, color: EdenColors.ink),
    bodySmall: TextStyle(fontSize: 12, color: EdenColors.muted),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: EdenColors.muted,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    toolbarHeight: 48,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size(double.infinity, 52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: EdenColors.pale,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    hintStyle: const TextStyle(fontSize: 13, color: EdenColors.muted),
  ),
  dividerTheme: const DividerThemeData(color: Color(0xFFEEEEEE)),
);
