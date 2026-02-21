// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_sync_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationSyncState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationSyncState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationSyncState()';
}


}

/// @nodoc
class $NotificationSyncStateCopyWith<$Res>  {
$NotificationSyncStateCopyWith(NotificationSyncState _, $Res Function(NotificationSyncState) __);
}


/// Adds pattern-matching-related methods to [NotificationSyncState].
extension NotificationSyncStatePatterns on NotificationSyncState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Idle value)?  idle,TResult Function( _SyncInProgress value)?  syncInProgress,TResult Function( _SyncSuccess value)?  syncSuccess,TResult Function( _SyncFailure value)?  syncFailure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle(_that);case _SyncInProgress() when syncInProgress != null:
return syncInProgress(_that);case _SyncSuccess() when syncSuccess != null:
return syncSuccess(_that);case _SyncFailure() when syncFailure != null:
return syncFailure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Idle value)  idle,required TResult Function( _SyncInProgress value)  syncInProgress,required TResult Function( _SyncSuccess value)  syncSuccess,required TResult Function( _SyncFailure value)  syncFailure,}){
final _that = this;
switch (_that) {
case _Idle():
return idle(_that);case _SyncInProgress():
return syncInProgress(_that);case _SyncSuccess():
return syncSuccess(_that);case _SyncFailure():
return syncFailure(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Idle value)?  idle,TResult? Function( _SyncInProgress value)?  syncInProgress,TResult? Function( _SyncSuccess value)?  syncSuccess,TResult? Function( _SyncFailure value)?  syncFailure,}){
final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle(_that);case _SyncInProgress() when syncInProgress != null:
return syncInProgress(_that);case _SyncSuccess() when syncSuccess != null:
return syncSuccess(_that);case _SyncFailure() when syncFailure != null:
return syncFailure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  syncInProgress,TResult Function()?  syncSuccess,TResult Function( MainFailure failure)?  syncFailure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle();case _SyncInProgress() when syncInProgress != null:
return syncInProgress();case _SyncSuccess() when syncSuccess != null:
return syncSuccess();case _SyncFailure() when syncFailure != null:
return syncFailure(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  syncInProgress,required TResult Function()  syncSuccess,required TResult Function( MainFailure failure)  syncFailure,}) {final _that = this;
switch (_that) {
case _Idle():
return idle();case _SyncInProgress():
return syncInProgress();case _SyncSuccess():
return syncSuccess();case _SyncFailure():
return syncFailure(_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  syncInProgress,TResult? Function()?  syncSuccess,TResult? Function( MainFailure failure)?  syncFailure,}) {final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle();case _SyncInProgress() when syncInProgress != null:
return syncInProgress();case _SyncSuccess() when syncSuccess != null:
return syncSuccess();case _SyncFailure() when syncFailure != null:
return syncFailure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _Idle implements NotificationSyncState {
  const _Idle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Idle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationSyncState.idle()';
}


}




/// @nodoc


class _SyncInProgress implements NotificationSyncState {
  const _SyncInProgress();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncInProgress);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationSyncState.syncInProgress()';
}


}




/// @nodoc


class _SyncSuccess implements NotificationSyncState {
  const _SyncSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationSyncState.syncSuccess()';
}


}




/// @nodoc


class _SyncFailure implements NotificationSyncState {
  const _SyncFailure(this.failure);
  

 final  MainFailure failure;

/// Create a copy of NotificationSyncState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncFailureCopyWith<_SyncFailure> get copyWith => __$SyncFailureCopyWithImpl<_SyncFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'NotificationSyncState.syncFailure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$SyncFailureCopyWith<$Res> implements $NotificationSyncStateCopyWith<$Res> {
  factory _$SyncFailureCopyWith(_SyncFailure value, $Res Function(_SyncFailure) _then) = __$SyncFailureCopyWithImpl;
@useResult
$Res call({
 MainFailure failure
});


$MainFailureCopyWith<$Res> get failure;

}
/// @nodoc
class __$SyncFailureCopyWithImpl<$Res>
    implements _$SyncFailureCopyWith<$Res> {
  __$SyncFailureCopyWithImpl(this._self, this._then);

  final _SyncFailure _self;
  final $Res Function(_SyncFailure) _then;

/// Create a copy of NotificationSyncState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(_SyncFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as MainFailure,
  ));
}

/// Create a copy of NotificationSyncState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MainFailureCopyWith<$Res> get failure {
  
  return $MainFailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
