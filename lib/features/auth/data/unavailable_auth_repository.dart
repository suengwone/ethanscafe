import '../domain/auth_models.dart';
import '../domain/auth_repository.dart';

class UnavailableAuthRepository implements AuthRepository {
  const UnavailableAuthRepository();

  @override
  Stream<AppUser?> authStateChanges() => Stream<AppUser?>.value(null);

  @override
  AppUser? get currentUser => null;

  @override
  Future<AppUser> signInWith(AuthProviderType provider) {
    throw const AuthException('로그인 기능이 아직 준비되지 않았습니다. Firebase 설정 후 이용해주세요.');
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<void> deleteAccount() {
    throw const AuthException('계정 삭제 기능이 아직 준비되지 않았습니다. Firebase 설정 후 이용해주세요.');
  }
}
