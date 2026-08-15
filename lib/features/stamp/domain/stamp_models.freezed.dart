// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stamp_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StampData {

 int get count; int get totalEarned; List<StampHistoryEntry> get history;
/// Create a copy of StampData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StampDataCopyWith<StampData> get copyWith => _$StampDataCopyWithImpl<StampData>(this as StampData, _$identity);

  /// Serializes this StampData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StampData&&(identical(other.count, count) || other.count == count)&&(identical(other.totalEarned, totalEarned) || other.totalEarned == totalEarned)&&const DeepCollectionEquality().equals(other.history, history));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,totalEarned,const DeepCollectionEquality().hash(history));

@override
String toString() {
  return 'StampData(count: $count, totalEarned: $totalEarned, history: $history)';
}


}

/// @nodoc
abstract mixin class $StampDataCopyWith<$Res>  {
  factory $StampDataCopyWith(StampData value, $Res Function(StampData) _then) = _$StampDataCopyWithImpl;
@useResult
$Res call({
 int count, int totalEarned, List<StampHistoryEntry> history
});




}
/// @nodoc
class _$StampDataCopyWithImpl<$Res>
    implements $StampDataCopyWith<$Res> {
  _$StampDataCopyWithImpl(this._self, this._then);

  final StampData _self;
  final $Res Function(StampData) _then;

/// Create a copy of StampData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? totalEarned = null,Object? history = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,totalEarned: null == totalEarned ? _self.totalEarned : totalEarned // ignore: cast_nullable_to_non_nullable
as int,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<StampHistoryEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [StampData].
extension StampDataPatterns on StampData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StampData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StampData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StampData value)  $default,){
final _that = this;
switch (_that) {
case _StampData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StampData value)?  $default,){
final _that = this;
switch (_that) {
case _StampData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  int totalEarned,  List<StampHistoryEntry> history)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StampData() when $default != null:
return $default(_that.count,_that.totalEarned,_that.history);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  int totalEarned,  List<StampHistoryEntry> history)  $default,) {final _that = this;
switch (_that) {
case _StampData():
return $default(_that.count,_that.totalEarned,_that.history);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  int totalEarned,  List<StampHistoryEntry> history)?  $default,) {final _that = this;
switch (_that) {
case _StampData() when $default != null:
return $default(_that.count,_that.totalEarned,_that.history);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StampData extends StampData {
  const _StampData({this.count = 0, this.totalEarned = 0, final  List<StampHistoryEntry> history = const <StampHistoryEntry>[]}): _history = history,super._();
  factory _StampData.fromJson(Map<String, dynamic> json) => _$StampDataFromJson(json);

@override@JsonKey() final  int count;
@override@JsonKey() final  int totalEarned;
 final  List<StampHistoryEntry> _history;
@override@JsonKey() List<StampHistoryEntry> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}


/// Create a copy of StampData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StampDataCopyWith<_StampData> get copyWith => __$StampDataCopyWithImpl<_StampData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StampDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StampData&&(identical(other.count, count) || other.count == count)&&(identical(other.totalEarned, totalEarned) || other.totalEarned == totalEarned)&&const DeepCollectionEquality().equals(other._history, _history));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,totalEarned,const DeepCollectionEquality().hash(_history));

@override
String toString() {
  return 'StampData(count: $count, totalEarned: $totalEarned, history: $history)';
}


}

/// @nodoc
abstract mixin class _$StampDataCopyWith<$Res> implements $StampDataCopyWith<$Res> {
  factory _$StampDataCopyWith(_StampData value, $Res Function(_StampData) _then) = __$StampDataCopyWithImpl;
@override @useResult
$Res call({
 int count, int totalEarned, List<StampHistoryEntry> history
});




}
/// @nodoc
class __$StampDataCopyWithImpl<$Res>
    implements _$StampDataCopyWith<$Res> {
  __$StampDataCopyWithImpl(this._self, this._then);

  final _StampData _self;
  final $Res Function(_StampData) _then;

/// Create a copy of StampData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? totalEarned = null,Object? history = null,}) {
  return _then(_StampData(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,totalEarned: null == totalEarned ? _self.totalEarned : totalEarned // ignore: cast_nullable_to_non_nullable
as int,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<StampHistoryEntry>,
  ));
}


}


/// @nodoc
mixin _$StampHistoryEntry {

 String get id; int get cups; int get rewards; DateTime get createdAt;
/// Create a copy of StampHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StampHistoryEntryCopyWith<StampHistoryEntry> get copyWith => _$StampHistoryEntryCopyWithImpl<StampHistoryEntry>(this as StampHistoryEntry, _$identity);

  /// Serializes this StampHistoryEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StampHistoryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.cups, cups) || other.cups == cups)&&(identical(other.rewards, rewards) || other.rewards == rewards)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,cups,rewards,createdAt);

@override
String toString() {
  return 'StampHistoryEntry(id: $id, cups: $cups, rewards: $rewards, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $StampHistoryEntryCopyWith<$Res>  {
  factory $StampHistoryEntryCopyWith(StampHistoryEntry value, $Res Function(StampHistoryEntry) _then) = _$StampHistoryEntryCopyWithImpl;
@useResult
$Res call({
 String id, int cups, int rewards, DateTime createdAt
});




}
/// @nodoc
class _$StampHistoryEntryCopyWithImpl<$Res>
    implements $StampHistoryEntryCopyWith<$Res> {
  _$StampHistoryEntryCopyWithImpl(this._self, this._then);

  final StampHistoryEntry _self;
  final $Res Function(StampHistoryEntry) _then;

/// Create a copy of StampHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? cups = null,Object? rewards = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,cups: null == cups ? _self.cups : cups // ignore: cast_nullable_to_non_nullable
as int,rewards: null == rewards ? _self.rewards : rewards // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StampHistoryEntry].
extension StampHistoryEntryPatterns on StampHistoryEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StampHistoryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StampHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StampHistoryEntry value)  $default,){
final _that = this;
switch (_that) {
case _StampHistoryEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StampHistoryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _StampHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int cups,  int rewards,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StampHistoryEntry() when $default != null:
return $default(_that.id,_that.cups,_that.rewards,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int cups,  int rewards,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _StampHistoryEntry():
return $default(_that.id,_that.cups,_that.rewards,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int cups,  int rewards,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _StampHistoryEntry() when $default != null:
return $default(_that.id,_that.cups,_that.rewards,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StampHistoryEntry implements StampHistoryEntry {
  const _StampHistoryEntry({required this.id, required this.cups, this.rewards = 0, required this.createdAt});
  factory _StampHistoryEntry.fromJson(Map<String, dynamic> json) => _$StampHistoryEntryFromJson(json);

@override final  String id;
@override final  int cups;
@override@JsonKey() final  int rewards;
@override final  DateTime createdAt;

/// Create a copy of StampHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StampHistoryEntryCopyWith<_StampHistoryEntry> get copyWith => __$StampHistoryEntryCopyWithImpl<_StampHistoryEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StampHistoryEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StampHistoryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.cups, cups) || other.cups == cups)&&(identical(other.rewards, rewards) || other.rewards == rewards)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,cups,rewards,createdAt);

@override
String toString() {
  return 'StampHistoryEntry(id: $id, cups: $cups, rewards: $rewards, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$StampHistoryEntryCopyWith<$Res> implements $StampHistoryEntryCopyWith<$Res> {
  factory _$StampHistoryEntryCopyWith(_StampHistoryEntry value, $Res Function(_StampHistoryEntry) _then) = __$StampHistoryEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, int cups, int rewards, DateTime createdAt
});




}
/// @nodoc
class __$StampHistoryEntryCopyWithImpl<$Res>
    implements _$StampHistoryEntryCopyWith<$Res> {
  __$StampHistoryEntryCopyWithImpl(this._self, this._then);

  final _StampHistoryEntry _self;
  final $Res Function(_StampHistoryEntry) _then;

/// Create a copy of StampHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? cups = null,Object? rewards = null,Object? createdAt = null,}) {
  return _then(_StampHistoryEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,cups: null == cups ? _self.cups : cups // ignore: cast_nullable_to_non_nullable
as int,rewards: null == rewards ? _self.rewards : rewards // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$StampEarnResult {

 String get membershipId; int get cups; int get count; int get totalEarned; int get rewardsIssued;
/// Create a copy of StampEarnResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StampEarnResultCopyWith<StampEarnResult> get copyWith => _$StampEarnResultCopyWithImpl<StampEarnResult>(this as StampEarnResult, _$identity);

  /// Serializes this StampEarnResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StampEarnResult&&(identical(other.membershipId, membershipId) || other.membershipId == membershipId)&&(identical(other.cups, cups) || other.cups == cups)&&(identical(other.count, count) || other.count == count)&&(identical(other.totalEarned, totalEarned) || other.totalEarned == totalEarned)&&(identical(other.rewardsIssued, rewardsIssued) || other.rewardsIssued == rewardsIssued));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,membershipId,cups,count,totalEarned,rewardsIssued);

@override
String toString() {
  return 'StampEarnResult(membershipId: $membershipId, cups: $cups, count: $count, totalEarned: $totalEarned, rewardsIssued: $rewardsIssued)';
}


}

/// @nodoc
abstract mixin class $StampEarnResultCopyWith<$Res>  {
  factory $StampEarnResultCopyWith(StampEarnResult value, $Res Function(StampEarnResult) _then) = _$StampEarnResultCopyWithImpl;
@useResult
$Res call({
 String membershipId, int cups, int count, int totalEarned, int rewardsIssued
});




}
/// @nodoc
class _$StampEarnResultCopyWithImpl<$Res>
    implements $StampEarnResultCopyWith<$Res> {
  _$StampEarnResultCopyWithImpl(this._self, this._then);

  final StampEarnResult _self;
  final $Res Function(StampEarnResult) _then;

/// Create a copy of StampEarnResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? membershipId = null,Object? cups = null,Object? count = null,Object? totalEarned = null,Object? rewardsIssued = null,}) {
  return _then(_self.copyWith(
membershipId: null == membershipId ? _self.membershipId : membershipId // ignore: cast_nullable_to_non_nullable
as String,cups: null == cups ? _self.cups : cups // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,totalEarned: null == totalEarned ? _self.totalEarned : totalEarned // ignore: cast_nullable_to_non_nullable
as int,rewardsIssued: null == rewardsIssued ? _self.rewardsIssued : rewardsIssued // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StampEarnResult].
extension StampEarnResultPatterns on StampEarnResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StampEarnResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StampEarnResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StampEarnResult value)  $default,){
final _that = this;
switch (_that) {
case _StampEarnResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StampEarnResult value)?  $default,){
final _that = this;
switch (_that) {
case _StampEarnResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String membershipId,  int cups,  int count,  int totalEarned,  int rewardsIssued)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StampEarnResult() when $default != null:
return $default(_that.membershipId,_that.cups,_that.count,_that.totalEarned,_that.rewardsIssued);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String membershipId,  int cups,  int count,  int totalEarned,  int rewardsIssued)  $default,) {final _that = this;
switch (_that) {
case _StampEarnResult():
return $default(_that.membershipId,_that.cups,_that.count,_that.totalEarned,_that.rewardsIssued);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String membershipId,  int cups,  int count,  int totalEarned,  int rewardsIssued)?  $default,) {final _that = this;
switch (_that) {
case _StampEarnResult() when $default != null:
return $default(_that.membershipId,_that.cups,_that.count,_that.totalEarned,_that.rewardsIssued);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StampEarnResult implements StampEarnResult {
  const _StampEarnResult({required this.membershipId, required this.cups, required this.count, required this.totalEarned, required this.rewardsIssued});
  factory _StampEarnResult.fromJson(Map<String, dynamic> json) => _$StampEarnResultFromJson(json);

@override final  String membershipId;
@override final  int cups;
@override final  int count;
@override final  int totalEarned;
@override final  int rewardsIssued;

/// Create a copy of StampEarnResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StampEarnResultCopyWith<_StampEarnResult> get copyWith => __$StampEarnResultCopyWithImpl<_StampEarnResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StampEarnResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StampEarnResult&&(identical(other.membershipId, membershipId) || other.membershipId == membershipId)&&(identical(other.cups, cups) || other.cups == cups)&&(identical(other.count, count) || other.count == count)&&(identical(other.totalEarned, totalEarned) || other.totalEarned == totalEarned)&&(identical(other.rewardsIssued, rewardsIssued) || other.rewardsIssued == rewardsIssued));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,membershipId,cups,count,totalEarned,rewardsIssued);

@override
String toString() {
  return 'StampEarnResult(membershipId: $membershipId, cups: $cups, count: $count, totalEarned: $totalEarned, rewardsIssued: $rewardsIssued)';
}


}

/// @nodoc
abstract mixin class _$StampEarnResultCopyWith<$Res> implements $StampEarnResultCopyWith<$Res> {
  factory _$StampEarnResultCopyWith(_StampEarnResult value, $Res Function(_StampEarnResult) _then) = __$StampEarnResultCopyWithImpl;
@override @useResult
$Res call({
 String membershipId, int cups, int count, int totalEarned, int rewardsIssued
});




}
/// @nodoc
class __$StampEarnResultCopyWithImpl<$Res>
    implements _$StampEarnResultCopyWith<$Res> {
  __$StampEarnResultCopyWithImpl(this._self, this._then);

  final _StampEarnResult _self;
  final $Res Function(_StampEarnResult) _then;

/// Create a copy of StampEarnResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? membershipId = null,Object? cups = null,Object? count = null,Object? totalEarned = null,Object? rewardsIssued = null,}) {
  return _then(_StampEarnResult(
membershipId: null == membershipId ? _self.membershipId : membershipId // ignore: cast_nullable_to_non_nullable
as String,cups: null == cups ? _self.cups : cups // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,totalEarned: null == totalEarned ? _self.totalEarned : totalEarned // ignore: cast_nullable_to_non_nullable
as int,rewardsIssued: null == rewardsIssued ? _self.rewardsIssued : rewardsIssued // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
