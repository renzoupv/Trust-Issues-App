import 'package:flutter/material.dart';

class AppColors {
  static const Color coral        = Color(0xFFFF5A5A); // main red/coral brand color
  static const Color green        = Color(0xFF4CAF50); // START GAME / Show my Word buttons
  static const Color cardWhite    = Color(0xFFFFFFFF);
  static const Color offWhite     = Color(0xFFF5F5F5);
  static const Color darkBg       = Color(0xFF2D2D2D); // Discussion / Summary screen background
  static const Color textDark     = Color(0xFF212121);
  static const Color textGray     = Color(0xFF9E9E9E);
  static const Color textLight    = Color(0xFFFFFFFF);
  static const Color imposterPink = Color(0xFFFFCDD2);
  static const Color imposterRed  = Color(0xFFE53935);
  static const Color wordBlue     = Color(0xFFBBDEFB);
  static const Color wordBlueDark = Color(0xFF1565C0);
  static const Color toggleGreen  = Color(0xFF66BB6A);
  static const Color darkButton   = Color(0xFF212121);
  static const Color revealGray   = Color(0xFF9E9E9E); // "Reveal" button in discussion
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.coral,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.coral,
        primary: AppColors.coral,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.coral,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textLight,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          elevation: 2,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardWhite,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}