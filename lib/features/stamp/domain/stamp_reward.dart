import '../../coupon/domain/coupon_models.dart';

const stampRewardThreshold = 10;
const stampRewardValidDays = 30;

({int newCount, int rewards}) applyStampEarn({
  required int count,
  required int cups,
}) {
  if (count < 0) {
    throw ArgumentError.value(count, 'count', '스탬프 개수는 0 이상이어야 합니다.');
  }
  if (cups <= 0) {
    throw ArgumentError.value(cups, 'cups', '적립 잔 수는 1 이상이어야 합니다.');
  }
  final total = count + cups;
  return (
    newCount: total % stampRewardThreshold,
    rewards: total ~/ stampRewardThreshold,
  );
}

String stampRewardCouponId(String uid, DateTime now, int index) =>
    'stamp-reward-$uid-${now.millisecondsSinceEpoch}-$index';

Coupon buildStampRewardCoupon({
  required String uid,
  required DateTime now,
  int index = 0,
}) {
  final expiresAt = DateTime(
    now.year,
    now.month,
    now.day + stampRewardValidDays - 1,
    23,
    59,
  );
  return Coupon(
    id: stampRewardCouponId(uid, now, index),
    title: '스탬프 완성 음료 1잔 무료',
    description: '스탬프 $stampRewardThreshold개 적립 완료! 매장에서 음료 1잔 무료 쿠폰',
    expiresAt: expiresAt,
  );
}
