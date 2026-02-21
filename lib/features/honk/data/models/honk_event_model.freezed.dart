// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'honk_event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HonkEventModel {

 String get id; String get userId; String get location; String get status; String? get details; DateTime get createdAt; DateTime get expiresAt;
/// Create a copy of HonkEventModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HonkEventModelCopyWith<HonkEventModel> get copyWith => _$HonkEventModelCopyWithImpl<HonkEventModel>(this as HonkEventModel, _$identity);

  /// Serializes this HonkEventModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HonkEventModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.location, location) || other.location == location)&&(identical(other.status, status) || other.status == status)&&(identical(other.details, details) || other.details == details)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,location,status,details,createdAt,expiresAt);

@override
String toString() {
  return 'HonkEventModel(id: $id, userId: $userId, location: $location, status: $status, details: $details, createdAt: $createdAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $HonkEventModelCopyWith<$Res>  {
  factory $HonkEventModelCopyWith(HonkEventModel value, $Res Function(HonkEventModel) _then) = _$HonkEventModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String location, String status, String? details, DateTime createdAt, DateTime expiresAt
});




}
/// @nodoc
class _$HonkEventModelCopyWithImpl<$Res>
    implements $HonkEventModelCopyWith<$Res> {
  _$HonkEventModelCopyWithImpl(this._self, this._then);

  final HonkEventModel _self;
  final $Res Function(HonkEventModel) _then;

/// Create a copy of HonkEventModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? location = null,Object? status = null,Object? details = freezed,Object? createdAt = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [HonkEventModel].
extension HonkEventModelPatterns on HonkEventModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HonkEventModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HonkEventModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HonkEventModel value)  $default,){
final _that = this;
switch (_that) {
case _HonkEventModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HonkEventModel value)?  $default,){
final _that = this;
switch (_that) {
case _HonkEventModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String location,  String status,  String? details,  DateTime createdAt,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HonkEventModel() when $default != null:
return $default(_that.id,_that.userId,_that.location,_that.status,_that.details,_that.createdAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String location,  String status,  String? details,  DateTime createdAt,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _HonkEventModel():
return $default(_that.id,_that.userId,_that.location,_that.status,_that.details,_that.createdAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String location,  String status,  String? details,  DateTime createdAt,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _HonkEventModel() when $default != null:
return $default(_that.id,_that.userId,_that.location,_that.status,_that.details,_that.createdAt,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _HonkEventModel extends HonkEventModel {
  const _HonkEventModel({required this.id, required this.userId, required this.location, required this.status, this.details, required this.createdAt, required this.expiresAt}): super._();
  factory _HonkEventModel.fromJson(Map<String, dynamic> json) => _$HonkEventModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String location;
@override final  String status;
@override final  String? details;
@override final  DateTime createdAt;
@override final  DateTime expiresAt;

/// Create a copy of HonkEventModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HonkEventModelCopyWith<_HonkEventModel> get copyWith => __$HonkEventModelCopyWithImpl<_HonkEventModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HonkEventModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HonkEventModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.location, location) || other.location == location)&&(identical(other.status, status) || other.status == status)&&(identical(other.details, details) || other.details == details)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,location,status,details,createdAt,expiresAt);

@override
String toString() {
  return 'HonkEventModel(id: $id, userId: $userId, location: $location, status: $status, details: $details, createdAt: $createdAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$HonkEventModelCopyWith<$Res> implements $HonkEventModelCopyWith<$Res> {
  factory _$HonkEventModelCopyWith(_HonkEventModel value, $Res Function(_HonkEventModel) _then) = __$HonkEventModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String location, String status, String? details, DateTime createdAt, DateTime expiresAt
});




}
/// @nodoc
class __$HonkEventModelCopyWithImpl<$Res>
    implements _$HonkEventModelCopyWith<$Res> {
  __$HonkEventModelCopyWithImpl(this._self, this._then);

  final _HonkEventModel _self;
  final $Res Function(_HonkEventModel) _then;

/// Create a copy of HonkEventModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? location = null,Object? status = null,Object? details = freezed,Object? createdAt = null,Object? expiresAt = null,}) {
  return _then(_HonkEventModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
