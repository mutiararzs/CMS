import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Warna diambil dari desain login.
class AppColors {
  static const Color ink = Color(0xFF251838); // teks, garis, bayangan
  static const Color lavender = Color(0xFFB6ACE4);
  static const Color amber = Color(0xFFF2A815);
  static const Color pink = Color(0xFFFFC1C6);
  static const Color orange = Color(0xFFFF552E);
  static const Color red = Color(0xFFB12400);
  static const Color brown = Color(0xFF5B403A);
  static const Color white = Colors.white;
}

/// Gaya teks: Space Mono Bold (judul/label) dan Plus Jakarta Sans Medium (isi).
class AppText {
  static TextStyle mono({
    double size = 12,
    Color color = AppColors.ink,
    double letterSpacing = 0,
    double? height,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.spaceMono(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
      decorationColor: color,
    );
  }

  static TextStyle body({
    double size = 13,
    Color color = AppColors.ink,
    double letterSpacing = 0,
    double? height,
    FontWeight weight = FontWeight.w500,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }
}

/// Kotak dengan garis tebal dan bayangan keras (tanpa blur).
BoxDecoration neoBox({required Color color, double shadow = 4}) {
  return BoxDecoration(
    color: color,
    border: Border.all(color: AppColors.ink, width: 2),
    boxShadow: [
      BoxShadow(
        color: AppColors.ink,
        offset: Offset(shadow, shadow),
        blurRadius: 0,
      ),
    ],
  );
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.orange),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.ink,
      selectionColor: AppColors.lavender,
    ),
  );
}