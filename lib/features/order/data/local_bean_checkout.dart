import '../../coupon/domain/coupon_models.dart';
import '../../coupon/domain/coupons_repository.dart';
import '../../payment/domain/payment_models.dart';
import '../../points/domain/points_repository.dart';
import '../../review/domain/reviews_repository.dart';
import '../domain/bean_checkout.dart';
import '../domain/bean_orders_repository.dart';
import '../domain/order_models.dart';

/// 서버를 거치지 않는 원두 주문. 콜러블이 한 트랜잭션에서 하는 일(쿠폰 사용
/// 처리, 포인트 차감·적립, 주문 저장, 판매량 집계)을 순서대로 흉내 낸다.
class LocalBeanCheckout implements BeanCheckout {
  LocalBeanCheckout({
    required this._orders,
    required this._coupons,
    required this._points,
    required this._reviews,
    required this._isMember,
  });

  final WritableBeanOrdersRepository _orders;
  final CouponsRepository _coupons;
  final PointsRepository _points;
  final ReviewsRepository _reviews;
  final bool _isMember;

  @override
  Future<BeanOrder> placeOrder({
    required List<BeanOrderItem> items,
    List<Coupon> coupons = const [],
    int couponDiscount = 0,
    int usedPoints = 0,
    PaymentApproval? payment,
    BeanFulfillmentMethod fulfillmentMethod = BeanFulfillmentMethod.delivery,
    String? storeId,
    String? storeName,
    String? recipient,
    String? recipientPhone,
    String? shippingAddress,
  }) async {
    for (final coupon in coupons) {
      await _coupons.markUsed(coupon.id);
    }

    if (usedPoints > 0) {
      await _points.usePoints(
        amount: usedPoints,
        description: beanOrderPointsUseDescription,
      );
    }

    final totalAmount = items.fold(0, (sum, item) => sum + item.totalPrice);
    final paidAmount = totalAmount - couponDiscount - usedPoints;

    var earnedPoints = 0;
    if (paidAmount > 0 && _isMember) {
      final pointsData = await _points.recordPayment(
        paymentAmount: paidAmount,
        description: beanOrderPaymentDescription,
      );
      final entry =
          pointsData.history.isEmpty ? null : pointsData.history.first;
      earnedPoints = entry != null && entry.isEarn ? entry.amount : 0;
    }

    final order = await _orders.placeOrder(
      items: items,
      usedPoints: usedPoints,
      earnedPoints: earnedPoints,
      couponId: couponIdsLabel(coupons),
      couponTitle: couponTitlesLabel(coupons),
      couponDiscount: couponDiscount,
      paymentKey: payment?.paymentKey,
      paymentMethod: payment?.method,
      fulfillmentMethod: fulfillmentMethod,
      storeId: storeId,
      storeName: storeName,
      recipient: recipient,
      recipientPhone: recipientPhone,
      shippingAddress: shippingAddress,
    );

    await _recordSales(items);
    return order;
  }

  @override
  Future<BeanOrder> cancelOrder(String orderId) async {
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
        description: beanOrderCancelDescription,
      );
    }

    return cancelled;
  }

  Future<void> _recordSales(List<BeanOrderItem> items) async {
    final salesByBean = <String, int>{};
    for (final item in items) {
      salesByBean[item.beanId] = (salesByBean[item.beanId] ?? 0) + item.quantity;
    }
    await _reviews.recordSales(salesByBean);
  }
}
