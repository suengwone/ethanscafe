import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/stamp/domain/stamp_reward.dart';

void main() {
  group('applyStampEarn', () {
    test('리워드 없이 스탬프를 누적한다', () {
      final result = applyStampEarn(count: 3, cups: 2);
      expect(result.newCount, 5);
      expect(result.rewards, 0);
    });

    test('10개를 채우면 리워드 1개를 발급하고 카운트를 초기화한다', () {
      final result = applyStampEarn(count: 9, cups: 1);
      expect(result.newCount, 0);
      expect(result.rewards, 1);
    });

    test('10개를 넘기면 나머지를 다음 카드로 이월한다', () {
      final result = applyStampEarn(count: 8, cups: 5);
      expect(result.newCount, 3);
      expect(result.rewards, 1);
    });

    test('한 번에 여러 리워드를 발급할 수 있다', () {
      final result = applyStampEarn(count: 5, cups: 25);
      expect(result.newCount, 0);
      expect(result.rewards, 3);
    });

    test('잔 수가 0 이하이면 예외를 던진다', () {
      expect(() => applyStampEarn(count: 0, cups: 0), throwsArgumentError);
      expect(() => applyStampEarn(count: 0, cups: -1), throwsArgumentError);
    });

    test('카운트가 음수이면 예외를 던진다', () {
      expect(() => applyStampEarn(count: -1, cups: 1), throwsArgumentError);
    });
  });

  group('buildStampRewardCoupon', () {
    test('무료 음료 쿠폰을 만든다', () {
      final now = DateTime(2026, 8, 15, 10, 30);
      final coupon = buildStampRewardCoupon(uid: 'user-1', now: now);

      expect(coupon.id, startsWith('stamp-reward-user-1-'));
      expect(coupon.title, '스탬프 완성 음료 1잔 무료');
      expect(coupon.isUsed, isFalse);
      expect(coupon.isOrderDiscount, isFalse);
      expect(
        coupon.expiresAt,
        DateTime(2026, 8, 15 + stampRewardValidDays - 1, 23, 59),
      );
      expect(coupon.isUsable(now), isTrue);
    });

    test('같은 시각의 여러 리워드는 서로 다른 id를 가진다', () {
      final now = DateTime(2026, 8, 15);
      final first = buildStampRewardCoupon(uid: 'user-1', now: now, index: 0);
      final second = buildStampRewardCoupon(uid: 'user-1', now: now, index: 1);
      expect(first.id, isNot(second.id));
    });
  });
}
