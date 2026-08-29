import 'package:cafe_app/features/profile/data/firestore_payment_methods_repository.dart';
import 'package:cafe_app/features/profile/domain/payment_method.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('paymentMethodsFromFirestore', () {
    test('cards 배열을 PaymentMethod 목록으로 변환한다', () {
      final cards = paymentMethodsFromFirestore({
        'cards': [
          {'id': 'card-1', 'brand': '신한카드', 'last4': '1234', 'isDefault': true},
        ],
      });

      expect(cards, hasLength(1));
      expect(cards.first.brand, '신한카드');
      expect(cards.first.last4, '1234');
      expect(cards.first.isDefault, isTrue);
    });

    test('cards 필드가 없으면 빈 목록을 반환한다', () {
      expect(paymentMethodsFromFirestore({}), isEmpty);
    });
  });

  group('paymentMethodsToFirestore', () {
    test('round trip 시 데이터가 보존된다', () {
      const original = [
        PaymentMethod(
          id: 'card-1',
          brand: '신한카드',
          last4: '1234',
          isDefault: true,
        ),
        PaymentMethod(id: 'card-2', brand: '현대카드', last4: '5678'),
      ];

      final restored = paymentMethodsFromFirestore(
        paymentMethodsToFirestore(original),
      );

      expect(restored, original);
    });
  });
}
