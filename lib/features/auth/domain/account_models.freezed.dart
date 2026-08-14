// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BusinessProfile {

 String get companyName; String get businessNumber; String get managerName; String get phone;
/// Create a copy of BusinessProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessProfileCopyWith<BusinessProfile> get copyWith => _$BusinessProfileCopyWithImpl<BusinessProfile>(this as BusinessProfile, _$identity);

  /// Serializes this BusinessProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessProfile&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.businessNumber, businessNumber) || other.businessNumber == businessNumber)&&(identical(other.managerName, managerName) || other.managerName == managerName)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,companyName,businessNumber,managerName,phone);

@override
String toString() {
  return 'BusinessProfile(companyName: $companyName, businessNumber: $businessNumber, managerName: $managerName, phone: $phone)';
}


}

/// @nodoc
abstract mixin class $BusinessProfileCopyWith<$Res>  {
  factory $BusinessProfileCopyWith(BusinessProfile value, $Res Function(BusinessProfile) _then) = _$BusinessProfileCopyWithImpl;
@useResult
$Res call({
 String companyName, String businessNumber, String managerName, String phone
});




}
/// @nodoc
class _$BusinessProfileCopyWithImpl<$Res>
    implements $BusinessProfileCopyWith<$Res> {
  _$BusinessProfileCopyWithImpl(this._self, this._then);

  final BusinessProfile _self;
  final $Res Function(BusinessProfile) _then;

/// Create a copy of BusinessProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? companyName = null,Object? businessNumber = null,Object? managerName = null,Object? phone = null,}) {
  return _then(_self.copyWith(
companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,businessNumber: null == businessNumber ? _self.businessNumber : businessNumber // ignore: cast_nullable_to_non_nullable
as String,managerName: null == managerName ? _self.managerName : managerName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BusinessProfile].
extension BusinessProfilePatterns on BusinessProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BusinessProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BusinessProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BusinessProfile value)  $default,){
final _that = this;
switch (_that) {
case _BusinessProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BusinessProfile value)?  $default,){
final _that = this;
switch (_that) {
case _BusinessProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String companyName,  String businessNumber,  String managerName,  String phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BusinessProfile() when $default != null:
return $default(_that.companyName,_that.businessNumber,_that.managerName,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String companyName,  String businessNumber,  String managerName,  String phone)  $default,) {final _that = this;
switch (_that) {
case _BusinessProfile():
return $default(_that.companyName,_that.businessNumber,_that.managerName,_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String companyName,  String businessNumber,  String managerName,  String phone)?  $default,) {final _that = this;
switch (_that) {
case _BusinessProfile() when $default != null:
return $default(_that.companyName,_that.businessNumber,_that.managerName,_that.phone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BusinessProfile implements BusinessProfile {
  const _BusinessProfile({required this.companyName, required this.businessNumber, this.managerName = '', this.phone = ''});
  factory _BusinessProfile.fromJson(Map<String, dynamic> json) => _$BusinessProfileFromJson(json);

@override final  String companyName;
@override final  String businessNumber;
@override@JsonKey() final  String managerName;
@override@JsonKey() final  String phone;

/// Create a copy of BusinessProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusinessProfileCopyWith<_BusinessProfile> get copyWith => __$BusinessProfileCopyWithImpl<_BusinessProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BusinessProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusinessProfile&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.businessNumber, businessNumber) || other.businessNumber == businessNumber)&&(identical(other.managerName, managerName) || other.managerName == managerName)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,companyName,businessNumber,managerName,phone);

@override
String toString() {
  return 'BusinessProfile(companyName: $companyName, businessNumber: $businessNumber, managerName: $managerName, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$BusinessProfileCopyWith<$Res> implements $BusinessProfileCopyWith<$Res> {
  factory _$BusinessProfileCopyWith(_BusinessProfile value, $Res Function(_BusinessProfile) _then) = __$BusinessProfileCopyWithImpl;
@override @useResult
$Res call({
 String companyName, String businessNumber, String managerName, String phone
});




}
/// @nodoc
class __$BusinessProfileCopyWithImpl<$Res>
    implements _$BusinessProfileCopyWith<$Res> {
  __$BusinessProfileCopyWithImpl(this._self, this._then);

  final _BusinessProfile _self;
  final $Res Function(_BusinessProfile) _then;

/// Create a copy of BusinessProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? companyName = null,Object? businessNumber = null,Object? managerName = null,Object? phone = null,}) {
  return _then(_BusinessProfile(
companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,businessNumber: null == businessNumber ? _self.businessNumber : businessNumber // ignore: cast_nullable_to_non_nullable
as String,managerName: null == managerName ? _self.managerName : managerName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AccountProfile {

 AccountType get type; BusinessProfile? get business;
/// Create a copy of AccountProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountProfileCopyWith<AccountProfile> get copyWith => _$AccountProfileCopyWithImpl<AccountProfile>(this as AccountProfile, _$identity);

  /// Serializes this AccountProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountProfile&&(identical(other.type, type) || other.type == type)&&(identical(other.business, business) || other.business == business));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,business);

@override
String toString() {
  return 'AccountProfile(type: $type, business: $business)';
}


}

/// @nodoc
abstract mixin class $AccountProfileCopyWith<$Res>  {
  factory $AccountProfileCopyWith(AccountProfile value, $Res Function(AccountProfile) _then) = _$AccountProfileCopyWithImpl;
@useResult
$Res call({
 AccountType type, BusinessProfile? business
});


$BusinessProfileCopyWith<$Res>? get business;

}
/// @nodoc
class _$AccountProfileCopyWithImpl<$Res>
    implements $AccountProfileCopyWith<$Res> {
  _$AccountProfileCopyWithImpl(this._self, this._then);

  final AccountProfile _self;
  final $Res Function(AccountProfile) _then;

/// Create a copy of AccountProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? business = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AccountType,business: freezed == business ? _self.business : business // ignore: cast_nullable_to_non_nullable
as BusinessProfile?,
  ));
}
/// Create a copy of AccountProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BusinessProfileCopyWith<$Res>? get business {
    if (_self.business == null) {
    return null;
  }

  return $BusinessProfileCopyWith<$Res>(_self.business!, (value) {
    return _then(_self.copyWith(business: value));
  });
}
}


/// Adds pattern-matching-related methods to [AccountProfile].
extension AccountProfilePatterns on AccountProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountProfile value)  $default,){
final _that = this;
switch (_that) {
case _AccountProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountProfile value)?  $default,){
final _that = this;
switch (_that) {
case _AccountProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AccountType type,  BusinessProfile? business)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountProfile() when $default != null:
return $default(_that.type,_that.business);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AccountType type,  BusinessProfile? business)  $default,) {final _that = this;
switch (_that) {
case _AccountProfile():
return $default(_that.type,_that.business);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AccountType type,  BusinessProfile? business)?  $default,) {final _that = this;
switch (_that) {
case _AccountProfile() when $default != null:
return $default(_that.type,_that.business);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountProfile extends AccountProfile {
  const _AccountProfile({this.type = AccountType.customer, this.business}): super._();
  factory _AccountProfile.fromJson(Map<String, dynamic> json) => _$AccountProfileFromJson(json);

@override@JsonKey() final  AccountType type;
@override final  BusinessProfile? business;

/// Create a copy of AccountProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountProfileCopyWith<_AccountProfile> get copyWith => __$AccountProfileCopyWithImpl<_AccountProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountProfile&&(identical(other.type, type) || other.type == type)&&(identical(other.business, business) || other.business == business));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,business);

@override
String toString() {
  return 'AccountProfile(type: $type, business: $business)';
}


}

/// @nodoc
abstract mixin class _$AccountProfileCopyWith<$Res> implements $AccountProfileCopyWith<$Res> {
  factory _$AccountProfileCopyWith(_AccountProfile value, $Res Function(_AccountProfile) _then) = __$AccountProfileCopyWithImpl;
@override @useResult
$Res call({
 AccountType type, BusinessProfile? business
});


@override $BusinessProfileCopyWith<$Res>? get business;

}
/// @nodoc
class __$AccountProfileCopyWithImpl<$Res>
    implements _$AccountProfileCopyWith<$Res> {
  __$AccountProfileCopyWithImpl(this._self, this._then);

  final _AccountProfile _self;
  final $Res Function(_AccountProfile) _then;

/// Create a copy of AccountProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? business = freezed,}) {
  return _then(_AccountProfile(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AccountType,business: freezed == business ? _self.business : business // ignore: cast_nullable_to_non_nullable
as BusinessProfile?,
  ));
}

/// Create a copy of AccountProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BusinessProfileCopyWith<$Res>? get business {
    if (_self.business == null) {
    return null;
  }

  return $BusinessProfileCopyWith<$Res>(_self.business!, (value) {
    return _then(_self.copyWith(business: value));
  });
}
}

// dart format on
