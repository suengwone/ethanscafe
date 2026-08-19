// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'banner_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EventBanner {

 String get id; String get title; String get subtitle; String get icon; int get sortOrder;
/// Create a copy of EventBanner
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventBannerCopyWith<EventBanner> get copyWith => _$EventBannerCopyWithImpl<EventBanner>(this as EventBanner, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventBanner&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,icon,sortOrder);

@override
String toString() {
  return 'EventBanner(id: $id, title: $title, subtitle: $subtitle, icon: $icon, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $EventBannerCopyWith<$Res>  {
  factory $EventBannerCopyWith(EventBanner value, $Res Function(EventBanner) _then) = _$EventBannerCopyWithImpl;
@useResult
$Res call({
 String id, String title, String subtitle, String icon, int sortOrder
});




}
/// @nodoc
class _$EventBannerCopyWithImpl<$Res>
    implements $EventBannerCopyWith<$Res> {
  _$EventBannerCopyWithImpl(this._self, this._then);

  final EventBanner _self;
  final $Res Function(EventBanner) _then;

/// Create a copy of EventBanner
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? subtitle = null,Object? icon = null,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EventBanner].
extension EventBannerPatterns on EventBanner {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventBanner value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventBanner() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventBanner value)  $default,){
final _that = this;
switch (_that) {
case _EventBanner():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventBanner value)?  $default,){
final _that = this;
switch (_that) {
case _EventBanner() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String subtitle,  String icon,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventBanner() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.icon,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String subtitle,  String icon,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _EventBanner():
return $default(_that.id,_that.title,_that.subtitle,_that.icon,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String subtitle,  String icon,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _EventBanner() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.icon,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc


class _EventBanner implements EventBanner {
  const _EventBanner({required this.id, required this.title, required this.subtitle, this.icon = 'sparkles', this.sortOrder = 0});
  

@override final  String id;
@override final  String title;
@override final  String subtitle;
@override@JsonKey() final  String icon;
@override@JsonKey() final  int sortOrder;

/// Create a copy of EventBanner
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventBannerCopyWith<_EventBanner> get copyWith => __$EventBannerCopyWithImpl<_EventBanner>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventBanner&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,icon,sortOrder);

@override
String toString() {
  return 'EventBanner(id: $id, title: $title, subtitle: $subtitle, icon: $icon, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$EventBannerCopyWith<$Res> implements $EventBannerCopyWith<$Res> {
  factory _$EventBannerCopyWith(_EventBanner value, $Res Function(_EventBanner) _then) = __$EventBannerCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String subtitle, String icon, int sortOrder
});




}
/// @nodoc
class __$EventBannerCopyWithImpl<$Res>
    implements _$EventBannerCopyWith<$Res> {
  __$EventBannerCopyWithImpl(this._self, this._then);

  final _EventBanner _self;
  final $Res Function(_EventBanner) _then;

/// Create a copy of EventBanner
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? subtitle = null,Object? icon = null,Object? sortOrder = null,}) {
  return _then(_EventBanner(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
