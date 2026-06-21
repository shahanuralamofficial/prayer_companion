import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Constants for "Liquid Glass"
  static const double glassBlur = 40.0;
  static const double glassOpacity = 0.92;

  static const primaryColor = Color(0xFF4DA8DA);
  static const secondaryColor = Color(0xFF7BDFF2);
  static const accentColor = Color(0xFFA8E6CF);
  
  // Luxury Gold Palette
  static const luxuryGold = Color(0xFFD4AF37);
  static const luxuryGoldLight = Color(0xFFEBCB8B);
  static const luxuryGoldDark = Color(0xFFB8860B);

  // Modern Glassy Palette
  static const glassyTeal = Color(0xFFB2DFDB); // Refined teal glass
  static const activePrayerGreen = Color(0xFF2ECC71); 
  static const activePrayerGreenLight = Color(0x4D2ECC71); // 30% opacity for better contrast
  static const textPrimaryLight = Color(0xFF1A2521); // Darker for legibility
  static const textSecondaryLight = Color(0xFF536360);

  // Dark Theme Colors
  static const darkBackground = Color(0xFF0F172A);
  static const glassSurfaceDark = Color(0xCC1E293B); // Higher opacity
  static const glassBorderDark = Color(0x40FFFFFF);

  // Light Theme Colors
  static const lightBackground = Color(0xFFF8FAFC);
  static const glassSurfaceLight = Color(0xCCB2DFDB);
  static const glassBorderLight = Color(0x4064748B);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: luxuryGold,
        surface: glassyTeal,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 36,
          fontWeight: FontWeight.w900,
          color: textPrimaryLight,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: textPrimaryLight,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: textSecondaryLight,
          fontWeight: FontWeight.w600,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: textSecondaryLight,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: luxuryGold,
        surface: darkBackground,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 36,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: Colors.white.withValues(alpha: 0.8),
          fontWeight: FontWeight.w600,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: Colors.white54,
        ),
      ),
    );
  }
}
