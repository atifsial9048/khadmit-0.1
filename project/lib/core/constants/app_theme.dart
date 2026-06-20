import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryGreen,
      primary: AppColors.primaryGreen,
      secondary: AppColors.gold,
      surface: AppColors.white,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.grey50,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
    ),
    cardTheme: CardTheme(
      color: AppColors.white,
      elevation: 2,
      shadowColor: AppColors.primaryGreen.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryGreen,
        side: const BorderSide(color: AppColors.primaryGreen),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.grey200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.grey200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: GoogleFonts.poppins(color: AppColors.grey400, fontSize: 14),
      labelStyle: GoogleFonts.poppins(color: AppColors.grey600, fontSize: 14),
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: AppColors.grey900),
      displayMedium: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: AppColors.grey900),
      headlineLarge: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: AppColors.grey900),
      headlineMedium: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.grey900),
      titleLarge: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.grey900),
      titleMedium: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: AppColors.grey800),
      bodyLarge: GoogleFonts.poppins(color: AppColors.grey800),
      bodyMedium: GoogleFonts.poppins(color: AppColors.grey700),
      bodySmall: GoogleFonts.poppins(color: AppColors.grey500),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primaryGreen,
      unselectedItemColor: AppColors.grey400,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.grey100,
      selectedColor: AppColors.primaryGreen.withOpacity(0.15),
      labelStyle: GoogleFonts.poppins(fontSize: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.grey200,
      thickness: 1,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryGreen,
      brightness: Brightness.dark,
      primary: AppColors.primaryGreenLight,
      secondary: AppColors.gold,
      surface: AppColors.darkSurface,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.darkBg,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
    ),
    cardTheme: CardTheme(
      color: AppColors.darkCard,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGreenLight,
        foregroundColor: AppColors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryGreenLight,
        side: const BorderSide(color: AppColors.primaryGreenLight),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.grey700),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.grey700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primaryGreenLight, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: GoogleFonts.poppins(color: AppColors.grey500, fontSize: 14),
      labelStyle: GoogleFonts.poppins(color: AppColors.grey400, fontSize: 14),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: AppColors.white),
      displayMedium: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: AppColors.white),
      headlineLarge: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: AppColors.white),
      headlineMedium: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.white),
      titleLarge: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.white),
      titleMedium: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: AppColors.grey200),
      bodyLarge: GoogleFonts.poppins(color: AppColors.grey200),
      bodyMedium: GoogleFonts.poppins(color: AppColors.grey300),
      bodySmall: GoogleFonts.poppins(color: AppColors.grey400),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: AppColors.primaryGreenLight,
      unselectedItemColor: AppColors.grey500,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkCard,
      selectedColor: AppColors.primaryGreenLight.withOpacity(0.25),
      labelStyle: GoogleFonts.poppins(fontSize: 12, color: AppColors.grey200),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.grey700,
      thickness: 1,
    ),
  );
}
