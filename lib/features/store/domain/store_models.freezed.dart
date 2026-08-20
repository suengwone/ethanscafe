// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CafeStore {

 String get id; String get name; String get address; String get phone; double get latitude; double get longitude; String get weekdayHours; String get weekendHours; List<String> get services; int get sortOrder; String get notice; StoreCongestion get congestion; DateTime? get congestionUpdatedAt;
/// Create a copy of CafeStore
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CafeStoreCopyWith<CafeStore> get copyWith => _$CafeStoreCopyWithImpl<CafeStore>(this as CafeStore, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CafeStore&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.weekdayHours, weekdayHours) || other.weekdayHours == weekdayHours)&&(identical(other.weekendHours, weekendHours) || other.weekendHours == weekendHours)&&const DeepCollectionEquality().equals(other.services, services)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.notice, notice) || other.notice == notice)&&(identical(other.congestion, congestion) || other.congestion == congestion)&&(identical(other.congestionUpdatedAt, congestionUpdatedAt) || other.congestionUpdatedAt == congestionUpdatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,address,phone,latitude,longitude,weekdayHours,weekendHours,const DeepCollectionEquality().hash(services),sortOrder,notice,congestion,congestionUpdatedAt);

@override
String toString() {
  return 'CafeStore(id: $id, name: $name, address: $address, phone: $phone, latitude: $latitude, longitude: $longitude, weekdayHours: $weekdayHours, weekendHours: $weekendHours, services: $services, sortOrder: $sortOrder, notice: $notice, congestion: $congestion, congestionUpdatedAt: $congestionUpdatedAt)';
}


}

/// @nodoc
abstract mixin class $CafeStoreCopyWith<$Res>  {
  factory $CafeStoreCopyWith(CafeStore value, $Res Function(CafeStore) _then) = _$CafeStoreCopyWithImpl;
@useResult
$Res call({
 String id, String name, String address, String phone, double latitude, double longitude, String weekdayHours, String weekendHours, List<String> services, int sortOrder, String notice, StoreCongestion congestion, DateTime? congestionUpdatedAt
});




}
/// @nodoc
class _$CafeStoreCopyWithImpl<$Res>
    implements $CafeStoreCopyWith<$Res> {
  _$CafeStoreCopyWithImpl(this._self, this._then);

  final CafeStore _self;
  final $Res Function(CafeStore) _then;

/// Create a copy of CafeStore
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = null,Object? phone = null,Object? latitude = null,Object? longitude = null,Object? weekdayHours = null,Object? weekendHours = null,Object? services = null,Object? sortOrder = null,Object? notice = null,Object? congestion = null,Object? congestionUpdatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,weekdayHours: null == weekdayHours ? _self.weekdayHours : weekdayHours // ignore: cast_nullable_to_non_nullable
as String,weekendHours: null == weekendHours ? _self.weekendHours : weekendHours // ignore: cast_nullable_to_non_nullable
as String,services: null == services ? _self.services : services // ignore: cast_nullable_to_non_nullable
as List<String>,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,notice: null == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as String,congestion: null == congestion ? _self.congestion : congestion // ignore: cast_nullable_to_non_nullable
as StoreCongestion,congestionUpdatedAt: freezed == congestionUpdatedAt ? _self.congestionUpdatedAt : congestionUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CafeStore].
extension CafeStorePatterns on CafeStore {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CafeStore value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CafeStore() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CafeStore value)  $default,){
final _that = this;
switch (_that) {
case _CafeStore():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CafeStore value)?  $default,){
final _that = this;
switch (_that) {
case _CafeStore() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String address,  String phone,  double latitude,  double longitude,  String weekdayHours,  String weekendHours,  List<String> services,  int sortOrder,  String notice,  StoreCongestion congestion,  DateTime? congestionUpdatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CafeStore() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.phone,_that.latitude,_that.longitude,_that.weekdayHours,_that.weekendHours,_that.services,_that.sortOrder,_that.notice,_that.congestion,_that.congestionUpdatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String address,  String phone,  double latitude,  double longitude,  String weekdayHours,  String weekendHours,  List<String> services,  int sortOrder,  String notice,  StoreCongestion congestion,  DateTime? congestionUpdatedAt)  $default,) {final _that = this;
switch (_that) {
case _CafeStore():
return $default(_that.id,_that.name,_that.address,_that.phone,_that.latitude,_that.longitude,_that.weekdayHours,_that.weekendHours,_that.services,_that.sortOrder,_that.notice,_that.congestion,_that.congestionUpdatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String address,  String phone,  double latitude,  double longitude,  String weekdayHours,  String weekendHours,  List<String> services,  int sortOrder,  String notice,  StoreCongestion congestion,  DateTime? congestionUpdatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CafeStore() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.phone,_that.latitude,_that.longitude,_that.weekdayHours,_that.weekendHours,_that.services,_that.sortOrder,_that.notice,_that.congestion,_that.congestionUpdatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _CafeStore extends CafeStore {
  const _CafeStore({required this.id, required this.name, required this.address, required this.phone, required this.latitude, required this.longitude, required this.weekdayHours, required this.weekendHours, final  List<String> services = const <String>[], this.sortOrder = 0, this.notice = '', this.congestion = StoreCongestion.unknown, this.congestionUpdatedAt}): _services = services,super._();
  

@override final  String id;
@override final  String name;
@override final  String address;
@override final  String phone;
@override final  double latitude;
@override final  double longitude;
@override final  String weekdayHours;
@override final  String weekendHours;
 final  List<String> _services;
@override@JsonKey() List<String> get services {
  if (_services is EqualUnmodifiableListView) return _services;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_services);
}

@override@JsonKey() final  int sortOrder;
@override@JsonKey() final  String notice;
@override@JsonKey() final  StoreCongestion congestion;
@override final  DateTime? congestionUpdatedAt;

/// Create a copy of CafeStore
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CafeStoreCopyWith<_CafeStore> get copyWith => __$CafeStoreCopyWithImpl<_CafeStore>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CafeStore&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.weekdayHours, weekdayHours) || other.weekdayHours == weekdayHours)&&(identical(other.weekendHours, weekendHours) || other.weekendHours == weekendHours)&&const DeepCollectionEquality().equals(other._services, _services)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.notice, notice) || other.notice == notice)&&(identical(other.congestion, congestion) || other.congestion == congestion)&&(identical(other.congestionUpdatedAt, congestionUpdatedAt) || other.congestionUpdatedAt == congestionUpdatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,address,phone,latitude,longitude,weekdayHours,weekendHours,const DeepCollectionEquality().hash(_services),sortOrder,notice,congestion,congestionUpdatedAt);

@override
String toString() {
  return 'CafeStore(id: $id, name: $name, address: $address, phone: $phone, latitude: $latitude, longitude: $longitude, weekdayHours: $weekdayHours, weekendHours: $weekendHours, services: $services, sortOrder: $sortOrder, notice: $notice, congestion: $congestion, congestionUpdatedAt: $congestionUpdatedAt)';
}


}

/// @nodoc
abstract mixin class _$CafeStoreCopyWith<$Res> implements $CafeStoreCopyWith<$Res> {
  factory _$CafeStoreCopyWith(_CafeStore value, $Res Function(_CafeStore) _then) = __$CafeStoreCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String address, String phone, double latitude, double longitude, String weekdayHours, String weekendHours, List<String> services, int sortOrder, String notice, StoreCongestion congestion, DateTime? congestionUpdatedAt
});




}
/// @nodoc
class __$CafeStoreCopyWithImpl<$Res>
    implements _$CafeStoreCopyWith<$Res> {
  __$CafeStoreCopyWithImpl(this._self, this._then);

  final _CafeStore _self;
  final $Res Function(_CafeStore) _then;

/// Create a copy of CafeStore
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = null,Object? phone = null,Object? latitude = null,Object? longitude = null,Object? weekdayHours = null,Object? weekendHours = null,Object? services = null,Object? sortOrder = null,Object? notice = null,Object? congestion = null,Object? congestionUpdatedAt = freezed,}) {
  return _then(_CafeStore(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,weekdayHours: null == weekdayHours ? _self.weekdayHours : weekdayHours // ignore: cast_nullable_to_non_nullable
as String,weekendHours: null == weekendHours ? _self.weekendHours : weekendHours // ignore: cast_nullable_to_non_nullable
as String,services: null == services ? _self._services : services // ignore: cast_nullable_to_non_nullable
as List<String>,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,notice: null == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as String,congestion: null == congestion ? _self.congestion : congestion // ignore: cast_nullable_to_non_nullable
as StoreCongestion,congestionUpdatedAt: freezed == congestionUpdatedAt ? _self.congestionUpdatedAt : congestionUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$StoreActivity {

 String get storeId;/// 아직 음료가 나오지 않은 픽업 주문 수.
 int get activeOrders; StoreCongestion get congestion; DateTime get updatedAt;
/// Create a copy of StoreActivity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreActivityCopyWith<StoreActivity> get copyWith => _$StoreActivityCopyWithImpl<StoreActivity>(this as StoreActivity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreActivity&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.activeOrders, activeOrders) || other.activeOrders == activeOrders)&&(identical(other.congestion, congestion) || other.congestion == congestion)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,storeId,activeOrders,congestion,updatedAt);

@override
String toString() {
  return 'StoreActivity(storeId: $storeId, activeOrders: $activeOrders, congestion: $congestion, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $StoreActivityCopyWith<$Res>  {
  factory $StoreActivityCopyWith(StoreActivity value, $Res Function(StoreActivity) _then) = _$StoreActivityCopyWithImpl;
@useResult
$Res call({
 String storeId, int activeOrders, StoreCongestion congestion, DateTime updatedAt
});




}
/// @nodoc
class _$StoreActivityCopyWithImpl<$Res>
    implements $StoreActivityCopyWith<$Res> {
  _$StoreActivityCopyWithImpl(this._self, this._then);

  final StoreActivity _self;
  final $Res Function(StoreActivity) _then;

/// Create a copy of StoreActivity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storeId = null,Object? activeOrders = null,Object? congestion = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,activeOrders: null == activeOrders ? _self.activeOrders : activeOrders // ignore: cast_nullable_to_non_nullable
as int,congestion: null == congestion ? _self.congestion : congestion // ignore: cast_nullable_to_non_nullable
as StoreCongestion,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreActivity].
extension StoreActivityPatterns on StoreActivity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreActivity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreActivity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreActivity value)  $default,){
final _that = this;
switch (_that) {
case _StoreActivity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreActivity value)?  $default,){
final _that = this;
switch (_that) {
case _StoreActivity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String storeId,  int activeOrders,  StoreCongestion congestion,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreActivity() when $default != null:
return $default(_that.storeId,_that.activeOrders,_that.congestion,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String storeId,  int activeOrders,  StoreCongestion congestion,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _StoreActivity():
return $default(_that.storeId,_that.activeOrders,_that.congestion,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String storeId,  int activeOrders,  StoreCongestion congestion,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _StoreActivity() when $default != null:
return $default(_that.storeId,_that.activeOrders,_that.congestion,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _StoreActivity extends StoreActivity {
  const _StoreActivity({required this.storeId, this.activeOrders = 0, this.congestion = StoreCongestion.unknown, required this.updatedAt}): super._();
  

@override final  String storeId;
/// 아직 음료가 나오지 않은 픽업 주문 수.
@override@JsonKey() final  int activeOrders;
@override@JsonKey() final  StoreCongestion congestion;
@override final  DateTime updatedAt;

/// Create a copy of StoreActivity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreActivityCopyWith<_StoreActivity> get copyWith => __$StoreActivityCopyWithImpl<_StoreActivity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreActivity&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.activeOrders, activeOrders) || other.activeOrders == activeOrders)&&(identical(other.congestion, congestion) || other.congestion == congestion)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,storeId,activeOrders,congestion,updatedAt);

@override
String toString() {
  return 'StoreActivity(storeId: $storeId, activeOrders: $activeOrders, congestion: $congestion, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$StoreActivityCopyWith<$Res> implements $StoreActivityCopyWith<$Res> {
  factory _$StoreActivityCopyWith(_StoreActivity value, $Res Function(_StoreActivity) _then) = __$StoreActivityCopyWithImpl;
@override @useResult
$Res call({
 String storeId, int activeOrders, StoreCongestion congestion, DateTime updatedAt
});




}
/// @nodoc
class __$StoreActivityCopyWithImpl<$Res>
    implements _$StoreActivityCopyWith<$Res> {
  __$StoreActivityCopyWithImpl(this._self, this._then);

  final _StoreActivity _self;
  final $Res Function(_StoreActivity) _then;

/// Create a copy of StoreActivity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storeId = null,Object? activeOrders = null,Object? congestion = null,Object? updatedAt = null,}) {
  return _then(_StoreActivity(
storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,activeOrders: null == activeOrders ? _self.activeOrders : activeOrders // ignore: cast_nullable_to_non_nullable
as int,congestion: null == congestion ? _self.congestion : congestion // ignore: cast_nullable_to_non_nullable
as StoreCongestion,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
