import 'package:cafe_app/features/profile/data/firestore_delivery_addresses_repository.dart';
import 'package:cafe_app/features/profile/domain/delivery_address.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('deliveryAddressesFromFirestore', () {
    test('addresses 배열을 DeliveryAddress 목록으로 변환한다', () {
      final addresses = deliveryAddressesFromFirestore({
        'addresses': [
          {
            'id': 'addr-1',
            'label': '집',
            'recipient': '홍길동',
            'phone': '010-1234-5678',
            'address1': '서울 성동구 연무장길 47',
            'address2': '101동 1001호',
            'isDefault': true,
          },
        ],
      });

      expect(addresses, hasLength(1));
      expect(addresses.first.label, '집');
      expect(addresses.first.address2, '101동 1001호');
      expect(addresses.first.isDefault, isTrue);
    });

    test('addresses 필드가 없으면 빈 목록을 반환한다', () {
      expect(deliveryAddressesFromFirestore({}), isEmpty);
    });
  });

  group('deliveryAddressesToFirestore', () {
    test('round trip 시 데이터가 보존된다', () {
      const original = [
        DeliveryAddress(
          id: 'addr-1',
          label: '집',
          recipient: '홍길동',
          phone: '010-1234-5678',
          address1: '서울 성동구 연무장길 47',
          address2: '101동 1001호',
          isDefault: true,
        ),
        DeliveryAddress(
          id: 'addr-2',
          label: '회사',
          recipient: '홍길동',
          phone: '010-1234-5678',
          address1: '서울 강남구 테헤란로 1',
        ),
      ];

      final restored = deliveryAddressesFromFirestore(
        deliveryAddressesToFirestore(original),
      );

      expect(restored, original);
    });
  });
}
