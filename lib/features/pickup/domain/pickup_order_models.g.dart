// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pickup_order_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PickupOrderItem _$PickupOrderItemFromJson(Map<String, dynamic> json) =>
    _PickupOrderItem(
      menuId: json['menuId'] as String,
      menuName: json['menuName'] as String,
      option: json['option'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unitPrice'] as num).toInt(),
    );

Map<String, dynamic> _$PickupOrderItemToJson(_PickupOrderItem instance) =>
    <String, dynamic>{
      'menuId': instance.menuId,
      'menuName': instance.menuName,
      'option': instance.option,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
    };

_PickupOrder _$PickupOrderFromJson(Map<String, dynamic> json) => _PickupOrder(
  id: json['id'] as String,
  storeId: json['storeId'] as String,
  storeName: json['storeName'] as String,
  pickupNumber: (json['pickupNumber'] as num).toInt(),
  items: (json['items'] as List<dynamic>)
      .map((e) => PickupOrderItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalAmount: (json['totalAmount'] as num).toInt(),
  usedPoints: (json['usedPoints'] as num?)?.toInt() ?? 0,
  earnedPoints: (json['earnedPoints'] as num?)?.toInt() ?? 0,
  couponId: json['couponId'] as String?,
  couponTitle: json['couponTitle'] as String?,
  couponDiscount: (json['couponDiscount'] as num?)?.toInt() ?? 0,
  paymentKey: json['paymentKey'] as String?,
  paymentMethod: json['paymentMethod'] as String?,
  status:
      $enumDecodeNullable(_$PickupOrderStatusEnumMap, json['status']) ??
      PickupOrderStatus.received,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$PickupOrderToJson(_PickupOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storeId': instance.storeId,
      'storeName': instance.storeName,
      'pickupNumber': instance.pickupNumber,
      'items': instance.items,
      'totalAmount': instance.totalAmount,
      'usedPoints': instance.usedPoints,
      'earnedPoints': instance.earnedPoints,
      'couponId': instance.couponId,
      'couponTitle': instance.couponTitle,
      'couponDiscount': instance.couponDiscount,
      'paymentKey': instance.paymentKey,
      'paymentMethod': instance.paymentMethod,
      'status': _$PickupOrderStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$PickupOrderStatusEnumMap = {
  PickupOrderStatus.received: 'received',
  PickupOrderStatus.preparing: 'preparing',
  PickupOrderStatus.ready: 'ready',
  PickupOrderStatus.pickedUp: 'pickedUp',
  PickupOrderStatus.cancelled: 'cancelled',
};
