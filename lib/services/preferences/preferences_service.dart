import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants/storage_keys.dart';

class PreferencesService {
  Future<bool> getIsDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(StorageKeys.isDarkMode) ?? false;
  }

  Future<void> setIsDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(StorageKeys.isDarkMode, value);
  }

  Future<String> getAccentThemeName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.accentThemeName) ?? 'ocean';
  }

  Future<void> setAccentThemeName(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.accentThemeName, value);
  }

  Future<bool> getIsBiometricLockEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(StorageKeys.isBiometricLockEnabled) ?? false;
  }

  Future<void> setIsBiometricLockEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(StorageKeys.isBiometricLockEnabled, value);
  }
}