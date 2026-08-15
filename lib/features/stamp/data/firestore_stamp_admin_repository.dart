import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../coupon/data/firestore_coupons_repository.dart';
import '../../points/data/firestore_points_repository.dart';
import '../domain/stamp_admin_repository.dart';
import '../domain/stamp_models.dart';
import '../domain/stamp_reward.dart';
import 'firestore_stamps_repository.dart';

class FirestoreStampAdminRepository implements StampAdminRepository {
  FirestoreStampAdminRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<StampEarnResult> earnByMembershipId({
    required String membershipId,
    required int cups,
  }) async {
    final trimmed = membershipId.trim();
    if (trimmed.isEmpty) {
      throw const FormatException('회원 QR 코드가 올바르지 않습니다.');
    }
    if (cups <= 0) {
      throw ArgumentError.value(cups, 'cups', '적립 잔 수는 1 이상이어야 합니다.');
    }

    final memberQuery = await _firestore
        .collection(FirestorePointsRepository.collectionPath)
        .where('membershipId', isEqualTo: trimmed)
        .limit(1)
        .get();
    if (memberQuery.docs.isEmpty) {
      throw const FormatException('등록되지 않은 회원 QR 코드입니다.');
    }
    final uid = memberQuery.docs.first.id;

    final stampRef =
        _firestore.collection(FirestoreStampsRepository.collectionPath).doc(uid);

    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(stampRef);
      final raw = snapshot.data();
      final data =
          raw != null ? stampDataFromFirestore(raw) : const StampData();

      final applied = applyStampEarn(count: data.count, cups: cups);
      final now = DateTime.now();
      final updated = data.copyWith(
        count: applied.newCount,
        totalEarned: data.totalEarned + cups,
        history: [
          StampHistoryEntry(
            id: _generateId(),
            cups: cups,
            rewards: applied.rewards,
            createdAt: now,
          ),
          ...data.history,
        ],
      );

      transaction.set(stampRef, stampDataToFirestore(updated));

      for (var index = 0; index < applied.rewards; index++) {
        final coupon =
            buildStampRewardCoupon(uid: uid, now: now, index: index);
        final couponRef = _firestore
            .collection(FirestoreCouponsRepository.collectionPath)
            .doc(coupon.id);
        transaction.set(couponRef, couponToFirestore(coupon));
      }

      return StampEarnResult(
        membershipId: trimmed,
        cups: cups,
        count: updated.count,
        totalEarned: updated.totalEarned,
        rewardsIssued: applied.rewards,
      );
    });
  }

  String _generateId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(0xFFFF)}';
}
