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

 String get id; PointHistoryType get type; String get description; int get amount; int? get paymentAmount; int? get bonusAmount; String? get paymentKey; DateTime get createdAt;
/// Create a copy of PointHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PointHistoryEntryCopyWith<PointHistoryEntry> get copyWith => _$PointHistoryEntryCopyWithImpl<PointHistoryEntry>(this as PointHistoryEntry, _$identity);

  /// Serializes this PointHistoryEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PointHistoryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paymentAmount, paymentAmount) || other.paymentAmount == paymentAmount)&&(identical(other.bonusAmount, bonusAmount) || other.bonusAmount == bonusAmount)&&(identical(other.paymentKey, paymentKey) || other.paymentKey == paymentKey)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,description,amount,paymentAmount,bonusAmount,paymentKey,createdAt);

@override
String toString() {
  return 'PointHistoryEntry(id: $id, type: $type, description: $description, amount: $amount, paymentAmount: $paymentAmount, bonusAmount: $bonusAmount, paymentKey: $paymentKey, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PointHistoryEntryCopyWith<$Res>  {
  factory $PointHistoryEntryCopyWith(PointHistoryEntry value, $Res Function(PointHistoryEntry) _then) = _$PointHistoryEntryCopyWithImpl;
@useResult
$Res call({
 String id, PointHistoryType type, String description, int amount, int? paymentAmount, int? bonusAmount, String? paymentKey, DateTime createdAt
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? description = null,Object? amount = null,Object? paymentAmount = freezed,Object? bonusAmount = freezed,Object? paymentKey = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PointHistoryType,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,paymentAmount: freezed == paymentAmount ? _self.paymentAmount : paymentAmount // ignore: cast_nullable_to_non_nullable
as int?,bonusAmount: freezed == bonusAmount ? _self.bonusAmount : bonusAmount // ignore: cast_nullable_to_non_nullable
as int?,paymentKey: freezed == paymentKey ? _self.paymentKey : paymentKey // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  PointHistoryType type,  String description,  int amount,  int? paymentAmount,  int? bonusAmount,  String? paymentKey,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PointHistoryEntry() when $default != null:
return $default(_that.id,_that.type,_that.description,_that.amount,_that.paymentAmount,_that.bonusAmount,_that.paymentKey,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  PointHistoryType type,  String description,  int amount,  int? paymentAmount,  int? bonusAmount,  String? paymentKey,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _PointHistoryEntry():
return $default(_that.id,_that.type,_that.description,_that.amount,_that.paymentAmount,_that.bonusAmount,_that.paymentKey,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  PointHistoryType type,  String description,  int amount,  int? paymentAmount,  int? bonusAmount,  String? paymentKey,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PointHistoryEntry() when $default != null:
return $default(_that.id,_that.type,_that.description,_that.amount,_that.paymentAmount,_that.bonusAmount,_that.paymentKey,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PointHistoryEntry extends PointHistoryEntry {
  const _PointHistoryEntry({required this.id, required this.type, required this.description, required this.amount, this.paymentAmount, this.bonusAmount, this.paymentKey, required this.createdAt}): super._();
  factory _PointHistoryEntry.fromJson(Map<String, dynamic> json) => _$PointHistoryEntryFromJson(json);

@override final  String id;
@override final  PointHistoryType type;
@override final  String description;
@override final  int amount;
@override final  int? paymentAmount;
@override final  int? bonusAmount;
@override final  String? paymentKey;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PointHistoryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paymentAmount, paymentAmount) || other.paymentAmount == paymentAmount)&&(identical(other.bonusAmount, bonusAmount) || other.bonusAmount == bonusAmount)&&(identical(other.paymentKey, paymentKey) || other.paymentKey == paymentKey)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,description,amount,paymentAmount,bonusAmount,paymentKey,createdAt);

@override
String toString() {
  return 'PointHistoryEntry(id: $id, type: $type, description: $description, amount: $amount, paymentAmount: $paymentAmount, bonusAmount: $bonusAmount, paymentKey: $paymentKey, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PointHistoryEntryCopyWith<$Res> implements $PointHistoryEntryCopyWith<$Res> {
  factory _$PointHistoryEntryCopyWith(_PointHistoryEntry value, $Res Function(_PointHistoryEntry) _then) = __$PointHistoryEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, PointHistoryType type, String description, int amount, int? paymentAmount, int? bonusAmount, String? paymentKey, DateTime createdAt
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? description = null,Object? amount = null,Object? paymentAmount = freezed,Object? bonusAmount = freezed,Object? paymentKey = freezed,Object? createdAt = null,}) {
  return _then(_PointHistoryEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PointHistoryType,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,paymentAmount: freezed == paymentAmount ? _self.paymentAmount : paymentAmount // ignore: cast_nullable_to_non_nullable
as int?,bonusAmount: freezed == bonusAmount ? _self.bonusAmount : bonusAmount // ignore: cast_nullable_to_non_nullable
as int?,paymentKey: freezed == paymentKey ? _self.paymentKey : paymentKey // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$PointsEarnResult {

 String get membershipId; int get paymentAmount; int get earned; int get balance;
/// Create a copy of PointsEarnResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PointsEarnResultCopyWith<PointsEarnResult> get copyWith => _$PointsEarnResultCopyWithImpl<PointsEarnResult>(this as PointsEarnResult, _$identity);

  /// Serializes this PointsEarnResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PointsEarnResult&&(identical(other.membershipId, membershipId) || other.membershipId == membershipId)&&(identical(other.paymentAmount, paymentAmount) || other.paymentAmount == paymentAmount)&&(identical(other.earned, earned) || other.earned == earned)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,membershipId,paymentAmount,earned,balance);

@override
String toString() {
  return 'PointsEarnResult(membershipId: $membershipId, paymentAmount: $paymentAmount, earned: $earned, balance: $balance)';
}


}

/// @nodoc
abstract mixin class $PointsEarnResultCopyWith<$Res>  {
  factory $PointsEarnResultCopyWith(PointsEarnResult value, $Res Function(PointsEarnResult) _then) = _$PointsEarnResultCopyWithImpl;
@useResult
$Res call({
 String membershipId, int paymentAmount, int earned, int balance
});




}
/// @nodoc
class _$PointsEarnResultCopyWithImpl<$Res>
    implements $PointsEarnResultCopyWith<$Res> {
  _$PointsEarnResultCopyWithImpl(this._self, this._then);

  final PointsEarnResult _self;
  final $Res Function(PointsEarnResult) _then;

/// Create a copy of PointsEarnResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? membershipId = null,Object? paymentAmount = null,Object? earned = null,Object? balance = null,}) {
  return _then(_self.copyWith(
membershipId: null == membershipId ? _self.membershipId : membershipId // ignore: cast_nullable_to_non_nullable
as String,paymentAmount: null == paymentAmount ? _self.paymentAmount : paymentAmount // ignore: cast_nullable_to_non_nullable
as int,earned: null == earned ? _self.earned : earned // ignore: cast_nullable_to_non_nullable
as int,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PointsEarnResult].
extension PointsEarnResultPatterns on PointsEarnResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PointsEarnResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PointsEarnResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PointsEarnResult value)  $default,){
final _that = this;
switch (_that) {
case _PointsEarnResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PointsEarnResult value)?  $default,){
final _that = this;
switch (_that) {
case _PointsEarnResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String membershipId,  int paymentAmount,  int earned,  int balance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PointsEarnResult() when $default != null:
return $default(_that.membershipId,_that.paymentAmount,_that.earned,_that.balance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String membershipId,  int paymentAmount,  int earned,  int balance)  $default,) {final _that = this;
switch (_that) {
case _PointsEarnResult():
return $default(_that.membershipId,_that.paymentAmount,_that.earned,_that.balance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String membershipId,  int paymentAmount,  int earned,  int balance)?  $default,) {final _that = this;
switch (_that) {
case _PointsEarnResult() when $default != null:
return $default(_that.membershipId,_that.paymentAmount,_that.earned,_that.balance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PointsEarnResult implements PointsEarnResult {
  const _PointsEarnResult({required this.membershipId, required this.paymentAmount, required this.earned, required this.balance});
  factory _PointsEarnResult.fromJson(Map<String, dynamic> json) => _$PointsEarnResultFromJson(json);

@override final  String membershipId;
@override final  int paymentAmount;
@override final  int earned;
@override final  int balance;

/// Create a copy of PointsEarnResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PointsEarnResultCopyWith<_PointsEarnResult> get copyWith => __$PointsEarnResultCopyWithImpl<_PointsEarnResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PointsEarnResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PointsEarnResult&&(identical(other.membershipId, membershipId) || other.membershipId == membershipId)&&(identical(other.paymentAmount, paymentAmount) || other.paymentAmount == paymentAmount)&&(identical(other.earned, earned) || other.earned == earned)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,membershipId,paymentAmount,earned,balance);

@override
String toString() {
  return 'PointsEarnResult(membershipId: $membershipId, paymentAmount: $paymentAmount, earned: $earned, balance: $balance)';
}


}

/// @nodoc
abstract mixin class _$PointsEarnResultCopyWith<$Res> implements $PointsEarnResultCopyWith<$Res> {
  factory _$PointsEarnResultCopyWith(_PointsEarnResult value, $Res Function(_PointsEarnResult) _then) = __$PointsEarnResultCopyWithImpl;
@override @useResult
$Res call({
 String membershipId, int paymentAmount, int earned, int balance
});




}
/// @nodoc
class __$PointsEarnResultCopyWithImpl<$Res>
    implements _$PointsEarnResultCopyWith<$Res> {
  __$PointsEarnResultCopyWithImpl(this._self, this._then);

  final _PointsEarnResult _self;
  final $Res Function(_PointsEarnResult) _then;

/// Create a copy of PointsEarnResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? membershipId = null,Object? paymentAmount = null,Object? earned = null,Object? balance = null,}) {
  return _then(_PointsEarnResult(
membershipId: null == membershipId ? _self.membershipId : membershipId // ignore: cast_nullable_to_non_nullable
as String,paymentAmount: null == paymentAmount ? _self.paymentAmount : paymentAmount // ignore: cast_nullable_to_non_nullable
as int,earned: null == earned ? _self.earned : earned // ignore: cast_nullable_to_non_nullable
as int,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
