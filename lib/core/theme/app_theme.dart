import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Konstanta warna bernuansa toko kue (Strawberry / Pink pastel)
  static const Color primaryColor = Color(0xFFFF6B81); // Strawberry Pink
  static const Color secondaryColor = Color(0xFFFFC4D9); // Light Pink / Vanilla
  static const Color backgroundColor = Color(0xFFFFF5F6); // Very Light Pink (Almost white)
  static const Color textColor = Color(0xFF2D3436); // Charcoal / Dark Gray untuk teks
}

class AppTheme {
  static ThemeData get applicationTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      primaryColor: AppColors.primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        primary: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
        surface: AppColors.backgroundColor,
      ),
      // Konfigurasi TextTheme menggunakan Google Fonts (Quicksand)
      textTheme: GoogleFonts.quicksandTextTheme().apply(
        bodyColor: AppColors.textColor,
        displayColor: AppColors.textColor,
      ),
      // Konfigurasi AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white, // warna tombol back / icon
        centerTitle: true,
        elevation: 0,
        titleTextStyle: GoogleFonts.quicksand(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      // Konfigurasi gaya tombol secara global
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
