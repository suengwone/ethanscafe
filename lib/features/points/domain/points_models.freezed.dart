// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'points_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PointsData {

 String get membershipId; int get balance; List<PointHistoryEntry> get history;
/// Create a copy of PointsData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PointsDataCopyWith<PointsData> get copyWith => _$PointsDataCopyWithImpl<PointsData>(this as PointsData, _$identity);

  /// Serializes this PointsData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PointsData&&(identical(other.membershipId, membershipId) || other.membershipId == membershipId)&&(identical(other.balance, balance) || other.balance == balance)&&const DeepCollectionEquality().equals(other.history, history));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,membershipId,balance,const DeepCollectionEquality().hash(history));

@override
String toString() {
  return 'PointsData(membershipId: $membershipId, balance: $balance, history: $history)';
}


}

/// @nodoc
abstract mixin class $PointsDataCopyWith<$Res>  {
  factory $PointsDataCopyWith(PointsData value, $Res Function(PointsData) _then) = _$PointsDataCopyWithImpl;
@useResult
$Res call({
 String membershipId, int balance, List<PointHistoryEntry> history
});




}
/// @nodoc
class _$PointsDataCopyWithImpl<$Res>
    implements $PointsDataCopyWith<$Res> {
  _$PointsDataCopyWithImpl(this._self, this._then);

  final PointsData _self;
  final $Res Function(PointsData) _then;

/// Create a copy of PointsData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? membershipId = null,Object? balance = null,Object? history = null,}) {
  return _then(_self.copyWith(
membershipId: null == membershipId ? _self.membershipId : membershipId // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<PointHistoryEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [PointsData].
extension PointsDataPatterns on PointsData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PointsData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PointsData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PointsData value)  $default,){
final _that = this;
switch (_that) {
case _PointsData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PointsData value)?  $default,){
final _that = this;
switch (_that) {
case _PointsData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String membershipId,  int balance,  List<PointHistoryEntry> history)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PointsData() when $default != null:
return $default(_that.membershipId,_that.balance,_that.history);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String membershipId,  int balance,  List<PointHistoryEntry> history)  $default,) {final _that = this;
switch (_that) {
case _PointsData():
return $default(_that.membershipId,_that.balance,_that.history);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String membershipId,  int balance,  List<PointHistoryEntry> history)?  $default,) {final _that = this;
switch (_that) {
case _PointsData() when $default != null:
return $default(_that.membershipId,_that.balance,_that.history);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PointsData extends PointsData {
  const _PointsData({required this.membershipId, this.balance = 0, final  List<PointHistoryEntry> history = const <PointHistoryEntry>[]}): _history = history,super._();
  factory _PointsData.fromJson(Map<String, dynamic> json) => _$PointsDataFromJson(json);

@override final  String membershipId;
@override@JsonKey() final  int balance;
 final  List<PointHistoryEntry> _history;
@override@JsonKey() List<PointHistoryEntry> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}


/// Create a copy of PointsData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PointsDataCopyWith<_PointsData> get copyWith => __$PointsDataCopyWithImpl<_PointsData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PointsDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PointsData&&(identical(other.membershipId, membershipId) || other.membershipId == membershipId)&&(identical(other.balance, balance) || other.balance == balance)&&const DeepCollectionEquality().equals(other._history, _history));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,membershipId,balance,const DeepCollectionEquality().hash(_history));

@override
String toString() {
  return 'PointsData(membershipId: $membershipId, balance: $balance, history: $history)';
}


}

/// @nodoc
abstract mixin class _$PointsDataCopyWith<$Res> implements $PointsDataCopyWith<$Res> {
  factory _$PointsDataCopyWith(_PointsData value, $Res Function(_PointsData) _then) = __$PointsDataCopyWithImpl;
@override @useResult
$Res call({
 String membershipId, int balance, List<PointHistoryEntry> history
});




}
/// @nodoc
class __$PointsDataCopyWithImpl<$Res>
    implements _$PointsDataCopyWith<$Res> {
  __$PointsDataCopyWithImpl(this._self, this._then);

  final _PointsData _self;
  final $Res Function(_PointsData) _then;

/// Create a copy of PointsData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? membershipId = null,Object? balance = null,Object? history = null,}) {
  return _then(_PointsData(
membershipId: null == membershipId ? _self.membershipId : membershipId // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<PointHistoryEntry>,
  ));
}


}


/// @nodoc
mixin _$PointHistoryEntry {

 String get id; PointHistoryType get type; String get description; int get amount; int? get paymentAmount; DateTime get createdAt;
/// Create a copy of PointHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PointHistoryEntryCopyWith<PointHistoryEntry> get copyWith => _$PointHistoryEntryCopyWithImpl<PointHistoryEntry>(this as PointHistoryEntry, _$identity);

  /// Serializes this PointHistoryEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PointHistoryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paymentAmount, paymentAmount) || other.paymentAmount == paymentAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,description,amount,paymentAmount,createdAt);

@override
String toString() {
  return 'PointHistoryEntry(id: $id, type: $type, description: $description, amount: $amount, paymentAmount: $paymentAmount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PointHistoryEntryCopyWith<$Res>  {
  factory $PointHistoryEntryCopyWith(PointHistoryEntry value, $Res Function(PointHistoryEntry) _then) = _$PointHistoryEntryCopyWithImpl;
@useResult
$Res call({
 String id, PointHistoryType type, String description, int amount, int? paymentAmount, DateTime createdAt
});




}
/// @nodoc
class _$PointHistoryEntryCopyWithImpl<$Res>
    implements $PointHistoryEntryCopyWith<$Res> {
  _$PointHistoryEntryCopyWithImpl(this._self, this._then);

  final PointHistoryEntry _self;
  final $Res Function(PointHistoryEntry) _then;

/// Create a copy of PointHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? description = null,Object? amount = null,Object? paymentAmount = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PointHistoryType,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,paymentAmount: freezed == paymentAmount ? _self.paymentAmount : paymentAmount // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PointHistoryEntry].
extension PointHistoryEntryPatterns on PointHistoryEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PointHistoryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PointHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PointHistoryEntry value)  $default,){
final _that = this;
switch (_that) {
case _PointHistoryEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PointHistoryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _PointHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  PointHistoryType type,  String description,  int amount,  int? paymentAmount,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PointHistoryEntry() when $default != null:
return $default(_that.id,_that.type,_that.description,_that.amount,_that.paymentAmount,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  PointHistoryType type,  String description,  int amount,  int? paymentAmount,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _PointHistoryEntry():
return $default(_that.id,_that.type,_that.description,_that.amount,_that.paymentAmount,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  PointHistoryType type,  String description,  int amount,  int? paymentAmount,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PointHistoryEntry() when $default != null:
return $default(_that.id,_that.type,_that.description,_that.amount,_that.paymentAmount,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PointHistoryEntry extends PointHistoryEntry {
  const _PointHistoryEntry({required this.id, required this.type, required this.description, required this.amount, this.paymentAmount, required this.createdAt}): super._();
  factory _PointHistoryEntry.fromJson(Map<String, dynamic> json) => _$PointHistoryEntryFromJson(json);

@override final  String id;
@override final  PointHistoryType type;
@override final  String description;
@override final  int amount;
@override final  int? paymentAmount;
@override final  DateTime createdAt;

/// Create a copy of PointHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PointHistoryEntryCopyWith<_PointHistoryEntry> get copyWith => __$PointHistoryEntryCopyWithImpl<_PointHistoryEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PointHistoryEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PointHistoryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paymentAmount, paymentAmount) || other.paymentAmount == paymentAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,description,amount,paymentAmount,createdAt);

@override
String toString() {
  return 'PointHistoryEntry(id: $id, type: $type, description: $description, amount: $amount, paymentAmount: $paymentAmount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PointHistoryEntryCopyWith<$Res> implements $PointHistoryEntryCopyWith<$Res> {
  factory _$PointHistoryEntryCopyWith(_PointHistoryEntry value, $Res Function(_PointHistoryEntry) _then) = __$PointHistoryEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, PointHistoryType type, String description, int amount, int? paymentAmount, DateTime createdAt
});




}
/// @nodoc
class __$PointHistoryEntryCopyWithImpl<$Res>
    implements _$PointHistoryEntryCopyWith<$Res> {
  __$PointHistoryEntryCopyWithImpl(this._self, this._then);

  final _PointHistoryEntry _self;
  final $Res Function(_PointHistoryEntry) _then;

/// Create a copy of PointHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? description = null,Object? amount = null,Object? paymentAmount = freezed,Object? createdAt = null,}) {
  return _then(_PointHistoryEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PointHistoryType,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,paymentAmount: freezed == paymentAmount ? _self.paymentAmount : paymentAmount // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$QrEarnResult {

 String get storeName; int get paymentAmount; int get earned; int get balance;
/// Create a copy of QrEarnResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QrEarnResultCopyWith<QrEarnResult> get copyWith => _$QrEarnResultCopyWithImpl<QrEarnResult>(this as QrEarnResult, _$identity);

  /// Serializes this QrEarnResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QrEarnResult&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.paymentAmount, paymentAmount) || other.paymentAmount == paymentAmount)&&(identical(other.earned, earned) || other.earned == earned)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storeName,paymentAmount,earned,balance);

@override
String toString() {
  return 'QrEarnResult(storeName: $storeName, paymentAmount: $paymentAmount, earned: $earned, balance: $balance)';
}


}

/// @nodoc
abstract mixin class $QrEarnResultCopyWith<$Res>  {
  factory $QrEarnResultCopyWith(QrEarnResult value, $Res Function(QrEarnResult) _then) = _$QrEarnResultCopyWithImpl;
@useResult
$Res call({
 String storeName, int paymentAmount, int earned, int balance
});




}
/// @nodoc
class _$QrEarnResultCopyWithImpl<$Res>
    implements $QrEarnResultCopyWith<$Res> {
  _$QrEarnResultCopyWithImpl(this._self, this._then);

  final QrEarnResult _self;
  final $Res Function(QrEarnResult) _then;

/// Create a copy of QrEarnResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storeName = null,Object? paymentAmount = null,Object? earned = null,Object? balance = null,}) {
  return _then(_self.copyWith(
storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,paymentAmount: null == paymentAmount ? _self.paymentAmount : paymentAmount // ignore: cast_nullable_to_non_nullable
as int,earned: null == earned ? _self.earned : earned // ignore: cast_nullable_to_non_nullable
as int,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QrEarnResult].
extension QrEarnResultPatterns on QrEarnResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QrEarnResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QrEarnResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QrEarnResult value)  $default,){
final _that = this;
switch (_that) {
case _QrEarnResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QrEarnResult value)?  $default,){
final _that = this;
switch (_that) {
case _QrEarnResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String storeName,  int paymentAmount,  int earned,  int balance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QrEarnResult() when $default != null:
return $default(_that.storeName,_that.paymentAmount,_that.earned,_that.balance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String storeName,  int paymentAmount,  int earned,  int balance)  $default,) {final _that = this;
switch (_that) {
case _QrEarnResult():
return $default(_that.storeName,_that.paymentAmount,_that.earned,_that.balance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String storeName,  int paymentAmount,  int earned,  int balance)?  $default,) {final _that = this;
switch (_that) {
case _QrEarnResult() when $default != null:
return $default(_that.storeName,_that.paymentAmount,_that.earned,_that.balance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QrEarnResult implements QrEarnResult {
  const _QrEarnResult({required this.storeName, required this.paymentAmount, required this.earned, required this.balance});
  factory _QrEarnResult.fromJson(Map<String, dynamic> json) => _$QrEarnResultFromJson(json);

@override final  String storeName;
@override final  int paymentAmount;
@override final  int earned;
@override final  int balance;

/// Create a copy of QrEarnResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QrEarnResultCopyWith<_QrEarnResult> get copyWith => __$QrEarnResultCopyWithImpl<_QrEarnResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QrEarnResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QrEarnResult&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.paymentAmount, paymentAmount) || other.paymentAmount == paymentAmount)&&(identical(other.earned, earned) || other.earned == earned)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storeName,paymentAmount,earned,balance);

@override
String toString() {
  return 'QrEarnResult(storeName: $storeName, paymentAmount: $paymentAmount, earned: $earned, balance: $balance)';
}


}

/// @nodoc
abstract mixin class _$QrEarnResultCopyWith<$Res> implements $QrEarnResultCopyWith<$Res> {
  factory _$QrEarnResultCopyWith(_QrEarnResult value, $Res Function(_QrEarnResult) _then) = __$QrEarnResultCopyWithImpl;
@override @useResult
$Res call({
 String storeName, int paymentAmount, int earned, int balance
});




}
/// @nodoc
class __$QrEarnResultCopyWithImpl<$Res>
    implements _$QrEarnResultCopyWith<$Res> {
  __$QrEarnResultCopyWithImpl(this._self, this._then);

  final _QrEarnResult _self;
  final $Res Function(_QrEarnResult) _then;

/// Create a copy of QrEarnResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storeName = null,Object? paymentAmount = null,Object? earned = null,Object? balance = null,}) {
  return _then(_QrEarnResult(
storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,paymentAmount: null == paymentAmount ? _self.paymentAmount : paymentAmount // ignore: cast_nullable_to_non_nullable
as int,earned: null == earned ? _self.earned : earned // ignore: cast_nullable_to_non_nullable
as int,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
