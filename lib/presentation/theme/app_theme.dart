import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData build() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.sorted),
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          color: Colors.white70,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
