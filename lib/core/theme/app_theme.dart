import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 메인 컬러 정의
  static const Color primaryBlue = Color(0xFF4A90E2); // 진한 하늘색
  static const Color secondaryBlue = Color(0xFF64B5F6); // 밝은 하늘색
  static const Color backgroundWhite = Colors.white;
  static const Color textDark = Color(0xFF2C3E50);
  
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // 컬러 스키마
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      primary: primaryBlue,
      secondary: secondaryBlue,
      background: backgroundWhite,
      onBackground: textDark,
      surface: backgroundWhite,
      onSurface: textDark,
      brightness: Brightness.light,
    ),

    // 앱바 테마
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: backgroundWhite,
      elevation: 0,
      iconTheme: const IconThemeData(color: textDark),
      titleTextStyle: GoogleFonts.notoSans(
        color: textDark,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    // 카드 테마
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: backgroundWhite,
    ),

    // 버튼 테마
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryBlue,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // 텍스트 테마 업데이트
    textTheme: TextTheme(
      displayLarge: GoogleFonts.notoSans(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        color: textDark,
      ),
      displayMedium: GoogleFonts.notoSans(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        color: textDark,
      ),
      displaySmall: GoogleFonts.notoSans(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: textDark,
      ),
      headlineLarge: GoogleFonts.notoSans(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textDark,
      ),
      headlineMedium: GoogleFonts.notoSans(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textDark,
      ),
      headlineSmall: GoogleFonts.notoSans(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textDark,
      ),
      titleLarge: GoogleFonts.notoSans(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: textDark,
      ),
      titleMedium: GoogleFonts.notoSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textDark,
      ),
      titleSmall: GoogleFonts.notoSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textDark,
      ),
      bodyLarge: GoogleFonts.notoSans(
        fontSize: 16,
        color: textDark,
      ),
      bodyMedium: GoogleFonts.notoSans(
        fontSize: 14,
        color: textDark,
      ),
      bodySmall: GoogleFonts.notoSans(
        fontSize: 12,
        color: textDark,
      ),
    ),

    // 입력 필드 테마
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: backgroundWhite,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryBlue, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    ),
  );
}