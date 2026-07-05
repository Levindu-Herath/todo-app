import 'auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  String? _userId;

  @override
  String? get currentUserId => _userId;

  @override
  Future<bool> login({required String email, required String password}) async {
    _userId = email;
    return true;
  }

  @override
  Future<bool> register({required String email, required String password}) async {
    _userId = email;
    return true;
  }

  @override
  Future<void> logout() async {
    _userId = null;
  }
}
