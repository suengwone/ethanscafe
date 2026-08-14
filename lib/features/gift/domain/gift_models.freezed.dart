// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gift_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BeanGift {

 String get id; String get beanId; String get beanName; BeanWeight get weight; GrindOption get grind; int get quantity; int get unitPrice; String get recipientName; String get recipientPhone; String get message; BeanGiftStatus get status; DateTime get createdAt;
/// Create a copy of BeanGift
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BeanGiftCopyWith<BeanGift> get copyWith => _$BeanGiftCopyWithImpl<BeanGift>(this as BeanGift, _$identity);

  /// Serializes this BeanGift to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BeanGift&&(identical(other.id, id) || other.id == id)&&(identical(other.beanId, beanId) || other.beanId == beanId)&&(identical(other.beanName, beanName) || other.beanName == beanName)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.grind, grind) || other.grind == grind)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.recipientName, recipientName) || other.recipientName == recipientName)&&(identical(other.recipientPhone, recipientPhone) || other.recipientPhone == recipientPhone)&&(identical(other.message, message) || other.message == message)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,beanId,beanName,weight,grind,quantity,unitPrice,recipientName,recipientPhone,message,status,createdAt);

@override
String toString() {
  return 'BeanGift(id: $id, beanId: $beanId, beanName: $beanName, weight: $weight, grind: $grind, quantity: $quantity, unitPrice: $unitPrice, recipientName: $recipientName, recipientPhone: $recipientPhone, message: $message, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BeanGiftCopyWith<$Res>  {
  factory $BeanGiftCopyWith(BeanGift value, $Res Function(BeanGift) _then) = _$BeanGiftCopyWithImpl;
@useResult
$Res call({
 String id, String beanId, String beanName, BeanWeight weight, GrindOption grind, int quantity, int unitPrice, String recipientName, String recipientPhone, String message, BeanGiftStatus status, DateTime createdAt
});




}
/// @nodoc
class _$BeanGiftCopyWithImpl<$Res>
    implements $BeanGiftCopyWith<$Res> {
  _$BeanGiftCopyWithImpl(this._self, this._then);

  final BeanGift _self;
  final $Res Function(BeanGift) _then;

/// Create a copy of BeanGift
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? beanId = null,Object? beanName = null,Object? weight = null,Object? grind = null,Object? quantity = null,Object? unitPrice = null,Object? recipientName = null,Object? recipientPhone = null,Object? message = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,beanId: null == beanId ? _self.beanId : beanId // ignore: cast_nullable_to_non_nullable
as String,beanName: null == beanName ? _self.beanName : beanName // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as BeanWeight,grind: null == grind ? _self.grind : grind // ignore: cast_nullable_to_non_nullable
as GrindOption,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,recipientName: null == recipientName ? _self.recipientName : recipientName // ignore: cast_nullable_to_non_nullable
as String,recipientPhone: null == recipientPhone ? _self.recipientPhone : recipientPhone // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BeanGiftStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [BeanGift].
extension BeanGiftPatterns on BeanGift {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BeanGift value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BeanGift() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BeanGift value)  $default,){
final _that = this;
switch (_that) {
case _BeanGift():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BeanGift value)?  $default,){
final _that = this;
switch (_that) {
case _BeanGift() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String beanId,  String beanName,  BeanWeight weight,  GrindOption grind,  int quantity,  int unitPrice,  String recipientName,  String recipientPhone,  String message,  BeanGiftStatus status,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BeanGift() when $default != null:
return $default(_that.id,_that.beanId,_that.beanName,_that.weight,_that.grind,_that.quantity,_that.unitPrice,_that.recipientName,_that.recipientPhone,_that.message,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String beanId,  String beanName,  BeanWeight weight,  GrindOption grind,  int quantity,  int unitPrice,  String recipientName,  String recipientPhone,  String message,  BeanGiftStatus status,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _BeanGift():
return $default(_that.id,_that.beanId,_that.beanName,_that.weight,_that.grind,_that.quantity,_that.unitPrice,_that.recipientName,_that.recipientPhone,_that.message,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String beanId,  String beanName,  BeanWeight weight,  GrindOption grind,  int quantity,  int unitPrice,  String recipientName,  String recipientPhone,  String message,  BeanGiftStatus status,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BeanGift() when $default != null:
return $default(_that.id,_that.beanId,_that.beanName,_that.weight,_that.grind,_that.quantity,_that.unitPrice,_that.recipientName,_that.recipientPhone,_that.message,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BeanGift extends BeanGift {
  const _BeanGift({required this.id, required this.beanId, required this.beanName, required this.weight, required this.grind, required this.quantity, required this.unitPrice, required this.recipientName, required this.recipientPhone, this.message = '', this.status = BeanGiftStatus.sent, required this.createdAt}): super._();
  factory _BeanGift.fromJson(Map<String, dynamic> json) => _$BeanGiftFromJson(json);

@override final  String id;
@override final  String beanId;
@override final  String beanName;
@override final  BeanWeight weight;
@override final  GrindOption grind;
@override final  int quantity;
@override final  int unitPrice;
@override final  String recipientName;
@override final  String recipientPhone;
@override@JsonKey() final  String message;
@override@JsonKey() final  BeanGiftStatus status;
@override final  DateTime createdAt;

/// Create a copy of BeanGift
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BeanGiftCopyWith<_BeanGift> get copyWith => __$BeanGiftCopyWithImpl<_BeanGift>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BeanGiftToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BeanGift&&(identical(other.id, id) || other.id == id)&&(identical(other.beanId, beanId) || other.beanId == beanId)&&(identical(other.beanName, beanName) || other.beanName == beanName)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.grind, grind) || other.grind == grind)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.recipientName, recipientName) || other.recipientName == recipientName)&&(identical(other.recipientPhone, recipientPhone) || other.recipientPhone == recipientPhone)&&(identical(other.message, message) || other.message == message)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,beanId,beanName,weight,grind,quantity,unitPrice,recipientName,recipientPhone,message,status,createdAt);

@override
String toString() {
  return 'BeanGift(id: $id, beanId: $beanId, beanName: $beanName, weight: $weight, grind: $grind, quantity: $quantity, unitPrice: $unitPrice, recipientName: $recipientName, recipientPhone: $recipientPhone, message: $message, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BeanGiftCopyWith<$Res> implements $BeanGiftCopyWith<$Res> {
  factory _$BeanGiftCopyWith(_BeanGift value, $Res Function(_BeanGift) _then) = __$BeanGiftCopyWithImpl;
@override @useResult
$Res call({
 String id, String beanId, String beanName, BeanWeight weight, GrindOption grind, int quantity, int unitPrice, String recipientName, String recipientPhone, String message, BeanGiftStatus status, DateTime createdAt
});




}
/// @nodoc
class __$BeanGiftCopyWithImpl<$Res>
    implements _$BeanGiftCopyWith<$Res> {
  __$BeanGiftCopyWithImpl(this._self, this._then);

  final _BeanGift _self;
  final $Res Function(_BeanGift) _then;

/// Create a copy of BeanGift
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? beanId = null,Object? beanName = null,Object? weight = null,Object? grind = null,Object? quantity = null,Object? unitPrice = null,Object? recipientName = null,Object? recipientPhone = null,Object? message = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_BeanGift(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,beanId: null == beanId ? _self.beanId : beanId // ignore: cast_nullable_to_non_nullable
as String,beanName: null == beanName ? _self.beanName : beanName // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as BeanWeight,grind: null == grind ? _self.grind : grind // ignore: cast_nullable_to_non_nullable
as GrindOption,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,recipientName: null == recipientName ? _self.recipientName : recipientName // ignore: cast_nullable_to_non_nullable
as String,recipientPhone: null == recipientPhone ? _self.recipientPhone : recipientPhone // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BeanGiftStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
