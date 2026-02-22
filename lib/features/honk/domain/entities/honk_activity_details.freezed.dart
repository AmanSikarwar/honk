// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'honk_activity_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HonkActivityDetails {

 HonkActivity get activity; List<HonkStatusOption> get statusOptions; List<HonkParticipant> get participants; List<HonkParticipant> get pendingParticipants; String get currentUserId;
/// Create a copy of HonkActivityDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HonkActivityDetailsCopyWith<HonkActivityDetails> get copyWith => _$HonkActivityDetailsCopyWithImpl<HonkActivityDetails>(this as HonkActivityDetails, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HonkActivityDetails&&(identical(other.activity, activity) || other.activity == activity)&&const DeepCollectionEquality().equals(other.statusOptions, statusOptions)&&const DeepCollectionEquality().equals(other.participants, participants)&&const DeepCollectionEquality().equals(other.pendingParticipants, pendingParticipants)&&(identical(other.currentUserId, currentUserId) || other.currentUserId == currentUserId));
}


@override
int get hashCode => Object.hash(runtimeType,activity,const DeepCollectionEquality().hash(statusOptions),const DeepCollectionEquality().hash(participants),const DeepCollectionEquality().hash(pendingParticipants),currentUserId);

@override
String toString() {
  return 'HonkActivityDetails(activity: $activity, statusOptions: $statusOptions, participants: $participants, pendingParticipants: $pendingParticipants, currentUserId: $currentUserId)';
}


}

/// @nodoc
abstract mixin class $HonkActivityDetailsCopyWith<$Res>  {
  factory $HonkActivityDetailsCopyWith(HonkActivityDetails value, $Res Function(HonkActivityDetails) _then) = _$HonkActivityDetailsCopyWithImpl;
@useResult
$Res call({
 HonkActivity activity, List<HonkStatusOption> statusOptions, List<HonkParticipant> participants, List<HonkParticipant> pendingParticipants, String currentUserId
});


$HonkActivityCopyWith<$Res> get activity;

}
/// @nodoc
class _$HonkActivityDetailsCopyWithImpl<$Res>
    implements $HonkActivityDetailsCopyWith<$Res> {
  _$HonkActivityDetailsCopyWithImpl(this._self, this._then);

  final HonkActivityDetails _self;
  final $Res Function(HonkActivityDetails) _then;

/// Create a copy of HonkActivityDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activity = null,Object? statusOptions = null,Object? participants = null,Object? pendingParticipants = null,Object? currentUserId = null,}) {
  return _then(_self.copyWith(
activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as HonkActivity,statusOptions: null == statusOptions ? _self.statusOptions : statusOptions // ignore: cast_nullable_to_non_nullable
as List<HonkStatusOption>,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<HonkParticipant>,pendingParticipants: null == pendingParticipants ? _self.pendingParticipants : pendingParticipants // ignore: cast_nullable_to_non_nullable
as List<HonkParticipant>,currentUserId: null == currentUserId ? _self.currentUserId : currentUserId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of HonkActivityDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HonkActivityCopyWith<$Res> get activity {
  
  return $HonkActivityCopyWith<$Res>(_self.activity, (value) {
    return _then(_self.copyWith(activity: value));
  });
}
}


/// Adds pattern-matching-related methods to [HonkActivityDetails].
extension HonkActivityDetailsPatterns on HonkActivityDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HonkActivityDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HonkActivityDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HonkActivityDetails value)  $default,){
final _that = this;
switch (_that) {
case _HonkActivityDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HonkActivityDetails value)?  $default,){
final _that = this;
switch (_that) {
case _HonkActivityDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( HonkActivity activity,  List<HonkStatusOption> statusOptions,  List<HonkParticipant> participants,  List<HonkParticipant> pendingParticipants,  String currentUserId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HonkActivityDetails() when $default != null:
return $default(_that.activity,_that.statusOptions,_that.participants,_that.pendingParticipants,_that.currentUserId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( HonkActivity activity,  List<HonkStatusOption> statusOptions,  List<HonkParticipant> participants,  List<HonkParticipant> pendingParticipants,  String currentUserId)  $default,) {final _that = this;
switch (_that) {
case _HonkActivityDetails():
return $default(_that.activity,_that.statusOptions,_that.participants,_that.pendingParticipants,_that.currentUserId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( HonkActivity activity,  List<HonkStatusOption> statusOptions,  List<HonkParticipant> participants,  List<HonkParticipant> pendingParticipants,  String currentUserId)?  $default,) {final _that = this;
switch (_that) {
case _HonkActivityDetails() when $default != null:
return $default(_that.activity,_that.statusOptions,_that.participants,_that.pendingParticipants,_that.currentUserId);case _:
  return null;

}
}

}

/// @nodoc


class _HonkActivityDetails extends HonkActivityDetails {
  const _HonkActivityDetails({required this.activity, required final  List<HonkStatusOption> statusOptions, required final  List<HonkParticipant> participants, final  List<HonkParticipant> pendingParticipants = const <HonkParticipant>[], required this.currentUserId}): _statusOptions = statusOptions,_participants = participants,_pendingParticipants = pendingParticipants,super._();
  

@override final  HonkActivity activity;
 final  List<HonkStatusOption> _statusOptions;
@override List<HonkStatusOption> get statusOptions {
  if (_statusOptions is EqualUnmodifiableListView) return _statusOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_statusOptions);
}

 final  List<HonkParticipant> _participants;
@override List<HonkParticipant> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

 final  List<HonkParticipant> _pendingParticipants;
@override@JsonKey() List<HonkParticipant> get pendingParticipants {
  if (_pendingParticipants is EqualUnmodifiableListView) return _pendingParticipants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pendingParticipants);
}

@override final  String currentUserId;

/// Create a copy of HonkActivityDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HonkActivityDetailsCopyWith<_HonkActivityDetails> get copyWith => __$HonkActivityDetailsCopyWithImpl<_HonkActivityDetails>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HonkActivityDetails&&(identical(other.activity, activity) || other.activity == activity)&&const DeepCollectionEquality().equals(other._statusOptions, _statusOptions)&&const DeepCollectionEquality().equals(other._participants, _participants)&&const DeepCollectionEquality().equals(other._pendingParticipants, _pendingParticipants)&&(identical(other.currentUserId, currentUserId) || other.currentUserId == currentUserId));
}


@override
int get hashCode => Object.hash(runtimeType,activity,const DeepCollectionEquality().hash(_statusOptions),const DeepCollectionEquality().hash(_participants),const DeepCollectionEquality().hash(_pendingParticipants),currentUserId);

@override
String toString() {
  return 'HonkActivityDetails(activity: $activity, statusOptions: $statusOptions, participants: $participants, pendingParticipants: $pendingParticipants, currentUserId: $currentUserId)';
}


}

/// @nodoc
abstract mixin class _$HonkActivityDetailsCopyWith<$Res> implements $HonkActivityDetailsCopyWith<$Res> {
  factory _$HonkActivityDetailsCopyWith(_HonkActivityDetails value, $Res Function(_HonkActivityDetails) _then) = __$HonkActivityDetailsCopyWithImpl;
@override @useResult
$Res call({
 HonkActivity activity, List<HonkStatusOption> statusOptions, List<HonkParticipant> participants, List<HonkParticipant> pendingParticipants, String currentUserId
});


@override $HonkActivityCopyWith<$Res> get activity;

}
/// @nodoc
class __$HonkActivityDetailsCopyWithImpl<$Res>
    implements _$HonkActivityDetailsCopyWith<$Res> {
  __$HonkActivityDetailsCopyWithImpl(this._self, this._then);

  final _HonkActivityDetails _self;
  final $Res Function(_HonkActivityDetails) _then;

/// Create a copy of HonkActivityDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activity = null,Object? statusOptions = null,Object? participants = null,Object? pendingParticipants = null,Object? currentUserId = null,}) {
  return _then(_HonkActivityDetails(
activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as HonkActivity,statusOptions: null == statusOptions ? _self._statusOptions : statusOptions // ignore: cast_nullable_to_non_nullable
as List<HonkStatusOption>,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<HonkParticipant>,pendingParticipants: null == pendingParticipants ? _self._pendingParticipants : pendingParticipants // ignore: cast_nullable_to_non_nullable
as List<HonkParticipant>,currentUserId: null == currentUserId ? _self.currentUserId : currentUserId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of HonkActivityDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HonkActivityCopyWith<$Res> get activity {
  
  return $HonkActivityCopyWith<$Res>(_self.activity, (value) {
    return _then(_self.copyWith(activity: value));
  });
}
}

// dart format on
