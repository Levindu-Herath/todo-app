import 'package:flutter/foundation.dart';

import '../../services/preferences/preferences_service.dart';

class ThemeViewModel extends ChangeNotifier {
  ThemeViewModel(this._preferencesService);

  final PreferencesService _preferencesService;

  bool get isDarkMode => _preferencesService.isDarkMode;

  Future<void> setDarkMode(bool enabled) async {
    await _preferencesService.setDarkMode(enabled);
    notifyListeners();
  }
}
