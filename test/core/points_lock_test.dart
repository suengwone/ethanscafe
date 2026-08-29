import 'package:cafe_app/core/services/points_lock_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeAuthenticator implements DeviceAuthenticator {
  FakeAuthenticator({
    this.supported = true,
    this.result = DeviceAuthResult.passed,
  });

  bool supported;
  DeviceAuthResult result;
  int asked = 0;
  String? reason;

  @override
  Future<bool> isSupported() async => supported;

  @override
  Future<DeviceAuthResult> authenticate(String reason) async {
    asked += 1;
    this.reason = reason;
    return result;
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  PointsLock lockWith(FakeAuthenticator authenticator) =>
      PointsLock(authenticator: authenticator, settings: PointsLockSettings());

  test('잠금은 기본으로 켜져 있다', () async {
    expect(await PointsLockSettings().isEnabled(), isTrue);
  });

  test('본인 확인을 통과하면 주문이 이어진다', () async {
    final authenticator = FakeAuthenticator();

    final result = await lockWith(authenticator).confirm('확인이 필요해요');

    expect(result, DeviceAuthResult.passed);
    expect(passesPointsLock(result), isTrue);
    expect(authenticator.asked, 1);
    expect(authenticator.reason, '확인이 필요해요');
  });

  test('그만두면 주문을 막는다', () async {
    final authenticator = FakeAuthenticator(result: DeviceAuthResult.refused);

    final result = await lockWith(authenticator).confirm('reason');

    expect(passesPointsLock(result), isFalse);
  });

  test('기기가 잠겼으면 막고 그 사실을 알린다', () async {
    final authenticator = FakeAuthenticator(result: DeviceAuthResult.lockedOut);

    final result = await lockWith(authenticator).confirm('reason');

    expect(result, DeviceAuthResult.lockedOut);
    expect(passesPointsLock(result), isFalse);
  });

  test('걸 잠금이 없는 기기는 묻지 않고 통과시킨다', () async {
    // 막을 수단이 없는데 막으면 그 기기에서는 포인트를 영영 못 쓴다.
    final authenticator = FakeAuthenticator(supported: false);

    final result = await lockWith(authenticator).confirm('reason');

    expect(passesPointsLock(result), isTrue);
    expect(authenticator.asked, 0);
  });

  test('설정을 끄면 묻지 않는다', () async {
    await PointsLockSettings().setEnabled(false);
    final authenticator = FakeAuthenticator();

    final result = await lockWith(authenticator).confirm('reason');

    expect(passesPointsLock(result), isTrue);
    expect(authenticator.asked, 0);
  });

  test('껐다 켜면 다시 묻는다', () async {
    final settings = PointsLockSettings();
    await settings.setEnabled(false);
    await settings.setEnabled(true);
    final authenticator = FakeAuthenticator();

    await lockWith(authenticator).confirm('reason');

    expect(authenticator.asked, 1);
  });
  group('잠금 화면이 돌려준 실패 사유', () {
    test('걸어 둔 잠금이 없을 때만 통과로 친다', () {
      expect(
        resultForAuthError(LocalAuthExceptionCode.noCredentialsSet),
        DeviceAuthResult.unavailable,
      );
    });

    test('잠금 화면을 띄우지 못하면 막는다', () {
      // 우리 설정 문제다. 통과시키면 잠금을 켜 둔 사람이 지켜지는 줄 안다.
      expect(
        resultForAuthError(LocalAuthExceptionCode.uiUnavailable),
        DeviceAuthResult.refused,
      );
    });

    test('여러 번 틀려 잠긴 것은 따로 알린다', () {
      expect(
        resultForAuthError(LocalAuthExceptionCode.temporaryLockout),
        DeviceAuthResult.lockedOut,
      );
      expect(
        resultForAuthError(LocalAuthExceptionCode.biometricLockout),
        DeviceAuthResult.lockedOut,
      );
    });

    test('사용자가 그만두면 막는다', () {
      expect(
        resultForAuthError(LocalAuthExceptionCode.userCanceled),
        DeviceAuthResult.refused,
      );
    });

    test('생체 인증만 없는 기기도 막는다', () {
      // PIN이라도 걸려 있으면 그것으로 확인받을 수 있다.
      expect(
        resultForAuthError(LocalAuthExceptionCode.noBiometricsEnrolled),
        DeviceAuthResult.refused,
      );
      expect(
        resultForAuthError(LocalAuthExceptionCode.noBiometricHardware),
        DeviceAuthResult.refused,
      );
    });
  });
}
