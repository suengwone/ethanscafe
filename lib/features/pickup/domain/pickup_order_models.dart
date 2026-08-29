import 'package:freezed_annotation/freezed_annotation.dart';

import '../../order/domain/refund_status.dart';

part 'pickup_order_models.freezed.dart';
part 'pickup_order_models.g.dart';

const pickupOrderPaymentDescription = '픽업 주문';
const pickupOrderPointsUseDescription = '픽업 주문 포인트 사용';
const pickupOrderCancelDescription = '픽업 주문 취소';

enum PickupOrderStatus { received, preparing, ready, pickedUp, cancelled }

const pickupOrderProgressSteps = [
  PickupOrderStatus.received,
  PickupOrderStatus.preparing,
  PickupOrderStatus.ready,
  PickupOrderStatus.pickedUp,
];

@freezed
abstract class PickupOrderItem with _$PickupOrderItem {
  const PickupOrderItem._();

  const factory PickupOrderItem({
    required String menuId,
    required String menuName,
    String? option,
    required int quantity,
    required int unitPrice,
  }) = _PickupOrderItem;

  factory PickupOrderItem.fromJson(Map<String, dynamic> json) =>
      _$PickupOrderItemFromJson(json);

  int get totalPrice => unitPrice * quantity;

  String get nameWithOption =>
      option == null ? menuName : '$menuName ($option)';
}

@freezed
abstract class PickupOrder with _$PickupOrder {
  const PickupOrder._();

  const factory PickupOrder({
    required String id,
    required String storeId,
    required String storeName,
    required int pickupNumber,
    required List<PickupOrderItem> items,
    required int totalAmount,
    @Default(0) int usedPoints,
    @Default(0) int earnedPoints,
    String? couponId,
    String? couponTitle,
    @Default(0) int couponDiscount,
    String? paymentKey,
    String? paymentMethod,
    @Default(PickupOrderStatus.received) PickupOrderStatus status,
    RefundStatus? refundStatus,
    required DateTime createdAt,
  }) = _PickupOrder;

  factory PickupOrder.fromJson(Map<String, dynamic> json) =>
      _$PickupOrderFromJson(json);

  int get paidAmount => totalAmount - couponDiscount - usedPoints;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isCancellable => status == PickupOrderStatus.received;

  bool get isCancelled => status == PickupOrderStatus.cancelled;

  /// 목록에 보이는 대표 상품. 나머지 개수는 화면이 언어에 맞게 붙인다.
  String get firstItemName => items.isEmpty ? '' : items.first.menuName;
}

int nextPickupNumber(List<PickupOrder> orders, DateTime now) {
  final todayCount = orders
      .where(
        (order) =>
            order.createdAt.year == now.year &&
            order.createdAt.month == now.month &&
            order.createdAt.day == now.day,
      )
      .length;
  return todayCount + 1;
}
