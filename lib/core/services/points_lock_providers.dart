import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'points_lock_service.dart';

final pointsLockSettingsProvider = Provider<PointsLockSettings>(
  (ref) => PointsLockSettings(),
);

final deviceAuthenticatorProvider = Provider<DeviceAuthenticator>(
  (ref) => LocalDeviceAuthenticator(),
);

final pointsLockProvider = Provider<PointsLock>(
  (ref) => PointsLock(
    authenticator: ref.watch(deviceAuthenticatorProvider),
    settings: ref.watch(pointsLockSettingsProvider),
  ),
);

/// 설정 화면이 읽고 쓰는 스위치 값.
final pointsLockEnabledProvider =
    AsyncNotifierProvider<PointsLockController, bool>(PointsLockController.new);

class PointsLockController extends AsyncNotifier<bool> {
  @override
  Future<bool> build() => ref.watch(pointsLockSettingsProvider).isEnabled();

  Future<void> setEnabled(bool enabled) async {
    state = AsyncData(enabled);
    await ref.read(pointsLockSettingsProvider).setEnabled(enabled);
  }
}

/// 기기에 걸 잠금이 있는지. 없으면 설정 화면이 그 사실을 알려 준다.
final deviceLockAvailableProvider = FutureProvider<bool>(
  (ref) => ref.watch(deviceAuthenticatorProvider).isSupported(),
);
