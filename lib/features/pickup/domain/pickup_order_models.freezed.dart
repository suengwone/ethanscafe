// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pickup_order_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PickupOrderItem {

 String get menuId; String get menuName; String? get option; int get quantity; int get unitPrice;
/// Create a copy of PickupOrderItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PickupOrderItemCopyWith<PickupOrderItem> get copyWith => _$PickupOrderItemCopyWithImpl<PickupOrderItem>(this as PickupOrderItem, _$identity);

  /// Serializes this PickupOrderItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PickupOrderItem&&(identical(other.menuId, menuId) || other.menuId == menuId)&&(identical(other.menuName, menuName) || other.menuName == menuName)&&(identical(other.option, option) || other.option == option)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,menuId,menuName,option,quantity,unitPrice);

@override
String toString() {
  return 'PickupOrderItem(menuId: $menuId, menuName: $menuName, option: $option, quantity: $quantity, unitPrice: $unitPrice)';
}


}

/// @nodoc
abstract mixin class $PickupOrderItemCopyWith<$Res>  {
  factory $PickupOrderItemCopyWith(PickupOrderItem value, $Res Function(PickupOrderItem) _then) = _$PickupOrderItemCopyWithImpl;
@useResult
$Res call({
 String menuId, String menuName, String? option, int quantity, int unitPrice
});




}
/// @nodoc
class _$PickupOrderItemCopyWithImpl<$Res>
    implements $PickupOrderItemCopyWith<$Res> {
  _$PickupOrderItemCopyWithImpl(this._self, this._then);

  final PickupOrderItem _self;
  final $Res Function(PickupOrderItem) _then;

/// Create a copy of PickupOrderItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? menuId = null,Object? menuName = null,Object? option = freezed,Object? quantity = null,Object? unitPrice = null,}) {
  return _then(_self.copyWith(
menuId: null == menuId ? _self.menuId : menuId // ignore: cast_nullable_to_non_nullable
as String,menuName: null == menuName ? _self.menuName : menuName // ignore: cast_nullable_to_non_nullable
as String,option: freezed == option ? _self.option : option // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PickupOrderItem].
extension PickupOrderItemPatterns on PickupOrderItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PickupOrderItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PickupOrderItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PickupOrderItem value)  $default,){
final _that = this;
switch (_that) {
case _PickupOrderItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PickupOrderItem value)?  $default,){
final _that = this;
switch (_that) {
case _PickupOrderItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String menuId,  String menuName,  String? option,  int quantity,  int unitPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PickupOrderItem() when $default != null:
return $default(_that.menuId,_that.menuName,_that.option,_that.quantity,_that.unitPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String menuId,  String menuName,  String? option,  int quantity,  int unitPrice)  $default,) {final _that = this;
switch (_that) {
case _PickupOrderItem():
return $default(_that.menuId,_that.menuName,_that.option,_that.quantity,_that.unitPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String menuId,  String menuName,  String? option,  int quantity,  int unitPrice)?  $default,) {final _that = this;
switch (_that) {
case _PickupOrderItem() when $default != null:
return $default(_that.menuId,_that.menuName,_that.option,_that.quantity,_that.unitPrice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PickupOrderItem extends PickupOrderItem {
  const _PickupOrderItem({required this.menuId, required this.menuName, this.option, required this.quantity, required this.unitPrice}): super._();
  factory _PickupOrderItem.fromJson(Map<String, dynamic> json) => _$PickupOrderItemFromJson(json);

@override final  String menuId;
@override final  String menuName;
@override final  String? option;
@override final  int quantity;
@override final  int unitPrice;

/// Create a copy of PickupOrderItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PickupOrderItemCopyWith<_PickupOrderItem> get copyWith => __$PickupOrderItemCopyWithImpl<_PickupOrderItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PickupOrderItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PickupOrderItem&&(identical(other.menuId, menuId) || other.menuId == menuId)&&(identical(other.menuName, menuName) || other.menuName == menuName)&&(identical(other.option, option) || other.option == option)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,menuId,menuName,option,quantity,unitPrice);

@override
String toString() {
  return 'PickupOrderItem(menuId: $menuId, menuName: $menuName, option: $option, quantity: $quantity, unitPrice: $unitPrice)';
}


}

/// @nodoc
abstract mixin class _$PickupOrderItemCopyWith<$Res> implements $PickupOrderItemCopyWith<$Res> {
  factory _$PickupOrderItemCopyWith(_PickupOrderItem value, $Res Function(_PickupOrderItem) _then) = __$PickupOrderItemCopyWithImpl;
@override @useResult
$Res call({
 String menuId, String menuName, String? option, int quantity, int unitPrice
});




}
/// @nodoc
class __$PickupOrderItemCopyWithImpl<$Res>
    implements _$PickupOrderItemCopyWith<$Res> {
  __$PickupOrderItemCopyWithImpl(this._self, this._then);

  final _PickupOrderItem _self;
  final $Res Function(_PickupOrderItem) _then;

/// Create a copy of PickupOrderItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? menuId = null,Object? menuName = null,Object? option = freezed,Object? quantity = null,Object? unitPrice = null,}) {
  return _then(_PickupOrderItem(
menuId: null == menuId ? _self.menuId : menuId // ignore: cast_nullable_to_non_nullable
as String,menuName: null == menuName ? _self.menuName : menuName // ignore: cast_nullable_to_non_nullable
as String,option: freezed == option ? _self.option : option // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PickupOrder {

 String get id; String get storeId; String get storeName; int get pickupNumber; List<PickupOrderItem> get items; int get totalAmount; int get usedPoints; int get earnedPoints; String? get couponId; String? get couponTitle; int get couponDiscount; String? get paymentKey; String? get paymentMethod; PickupOrderStatus get status; RefundStatus? get refundStatus; DateTime get createdAt;
/// Create a copy of PickupOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PickupOrderCopyWith<PickupOrder> get copyWith => _$PickupOrderCopyWithImpl<PickupOrder>(this as PickupOrder, _$identity);

  /// Serializes this PickupOrder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PickupOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.pickupNumber, pickupNumber) || other.pickupNumber == pickupNumber)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.usedPoints, usedPoints) || other.usedPoints == usedPoints)&&(identical(other.earnedPoints, earnedPoints) || other.earnedPoints == earnedPoints)&&(identical(other.couponId, couponId) || other.couponId == couponId)&&(identical(other.couponTitle, couponTitle) || other.couponTitle == couponTitle)&&(identical(other.couponDiscount, couponDiscount) || other.couponDiscount == couponDiscount)&&(identical(other.paymentKey, paymentKey) || other.paymentKey == paymentKey)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.status, status) || other.status == status)&&(identical(other.refundStatus, refundStatus) || other.refundStatus == refundStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeId,storeName,pickupNumber,const DeepCollectionEquality().hash(items),totalAmount,usedPoints,earnedPoints,couponId,couponTitle,couponDiscount,paymentKey,paymentMethod,status,refundStatus,createdAt);

@override
String toString() {
  return 'PickupOrder(id: $id, storeId: $storeId, storeName: $storeName, pickupNumber: $pickupNumber, items: $items, totalAmount: $totalAmount, usedPoints: $usedPoints, earnedPoints: $earnedPoints, couponId: $couponId, couponTitle: $couponTitle, couponDiscount: $couponDiscount, paymentKey: $paymentKey, paymentMethod: $paymentMethod, status: $status, refundStatus: $refundStatus, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PickupOrderCopyWith<$Res>  {
  factory $PickupOrderCopyWith(PickupOrder value, $Res Function(PickupOrder) _then) = _$PickupOrderCopyWithImpl;
@useResult
$Res call({
 String id, String storeId, String storeName, int pickupNumber, List<PickupOrderItem> items, int totalAmount, int usedPoints, int earnedPoints, String? couponId, String? couponTitle, int couponDiscount, String? paymentKey, String? paymentMethod, PickupOrderStatus status, RefundStatus? refundStatus, DateTime createdAt
});




}
/// @nodoc
class _$PickupOrderCopyWithImpl<$Res>
    implements $PickupOrderCopyWith<$Res> {
  _$PickupOrderCopyWithImpl(this._self, this._then);

  final PickupOrder _self;
  final $Res Function(PickupOrder) _then;

/// Create a copy of PickupOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? storeId = null,Object? storeName = null,Object? pickupNumber = null,Object? items = null,Object? totalAmount = null,Object? usedPoints = null,Object? earnedPoints = null,Object? couponId = freezed,Object? couponTitle = freezed,Object? couponDiscount = null,Object? paymentKey = freezed,Object? paymentMethod = freezed,Object? status = null,Object? refundStatus = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,pickupNumber: null == pickupNumber ? _self.pickupNumber : pickupNumber // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<PickupOrderItem>,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,usedPoints: null == usedPoints ? _self.usedPoints : usedPoints // ignore: cast_nullable_to_non_nullable
as int,earnedPoints: null == earnedPoints ? _self.earnedPoints : earnedPoints // ignore: cast_nullable_to_non_nullable
as int,couponId: freezed == couponId ? _self.couponId : couponId // ignore: cast_nullable_to_non_nullable
as String?,couponTitle: freezed == couponTitle ? _self.couponTitle : couponTitle // ignore: cast_nullable_to_non_nullable
as String?,couponDiscount: null == couponDiscount ? _self.couponDiscount : couponDiscount // ignore: cast_nullable_to_non_nullable
as int,paymentKey: freezed == paymentKey ? _self.paymentKey : paymentKey // ignore: cast_nullable_to_non_nullable
as String?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PickupOrderStatus,refundStatus: freezed == refundStatus ? _self.refundStatus : refundStatus // ignore: cast_nullable_to_non_nullable
as RefundStatus?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PickupOrder].
extension PickupOrderPatterns on PickupOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PickupOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PickupOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PickupOrder value)  $default,){
final _that = this;
switch (_that) {
case _PickupOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PickupOrder value)?  $default,){
final _that = this;
switch (_that) {
case _PickupOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String storeId,  String storeName,  int pickupNumber,  List<PickupOrderItem> items,  int totalAmount,  int usedPoints,  int earnedPoints,  String? couponId,  String? couponTitle,  int couponDiscount,  String? paymentKey,  String? paymentMethod,  PickupOrderStatus status,  RefundStatus? refundStatus,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PickupOrder() when $default != null:
return $default(_that.id,_that.storeId,_that.storeName,_that.pickupNumber,_that.items,_that.totalAmount,_that.usedPoints,_that.earnedPoints,_that.couponId,_that.couponTitle,_that.couponDiscount,_that.paymentKey,_that.paymentMethod,_that.status,_that.refundStatus,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String storeId,  String storeName,  int pickupNumber,  List<PickupOrderItem> items,  int totalAmount,  int usedPoints,  int earnedPoints,  String? couponId,  String? couponTitle,  int couponDiscount,  String? paymentKey,  String? paymentMethod,  PickupOrderStatus status,  RefundStatus? refundStatus,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _PickupOrder():
return $default(_that.id,_that.storeId,_that.storeName,_that.pickupNumber,_that.items,_that.totalAmount,_that.usedPoints,_that.earnedPoints,_that.couponId,_that.couponTitle,_that.couponDiscount,_that.paymentKey,_that.paymentMethod,_that.status,_that.refundStatus,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String storeId,  String storeName,  int pickupNumber,  List<PickupOrderItem> items,  int totalAmount,  int usedPoints,  int earnedPoints,  String? couponId,  String? couponTitle,  int couponDiscount,  String? paymentKey,  String? paymentMethod,  PickupOrderStatus status,  RefundStatus? refundStatus,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PickupOrder() when $default != null:
return $default(_that.id,_that.storeId,_that.storeName,_that.pickupNumber,_that.items,_that.totalAmount,_that.usedPoints,_that.earnedPoints,_that.couponId,_that.couponTitle,_that.couponDiscount,_that.paymentKey,_that.paymentMethod,_that.status,_that.refundStatus,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PickupOrder extends PickupOrder {
  const _PickupOrder({required this.id, required this.storeId, required this.storeName, required this.pickupNumber, required final  List<PickupOrderItem> items, required this.totalAmount, this.usedPoints = 0, this.earnedPoints = 0, this.couponId, this.couponTitle, this.couponDiscount = 0, this.paymentKey, this.paymentMethod, this.status = PickupOrderStatus.received, this.refundStatus, required this.createdAt}): _items = items,super._();
  factory _PickupOrder.fromJson(Map<String, dynamic> json) => _$PickupOrderFromJson(json);

@override final  String id;
@override final  String storeId;
@override final  String storeName;
@override final  int pickupNumber;
 final  List<PickupOrderItem> _items;
@override List<PickupOrderItem> get items {
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
@override@JsonKey() final  PickupOrderStatus status;
@override final  RefundStatus? refundStatus;
@override final  DateTime createdAt;

/// Create a copy of PickupOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PickupOrderCopyWith<_PickupOrder> get copyWith => __$PickupOrderCopyWithImpl<_PickupOrder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PickupOrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PickupOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.pickupNumber, pickupNumber) || other.pickupNumber == pickupNumber)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.usedPoints, usedPoints) || other.usedPoints == usedPoints)&&(identical(other.earnedPoints, earnedPoints) || other.earnedPoints == earnedPoints)&&(identical(other.couponId, couponId) || other.couponId == couponId)&&(identical(other.couponTitle, couponTitle) || other.couponTitle == couponTitle)&&(identical(other.couponDiscount, couponDiscount) || other.couponDiscount == couponDiscount)&&(identical(other.paymentKey, paymentKey) || other.paymentKey == paymentKey)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.status, status) || other.status == status)&&(identical(other.refundStatus, refundStatus) || other.refundStatus == refundStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeId,storeName,pickupNumber,const DeepCollectionEquality().hash(_items),totalAmount,usedPoints,earnedPoints,couponId,couponTitle,couponDiscount,paymentKey,paymentMethod,status,refundStatus,createdAt);

@override
String toString() {
  return 'PickupOrder(id: $id, storeId: $storeId, storeName: $storeName, pickupNumber: $pickupNumber, items: $items, totalAmount: $totalAmount, usedPoints: $usedPoints, earnedPoints: $earnedPoints, couponId: $couponId, couponTitle: $couponTitle, couponDiscount: $couponDiscount, paymentKey: $paymentKey, paymentMethod: $paymentMethod, status: $status, refundStatus: $refundStatus, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PickupOrderCopyWith<$Res> implements $PickupOrderCopyWith<$Res> {
  factory _$PickupOrderCopyWith(_PickupOrder value, $Res Function(_PickupOrder) _then) = __$PickupOrderCopyWithImpl;
@override @useResult
$Res call({
 String id, String storeId, String storeName, int pickupNumber, List<PickupOrderItem> items, int totalAmount, int usedPoints, int earnedPoints, String? couponId, String? couponTitle, int couponDiscount, String? paymentKey, String? paymentMethod, PickupOrderStatus status, RefundStatus? refundStatus, DateTime createdAt
});




}
/// @nodoc
class __$PickupOrderCopyWithImpl<$Res>
    implements _$PickupOrderCopyWith<$Res> {
  __$PickupOrderCopyWithImpl(this._self, this._then);

  final _PickupOrder _self;
  final $Res Function(_PickupOrder) _then;

/// Create a copy of PickupOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? storeId = null,Object? storeName = null,Object? pickupNumber = null,Object? items = null,Object? totalAmount = null,Object? usedPoints = null,Object? earnedPoints = null,Object? couponId = freezed,Object? couponTitle = freezed,Object? couponDiscount = null,Object? paymentKey = freezed,Object? paymentMethod = freezed,Object? status = null,Object? refundStatus = freezed,Object? createdAt = null,}) {
  return _then(_PickupOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,pickupNumber: null == pickupNumber ? _self.pickupNumber : pickupNumber // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<PickupOrderItem>,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,usedPoints: null == usedPoints ? _self.usedPoints : usedPoints // ignore: cast_nullable_to_non_nullable
as int,earnedPoints: null == earnedPoints ? _self.earnedPoints : earnedPoints // ignore: cast_nullable_to_non_nullable
as int,couponId: freezed == couponId ? _self.couponId : couponId // ignore: cast_nullable_to_non_nullable
as String?,couponTitle: freezed == couponTitle ? _self.couponTitle : couponTitle // ignore: cast_nullable_to_non_nullable
as String?,couponDiscount: null == couponDiscount ? _self.couponDiscount : couponDiscount // ignore: cast_nullable_to_non_nullable
as int,paymentKey: freezed == paymentKey ? _self.paymentKey : paymentKey // ignore: cast_nullable_to_non_nullable
as String?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PickupOrderStatus,refundStatus: freezed == refundStatus ? _self.refundStatus : refundStatus // ignore: cast_nullable_to_non_nullable
as RefundStatus?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
