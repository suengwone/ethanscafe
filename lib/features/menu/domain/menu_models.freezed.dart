// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'menu_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MenuItem {

 String get id; String get name; String get description; MenuCategory get category; int get price; bool get priceFrom; MenuBadge get badge; List<String> get servingOptions; String? get detail; bool get isRecommended; bool get soldOut; int get sortOrder; String? get imageUrl;
/// Create a copy of MenuItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MenuItemCopyWith<MenuItem> get copyWith => _$MenuItemCopyWithImpl<MenuItem>(this as MenuItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MenuItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.price, price) || other.price == price)&&(identical(other.priceFrom, priceFrom) || other.priceFrom == priceFrom)&&(identical(other.badge, badge) || other.badge == badge)&&const DeepCollectionEquality().equals(other.servingOptions, servingOptions)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.isRecommended, isRecommended) || other.isRecommended == isRecommended)&&(identical(other.soldOut, soldOut) || other.soldOut == soldOut)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,category,price,priceFrom,badge,const DeepCollectionEquality().hash(servingOptions),detail,isRecommended,soldOut,sortOrder,imageUrl);

@override
String toString() {
  return 'MenuItem(id: $id, name: $name, description: $description, category: $category, price: $price, priceFrom: $priceFrom, badge: $badge, servingOptions: $servingOptions, detail: $detail, isRecommended: $isRecommended, soldOut: $soldOut, sortOrder: $sortOrder, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $MenuItemCopyWith<$Res>  {
  factory $MenuItemCopyWith(MenuItem value, $Res Function(MenuItem) _then) = _$MenuItemCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, MenuCategory category, int price, bool priceFrom, MenuBadge badge, List<String> servingOptions, String? detail, bool isRecommended, bool soldOut, int sortOrder, String? imageUrl
});




}
/// @nodoc
class _$MenuItemCopyWithImpl<$Res>
    implements $MenuItemCopyWith<$Res> {
  _$MenuItemCopyWithImpl(this._self, this._then);

  final MenuItem _self;
  final $Res Function(MenuItem) _then;

/// Create a copy of MenuItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? category = null,Object? price = null,Object? priceFrom = null,Object? badge = null,Object? servingOptions = null,Object? detail = freezed,Object? isRecommended = null,Object? soldOut = null,Object? sortOrder = null,Object? imageUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MenuCategory,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,priceFrom: null == priceFrom ? _self.priceFrom : priceFrom // ignore: cast_nullable_to_non_nullable
as bool,badge: null == badge ? _self.badge : badge // ignore: cast_nullable_to_non_nullable
as MenuBadge,servingOptions: null == servingOptions ? _self.servingOptions : servingOptions // ignore: cast_nullable_to_non_nullable
as List<String>,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,isRecommended: null == isRecommended ? _self.isRecommended : isRecommended // ignore: cast_nullable_to_non_nullable
as bool,soldOut: null == soldOut ? _self.soldOut : soldOut // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MenuItem].
extension MenuItemPatterns on MenuItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MenuItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MenuItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MenuItem value)  $default,){
final _that = this;
switch (_that) {
case _MenuItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MenuItem value)?  $default,){
final _that = this;
switch (_that) {
case _MenuItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  MenuCategory category,  int price,  bool priceFrom,  MenuBadge badge,  List<String> servingOptions,  String? detail,  bool isRecommended,  bool soldOut,  int sortOrder,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MenuItem() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.category,_that.price,_that.priceFrom,_that.badge,_that.servingOptions,_that.detail,_that.isRecommended,_that.soldOut,_that.sortOrder,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  MenuCategory category,  int price,  bool priceFrom,  MenuBadge badge,  List<String> servingOptions,  String? detail,  bool isRecommended,  bool soldOut,  int sortOrder,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _MenuItem():
return $default(_that.id,_that.name,_that.description,_that.category,_that.price,_that.priceFrom,_that.badge,_that.servingOptions,_that.detail,_that.isRecommended,_that.soldOut,_that.sortOrder,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  MenuCategory category,  int price,  bool priceFrom,  MenuBadge badge,  List<String> servingOptions,  String? detail,  bool isRecommended,  bool soldOut,  int sortOrder,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _MenuItem() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.category,_that.price,_that.priceFrom,_that.badge,_that.servingOptions,_that.detail,_that.isRecommended,_that.soldOut,_that.sortOrder,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc


class _MenuItem extends MenuItem {
  const _MenuItem({required this.id, required this.name, required this.description, required this.category, required this.price, this.priceFrom = false, this.badge = MenuBadge.none, final  List<String> servingOptions = const <String>[], this.detail, this.isRecommended = false, this.soldOut = false, this.sortOrder = 0, this.imageUrl}): _servingOptions = servingOptions,super._();
  

@override final  String id;
@override final  String name;
@override final  String description;
@override final  MenuCategory category;
@override final  int price;
@override@JsonKey() final  bool priceFrom;
@override@JsonKey() final  MenuBadge badge;
 final  List<String> _servingOptions;
@override@JsonKey() List<String> get servingOptions {
  if (_servingOptions is EqualUnmodifiableListView) return _servingOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_servingOptions);
}

@override final  String? detail;
@override@JsonKey() final  bool isRecommended;
@override@JsonKey() final  bool soldOut;
@override@JsonKey() final  int sortOrder;
@override final  String? imageUrl;

/// Create a copy of MenuItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MenuItemCopyWith<_MenuItem> get copyWith => __$MenuItemCopyWithImpl<_MenuItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MenuItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.price, price) || other.price == price)&&(identical(other.priceFrom, priceFrom) || other.priceFrom == priceFrom)&&(identical(other.badge, badge) || other.badge == badge)&&const DeepCollectionEquality().equals(other._servingOptions, _servingOptions)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.isRecommended, isRecommended) || other.isRecommended == isRecommended)&&(identical(other.soldOut, soldOut) || other.soldOut == soldOut)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,category,price,priceFrom,badge,const DeepCollectionEquality().hash(_servingOptions),detail,isRecommended,soldOut,sortOrder,imageUrl);

@override
String toString() {
  return 'MenuItem(id: $id, name: $name, description: $description, category: $category, price: $price, priceFrom: $priceFrom, badge: $badge, servingOptions: $servingOptions, detail: $detail, isRecommended: $isRecommended, soldOut: $soldOut, sortOrder: $sortOrder, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$MenuItemCopyWith<$Res> implements $MenuItemCopyWith<$Res> {
  factory _$MenuItemCopyWith(_MenuItem value, $Res Function(_MenuItem) _then) = __$MenuItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, MenuCategory category, int price, bool priceFrom, MenuBadge badge, List<String> servingOptions, String? detail, bool isRecommended, bool soldOut, int sortOrder, String? imageUrl
});




}
/// @nodoc
class __$MenuItemCopyWithImpl<$Res>
    implements _$MenuItemCopyWith<$Res> {
  __$MenuItemCopyWithImpl(this._self, this._then);

  final _MenuItem _self;
  final $Res Function(_MenuItem) _then;

/// Create a copy of MenuItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? category = null,Object? price = null,Object? priceFrom = null,Object? badge = null,Object? servingOptions = null,Object? detail = freezed,Object? isRecommended = null,Object? soldOut = null,Object? sortOrder = null,Object? imageUrl = freezed,}) {
  return _then(_MenuItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MenuCategory,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,priceFrom: null == priceFrom ? _self.priceFrom : priceFrom // ignore: cast_nullable_to_non_nullable
as bool,badge: null == badge ? _self.badge : badge // ignore: cast_nullable_to_non_nullable
as MenuBadge,servingOptions: null == servingOptions ? _self._servingOptions : servingOptions // ignore: cast_nullable_to_non_nullable
as List<String>,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,isRecommended: null == isRecommended ? _self.isRecommended : isRecommended // ignore: cast_nullable_to_non_nullable
as bool,soldOut: null == soldOut ? _self.soldOut : soldOut // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
