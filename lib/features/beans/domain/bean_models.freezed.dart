// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bean_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Bean {

 String get id; String get name; String get origin; String get description; String get story; RoastLevel get roastLevel; String get process; List<String> get tastingNotes; int get acidity; int get body; int get sweetness; List<String> get recommendedBrews; int get price200; int get price500; bool get isNew; bool get soldOut; int get sortOrder;
/// Create a copy of Bean
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BeanCopyWith<Bean> get copyWith => _$BeanCopyWithImpl<Bean>(this as Bean, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Bean&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.description, description) || other.description == description)&&(identical(other.story, story) || other.story == story)&&(identical(other.roastLevel, roastLevel) || other.roastLevel == roastLevel)&&(identical(other.process, process) || other.process == process)&&const DeepCollectionEquality().equals(other.tastingNotes, tastingNotes)&&(identical(other.acidity, acidity) || other.acidity == acidity)&&(identical(other.body, body) || other.body == body)&&(identical(other.sweetness, sweetness) || other.sweetness == sweetness)&&const DeepCollectionEquality().equals(other.recommendedBrews, recommendedBrews)&&(identical(other.price200, price200) || other.price200 == price200)&&(identical(other.price500, price500) || other.price500 == price500)&&(identical(other.isNew, isNew) || other.isNew == isNew)&&(identical(other.soldOut, soldOut) || other.soldOut == soldOut)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,origin,description,story,roastLevel,process,const DeepCollectionEquality().hash(tastingNotes),acidity,body,sweetness,const DeepCollectionEquality().hash(recommendedBrews),price200,price500,isNew,soldOut,sortOrder);

@override
String toString() {
  return 'Bean(id: $id, name: $name, origin: $origin, description: $description, story: $story, roastLevel: $roastLevel, process: $process, tastingNotes: $tastingNotes, acidity: $acidity, body: $body, sweetness: $sweetness, recommendedBrews: $recommendedBrews, price200: $price200, price500: $price500, isNew: $isNew, soldOut: $soldOut, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $BeanCopyWith<$Res>  {
  factory $BeanCopyWith(Bean value, $Res Function(Bean) _then) = _$BeanCopyWithImpl;
@useResult
$Res call({
 String id, String name, String origin, String description, String story, RoastLevel roastLevel, String process, List<String> tastingNotes, int acidity, int body, int sweetness, List<String> recommendedBrews, int price200, int price500, bool isNew, bool soldOut, int sortOrder
});




}
/// @nodoc
class _$BeanCopyWithImpl<$Res>
    implements $BeanCopyWith<$Res> {
  _$BeanCopyWithImpl(this._self, this._then);

  final Bean _self;
  final $Res Function(Bean) _then;

/// Create a copy of Bean
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? origin = null,Object? description = null,Object? story = null,Object? roastLevel = null,Object? process = null,Object? tastingNotes = null,Object? acidity = null,Object? body = null,Object? sweetness = null,Object? recommendedBrews = null,Object? price200 = null,Object? price500 = null,Object? isNew = null,Object? soldOut = null,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,story: null == story ? _self.story : story // ignore: cast_nullable_to_non_nullable
as String,roastLevel: null == roastLevel ? _self.roastLevel : roastLevel // ignore: cast_nullable_to_non_nullable
as RoastLevel,process: null == process ? _self.process : process // ignore: cast_nullable_to_non_nullable
as String,tastingNotes: null == tastingNotes ? _self.tastingNotes : tastingNotes // ignore: cast_nullable_to_non_nullable
as List<String>,acidity: null == acidity ? _self.acidity : acidity // ignore: cast_nullable_to_non_nullable
as int,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as int,sweetness: null == sweetness ? _self.sweetness : sweetness // ignore: cast_nullable_to_non_nullable
as int,recommendedBrews: null == recommendedBrews ? _self.recommendedBrews : recommendedBrews // ignore: cast_nullable_to_non_nullable
as List<String>,price200: null == price200 ? _self.price200 : price200 // ignore: cast_nullable_to_non_nullable
as int,price500: null == price500 ? _self.price500 : price500 // ignore: cast_nullable_to_non_nullable
as int,isNew: null == isNew ? _self.isNew : isNew // ignore: cast_nullable_to_non_nullable
as bool,soldOut: null == soldOut ? _self.soldOut : soldOut // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Bean].
extension BeanPatterns on Bean {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Bean value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Bean() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Bean value)  $default,){
final _that = this;
switch (_that) {
case _Bean():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Bean value)?  $default,){
final _that = this;
switch (_that) {
case _Bean() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String origin,  String description,  String story,  RoastLevel roastLevel,  String process,  List<String> tastingNotes,  int acidity,  int body,  int sweetness,  List<String> recommendedBrews,  int price200,  int price500,  bool isNew,  bool soldOut,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Bean() when $default != null:
return $default(_that.id,_that.name,_that.origin,_that.description,_that.story,_that.roastLevel,_that.process,_that.tastingNotes,_that.acidity,_that.body,_that.sweetness,_that.recommendedBrews,_that.price200,_that.price500,_that.isNew,_that.soldOut,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String origin,  String description,  String story,  RoastLevel roastLevel,  String process,  List<String> tastingNotes,  int acidity,  int body,  int sweetness,  List<String> recommendedBrews,  int price200,  int price500,  bool isNew,  bool soldOut,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _Bean():
return $default(_that.id,_that.name,_that.origin,_that.description,_that.story,_that.roastLevel,_that.process,_that.tastingNotes,_that.acidity,_that.body,_that.sweetness,_that.recommendedBrews,_that.price200,_that.price500,_that.isNew,_that.soldOut,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String origin,  String description,  String story,  RoastLevel roastLevel,  String process,  List<String> tastingNotes,  int acidity,  int body,  int sweetness,  List<String> recommendedBrews,  int price200,  int price500,  bool isNew,  bool soldOut,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _Bean() when $default != null:
return $default(_that.id,_that.name,_that.origin,_that.description,_that.story,_that.roastLevel,_that.process,_that.tastingNotes,_that.acidity,_that.body,_that.sweetness,_that.recommendedBrews,_that.price200,_that.price500,_that.isNew,_that.soldOut,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc


class _Bean extends Bean {
  const _Bean({required this.id, required this.name, required this.origin, required this.description, required this.story, required this.roastLevel, required this.process, required final  List<String> tastingNotes, required this.acidity, required this.body, required this.sweetness, required final  List<String> recommendedBrews, required this.price200, required this.price500, this.isNew = false, this.soldOut = false, this.sortOrder = 0}): _tastingNotes = tastingNotes,_recommendedBrews = recommendedBrews,super._();
  

@override final  String id;
@override final  String name;
@override final  String origin;
@override final  String description;
@override final  String story;
@override final  RoastLevel roastLevel;
@override final  String process;
 final  List<String> _tastingNotes;
@override List<String> get tastingNotes {
  if (_tastingNotes is EqualUnmodifiableListView) return _tastingNotes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tastingNotes);
}

@override final  int acidity;
@override final  int body;
@override final  int sweetness;
 final  List<String> _recommendedBrews;
@override List<String> get recommendedBrews {
  if (_recommendedBrews is EqualUnmodifiableListView) return _recommendedBrews;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recommendedBrews);
}

@override final  int price200;
@override final  int price500;
@override@JsonKey() final  bool isNew;
@override@JsonKey() final  bool soldOut;
@override@JsonKey() final  int sortOrder;

/// Create a copy of Bean
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BeanCopyWith<_Bean> get copyWith => __$BeanCopyWithImpl<_Bean>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Bean&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.description, description) || other.description == description)&&(identical(other.story, story) || other.story == story)&&(identical(other.roastLevel, roastLevel) || other.roastLevel == roastLevel)&&(identical(other.process, process) || other.process == process)&&const DeepCollectionEquality().equals(other._tastingNotes, _tastingNotes)&&(identical(other.acidity, acidity) || other.acidity == acidity)&&(identical(other.body, body) || other.body == body)&&(identical(other.sweetness, sweetness) || other.sweetness == sweetness)&&const DeepCollectionEquality().equals(other._recommendedBrews, _recommendedBrews)&&(identical(other.price200, price200) || other.price200 == price200)&&(identical(other.price500, price500) || other.price500 == price500)&&(identical(other.isNew, isNew) || other.isNew == isNew)&&(identical(other.soldOut, soldOut) || other.soldOut == soldOut)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,origin,description,story,roastLevel,process,const DeepCollectionEquality().hash(_tastingNotes),acidity,body,sweetness,const DeepCollectionEquality().hash(_recommendedBrews),price200,price500,isNew,soldOut,sortOrder);

@override
String toString() {
  return 'Bean(id: $id, name: $name, origin: $origin, description: $description, story: $story, roastLevel: $roastLevel, process: $process, tastingNotes: $tastingNotes, acidity: $acidity, body: $body, sweetness: $sweetness, recommendedBrews: $recommendedBrews, price200: $price200, price500: $price500, isNew: $isNew, soldOut: $soldOut, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$BeanCopyWith<$Res> implements $BeanCopyWith<$Res> {
  factory _$BeanCopyWith(_Bean value, $Res Function(_Bean) _then) = __$BeanCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String origin, String description, String story, RoastLevel roastLevel, String process, List<String> tastingNotes, int acidity, int body, int sweetness, List<String> recommendedBrews, int price200, int price500, bool isNew, bool soldOut, int sortOrder
});




}
/// @nodoc
class __$BeanCopyWithImpl<$Res>
    implements _$BeanCopyWith<$Res> {
  __$BeanCopyWithImpl(this._self, this._then);

  final _Bean _self;
  final $Res Function(_Bean) _then;

/// Create a copy of Bean
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? origin = null,Object? description = null,Object? story = null,Object? roastLevel = null,Object? process = null,Object? tastingNotes = null,Object? acidity = null,Object? body = null,Object? sweetness = null,Object? recommendedBrews = null,Object? price200 = null,Object? price500 = null,Object? isNew = null,Object? soldOut = null,Object? sortOrder = null,}) {
  return _then(_Bean(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,story: null == story ? _self.story : story // ignore: cast_nullable_to_non_nullable
as String,roastLevel: null == roastLevel ? _self.roastLevel : roastLevel // ignore: cast_nullable_to_non_nullable
as RoastLevel,process: null == process ? _self.process : process // ignore: cast_nullable_to_non_nullable
as String,tastingNotes: null == tastingNotes ? _self._tastingNotes : tastingNotes // ignore: cast_nullable_to_non_nullable
as List<String>,acidity: null == acidity ? _self.acidity : acidity // ignore: cast_nullable_to_non_nullable
as int,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as int,sweetness: null == sweetness ? _self.sweetness : sweetness // ignore: cast_nullable_to_non_nullable
as int,recommendedBrews: null == recommendedBrews ? _self._recommendedBrews : recommendedBrews // ignore: cast_nullable_to_non_nullable
as List<String>,price200: null == price200 ? _self.price200 : price200 // ignore: cast_nullable_to_non_nullable
as int,price500: null == price500 ? _self.price500 : price500 // ignore: cast_nullable_to_non_nullable
as int,isNew: null == isNew ? _self.isNew : isNew // ignore: cast_nullable_to_non_nullable
as bool,soldOut: null == soldOut ? _self.soldOut : soldOut // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
