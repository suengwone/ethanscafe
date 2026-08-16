import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/points/domain/membership_tier.dart';
import 'package:cafe_app/features/points/domain/points_models.dart';

PointHistoryEntry _earnEntry(int paymentAmount) => PointHistoryEntry(
      id: 'earn-$paymentAmount',
      type: PointHistoryType.earn,
      description: '매장 결제',
      amount: paymentAmount ~/ 10,
      paymentAmount: paymentAmount,
      createdAt: DateTime(2026, 8, 1),
    );

void main() {
  group('membershipTierForSpending', () {
    test('누적 결제 30만원 미만은 그린 등급이다', () {
      expect(membershipTierForSpending(0), MembershipTier.green);
      expect(membershipTierForSpending(299999), MembershipTier.green);
    });

    test('누적 결제 30만원 이상은 골드 등급이다', () {
      expect(membershipTierForSpending(300000), MembershipTier.gold);
      expect(membershipTierForSpending(999999), MembershipTier.gold);
    });

    test('누적 결제 100만원 이상은 플래티넘 등급이다', () {
      expect(membershipTierForSpending(1000000), MembershipTier.platinum);
      expect(membershipTierForSpending(5000000), MembershipTier.platinum);
    });
  });

  group('cumulativeSpending', () {
    test('적립 내역의 결제 금액만 합산한다', () {
      final history = [
        _earnEntry(12000),
        PointHistoryEntry(
          id: 'use-1',
          type: PointHistoryType.use,
          description: '포인트 결제',
          amount: -500,
          createdAt: DateTime(2026, 8, 2),
        ),
        PointHistoryEntry(
          id: 'refund-1',
          type: PointHistoryType.earn,
          description: '주문 취소 포인트 환급',
          amount: 500,
          createdAt: DateTime(2026, 8, 3),
        ),
        _earnEntry(5500),
      ];

      expect(cumulativeSpending(history), 17500);
    });

    test('내역이 없으면 0이다', () {
      expect(cumulativeSpending(const []), 0);
    });
  });

  group('MembershipTier.earnPoints', () {
    test('그린 등급은 10% 적립한다', () {
      expect(MembershipTier.green.earnPoints(12000), 1200);
      expect(MembershipTier.green.earnPoints(999), 99);
    });

    test('골드 등급은 12% 적립한다', () {
      expect(MembershipTier.gold.earnPoints(10000), 1200);
      expect(MembershipTier.gold.earnPoints(999), 119);
    });

    test('플래티넘 등급은 15% 적립한다', () {
      expect(MembershipTier.platinum.earnPoints(10000), 1500);
    });
  });

  group('next', () {
    test('그린 다음은 골드, 골드 다음은 플래티넘이다', () {
      expect(MembershipTier.green.next, MembershipTier.gold);
      expect(MembershipTier.gold.next, MembershipTier.platinum);
    });

    test('플래티넘은 다음 등급이 없다', () {
      expect(MembershipTier.platinum.next, isNull);
    });
  });

  group('PointsDataMembershipTier', () {
    test('포인트 데이터에서 등급과 다음 등급까지 남은 금액을 계산한다', () {
      final data = PointsData(
        membershipId: 'MEMBER-00000001',
        balance: 1000,
        history: [_earnEntry(250000), _earnEntry(100000)],
      );

      expect(data.cumulativePayment, 350000);
      expect(data.tier, MembershipTier.gold);
      expect(data.remainingToNextTier, 650000);
    });

    test('최고 등급이면 남은 금액이 null이다', () {
      final data = PointsData(
        membershipId: 'MEMBER-00000002',
        history: [_earnEntry(1200000)],
      );

      expect(data.tier, MembershipTier.platinum);
      expect(data.remainingToNextTier, isNull);
    });
  });
}
