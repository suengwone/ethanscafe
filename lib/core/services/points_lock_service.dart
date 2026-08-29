import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 기기 잠금을 물어보는 쪽. 테스트는 이 자리를 갈아 끼운다.
abstract class DeviceAuthenticator {
  /// 이 기기에 확인할 잠금(생체 인증이든 PIN이든)이 있는지.
  Future<bool> isSupported();

  Future<DeviceAuthResult> authenticate(String reason);
}

enum DeviceAuthResult {
  /// 본인이 맞다고 확인됐다.
  passed,

  /// 사용자가 그만뒀거나 확인에 실패했다.
  refused,

  /// 여러 번 틀려 기기가 잠갔다. 기기 잠금을 풀고 와야 한다.
  lockedOut,

  /// 확인할 잠금이 없다. 막을 수단이 없으므로 통과로 친다.
  unavailable,
}

class LocalDeviceAuthenticator implements DeviceAuthenticator {
  LocalDeviceAuthenticator({LocalAuthentication? auth})
    : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  @override
  Future<bool> isSupported() async {
    // 웹에는 붙일 잠금이 없다.
    if (kIsWeb) {
      return false;
    }
    try {
      return await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<DeviceAuthResult> authenticate(String reason) async {
    try {
      final passed = await _auth.authenticate(localizedReason: reason);
      return passed ? DeviceAuthResult.passed : DeviceAuthResult.refused;
    } on LocalAuthException catch (error) {
      return resultForAuthError(error.code);
    } catch (_) {
      return DeviceAuthResult.refused;
    }
  }
}

/// 잠금 화면이 돌려준 실패 사유를 통과/막힘으로 옮긴다.
///
/// 통과로 치는 것은 **기기에 걸 잠금이 아예 없을 때 하나뿐**이다. 그 기기에서
/// 막아 버리면 포인트를 영영 쓰지 못한다. 나머지는 전부 막는다. 특히 잠금 화면을
/// 띄우지 못한 경우(`uiUnavailable`)는 기기 사정이 아니라 우리 설정 문제이고,
/// 통과로 쳐 주면 잠금을 켜 둔 사람이 지켜지고 있다고 착각한다.
DeviceAuthResult resultForAuthError(LocalAuthExceptionCode code) {
  return switch (code) {
    LocalAuthExceptionCode.noCredentialsSet => DeviceAuthResult.unavailable,
    LocalAuthExceptionCode.temporaryLockout ||
    LocalAuthExceptionCode.biometricLockout => DeviceAuthResult.lockedOut,
    _ => DeviceAuthResult.refused,
  };
}

/// 잠금을 켤지는 기기마다 다르다. 계정이 아니라 이 기기에만 저장한다.
class PointsLockSettings {
  static const storageKey = 'points_lock_enabled';

  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(storageKey) ?? true;
  }

  Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(storageKey, enabled);
  }
}

/// 포인트를 쓰는 순간에만 본인 확인을 요구한다.
///
/// 포인트는 충전해 둔 현금성 잔액이라 폰을 잃어버리면 그 자리에서 소진된다.
/// 카드 결제는 토스 결제창이 이미 본인 확인을 태우므로 여기서 또 묻지 않는다.
class PointsLock {
  PointsLock({required this.authenticator, required this.settings});

  final DeviceAuthenticator authenticator;
  final PointsLockSettings settings;

  Future<DeviceAuthResult> confirm(String reason) async {
    if (!await settings.isEnabled()) {
      return DeviceAuthResult.unavailable;
    }
    if (!await authenticator.isSupported()) {
      return DeviceAuthResult.unavailable;
    }
    return authenticator.authenticate(reason);
  }
}

/// 주문을 계속해도 되는 결과인지.
bool passesPointsLock(DeviceAuthResult result) =>
    result == DeviceAuthResult.passed || result == DeviceAuthResult.unavailable;
