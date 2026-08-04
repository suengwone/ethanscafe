import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/points/data/functions_qr_points_repository.dart';

void main() {
  group('qrEarnResultFromCallable', () {
    test('callable 응답 맵을 QrEarnResult로 변환한다', () {
      final result = qrEarnResultFromCallable({
        'storeName': '폭스트롯 성수점',
        'paymentAmount': 12000,
        'earned': 1200,
        'balance': 3450,
      });

      expect(result.storeName, '폭스트롯 성수점');
      expect(result.paymentAmount, 12000);
      expect(result.earned, 1200);
      expect(result.balance, 3450);
    });

    test('누락된 필드는 기본값으로 채운다', () {
      final result = qrEarnResultFromCallable({});

      expect(result.storeName, '매장 결제');
      expect(result.paymentAmount, 0);
      expect(result.earned, 0);
      expect(result.balance, 0);
    });
  });
}
