import 'dart:math';

class ChargePlan {
  const ChargePlan({required this.amount, required this.bonus});

  final int amount;
  final int bonus;

  int get totalPoints => amount + bonus;
}

const chargeDescription = '선불권 충전';

/// 매장 결제 적립 내역에 남는 설명. 포인트 히스토리에 그대로 저장되므로
/// 번역하면 이미 쌓인 내역과 새 내역이 서로 다른 말을 하게 된다.
const pointsPaymentDescription = '포인트 결제';

const chargePlans = [
  ChargePlan(amount: 10000, bonus: 0),
  ChargePlan(amount: 30000, bonus: 1000),
  ChargePlan(amount: 50000, bonus: 2500),
  ChargePlan(amount: 100000, bonus: 7000),
];

ChargePlan? chargePlanOf(int amount) {
  for (final plan in chargePlans) {
    if (plan.amount == amount) {
      return plan;
    }
  }
  return null;
}

String generateChargeOrderId() =>
    'charge-${DateTime.now().millisecondsSinceEpoch}-'
    '${Random().nextInt(0xFFFF).toRadixString(16).padLeft(4, '0')}';
