import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/points_admin_repository.dart';
import '../domain/points_models.dart';
import 'firestore_points_repository.dart';

class FirestorePointsAdminRepository implements PointsAdminRepository {
  FirestorePointsAdminRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<PointsEarnResult> earnByMembershipId({
    required String membershipId,
    required int paymentAmount,
  }) async {
    final trimmed = membershipId.trim();
    if (trimmed.isEmpty) {
      throw const FormatException('회원 QR 코드가 올바르지 않습니다.');
    }
    if (paymentAmount <= 0) {
      throw ArgumentError.value(
          paymentAmount, 'paymentAmount', '결제 금액은 0보다 커야 합니다.');
    }

    final query = await _firestore
        .collection(FirestorePointsRepository.collectionPath)
        .where('membershipId', isEqualTo: trimmed)
        .limit(1)
        .get();
    if (query.docs.isEmpty) {
      throw const FormatException('등록되지 않은 회원 QR 코드입니다.');
    }
    final doc = query.docs.first.reference;

    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(doc);
      final data = pointsDataFromFirestore(snapshot.data() ?? const {});
      final earned = earnPointsForPayment(paymentAmount);
      final updated = data.copyWith(
        balance: data.balance + earned,
        history: [
          PointHistoryEntry(
            id: generateEntryId(),
            type: PointHistoryType.earn,
            description: '매장 결제',
            amount: earned,
            paymentAmount: paymentAmount,
            createdAt: DateTime.now(),
          ),
          ...data.history,
        ],
      );
      transaction.set(doc, pointsDataToFirestore(updated));
      return PointsEarnResult(
        membershipId: trimmed,
        paymentAmount: paymentAmount,
        earned: earned,
        balance: updated.balance,
      );
    });
  }
}
