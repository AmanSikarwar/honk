// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'honk_activity_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HonkActivityModel {

 String get id; String get creatorId; String get activity; String get location; String? get details; DateTime get startsAt; String? get recurrenceRrule; String get recurrenceTimezone; int get statusResetSeconds; String get inviteCode; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of HonkActivityModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HonkActivityModelCopyWith<HonkActivityModel> get copyWith => _$HonkActivityModelCopyWithImpl<HonkActivityModel>(this as HonkActivityModel, _$identity);

  /// Serializes this HonkActivityModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HonkActivityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.creatorId, creatorId) || other.creatorId == creatorId)&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.location, location) || other.location == location)&&(identical(other.details, details) || other.details == details)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.recurrenceRrule, recurrenceRrule) || other.recurrenceRrule == recurrenceRrule)&&(identical(other.recurrenceTimezone, recurrenceTimezone) || other.recurrenceTimezone == recurrenceTimezone)&&(identical(other.statusResetSeconds, statusResetSeconds) || other.statusResetSeconds == statusResetSeconds)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,creatorId,activity,location,details,startsAt,recurrenceRrule,recurrenceTimezone,statusResetSeconds,inviteCode,createdAt,updatedAt);

@override
String toString() {
  return 'HonkActivityModel(id: $id, creatorId: $creatorId, activity: $activity, location: $location, details: $details, startsAt: $startsAt, recurrenceRrule: $recurrenceRrule, recurrenceTimezone: $recurrenceTimezone, statusResetSeconds: $statusResetSeconds, inviteCode: $inviteCode, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $HonkActivityModelCopyWith<$Res>  {
  factory $HonkActivityModelCopyWith(HonkActivityModel value, $Res Function(HonkActivityModel) _then) = _$HonkActivityModelCopyWithImpl;
@useResult
$Res call({
 String id, String creatorId, String activity, String location, String? details, DateTime startsAt, String? recurrenceRrule, String recurrenceTimezone, int statusResetSeconds, String inviteCode, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$HonkActivityModelCopyWithImpl<$Res>
    implements $HonkActivityModelCopyWith<$Res> {
  _$HonkActivityModelCopyWithImpl(this._self, this._then);

  final HonkActivityModel _self;
  final $Res Function(HonkActivityModel) _then;

/// Create a copy of HonkActivityModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? creatorId = null,Object? activity = null,Object? location = null,Object? details = freezed,Object? startsAt = null,Object? recurrenceRrule = freezed,Object? recurrenceTimezone = null,Object? statusResetSeconds = null,Object? inviteCode = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,creatorId: null == creatorId ? _self.creatorId : creatorId // ignore: cast_nullable_to_non_nullable
as String,activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,recurrenceRrule: freezed == recurrenceRrule ? _self.recurrenceRrule : recurrenceRrule // ignore: cast_nullable_to_non_nullable
as String?,recurrenceTimezone: null == recurrenceTimezone ? _self.recurrenceTimezone : recurrenceTimezone // ignore: cast_nullable_to_non_nullable
as String,statusResetSeconds: null == statusResetSeconds ? _self.statusResetSeconds : statusResetSeconds // ignore: cast_nullable_to_non_nullable
as int,inviteCode: null == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [HonkActivityModel].
extension HonkActivityModelPatterns on HonkActivityModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HonkActivityModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HonkActivityModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HonkActivityModel value)  $default,){
final _that = this;
switch (_that) {
case _HonkActivityModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HonkActivityModel value)?  $default,){
final _that = this;
switch (_that) {
case _HonkActivityModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String creatorId,  String activity,  String location,  String? details,  DateTime startsAt,  String? recurrenceRrule,  String recurrenceTimezone,  int statusResetSeconds,  String inviteCode,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HonkActivityModel() when $default != null:
return $default(_that.id,_that.creatorId,_that.activity,_that.location,_that.details,_that.startsAt,_that.recurrenceRrule,_that.recurrenceTimezone,_that.statusResetSeconds,_that.inviteCode,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String creatorId,  String activity,  String location,  String? details,  DateTime startsAt,  String? recurrenceRrule,  String recurrenceTimezone,  int statusResetSeconds,  String inviteCode,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _HonkActivityModel():
return $default(_that.id,_that.creatorId,_that.activity,_that.location,_that.details,_that.startsAt,_that.recurrenceRrule,_that.recurrenceTimezone,_that.statusResetSeconds,_that.inviteCode,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String creatorId,  String activity,  String location,  String? details,  DateTime startsAt,  String? recurrenceRrule,  String recurrenceTimezone,  int statusResetSeconds,  String inviteCode,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _HonkActivityModel() when $default != null:
return $default(_that.id,_that.creatorId,_that.activity,_that.location,_that.details,_that.startsAt,_that.recurrenceRrule,_that.recurrenceTimezone,_that.statusResetSeconds,_that.inviteCode,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _HonkActivityModel extends HonkActivityModel {
  const _HonkActivityModel({required this.id, required this.creatorId, required this.activity, required this.location, this.details, required this.startsAt, this.recurrenceRrule, required this.recurrenceTimezone, required this.statusResetSeconds, required this.inviteCode, required this.createdAt, required this.updatedAt}): super._();
  factory _HonkActivityModel.fromJson(Map<String, dynamic> json) => _$HonkActivityModelFromJson(json);

@override final  String id;
@override final  String creatorId;
@override final  String activity;
@override final  String location;
@override final  String? details;
@override final  DateTime startsAt;
@override final  String? recurrenceRrule;
@override final  String recurrenceTimezone;
@override final  int statusResetSeconds;
@override final  String inviteCode;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of HonkActivityModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HonkActivityModelCopyWith<_HonkActivityModel> get copyWith => __$HonkActivityModelCopyWithImpl<_HonkActivityModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HonkActivityModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HonkActivityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.creatorId, creatorId) || other.creatorId == creatorId)&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.location, location) || other.location == location)&&(identical(other.details, details) || other.details == details)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.recurrenceRrule, recurrenceRrule) || other.recurrenceRrule == recurrenceRrule)&&(identical(other.recurrenceTimezone, recurrenceTimezone) || other.recurrenceTimezone == recurrenceTimezone)&&(identical(other.statusResetSeconds, statusResetSeconds) || other.statusResetSeconds == statusResetSeconds)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,creatorId,activity,location,details,startsAt,recurrenceRrule,recurrenceTimezone,statusResetSeconds,inviteCode,createdAt,updatedAt);

@override
String toString() {
  return 'HonkActivityModel(id: $id, creatorId: $creatorId, activity: $activity, location: $location, details: $details, startsAt: $startsAt, recurrenceRrule: $recurrenceRrule, recurrenceTimezone: $recurrenceTimezone, statusResetSeconds: $statusResetSeconds, inviteCode: $inviteCode, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$HonkActivityModelCopyWith<$Res> implements $HonkActivityModelCopyWith<$Res> {
  factory _$HonkActivityModelCopyWith(_HonkActivityModel value, $Res Function(_HonkActivityModel) _then) = __$HonkActivityModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String creatorId, String activity, String location, String? details, DateTime startsAt, String? recurrenceRrule, String recurrenceTimezone, int statusResetSeconds, String inviteCode, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$HonkActivityModelCopyWithImpl<$Res>
    implements _$HonkActivityModelCopyWith<$Res> {
  __$HonkActivityModelCopyWithImpl(this._self, this._then);

  final _HonkActivityModel _self;
  final $Res Function(_HonkActivityModel) _then;

/// Create a copy of HonkActivityModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? creatorId = null,Object? activity = null,Object? location = null,Object? details = freezed,Object? startsAt = null,Object? recurrenceRrule = freezed,Object? recurrenceTimezone = null,Object? statusResetSeconds = null,Object? inviteCode = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_HonkActivityModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,creatorId: null == creatorId ? _self.creatorId : creatorId // ignore: cast_nullable_to_non_nullable
as String,activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,recurrenceRrule: freezed == recurrenceRrule ? _self.recurrenceRrule : recurrenceRrule // ignore: cast_nullable_to_non_nullable
as String?,recurrenceTimezone: null == recurrenceTimezone ? _self.recurrenceTimezone : recurrenceTimezone // ignore: cast_nullable_to_non_nullable
as String,statusResetSeconds: null == statusResetSeconds ? _self.statusResetSeconds : statusResetSeconds // ignore: cast_nullable_to_non_nullable
as int,inviteCode: null == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
