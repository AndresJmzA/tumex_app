import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primaryColor = Color(0xFF27737B);
  static const secondaryColor = Color(0xC4FFFFFF); // 80% opacity
  static const tertiaryColor = Color(0xFF06A1B1);

  static final ThemeData themeData = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme(
      primary: primaryColor,
      secondary: tertiaryColor, // Using tertiary as secondary for accents
      surface: Colors.white,
      background: Colors.white,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.raleway(
          fontSize: 96, fontWeight: FontWeight.w300, letterSpacing: -1.5),
      displayMedium: GoogleFonts.raleway(
          fontSize: 60, fontWeight: FontWeight.w300, letterSpacing: -0.5),
      displaySmall:
          GoogleFonts.raleway(fontSize: 48, fontWeight: FontWeight.w400),
      headlineMedium: GoogleFonts.raleway(
          fontSize: 34, fontWeight: FontWeight.w600, letterSpacing: 0.25),
      headlineSmall: GoogleFonts.raleway(
          fontSize: 24,
          fontWeight: FontWeight.w500), // Guide: 24px, Medium (w500)
      titleLarge: GoogleFonts.raleway(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15), // Guide: 22px, Medium (w500)
      bodyLarge: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5), // Body text
      bodyMedium: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25), // Guide: 14px, Normal (w400)
      labelLarge: GoogleFonts.raleway(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.25), // Buttons
      bodySmall: GoogleFonts.roboto(
          fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
      labelSmall: GoogleFonts.roboto(
          fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        textStyle: GoogleFonts.raleway(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primaryColor, width: 2.0),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: GoogleFonts.roboto(
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
    ),
  );
}
