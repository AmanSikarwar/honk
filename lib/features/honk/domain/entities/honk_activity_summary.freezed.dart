// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'honk_activity_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HonkActivitySummary {

 String get id; String get activity; String get location; String? get details; int get statusResetSeconds; String get defaultStatusKey; int get participantCount; bool get isCreator;
/// Create a copy of HonkActivitySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HonkActivitySummaryCopyWith<HonkActivitySummary> get copyWith => _$HonkActivitySummaryCopyWithImpl<HonkActivitySummary>(this as HonkActivitySummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HonkActivitySummary&&(identical(other.id, id) || other.id == id)&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.location, location) || other.location == location)&&(identical(other.details, details) || other.details == details)&&(identical(other.statusResetSeconds, statusResetSeconds) || other.statusResetSeconds == statusResetSeconds)&&(identical(other.defaultStatusKey, defaultStatusKey) || other.defaultStatusKey == defaultStatusKey)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount)&&(identical(other.isCreator, isCreator) || other.isCreator == isCreator));
}


@override
int get hashCode => Object.hash(runtimeType,id,activity,location,details,statusResetSeconds,defaultStatusKey,participantCount,isCreator);

@override
String toString() {
  return 'HonkActivitySummary(id: $id, activity: $activity, location: $location, details: $details, statusResetSeconds: $statusResetSeconds, defaultStatusKey: $defaultStatusKey, participantCount: $participantCount, isCreator: $isCreator)';
}


}

/// @nodoc
abstract mixin class $HonkActivitySummaryCopyWith<$Res>  {
  factory $HonkActivitySummaryCopyWith(HonkActivitySummary value, $Res Function(HonkActivitySummary) _then) = _$HonkActivitySummaryCopyWithImpl;
@useResult
$Res call({
 String id, String activity, String location, String? details, int statusResetSeconds, String defaultStatusKey, int participantCount, bool isCreator
});




}
/// @nodoc
class _$HonkActivitySummaryCopyWithImpl<$Res>
    implements $HonkActivitySummaryCopyWith<$Res> {
  _$HonkActivitySummaryCopyWithImpl(this._self, this._then);

  final HonkActivitySummary _self;
  final $Res Function(HonkActivitySummary) _then;

/// Create a copy of HonkActivitySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? activity = null,Object? location = null,Object? details = freezed,Object? statusResetSeconds = null,Object? defaultStatusKey = null,Object? participantCount = null,Object? isCreator = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,statusResetSeconds: null == statusResetSeconds ? _self.statusResetSeconds : statusResetSeconds // ignore: cast_nullable_to_non_nullable
as int,defaultStatusKey: null == defaultStatusKey ? _self.defaultStatusKey : defaultStatusKey // ignore: cast_nullable_to_non_nullable
as String,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,isCreator: null == isCreator ? _self.isCreator : isCreator // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HonkActivitySummary].
extension HonkActivitySummaryPatterns on HonkActivitySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HonkActivitySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HonkActivitySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HonkActivitySummary value)  $default,){
final _that = this;
switch (_that) {
case _HonkActivitySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HonkActivitySummary value)?  $default,){
final _that = this;
switch (_that) {
case _HonkActivitySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String activity,  String location,  String? details,  int statusResetSeconds,  String defaultStatusKey,  int participantCount,  bool isCreator)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HonkActivitySummary() when $default != null:
return $default(_that.id,_that.activity,_that.location,_that.details,_that.statusResetSeconds,_that.defaultStatusKey,_that.participantCount,_that.isCreator);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String activity,  String location,  String? details,  int statusResetSeconds,  String defaultStatusKey,  int participantCount,  bool isCreator)  $default,) {final _that = this;
switch (_that) {
case _HonkActivitySummary():
return $default(_that.id,_that.activity,_that.location,_that.details,_that.statusResetSeconds,_that.defaultStatusKey,_that.participantCount,_that.isCreator);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String activity,  String location,  String? details,  int statusResetSeconds,  String defaultStatusKey,  int participantCount,  bool isCreator)?  $default,) {final _that = this;
switch (_that) {
case _HonkActivitySummary() when $default != null:
return $default(_that.id,_that.activity,_that.location,_that.details,_that.statusResetSeconds,_that.defaultStatusKey,_that.participantCount,_that.isCreator);case _:
  return null;

}
}

}

/// @nodoc


class _HonkActivitySummary implements HonkActivitySummary {
  const _HonkActivitySummary({required this.id, required this.activity, required this.location, this.details, required this.statusResetSeconds, required this.defaultStatusKey, required this.participantCount, required this.isCreator});
  

@override final  String id;
@override final  String activity;
@override final  String location;
@override final  String? details;
@override final  int statusResetSeconds;
@override final  String defaultStatusKey;
@override final  int participantCount;
@override final  bool isCreator;

/// Create a copy of HonkActivitySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HonkActivitySummaryCopyWith<_HonkActivitySummary> get copyWith => __$HonkActivitySummaryCopyWithImpl<_HonkActivitySummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HonkActivitySummary&&(identical(other.id, id) || other.id == id)&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.location, location) || other.location == location)&&(identical(other.details, details) || other.details == details)&&(identical(other.statusResetSeconds, statusResetSeconds) || other.statusResetSeconds == statusResetSeconds)&&(identical(other.defaultStatusKey, defaultStatusKey) || other.defaultStatusKey == defaultStatusKey)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount)&&(identical(other.isCreator, isCreator) || other.isCreator == isCreator));
}


@override
int get hashCode => Object.hash(runtimeType,id,activity,location,details,statusResetSeconds,defaultStatusKey,participantCount,isCreator);

@override
String toString() {
  return 'HonkActivitySummary(id: $id, activity: $activity, location: $location, details: $details, statusResetSeconds: $statusResetSeconds, defaultStatusKey: $defaultStatusKey, participantCount: $participantCount, isCreator: $isCreator)';
}


}

/// @nodoc
abstract mixin class _$HonkActivitySummaryCopyWith<$Res> implements $HonkActivitySummaryCopyWith<$Res> {
  factory _$HonkActivitySummaryCopyWith(_HonkActivitySummary value, $Res Function(_HonkActivitySummary) _then) = __$HonkActivitySummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String activity, String location, String? details, int statusResetSeconds, String defaultStatusKey, int participantCount, bool isCreator
});




}
/// @nodoc
class __$HonkActivitySummaryCopyWithImpl<$Res>
    implements _$HonkActivitySummaryCopyWith<$Res> {
  __$HonkActivitySummaryCopyWithImpl(this._self, this._then);

  final _HonkActivitySummary _self;
  final $Res Function(_HonkActivitySummary) _then;

/// Create a copy of HonkActivitySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? activity = null,Object? location = null,Object? details = freezed,Object? statusResetSeconds = null,Object? defaultStatusKey = null,Object? participantCount = null,Object? isCreator = null,}) {
  return _then(_HonkActivitySummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,statusResetSeconds: null == statusResetSeconds ? _self.statusResetSeconds : statusResetSeconds // ignore: cast_nullable_to_non_nullable
as int,defaultStatusKey: null == defaultStatusKey ? _self.defaultStatusKey : defaultStatusKey // ignore: cast_nullable_to_non_nullable
as String,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,isCreator: null == isCreator ? _self.isCreator : isCreator // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
