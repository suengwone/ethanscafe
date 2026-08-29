import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../../../core/firebase/firestore_converters.dart';
import '../domain/points_models.dart';
import '../domain/points_repository.dart';

class FirestorePointsRepository implements PointsRepository {
  FirestorePointsRepository({
    required this.uid,
    FirebaseFirestore? firestore,
    FirebaseFunctions? functions,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _functions = functions ?? FirebaseFunctions.instanceFor(region: _region);

  final String uid;
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  static const collectionPath = 'points';
  static const _region = 'asia-northeast3';
  static const usePointsCallableName = 'usePoints';

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
  }) {
    throw UnsupportedError('포인트 적립은 서버(Cloud Functions)에서만 처리됩니다.');
  }

  @override
  Future<PointsData> usePoints({
    required int amount,
    String description = '포인트 결제',
  }) async {
    if (amount <= 0) {
      throw ArgumentError.value(amount, 'amount', '사용 포인트는 0보다 커야 합니다.');
    }

    await _functions.httpsCallable(usePointsCallableName).call<Object?>({
      'amount': amount,
      'description': description,
    });
    return load();
  }

  @override
  Future<PointsData> refundOrderPoints({
    int usedPoints = 0,
    int earnedPoints = 0,
    String description = '주문 취소',
  }) {
    throw UnsupportedError('포인트 환급은 서버(Cloud Functions)에서만 처리됩니다.');
  }
}

PointsData pointsDataFromFirestore(Map<String, dynamic> data) {
  return PointsData(
    membershipId: data['membershipId'] as String? ?? '',
    balance: (data['balance'] as num? ?? 0).toInt(),
    history: (data['history'] as List<dynamic>? ?? const [])
        .map(
          (entry) =>
              pointHistoryEntryFromFirestore(entry as Map<String, dynamic>),
        )
        .toList(),
  );
}

PointHistoryEntry pointHistoryEntryFromFirestore(Map<String, dynamic> data) {
  return PointHistoryEntry(
    id: data['id'] as String? ?? '',
    type:
        PointHistoryType.values.asNameMap()[data['type']] ??
        PointHistoryType.earn,
    description: data['description'] as String? ?? '',
    amount: (data['amount'] as num? ?? 0).toInt(),
    paymentAmount: (data['paymentAmount'] as num?)?.toInt(),
    bonusAmount: (data['bonusAmount'] as num?)?.toInt(),
    paymentKey: data['paymentKey'] as String?,
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
    if (entry.bonusAmount != null) 'bonusAmount': entry.bonusAmount,
    if (entry.paymentKey != null) 'paymentKey': entry.paymentKey,
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
