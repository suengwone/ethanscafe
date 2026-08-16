import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/points/data/local_points_charge_repository.dart';
import 'package:cafe_app/features/points/data/local_points_repository.dart';
import 'package:cafe_app/features/points/domain/membership_tier.dart';
import 'package:cafe_app/features/points/domain/points_models.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('충전 결제 승인 시 보너스를 포함해 잔액을 늘린다', () async {
    final pointsRepository = LocalPointsRepository();
    final repository =
        LocalPointsChargeRepository(pointsRepository: pointsRepository);

    final approval = await repository.confirmPayment(
      paymentKey: 'pk-charge',
      orderId: 'charge-123456',
      amount: 30000,
    );

    expect(approval.amount, 30000);
    expect(approval.orderId, 'charge-123456');

    final data = await pointsRepository.load();
    expect(data.balance, 31000);
    final entry = data.history.first;
    expect(entry.type, PointHistoryType.charge);
    expect(entry.description, '선불권 충전');
    expect(entry.amount, 31000);
    expect(entry.paymentAmount, 30000);
    expect(entry.bonusAmount, 1000);
    expect(entry.paymentKey, 'pk-charge');
    expect(entry.isIncrease, isTrue);
  });

  test('보너스가 없는 충전은 bonusAmount를 기록하지 않는다', () async {
    final pointsRepository = LocalPointsRepository();
    final repository =
        LocalPointsChargeRepository(pointsRepository: pointsRepository);

    await repository.confirmPayment(
      paymentKey: 'pk',
      orderId: 'charge-123456',
      amount: 10000,
    );

    final data = await pointsRepository.load();
    expect(data.balance, 10000);
    expect(data.history.first.bonusAmount, isNull);
  });

  test('정의되지 않은 충전 금액은 거부한다', () async {
    final repository = LocalPointsChargeRepository();

    expect(
      () => repository.confirmPayment(
        paymentKey: 'pk',
        orderId: 'charge-123456',
        amount: 15000,
      ),
      throwsArgumentError,
    );
  });

  test('충전 금액은 멤버십 등급 누적 결제에 포함되지 않는다', () async {
    final pointsRepository = LocalPointsRepository();
    final repository =
        LocalPointsChargeRepository(pointsRepository: pointsRepository);

    await repository.confirmPayment(
      paymentKey: 'pk',
      orderId: 'charge-123456',
      amount: 100000,
    );

    final data = await pointsRepository.load();
    expect(data.cumulativePayment, 0);
    expect(data.tier, MembershipTier.green);
  });

  test('충전 포인트는 사용 차감에 그대로 쓸 수 있다', () async {
    final pointsRepository = LocalPointsRepository();
    final repository =
        LocalPointsChargeRepository(pointsRepository: pointsRepository);

    await repository.confirmPayment(
      paymentKey: 'pk',
      orderId: 'charge-123456',
      amount: 50000,
    );
    final data = await pointsRepository.usePoints(amount: 52500);

    expect(data.balance, 0);
  });
}
