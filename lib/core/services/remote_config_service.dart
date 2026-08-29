import 'package:firebase_remote_config/firebase_remote_config.dart';

/// '1.2.3' 또는 '1.2.3+4' 형태의 버전을 숫자 단위로 비교한다.
/// a가 낮으면 음수, 같으면 0, 높으면 양수를 반환한다.
int compareVersions(String a, String b) {
  final left = _versionParts(a);
  final right = _versionParts(b);
  final length = left.length > right.length ? left.length : right.length;
  for (var i = 0; i < length; i++) {
    final x = i < left.length ? left[i] : 0;
    final y = i < right.length ? right[i] : 0;
    if (x != y) {
      return x < y ? -1 : 1;
    }
  }
  return 0;
}

List<int> _versionParts(String version) {
  return version
      .split('+')
      .first
      .trim()
      .split('.')
      .map((part) => int.tryParse(part.trim()) ?? 0)
      .toList();
}

/// 최소 지원 버전이 비어 있으면 업데이트를 강제하지 않는다.
bool isUpdateRequired({
  required String currentVersion,
  required String minSupportedVersion,
}) {
  if (minSupportedVersion.trim().isEmpty) {
    return false;
  }
  return compareVersions(currentVersion, minSupportedVersion) < 0;
}

class RemoteAppConfig {
  const RemoteAppConfig({
    this.minSupportedVersion = '',
    this.noticeEnabled = false,
    this.noticeMessage = '',
    this.storeUrl = '',
  });

  final String minSupportedVersion;
  final bool noticeEnabled;
  final String noticeMessage;

  /// 스토어 주소는 플랫폼마다 달라 원격 값으로 받는다. 비어 있으면 이동 버튼을 감춘다.
  final String storeUrl;

  bool get hasNotice => noticeEnabled && noticeMessage.trim().isNotEmpty;

  bool get hasStoreUrl => storeUrl.trim().isNotEmpty;

  @override
  bool operator ==(Object other) =>
      other is RemoteAppConfig &&
      other.minSupportedVersion == minSupportedVersion &&
      other.noticeEnabled == noticeEnabled &&
      other.noticeMessage == noticeMessage &&
      other.storeUrl == storeUrl;

  @override
  int get hashCode =>
      Object.hash(minSupportedVersion, noticeEnabled, noticeMessage, storeUrl);
}

class RemoteConfigService {
  RemoteConfigService({FirebaseRemoteConfig? remoteConfig})
    : _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance;

  final FirebaseRemoteConfig _remoteConfig;

  static const minSupportedVersionKey = 'min_supported_version';
  static const noticeEnabledKey = 'notice_enabled';
  static const noticeMessageKey = 'notice_message';
  static const storeUrlKey = 'store_url';

  static const defaults = <String, dynamic>{
    minSupportedVersionKey: '',
    noticeEnabledKey: false,
    noticeMessageKey: '',
    storeUrlKey: '',
  };

  /// 원격 값을 받아오되, 실패하면 마지막으로 활성화된 값(없으면 기본값)을 쓴다.
  Future<RemoteAppConfig> load() async {
    await _remoteConfig.setDefaults(defaults);
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    try {
      await _remoteConfig.fetchAndActivate();
    } catch (_) {
      // 네트워크 실패 시 캐시된 값으로 계속 진행한다.
    }
    return RemoteAppConfig(
      minSupportedVersion: _remoteConfig.getString(minSupportedVersionKey),
      noticeEnabled: _remoteConfig.getBool(noticeEnabledKey),
      noticeMessage: _remoteConfig.getString(noticeMessageKey),
      storeUrl: _remoteConfig.getString(storeUrlKey),
    );
  }
}
