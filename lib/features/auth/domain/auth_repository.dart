import 'auth_models.dart';

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => message;
}

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();

  AppUser? get currentUser;

  Future<AppUser> signInWith(AuthProviderType provider);

  Future<void> signOut();

  Future<void> deleteAccount();
}
