// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'honk_participant_candidate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HonkParticipantCandidate {

 String get id; String get username;
/// Create a copy of HonkParticipantCandidate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HonkParticipantCandidateCopyWith<HonkParticipantCandidate> get copyWith => _$HonkParticipantCandidateCopyWithImpl<HonkParticipantCandidate>(this as HonkParticipantCandidate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HonkParticipantCandidate&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username));
}


@override
int get hashCode => Object.hash(runtimeType,id,username);

@override
String toString() {
  return 'HonkParticipantCandidate(id: $id, username: $username)';
}


}

/// @nodoc
abstract mixin class $HonkParticipantCandidateCopyWith<$Res>  {
  factory $HonkParticipantCandidateCopyWith(HonkParticipantCandidate value, $Res Function(HonkParticipantCandidate) _then) = _$HonkParticipantCandidateCopyWithImpl;
@useResult
$Res call({
 String id, String username
});




}
/// @nodoc
class _$HonkParticipantCandidateCopyWithImpl<$Res>
    implements $HonkParticipantCandidateCopyWith<$Res> {
  _$HonkParticipantCandidateCopyWithImpl(this._self, this._then);

  final HonkParticipantCandidate _self;
  final $Res Function(HonkParticipantCandidate) _then;

/// Create a copy of HonkParticipantCandidate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HonkParticipantCandidate].
extension HonkParticipantCandidatePatterns on HonkParticipantCandidate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HonkParticipantCandidate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HonkParticipantCandidate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HonkParticipantCandidate value)  $default,){
final _that = this;
switch (_that) {
case _HonkParticipantCandidate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HonkParticipantCandidate value)?  $default,){
final _that = this;
switch (_that) {
case _HonkParticipantCandidate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HonkParticipantCandidate() when $default != null:
return $default(_that.id,_that.username);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username)  $default,) {final _that = this;
switch (_that) {
case _HonkParticipantCandidate():
return $default(_that.id,_that.username);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username)?  $default,) {final _that = this;
switch (_that) {
case _HonkParticipantCandidate() when $default != null:
return $default(_that.id,_that.username);case _:
  return null;

}
}

}

/// @nodoc


class _HonkParticipantCandidate implements HonkParticipantCandidate {
  const _HonkParticipantCandidate({required this.id, required this.username});
  

@override final  String id;
@override final  String username;

/// Create a copy of HonkParticipantCandidate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HonkParticipantCandidateCopyWith<_HonkParticipantCandidate> get copyWith => __$HonkParticipantCandidateCopyWithImpl<_HonkParticipantCandidate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HonkParticipantCandidate&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username));
}


@override
int get hashCode => Object.hash(runtimeType,id,username);

@override
String toString() {
  return 'HonkParticipantCandidate(id: $id, username: $username)';
}


}

/// @nodoc
abstract mixin class _$HonkParticipantCandidateCopyWith<$Res> implements $HonkParticipantCandidateCopyWith<$Res> {
  factory _$HonkParticipantCandidateCopyWith(_HonkParticipantCandidate value, $Res Function(_HonkParticipantCandidate) _then) = __$HonkParticipantCandidateCopyWithImpl;
@override @useResult
$Res call({
 String id, String username
});




}
/// @nodoc
class __$HonkParticipantCandidateCopyWithImpl<$Res>
    implements _$HonkParticipantCandidateCopyWith<$Res> {
  __$HonkParticipantCandidateCopyWithImpl(this._self, this._then);

  final _HonkParticipantCandidate _self;
  final $Res Function(_HonkParticipantCandidate) _then;

/// Create a copy of HonkParticipantCandidate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,}) {
  return _then(_HonkParticipantCandidate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
