// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'referral_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReferralSummary {

 String get code; int get invitedCount; int get earnedPoints; String? get redeemedCode; int get reward; int get inviteLimit;
/// Create a copy of ReferralSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferralSummaryCopyWith<ReferralSummary> get copyWith => _$ReferralSummaryCopyWithImpl<ReferralSummary>(this as ReferralSummary, _$identity);

  /// Serializes this ReferralSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferralSummary&&(identical(other.code, code) || other.code == code)&&(identical(other.invitedCount, invitedCount) || other.invitedCount == invitedCount)&&(identical(other.earnedPoints, earnedPoints) || other.earnedPoints == earnedPoints)&&(identical(other.redeemedCode, redeemedCode) || other.redeemedCode == redeemedCode)&&(identical(other.reward, reward) || other.reward == reward)&&(identical(other.inviteLimit, inviteLimit) || other.inviteLimit == inviteLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,invitedCount,earnedPoints,redeemedCode,reward,inviteLimit);

@override
String toString() {
  return 'ReferralSummary(code: $code, invitedCount: $invitedCount, earnedPoints: $earnedPoints, redeemedCode: $redeemedCode, reward: $reward, inviteLimit: $inviteLimit)';
}


}

/// @nodoc
abstract mixin class $ReferralSummaryCopyWith<$Res>  {
  factory $ReferralSummaryCopyWith(ReferralSummary value, $Res Function(ReferralSummary) _then) = _$ReferralSummaryCopyWithImpl;
@useResult
$Res call({
 String code, int invitedCount, int earnedPoints, String? redeemedCode, int reward, int inviteLimit
});




}
/// @nodoc
class _$ReferralSummaryCopyWithImpl<$Res>
    implements $ReferralSummaryCopyWith<$Res> {
  _$ReferralSummaryCopyWithImpl(this._self, this._then);

  final ReferralSummary _self;
  final $Res Function(ReferralSummary) _then;

/// Create a copy of ReferralSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? invitedCount = null,Object? earnedPoints = null,Object? redeemedCode = freezed,Object? reward = null,Object? inviteLimit = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,invitedCount: null == invitedCount ? _self.invitedCount : invitedCount // ignore: cast_nullable_to_non_nullable
as int,earnedPoints: null == earnedPoints ? _self.earnedPoints : earnedPoints // ignore: cast_nullable_to_non_nullable
as int,redeemedCode: freezed == redeemedCode ? _self.redeemedCode : redeemedCode // ignore: cast_nullable_to_non_nullable
as String?,reward: null == reward ? _self.reward : reward // ignore: cast_nullable_to_non_nullable
as int,inviteLimit: null == inviteLimit ? _self.inviteLimit : inviteLimit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReferralSummary].
extension ReferralSummaryPatterns on ReferralSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReferralSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReferralSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReferralSummary value)  $default,){
final _that = this;
switch (_that) {
case _ReferralSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReferralSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ReferralSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  int invitedCount,  int earnedPoints,  String? redeemedCode,  int reward,  int inviteLimit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReferralSummary() when $default != null:
return $default(_that.code,_that.invitedCount,_that.earnedPoints,_that.redeemedCode,_that.reward,_that.inviteLimit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  int invitedCount,  int earnedPoints,  String? redeemedCode,  int reward,  int inviteLimit)  $default,) {final _that = this;
switch (_that) {
case _ReferralSummary():
return $default(_that.code,_that.invitedCount,_that.earnedPoints,_that.redeemedCode,_that.reward,_that.inviteLimit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  int invitedCount,  int earnedPoints,  String? redeemedCode,  int reward,  int inviteLimit)?  $default,) {final _that = this;
switch (_that) {
case _ReferralSummary() when $default != null:
return $default(_that.code,_that.invitedCount,_that.earnedPoints,_that.redeemedCode,_that.reward,_that.inviteLimit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReferralSummary extends ReferralSummary {
  const _ReferralSummary({required this.code, this.invitedCount = 0, this.earnedPoints = 0, this.redeemedCode, this.reward = referralRewardPoints, this.inviteLimit = referralInviteLimit}): super._();
  factory _ReferralSummary.fromJson(Map<String, dynamic> json) => _$ReferralSummaryFromJson(json);

@override final  String code;
@override@JsonKey() final  int invitedCount;
@override@JsonKey() final  int earnedPoints;
@override final  String? redeemedCode;
@override@JsonKey() final  int reward;
@override@JsonKey() final  int inviteLimit;

/// Create a copy of ReferralSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReferralSummaryCopyWith<_ReferralSummary> get copyWith => __$ReferralSummaryCopyWithImpl<_ReferralSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReferralSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReferralSummary&&(identical(other.code, code) || other.code == code)&&(identical(other.invitedCount, invitedCount) || other.invitedCount == invitedCount)&&(identical(other.earnedPoints, earnedPoints) || other.earnedPoints == earnedPoints)&&(identical(other.redeemedCode, redeemedCode) || other.redeemedCode == redeemedCode)&&(identical(other.reward, reward) || other.reward == reward)&&(identical(other.inviteLimit, inviteLimit) || other.inviteLimit == inviteLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,invitedCount,earnedPoints,redeemedCode,reward,inviteLimit);

@override
String toString() {
  return 'ReferralSummary(code: $code, invitedCount: $invitedCount, earnedPoints: $earnedPoints, redeemedCode: $redeemedCode, reward: $reward, inviteLimit: $inviteLimit)';
}


}

/// @nodoc
abstract mixin class _$ReferralSummaryCopyWith<$Res> implements $ReferralSummaryCopyWith<$Res> {
  factory _$ReferralSummaryCopyWith(_ReferralSummary value, $Res Function(_ReferralSummary) _then) = __$ReferralSummaryCopyWithImpl;
@override @useResult
$Res call({
 String code, int invitedCount, int earnedPoints, String? redeemedCode, int reward, int inviteLimit
});




}
/// @nodoc
class __$ReferralSummaryCopyWithImpl<$Res>
    implements _$ReferralSummaryCopyWith<$Res> {
  __$ReferralSummaryCopyWithImpl(this._self, this._then);

  final _ReferralSummary _self;
  final $Res Function(_ReferralSummary) _then;

/// Create a copy of ReferralSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? invitedCount = null,Object? earnedPoints = null,Object? redeemedCode = freezed,Object? reward = null,Object? inviteLimit = null,}) {
  return _then(_ReferralSummary(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,invitedCount: null == invitedCount ? _self.invitedCount : invitedCount // ignore: cast_nullable_to_non_nullable
as int,earnedPoints: null == earnedPoints ? _self.earnedPoints : earnedPoints // ignore: cast_nullable_to_non_nullable
as int,redeemedCode: freezed == redeemedCode ? _self.redeemedCode : redeemedCode // ignore: cast_nullable_to_non_nullable
as String?,reward: null == reward ? _self.reward : reward // ignore: cast_nullable_to_non_nullable
as int,inviteLimit: null == inviteLimit ? _self.inviteLimit : inviteLimit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ReferralRedeemResult {

 String get code; int get reward; int get balance; ReferralSummary get summary;
/// Create a copy of ReferralRedeemResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferralRedeemResultCopyWith<ReferralRedeemResult> get copyWith => _$ReferralRedeemResultCopyWithImpl<ReferralRedeemResult>(this as ReferralRedeemResult, _$identity);

  /// Serializes this ReferralRedeemResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferralRedeemResult&&(identical(other.code, code) || other.code == code)&&(identical(other.reward, reward) || other.reward == reward)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,reward,balance,summary);

@override
String toString() {
  return 'ReferralRedeemResult(code: $code, reward: $reward, balance: $balance, summary: $summary)';
}


}

/// @nodoc
abstract mixin class $ReferralRedeemResultCopyWith<$Res>  {
  factory $ReferralRedeemResultCopyWith(ReferralRedeemResult value, $Res Function(ReferralRedeemResult) _then) = _$ReferralRedeemResultCopyWithImpl;
@useResult
$Res call({
 String code, int reward, int balance, ReferralSummary summary
});


$ReferralSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class _$ReferralRedeemResultCopyWithImpl<$Res>
    implements $ReferralRedeemResultCopyWith<$Res> {
  _$ReferralRedeemResultCopyWithImpl(this._self, this._then);

  final ReferralRedeemResult _self;
  final $Res Function(ReferralRedeemResult) _then;

/// Create a copy of ReferralRedeemResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? reward = null,Object? balance = null,Object? summary = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,reward: null == reward ? _self.reward : reward // ignore: cast_nullable_to_non_nullable
as int,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as ReferralSummary,
  ));
}
/// Create a copy of ReferralRedeemResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReferralSummaryCopyWith<$Res> get summary {
  
  return $ReferralSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReferralRedeemResult].
extension ReferralRedeemResultPatterns on ReferralRedeemResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReferralRedeemResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReferralRedeemResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReferralRedeemResult value)  $default,){
final _that = this;
switch (_that) {
case _ReferralRedeemResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReferralRedeemResult value)?  $default,){
final _that = this;
switch (_that) {
case _ReferralRedeemResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  int reward,  int balance,  ReferralSummary summary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReferralRedeemResult() when $default != null:
return $default(_that.code,_that.reward,_that.balance,_that.summary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  int reward,  int balance,  ReferralSummary summary)  $default,) {final _that = this;
switch (_that) {
case _ReferralRedeemResult():
return $default(_that.code,_that.reward,_that.balance,_that.summary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  int reward,  int balance,  ReferralSummary summary)?  $default,) {final _that = this;
switch (_that) {
case _ReferralRedeemResult() when $default != null:
return $default(_that.code,_that.reward,_that.balance,_that.summary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReferralRedeemResult implements ReferralRedeemResult {
  const _ReferralRedeemResult({required this.code, required this.reward, required this.balance, required this.summary});
  factory _ReferralRedeemResult.fromJson(Map<String, dynamic> json) => _$ReferralRedeemResultFromJson(json);

@override final  String code;
@override final  int reward;
@override final  int balance;
@override final  ReferralSummary summary;

/// Create a copy of ReferralRedeemResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReferralRedeemResultCopyWith<_ReferralRedeemResult> get copyWith => __$ReferralRedeemResultCopyWithImpl<_ReferralRedeemResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReferralRedeemResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReferralRedeemResult&&(identical(other.code, code) || other.code == code)&&(identical(other.reward, reward) || other.reward == reward)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,reward,balance,summary);

@override
String toString() {
  return 'ReferralRedeemResult(code: $code, reward: $reward, balance: $balance, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$ReferralRedeemResultCopyWith<$Res> implements $ReferralRedeemResultCopyWith<$Res> {
  factory _$ReferralRedeemResultCopyWith(_ReferralRedeemResult value, $Res Function(_ReferralRedeemResult) _then) = __$ReferralRedeemResultCopyWithImpl;
@override @useResult
$Res call({
 String code, int reward, int balance, ReferralSummary summary
});


@override $ReferralSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class __$ReferralRedeemResultCopyWithImpl<$Res>
    implements _$ReferralRedeemResultCopyWith<$Res> {
  __$ReferralRedeemResultCopyWithImpl(this._self, this._then);

  final _ReferralRedeemResult _self;
  final $Res Function(_ReferralRedeemResult) _then;

/// Create a copy of ReferralRedeemResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? reward = null,Object? balance = null,Object? summary = null,}) {
  return _then(_ReferralRedeemResult(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,reward: null == reward ? _self.reward : reward // ignore: cast_nullable_to_non_nullable
as int,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as ReferralSummary,
  ));
}

/// Create a copy of ReferralRedeemResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReferralSummaryCopyWith<$Res> get summary {
  
  return $ReferralSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

// dart format on
