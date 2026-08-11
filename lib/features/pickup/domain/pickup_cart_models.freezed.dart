// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pickup_cart_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PickupCartItem {

 MenuItem get menuItem; String? get option; int get quantity;
/// Create a copy of PickupCartItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PickupCartItemCopyWith<PickupCartItem> get copyWith => _$PickupCartItemCopyWithImpl<PickupCartItem>(this as PickupCartItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PickupCartItem&&(identical(other.menuItem, menuItem) || other.menuItem == menuItem)&&(identical(other.option, option) || other.option == option)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,menuItem,option,quantity);

@override
String toString() {
  return 'PickupCartItem(menuItem: $menuItem, option: $option, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $PickupCartItemCopyWith<$Res>  {
  factory $PickupCartItemCopyWith(PickupCartItem value, $Res Function(PickupCartItem) _then) = _$PickupCartItemCopyWithImpl;
@useResult
$Res call({
 MenuItem menuItem, String? option, int quantity
});


$MenuItemCopyWith<$Res> get menuItem;

}
/// @nodoc
class _$PickupCartItemCopyWithImpl<$Res>
    implements $PickupCartItemCopyWith<$Res> {
  _$PickupCartItemCopyWithImpl(this._self, this._then);

  final PickupCartItem _self;
  final $Res Function(PickupCartItem) _then;

/// Create a copy of PickupCartItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? menuItem = null,Object? option = freezed,Object? quantity = null,}) {
  return _then(_self.copyWith(
menuItem: null == menuItem ? _self.menuItem : menuItem // ignore: cast_nullable_to_non_nullable
as MenuItem,option: freezed == option ? _self.option : option // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of PickupCartItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MenuItemCopyWith<$Res> get menuItem {
  
  return $MenuItemCopyWith<$Res>(_self.menuItem, (value) {
    return _then(_self.copyWith(menuItem: value));
  });
}
}


/// Adds pattern-matching-related methods to [PickupCartItem].
extension PickupCartItemPatterns on PickupCartItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PickupCartItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PickupCartItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PickupCartItem value)  $default,){
final _that = this;
switch (_that) {
case _PickupCartItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PickupCartItem value)?  $default,){
final _that = this;
switch (_that) {
case _PickupCartItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MenuItem menuItem,  String? option,  int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PickupCartItem() when $default != null:
return $default(_that.menuItem,_that.option,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MenuItem menuItem,  String? option,  int quantity)  $default,) {final _that = this;
switch (_that) {
case _PickupCartItem():
return $default(_that.menuItem,_that.option,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MenuItem menuItem,  String? option,  int quantity)?  $default,) {final _that = this;
switch (_that) {
case _PickupCartItem() when $default != null:
return $default(_that.menuItem,_that.option,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc


class _PickupCartItem extends PickupCartItem {
  const _PickupCartItem({required this.menuItem, this.option, required this.quantity}): super._();
  

@override final  MenuItem menuItem;
@override final  String? option;
@override final  int quantity;

/// Create a copy of PickupCartItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PickupCartItemCopyWith<_PickupCartItem> get copyWith => __$PickupCartItemCopyWithImpl<_PickupCartItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PickupCartItem&&(identical(other.menuItem, menuItem) || other.menuItem == menuItem)&&(identical(other.option, option) || other.option == option)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,menuItem,option,quantity);

@override
String toString() {
  return 'PickupCartItem(menuItem: $menuItem, option: $option, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$PickupCartItemCopyWith<$Res> implements $PickupCartItemCopyWith<$Res> {
  factory _$PickupCartItemCopyWith(_PickupCartItem value, $Res Function(_PickupCartItem) _then) = __$PickupCartItemCopyWithImpl;
@override @useResult
$Res call({
 MenuItem menuItem, String? option, int quantity
});


@override $MenuItemCopyWith<$Res> get menuItem;

}
/// @nodoc
class __$PickupCartItemCopyWithImpl<$Res>
    implements _$PickupCartItemCopyWith<$Res> {
  __$PickupCartItemCopyWithImpl(this._self, this._then);

  final _PickupCartItem _self;
  final $Res Function(_PickupCartItem) _then;

/// Create a copy of PickupCartItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? menuItem = null,Object? option = freezed,Object? quantity = null,}) {
  return _then(_PickupCartItem(
menuItem: null == menuItem ? _self.menuItem : menuItem // ignore: cast_nullable_to_non_nullable
as MenuItem,option: freezed == option ? _self.option : option // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of PickupCartItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MenuItemCopyWith<$Res> get menuItem {
  
  return $MenuItemCopyWith<$Res>(_self.menuItem, (value) {
    return _then(_self.copyWith(menuItem: value));
  });
}
}

// dart format on
