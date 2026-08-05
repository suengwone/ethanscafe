import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/points_models.dart';
import '../domain/qr_points_repository.dart';
import 'firestore_points_repository.dart';

class FirestoreQrPointsRepository implements QrPointsRepository {
  FirestoreQrPointsRepository({
    required this.uid,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  static const tokenCollectionPath = 'qrTokens';
  static const earnRate = 0.1;

  final String uid;
  final FirebaseFirestore _firestore;

  @override
  Future<QrEarnResult> earnFromQr(String code) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) {
      throw const FormatException('QR 코드가 올바르지 않습니다.');
    }

    final tokenRef = _firestore.collection(tokenCollectionPath).doc(trimmed);
    final pointsRef = _firestore
        .collection(FirestorePointsRepository.collectionPath)
        .doc(uid);

    return _firestore.runTransaction((transaction) async {
      final tokenSnapshot = await transaction.get(tokenRef);
      final token = validateQrToken(tokenSnapshot.data(), now: DateTime.now());

      final pointsSnapshot = await transaction.get(pointsRef);
      final pointsRaw = pointsSnapshot.data();
      final points = pointsRaw != null
          ? pointsDataFromFirestore(pointsRaw)
          : PointsData(membershipId: generateMembershipId());

      final earned = (token.paymentAmount * earnRate).floor();
      final updated = points.copyWith(
        balance: points.balance + earned,
        history: [
          PointHistoryEntry(
            id: generateEntryId(),
            type: PointHistoryType.earn,
            description: token.storeName,
            amount: earned,
            paymentAmount: token.paymentAmount,
            createdAt: DateTime.now(),
          ),
          ...points.history,
        ],
      );

      transaction.set(pointsRef, pointsDataToFirestore(updated));
      transaction.update(tokenRef, {
        'used': true,
        'usedBy': uid,
        'usedAt': FieldValue.serverTimestamp(),
      });

      return QrEarnResult(
        storeName: token.storeName,
        paymentAmount: token.paymentAmount,
        earned: earned,
        balance: updated.balance,
      );
    });
  }
}

({String storeName, int paymentAmount}) validateQrToken(
  Map<String, dynamic>? data, {
  required DateTime now,
}) {
  if (data == null) {
    throw const FormatException('등록되지 않은 QR 코드입니다.');
  }
  if (data['used'] == true) {
    throw StateError('이미 사용된 QR 코드입니다.');
  }
  final expiresAt = data['expiresAt'];
  if (expiresAt is Timestamp && expiresAt.toDate().isBefore(now)) {
    throw StateError('만료된 QR 코드입니다.');
  }
  final paymentAmount = (data['paymentAmount'] as num? ?? 0).toInt();
  if (paymentAmount <= 0) {
    throw StateError('결제 금액이 올바르지 않습니다.');
  }
  final storeName = data['storeName'] as String? ?? '';
  return (
    storeName: storeName.isEmpty ? '매장 결제' : storeName,
    paymentAmount: paymentAmount,
  );
}
