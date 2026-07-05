import 'package:flutter/foundation.dart';

import '../../services/preferences/preferences_service.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel(this._preferencesService);

  final PreferencesService _preferencesService;

  bool get biometricsEnabled => _preferencesService.isBiometricEnabled;

  Future<void> setBiometricsEnabled(bool enabled) async {
    await _preferencesService.setBiometricEnabled(enabled);
    notifyListeners();
  }
}
