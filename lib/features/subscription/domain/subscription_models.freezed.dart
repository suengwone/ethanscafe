// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BeanSubscription {

 String get id; String get beanId; String get beanName; BeanWeight get weight; GrindOption get grind; int get quantity; SubscriptionCycle get cycle; int get unitPrice; SubscriptionStatus get status; DateTime get nextDeliveryDate; DateTime get createdAt;
/// Create a copy of BeanSubscription
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BeanSubscriptionCopyWith<BeanSubscription> get copyWith => _$BeanSubscriptionCopyWithImpl<BeanSubscription>(this as BeanSubscription, _$identity);

  /// Serializes this BeanSubscription to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BeanSubscription&&(identical(other.id, id) || other.id == id)&&(identical(other.beanId, beanId) || other.beanId == beanId)&&(identical(other.beanName, beanName) || other.beanName == beanName)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.grind, grind) || other.grind == grind)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.cycle, cycle) || other.cycle == cycle)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.status, status) || other.status == status)&&(identical(other.nextDeliveryDate, nextDeliveryDate) || other.nextDeliveryDate == nextDeliveryDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,beanId,beanName,weight,grind,quantity,cycle,unitPrice,status,nextDeliveryDate,createdAt);

@override
String toString() {
  return 'BeanSubscription(id: $id, beanId: $beanId, beanName: $beanName, weight: $weight, grind: $grind, quantity: $quantity, cycle: $cycle, unitPrice: $unitPrice, status: $status, nextDeliveryDate: $nextDeliveryDate, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BeanSubscriptionCopyWith<$Res>  {
  factory $BeanSubscriptionCopyWith(BeanSubscription value, $Res Function(BeanSubscription) _then) = _$BeanSubscriptionCopyWithImpl;
@useResult
$Res call({
 String id, String beanId, String beanName, BeanWeight weight, GrindOption grind, int quantity, SubscriptionCycle cycle, int unitPrice, SubscriptionStatus status, DateTime nextDeliveryDate, DateTime createdAt
});




}
/// @nodoc
class _$BeanSubscriptionCopyWithImpl<$Res>
    implements $BeanSubscriptionCopyWith<$Res> {
  _$BeanSubscriptionCopyWithImpl(this._self, this._then);

  final BeanSubscription _self;
  final $Res Function(BeanSubscription) _then;

/// Create a copy of BeanSubscription
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? beanId = null,Object? beanName = null,Object? weight = null,Object? grind = null,Object? quantity = null,Object? cycle = null,Object? unitPrice = null,Object? status = null,Object? nextDeliveryDate = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,beanId: null == beanId ? _self.beanId : beanId // ignore: cast_nullable_to_non_nullable
as String,beanName: null == beanName ? _self.beanName : beanName // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as BeanWeight,grind: null == grind ? _self.grind : grind // ignore: cast_nullable_to_non_nullable
as GrindOption,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,cycle: null == cycle ? _self.cycle : cycle // ignore: cast_nullable_to_non_nullable
as SubscriptionCycle,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SubscriptionStatus,nextDeliveryDate: null == nextDeliveryDate ? _self.nextDeliveryDate : nextDeliveryDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [BeanSubscription].
extension BeanSubscriptionPatterns on BeanSubscription {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BeanSubscription value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BeanSubscription() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BeanSubscription value)  $default,){
final _that = this;
switch (_that) {
case _BeanSubscription():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BeanSubscription value)?  $default,){
final _that = this;
switch (_that) {
case _BeanSubscription() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String beanId,  String beanName,  BeanWeight weight,  GrindOption grind,  int quantity,  SubscriptionCycle cycle,  int unitPrice,  SubscriptionStatus status,  DateTime nextDeliveryDate,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BeanSubscription() when $default != null:
return $default(_that.id,_that.beanId,_that.beanName,_that.weight,_that.grind,_that.quantity,_that.cycle,_that.unitPrice,_that.status,_that.nextDeliveryDate,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String beanId,  String beanName,  BeanWeight weight,  GrindOption grind,  int quantity,  SubscriptionCycle cycle,  int unitPrice,  SubscriptionStatus status,  DateTime nextDeliveryDate,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _BeanSubscription():
return $default(_that.id,_that.beanId,_that.beanName,_that.weight,_that.grind,_that.quantity,_that.cycle,_that.unitPrice,_that.status,_that.nextDeliveryDate,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String beanId,  String beanName,  BeanWeight weight,  GrindOption grind,  int quantity,  SubscriptionCycle cycle,  int unitPrice,  SubscriptionStatus status,  DateTime nextDeliveryDate,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BeanSubscription() when $default != null:
return $default(_that.id,_that.beanId,_that.beanName,_that.weight,_that.grind,_that.quantity,_that.cycle,_that.unitPrice,_that.status,_that.nextDeliveryDate,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BeanSubscription extends BeanSubscription {
  const _BeanSubscription({required this.id, required this.beanId, required this.beanName, required this.weight, required this.grind, required this.quantity, required this.cycle, required this.unitPrice, this.status = SubscriptionStatus.active, required this.nextDeliveryDate, required this.createdAt}): super._();
  factory _BeanSubscription.fromJson(Map<String, dynamic> json) => _$BeanSubscriptionFromJson(json);

@override final  String id;
@override final  String beanId;
@override final  String beanName;
@override final  BeanWeight weight;
@override final  GrindOption grind;
@override final  int quantity;
@override final  SubscriptionCycle cycle;
@override final  int unitPrice;
@override@JsonKey() final  SubscriptionStatus status;
@override final  DateTime nextDeliveryDate;
@override final  DateTime createdAt;

/// Create a copy of BeanSubscription
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BeanSubscriptionCopyWith<_BeanSubscription> get copyWith => __$BeanSubscriptionCopyWithImpl<_BeanSubscription>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BeanSubscriptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BeanSubscription&&(identical(other.id, id) || other.id == id)&&(identical(other.beanId, beanId) || other.beanId == beanId)&&(identical(other.beanName, beanName) || other.beanName == beanName)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.grind, grind) || other.grind == grind)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.cycle, cycle) || other.cycle == cycle)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.status, status) || other.status == status)&&(identical(other.nextDeliveryDate, nextDeliveryDate) || other.nextDeliveryDate == nextDeliveryDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,beanId,beanName,weight,grind,quantity,cycle,unitPrice,status,nextDeliveryDate,createdAt);

@override
String toString() {
  return 'BeanSubscription(id: $id, beanId: $beanId, beanName: $beanName, weight: $weight, grind: $grind, quantity: $quantity, cycle: $cycle, unitPrice: $unitPrice, status: $status, nextDeliveryDate: $nextDeliveryDate, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BeanSubscriptionCopyWith<$Res> implements $BeanSubscriptionCopyWith<$Res> {
  factory _$BeanSubscriptionCopyWith(_BeanSubscription value, $Res Function(_BeanSubscription) _then) = __$BeanSubscriptionCopyWithImpl;
@override @useResult
$Res call({
 String id, String beanId, String beanName, BeanWeight weight, GrindOption grind, int quantity, SubscriptionCycle cycle, int unitPrice, SubscriptionStatus status, DateTime nextDeliveryDate, DateTime createdAt
});




}
/// @nodoc
class __$BeanSubscriptionCopyWithImpl<$Res>
    implements _$BeanSubscriptionCopyWith<$Res> {
  __$BeanSubscriptionCopyWithImpl(this._self, this._then);

  final _BeanSubscription _self;
  final $Res Function(_BeanSubscription) _then;

/// Create a copy of BeanSubscription
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? beanId = null,Object? beanName = null,Object? weight = null,Object? grind = null,Object? quantity = null,Object? cycle = null,Object? unitPrice = null,Object? status = null,Object? nextDeliveryDate = null,Object? createdAt = null,}) {
  return _then(_BeanSubscription(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,beanId: null == beanId ? _self.beanId : beanId // ignore: cast_nullable_to_non_nullable
as String,beanName: null == beanName ? _self.beanName : beanName // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as BeanWeight,grind: null == grind ? _self.grind : grind // ignore: cast_nullable_to_non_nullable
as GrindOption,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,cycle: null == cycle ? _self.cycle : cycle // ignore: cast_nullable_to_non_nullable
as SubscriptionCycle,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SubscriptionStatus,nextDeliveryDate: null == nextDeliveryDate ? _self.nextDeliveryDate : nextDeliveryDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
