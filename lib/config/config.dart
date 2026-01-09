import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Config {
  static const Color primaryGreen = Color(0xFF3A653F);
  static const Color accentBlue = Color(0xFF4FB9E8);

  static const Color background = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color successGreen = Color(0xFF388E3C);

  static const String baseURLIbnu =
      "https://unforgettable-anjanette-longshore.ngrok-free.dev/api";
  // static const String baseURLApril = "https://unuseful-odell-subincomplete.ngrok-free.dev/api";
  // static const String baseURLRakha = "https://jamari-transuranic-uncentrally.ngrok-free.dev";
  // static const String baseURLAzwa = "https://fusilly-melida-spacially.ngrok-free.dev/api";

  ThemeData getAppTheme() {
    return ThemeData(
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        secondary: accentBlue,
        error: errorRed,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        TextTheme(
          headlineLarge: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: textPrimary,
          ),
          // Judul yang lebih kecil untuk bagian
          headlineMedium: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: textPrimary,
          ),
          // Judul untuk kartu
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: textPrimary,
          ),
          bodyLarge: TextStyle(fontSize: 16, color: textPrimary),
          bodyMedium: TextStyle(fontSize: 14, color: textSecondary),
          labelSmall: TextStyle(
            fontSize: 12,
            color: textPrimary,
            fontWeight: FontWeight.w600,
          ),
          labelLarge: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: primaryGreen, width: 2.0),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2.0,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
