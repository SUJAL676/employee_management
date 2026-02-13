import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primaryBlue = Color(0xFF2F80ED);
  static const background = Color(0xFFF4F7FC);
  static const textPrimary = Color(0xFF1F2937);
  static const textSecondary = Color(0xFF6B7280);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.interTextTheme(),
  );
}

class AppColors {
  static const primary = Color(0xFF2196F3);
  static const primaryDark = Color(0xFF1976D2);

  static const surface = Color(0xFFF5F5F5);
  static const backgroundGradientStart = Color(0xFFFFFFFF);
  static const backgroundGradientEnd = Color(0xFFF5F5F5);

  static const textMain = Color(0xFF2D3748);
  static const textDark = Color(0xFF1F2937);
  static const textMuted = Color(0xFF718096);
  static const textLight = Color(0xFF94A3B8);

  static const border = Color(0xFFE2E8F0);

  static const greenOnline = Color(0xFF22C55E);
}
