// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BeanOrderItem {

 String get beanId; String get beanName; BeanWeight get weight; GrindOption get grind; int get quantity; int get unitPrice;
/// Create a copy of BeanOrderItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BeanOrderItemCopyWith<BeanOrderItem> get copyWith => _$BeanOrderItemCopyWithImpl<BeanOrderItem>(this as BeanOrderItem, _$identity);

  /// Serializes this BeanOrderItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BeanOrderItem&&(identical(other.beanId, beanId) || other.beanId == beanId)&&(identical(other.beanName, beanName) || other.beanName == beanName)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.grind, grind) || other.grind == grind)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,beanId,beanName,weight,grind,quantity,unitPrice);

@override
String toString() {
  return 'BeanOrderItem(beanId: $beanId, beanName: $beanName, weight: $weight, grind: $grind, quantity: $quantity, unitPrice: $unitPrice)';
}


}

/// @nodoc
abstract mixin class $BeanOrderItemCopyWith<$Res>  {
  factory $BeanOrderItemCopyWith(BeanOrderItem value, $Res Function(BeanOrderItem) _then) = _$BeanOrderItemCopyWithImpl;
@useResult
$Res call({
 String beanId, String beanName, BeanWeight weight, GrindOption grind, int quantity, int unitPrice
});




}
/// @nodoc
class _$BeanOrderItemCopyWithImpl<$Res>
    implements $BeanOrderItemCopyWith<$Res> {
  _$BeanOrderItemCopyWithImpl(this._self, this._then);

  final BeanOrderItem _self;
  final $Res Function(BeanOrderItem) _then;

/// Create a copy of BeanOrderItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? beanId = null,Object? beanName = null,Object? weight = null,Object? grind = null,Object? quantity = null,Object? unitPrice = null,}) {
  return _then(_self.copyWith(
beanId: null == beanId ? _self.beanId : beanId // ignore: cast_nullable_to_non_nullable
as String,beanName: null == beanName ? _self.beanName : beanName // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as BeanWeight,grind: null == grind ? _self.grind : grind // ignore: cast_nullable_to_non_nullable
as GrindOption,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BeanOrderItem].
extension BeanOrderItemPatterns on BeanOrderItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BeanOrderItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BeanOrderItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BeanOrderItem value)  $default,){
final _that = this;
switch (_that) {
case _BeanOrderItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BeanOrderItem value)?  $default,){
final _that = this;
switch (_that) {
case _BeanOrderItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String beanId,  String beanName,  BeanWeight weight,  GrindOption grind,  int quantity,  int unitPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BeanOrderItem() when $default != null:
return $default(_that.beanId,_that.beanName,_that.weight,_that.grind,_that.quantity,_that.unitPrice);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String beanId,  String beanName,  BeanWeight weight,  GrindOption grind,  int quantity,  int unitPrice)  $default,) {final _that = this;
switch (_that) {
case _BeanOrderItem():
return $default(_that.beanId,_that.beanName,_that.weight,_that.grind,_that.quantity,_that.unitPrice);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String beanId,  String beanName,  BeanWeight weight,  GrindOption grind,  int quantity,  int unitPrice)?  $default,) {final _that = this;
switch (_that) {
case _BeanOrderItem() when $default != null:
return $default(_that.beanId,_that.beanName,_that.weight,_that.grind,_that.quantity,_that.unitPrice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BeanOrderItem extends BeanOrderItem {
  const _BeanOrderItem({required this.beanId, required this.beanName, required this.weight, required this.grind, required this.quantity, required this.unitPrice}): super._();
  factory _BeanOrderItem.fromJson(Map<String, dynamic> json) => _$BeanOrderItemFromJson(json);

@override final  String beanId;
@override final  String beanName;
@override final  BeanWeight weight;
@override final  GrindOption grind;
@override final  int quantity;
@override final  int unitPrice;

/// Create a copy of BeanOrderItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BeanOrderItemCopyWith<_BeanOrderItem> get copyWith => __$BeanOrderItemCopyWithImpl<_BeanOrderItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BeanOrderItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BeanOrderItem&&(identical(other.beanId, beanId) || other.beanId == beanId)&&(identical(other.beanName, beanName) || other.beanName == beanName)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.grind, grind) || other.grind == grind)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,beanId,beanName,weight,grind,quantity,unitPrice);

@override
String toString() {
  return 'BeanOrderItem(beanId: $beanId, beanName: $beanName, weight: $weight, grind: $grind, quantity: $quantity, unitPrice: $unitPrice)';
}


}

/// @nodoc
abstract mixin class _$BeanOrderItemCopyWith<$Res> implements $BeanOrderItemCopyWith<$Res> {
  factory _$BeanOrderItemCopyWith(_BeanOrderItem value, $Res Function(_BeanOrderItem) _then) = __$BeanOrderItemCopyWithImpl;
@override @useResult
$Res call({
 String beanId, String beanName, BeanWeight weight, GrindOption grind, int quantity, int unitPrice
});




}
/// @nodoc
class __$BeanOrderItemCopyWithImpl<$Res>
    implements _$BeanOrderItemCopyWith<$Res> {
  __$BeanOrderItemCopyWithImpl(this._self, this._then);

  final _BeanOrderItem _self;
  final $Res Function(_BeanOrderItem) _then;

/// Create a copy of BeanOrderItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? beanId = null,Object? beanName = null,Object? weight = null,Object? grind = null,Object? quantity = null,Object? unitPrice = null,}) {
  return _then(_BeanOrderItem(
beanId: null == beanId ? _self.beanId : beanId // ignore: cast_nullable_to_non_nullable
as String,beanName: null == beanName ? _self.beanName : beanName // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as BeanWeight,grind: null == grind ? _self.grind : grind // ignore: cast_nullable_to_non_nullable
as GrindOption,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BeanOrder {

 String get id; List<BeanOrderItem> get items; int get totalAmount; int get usedPoints; int get earnedPoints; String? get couponId; String? get couponTitle; int get couponDiscount; String? get paymentKey; String? get paymentMethod; BeanFulfillmentMethod get fulfillmentMethod; String? get storeId; String? get storeName; String? get recipient; String? get recipientPhone; String? get shippingAddress; BeanOrderStatus get status; DateTime get createdAt;
/// Create a copy of BeanOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BeanOrderCopyWith<BeanOrder> get copyWith => _$BeanOrderCopyWithImpl<BeanOrder>(this as BeanOrder, _$identity);

  /// Serializes this BeanOrder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BeanOrder&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.usedPoints, usedPoints) || other.usedPoints == usedPoints)&&(identical(other.earnedPoints, earnedPoints) || other.earnedPoints == earnedPoints)&&(identical(other.couponId, couponId) || other.couponId == couponId)&&(identical(other.couponTitle, couponTitle) || other.couponTitle == couponTitle)&&(identical(other.couponDiscount, couponDiscount) || other.couponDiscount == couponDiscount)&&(identical(other.paymentKey, paymentKey) || other.paymentKey == paymentKey)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.fulfillmentMethod, fulfillmentMethod) || other.fulfillmentMethod == fulfillmentMethod)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.recipient, recipient) || other.recipient == recipient)&&(identical(other.recipientPhone, recipientPhone) || other.recipientPhone == recipientPhone)&&(identical(other.shippingAddress, shippingAddress) || other.shippingAddress == shippingAddress)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(items),totalAmount,usedPoints,earnedPoints,couponId,couponTitle,couponDiscount,paymentKey,paymentMethod,fulfillmentMethod,storeId,storeName,recipient,recipientPhone,shippingAddress,status,createdAt);

@override
String toString() {
  return 'BeanOrder(id: $id, items: $items, totalAmount: $totalAmount, usedPoints: $usedPoints, earnedPoints: $earnedPoints, couponId: $couponId, couponTitle: $couponTitle, couponDiscount: $couponDiscount, paymentKey: $paymentKey, paymentMethod: $paymentMethod, fulfillmentMethod: $fulfillmentMethod, storeId: $storeId, storeName: $storeName, recipient: $recipient, recipientPhone: $recipientPhone, shippingAddress: $shippingAddress, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BeanOrderCopyWith<$Res>  {
  factory $BeanOrderCopyWith(BeanOrder value, $Res Function(BeanOrder) _then) = _$BeanOrderCopyWithImpl;
@useResult
$Res call({
 String id, List<BeanOrderItem> items, int totalAmount, int usedPoints, int earnedPoints, String? couponId, String? couponTitle, int couponDiscount, String? paymentKey, String? paymentMethod, BeanFulfillmentMethod fulfillmentMethod, String? storeId, String? storeName, String? recipient, String? recipientPhone, String? shippingAddress, BeanOrderStatus status, DateTime createdAt
});




}
/// @nodoc
class _$BeanOrderCopyWithImpl<$Res>
    implements $BeanOrderCopyWith<$Res> {
  _$BeanOrderCopyWithImpl(this._self, this._then);

  final BeanOrder _self;
  final $Res Function(BeanOrder) _then;

/// Create a copy of BeanOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? items = null,Object? totalAmount = null,Object? usedPoints = null,Object? earnedPoints = null,Object? couponId = freezed,Object? couponTitle = freezed,Object? couponDiscount = null,Object? paymentKey = freezed,Object? paymentMethod = freezed,Object? fulfillmentMethod = null,Object? storeId = freezed,Object? storeName = freezed,Object? recipient = freezed,Object? recipientPhone = freezed,Object? shippingAddress = freezed,Object? status = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<BeanOrderItem>,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,usedPoints: null == usedPoints ? _self.usedPoints : usedPoints // ignore: cast_nullable_to_non_nullable
as int,earnedPoints: null == earnedPoints ? _self.earnedPoints : earnedPoints // ignore: cast_nullable_to_non_nullable
as int,couponId: freezed == couponId ? _self.couponId : couponId // ignore: cast_nullable_to_non_nullable
as String?,couponTitle: freezed == couponTitle ? _self.couponTitle : couponTitle // ignore: cast_nullable_to_non_nullable
as String?,couponDiscount: null == couponDiscount ? _self.couponDiscount : couponDiscount // ignore: cast_nullable_to_non_nullable
as int,paymentKey: freezed == paymentKey ? _self.paymentKey : paymentKey // ignore: cast_nullable_to_non_nullable
as String?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,fulfillmentMethod: null == fulfillmentMethod ? _self.fulfillmentMethod : fulfillmentMethod // ignore: cast_nullable_to_non_nullable
as BeanFulfillmentMethod,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,recipient: freezed == recipient ? _self.recipient : recipient // ignore: cast_nullable_to_non_nullable
as String?,recipientPhone: freezed == recipientPhone ? _self.recipientPhone : recipientPhone // ignore: cast_nullable_to_non_nullable
as String?,shippingAddress: freezed == shippingAddress ? _self.shippingAddress : shippingAddress // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BeanOrderStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [BeanOrder].
extension BeanOrderPatterns on BeanOrder {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BeanOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BeanOrder() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BeanOrder value)  $default,){
final _that = this;
switch (_that) {
case _BeanOrder():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BeanOrder value)?  $default,){
final _that = this;
switch (_that) {
case _BeanOrder() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  List<BeanOrderItem> items,  int totalAmount,  int usedPoints,  int earnedPoints,  String? couponId,  String? couponTitle,  int couponDiscount,  String? paymentKey,  String? paymentMethod,  BeanFulfillmentMethod fulfillmentMethod,  String? storeId,  String? storeName,  String? recipient,  String? recipientPhone,  String? shippingAddress,  BeanOrderStatus status,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BeanOrder() when $default != null:
return $default(_that.id,_that.items,_that.totalAmount,_that.usedPoints,_that.earnedPoints,_that.couponId,_that.couponTitle,_that.couponDiscount,_that.paymentKey,_that.paymentMethod,_that.fulfillmentMethod,_that.storeId,_that.storeName,_that.recipient,_that.recipientPhone,_that.shippingAddress,_that.status,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  List<BeanOrderItem> items,  int totalAmount,  int usedPoints,  int earnedPoints,  String? couponId,  String? couponTitle,  int couponDiscount,  String? paymentKey,  String? paymentMethod,  BeanFulfillmentMethod fulfillmentMethod,  String? storeId,  String? storeName,  String? recipient,  String? recipientPhone,  String? shippingAddress,  BeanOrderStatus status,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _BeanOrder():
return $default(_that.id,_that.items,_that.totalAmount,_that.usedPoints,_that.earnedPoints,_that.couponId,_that.couponTitle,_that.couponDiscount,_that.paymentKey,_that.paymentMethod,_that.fulfillmentMethod,_that.storeId,_that.storeName,_that.recipient,_that.recipientPhone,_that.shippingAddress,_that.status,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  List<BeanOrderItem> items,  int totalAmount,  int usedPoints,  int earnedPoints,  String? couponId,  String? couponTitle,  int couponDiscount,  String? paymentKey,  String? paymentMethod,  BeanFulfillmentMethod fulfillmentMethod,  String? storeId,  String? storeName,  String? recipient,  String? recipientPhone,  String? shippingAddress,  BeanOrderStatus status,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BeanOrder() when $default != null:
return $default(_that.id,_that.items,_that.totalAmount,_that.usedPoints,_that.earnedPoints,_that.couponId,_that.couponTitle,_that.couponDiscount,_that.paymentKey,_that.paymentMethod,_that.fulfillmentMethod,_that.storeId,_that.storeName,_that.recipient,_that.recipientPhone,_that.shippingAddress,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BeanOrder extends BeanOrder {
  const _BeanOrder({required this.id, required final  List<BeanOrderItem> items, required this.totalAmount, this.usedPoints = 0, this.earnedPoints = 0, this.couponId, this.couponTitle, this.couponDiscount = 0, this.paymentKey, this.paymentMethod, this.fulfillmentMethod = BeanFulfillmentMethod.delivery, this.storeId, this.storeName, this.recipient, this.recipientPhone, this.shippingAddress, this.status = BeanOrderStatus.received, required this.createdAt}): _items = items,super._();
  factory _BeanOrder.fromJson(Map<String, dynamic> json) => _$BeanOrderFromJson(json);

@override final  String id;
 final  List<BeanOrderItem> _items;
@override List<BeanOrderItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int totalAmount;
@override@JsonKey() final  int usedPoints;
@override@JsonKey() final  int earnedPoints;
@override final  String? couponId;
@override final  String? couponTitle;
@override@JsonKey() final  int couponDiscount;
@override final  String? paymentKey;
@override final  String? paymentMethod;
@override@JsonKey() final  BeanFulfillmentMethod fulfillmentMethod;
@override final  String? storeId;
@override final  String? storeName;
@override final  String? recipient;
@override final  String? recipientPhone;
@override final  String? shippingAddress;
@override@JsonKey() final  BeanOrderStatus status;
@override final  DateTime createdAt;

/// Create a copy of BeanOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BeanOrderCopyWith<_BeanOrder> get copyWith => __$BeanOrderCopyWithImpl<_BeanOrder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BeanOrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BeanOrder&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.usedPoints, usedPoints) || other.usedPoints == usedPoints)&&(identical(other.earnedPoints, earnedPoints) || other.earnedPoints == earnedPoints)&&(identical(other.couponId, couponId) || other.couponId == couponId)&&(identical(other.couponTitle, couponTitle) || other.couponTitle == couponTitle)&&(identical(other.couponDiscount, couponDiscount) || other.couponDiscount == couponDiscount)&&(identical(other.paymentKey, paymentKey) || other.paymentKey == paymentKey)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.fulfillmentMethod, fulfillmentMethod) || other.fulfillmentMethod == fulfillmentMethod)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.recipient, recipient) || other.recipient == recipient)&&(identical(other.recipientPhone, recipientPhone) || other.recipientPhone == recipientPhone)&&(identical(other.shippingAddress, shippingAddress) || other.shippingAddress == shippingAddress)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_items),totalAmount,usedPoints,earnedPoints,couponId,couponTitle,couponDiscount,paymentKey,paymentMethod,fulfillmentMethod,storeId,storeName,recipient,recipientPhone,shippingAddress,status,createdAt);

@override
String toString() {
  return 'BeanOrder(id: $id, items: $items, totalAmount: $totalAmount, usedPoints: $usedPoints, earnedPoints: $earnedPoints, couponId: $couponId, couponTitle: $couponTitle, couponDiscount: $couponDiscount, paymentKey: $paymentKey, paymentMethod: $paymentMethod, fulfillmentMethod: $fulfillmentMethod, storeId: $storeId, storeName: $storeName, recipient: $recipient, recipientPhone: $recipientPhone, shippingAddress: $shippingAddress, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BeanOrderCopyWith<$Res> implements $BeanOrderCopyWith<$Res> {
  factory _$BeanOrderCopyWith(_BeanOrder value, $Res Function(_BeanOrder) _then) = __$BeanOrderCopyWithImpl;
@override @useResult
$Res call({
 String id, List<BeanOrderItem> items, int totalAmount, int usedPoints, int earnedPoints, String? couponId, String? couponTitle, int couponDiscount, String? paymentKey, String? paymentMethod, BeanFulfillmentMethod fulfillmentMethod, String? storeId, String? storeName, String? recipient, String? recipientPhone, String? shippingAddress, BeanOrderStatus status, DateTime createdAt
});




}
/// @nodoc
class __$BeanOrderCopyWithImpl<$Res>
    implements _$BeanOrderCopyWith<$Res> {
  __$BeanOrderCopyWithImpl(this._self, this._then);

  final _BeanOrder _self;
  final $Res Function(_BeanOrder) _then;

/// Create a copy of BeanOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? items = null,Object? totalAmount = null,Object? usedPoints = null,Object? earnedPoints = null,Object? couponId = freezed,Object? couponTitle = freezed,Object? couponDiscount = null,Object? paymentKey = freezed,Object? paymentMethod = freezed,Object? fulfillmentMethod = null,Object? storeId = freezed,Object? storeName = freezed,Object? recipient = freezed,Object? recipientPhone = freezed,Object? shippingAddress = freezed,Object? status = null,Object? createdAt = null,}) {
  return _then(_BeanOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<BeanOrderItem>,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,usedPoints: null == usedPoints ? _self.usedPoints : usedPoints // ignore: cast_nullable_to_non_nullable
as int,earnedPoints: null == earnedPoints ? _self.earnedPoints : earnedPoints // ignore: cast_nullable_to_non_nullable
as int,couponId: freezed == couponId ? _self.couponId : couponId // ignore: cast_nullable_to_non_nullable
as String?,couponTitle: freezed == couponTitle ? _self.couponTitle : couponTitle // ignore: cast_nullable_to_non_nullable
as String?,couponDiscount: null == couponDiscount ? _self.couponDiscount : couponDiscount // ignore: cast_nullable_to_non_nullable
as int,paymentKey: freezed == paymentKey ? _self.paymentKey : paymentKey // ignore: cast_nullable_to_non_nullable
as String?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,fulfillmentMethod: null == fulfillmentMethod ? _self.fulfillmentMethod : fulfillmentMethod // ignore: cast_nullable_to_non_nullable
as BeanFulfillmentMethod,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,recipient: freezed == recipient ? _self.recipient : recipient // ignore: cast_nullable_to_non_nullable
as String?,recipientPhone: freezed == recipientPhone ? _self.recipientPhone : recipientPhone // ignore: cast_nullable_to_non_nullable
as String?,shippingAddress: freezed == shippingAddress ? _self.shippingAddress : shippingAddress // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BeanOrderStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
