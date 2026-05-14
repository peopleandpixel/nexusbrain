import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NexusBrainTheme {
  static const _primary = Color(0xFF8B5CF6);    // Violet
  static const _secondary = Color(0xFF06B6D4);   // Cyan
  static const _accent = Color(0xFFF59E0B);      // Amber
  static const _surface = Color(0xFF0F0F1A);     // Deep dark
  static const _card = Color(0xFF1A1A2E);        // Card dark
  static const _cardHover = Color(0xFF252540);   // Card hover
  static const _text = Color(0xFFE2E8F0);        // Light text
  static const _textMuted = Color(0xFF64748B);   // Muted text
  static const _border = Color(0xFF2D2D44);      // Border
  static const _danger = Color(0xFFEF4444);      // Red

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: _primary,
      secondary: _secondary,
      tertiary: _accent,
      surface: _surface,
      onSurface: _text,
      error: _danger,
    ),
    scaffoldBackgroundColor: _surface,
    cardColor: _card,
    dividerColor: _border,
    textTheme: GoogleFonts.interTextTheme(const TextTheme(
      headlineLarge: TextStyle(color: _text, fontWeight: FontWeight.w700, fontSize: 32),
      headlineMedium: TextStyle(color: _text, fontWeight: FontWeight.w600, fontSize: 24),
      headlineSmall: TextStyle(color: _text, fontWeight: FontWeight.w600, fontSize: 20),
      titleLarge: TextStyle(color: _text, fontWeight: FontWeight.w600, fontSize: 18),
      titleMedium: TextStyle(color: _text, fontWeight: FontWeight.w500, fontSize: 16),
      titleSmall: TextStyle(color: _textMuted, fontWeight: FontWeight.w500, fontSize: 14),
      bodyLarge: TextStyle(color: _text, fontSize: 16),
      bodyMedium: TextStyle(color: _text, fontSize: 14),
      bodySmall: TextStyle(color: _textMuted, fontSize: 12),
      labelLarge: TextStyle(color: _text, fontWeight: FontWeight.w500, fontSize: 14),
      labelMedium: TextStyle(color: _textMuted, fontSize: 12),
      labelSmall: TextStyle(color: _textMuted, fontSize: 10),
    )),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: _text,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: IconThemeData(color: _text),
    ),
    cardTheme: CardThemeData(
      color: _card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: _border, width: 1),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _card,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primary, width: 2),
      ),
      hintStyle: const TextStyle(color: _textMuted),
      labelStyle: const TextStyle(color: _textMuted),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primary,
      foregroundColor: Colors.white,
      elevation: 8,
      shape: CircleBorder(),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _card,
      selectedItemColor: _primary,
      unselectedItemColor: _textMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: _cardHover,
      selectedColor: _primary.withValues(alpha: 0.3),
      labelStyle: const TextStyle(color: _text, fontSize: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
    ),
    iconTheme: const IconThemeData(color: _textMuted, size: 20),
    dialogTheme: DialogThemeData(
      backgroundColor: _card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );

  // Gradient presets
  static const primaryGradient = LinearGradient(
    colors: [_primary, _secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const cardGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16162A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const glowGradient = RadialGradient(
    colors: [Color(0x338B5CF6), Colors.transparent],
    radius: 0.8,
  );
}
