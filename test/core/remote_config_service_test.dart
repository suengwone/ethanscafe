import 'package:cafe_app/core/services/remote_config_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('compareVersions', () {
    test('숫자 단위로 비교한다', () {
      expect(compareVersions('1.0.0', '1.0.1'), lessThan(0));
      expect(compareVersions('1.2.0', '1.10.0'), lessThan(0));
      expect(compareVersions('2.0.0', '1.9.9'), greaterThan(0));
      expect(compareVersions('1.0.0', '1.0.0'), 0);
    });

    test('자리 수가 달라도 비교한다', () {
      expect(compareVersions('1.0', '1.0.0'), 0);
      expect(compareVersions('1.0', '1.0.1'), lessThan(0));
      expect(compareVersions('1.1', '1.0.9'), greaterThan(0));
    });

    test('빌드 번호는 무시한다', () {
      expect(compareVersions('1.0.0+9', '1.0.0+1'), 0);
      expect(compareVersions('1.0.0+1', '1.0.1'), lessThan(0));
    });

    test('숫자가 아닌 조각은 0으로 본다', () {
      expect(compareVersions('1.x.0', '1.0.0'), 0);
      expect(compareVersions('', '0.0.0'), 0);
    });
  });

  group('isUpdateRequired', () {
    test('현재 버전이 최소 지원 버전보다 낮으면 업데이트가 필요하다', () {
      expect(
        isUpdateRequired(currentVersion: '1.0.0', minSupportedVersion: '1.1.0'),
        isTrue,
      );
    });

    test('같거나 높으면 업데이트가 필요 없다', () {
      expect(
        isUpdateRequired(currentVersion: '1.1.0', minSupportedVersion: '1.1.0'),
        isFalse,
      );
      expect(
        isUpdateRequired(currentVersion: '1.2.0', minSupportedVersion: '1.1.0'),
        isFalse,
      );
    });

    test('최소 지원 버전이 비어 있으면 강제하지 않는다', () {
      expect(
        isUpdateRequired(currentVersion: '1.0.0', minSupportedVersion: ''),
        isFalse,
      );
      expect(
        isUpdateRequired(currentVersion: '1.0.0', minSupportedVersion: '   '),
        isFalse,
      );
    });
  });

  group('RemoteAppConfig', () {
    test('공지는 켜져 있고 내용이 있을 때만 노출한다', () {
      expect(
        const RemoteAppConfig(
          noticeEnabled: true,
          noticeMessage: '점검 예정',
        ).hasNotice,
        isTrue,
      );
      expect(
        const RemoteAppConfig(
          noticeEnabled: false,
          noticeMessage: '점검 예정',
        ).hasNotice,
        isFalse,
      );
      expect(
        const RemoteAppConfig(
          noticeEnabled: true,
          noticeMessage: '   ',
        ).hasNotice,
        isFalse,
      );
    });

    test('스토어 주소가 비어 있으면 이동 버튼을 감춘다', () {
      expect(const RemoteAppConfig().hasStoreUrl, isFalse);
      expect(const RemoteAppConfig(storeUrl: '  ').hasStoreUrl, isFalse);
      expect(
        const RemoteAppConfig(storeUrl: 'https://example.com').hasStoreUrl,
        isTrue,
      );
    });
  });
}
