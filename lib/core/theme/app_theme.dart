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

  // Modern Glassy Palette (Perfect Match for Reference Image)
  static const glassyTeal = Color(0xFFE8F6F6); 
  static const activePrayerGreen = Color(0xFF2ECC71); 
  static const activePrayerGreenDark = Color(0xFF1B5E20); 
  static const activePrayerGreenLight = Color(0xFFD1F2EB); // Perfect teal-mint match
  
  static const textPrimaryLight = Color(0xFF1A2521); 
  static const textSecondaryLight = Color(0xFF536360);

  // Dark Theme Colors
  static const darkBackground = Color(0xFF0F172A);
  static const glassSurfaceDark = Color(0xEB1E293B); 
  static const glassBorderDark = Color(0x40FFFFFF);

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
