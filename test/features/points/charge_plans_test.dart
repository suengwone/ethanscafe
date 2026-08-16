import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/points/domain/charge_plans.dart';

void main() {
  test('충전 상품은 기획된 4종의 금액과 보너스를 갖는다', () {
    expect(chargePlans, hasLength(4));
    expect(
      {for (final plan in chargePlans) plan.amount: plan.bonus},
      {10000: 0, 30000: 1000, 50000: 2500, 100000: 7000},
    );
  });

  test('총 충전 포인트는 결제 금액과 보너스의 합이다', () {
    expect(chargePlanOf(30000)!.totalPoints, 31000);
    expect(chargePlanOf(100000)!.totalPoints, 107000);
  });

  test('정의되지 않은 금액은 플랜을 찾지 못한다', () {
    expect(chargePlanOf(15000), isNull);
    expect(chargePlanOf(0), isNull);
  });

  test('충전 주문 ID는 charge 접두사와 허용 문자만 사용한다', () {
    final orderId = generateChargeOrderId();
    expect(RegExp(r'^charge-[A-Za-z0-9_-]{4,57}$').hasMatch(orderId), isTrue);
  });
}
