import 'package:flutter/material.dart';
import '../../services/preferences/preferences_service.dart';

enum AccentTheme { ocean, coral, forest }

class ThemeViewModel extends ChangeNotifier {
  final PreferencesService _preferencesService;

  ThemeViewModel(this._preferencesService) {
    _loadSavedTheme();
  }

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  AccentTheme _accentTheme = AccentTheme.ocean;
  AccentTheme get accentTheme => _accentTheme;

  Future<void> _loadSavedTheme() async {
    _isDarkMode = await _preferencesService.getIsDarkMode();
    final name = await _preferencesService.getAccentThemeName();
    _accentTheme = AccentTheme.values.firstWhere(
      (e) => e.name == name,
      orElse: () => AccentTheme.ocean,
    );
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    await _preferencesService.setIsDarkMode(value);
  }

  Future<void> setAccentTheme(AccentTheme theme) async {
    _accentTheme = theme;
    notifyListeners();
    await _preferencesService.setAccentThemeName(theme.name);
  }

  Color get accentColor {
    switch (_accentTheme) {
      case AccentTheme.ocean:
        return const Color(0xFF1B6EC2);
      case AccentTheme.coral:
        return const Color(0xFFC25533);
      case AccentTheme.forest:
        return const Color(0xFF2B7A4B);
    }
  }
}