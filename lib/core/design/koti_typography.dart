import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KotiTypography {
  static TextTheme get textTheme {
    return GoogleFonts.interTextTheme(
      const TextTheme(
        displayLarge: TextStyle(fontSize: 40, fontWeight: FontWeight.w700, letterSpacing: -1.0),
        displayMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.5),
        displaySmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
