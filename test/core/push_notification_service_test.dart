import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/core/services/push_notification_service.dart';

void main() {
  group('routeFromMessageData', () {
    test('유효한 경로면 그대로 반환한다', () {
      expect(routeFromMessageData({'route': '/notices'}), '/notices');
    });

    test('앞뒤 공백은 제거한다', () {
      expect(routeFromMessageData({'route': ' /points '}), '/points');
    });

    test('route 키가 없으면 null을 반환한다', () {
      expect(routeFromMessageData({'other': 'value'}), isNull);
    });

    test('문자열이 아니면 null을 반환한다', () {
      expect(routeFromMessageData({'route': 123}), isNull);
    });

    test('빈 문자열이면 null을 반환한다', () {
      expect(routeFromMessageData({'route': '  '}), isNull);
    });

    test('슬래시로 시작하지 않으면 null을 반환한다', () {
      expect(routeFromMessageData({'route': 'notices'}), isNull);
    });
  });
}
