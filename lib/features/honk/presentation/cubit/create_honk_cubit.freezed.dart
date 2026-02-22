// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_honk_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreateHonkState {

 bool get isSubmitting; HonkActivity? get createdActivity; MainFailure? get submissionFailure;
/// Create a copy of CreateHonkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateHonkStateCopyWith<CreateHonkState> get copyWith => _$CreateHonkStateCopyWithImpl<CreateHonkState>(this as CreateHonkState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateHonkState&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.createdActivity, createdActivity) || other.createdActivity == createdActivity)&&(identical(other.submissionFailure, submissionFailure) || other.submissionFailure == submissionFailure));
}


@override
int get hashCode => Object.hash(runtimeType,isSubmitting,createdActivity,submissionFailure);

@override
String toString() {
  return 'CreateHonkState(isSubmitting: $isSubmitting, createdActivity: $createdActivity, submissionFailure: $submissionFailure)';
}


}

/// @nodoc
abstract mixin class $CreateHonkStateCopyWith<$Res>  {
  factory $CreateHonkStateCopyWith(CreateHonkState value, $Res Function(CreateHonkState) _then) = _$CreateHonkStateCopyWithImpl;
@useResult
$Res call({
 bool isSubmitting, HonkActivity? createdActivity, MainFailure? submissionFailure
});


$HonkActivityCopyWith<$Res>? get createdActivity;$MainFailureCopyWith<$Res>? get submissionFailure;

}
/// @nodoc
class _$CreateHonkStateCopyWithImpl<$Res>
    implements $CreateHonkStateCopyWith<$Res> {
  _$CreateHonkStateCopyWithImpl(this._self, this._then);

  final CreateHonkState _self;
  final $Res Function(CreateHonkState) _then;

/// Create a copy of CreateHonkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isSubmitting = null,Object? createdActivity = freezed,Object? submissionFailure = freezed,}) {
  return _then(_self.copyWith(
isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,createdActivity: freezed == createdActivity ? _self.createdActivity : createdActivity // ignore: cast_nullable_to_non_nullable
as HonkActivity?,submissionFailure: freezed == submissionFailure ? _self.submissionFailure : submissionFailure // ignore: cast_nullable_to_non_nullable
as MainFailure?,
  ));
}
/// Create a copy of CreateHonkState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HonkActivityCopyWith<$Res>? get createdActivity {
    if (_self.createdActivity == null) {
    return null;
  }

  return $HonkActivityCopyWith<$Res>(_self.createdActivity!, (value) {
    return _then(_self.copyWith(createdActivity: value));
  });
}/// Create a copy of CreateHonkState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MainFailureCopyWith<$Res>? get submissionFailure {
    if (_self.submissionFailure == null) {
    return null;
  }

  return $MainFailureCopyWith<$Res>(_self.submissionFailure!, (value) {
    return _then(_self.copyWith(submissionFailure: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreateHonkState].
extension CreateHonkStatePatterns on CreateHonkState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateHonkState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateHonkState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateHonkState value)  $default,){
final _that = this;
switch (_that) {
case _CreateHonkState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateHonkState value)?  $default,){
final _that = this;
switch (_that) {
case _CreateHonkState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isSubmitting,  HonkActivity? createdActivity,  MainFailure? submissionFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateHonkState() when $default != null:
return $default(_that.isSubmitting,_that.createdActivity,_that.submissionFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isSubmitting,  HonkActivity? createdActivity,  MainFailure? submissionFailure)  $default,) {final _that = this;
switch (_that) {
case _CreateHonkState():
return $default(_that.isSubmitting,_that.createdActivity,_that.submissionFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isSubmitting,  HonkActivity? createdActivity,  MainFailure? submissionFailure)?  $default,) {final _that = this;
switch (_that) {
case _CreateHonkState() when $default != null:
return $default(_that.isSubmitting,_that.createdActivity,_that.submissionFailure);case _:
  return null;

}
}

}

/// @nodoc


class _CreateHonkState implements CreateHonkState {
  const _CreateHonkState({this.isSubmitting = false, this.createdActivity, this.submissionFailure});
  

@override@JsonKey() final  bool isSubmitting;
@override final  HonkActivity? createdActivity;
@override final  MainFailure? submissionFailure;

/// Create a copy of CreateHonkState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateHonkStateCopyWith<_CreateHonkState> get copyWith => __$CreateHonkStateCopyWithImpl<_CreateHonkState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateHonkState&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.createdActivity, createdActivity) || other.createdActivity == createdActivity)&&(identical(other.submissionFailure, submissionFailure) || other.submissionFailure == submissionFailure));
}


@override
int get hashCode => Object.hash(runtimeType,isSubmitting,createdActivity,submissionFailure);

@override
String toString() {
  return 'CreateHonkState(isSubmitting: $isSubmitting, createdActivity: $createdActivity, submissionFailure: $submissionFailure)';
}


}

/// @nodoc
abstract mixin class _$CreateHonkStateCopyWith<$Res> implements $CreateHonkStateCopyWith<$Res> {
  factory _$CreateHonkStateCopyWith(_CreateHonkState value, $Res Function(_CreateHonkState) _then) = __$CreateHonkStateCopyWithImpl;
@override @useResult
$Res call({
 bool isSubmitting, HonkActivity? createdActivity, MainFailure? submissionFailure
});


@override $HonkActivityCopyWith<$Res>? get createdActivity;@override $MainFailureCopyWith<$Res>? get submissionFailure;

}
/// @nodoc
class __$CreateHonkStateCopyWithImpl<$Res>
    implements _$CreateHonkStateCopyWith<$Res> {
  __$CreateHonkStateCopyWithImpl(this._self, this._then);

  final _CreateHonkState _self;
  final $Res Function(_CreateHonkState) _then;

/// Create a copy of CreateHonkState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isSubmitting = null,Object? createdActivity = freezed,Object? submissionFailure = freezed,}) {
  return _then(_CreateHonkState(
isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,createdActivity: freezed == createdActivity ? _self.createdActivity : createdActivity // ignore: cast_nullable_to_non_nullable
as HonkActivity?,submissionFailure: freezed == submissionFailure ? _self.submissionFailure : submissionFailure // ignore: cast_nullable_to_non_nullable
as MainFailure?,
  ));
}

/// Create a copy of CreateHonkState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HonkActivityCopyWith<$Res>? get createdActivity {
    if (_self.createdActivity == null) {
    return null;
  }

  return $HonkActivityCopyWith<$Res>(_self.createdActivity!, (value) {
    return _then(_self.copyWith(createdActivity: value));
  });
}/// Create a copy of CreateHonkState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MainFailureCopyWith<$Res>? get submissionFailure {
    if (_self.submissionFailure == null) {
    return null;
  }

  return $MainFailureCopyWith<$Res>(_self.submissionFailure!, (value) {
    return _then(_self.copyWith(submissionFailure: value));
  });
}
}

// dart format on
