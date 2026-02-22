// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'honk_details_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HonkDetailsState {

 bool get isLoading; HonkActivityDetails? get details; MainFailure? get loadFailure; bool get isSavingStatus; String? get savingStatusKey; bool get isDeleting; bool get isLeaving; bool get isRotatingInvite; bool get isUpdating; String? get rotatedInviteCode; MainFailure? get actionError; bool get wasDeleted; bool get wasLeft;
/// Create a copy of HonkDetailsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HonkDetailsStateCopyWith<HonkDetailsState> get copyWith => _$HonkDetailsStateCopyWithImpl<HonkDetailsState>(this as HonkDetailsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HonkDetailsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.details, details) || other.details == details)&&(identical(other.loadFailure, loadFailure) || other.loadFailure == loadFailure)&&(identical(other.isSavingStatus, isSavingStatus) || other.isSavingStatus == isSavingStatus)&&(identical(other.savingStatusKey, savingStatusKey) || other.savingStatusKey == savingStatusKey)&&(identical(other.isDeleting, isDeleting) || other.isDeleting == isDeleting)&&(identical(other.isLeaving, isLeaving) || other.isLeaving == isLeaving)&&(identical(other.isRotatingInvite, isRotatingInvite) || other.isRotatingInvite == isRotatingInvite)&&(identical(other.isUpdating, isUpdating) || other.isUpdating == isUpdating)&&(identical(other.rotatedInviteCode, rotatedInviteCode) || other.rotatedInviteCode == rotatedInviteCode)&&(identical(other.actionError, actionError) || other.actionError == actionError)&&(identical(other.wasDeleted, wasDeleted) || other.wasDeleted == wasDeleted)&&(identical(other.wasLeft, wasLeft) || other.wasLeft == wasLeft));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,details,loadFailure,isSavingStatus,savingStatusKey,isDeleting,isLeaving,isRotatingInvite,isUpdating,rotatedInviteCode,actionError,wasDeleted,wasLeft);

@override
String toString() {
  return 'HonkDetailsState(isLoading: $isLoading, details: $details, loadFailure: $loadFailure, isSavingStatus: $isSavingStatus, savingStatusKey: $savingStatusKey, isDeleting: $isDeleting, isLeaving: $isLeaving, isRotatingInvite: $isRotatingInvite, isUpdating: $isUpdating, rotatedInviteCode: $rotatedInviteCode, actionError: $actionError, wasDeleted: $wasDeleted, wasLeft: $wasLeft)';
}


}

/// @nodoc
abstract mixin class $HonkDetailsStateCopyWith<$Res>  {
  factory $HonkDetailsStateCopyWith(HonkDetailsState value, $Res Function(HonkDetailsState) _then) = _$HonkDetailsStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, HonkActivityDetails? details, MainFailure? loadFailure, bool isSavingStatus, String? savingStatusKey, bool isDeleting, bool isLeaving, bool isRotatingInvite, bool isUpdating, String? rotatedInviteCode, MainFailure? actionError, bool wasDeleted, bool wasLeft
});


$HonkActivityDetailsCopyWith<$Res>? get details;$MainFailureCopyWith<$Res>? get loadFailure;$MainFailureCopyWith<$Res>? get actionError;

}
/// @nodoc
class _$HonkDetailsStateCopyWithImpl<$Res>
    implements $HonkDetailsStateCopyWith<$Res> {
  _$HonkDetailsStateCopyWithImpl(this._self, this._then);

  final HonkDetailsState _self;
  final $Res Function(HonkDetailsState) _then;

/// Create a copy of HonkDetailsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? details = freezed,Object? loadFailure = freezed,Object? isSavingStatus = null,Object? savingStatusKey = freezed,Object? isDeleting = null,Object? isLeaving = null,Object? isRotatingInvite = null,Object? isUpdating = null,Object? rotatedInviteCode = freezed,Object? actionError = freezed,Object? wasDeleted = null,Object? wasLeft = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as HonkActivityDetails?,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as MainFailure?,isSavingStatus: null == isSavingStatus ? _self.isSavingStatus : isSavingStatus // ignore: cast_nullable_to_non_nullable
as bool,savingStatusKey: freezed == savingStatusKey ? _self.savingStatusKey : savingStatusKey // ignore: cast_nullable_to_non_nullable
as String?,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,isLeaving: null == isLeaving ? _self.isLeaving : isLeaving // ignore: cast_nullable_to_non_nullable
as bool,isRotatingInvite: null == isRotatingInvite ? _self.isRotatingInvite : isRotatingInvite // ignore: cast_nullable_to_non_nullable
as bool,isUpdating: null == isUpdating ? _self.isUpdating : isUpdating // ignore: cast_nullable_to_non_nullable
as bool,rotatedInviteCode: freezed == rotatedInviteCode ? _self.rotatedInviteCode : rotatedInviteCode // ignore: cast_nullable_to_non_nullable
as String?,actionError: freezed == actionError ? _self.actionError : actionError // ignore: cast_nullable_to_non_nullable
as MainFailure?,wasDeleted: null == wasDeleted ? _self.wasDeleted : wasDeleted // ignore: cast_nullable_to_non_nullable
as bool,wasLeft: null == wasLeft ? _self.wasLeft : wasLeft // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of HonkDetailsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HonkActivityDetailsCopyWith<$Res>? get details {
    if (_self.details == null) {
    return null;
  }

  return $HonkActivityDetailsCopyWith<$Res>(_self.details!, (value) {
    return _then(_self.copyWith(details: value));
  });
}/// Create a copy of HonkDetailsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MainFailureCopyWith<$Res>? get loadFailure {
    if (_self.loadFailure == null) {
    return null;
  }

  return $MainFailureCopyWith<$Res>(_self.loadFailure!, (value) {
    return _then(_self.copyWith(loadFailure: value));
  });
}/// Create a copy of HonkDetailsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MainFailureCopyWith<$Res>? get actionError {
    if (_self.actionError == null) {
    return null;
  }

  return $MainFailureCopyWith<$Res>(_self.actionError!, (value) {
    return _then(_self.copyWith(actionError: value));
  });
}
}


/// Adds pattern-matching-related methods to [HonkDetailsState].
extension HonkDetailsStatePatterns on HonkDetailsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HonkDetailsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HonkDetailsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HonkDetailsState value)  $default,){
final _that = this;
switch (_that) {
case _HonkDetailsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HonkDetailsState value)?  $default,){
final _that = this;
switch (_that) {
case _HonkDetailsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  HonkActivityDetails? details,  MainFailure? loadFailure,  bool isSavingStatus,  String? savingStatusKey,  bool isDeleting,  bool isLeaving,  bool isRotatingInvite,  bool isUpdating,  String? rotatedInviteCode,  MainFailure? actionError,  bool wasDeleted,  bool wasLeft)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HonkDetailsState() when $default != null:
return $default(_that.isLoading,_that.details,_that.loadFailure,_that.isSavingStatus,_that.savingStatusKey,_that.isDeleting,_that.isLeaving,_that.isRotatingInvite,_that.isUpdating,_that.rotatedInviteCode,_that.actionError,_that.wasDeleted,_that.wasLeft);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  HonkActivityDetails? details,  MainFailure? loadFailure,  bool isSavingStatus,  String? savingStatusKey,  bool isDeleting,  bool isLeaving,  bool isRotatingInvite,  bool isUpdating,  String? rotatedInviteCode,  MainFailure? actionError,  bool wasDeleted,  bool wasLeft)  $default,) {final _that = this;
switch (_that) {
case _HonkDetailsState():
return $default(_that.isLoading,_that.details,_that.loadFailure,_that.isSavingStatus,_that.savingStatusKey,_that.isDeleting,_that.isLeaving,_that.isRotatingInvite,_that.isUpdating,_that.rotatedInviteCode,_that.actionError,_that.wasDeleted,_that.wasLeft);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  HonkActivityDetails? details,  MainFailure? loadFailure,  bool isSavingStatus,  String? savingStatusKey,  bool isDeleting,  bool isLeaving,  bool isRotatingInvite,  bool isUpdating,  String? rotatedInviteCode,  MainFailure? actionError,  bool wasDeleted,  bool wasLeft)?  $default,) {final _that = this;
switch (_that) {
case _HonkDetailsState() when $default != null:
return $default(_that.isLoading,_that.details,_that.loadFailure,_that.isSavingStatus,_that.savingStatusKey,_that.isDeleting,_that.isLeaving,_that.isRotatingInvite,_that.isUpdating,_that.rotatedInviteCode,_that.actionError,_that.wasDeleted,_that.wasLeft);case _:
  return null;

}
}

}

/// @nodoc


class _HonkDetailsState implements HonkDetailsState {
  const _HonkDetailsState({this.isLoading = true, this.details, this.loadFailure, this.isSavingStatus = false, this.savingStatusKey, this.isDeleting = false, this.isLeaving = false, this.isRotatingInvite = false, this.isUpdating = false, this.rotatedInviteCode, this.actionError, this.wasDeleted = false, this.wasLeft = false});
  

@override@JsonKey() final  bool isLoading;
@override final  HonkActivityDetails? details;
@override final  MainFailure? loadFailure;
@override@JsonKey() final  bool isSavingStatus;
@override final  String? savingStatusKey;
@override@JsonKey() final  bool isDeleting;
@override@JsonKey() final  bool isLeaving;
@override@JsonKey() final  bool isRotatingInvite;
@override@JsonKey() final  bool isUpdating;
@override final  String? rotatedInviteCode;
@override final  MainFailure? actionError;
@override@JsonKey() final  bool wasDeleted;
@override@JsonKey() final  bool wasLeft;

/// Create a copy of HonkDetailsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HonkDetailsStateCopyWith<_HonkDetailsState> get copyWith => __$HonkDetailsStateCopyWithImpl<_HonkDetailsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HonkDetailsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.details, details) || other.details == details)&&(identical(other.loadFailure, loadFailure) || other.loadFailure == loadFailure)&&(identical(other.isSavingStatus, isSavingStatus) || other.isSavingStatus == isSavingStatus)&&(identical(other.savingStatusKey, savingStatusKey) || other.savingStatusKey == savingStatusKey)&&(identical(other.isDeleting, isDeleting) || other.isDeleting == isDeleting)&&(identical(other.isLeaving, isLeaving) || other.isLeaving == isLeaving)&&(identical(other.isRotatingInvite, isRotatingInvite) || other.isRotatingInvite == isRotatingInvite)&&(identical(other.isUpdating, isUpdating) || other.isUpdating == isUpdating)&&(identical(other.rotatedInviteCode, rotatedInviteCode) || other.rotatedInviteCode == rotatedInviteCode)&&(identical(other.actionError, actionError) || other.actionError == actionError)&&(identical(other.wasDeleted, wasDeleted) || other.wasDeleted == wasDeleted)&&(identical(other.wasLeft, wasLeft) || other.wasLeft == wasLeft));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,details,loadFailure,isSavingStatus,savingStatusKey,isDeleting,isLeaving,isRotatingInvite,isUpdating,rotatedInviteCode,actionError,wasDeleted,wasLeft);

@override
String toString() {
  return 'HonkDetailsState(isLoading: $isLoading, details: $details, loadFailure: $loadFailure, isSavingStatus: $isSavingStatus, savingStatusKey: $savingStatusKey, isDeleting: $isDeleting, isLeaving: $isLeaving, isRotatingInvite: $isRotatingInvite, isUpdating: $isUpdating, rotatedInviteCode: $rotatedInviteCode, actionError: $actionError, wasDeleted: $wasDeleted, wasLeft: $wasLeft)';
}


}

/// @nodoc
abstract mixin class _$HonkDetailsStateCopyWith<$Res> implements $HonkDetailsStateCopyWith<$Res> {
  factory _$HonkDetailsStateCopyWith(_HonkDetailsState value, $Res Function(_HonkDetailsState) _then) = __$HonkDetailsStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, HonkActivityDetails? details, MainFailure? loadFailure, bool isSavingStatus, String? savingStatusKey, bool isDeleting, bool isLeaving, bool isRotatingInvite, bool isUpdating, String? rotatedInviteCode, MainFailure? actionError, bool wasDeleted, bool wasLeft
});


@override $HonkActivityDetailsCopyWith<$Res>? get details;@override $MainFailureCopyWith<$Res>? get loadFailure;@override $MainFailureCopyWith<$Res>? get actionError;

}
/// @nodoc
class __$HonkDetailsStateCopyWithImpl<$Res>
    implements _$HonkDetailsStateCopyWith<$Res> {
  __$HonkDetailsStateCopyWithImpl(this._self, this._then);

  final _HonkDetailsState _self;
  final $Res Function(_HonkDetailsState) _then;

/// Create a copy of HonkDetailsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? details = freezed,Object? loadFailure = freezed,Object? isSavingStatus = null,Object? savingStatusKey = freezed,Object? isDeleting = null,Object? isLeaving = null,Object? isRotatingInvite = null,Object? isUpdating = null,Object? rotatedInviteCode = freezed,Object? actionError = freezed,Object? wasDeleted = null,Object? wasLeft = null,}) {
  return _then(_HonkDetailsState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as HonkActivityDetails?,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as MainFailure?,isSavingStatus: null == isSavingStatus ? _self.isSavingStatus : isSavingStatus // ignore: cast_nullable_to_non_nullable
as bool,savingStatusKey: freezed == savingStatusKey ? _self.savingStatusKey : savingStatusKey // ignore: cast_nullable_to_non_nullable
as String?,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,isLeaving: null == isLeaving ? _self.isLeaving : isLeaving // ignore: cast_nullable_to_non_nullable
as bool,isRotatingInvite: null == isRotatingInvite ? _self.isRotatingInvite : isRotatingInvite // ignore: cast_nullable_to_non_nullable
as bool,isUpdating: null == isUpdating ? _self.isUpdating : isUpdating // ignore: cast_nullable_to_non_nullable
as bool,rotatedInviteCode: freezed == rotatedInviteCode ? _self.rotatedInviteCode : rotatedInviteCode // ignore: cast_nullable_to_non_nullable
as String?,actionError: freezed == actionError ? _self.actionError : actionError // ignore: cast_nullable_to_non_nullable
as MainFailure?,wasDeleted: null == wasDeleted ? _self.wasDeleted : wasDeleted // ignore: cast_nullable_to_non_nullable
as bool,wasLeft: null == wasLeft ? _self.wasLeft : wasLeft // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of HonkDetailsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HonkActivityDetailsCopyWith<$Res>? get details {
    if (_self.details == null) {
    return null;
  }

  return $HonkActivityDetailsCopyWith<$Res>(_self.details!, (value) {
    return _then(_self.copyWith(details: value));
  });
}/// Create a copy of HonkDetailsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MainFailureCopyWith<$Res>? get loadFailure {
    if (_self.loadFailure == null) {
    return null;
  }

  return $MainFailureCopyWith<$Res>(_self.loadFailure!, (value) {
    return _then(_self.copyWith(loadFailure: value));
  });
}/// Create a copy of HonkDetailsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MainFailureCopyWith<$Res>? get actionError {
    if (_self.actionError == null) {
    return null;
  }

  return $MainFailureCopyWith<$Res>(_self.actionError!, (value) {
    return _then(_self.copyWith(actionError: value));
  });
}
}

// dart format on
