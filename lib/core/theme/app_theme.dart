import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFFF6F7F9);
  static const navy = Color(0xFF10394B);
  static const teal = Color(0xFF20A6A4);
  static const muted = Color(0xFF667D85);
  static const border = Color(0xFFE5E9EB);
  static const mint = Color(0xFFE4F5F1);
  static const blue = Color(0xFFE7F0F7);
  static const purple = Color(0xFFF1ECF8);
  static const peach = Color(0xFFFFF0E4);
}

abstract final class AppSpace {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const section = 36.0;
  static const radius = 20.0;
  static const iconRadius = 14.0;
  static const maxWidth = 1120.0;
  static const tablet = 700.0;
  static const desktop = 1000.0;
}

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.teal,
      primary: AppColors.teal,
      secondary: AppColors.navy,
      surface: Colors.white,
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.w800,
        height: 1.5,
        color: AppColors.navy,
      ),
      titleLarge: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w700,
        height: 1.5,
        color: AppColors.navy,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.5,
        color: AppColors.navy,
      ),
      bodyMedium: TextStyle(fontSize: 14, height: 1.6, color: AppColors.navy),
      bodySmall: TextStyle(fontSize: 12, height: 1.5, color: AppColors.muted),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
    ),
    iconTheme: const IconThemeData(color: AppColors.muted),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: AppColors.muted, fontSize: 13),
      contentPadding: const EdgeInsets.all(AppSpace.md),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpace.radius),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpace.radius),
        borderSide: const BorderSide(color: AppColors.border),
      ),
    ),
  );
}
