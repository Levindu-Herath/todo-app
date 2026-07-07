import 'package:flutter/material.dart';
import '../../services/auth/auth_repository.dart';
import '../../services/preferences/preferences_service.dart';

class SettingsViewModel extends ChangeNotifier {
  final PreferencesService _preferencesService;
  final AuthRepository _authRepository;

  SettingsViewModel(this._preferencesService, this._authRepository) {
    _loadBiometricSetting();
  }

  bool _isBiometricLockEnabled = false;
  bool get isBiometricLockEnabled => _isBiometricLockEnabled;

  String? get userEmail => _authRepository.currentUser?.email;
  String? get userDisplayName => _authRepository.currentUser?.displayName;

  Future<void> _loadBiometricSetting() async {
    _isBiometricLockEnabled = await _preferencesService.getIsBiometricLockEnabled();
    notifyListeners();
  }

  Future<void> toggleBiometricLock(bool value) async {
    _isBiometricLockEnabled = value;
    notifyListeners();
    await _preferencesService.setIsBiometricLockEnabled(value);
  }

  Future<void> logOut() async {
    await _authRepository.signOut();
  }
}