import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/auth/data/unavailable_auth_repository.dart';
import 'package:cafe_app/features/auth/domain/auth_models.dart';
import 'package:cafe_app/features/auth/domain/auth_repository.dart';
import 'package:cafe_app/features/auth/presentation/auth_providers.dart';

import 'fake_auth_repository.dart';

void main() {
  ProviderContainer createContainer(AuthRepository repository) {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('로그인 성공 시 true를 반환하고 에러가 없다', () async {
    final repository = FakeAuthRepository();
    final container = createContainer(repository);

    final success = await container
        .read(authControllerProvider.notifier)
        .signInWith(AuthProviderType.google);

    expect(success, isTrue);
    expect(container.read(authControllerProvider).hasError, isFalse);
    expect(repository.user, isNotNull);
    expect(repository.user!.providerId, 'google');
  });

  test('네이버 로그인 성공 시 providerId가 naver로 설정된다', () async {
    final repository = FakeAuthRepository();
    final container = createContainer(repository);

    final success = await container
        .read(authControllerProvider.notifier)
        .signInWith(AuthProviderType.naver);

    expect(success, isTrue);
    expect(repository.user, isNotNull);
    expect(repository.user!.providerId, 'naver');
  });

  test('로그인 실패 시 false를 반환하고 에러 상태가 된다', () async {
    final repository =
        FakeAuthRepository(failure: const AuthException('로그인 실패'));
    final container = createContainer(repository);

    final success = await container
        .read(authControllerProvider.notifier)
        .signInWith(AuthProviderType.kakao);

    expect(success, isFalse);
    final state = container.read(authControllerProvider);
    expect(state.hasError, isTrue);
    expect(state.error.toString(), '로그인 실패');
  });

  test('로그아웃하면 사용자 정보가 제거된다', () async {
    final repository = FakeAuthRepository(
      user: const AppUser(uid: 'u1', displayName: '홍길동'),
    );
    final container = createContainer(repository);

    await container.read(authControllerProvider.notifier).signOut();

    expect(repository.user, isNull);
    expect(container.read(authControllerProvider).hasError, isFalse);
  });

  test('계정 삭제 성공 시 true를 반환하고 사용자 정보가 제거된다', () async {
    final repository = FakeAuthRepository(
      user: const AppUser(uid: 'u1', displayName: '홍길동'),
    );
    final container = createContainer(repository);

    final success =
        await container.read(authControllerProvider.notifier).deleteAccount();

    expect(success, isTrue);
    expect(repository.user, isNull);
    expect(container.read(authControllerProvider).hasError, isFalse);
  });

  test('계정 삭제 실패 시 false를 반환하고 에러 상태가 된다', () async {
    final repository = FakeAuthRepository(
      user: const AppUser(uid: 'u1', displayName: '홍길동'),
      failure: const AuthException('보안을 위해 다시 로그인한 뒤 탈퇴를 진행해주세요.'),
    );
    final container = createContainer(repository);

    final success =
        await container.read(authControllerProvider.notifier).deleteAccount();

    expect(success, isFalse);
    final state = container.read(authControllerProvider);
    expect(state.hasError, isTrue);
    expect(state.error.toString(), '보안을 위해 다시 로그인한 뒤 탈퇴를 진행해주세요.');
  });

  test('authStateProvider는 저장소의 사용자 상태를 노출한다', () async {
    final repository = FakeAuthRepository(
      user: const AppUser(uid: 'u1', displayName: '홍길동'),
    );
    final container = createContainer(repository);

    final subscription =
        container.listen(authStateProvider.future, (previous, next) {});
    final user = await subscription.read();

    expect(user, isNotNull);
    expect(user!.displayLabel, '홍길동');
  });

  test('Firebase 미구성 환경에서는 로그인 시도 시 안내 에러를 던진다', () async {
    const repository = UnavailableAuthRepository();
    final container = createContainer(repository);

    final success = await container
        .read(authControllerProvider.notifier)
        .signInWith(AuthProviderType.apple);

    expect(success, isFalse);
    expect(
      container.read(authControllerProvider).error,
      isA<AuthException>(),
    );
  });
}
