import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'surface_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.brand),
      scaffoldBackgroundColor: SurfaceColors.background,
      useMaterial3: true,
    );

    return base.copyWith(
      appBarTheme: base.appBarTheme.copyWith(centerTitle: false),
      cardTheme: const CardThemeData(color: SurfaceColors.card),
    );
  }
}
