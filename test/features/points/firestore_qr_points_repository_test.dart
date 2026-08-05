import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/points/data/firestore_qr_points_repository.dart';

void main() {
  final now = DateTime(2026, 8, 5, 12);

  group('validateQrToken', () {
    test('유효한 토큰이면 매장명과 결제 금액을 반환한다', () {
      final token = validateQrToken(
        {
          'storeName': '폭스트롯 성수점',
          'paymentAmount': 12000,
          'used': false,
        },
        now: now,
      );

      expect(token.storeName, '폭스트롯 성수점');
      expect(token.paymentAmount, 12000);
    });

    test('매장명이 없으면 기본값을 사용한다', () {
      final token = validateQrToken(
        {'paymentAmount': 5500},
        now: now,
      );

      expect(token.storeName, '매장 결제');
      expect(token.paymentAmount, 5500);
    });

    test('등록되지 않은 토큰이면 FormatException을 던진다', () {
      expect(
        () => validateQrToken(null, now: now),
        throwsA(isA<FormatException>().having(
          (e) => e.message,
          'message',
          '등록되지 않은 QR 코드입니다.',
        )),
      );
    });

    test('이미 사용된 토큰이면 StateError를 던진다', () {
      expect(
        () => validateQrToken(
          {'paymentAmount': 5500, 'used': true},
          now: now,
        ),
        throwsA(isA<StateError>().having(
          (e) => e.message,
          'message',
          '이미 사용된 QR 코드입니다.',
        )),
      );
    });

    test('만료된 토큰이면 StateError를 던진다', () {
      expect(
        () => validateQrToken(
          {
            'paymentAmount': 5500,
            'expiresAt': Timestamp.fromDate(now.subtract(
              const Duration(minutes: 1),
            )),
          },
          now: now,
        ),
        throwsA(isA<StateError>().having(
          (e) => e.message,
          'message',
          '만료된 QR 코드입니다.',
        )),
      );
    });

    test('만료 전 토큰은 통과한다', () {
      final token = validateQrToken(
        {
          'paymentAmount': 5500,
          'expiresAt': Timestamp.fromDate(now.add(const Duration(minutes: 5))),
        },
        now: now,
      );

      expect(token.paymentAmount, 5500);
    });

    test('결제 금액이 없거나 0 이하면 StateError를 던진다', () {
      expect(
        () => validateQrToken({'storeName': '폭스트롯 성수점'}, now: now),
        throwsA(isA<StateError>().having(
          (e) => e.message,
          'message',
          '결제 금액이 올바르지 않습니다.',
        )),
      );
    });
  });
}
