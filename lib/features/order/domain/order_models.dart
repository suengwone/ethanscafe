import 'package:freezed_annotation/freezed_annotation.dart';

import '../../beans/domain/bean_models.dart';
import 'refund_status.dart';

part 'order_models.freezed.dart';
part 'order_models.g.dart';

const beanOrderPaymentDescription = '원두 주문';
const beanOrderPointsUseDescription = '원두 주문 포인트 사용';
const beanOrderCancelDescription = '원두 주문 취소';

enum BeanOrderStatus {
  received('주문 접수'),
  roasting('로스팅 중'),
  shipped('발송 완료'),
  delivered('배송 완료'),
  ready('픽업 대기'),
  pickedUp('픽업 완료'),
  cancelled('주문 취소');

  const BeanOrderStatus(this.label);

  final String label;
}

enum BeanFulfillmentMethod {
  delivery('택배 배송'),
  pickup('매장 픽업');

  const BeanFulfillmentMethod(this.label);

  final String label;
}

@freezed
abstract class BeanOrderItem with _$BeanOrderItem {
  const BeanOrderItem._();

  const factory BeanOrderItem({
    required String beanId,
    required String beanName,
    required BeanWeight weight,
    required GrindOption grind,
    required int quantity,
    required int unitPrice,
  }) = _BeanOrderItem;

  factory BeanOrderItem.fromJson(Map<String, dynamic> json) =>
      _$BeanOrderItemFromJson(json);

  int get totalPrice => unitPrice * quantity;

  String get optionLabel => '${weight.label} · ${grind.label}';
}

@freezed
abstract class BeanOrder with _$BeanOrder {
  const BeanOrder._();

  const factory BeanOrder({
    required String id,
    required List<BeanOrderItem> items,
    required int totalAmount,
    @Default(0) int usedPoints,
    @Default(0) int earnedPoints,
    String? couponId,
    String? couponTitle,
    @Default(0) int couponDiscount,
    String? paymentKey,
    String? paymentMethod,
    @Default(BeanFulfillmentMethod.delivery)
    BeanFulfillmentMethod fulfillmentMethod,
    String? storeId,
    String? storeName,
    String? recipient,
    String? recipientPhone,
    String? shippingAddress,
    @Default(BeanOrderStatus.received) BeanOrderStatus status,
    RefundStatus? refundStatus,
    required DateTime createdAt,
  }) = _BeanOrder;

  factory BeanOrder.fromJson(Map<String, dynamic> json) =>
      _$BeanOrderFromJson(json);

  int get paidAmount => totalAmount - couponDiscount - usedPoints;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isCancellable => status == BeanOrderStatus.received;

  bool get isCancelled => status == BeanOrderStatus.cancelled;

  String get summary => items.length == 1
      ? items.first.beanName
      : '${items.first.beanName} 외 ${items.length - 1}건';
}
