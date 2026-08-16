import 'dart:math';

class ChargePlan {
  const ChargePlan({required this.amount, required this.bonus});

  final int amount;
  final int bonus;

  int get totalPoints => amount + bonus;
}

const chargeDescription = '선불권 충전';

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
