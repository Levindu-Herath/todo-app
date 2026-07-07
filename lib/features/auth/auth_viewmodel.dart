import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/utils/validators.dart';
import '../../services/auth/auth_repository.dart';
import '../../di/service_locator.dart';
import '../../services/task/synced_task_repository.dart';

enum AuthStatus { idle, loading, error }

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository);

  AuthStatus _status = AuthStatus.idle;
  AuthStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? passwordError;
  int passwordStrength = 0;
  List<String> passwordRequirements = [];

  void onPasswordChanged(String value) {
    passwordError = PasswordValidator.validate(value);
    passwordStrength = PasswordValidator.strengthScore(value);
    passwordRequirements = PasswordValidator.unmetRequirements(value);
    notifyListeners();
  }

  bool get isPasswordValid => passwordError == null;

  Future<bool> signIn(String email, String password) async {
    _setLoading();
    try {
      await _authRepository.signInWithEmail(email.trim(), password);
      _setIdle();
      unawaited(getIt<SyncedTaskRepository>().pullFromRemote());
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_mapAuthError(e.code));
      return false;
    } catch (_) {
      _setError('Something went wrong. Please try again.');
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    _setLoading();
    try {
      await _authRepository.signUpWithEmail(email.trim(), password);
      _setIdle();
      unawaited(getIt<SyncedTaskRepository>().pullFromRemote());
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_mapAuthError(e.code));
      return false;
    } catch (_) {
      _setError('Something went wrong. Please try again.');
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _setLoading();
    try {
      await _authRepository.signInWithGoogle();
      _setIdle();
      unawaited(getIt<SyncedTaskRepository>().pullFromRemote());
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'sign-in-cancelled') {
        _setIdle();
        return false;
      }
      _setError(_mapAuthError(e.code));
      return false;
    } catch (_) {
      _setError('Google sign-in failed. Please try again.');
      return false;
    }
  }

  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setIdle() {
    _status = AuthStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
    notifyListeners();
  }

  String _mapAuthError(String code) {
    switch (code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 8 characters.';
      case 'network-request-failed':
        return 'No connection. Check your network and try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
