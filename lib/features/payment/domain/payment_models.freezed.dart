// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaymentRequest {

 String get orderId; String get orderName; int get amount;
/// Create a copy of PaymentRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentRequestCopyWith<PaymentRequest> get copyWith => _$PaymentRequestCopyWithImpl<PaymentRequest>(this as PaymentRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentRequest&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.orderName, orderName) || other.orderName == orderName)&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,orderId,orderName,amount);

@override
String toString() {
  return 'PaymentRequest(orderId: $orderId, orderName: $orderName, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $PaymentRequestCopyWith<$Res>  {
  factory $PaymentRequestCopyWith(PaymentRequest value, $Res Function(PaymentRequest) _then) = _$PaymentRequestCopyWithImpl;
@useResult
$Res call({
 String orderId, String orderName, int amount
});




}
/// @nodoc
class _$PaymentRequestCopyWithImpl<$Res>
    implements $PaymentRequestCopyWith<$Res> {
  _$PaymentRequestCopyWithImpl(this._self, this._then);

  final PaymentRequest _self;
  final $Res Function(PaymentRequest) _then;

/// Create a copy of PaymentRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderId = null,Object? orderName = null,Object? amount = null,}) {
  return _then(_self.copyWith(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,orderName: null == orderName ? _self.orderName : orderName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentRequest].
extension PaymentRequestPatterns on PaymentRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentRequest value)  $default,){
final _that = this;
switch (_that) {
case _PaymentRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentRequest value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String orderId,  String orderName,  int amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentRequest() when $default != null:
return $default(_that.orderId,_that.orderName,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String orderId,  String orderName,  int amount)  $default,) {final _that = this;
switch (_that) {
case _PaymentRequest():
return $default(_that.orderId,_that.orderName,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String orderId,  String orderName,  int amount)?  $default,) {final _that = this;
switch (_that) {
case _PaymentRequest() when $default != null:
return $default(_that.orderId,_that.orderName,_that.amount);case _:
  return null;

}
}

}

/// @nodoc


class _PaymentRequest implements PaymentRequest {
  const _PaymentRequest({required this.orderId, required this.orderName, required this.amount});
  

@override final  String orderId;
@override final  String orderName;
@override final  int amount;

/// Create a copy of PaymentRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentRequestCopyWith<_PaymentRequest> get copyWith => __$PaymentRequestCopyWithImpl<_PaymentRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentRequest&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.orderName, orderName) || other.orderName == orderName)&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,orderId,orderName,amount);

@override
String toString() {
  return 'PaymentRequest(orderId: $orderId, orderName: $orderName, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$PaymentRequestCopyWith<$Res> implements $PaymentRequestCopyWith<$Res> {
  factory _$PaymentRequestCopyWith(_PaymentRequest value, $Res Function(_PaymentRequest) _then) = __$PaymentRequestCopyWithImpl;
@override @useResult
$Res call({
 String orderId, String orderName, int amount
});




}
/// @nodoc
class __$PaymentRequestCopyWithImpl<$Res>
    implements _$PaymentRequestCopyWith<$Res> {
  __$PaymentRequestCopyWithImpl(this._self, this._then);

  final _PaymentRequest _self;
  final $Res Function(_PaymentRequest) _then;

/// Create a copy of PaymentRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? orderName = null,Object? amount = null,}) {
  return _then(_PaymentRequest(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,orderName: null == orderName ? _self.orderName : orderName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$PaymentApproval {

 String get paymentKey; String get orderId; int get amount; String get method;
/// Create a copy of PaymentApproval
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentApprovalCopyWith<PaymentApproval> get copyWith => _$PaymentApprovalCopyWithImpl<PaymentApproval>(this as PaymentApproval, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentApproval&&(identical(other.paymentKey, paymentKey) || other.paymentKey == paymentKey)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.method, method) || other.method == method));
}


@override
int get hashCode => Object.hash(runtimeType,paymentKey,orderId,amount,method);

@override
String toString() {
  return 'PaymentApproval(paymentKey: $paymentKey, orderId: $orderId, amount: $amount, method: $method)';
}


}

/// @nodoc
abstract mixin class $PaymentApprovalCopyWith<$Res>  {
  factory $PaymentApprovalCopyWith(PaymentApproval value, $Res Function(PaymentApproval) _then) = _$PaymentApprovalCopyWithImpl;
@useResult
$Res call({
 String paymentKey, String orderId, int amount, String method
});




}
/// @nodoc
class _$PaymentApprovalCopyWithImpl<$Res>
    implements $PaymentApprovalCopyWith<$Res> {
  _$PaymentApprovalCopyWithImpl(this._self, this._then);

  final PaymentApproval _self;
  final $Res Function(PaymentApproval) _then;

/// Create a copy of PaymentApproval
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? paymentKey = null,Object? orderId = null,Object? amount = null,Object? method = null,}) {
  return _then(_self.copyWith(
paymentKey: null == paymentKey ? _self.paymentKey : paymentKey // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentApproval].
extension PaymentApprovalPatterns on PaymentApproval {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentApproval value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentApproval() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentApproval value)  $default,){
final _that = this;
switch (_that) {
case _PaymentApproval():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentApproval value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentApproval() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String paymentKey,  String orderId,  int amount,  String method)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentApproval() when $default != null:
return $default(_that.paymentKey,_that.orderId,_that.amount,_that.method);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String paymentKey,  String orderId,  int amount,  String method)  $default,) {final _that = this;
switch (_that) {
case _PaymentApproval():
return $default(_that.paymentKey,_that.orderId,_that.amount,_that.method);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String paymentKey,  String orderId,  int amount,  String method)?  $default,) {final _that = this;
switch (_that) {
case _PaymentApproval() when $default != null:
return $default(_that.paymentKey,_that.orderId,_that.amount,_that.method);case _:
  return null;

}
}

}

/// @nodoc


class _PaymentApproval implements PaymentApproval {
  const _PaymentApproval({required this.paymentKey, required this.orderId, required this.amount, required this.method});
  

@override final  String paymentKey;
@override final  String orderId;
@override final  int amount;
@override final  String method;

/// Create a copy of PaymentApproval
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentApprovalCopyWith<_PaymentApproval> get copyWith => __$PaymentApprovalCopyWithImpl<_PaymentApproval>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentApproval&&(identical(other.paymentKey, paymentKey) || other.paymentKey == paymentKey)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.method, method) || other.method == method));
}


@override
int get hashCode => Object.hash(runtimeType,paymentKey,orderId,amount,method);

@override
String toString() {
  return 'PaymentApproval(paymentKey: $paymentKey, orderId: $orderId, amount: $amount, method: $method)';
}


}

/// @nodoc
abstract mixin class _$PaymentApprovalCopyWith<$Res> implements $PaymentApprovalCopyWith<$Res> {
  factory _$PaymentApprovalCopyWith(_PaymentApproval value, $Res Function(_PaymentApproval) _then) = __$PaymentApprovalCopyWithImpl;
@override @useResult
$Res call({
 String paymentKey, String orderId, int amount, String method
});




}
/// @nodoc
class __$PaymentApprovalCopyWithImpl<$Res>
    implements _$PaymentApprovalCopyWith<$Res> {
  __$PaymentApprovalCopyWithImpl(this._self, this._then);

  final _PaymentApproval _self;
  final $Res Function(_PaymentApproval) _then;

/// Create a copy of PaymentApproval
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? paymentKey = null,Object? orderId = null,Object? amount = null,Object? method = null,}) {
  return _then(_PaymentApproval(
paymentKey: null == paymentKey ? _self.paymentKey : paymentKey // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
