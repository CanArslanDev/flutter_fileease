import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Themes {
  static final lightTextColor =
      GoogleFonts.inter(color: const Color(0xFF363635));
  static final darkTextColor =
      GoogleFonts.inter(color: const Color(0xFFFFFFFF));
  static final lightTheme = ThemeData.light().copyWith(
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primaryContainer: const Color(0xFFF3F3F3),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFFFFFFFF),
      elevation: 0,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFFFFFFFF),
      surfaceTintColor: Color(0xFFFFFFFF),
    ),
    scaffoldBackgroundColor: const Color(0xFFF2FBFF),
    primaryColor: const Color(0xFFF2FBFF),
    textTheme: GoogleFonts.interTextTheme(
      TextTheme(
        labelMedium: lightTextColor,
        labelLarge: lightTextColor,
        labelSmall: lightTextColor,
        displayMedium: lightTextColor,
        displayLarge: lightTextColor,
        displaySmall: lightTextColor,
        titleMedium: lightTextColor,
        titleLarge: lightTextColor,
        titleSmall: lightTextColor,
        bodyMedium: lightTextColor,
        bodyLarge: lightTextColor,
        bodySmall: lightTextColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF464646),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        minimumSize: Size(42.w, 12.w),
      ),
    ),
    appBarTheme: AppBarTheme(
      color: const Color(0xFFF2FBFF),
      elevation: 0,
      titleTextStyle: GoogleFonts.varelaRound(
        color: const Color(0xFF414040),
        fontSize: 5.w,
        fontWeight: FontWeight.bold,
      ),
      foregroundColor: const Color(0xFF414040),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.white,
      hintStyle: GoogleFonts.inter(
        color: Colors.grey.shade600,
        fontSize: 4.w,
        fontWeight: FontWeight.w500,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        gapPadding: 0,
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
      ),
    ),
  );

  static final darkTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primaryContainer: const Color(0xFF373A3E),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF272A32),
      elevation: 0,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: const Color(0xFF272A32),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        minimumSize: Size(42.w, 12.w),
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFF1D1E21),
    ),
    scaffoldBackgroundColor: const Color(0xFF1D1E21),
    primaryColor: const Color(0xFF1D1E21),
    textTheme: GoogleFonts.interTextTheme(
      TextTheme(
        labelMedium: darkTextColor,
        labelLarge: darkTextColor,
        labelSmall: darkTextColor,
        displayMedium: darkTextColor,
        displayLarge: darkTextColor,
        displaySmall: darkTextColor,
        titleMedium: darkTextColor,
        titleLarge: darkTextColor,
        titleSmall: darkTextColor,
        bodyMedium: darkTextColor,
        bodyLarge: darkTextColor,
        bodySmall: darkTextColor,
      ),
    ),
    appBarTheme: AppBarTheme(
      color: const Color(0xFF1D1E21),
      elevation: 0,
      titleTextStyle: GoogleFonts.varelaRound(
        color: const Color(0xFFF2FBFF),
        fontSize: 5.w,
        fontWeight: FontWeight.bold,
      ),
      foregroundColor: const Color(0xFFF2FBFF),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: const Color(0xFF272A32),
      hintStyle: GoogleFonts.inter(
        color: Colors.grey.shade600,
        fontSize: 4.w,
        fontWeight: FontWeight.w500,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade700, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade700, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        gapPadding: 0,
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade700, width: 1.5),
      ),
    ),
  );
}
