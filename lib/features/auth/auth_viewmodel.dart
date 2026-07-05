import 'package:flutter/foundation.dart';

import '../../services/auth/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._authRepository);

  final AuthRepository _authRepository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool get isAuthenticated => _authRepository.currentUserId != null;

  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    try {
      return await _authRepository.login(email: email, password: password);
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register({required String email, required String password}) async {
    _setLoading(true);
    try {
      return await _authRepository.register(email: email, password: password);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authRepository.logout();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
