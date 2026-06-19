import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primaryColor = Color(0xFF4DA8DA);
  static const secondaryColor = Color(0xFF7BDFF2);
  static const accentColor = Color(0xFFA8E6CF);
  static const darkBackground = Color(0xFF0F172A);
  static const glassSurface = Color(0x1F969696); // Approx rgba(255,255,255,0.12)
  static const glassBorder = Color(0x40FFFFFF);  // Approx rgba(255,255,255,0.25)

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: darkBackground,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.white70,
        ),
      ),
      cardTheme: CardThemeData(
        color: glassSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: glassBorder, width: 0.5),
        ),
        elevation: 0,
      ),
    );
  }
}
