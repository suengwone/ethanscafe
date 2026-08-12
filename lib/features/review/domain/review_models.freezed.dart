// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductReview {

 String get id; String get productId; ReviewProductType get productType; String get productName; String get orderId; int get rating; String get comment; DateTime get createdAt;
/// Create a copy of ProductReview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductReviewCopyWith<ProductReview> get copyWith => _$ProductReviewCopyWithImpl<ProductReview>(this as ProductReview, _$identity);

  /// Serializes this ProductReview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductReview&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productType, productType) || other.productType == productType)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,productType,productName,orderId,rating,comment,createdAt);

@override
String toString() {
  return 'ProductReview(id: $id, productId: $productId, productType: $productType, productName: $productName, orderId: $orderId, rating: $rating, comment: $comment, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ProductReviewCopyWith<$Res>  {
  factory $ProductReviewCopyWith(ProductReview value, $Res Function(ProductReview) _then) = _$ProductReviewCopyWithImpl;
@useResult
$Res call({
 String id, String productId, ReviewProductType productType, String productName, String orderId, int rating, String comment, DateTime createdAt
});




}
/// @nodoc
class _$ProductReviewCopyWithImpl<$Res>
    implements $ProductReviewCopyWith<$Res> {
  _$ProductReviewCopyWithImpl(this._self, this._then);

  final ProductReview _self;
  final $Res Function(ProductReview) _then;

/// Create a copy of ProductReview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? productType = null,Object? productName = null,Object? orderId = null,Object? rating = null,Object? comment = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productType: null == productType ? _self.productType : productType // ignore: cast_nullable_to_non_nullable
as ReviewProductType,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductReview].
extension ProductReviewPatterns on ProductReview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductReview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductReview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductReview value)  $default,){
final _that = this;
switch (_that) {
case _ProductReview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductReview value)?  $default,){
final _that = this;
switch (_that) {
case _ProductReview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String productId,  ReviewProductType productType,  String productName,  String orderId,  int rating,  String comment,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductReview() when $default != null:
return $default(_that.id,_that.productId,_that.productType,_that.productName,_that.orderId,_that.rating,_that.comment,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String productId,  ReviewProductType productType,  String productName,  String orderId,  int rating,  String comment,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ProductReview():
return $default(_that.id,_that.productId,_that.productType,_that.productName,_that.orderId,_that.rating,_that.comment,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String productId,  ReviewProductType productType,  String productName,  String orderId,  int rating,  String comment,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ProductReview() when $default != null:
return $default(_that.id,_that.productId,_that.productType,_that.productName,_that.orderId,_that.rating,_that.comment,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductReview extends ProductReview {
  const _ProductReview({required this.id, required this.productId, required this.productType, required this.productName, required this.orderId, required this.rating, this.comment = '', required this.createdAt}): super._();
  factory _ProductReview.fromJson(Map<String, dynamic> json) => _$ProductReviewFromJson(json);

@override final  String id;
@override final  String productId;
@override final  ReviewProductType productType;
@override final  String productName;
@override final  String orderId;
@override final  int rating;
@override@JsonKey() final  String comment;
@override final  DateTime createdAt;

/// Create a copy of ProductReview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductReviewCopyWith<_ProductReview> get copyWith => __$ProductReviewCopyWithImpl<_ProductReview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductReviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductReview&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productType, productType) || other.productType == productType)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,productType,productName,orderId,rating,comment,createdAt);

@override
String toString() {
  return 'ProductReview(id: $id, productId: $productId, productType: $productType, productName: $productName, orderId: $orderId, rating: $rating, comment: $comment, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ProductReviewCopyWith<$Res> implements $ProductReviewCopyWith<$Res> {
  factory _$ProductReviewCopyWith(_ProductReview value, $Res Function(_ProductReview) _then) = __$ProductReviewCopyWithImpl;
@override @useResult
$Res call({
 String id, String productId, ReviewProductType productType, String productName, String orderId, int rating, String comment, DateTime createdAt
});




}
/// @nodoc
class __$ProductReviewCopyWithImpl<$Res>
    implements _$ProductReviewCopyWith<$Res> {
  __$ProductReviewCopyWithImpl(this._self, this._then);

  final _ProductReview _self;
  final $Res Function(_ProductReview) _then;

/// Create a copy of ProductReview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? productType = null,Object? productName = null,Object? orderId = null,Object? rating = null,Object? comment = null,Object? createdAt = null,}) {
  return _then(_ProductReview(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productType: null == productType ? _self.productType : productType // ignore: cast_nullable_to_non_nullable
as ReviewProductType,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ProductStats {

 String get productId; int get ratingSum; int get ratingCount; int get salesCount;
/// Create a copy of ProductStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductStatsCopyWith<ProductStats> get copyWith => _$ProductStatsCopyWithImpl<ProductStats>(this as ProductStats, _$identity);

  /// Serializes this ProductStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductStats&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.ratingSum, ratingSum) || other.ratingSum == ratingSum)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.salesCount, salesCount) || other.salesCount == salesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,ratingSum,ratingCount,salesCount);

@override
String toString() {
  return 'ProductStats(productId: $productId, ratingSum: $ratingSum, ratingCount: $ratingCount, salesCount: $salesCount)';
}


}

/// @nodoc
abstract mixin class $ProductStatsCopyWith<$Res>  {
  factory $ProductStatsCopyWith(ProductStats value, $Res Function(ProductStats) _then) = _$ProductStatsCopyWithImpl;
@useResult
$Res call({
 String productId, int ratingSum, int ratingCount, int salesCount
});




}
/// @nodoc
class _$ProductStatsCopyWithImpl<$Res>
    implements $ProductStatsCopyWith<$Res> {
  _$ProductStatsCopyWithImpl(this._self, this._then);

  final ProductStats _self;
  final $Res Function(ProductStats) _then;

/// Create a copy of ProductStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? ratingSum = null,Object? ratingCount = null,Object? salesCount = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,ratingSum: null == ratingSum ? _self.ratingSum : ratingSum // ignore: cast_nullable_to_non_nullable
as int,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,salesCount: null == salesCount ? _self.salesCount : salesCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductStats].
extension ProductStatsPatterns on ProductStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductStats value)  $default,){
final _that = this;
switch (_that) {
case _ProductStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductStats value)?  $default,){
final _that = this;
switch (_that) {
case _ProductStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  int ratingSum,  int ratingCount,  int salesCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductStats() when $default != null:
return $default(_that.productId,_that.ratingSum,_that.ratingCount,_that.salesCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  int ratingSum,  int ratingCount,  int salesCount)  $default,) {final _that = this;
switch (_that) {
case _ProductStats():
return $default(_that.productId,_that.ratingSum,_that.ratingCount,_that.salesCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  int ratingSum,  int ratingCount,  int salesCount)?  $default,) {final _that = this;
switch (_that) {
case _ProductStats() when $default != null:
return $default(_that.productId,_that.ratingSum,_that.ratingCount,_that.salesCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductStats extends ProductStats {
  const _ProductStats({required this.productId, this.ratingSum = 0, this.ratingCount = 0, this.salesCount = 0}): super._();
  factory _ProductStats.fromJson(Map<String, dynamic> json) => _$ProductStatsFromJson(json);

@override final  String productId;
@override@JsonKey() final  int ratingSum;
@override@JsonKey() final  int ratingCount;
@override@JsonKey() final  int salesCount;

/// Create a copy of ProductStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductStatsCopyWith<_ProductStats> get copyWith => __$ProductStatsCopyWithImpl<_ProductStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductStats&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.ratingSum, ratingSum) || other.ratingSum == ratingSum)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.salesCount, salesCount) || other.salesCount == salesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,ratingSum,ratingCount,salesCount);

@override
String toString() {
  return 'ProductStats(productId: $productId, ratingSum: $ratingSum, ratingCount: $ratingCount, salesCount: $salesCount)';
}


}

/// @nodoc
abstract mixin class _$ProductStatsCopyWith<$Res> implements $ProductStatsCopyWith<$Res> {
  factory _$ProductStatsCopyWith(_ProductStats value, $Res Function(_ProductStats) _then) = __$ProductStatsCopyWithImpl;
@override @useResult
$Res call({
 String productId, int ratingSum, int ratingCount, int salesCount
});




}
/// @nodoc
class __$ProductStatsCopyWithImpl<$Res>
    implements _$ProductStatsCopyWith<$Res> {
  __$ProductStatsCopyWithImpl(this._self, this._then);

  final _ProductStats _self;
  final $Res Function(_ProductStats) _then;

/// Create a copy of ProductStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? ratingSum = null,Object? ratingCount = null,Object? salesCount = null,}) {
  return _then(_ProductStats(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,ratingSum: null == ratingSum ? _self.ratingSum : ratingSum // ignore: cast_nullable_to_non_nullable
as int,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,salesCount: null == salesCount ? _self.salesCount : salesCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
