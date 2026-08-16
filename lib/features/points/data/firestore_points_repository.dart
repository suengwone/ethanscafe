import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firebase/firestore_converters.dart';
import '../domain/membership_tier.dart';
import '../domain/points_models.dart';
import '../domain/points_repository.dart';

class FirestorePointsRepository implements PointsRepository {
  FirestorePointsRepository({
    required this.uid,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final String uid;
  final FirebaseFirestore _firestore;

  static const collectionPath = 'points';

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.collection(collectionPath).doc(uid);

  @override
  Future<PointsData> load() async {
    final snapshot = await _doc.get();
    final data = snapshot.data();
    if (data != null) {
      return pointsDataFromFirestore(data);
    }

    final created = PointsData(membershipId: generateMembershipId());
    await _doc.set(pointsDataToFirestore(created));
    return created;
  }

  @override
  Future<PointsData> recordPayment({
    required int paymentAmount,
    String description = '매장 결제',
  }) async {
    if (paymentAmount <= 0) {
      throw ArgumentError.value(
          paymentAmount, 'paymentAmount', '결제 금액은 0보다 커야 합니다.');
    }

    return _firestore.runTransaction((transaction) async {
      final data = await _loadInTransaction(transaction);
      final earned = membershipTierOf(data.history).earnPoints(paymentAmount);
      final updated = data.copyWith(
        balance: data.balance + earned,
        history: [
          PointHistoryEntry(
            id: generateEntryId(),
            type: PointHistoryType.earn,
            description: description,
            amount: earned,
            paymentAmount: paymentAmount,
            createdAt: DateTime.now(),
          ),
          ...data.history,
        ],
      );
      transaction.set(_doc, pointsDataToFirestore(updated));
      return updated;
    });
  }

  @override
  Future<PointsData> usePoints({
    required int amount,
    String description = '포인트 결제',
  }) async {
    if (amount <= 0) {
      throw ArgumentError.value(amount, 'amount', '사용 포인트는 0보다 커야 합니다.');
    }

    return _firestore.runTransaction((transaction) async {
      final data = await _loadInTransaction(transaction);
      if (amount > data.balance) {
        throw StateError('포인트 잔액이 부족합니다.');
      }
      final updated = data.copyWith(
        balance: data.balance - amount,
        history: [
          PointHistoryEntry(
            id: generateEntryId(),
            type: PointHistoryType.use,
            description: description,
            amount: -amount,
            createdAt: DateTime.now(),
          ),
          ...data.history,
        ],
      );
      transaction.set(_doc, pointsDataToFirestore(updated));
      return updated;
    });
  }

  @override
  Future<PointsData> refundOrderPoints({
    int usedPoints = 0,
    int earnedPoints = 0,
    String description = '주문 취소',
  }) async {
    if (usedPoints < 0 || earnedPoints < 0) {
      throw ArgumentError('환급/회수 포인트는 0 이상이어야 합니다.');
    }
    if (usedPoints == 0 && earnedPoints == 0) {
      return load();
    }

    return _firestore.runTransaction((transaction) async {
      final data = await _loadInTransaction(transaction);
      final reclaimed = min(earnedPoints, data.balance + usedPoints);
      final updated = data.copyWith(
        balance: data.balance + usedPoints - reclaimed,
        history: [
          if (reclaimed > 0)
            PointHistoryEntry(
              id: generateEntryId(),
              type: PointHistoryType.use,
              description: '$description 적립 회수',
              amount: -reclaimed,
              createdAt: DateTime.now(),
            ),
          if (usedPoints > 0)
            PointHistoryEntry(
              id: generateEntryId(),
              type: PointHistoryType.earn,
              description: '$description 포인트 환급',
              amount: usedPoints,
              createdAt: DateTime.now(),
            ),
          ...data.history,
        ],
      );
      transaction.set(_doc, pointsDataToFirestore(updated));
      return updated;
    });
  }

  Future<PointsData> _loadInTransaction(Transaction transaction) async {
    final snapshot = await transaction.get(_doc);
    final data = snapshot.data();
    if (data != null) {
      return pointsDataFromFirestore(data);
    }
    return PointsData(membershipId: generateMembershipId());
  }
}

PointsData pointsDataFromFirestore(Map<String, dynamic> data) {
  return PointsData(
    membershipId: data['membershipId'] as String? ?? '',
    balance: (data['balance'] as num? ?? 0).toInt(),
    history: (data['history'] as List<dynamic>? ?? const [])
        .map((entry) =>
            pointHistoryEntryFromFirestore(entry as Map<String, dynamic>))
        .toList(),
  );
}

PointHistoryEntry pointHistoryEntryFromFirestore(Map<String, dynamic> data) {
  return PointHistoryEntry(
    id: data['id'] as String? ?? '',
    type: PointHistoryType.values.asNameMap()[data['type']] ??
        PointHistoryType.earn,
    description: data['description'] as String? ?? '',
    amount: (data['amount'] as num? ?? 0).toInt(),
    paymentAmount: (data['paymentAmount'] as num?)?.toInt(),
    createdAt: firestoreDateTime(data['createdAt']),
  );
}

Map<String, dynamic> pointsDataToFirestore(PointsData data) {
  return {
    'membershipId': data.membershipId,
    'balance': data.balance,
    'history': data.history.map(pointHistoryEntryToFirestore).toList(),
  };
}

Map<String, dynamic> pointHistoryEntryToFirestore(PointHistoryEntry entry) {
  return {
    'id': entry.id,
    'type': entry.type.name,
    'description': entry.description,
    'amount': entry.amount,
    if (entry.paymentAmount != null) 'paymentAmount': entry.paymentAmount,
    'createdAt': Timestamp.fromDate(entry.createdAt),
  };
}

String generateEntryId() =>
    '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(0xFFFF)}';

String generateMembershipId() {
  final random = Random();
  final digits = List.generate(8, (_) => random.nextInt(10)).join();
  return 'MEMBER-$digits';
}
