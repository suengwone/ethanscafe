// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wholesale_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WholesalePriceTier {

 int get minKg; int get pricePerKg;
/// Create a copy of WholesalePriceTier
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WholesalePriceTierCopyWith<WholesalePriceTier> get copyWith => _$WholesalePriceTierCopyWithImpl<WholesalePriceTier>(this as WholesalePriceTier, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WholesalePriceTier&&(identical(other.minKg, minKg) || other.minKg == minKg)&&(identical(other.pricePerKg, pricePerKg) || other.pricePerKg == pricePerKg));
}


@override
int get hashCode => Object.hash(runtimeType,minKg,pricePerKg);

@override
String toString() {
  return 'WholesalePriceTier(minKg: $minKg, pricePerKg: $pricePerKg)';
}


}

/// @nodoc
abstract mixin class $WholesalePriceTierCopyWith<$Res>  {
  factory $WholesalePriceTierCopyWith(WholesalePriceTier value, $Res Function(WholesalePriceTier) _then) = _$WholesalePriceTierCopyWithImpl;
@useResult
$Res call({
 int minKg, int pricePerKg
});




}
/// @nodoc
class _$WholesalePriceTierCopyWithImpl<$Res>
    implements $WholesalePriceTierCopyWith<$Res> {
  _$WholesalePriceTierCopyWithImpl(this._self, this._then);

  final WholesalePriceTier _self;
  final $Res Function(WholesalePriceTier) _then;

/// Create a copy of WholesalePriceTier
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? minKg = null,Object? pricePerKg = null,}) {
  return _then(_self.copyWith(
minKg: null == minKg ? _self.minKg : minKg // ignore: cast_nullable_to_non_nullable
as int,pricePerKg: null == pricePerKg ? _self.pricePerKg : pricePerKg // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WholesalePriceTier].
extension WholesalePriceTierPatterns on WholesalePriceTier {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WholesalePriceTier value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WholesalePriceTier() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WholesalePriceTier value)  $default,){
final _that = this;
switch (_that) {
case _WholesalePriceTier():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WholesalePriceTier value)?  $default,){
final _that = this;
switch (_that) {
case _WholesalePriceTier() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int minKg,  int pricePerKg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WholesalePriceTier() when $default != null:
return $default(_that.minKg,_that.pricePerKg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int minKg,  int pricePerKg)  $default,) {final _that = this;
switch (_that) {
case _WholesalePriceTier():
return $default(_that.minKg,_that.pricePerKg);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int minKg,  int pricePerKg)?  $default,) {final _that = this;
switch (_that) {
case _WholesalePriceTier() when $default != null:
return $default(_that.minKg,_that.pricePerKg);case _:
  return null;

}
}

}

/// @nodoc


class _WholesalePriceTier implements WholesalePriceTier {
  const _WholesalePriceTier({required this.minKg, required this.pricePerKg});
  

@override final  int minKg;
@override final  int pricePerKg;

/// Create a copy of WholesalePriceTier
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WholesalePriceTierCopyWith<_WholesalePriceTier> get copyWith => __$WholesalePriceTierCopyWithImpl<_WholesalePriceTier>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WholesalePriceTier&&(identical(other.minKg, minKg) || other.minKg == minKg)&&(identical(other.pricePerKg, pricePerKg) || other.pricePerKg == pricePerKg));
}


@override
int get hashCode => Object.hash(runtimeType,minKg,pricePerKg);

@override
String toString() {
  return 'WholesalePriceTier(minKg: $minKg, pricePerKg: $pricePerKg)';
}


}

/// @nodoc
abstract mixin class _$WholesalePriceTierCopyWith<$Res> implements $WholesalePriceTierCopyWith<$Res> {
  factory _$WholesalePriceTierCopyWith(_WholesalePriceTier value, $Res Function(_WholesalePriceTier) _then) = __$WholesalePriceTierCopyWithImpl;
@override @useResult
$Res call({
 int minKg, int pricePerKg
});




}
/// @nodoc
class __$WholesalePriceTierCopyWithImpl<$Res>
    implements _$WholesalePriceTierCopyWith<$Res> {
  __$WholesalePriceTierCopyWithImpl(this._self, this._then);

  final _WholesalePriceTier _self;
  final $Res Function(_WholesalePriceTier) _then;

/// Create a copy of WholesalePriceTier
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? minKg = null,Object? pricePerKg = null,}) {
  return _then(_WholesalePriceTier(
minKg: null == minKg ? _self.minKg : minKg // ignore: cast_nullable_to_non_nullable
as int,pricePerKg: null == pricePerKg ? _self.pricePerKg : pricePerKg // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$WholesaleBean {

 String get id; String get name; String get origin; RoastLevel get roastLevel; String get process; List<String> get tastingNotes; int get minOrderKg; List<WholesalePriceTier> get tiers; bool get isBest;
/// Create a copy of WholesaleBean
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WholesaleBeanCopyWith<WholesaleBean> get copyWith => _$WholesaleBeanCopyWithImpl<WholesaleBean>(this as WholesaleBean, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WholesaleBean&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.roastLevel, roastLevel) || other.roastLevel == roastLevel)&&(identical(other.process, process) || other.process == process)&&const DeepCollectionEquality().equals(other.tastingNotes, tastingNotes)&&(identical(other.minOrderKg, minOrderKg) || other.minOrderKg == minOrderKg)&&const DeepCollectionEquality().equals(other.tiers, tiers)&&(identical(other.isBest, isBest) || other.isBest == isBest));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,origin,roastLevel,process,const DeepCollectionEquality().hash(tastingNotes),minOrderKg,const DeepCollectionEquality().hash(tiers),isBest);

@override
String toString() {
  return 'WholesaleBean(id: $id, name: $name, origin: $origin, roastLevel: $roastLevel, process: $process, tastingNotes: $tastingNotes, minOrderKg: $minOrderKg, tiers: $tiers, isBest: $isBest)';
}


}

/// @nodoc
abstract mixin class $WholesaleBeanCopyWith<$Res>  {
  factory $WholesaleBeanCopyWith(WholesaleBean value, $Res Function(WholesaleBean) _then) = _$WholesaleBeanCopyWithImpl;
@useResult
$Res call({
 String id, String name, String origin, RoastLevel roastLevel, String process, List<String> tastingNotes, int minOrderKg, List<WholesalePriceTier> tiers, bool isBest
});




}
/// @nodoc
class _$WholesaleBeanCopyWithImpl<$Res>
    implements $WholesaleBeanCopyWith<$Res> {
  _$WholesaleBeanCopyWithImpl(this._self, this._then);

  final WholesaleBean _self;
  final $Res Function(WholesaleBean) _then;

/// Create a copy of WholesaleBean
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? origin = null,Object? roastLevel = null,Object? process = null,Object? tastingNotes = null,Object? minOrderKg = null,Object? tiers = null,Object? isBest = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,roastLevel: null == roastLevel ? _self.roastLevel : roastLevel // ignore: cast_nullable_to_non_nullable
as RoastLevel,process: null == process ? _self.process : process // ignore: cast_nullable_to_non_nullable
as String,tastingNotes: null == tastingNotes ? _self.tastingNotes : tastingNotes // ignore: cast_nullable_to_non_nullable
as List<String>,minOrderKg: null == minOrderKg ? _self.minOrderKg : minOrderKg // ignore: cast_nullable_to_non_nullable
as int,tiers: null == tiers ? _self.tiers : tiers // ignore: cast_nullable_to_non_nullable
as List<WholesalePriceTier>,isBest: null == isBest ? _self.isBest : isBest // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WholesaleBean].
extension WholesaleBeanPatterns on WholesaleBean {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WholesaleBean value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WholesaleBean() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WholesaleBean value)  $default,){
final _that = this;
switch (_that) {
case _WholesaleBean():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WholesaleBean value)?  $default,){
final _that = this;
switch (_that) {
case _WholesaleBean() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String origin,  RoastLevel roastLevel,  String process,  List<String> tastingNotes,  int minOrderKg,  List<WholesalePriceTier> tiers,  bool isBest)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WholesaleBean() when $default != null:
return $default(_that.id,_that.name,_that.origin,_that.roastLevel,_that.process,_that.tastingNotes,_that.minOrderKg,_that.tiers,_that.isBest);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String origin,  RoastLevel roastLevel,  String process,  List<String> tastingNotes,  int minOrderKg,  List<WholesalePriceTier> tiers,  bool isBest)  $default,) {final _that = this;
switch (_that) {
case _WholesaleBean():
return $default(_that.id,_that.name,_that.origin,_that.roastLevel,_that.process,_that.tastingNotes,_that.minOrderKg,_that.tiers,_that.isBest);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String origin,  RoastLevel roastLevel,  String process,  List<String> tastingNotes,  int minOrderKg,  List<WholesalePriceTier> tiers,  bool isBest)?  $default,) {final _that = this;
switch (_that) {
case _WholesaleBean() when $default != null:
return $default(_that.id,_that.name,_that.origin,_that.roastLevel,_that.process,_that.tastingNotes,_that.minOrderKg,_that.tiers,_that.isBest);case _:
  return null;

}
}

}

/// @nodoc


class _WholesaleBean extends WholesaleBean {
  const _WholesaleBean({required this.id, required this.name, required this.origin, required this.roastLevel, required this.process, required final  List<String> tastingNotes, required this.minOrderKg, required final  List<WholesalePriceTier> tiers, this.isBest = false}): _tastingNotes = tastingNotes,_tiers = tiers,super._();
  

@override final  String id;
@override final  String name;
@override final  String origin;
@override final  RoastLevel roastLevel;
@override final  String process;
 final  List<String> _tastingNotes;
@override List<String> get tastingNotes {
  if (_tastingNotes is EqualUnmodifiableListView) return _tastingNotes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tastingNotes);
}

@override final  int minOrderKg;
 final  List<WholesalePriceTier> _tiers;
@override List<WholesalePriceTier> get tiers {
  if (_tiers is EqualUnmodifiableListView) return _tiers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tiers);
}

@override@JsonKey() final  bool isBest;

/// Create a copy of WholesaleBean
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WholesaleBeanCopyWith<_WholesaleBean> get copyWith => __$WholesaleBeanCopyWithImpl<_WholesaleBean>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WholesaleBean&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.roastLevel, roastLevel) || other.roastLevel == roastLevel)&&(identical(other.process, process) || other.process == process)&&const DeepCollectionEquality().equals(other._tastingNotes, _tastingNotes)&&(identical(other.minOrderKg, minOrderKg) || other.minOrderKg == minOrderKg)&&const DeepCollectionEquality().equals(other._tiers, _tiers)&&(identical(other.isBest, isBest) || other.isBest == isBest));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,origin,roastLevel,process,const DeepCollectionEquality().hash(_tastingNotes),minOrderKg,const DeepCollectionEquality().hash(_tiers),isBest);

@override
String toString() {
  return 'WholesaleBean(id: $id, name: $name, origin: $origin, roastLevel: $roastLevel, process: $process, tastingNotes: $tastingNotes, minOrderKg: $minOrderKg, tiers: $tiers, isBest: $isBest)';
}


}

/// @nodoc
abstract mixin class _$WholesaleBeanCopyWith<$Res> implements $WholesaleBeanCopyWith<$Res> {
  factory _$WholesaleBeanCopyWith(_WholesaleBean value, $Res Function(_WholesaleBean) _then) = __$WholesaleBeanCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String origin, RoastLevel roastLevel, String process, List<String> tastingNotes, int minOrderKg, List<WholesalePriceTier> tiers, bool isBest
});




}
/// @nodoc
class __$WholesaleBeanCopyWithImpl<$Res>
    implements _$WholesaleBeanCopyWith<$Res> {
  __$WholesaleBeanCopyWithImpl(this._self, this._then);

  final _WholesaleBean _self;
  final $Res Function(_WholesaleBean) _then;

/// Create a copy of WholesaleBean
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? origin = null,Object? roastLevel = null,Object? process = null,Object? tastingNotes = null,Object? minOrderKg = null,Object? tiers = null,Object? isBest = null,}) {
  return _then(_WholesaleBean(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,roastLevel: null == roastLevel ? _self.roastLevel : roastLevel // ignore: cast_nullable_to_non_nullable
as RoastLevel,process: null == process ? _self.process : process // ignore: cast_nullable_to_non_nullable
as String,tastingNotes: null == tastingNotes ? _self._tastingNotes : tastingNotes // ignore: cast_nullable_to_non_nullable
as List<String>,minOrderKg: null == minOrderKg ? _self.minOrderKg : minOrderKg // ignore: cast_nullable_to_non_nullable
as int,tiers: null == tiers ? _self._tiers : tiers // ignore: cast_nullable_to_non_nullable
as List<WholesalePriceTier>,isBest: null == isBest ? _self.isBest : isBest // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$WholesaleQuoteItem {

 String get beanId; String get beanName; int get kg; int get pricePerKg;
/// Create a copy of WholesaleQuoteItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WholesaleQuoteItemCopyWith<WholesaleQuoteItem> get copyWith => _$WholesaleQuoteItemCopyWithImpl<WholesaleQuoteItem>(this as WholesaleQuoteItem, _$identity);

  /// Serializes this WholesaleQuoteItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WholesaleQuoteItem&&(identical(other.beanId, beanId) || other.beanId == beanId)&&(identical(other.beanName, beanName) || other.beanName == beanName)&&(identical(other.kg, kg) || other.kg == kg)&&(identical(other.pricePerKg, pricePerKg) || other.pricePerKg == pricePerKg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,beanId,beanName,kg,pricePerKg);

@override
String toString() {
  return 'WholesaleQuoteItem(beanId: $beanId, beanName: $beanName, kg: $kg, pricePerKg: $pricePerKg)';
}


}

/// @nodoc
abstract mixin class $WholesaleQuoteItemCopyWith<$Res>  {
  factory $WholesaleQuoteItemCopyWith(WholesaleQuoteItem value, $Res Function(WholesaleQuoteItem) _then) = _$WholesaleQuoteItemCopyWithImpl;
@useResult
$Res call({
 String beanId, String beanName, int kg, int pricePerKg
});




}
/// @nodoc
class _$WholesaleQuoteItemCopyWithImpl<$Res>
    implements $WholesaleQuoteItemCopyWith<$Res> {
  _$WholesaleQuoteItemCopyWithImpl(this._self, this._then);

  final WholesaleQuoteItem _self;
  final $Res Function(WholesaleQuoteItem) _then;

/// Create a copy of WholesaleQuoteItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? beanId = null,Object? beanName = null,Object? kg = null,Object? pricePerKg = null,}) {
  return _then(_self.copyWith(
beanId: null == beanId ? _self.beanId : beanId // ignore: cast_nullable_to_non_nullable
as String,beanName: null == beanName ? _self.beanName : beanName // ignore: cast_nullable_to_non_nullable
as String,kg: null == kg ? _self.kg : kg // ignore: cast_nullable_to_non_nullable
as int,pricePerKg: null == pricePerKg ? _self.pricePerKg : pricePerKg // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WholesaleQuoteItem].
extension WholesaleQuoteItemPatterns on WholesaleQuoteItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WholesaleQuoteItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WholesaleQuoteItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WholesaleQuoteItem value)  $default,){
final _that = this;
switch (_that) {
case _WholesaleQuoteItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WholesaleQuoteItem value)?  $default,){
final _that = this;
switch (_that) {
case _WholesaleQuoteItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String beanId,  String beanName,  int kg,  int pricePerKg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WholesaleQuoteItem() when $default != null:
return $default(_that.beanId,_that.beanName,_that.kg,_that.pricePerKg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String beanId,  String beanName,  int kg,  int pricePerKg)  $default,) {final _that = this;
switch (_that) {
case _WholesaleQuoteItem():
return $default(_that.beanId,_that.beanName,_that.kg,_that.pricePerKg);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String beanId,  String beanName,  int kg,  int pricePerKg)?  $default,) {final _that = this;
switch (_that) {
case _WholesaleQuoteItem() when $default != null:
return $default(_that.beanId,_that.beanName,_that.kg,_that.pricePerKg);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WholesaleQuoteItem extends WholesaleQuoteItem {
  const _WholesaleQuoteItem({required this.beanId, required this.beanName, required this.kg, required this.pricePerKg}): super._();
  factory _WholesaleQuoteItem.fromJson(Map<String, dynamic> json) => _$WholesaleQuoteItemFromJson(json);

@override final  String beanId;
@override final  String beanName;
@override final  int kg;
@override final  int pricePerKg;

/// Create a copy of WholesaleQuoteItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WholesaleQuoteItemCopyWith<_WholesaleQuoteItem> get copyWith => __$WholesaleQuoteItemCopyWithImpl<_WholesaleQuoteItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WholesaleQuoteItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WholesaleQuoteItem&&(identical(other.beanId, beanId) || other.beanId == beanId)&&(identical(other.beanName, beanName) || other.beanName == beanName)&&(identical(other.kg, kg) || other.kg == kg)&&(identical(other.pricePerKg, pricePerKg) || other.pricePerKg == pricePerKg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,beanId,beanName,kg,pricePerKg);

@override
String toString() {
  return 'WholesaleQuoteItem(beanId: $beanId, beanName: $beanName, kg: $kg, pricePerKg: $pricePerKg)';
}


}

/// @nodoc
abstract mixin class _$WholesaleQuoteItemCopyWith<$Res> implements $WholesaleQuoteItemCopyWith<$Res> {
  factory _$WholesaleQuoteItemCopyWith(_WholesaleQuoteItem value, $Res Function(_WholesaleQuoteItem) _then) = __$WholesaleQuoteItemCopyWithImpl;
@override @useResult
$Res call({
 String beanId, String beanName, int kg, int pricePerKg
});




}
/// @nodoc
class __$WholesaleQuoteItemCopyWithImpl<$Res>
    implements _$WholesaleQuoteItemCopyWith<$Res> {
  __$WholesaleQuoteItemCopyWithImpl(this._self, this._then);

  final _WholesaleQuoteItem _self;
  final $Res Function(_WholesaleQuoteItem) _then;

/// Create a copy of WholesaleQuoteItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? beanId = null,Object? beanName = null,Object? kg = null,Object? pricePerKg = null,}) {
  return _then(_WholesaleQuoteItem(
beanId: null == beanId ? _self.beanId : beanId // ignore: cast_nullable_to_non_nullable
as String,beanName: null == beanName ? _self.beanName : beanName // ignore: cast_nullable_to_non_nullable
as String,kg: null == kg ? _self.kg : kg // ignore: cast_nullable_to_non_nullable
as int,pricePerKg: null == pricePerKg ? _self.pricePerKg : pricePerKg // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$WholesaleQuote {

 String get id; String get companyName; List<WholesaleQuoteItem> get items; String get memo; WholesaleQuoteStatus get status; DateTime get createdAt;
/// Create a copy of WholesaleQuote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WholesaleQuoteCopyWith<WholesaleQuote> get copyWith => _$WholesaleQuoteCopyWithImpl<WholesaleQuote>(this as WholesaleQuote, _$identity);

  /// Serializes this WholesaleQuote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WholesaleQuote&&(identical(other.id, id) || other.id == id)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.memo, memo) || other.memo == memo)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,companyName,const DeepCollectionEquality().hash(items),memo,status,createdAt);

@override
String toString() {
  return 'WholesaleQuote(id: $id, companyName: $companyName, items: $items, memo: $memo, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $WholesaleQuoteCopyWith<$Res>  {
  factory $WholesaleQuoteCopyWith(WholesaleQuote value, $Res Function(WholesaleQuote) _then) = _$WholesaleQuoteCopyWithImpl;
@useResult
$Res call({
 String id, String companyName, List<WholesaleQuoteItem> items, String memo, WholesaleQuoteStatus status, DateTime createdAt
});




}
/// @nodoc
class _$WholesaleQuoteCopyWithImpl<$Res>
    implements $WholesaleQuoteCopyWith<$Res> {
  _$WholesaleQuoteCopyWithImpl(this._self, this._then);

  final WholesaleQuote _self;
  final $Res Function(WholesaleQuote) _then;

/// Create a copy of WholesaleQuote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? companyName = null,Object? items = null,Object? memo = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<WholesaleQuoteItem>,memo: null == memo ? _self.memo : memo // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WholesaleQuoteStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WholesaleQuote].
extension WholesaleQuotePatterns on WholesaleQuote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WholesaleQuote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WholesaleQuote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WholesaleQuote value)  $default,){
final _that = this;
switch (_that) {
case _WholesaleQuote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WholesaleQuote value)?  $default,){
final _that = this;
switch (_that) {
case _WholesaleQuote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String companyName,  List<WholesaleQuoteItem> items,  String memo,  WholesaleQuoteStatus status,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WholesaleQuote() when $default != null:
return $default(_that.id,_that.companyName,_that.items,_that.memo,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String companyName,  List<WholesaleQuoteItem> items,  String memo,  WholesaleQuoteStatus status,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _WholesaleQuote():
return $default(_that.id,_that.companyName,_that.items,_that.memo,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String companyName,  List<WholesaleQuoteItem> items,  String memo,  WholesaleQuoteStatus status,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _WholesaleQuote() when $default != null:
return $default(_that.id,_that.companyName,_that.items,_that.memo,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WholesaleQuote extends WholesaleQuote {
  const _WholesaleQuote({required this.id, required this.companyName, required final  List<WholesaleQuoteItem> items, this.memo = '', this.status = WholesaleQuoteStatus.requested, required this.createdAt}): _items = items,super._();
  factory _WholesaleQuote.fromJson(Map<String, dynamic> json) => _$WholesaleQuoteFromJson(json);

@override final  String id;
@override final  String companyName;
 final  List<WholesaleQuoteItem> _items;
@override List<WholesaleQuoteItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  String memo;
@override@JsonKey() final  WholesaleQuoteStatus status;
@override final  DateTime createdAt;

/// Create a copy of WholesaleQuote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WholesaleQuoteCopyWith<_WholesaleQuote> get copyWith => __$WholesaleQuoteCopyWithImpl<_WholesaleQuote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WholesaleQuoteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WholesaleQuote&&(identical(other.id, id) || other.id == id)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.memo, memo) || other.memo == memo)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,companyName,const DeepCollectionEquality().hash(_items),memo,status,createdAt);

@override
String toString() {
  return 'WholesaleQuote(id: $id, companyName: $companyName, items: $items, memo: $memo, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$WholesaleQuoteCopyWith<$Res> implements $WholesaleQuoteCopyWith<$Res> {
  factory _$WholesaleQuoteCopyWith(_WholesaleQuote value, $Res Function(_WholesaleQuote) _then) = __$WholesaleQuoteCopyWithImpl;
@override @useResult
$Res call({
 String id, String companyName, List<WholesaleQuoteItem> items, String memo, WholesaleQuoteStatus status, DateTime createdAt
});




}
/// @nodoc
class __$WholesaleQuoteCopyWithImpl<$Res>
    implements _$WholesaleQuoteCopyWith<$Res> {
  __$WholesaleQuoteCopyWithImpl(this._self, this._then);

  final _WholesaleQuote _self;
  final $Res Function(_WholesaleQuote) _then;

/// Create a copy of WholesaleQuote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? companyName = null,Object? items = null,Object? memo = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_WholesaleQuote(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<WholesaleQuoteItem>,memo: null == memo ? _self.memo : memo // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WholesaleQuoteStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
