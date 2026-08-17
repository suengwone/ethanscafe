import 'package:cafe_app/core/services/connectivity_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isOnlineFromResults', () {
    test('연결 수단이 없으면 오프라인이다', () {
      expect(isOnlineFromResults(const []), isFalse);
      expect(isOnlineFromResults(const [ConnectivityResult.none]), isFalse);
    });

    test('wifi나 모바일 연결이 있으면 온라인이다', () {
      expect(isOnlineFromResults(const [ConnectivityResult.wifi]), isTrue);
      expect(isOnlineFromResults(const [ConnectivityResult.mobile]), isTrue);
      expect(isOnlineFromResults(const [ConnectivityResult.ethernet]), isTrue);
    });

    test('none과 실제 연결이 섞여 있으면 온라인이다', () {
      expect(
        isOnlineFromResults(const [
          ConnectivityResult.none,
          ConnectivityResult.wifi,
        ]),
        isTrue,
      );
    });
  });
}
