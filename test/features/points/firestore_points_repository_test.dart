import 'package:cafe_app/features/points/data/firestore_points_repository.dart';
import 'package:cafe_app/features/points/domain/points_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('pointsDataFromFirestore', () {
    test('Timestamp 히스토리를 포함한 문서를 변환한다', () {
      final createdAt = DateTime(2026, 8, 1, 12, 30);
      final data = pointsDataFromFirestore({
        'membershipId': 'MEMBER-12345678',
        'balance': 1500,
        'history': [
          {
            'id': 'entry-1',
            'type': 'earn',
            'description': '매장 결제',
            'amount': 500,
            'paymentAmount': 5000,
            'createdAt': Timestamp.fromDate(createdAt),
          },
        ],
      });

      expect(data.membershipId, 'MEMBER-12345678');
      expect(data.balance, 1500);
      expect(data.history, hasLength(1));
      expect(data.history.first.type, PointHistoryType.earn);
      expect(data.history.first.amount, 500);
      expect(data.history.first.paymentAmount, 5000);
      expect(data.history.first.createdAt, createdAt);
    });

    test('누락된 필드는 기본값으로 채운다', () {
      final data = pointsDataFromFirestore({'membershipId': 'MEMBER-00000000'});

      expect(data.balance, 0);
      expect(data.history, isEmpty);
    });

    test('use 타입 히스토리를 변환한다', () {
      final data = pointsDataFromFirestore({
        'membershipId': 'MEMBER-12345678',
        'balance': 0,
        'history': [
          {
            'id': 'entry-2',
            'type': 'use',
            'description': '포인트 결제',
            'amount': -1000,
            'createdAt': '2026-08-02T09:00:00.000',
          },
        ],
      });

      expect(data.history.first.type, PointHistoryType.use);
      expect(data.history.first.amount, -1000);
      expect(data.history.first.paymentAmount, isNull);
      expect(data.history.first.createdAt, DateTime(2026, 8, 2, 9));
    });
  });

  group('pointsDataToFirestore', () {
    test('히스토리 createdAt을 Timestamp로 직렬화한다', () {
      final createdAt = DateTime(2026, 8, 1, 12, 30);
      final map = pointsDataToFirestore(
        PointsData(
          membershipId: 'MEMBER-12345678',
          balance: 700,
          history: [
            PointHistoryEntry(
              id: 'entry-1',
              type: PointHistoryType.earn,
              description: '매장 결제',
              amount: 700,
              paymentAmount: 7000,
              createdAt: createdAt,
            ),
          ],
        ),
      );

      expect(map['membershipId'], 'MEMBER-12345678');
      expect(map['balance'], 700);
      final history = map['history'] as List<dynamic>;
      final entry = history.first as Map<String, dynamic>;
      expect(entry['type'], 'earn');
      expect(entry['createdAt'], Timestamp.fromDate(createdAt));
    });

    test('paymentAmount가 없으면 필드를 생략한다', () {
      final map = pointsDataToFirestore(
        PointsData(
          membershipId: 'MEMBER-12345678',
          history: [
            PointHistoryEntry(
              id: 'entry-2',
              type: PointHistoryType.use,
              description: '포인트 결제',
              amount: -300,
              createdAt: DateTime(2026, 8, 2),
            ),
          ],
        ),
      );

      final entry =
          (map['history'] as List<dynamic>).first as Map<String, dynamic>;
      expect(entry.containsKey('paymentAmount'), isFalse);
    });

    test('round trip 시 데이터가 보존된다', () {
      final original = PointsData(
        membershipId: 'MEMBER-87654321',
        balance: 2500,
        history: [
          PointHistoryEntry(
            id: 'entry-1',
            type: PointHistoryType.earn,
            description: '매장 결제',
            amount: 500,
            paymentAmount: 5000,
            createdAt: DateTime(2026, 8, 1, 12, 30),
          ),
          PointHistoryEntry(
            id: 'entry-2',
            type: PointHistoryType.use,
            description: '포인트 결제',
            amount: -1000,
            createdAt: DateTime(2026, 8, 2, 9),
          ),
        ],
      );

      final restored = pointsDataFromFirestore(pointsDataToFirestore(original));

      expect(restored, original);
    });
  });

  group('generateMembershipId', () {
    test('MEMBER- 접두어와 8자리 숫자로 생성한다', () {
      final id = generateMembershipId();
      expect(RegExp(r'^MEMBER-\d{8}$').hasMatch(id), isTrue);
    });
  });
}
