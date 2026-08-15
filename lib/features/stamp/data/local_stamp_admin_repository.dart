import '../../coupon/domain/coupons_repository.dart';
import '../../points/domain/points_repository.dart';
import '../domain/stamp_admin_repository.dart';
import '../domain/stamp_models.dart';
import '../domain/stamp_reward.dart';
import 'local_stamps_repository.dart';

class LocalStampAdminRepository implements StampAdminRepository {
  LocalStampAdminRepository(this._stamps, this._points, this._coupons);

  final LocalStampsRepository _stamps;
  final PointsRepository _points;
  final CouponsRepository _coupons;

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

    final points = await _points.load();
    if (points.membershipId != trimmed) {
      throw const FormatException('등록되지 않은 회원 QR 코드입니다.');
    }

    final before = await _stamps.load();
    final applied = applyStampEarn(count: before.count, cups: cups);
    final updated = await _stamps.earn(cups: cups);

    final now = DateTime.now();
    for (var index = 0; index < applied.rewards; index++) {
      await _coupons.issueCoupon(
        buildStampRewardCoupon(uid: trimmed, now: now, index: index),
      );
    }

    return StampEarnResult(
      membershipId: trimmed,
      cups: cups,
      count: updated.count,
      totalEarned: updated.totalEarned,
      rewardsIssued: applied.rewards,
    );
  }
}
