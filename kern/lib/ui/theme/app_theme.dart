import 'package:flutter/material.dart';

/// Centralized design tokens matching the light "Google Health" aesthetic.
class AppTheme {
  // Brand Colors
  static const Color primaryBlue = Color(0xFF1A73E8);
  static const Color background = Color(0xFFF4F7FB);
  static const Color surface = Colors.white;
  
  // Accents (Pastels)
  static const Color accentMint = Color(0xFFE6F4EA);
  static const Color textMint = Color(0xFF137333);
  
  static const Color accentPurple = Color(0xFFF3E8FD);
  static const Color textPurple = Color(0xFF681DA8);
  
  static const Color accentBlue = Color(0xFFE8F0FE);
  static const Color textBlue = Color(0xFF1967D2);
  
  static const Color accentOrange = Color(0xFFFEF7E0);
  static const Color textOrange = Color(0xFFE37400);

  static const Color accentPink = Color(0xFFFCE8E6);
  static const Color textPink = Color(0xFFC5221F);

  // Text Colors
  static const Color textPrimary = Color(0xFF202124);
  static const Color textSecondary = Color(0xFF5F6368);
  static const Color textTertiary = Color(0xFF80868B);

  // Borders & Dividers
  static const Color divider = Color(0xFFE8EAED);

  // Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        surface: surface,
        primary: primaryBlue,
        onSurface: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primaryBlue,
        unselectedItemColor: textTertiary,
        elevation: 16,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: divider, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: textSecondary,
        textColor: textPrimary,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
