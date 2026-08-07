// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coupon_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Coupon {

 String get id; String get title; String get description; DateTime get expiresAt; bool get isUsed; int get discountAmount; int get discountRate; int get minOrderAmount;
/// Create a copy of Coupon
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CouponCopyWith<Coupon> get copyWith => _$CouponCopyWithImpl<Coupon>(this as Coupon, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Coupon&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.isUsed, isUsed) || other.isUsed == isUsed)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.discountRate, discountRate) || other.discountRate == discountRate)&&(identical(other.minOrderAmount, minOrderAmount) || other.minOrderAmount == minOrderAmount));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,expiresAt,isUsed,discountAmount,discountRate,minOrderAmount);

@override
String toString() {
  return 'Coupon(id: $id, title: $title, description: $description, expiresAt: $expiresAt, isUsed: $isUsed, discountAmount: $discountAmount, discountRate: $discountRate, minOrderAmount: $minOrderAmount)';
}


}

/// @nodoc
abstract mixin class $CouponCopyWith<$Res>  {
  factory $CouponCopyWith(Coupon value, $Res Function(Coupon) _then) = _$CouponCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, DateTime expiresAt, bool isUsed, int discountAmount, int discountRate, int minOrderAmount
});




}
/// @nodoc
class _$CouponCopyWithImpl<$Res>
    implements $CouponCopyWith<$Res> {
  _$CouponCopyWithImpl(this._self, this._then);

  final Coupon _self;
  final $Res Function(Coupon) _then;

/// Create a copy of Coupon
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? expiresAt = null,Object? isUsed = null,Object? discountAmount = null,Object? discountRate = null,Object? minOrderAmount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,isUsed: null == isUsed ? _self.isUsed : isUsed // ignore: cast_nullable_to_non_nullable
as bool,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as int,discountRate: null == discountRate ? _self.discountRate : discountRate // ignore: cast_nullable_to_non_nullable
as int,minOrderAmount: null == minOrderAmount ? _self.minOrderAmount : minOrderAmount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Coupon].
extension CouponPatterns on Coupon {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Coupon value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Coupon() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Coupon value)  $default,){
final _that = this;
switch (_that) {
case _Coupon():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Coupon value)?  $default,){
final _that = this;
switch (_that) {
case _Coupon() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  DateTime expiresAt,  bool isUsed,  int discountAmount,  int discountRate,  int minOrderAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Coupon() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.expiresAt,_that.isUsed,_that.discountAmount,_that.discountRate,_that.minOrderAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  DateTime expiresAt,  bool isUsed,  int discountAmount,  int discountRate,  int minOrderAmount)  $default,) {final _that = this;
switch (_that) {
case _Coupon():
return $default(_that.id,_that.title,_that.description,_that.expiresAt,_that.isUsed,_that.discountAmount,_that.discountRate,_that.minOrderAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  DateTime expiresAt,  bool isUsed,  int discountAmount,  int discountRate,  int minOrderAmount)?  $default,) {final _that = this;
switch (_that) {
case _Coupon() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.expiresAt,_that.isUsed,_that.discountAmount,_that.discountRate,_that.minOrderAmount);case _:
  return null;

}
}

}

/// @nodoc


class _Coupon extends Coupon {
  const _Coupon({required this.id, required this.title, required this.description, required this.expiresAt, this.isUsed = false, this.discountAmount = 0, this.discountRate = 0, this.minOrderAmount = 0}): super._();
  

@override final  String id;
@override final  String title;
@override final  String description;
@override final  DateTime expiresAt;
@override@JsonKey() final  bool isUsed;
@override@JsonKey() final  int discountAmount;
@override@JsonKey() final  int discountRate;
@override@JsonKey() final  int minOrderAmount;

/// Create a copy of Coupon
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CouponCopyWith<_Coupon> get copyWith => __$CouponCopyWithImpl<_Coupon>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Coupon&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.isUsed, isUsed) || other.isUsed == isUsed)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.discountRate, discountRate) || other.discountRate == discountRate)&&(identical(other.minOrderAmount, minOrderAmount) || other.minOrderAmount == minOrderAmount));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,expiresAt,isUsed,discountAmount,discountRate,minOrderAmount);

@override
String toString() {
  return 'Coupon(id: $id, title: $title, description: $description, expiresAt: $expiresAt, isUsed: $isUsed, discountAmount: $discountAmount, discountRate: $discountRate, minOrderAmount: $minOrderAmount)';
}


}

/// @nodoc
abstract mixin class _$CouponCopyWith<$Res> implements $CouponCopyWith<$Res> {
  factory _$CouponCopyWith(_Coupon value, $Res Function(_Coupon) _then) = __$CouponCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, DateTime expiresAt, bool isUsed, int discountAmount, int discountRate, int minOrderAmount
});




}
/// @nodoc
class __$CouponCopyWithImpl<$Res>
    implements _$CouponCopyWith<$Res> {
  __$CouponCopyWithImpl(this._self, this._then);

  final _Coupon _self;
  final $Res Function(_Coupon) _then;

/// Create a copy of Coupon
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? expiresAt = null,Object? isUsed = null,Object? discountAmount = null,Object? discountRate = null,Object? minOrderAmount = null,}) {
  return _then(_Coupon(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,isUsed: null == isUsed ? _self.isUsed : isUsed // ignore: cast_nullable_to_non_nullable
as bool,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as int,discountRate: null == discountRate ? _self.discountRate : discountRate // ignore: cast_nullable_to_non_nullable
as int,minOrderAmount: null == minOrderAmount ? _self.minOrderAmount : minOrderAmount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
