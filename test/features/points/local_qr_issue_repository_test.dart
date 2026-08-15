import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/points/data/local_qr_issue_repository.dart';
import 'package:cafe_app/features/points/data/local_qr_points_repository.dart';

void main() {
  group('LocalQrIssueRepository', () {
    late LocalQrIssueRepository repository;

    setUp(() {
      repository = LocalQrIssueRepository();
    });

    test('스캔 적립이 인식할 수 있는 코드를 발급한다', () async {
      final token = await repository.issue(
        paymentAmount: 12000,
        storeName: '폭스트롯 성수점',
      );

      expect(token.paymentAmount, 12000);
      expect(token.storeName, '폭스트롯 성수점');

      final payload = parseQrPayCode(token.code);
      expect(payload, isNotNull);
      expect(payload!.paymentAmount, 12000);
      expect(payload.storeName, '폭스트롯 성수점');
    });

    test('만료 시각은 발급 시점 이후다', () async {
      final before = DateTime.now();
      final token = await repository.issue(
        paymentAmount: 5500,
        storeName: '폭스트롯',
      );

      expect(token.expiresAt.isAfter(before), isTrue);
    });

    test('결제 금액이 0 이하이면 ArgumentError를 던진다', () {
      expect(
        () => repository.issue(paymentAmount: 0, storeName: '폭스트롯'),
        throwsArgumentError,
      );
      expect(
        () => repository.issue(paymentAmount: -1000, storeName: '폭스트롯'),
        throwsArgumentError,
      );
    });

    test('매장명이 비어 있으면 ArgumentError를 던진다', () {
      expect(
        () => repository.issue(paymentAmount: 5500, storeName: '  '),
        throwsArgumentError,
      );
    });
  });
}
