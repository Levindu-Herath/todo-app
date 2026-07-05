import 'package:flutter/material.dart';

class AppColors {
  // Ocean blue (default)
  static const oceanAccent50 = Color(0xFFE8F1FB);
  static const oceanAccent400 = Color(0xFF4A90D9);
  static const oceanAccent600 = Color(0xFF1B6EC2);
  static const oceanAccent800 = Color(0xFF0C447C);

  // Warm coral
  static const coralAccent50 = Color(0xFFFAECE7);
  static const coralAccent400 = Color(0xFFE07850);
  static const coralAccent600 = Color(0xFFC25533);
  static const coralAccent800 = Color(0xFF712B13);

  // Forest green
  static const forestAccent50 = Color(0xFFE6F4EC);
  static const forestAccent400 = Color(0xFF3DA667);
  static const forestAccent600 = Color(0xFF2B7A4B);
  static const forestAccent800 = Color(0xFF1A5C35);

  // Kept for existing call sites — points at ocean (default)
  static const accent600 = oceanAccent600;

  // Semantic (theme-independent)
  static const error = Color(0xFFE24B4A);
  static const errorLightBg = Color(0xFFFCEBEB);
  static const errorLightBorder = Color(0xFFF09595);
  static const errorLightText = Color(0xFFA32D2D);
  static const errorDarkBg = Color(0xFF3A1A1A);
  static const errorDarkBorder = Color(0xFF5A2020);
  static const errorDarkText = Color(0xFFF09595);

  static const success = Color(0xFF2B7A4B);
  static const successLightBg = Color(0xFFE6F4EC);
  static const successLightBorder = Color(0xFFA5D6A7);
  static const successLightText = Color(0xFF1A5C35);
  static const successDarkBg = Color(0xFF1A2E1F);
  static const successDarkBorder = Color(0xFF2A4A30);
  static const successDarkText = Color(0xFF66BB6A);

  static const warning = Color(0xFFD4880F);
  static const warningLightBg = Color(0xFFFFF3E0);
  static const warningLightBorder = Color(0xFFFFD180);
  static const warningLightText = Color(0xFFB86E00);
  static const warningDarkBg = Color(0xFF3A2E1A);
  static const warningDarkBorder = Color(0xFF5C4520);
  static const warningDarkText = Color(0xFFFFB74D);

  // Light surfaces
  static const lightBg = Color(0xFFFFFFFF);
  static const lightSurface = Color(0xFFFAFAF8);
  static const lightCard = Color(0xFFF3F2EE);
  static const lightBorder = Color(0xFFE0DFD8);
  static const lightTextPrimary = Color(0xFF1A1A19);
  static const lightTextSecondary = Color(0xFF73726C);
  static const lightTextMuted = Color(0xFFADABA2);

  // Dark surfaces
  static const darkBg = Color(0xFF121212);
  static const darkSurface = Color(0xFF1E1E1D);
  static const darkCard = Color(0xFF2A2A28);
  static const darkBorder = Color(0xFF3D3D3A);
  static const darkTextPrimary = Color(0xFFE8E7E0);
  static const darkTextSecondary = Color(0xFF9C9A92);
  static const darkTextMuted = Color(0xFF5F5E5A);
}