// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_management_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FriendManagementState {

 bool get isLoading; List<Profile> get friends; List<Profile> get searchResults; String get searchQuery; MainFailure? get failure;
/// Create a copy of FriendManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FriendManagementStateCopyWith<FriendManagementState> get copyWith => _$FriendManagementStateCopyWithImpl<FriendManagementState>(this as FriendManagementState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FriendManagementState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.friends, friends)&&const DeepCollectionEquality().equals(other.searchResults, searchResults)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(friends),const DeepCollectionEquality().hash(searchResults),searchQuery,failure);

@override
String toString() {
  return 'FriendManagementState(isLoading: $isLoading, friends: $friends, searchResults: $searchResults, searchQuery: $searchQuery, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $FriendManagementStateCopyWith<$Res>  {
  factory $FriendManagementStateCopyWith(FriendManagementState value, $Res Function(FriendManagementState) _then) = _$FriendManagementStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<Profile> friends, List<Profile> searchResults, String searchQuery, MainFailure? failure
});


$MainFailureCopyWith<$Res>? get failure;

}
/// @nodoc
class _$FriendManagementStateCopyWithImpl<$Res>
    implements $FriendManagementStateCopyWith<$Res> {
  _$FriendManagementStateCopyWithImpl(this._self, this._then);

  final FriendManagementState _self;
  final $Res Function(FriendManagementState) _then;

/// Create a copy of FriendManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? friends = null,Object? searchResults = null,Object? searchQuery = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,friends: null == friends ? _self.friends : friends // ignore: cast_nullable_to_non_nullable
as List<Profile>,searchResults: null == searchResults ? _self.searchResults : searchResults // ignore: cast_nullable_to_non_nullable
as List<Profile>,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as MainFailure?,
  ));
}
/// Create a copy of FriendManagementState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MainFailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $MainFailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}


/// Adds pattern-matching-related methods to [FriendManagementState].
extension FriendManagementStatePatterns on FriendManagementState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FriendManagementState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FriendManagementState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FriendManagementState value)  $default,){
final _that = this;
switch (_that) {
case _FriendManagementState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FriendManagementState value)?  $default,){
final _that = this;
switch (_that) {
case _FriendManagementState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<Profile> friends,  List<Profile> searchResults,  String searchQuery,  MainFailure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FriendManagementState() when $default != null:
return $default(_that.isLoading,_that.friends,_that.searchResults,_that.searchQuery,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<Profile> friends,  List<Profile> searchResults,  String searchQuery,  MainFailure? failure)  $default,) {final _that = this;
switch (_that) {
case _FriendManagementState():
return $default(_that.isLoading,_that.friends,_that.searchResults,_that.searchQuery,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<Profile> friends,  List<Profile> searchResults,  String searchQuery,  MainFailure? failure)?  $default,) {final _that = this;
switch (_that) {
case _FriendManagementState() when $default != null:
return $default(_that.isLoading,_that.friends,_that.searchResults,_that.searchQuery,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _FriendManagementState implements FriendManagementState {
  const _FriendManagementState({this.isLoading = false, final  List<Profile> friends = const <Profile>[], final  List<Profile> searchResults = const <Profile>[], this.searchQuery = '', this.failure}): _friends = friends,_searchResults = searchResults;
  

@override@JsonKey() final  bool isLoading;
 final  List<Profile> _friends;
@override@JsonKey() List<Profile> get friends {
  if (_friends is EqualUnmodifiableListView) return _friends;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_friends);
}

 final  List<Profile> _searchResults;
@override@JsonKey() List<Profile> get searchResults {
  if (_searchResults is EqualUnmodifiableListView) return _searchResults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_searchResults);
}

@override@JsonKey() final  String searchQuery;
@override final  MainFailure? failure;

/// Create a copy of FriendManagementState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FriendManagementStateCopyWith<_FriendManagementState> get copyWith => __$FriendManagementStateCopyWithImpl<_FriendManagementState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FriendManagementState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._friends, _friends)&&const DeepCollectionEquality().equals(other._searchResults, _searchResults)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_friends),const DeepCollectionEquality().hash(_searchResults),searchQuery,failure);

@override
String toString() {
  return 'FriendManagementState(isLoading: $isLoading, friends: $friends, searchResults: $searchResults, searchQuery: $searchQuery, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$FriendManagementStateCopyWith<$Res> implements $FriendManagementStateCopyWith<$Res> {
  factory _$FriendManagementStateCopyWith(_FriendManagementState value, $Res Function(_FriendManagementState) _then) = __$FriendManagementStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<Profile> friends, List<Profile> searchResults, String searchQuery, MainFailure? failure
});


@override $MainFailureCopyWith<$Res>? get failure;

}
/// @nodoc
class __$FriendManagementStateCopyWithImpl<$Res>
    implements _$FriendManagementStateCopyWith<$Res> {
  __$FriendManagementStateCopyWithImpl(this._self, this._then);

  final _FriendManagementState _self;
  final $Res Function(_FriendManagementState) _then;

/// Create a copy of FriendManagementState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? friends = null,Object? searchResults = null,Object? searchQuery = null,Object? failure = freezed,}) {
  return _then(_FriendManagementState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,friends: null == friends ? _self._friends : friends // ignore: cast_nullable_to_non_nullable
as List<Profile>,searchResults: null == searchResults ? _self._searchResults : searchResults // ignore: cast_nullable_to_non_nullable
as List<Profile>,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as MainFailure?,
  ));
}

/// Create a copy of FriendManagementState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MainFailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $MainFailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
