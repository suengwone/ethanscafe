import 'package:cafe_app/features/auth/domain/auth_models.dart';
import 'package:cafe_app/features/auth/domain/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  AppUser? user;
  final AuthException? failure;
  final bool admin;

  FakeAuthRepository({this.user, this.failure, this.admin = false});

  @override
  Stream<AppUser?> authStateChanges() => Stream<AppUser?>.value(user);

  @override
  AppUser? get currentUser => user;

  @override
  Future<bool> isAdmin() async => admin;

  @override
  Future<AppUser> signInWith(AuthProviderType provider) async {
    if (failure != null) {
      throw failure!;
    }
    user = AppUser(
      uid: 'fake-uid',
      displayName: '테스트 사용자',
      email: 'test@example.com',
      providerId: provider.name,
    );
    return user!;
  }

  @override
  Future<void> signOut() async {
    user = null;
  }

  @override
  Future<void> deleteAccount() async {
    if (failure != null) {
      throw failure!;
    }
    user = null;
  }
}
