import '../../coupon/domain/coupon_models.dart';
import '../../coupon/domain/coupons_repository.dart';
import '../../payment/domain/payment_models.dart';
import '../../points/domain/points_repository.dart';
import '../../review/domain/reviews_repository.dart';
import '../domain/pickup_checkout.dart';
import '../domain/pickup_order_models.dart';
import '../domain/pickup_orders_repository.dart';

/// 서버를 거치지 않는 픽업 주문. [LocalBeanCheckout]과 같은 순서를 따른다.
class LocalPickupCheckout implements PickupCheckout {
  LocalPickupCheckout({
    required this._orders,
    required this._coupons,
    required this._points,
    required this._reviews,
    required this._isMember,
  });

  final WritablePickupOrdersRepository _orders;
  final CouponsRepository _coupons;
  final PointsRepository _points;
  final ReviewsRepository _reviews;
  final bool _isMember;

  @override
  Future<PickupOrder> placeOrder({
    required List<PickupOrderItem> items,
    required String storeId,
    required String storeName,
    List<Coupon> coupons = const [],
    int couponDiscount = 0,
    int usedPoints = 0,
    PaymentApproval? payment,
  }) async {
    for (final coupon in coupons) {
      await _coupons.markUsed(coupon.id);
    }

    if (usedPoints > 0) {
      await _points.usePoints(
        amount: usedPoints,
        description: pickupOrderPointsUseDescription,
      );
    }

    final totalAmount = items.fold(0, (sum, item) => sum + item.totalPrice);
    final paidAmount = totalAmount - couponDiscount - usedPoints;

    var earnedPoints = 0;
    if (paidAmount > 0 && _isMember) {
      final pointsData = await _points.recordPayment(
        paymentAmount: paidAmount,
        description: pickupOrderPaymentDescription,
      );
      final entry = pointsData.history.isEmpty
          ? null
          : pointsData.history.first;
      earnedPoints = entry != null && entry.isEarn ? entry.amount : 0;
    }

    final order = await _orders.placeOrder(
      items: items,
      storeId: storeId,
      storeName: storeName,
      usedPoints: usedPoints,
      earnedPoints: earnedPoints,
      couponId: couponIdsLabel(coupons),
      couponTitle: couponTitlesLabel(coupons),
      couponDiscount: couponDiscount,
      paymentKey: payment?.paymentKey,
      paymentMethod: payment?.method,
    );

    await _recordSales(items);
    return order;
  }

  @override
  Future<PickupOrder> cancelOrder(String orderId) async {
    final cancelled = await _orders.cancelOrder(orderId);

    final couponId = cancelled.couponId;
    if (couponId != null && couponId.isNotEmpty) {
      for (final id in couponId.split(',')) {
        await _coupons.markUnused(id);
      }
    }

    if (cancelled.usedPoints > 0 || cancelled.earnedPoints > 0) {
      await _points.refundOrderPoints(
        usedPoints: cancelled.usedPoints,
        earnedPoints: cancelled.earnedPoints,
        description: pickupOrderCancelDescription,
      );
    }

    return cancelled;
  }

  Future<void> _recordSales(List<PickupOrderItem> items) async {
    final salesByMenu = <String, int>{};
    for (final item in items) {
      salesByMenu[item.menuId] =
          (salesByMenu[item.menuId] ?? 0) + item.quantity;
    }
    await _reviews.recordSales(salesByMenu);
  }
}
