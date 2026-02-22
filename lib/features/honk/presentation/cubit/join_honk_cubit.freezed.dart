// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'join_honk_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JoinHonkState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JoinHonkState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JoinHonkState()';
}


}

/// @nodoc
class $JoinHonkStateCopyWith<$Res>  {
$JoinHonkStateCopyWith(JoinHonkState _, $Res Function(JoinHonkState) __);
}


/// Adds pattern-matching-related methods to [JoinHonkState].
extension JoinHonkStatePatterns on JoinHonkState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Idle value)?  idle,TResult Function( _Loading value)?  loading,TResult Function( _PendingApproval value)?  pendingApproval,TResult Function( _Success value)?  success,TResult Function( _Failure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle(_that);case _Loading() when loading != null:
return loading(_that);case _PendingApproval() when pendingApproval != null:
return pendingApproval(_that);case _Success() when success != null:
return success(_that);case _Failure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Idle value)  idle,required TResult Function( _Loading value)  loading,required TResult Function( _PendingApproval value)  pendingApproval,required TResult Function( _Success value)  success,required TResult Function( _Failure value)  failure,}){
final _that = this;
switch (_that) {
case _Idle():
return idle(_that);case _Loading():
return loading(_that);case _PendingApproval():
return pendingApproval(_that);case _Success():
return success(_that);case _Failure():
return failure(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Idle value)?  idle,TResult? Function( _Loading value)?  loading,TResult? Function( _PendingApproval value)?  pendingApproval,TResult? Function( _Success value)?  success,TResult? Function( _Failure value)?  failure,}){
final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle(_that);case _Loading() when loading != null:
return loading(_that);case _PendingApproval() when pendingApproval != null:
return pendingApproval(_that);case _Success() when success != null:
return success(_that);case _Failure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  loading,TResult Function( String activityId)?  pendingApproval,TResult Function( String activityId)?  success,TResult Function( MainFailure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle();case _Loading() when loading != null:
return loading();case _PendingApproval() when pendingApproval != null:
return pendingApproval(_that.activityId);case _Success() when success != null:
return success(_that.activityId);case _Failure() when failure != null:
return failure(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  loading,required TResult Function( String activityId)  pendingApproval,required TResult Function( String activityId)  success,required TResult Function( MainFailure failure)  failure,}) {final _that = this;
switch (_that) {
case _Idle():
return idle();case _Loading():
return loading();case _PendingApproval():
return pendingApproval(_that.activityId);case _Success():
return success(_that.activityId);case _Failure():
return failure(_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  loading,TResult? Function( String activityId)?  pendingApproval,TResult? Function( String activityId)?  success,TResult? Function( MainFailure failure)?  failure,}) {final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle();case _Loading() when loading != null:
return loading();case _PendingApproval() when pendingApproval != null:
return pendingApproval(_that.activityId);case _Success() when success != null:
return success(_that.activityId);case _Failure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _Idle implements JoinHonkState {
  const _Idle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Idle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JoinHonkState.idle()';
}


}




/// @nodoc


class _Loading implements JoinHonkState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JoinHonkState.loading()';
}


}




/// @nodoc


class _PendingApproval implements JoinHonkState {
  const _PendingApproval(this.activityId);
  

 final  String activityId;

/// Create a copy of JoinHonkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PendingApprovalCopyWith<_PendingApproval> get copyWith => __$PendingApprovalCopyWithImpl<_PendingApproval>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PendingApproval&&(identical(other.activityId, activityId) || other.activityId == activityId));
}


@override
int get hashCode => Object.hash(runtimeType,activityId);

@override
String toString() {
  return 'JoinHonkState.pendingApproval(activityId: $activityId)';
}


}

/// @nodoc
abstract mixin class _$PendingApprovalCopyWith<$Res> implements $JoinHonkStateCopyWith<$Res> {
  factory _$PendingApprovalCopyWith(_PendingApproval value, $Res Function(_PendingApproval) _then) = __$PendingApprovalCopyWithImpl;
@useResult
$Res call({
 String activityId
});




}
/// @nodoc
class __$PendingApprovalCopyWithImpl<$Res>
    implements _$PendingApprovalCopyWith<$Res> {
  __$PendingApprovalCopyWithImpl(this._self, this._then);

  final _PendingApproval _self;
  final $Res Function(_PendingApproval) _then;

/// Create a copy of JoinHonkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? activityId = null,}) {
  return _then(_PendingApproval(
null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Success implements JoinHonkState {
  const _Success(this.activityId);
  

 final  String activityId;

/// Create a copy of JoinHonkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessCopyWith<_Success> get copyWith => __$SuccessCopyWithImpl<_Success>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success&&(identical(other.activityId, activityId) || other.activityId == activityId));
}


@override
int get hashCode => Object.hash(runtimeType,activityId);

@override
String toString() {
  return 'JoinHonkState.success(activityId: $activityId)';
}


}

/// @nodoc
abstract mixin class _$SuccessCopyWith<$Res> implements $JoinHonkStateCopyWith<$Res> {
  factory _$SuccessCopyWith(_Success value, $Res Function(_Success) _then) = __$SuccessCopyWithImpl;
@useResult
$Res call({
 String activityId
});




}
/// @nodoc
class __$SuccessCopyWithImpl<$Res>
    implements _$SuccessCopyWith<$Res> {
  __$SuccessCopyWithImpl(this._self, this._then);

  final _Success _self;
  final $Res Function(_Success) _then;

/// Create a copy of JoinHonkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? activityId = null,}) {
  return _then(_Success(
null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Failure implements JoinHonkState {
  const _Failure(this.failure);
  

 final  MainFailure failure;

/// Create a copy of JoinHonkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FailureCopyWith<_Failure> get copyWith => __$FailureCopyWithImpl<_Failure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Failure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'JoinHonkState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$FailureCopyWith<$Res> implements $JoinHonkStateCopyWith<$Res> {
  factory _$FailureCopyWith(_Failure value, $Res Function(_Failure) _then) = __$FailureCopyWithImpl;
@useResult
$Res call({
 MainFailure failure
});


$MainFailureCopyWith<$Res> get failure;

}
/// @nodoc
class __$FailureCopyWithImpl<$Res>
    implements _$FailureCopyWith<$Res> {
  __$FailureCopyWithImpl(this._self, this._then);

  final _Failure _self;
  final $Res Function(_Failure) _then;

/// Create a copy of JoinHonkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(_Failure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as MainFailure,
  ));
}

/// Create a copy of JoinHonkState
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
