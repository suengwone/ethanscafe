import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'remote_config_service.dart';

bool get _isRemoteConfigSupported {
  try {
    return Firebase.apps.isNotEmpty;
  } catch (_) {
    return false;
  }
}

final remoteConfigServiceProvider = Provider<RemoteConfigService?>((ref) {
  if (!_isRemoteConfigSupported) {
    return null;
  }
  return RemoteConfigService();
});

final appVersionProvider = FutureProvider<String>((ref) async {
  final info = await PackageInfo.fromPlatform();
  return info.version;
});

final remoteAppConfigProvider = FutureProvider<RemoteAppConfig>((ref) async {
  final service = ref.watch(remoteConfigServiceProvider);
  if (service == null) {
    return const RemoteAppConfig();
  }
  try {
    return await service.load();
  } catch (e) {
    debugPrint('Remote config load failed: $e');
    return const RemoteAppConfig();
  }
});

/// 현재 설치된 버전이 원격 최소 지원 버전보다 낮은지 판단한다.
/// 버전이나 원격 설정을 아직 모르면 false를 반환해 화면을 막지 않는다.
final isUpdateRequiredProvider = Provider<bool>((ref) {
  final version = ref.watch(appVersionProvider).value;
  final config = ref.watch(remoteAppConfigProvider).value;
  if (version == null || config == null) {
    return false;
  }
  return isUpdateRequired(
    currentVersion: version,
    minSupportedVersion: config.minSupportedVersion,
  );
});
