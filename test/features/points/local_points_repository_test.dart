import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/points/data/local_points_repository.dart';
import 'package:cafe_app/features/points/domain/points_models.dart';

void main() {
  late LocalPointsRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = LocalPointsRepository();
  });

  test('최초 로드 시 기본 포인트 데이터를 생성한다', () async {
    final data = await repository.load();

    expect(data.membershipId, startsWith('MEMBER-'));
    expect(data.balance, 0);
    expect(data.history, isEmpty);
  });

  test('기존 스탬프 데이터가 있으면 멤버십 ID를 이어받는다', () async {
    SharedPreferences.setMockInitialValues({
      'membership_data': jsonEncode({
        'membershipId': 'MEMBER-00001234',
        'stampCount': 7,
      }),
    });

    final data = await LocalPointsRepository().load();
    final prefs = await SharedPreferences.getInstance();

    expect(data.membershipId, 'MEMBER-00001234');
    expect(prefs.getString('membership_data'), isNull);
  });

  test('결제 시 결제 금액의 10%가 적립된다', () async {
    final data = await repository.recordPayment(
      paymentAmount: 12000,
      description: '아메리카노 외 2건',
    );

    expect(data.balance, 1200);
    expect(data.history, hasLength(1));
    expect(data.history.first.type, PointHistoryType.earn);
    expect(data.history.first.amount, 1200);
    expect(data.history.first.paymentAmount, 12000);
    expect(data.history.first.description, '아메리카노 외 2건');
  });

  test('적립 포인트는 원 단위 미만을 버린다', () async {
    final data = await repository.recordPayment(paymentAmount: 999);

    expect(data.balance, 99);
  });

  test('0 이하 결제 금액은 적립할 수 없다', () async {
    expect(
      () => repository.recordPayment(paymentAmount: 0),
      throwsArgumentError,
    );
    expect(
      () => repository.recordPayment(paymentAmount: -1000),
      throwsArgumentError,
    );
  });

  test('포인트 사용 시 잔액이 차감되고 히스토리가 남는다', () async {
    await repository.recordPayment(paymentAmount: 10000);

    final data = await repository.usePoints(amount: 700);

    expect(data.balance, 300);
    expect(data.history, hasLength(2));
    expect(data.history.first.type, PointHistoryType.use);
    expect(data.history.first.amount, -700);
    expect(data.history.first.paymentAmount, isNull);
  });

  test('잔액보다 많은 포인트는 사용할 수 없다', () async {
    await repository.recordPayment(paymentAmount: 10000);

    expect(() => repository.usePoints(amount: 1001), throwsStateError);
  });

  test('0 이하 포인트는 사용할 수 없다', () async {
    await repository.recordPayment(paymentAmount: 10000);

    expect(() => repository.usePoints(amount: 0), throwsArgumentError);
    expect(() => repository.usePoints(amount: -100), throwsArgumentError);
  });

  test('데이터가 로컬에 영속화된다', () async {
    await repository.recordPayment(paymentAmount: 5500);

    final reloaded = await LocalPointsRepository().load();

    expect(reloaded.balance, 550);
    expect(reloaded.history, hasLength(1));
  });
}
