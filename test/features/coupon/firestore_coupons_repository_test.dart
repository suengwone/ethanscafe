import 'package:cafe_app/features/coupon/data/firestore_coupons_repository.dart';
import 'package:cafe_app/features/coupon/domain/coupon_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('couponToFirestore', () {
    test('쿠폰 필드를 Firestore 데이터로 변환한다', () {
      final expiresAt = DateTime(2026, 9, 12, 23, 59);
      final data = couponToFirestore(
        Coupon(
          id: 'welcome-user-1',
          title: '웰컴 3,000원 할인',
          description: '가입 축하 쿠폰',
          expiresAt: expiresAt,
          discountAmount: 3000,
        ),
      );

      expect(data['title'], '웰컴 3,000원 할인');
      expect(data['expiresAt'], Timestamp.fromDate(expiresAt));
      expect(data['isUsed'], isFalse);
      expect(data['discountAmount'], 3000);
      expect(data['discountRate'], 0);
      expect(data['isStackable'], isFalse);

      final restored = couponFromFirestore(
        'welcome-user-1',
        data,
      );
      expect(restored.expiresAt, expiresAt);
      expect(restored.discountAmount, 3000);
    });
  });

  group('couponFromFirestore', () {
    test('Timestamp 만료일을 DateTime으로 변환한다', () {
      final expiresAt = DateTime(2026, 8, 31, 23, 59);
      final coupon = couponFromFirestore('coupon-1', {
        'title': '웰컴 아메리카노 1잔',
        'description': '첫 가입 기념 무료 쿠폰',
        'expiresAt': Timestamp.fromDate(expiresAt),
        'isUsed': false,
      });

      expect(coupon.id, 'coupon-1');
      expect(coupon.title, '웰컴 아메리카노 1잔');
      expect(coupon.expiresAt, expiresAt);
      expect(coupon.isUsed, isFalse);
    });

    test('문자열 만료일도 파싱한다', () {
      final coupon = couponFromFirestore('coupon-2', {
        'title': '디저트 30% 할인',
        'description': '여름 시즌 한정',
        'expiresAt': '2026-08-15T23:59:00.000',
        'isUsed': true,
      });

      expect(coupon.expiresAt, DateTime(2026, 8, 15, 23, 59));
      expect(coupon.isUsed, isTrue);
    });

    test('isStackable 필드를 파싱하고 없으면 false다', () {
      final stackable = couponFromFirestore('coupon-3', {
        'title': '1,000원 중복 할인',
        'description': '다른 쿠폰과 함께 사용 가능',
        'expiresAt': '2026-12-31T23:59:00.000',
        'discountAmount': 1000,
        'isStackable': true,
      });
      final regular = couponFromFirestore('coupon-4', {
        'title': '일반 쿠폰',
        'description': '설명',
        'expiresAt': '2026-12-31T23:59:00.000',
      });

      expect(stackable.isStackable, isTrue);
      expect(stackable.discountAmount, 1000);
      expect(regular.isStackable, isFalse);
    });
  });
}
