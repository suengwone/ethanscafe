import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/payment/data/local_payments_repository.dart';
import 'package:cafe_app/features/payment/domain/payment_models.dart';

void main() {
  test('로컬 결제 승인은 요청 그대로 승인 정보를 반환한다', () async {
    final repository = LocalPaymentsRepository();

    final approval = await repository.confirmPayment(
      paymentKey: 'local-key',
      orderId: 'bean-123456',
      amount: 59000,
    );

    expect(
      approval,
      const PaymentApproval(
        paymentKey: 'local-key',
        orderId: 'bean-123456',
        amount: 59000,
        method: LocalPaymentsRepository.simulatedMethod,
      ),
    );
  });

  test('0원 이하 금액은 승인하지 않는다', () {
    final repository = LocalPaymentsRepository();

    expect(
      () => repository.confirmPayment(
        paymentKey: 'local-key',
        orderId: 'bean-123456',
        amount: 0,
      ),
      throwsArgumentError,
    );
  });

  test('결제 주문 ID는 토스 orderId 규칙을 만족한다', () {
    final orderId = generatePaymentOrderId();

    expect(RegExp(r'^[A-Za-z0-9_-]{6,64}$').hasMatch(orderId), isTrue);
  });
}
