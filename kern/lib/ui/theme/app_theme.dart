import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static ThemeData lightTheme(ColorScheme? dynamicColorScheme) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: background,
      colorScheme: dynamicColorScheme ?? ColorScheme.fromSeed(
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
        selectedItemColor: dynamicColorScheme?.primary ?? primaryBlue,
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

  static ThemeData darkTheme(ColorScheme? dynamicColorScheme) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: dynamicColorScheme ?? ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.dark,
        surface: const Color(0xFF1E1E1E),
        primary: primaryBlue,
        onSurface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: dynamicColorScheme?.primary ?? primaryBlue,
        unselectedItemColor: Colors.white54,
        elevation: 16,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Colors.white12, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: Colors.white70,
        textColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}

// Global theme mode provider

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  static const _key = 'kern_theme_mode';

  ThemeModeNotifier() : super(ThemeMode.light) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_key);
    state = stored == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggle() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    state = newMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, newMode == ThemeMode.dark ? 'dark' : 'light');
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode == ThemeMode.dark ? 'dark' : 'light');
  }
}

final useDynamicColorProvider = StateNotifierProvider<DynamicColorNotifier, bool>((ref) {
  return DynamicColorNotifier();
});

class DynamicColorNotifier extends StateNotifier<bool> {
  static const _key = 'kern_dynamic_color';

  DynamicColorNotifier() : super(true) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_key) ?? true;
  }

  Future<void> toggle() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, state);
  }

  Future<void> setMode(bool useDynamicColor) async {
    state = useDynamicColor;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, state);
  }
}
