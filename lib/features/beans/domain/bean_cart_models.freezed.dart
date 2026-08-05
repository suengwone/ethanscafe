// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bean_cart_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BeanCartItem {

 Bean get bean; BeanWeight get weight; GrindOption get grind; int get quantity;
/// Create a copy of BeanCartItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BeanCartItemCopyWith<BeanCartItem> get copyWith => _$BeanCartItemCopyWithImpl<BeanCartItem>(this as BeanCartItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BeanCartItem&&(identical(other.bean, bean) || other.bean == bean)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.grind, grind) || other.grind == grind)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,bean,weight,grind,quantity);

@override
String toString() {
  return 'BeanCartItem(bean: $bean, weight: $weight, grind: $grind, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $BeanCartItemCopyWith<$Res>  {
  factory $BeanCartItemCopyWith(BeanCartItem value, $Res Function(BeanCartItem) _then) = _$BeanCartItemCopyWithImpl;
@useResult
$Res call({
 Bean bean, BeanWeight weight, GrindOption grind, int quantity
});


$BeanCopyWith<$Res> get bean;

}
/// @nodoc
class _$BeanCartItemCopyWithImpl<$Res>
    implements $BeanCartItemCopyWith<$Res> {
  _$BeanCartItemCopyWithImpl(this._self, this._then);

  final BeanCartItem _self;
  final $Res Function(BeanCartItem) _then;

/// Create a copy of BeanCartItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bean = null,Object? weight = null,Object? grind = null,Object? quantity = null,}) {
  return _then(_self.copyWith(
bean: null == bean ? _self.bean : bean // ignore: cast_nullable_to_non_nullable
as Bean,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as BeanWeight,grind: null == grind ? _self.grind : grind // ignore: cast_nullable_to_non_nullable
as GrindOption,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of BeanCartItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BeanCopyWith<$Res> get bean {
  
  return $BeanCopyWith<$Res>(_self.bean, (value) {
    return _then(_self.copyWith(bean: value));
  });
}
}


/// Adds pattern-matching-related methods to [BeanCartItem].
extension BeanCartItemPatterns on BeanCartItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BeanCartItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BeanCartItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BeanCartItem value)  $default,){
final _that = this;
switch (_that) {
case _BeanCartItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BeanCartItem value)?  $default,){
final _that = this;
switch (_that) {
case _BeanCartItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Bean bean,  BeanWeight weight,  GrindOption grind,  int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BeanCartItem() when $default != null:
return $default(_that.bean,_that.weight,_that.grind,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Bean bean,  BeanWeight weight,  GrindOption grind,  int quantity)  $default,) {final _that = this;
switch (_that) {
case _BeanCartItem():
return $default(_that.bean,_that.weight,_that.grind,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Bean bean,  BeanWeight weight,  GrindOption grind,  int quantity)?  $default,) {final _that = this;
switch (_that) {
case _BeanCartItem() when $default != null:
return $default(_that.bean,_that.weight,_that.grind,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc


class _BeanCartItem extends BeanCartItem {
  const _BeanCartItem({required this.bean, required this.weight, required this.grind, required this.quantity}): super._();
  

@override final  Bean bean;
@override final  BeanWeight weight;
@override final  GrindOption grind;
@override final  int quantity;

/// Create a copy of BeanCartItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BeanCartItemCopyWith<_BeanCartItem> get copyWith => __$BeanCartItemCopyWithImpl<_BeanCartItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BeanCartItem&&(identical(other.bean, bean) || other.bean == bean)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.grind, grind) || other.grind == grind)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,bean,weight,grind,quantity);

@override
String toString() {
  return 'BeanCartItem(bean: $bean, weight: $weight, grind: $grind, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$BeanCartItemCopyWith<$Res> implements $BeanCartItemCopyWith<$Res> {
  factory _$BeanCartItemCopyWith(_BeanCartItem value, $Res Function(_BeanCartItem) _then) = __$BeanCartItemCopyWithImpl;
@override @useResult
$Res call({
 Bean bean, BeanWeight weight, GrindOption grind, int quantity
});


@override $BeanCopyWith<$Res> get bean;

}
/// @nodoc
class __$BeanCartItemCopyWithImpl<$Res>
    implements _$BeanCartItemCopyWith<$Res> {
  __$BeanCartItemCopyWithImpl(this._self, this._then);

  final _BeanCartItem _self;
  final $Res Function(_BeanCartItem) _then;

/// Create a copy of BeanCartItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bean = null,Object? weight = null,Object? grind = null,Object? quantity = null,}) {
  return _then(_BeanCartItem(
bean: null == bean ? _self.bean : bean // ignore: cast_nullable_to_non_nullable
as Bean,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as BeanWeight,grind: null == grind ? _self.grind : grind // ignore: cast_nullable_to_non_nullable
as GrindOption,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of BeanCartItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BeanCopyWith<$Res> get bean {
  
  return $BeanCopyWith<$Res>(_self.bean, (value) {
    return _then(_self.copyWith(bean: value));
  });
}
}

// dart format on
