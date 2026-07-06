import 'package:flutter/material.dart';
import '../../features/theme/theme_viewmodel.dart';
import 'app_colors.dart';

class _AccentRamp {
  final Color a50;
  final Color a400;
  final Color a600;
  final Color a800;
  const _AccentRamp({
    required this.a50,
    required this.a400,
    required this.a600,
    required this.a800,
  });
}

class AppTheme {
  AppTheme._();

  static _AccentRamp _rampFor(AccentTheme accent) {
    switch (accent) {
      case AccentTheme.ocean:
        return const _AccentRamp(
          a50: AppColors.oceanAccent50,
          a400: AppColors.oceanAccent400,
          a600: AppColors.oceanAccent600,
          a800: AppColors.oceanAccent800,
        );
      case AccentTheme.coral:
        return const _AccentRamp(
          a50: AppColors.coralAccent50,
          a400: AppColors.coralAccent400,
          a600: AppColors.coralAccent600,
          a800: AppColors.coralAccent800,
        );
      case AccentTheme.forest:
        return const _AccentRamp(
          a50: AppColors.forestAccent50,
          a400: AppColors.forestAccent400,
          a600: AppColors.forestAccent600,
          a800: AppColors.forestAccent800,
        );
    }
  }

  static ThemeData build({
    required AccentTheme accent,
    required Brightness brightness,
  }) {
    final ramp = _rampFor(accent);
    final isDark = brightness == Brightness.dark;

    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final card = isDark ? AppColors.darkCard : AppColors.lightCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final textMuted = isDark
        ? AppColors.darkTextMuted
        : AppColors.lightTextMuted;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: ramp.a600,
      onPrimary: Colors.white,
      primaryContainer: ramp.a50,
      onPrimaryContainer: ramp.a800,
      secondary: ramp.a400,
      onSecondary: Colors.white,
      surface: surface,
      onSurface: textPrimary,
      error: AppColors.error,
      onError: Colors.white,
      outline: border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      colorScheme: colorScheme,
      primaryColor: ramp.a600,
      dividerColor: border,

      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: textPrimary,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        iconTheme: IconThemeData(color: textSecondary),
      ),

      textTheme: TextTheme(
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: textPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: textPrimary),
        labelMedium: TextStyle(fontSize: 13, color: textSecondary),
        bodySmall: TextStyle(fontSize: 12, color: textSecondary),
        labelSmall: TextStyle(fontSize: 11, color: textMuted),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ramp.a600,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: BorderSide(color: border),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: ramp.a600),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: TextStyle(color: textMuted, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ramp.a600, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return ramp.a600;
          return border;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return ramp.a600;
          return border;
        }),
        trackOutlineWidth: const WidgetStatePropertyAll(1),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ramp.a600,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? AppColors.darkCard : bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
