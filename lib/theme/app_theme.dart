import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color backgroundColor = Colors.white;
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFB00020);
  static const Color onPrimaryColor = Colors.white;
  static const Color onSecondaryColor = Colors.black;
  static const Color onBackgroundColor = Colors.black87;
  static const Color onSurfaceColor = Colors.black87;

  static ThemeData get lightTheme {
    final base = ThemeData.light();
    return base.copyWith(
      colorScheme: ColorScheme(
        primary: primaryColor,
        primaryContainer: primaryColor.withOpacity(0.8),
        secondary: secondaryColor,
        secondaryContainer: secondaryColor.withOpacity(0.8),
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
        onPrimary: onPrimaryColor,
        onSecondary: onSecondaryColor,
        onSurface: onSurfaceColor,
        onBackground: onBackgroundColor,
        onError: onPrimaryColor,
        brightness: Brightness.light,
      ),
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryColor,
        elevation: 4,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onPrimaryColor,
        ),
        iconTheme: IconThemeData(color: onPrimaryColor),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        base.textTheme,
      ).apply(bodyColor: onBackgroundColor, displayColor: onBackgroundColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: onPrimaryColor,
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        labelStyle: TextStyle(color: primaryColor),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: primaryColor,
        contentTextStyle: GoogleFonts.poppins(
          color: onPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      ),
      iconTheme: IconThemeData(color: primaryColor),
    );
  }
}
