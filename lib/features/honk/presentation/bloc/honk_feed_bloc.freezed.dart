// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'honk_feed_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HonkFeedEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HonkFeedEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HonkFeedEvent()';
}


}

/// @nodoc
class $HonkFeedEventCopyWith<$Res>  {
$HonkFeedEventCopyWith(HonkFeedEvent _, $Res Function(HonkFeedEvent) __);
}


/// Adds pattern-matching-related methods to [HonkFeedEvent].
extension HonkFeedEventPatterns on HonkFeedEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _HonksUpdated value)?  honksUpdated,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _HonksUpdated() when honksUpdated != null:
return honksUpdated(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _HonksUpdated value)  honksUpdated,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _HonksUpdated():
return honksUpdated(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _HonksUpdated value)?  honksUpdated,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _HonksUpdated() when honksUpdated != null:
return honksUpdated(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( Either<MainFailure, List<HonkActivitySummary>> result)?  honksUpdated,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _HonksUpdated() when honksUpdated != null:
return honksUpdated(_that.result);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( Either<MainFailure, List<HonkActivitySummary>> result)  honksUpdated,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _HonksUpdated():
return honksUpdated(_that.result);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( Either<MainFailure, List<HonkActivitySummary>> result)?  honksUpdated,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _HonksUpdated() when honksUpdated != null:
return honksUpdated(_that.result);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements HonkFeedEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HonkFeedEvent.started()';
}


}




/// @nodoc


class _HonksUpdated implements HonkFeedEvent {
  const _HonksUpdated(this.result);
  

 final  Either<MainFailure, List<HonkActivitySummary>> result;

/// Create a copy of HonkFeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HonksUpdatedCopyWith<_HonksUpdated> get copyWith => __$HonksUpdatedCopyWithImpl<_HonksUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HonksUpdated&&(identical(other.result, result) || other.result == result));
}


@override
int get hashCode => Object.hash(runtimeType,result);

@override
String toString() {
  return 'HonkFeedEvent.honksUpdated(result: $result)';
}


}

/// @nodoc
abstract mixin class _$HonksUpdatedCopyWith<$Res> implements $HonkFeedEventCopyWith<$Res> {
  factory _$HonksUpdatedCopyWith(_HonksUpdated value, $Res Function(_HonksUpdated) _then) = __$HonksUpdatedCopyWithImpl;
@useResult
$Res call({
 Either<MainFailure, List<HonkActivitySummary>> result
});




}
/// @nodoc
class __$HonksUpdatedCopyWithImpl<$Res>
    implements _$HonksUpdatedCopyWith<$Res> {
  __$HonksUpdatedCopyWithImpl(this._self, this._then);

  final _HonksUpdated _self;
  final $Res Function(_HonksUpdated) _then;

/// Create a copy of HonkFeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? result = null,}) {
  return _then(_HonksUpdated(
null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as Either<MainFailure, List<HonkActivitySummary>>,
  ));
}


}

/// @nodoc
mixin _$HonkFeedState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HonkFeedState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HonkFeedState()';
}


}

/// @nodoc
class $HonkFeedStateCopyWith<$Res>  {
$HonkFeedStateCopyWith(HonkFeedState _, $Res Function(HonkFeedState) __);
}


/// Adds pattern-matching-related methods to [HonkFeedState].
extension HonkFeedStatePatterns on HonkFeedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _LoadInProgress value)?  loadInProgress,TResult Function( _LoadSuccess value)?  loadSuccess,TResult Function( _LoadFailure value)?  loadFailure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _LoadInProgress() when loadInProgress != null:
return loadInProgress(_that);case _LoadSuccess() when loadSuccess != null:
return loadSuccess(_that);case _LoadFailure() when loadFailure != null:
return loadFailure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _LoadInProgress value)  loadInProgress,required TResult Function( _LoadSuccess value)  loadSuccess,required TResult Function( _LoadFailure value)  loadFailure,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _LoadInProgress():
return loadInProgress(_that);case _LoadSuccess():
return loadSuccess(_that);case _LoadFailure():
return loadFailure(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _LoadInProgress value)?  loadInProgress,TResult? Function( _LoadSuccess value)?  loadSuccess,TResult? Function( _LoadFailure value)?  loadFailure,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _LoadInProgress() when loadInProgress != null:
return loadInProgress(_that);case _LoadSuccess() when loadSuccess != null:
return loadSuccess(_that);case _LoadFailure() when loadFailure != null:
return loadFailure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loadInProgress,TResult Function( List<HonkActivitySummary> honks)?  loadSuccess,TResult Function( MainFailure failure)?  loadFailure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _LoadInProgress() when loadInProgress != null:
return loadInProgress();case _LoadSuccess() when loadSuccess != null:
return loadSuccess(_that.honks);case _LoadFailure() when loadFailure != null:
return loadFailure(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loadInProgress,required TResult Function( List<HonkActivitySummary> honks)  loadSuccess,required TResult Function( MainFailure failure)  loadFailure,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _LoadInProgress():
return loadInProgress();case _LoadSuccess():
return loadSuccess(_that.honks);case _LoadFailure():
return loadFailure(_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loadInProgress,TResult? Function( List<HonkActivitySummary> honks)?  loadSuccess,TResult? Function( MainFailure failure)?  loadFailure,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _LoadInProgress() when loadInProgress != null:
return loadInProgress();case _LoadSuccess() when loadSuccess != null:
return loadSuccess(_that.honks);case _LoadFailure() when loadFailure != null:
return loadFailure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements HonkFeedState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HonkFeedState.initial()';
}


}




/// @nodoc


class _LoadInProgress implements HonkFeedState {
  const _LoadInProgress();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadInProgress);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HonkFeedState.loadInProgress()';
}


}




/// @nodoc


class _LoadSuccess implements HonkFeedState {
  const _LoadSuccess(final  List<HonkActivitySummary> honks): _honks = honks;
  

 final  List<HonkActivitySummary> _honks;
 List<HonkActivitySummary> get honks {
  if (_honks is EqualUnmodifiableListView) return _honks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_honks);
}


/// Create a copy of HonkFeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadSuccessCopyWith<_LoadSuccess> get copyWith => __$LoadSuccessCopyWithImpl<_LoadSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadSuccess&&const DeepCollectionEquality().equals(other._honks, _honks));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_honks));

@override
String toString() {
  return 'HonkFeedState.loadSuccess(honks: $honks)';
}


}

/// @nodoc
abstract mixin class _$LoadSuccessCopyWith<$Res> implements $HonkFeedStateCopyWith<$Res> {
  factory _$LoadSuccessCopyWith(_LoadSuccess value, $Res Function(_LoadSuccess) _then) = __$LoadSuccessCopyWithImpl;
@useResult
$Res call({
 List<HonkActivitySummary> honks
});




}
/// @nodoc
class __$LoadSuccessCopyWithImpl<$Res>
    implements _$LoadSuccessCopyWith<$Res> {
  __$LoadSuccessCopyWithImpl(this._self, this._then);

  final _LoadSuccess _self;
  final $Res Function(_LoadSuccess) _then;

/// Create a copy of HonkFeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? honks = null,}) {
  return _then(_LoadSuccess(
null == honks ? _self._honks : honks // ignore: cast_nullable_to_non_nullable
as List<HonkActivitySummary>,
  ));
}


}

/// @nodoc


class _LoadFailure implements HonkFeedState {
  const _LoadFailure(this.failure);
  

 final  MainFailure failure;

/// Create a copy of HonkFeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadFailureCopyWith<_LoadFailure> get copyWith => __$LoadFailureCopyWithImpl<_LoadFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'HonkFeedState.loadFailure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$LoadFailureCopyWith<$Res> implements $HonkFeedStateCopyWith<$Res> {
  factory _$LoadFailureCopyWith(_LoadFailure value, $Res Function(_LoadFailure) _then) = __$LoadFailureCopyWithImpl;
@useResult
$Res call({
 MainFailure failure
});


$MainFailureCopyWith<$Res> get failure;

}
/// @nodoc
class __$LoadFailureCopyWithImpl<$Res>
    implements _$LoadFailureCopyWith<$Res> {
  __$LoadFailureCopyWithImpl(this._self, this._then);

  final _LoadFailure _self;
  final $Res Function(_LoadFailure) _then;

/// Create a copy of HonkFeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(_LoadFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as MainFailure,
  ));
}

/// Create a copy of HonkFeedState
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
