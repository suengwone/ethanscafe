import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/points/data/local_points_repository.dart';
import 'package:cafe_app/features/points/data/local_qr_points_repository.dart';

void main() {
  group('parseQrPayCode', () {
    test('FOXTROT-PAY 형식 코드를 파싱한다', () {
      final payload = parseQrPayCode('FOXTROT-PAY:5500:폭스트롯 성수점');

      expect(payload, isNotNull);
      expect(payload!.paymentAmount, 5500);
      expect(payload.storeName, '폭스트롯 성수점');
    });

    test('매장명에 콜론이 있어도 파싱한다', () {
      final payload = parseQrPayCode('FOXTROT-PAY:12000:폭스트롯: 본점');

      expect(payload!.paymentAmount, 12000);
      expect(payload.storeName, '폭스트롯: 본점');
    });

    test('접두어가 다르면 null을 반환한다', () {
      expect(parseQrPayCode('MEMBER-12345678'), isNull);
      expect(parseQrPayCode('https://example.com'), isNull);
    });

    test('금액이 잘못되면 null을 반환한다', () {
      expect(parseQrPayCode('FOXTROT-PAY:abc:매장'), isNull);
      expect(parseQrPayCode('FOXTROT-PAY:0:매장'), isNull);
      expect(parseQrPayCode('FOXTROT-PAY:-100:매장'), isNull);
    });

    test('매장명이 비어 있으면 null을 반환한다', () {
      expect(parseQrPayCode('FOXTROT-PAY:5500:'), isNull);
      expect(parseQrPayCode('FOXTROT-PAY:5500'), isNull);
    });
  });

  group('LocalQrPointsRepository', () {
    late LocalQrPointsRepository repository;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      repository = LocalQrPointsRepository(LocalPointsRepository());
    });

    test('유효한 코드 스캔 시 결제 금액의 10%를 적립한다', () async {
      final result =
          await repository.earnFromQr('FOXTROT-PAY:12000:폭스트롯 성수점');

      expect(result.storeName, '폭스트롯 성수점');
      expect(result.paymentAmount, 12000);
      expect(result.earned, 1200);
      expect(result.balance, 1200);
    });

    test('적립 내역이 히스토리에 기록된다', () async {
      await repository.earnFromQr('FOXTROT-PAY:5500:폭스트롯 성수점');

      final data = await LocalPointsRepository().load();
      expect(data.history, hasLength(1));
      expect(data.history.first.description, '폭스트롯 성수점');
      expect(data.history.first.amount, 550);
      expect(data.history.first.paymentAmount, 5500);
    });

    test('지원하지 않는 코드는 FormatException을 던진다', () async {
      expect(
        () => repository.earnFromQr('unknown-code'),
        throwsFormatException,
      );
    });
  });
}
