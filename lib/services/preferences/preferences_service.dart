class PreferencesService {
  bool _isDarkMode = false;
  bool _isBiometricEnabled = false;

  bool get isDarkMode => _isDarkMode;
  bool get isBiometricEnabled => _isBiometricEnabled;

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
  }

  Future<void> setBiometricEnabled(bool value) async {
    _isBiometricEnabled = value;
  }
}
