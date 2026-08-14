// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BeanOrderItem _$BeanOrderItemFromJson(Map<String, dynamic> json) =>
    _BeanOrderItem(
      beanId: json['beanId'] as String,
      beanName: json['beanName'] as String,
      weight: $enumDecode(_$BeanWeightEnumMap, json['weight']),
      grind: $enumDecode(_$GrindOptionEnumMap, json['grind']),
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unitPrice'] as num).toInt(),
    );

Map<String, dynamic> _$BeanOrderItemToJson(_BeanOrderItem instance) =>
    <String, dynamic>{
      'beanId': instance.beanId,
      'beanName': instance.beanName,
      'weight': _$BeanWeightEnumMap[instance.weight]!,
      'grind': _$GrindOptionEnumMap[instance.grind]!,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
    };

const _$BeanWeightEnumMap = {BeanWeight.g200: 'g200', BeanWeight.g500: 'g500'};

const _$GrindOptionEnumMap = {
  GrindOption.wholeBean: 'wholeBean',
  GrindOption.espresso: 'espresso',
  GrindOption.mokaPot: 'mokaPot',
  GrindOption.handDrip: 'handDrip',
  GrindOption.frenchPress: 'frenchPress',
};

_BeanOrder _$BeanOrderFromJson(Map<String, dynamic> json) => _BeanOrder(
  id: json['id'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => BeanOrderItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalAmount: (json['totalAmount'] as num).toInt(),
  usedPoints: (json['usedPoints'] as num?)?.toInt() ?? 0,
  earnedPoints: (json['earnedPoints'] as num?)?.toInt() ?? 0,
  couponId: json['couponId'] as String?,
  couponTitle: json['couponTitle'] as String?,
  couponDiscount: (json['couponDiscount'] as num?)?.toInt() ?? 0,
  paymentKey: json['paymentKey'] as String?,
  paymentMethod: json['paymentMethod'] as String?,
  fulfillmentMethod:
      $enumDecodeNullable(
        _$BeanFulfillmentMethodEnumMap,
        json['fulfillmentMethod'],
      ) ??
      BeanFulfillmentMethod.delivery,
  storeId: json['storeId'] as String?,
  storeName: json['storeName'] as String?,
  recipient: json['recipient'] as String?,
  recipientPhone: json['recipientPhone'] as String?,
  shippingAddress: json['shippingAddress'] as String?,
  status:
      $enumDecodeNullable(_$BeanOrderStatusEnumMap, json['status']) ??
      BeanOrderStatus.received,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$BeanOrderToJson(_BeanOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'items': instance.items,
      'totalAmount': instance.totalAmount,
      'usedPoints': instance.usedPoints,
      'earnedPoints': instance.earnedPoints,
      'couponId': instance.couponId,
      'couponTitle': instance.couponTitle,
      'couponDiscount': instance.couponDiscount,
      'paymentKey': instance.paymentKey,
      'paymentMethod': instance.paymentMethod,
      'fulfillmentMethod':
          _$BeanFulfillmentMethodEnumMap[instance.fulfillmentMethod]!,
      'storeId': instance.storeId,
      'storeName': instance.storeName,
      'recipient': instance.recipient,
      'recipientPhone': instance.recipientPhone,
      'shippingAddress': instance.shippingAddress,
      'status': _$BeanOrderStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$BeanFulfillmentMethodEnumMap = {
  BeanFulfillmentMethod.delivery: 'delivery',
  BeanFulfillmentMethod.pickup: 'pickup',
};

const _$BeanOrderStatusEnumMap = {
  BeanOrderStatus.received: 'received',
  BeanOrderStatus.roasting: 'roasting',
  BeanOrderStatus.shipped: 'shipped',
  BeanOrderStatus.delivered: 'delivered',
  BeanOrderStatus.ready: 'ready',
  BeanOrderStatus.pickedUp: 'pickedUp',
  BeanOrderStatus.cancelled: 'cancelled',
};
