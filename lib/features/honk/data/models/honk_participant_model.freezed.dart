// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'honk_participant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HonkParticipantModel {

 String get userId; String get username; String? get fullName; String? get profileUrl; String get role; String get effectiveStatusKey; String get joinStatus; DateTime? get statusUpdatedAt; DateTime? get statusExpiresAt;
/// Create a copy of HonkParticipantModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HonkParticipantModelCopyWith<HonkParticipantModel> get copyWith => _$HonkParticipantModelCopyWithImpl<HonkParticipantModel>(this as HonkParticipantModel, _$identity);

  /// Serializes this HonkParticipantModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HonkParticipantModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.profileUrl, profileUrl) || other.profileUrl == profileUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.effectiveStatusKey, effectiveStatusKey) || other.effectiveStatusKey == effectiveStatusKey)&&(identical(other.joinStatus, joinStatus) || other.joinStatus == joinStatus)&&(identical(other.statusUpdatedAt, statusUpdatedAt) || other.statusUpdatedAt == statusUpdatedAt)&&(identical(other.statusExpiresAt, statusExpiresAt) || other.statusExpiresAt == statusExpiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,username,fullName,profileUrl,role,effectiveStatusKey,joinStatus,statusUpdatedAt,statusExpiresAt);

@override
String toString() {
  return 'HonkParticipantModel(userId: $userId, username: $username, fullName: $fullName, profileUrl: $profileUrl, role: $role, effectiveStatusKey: $effectiveStatusKey, joinStatus: $joinStatus, statusUpdatedAt: $statusUpdatedAt, statusExpiresAt: $statusExpiresAt)';
}


}

/// @nodoc
abstract mixin class $HonkParticipantModelCopyWith<$Res>  {
  factory $HonkParticipantModelCopyWith(HonkParticipantModel value, $Res Function(HonkParticipantModel) _then) = _$HonkParticipantModelCopyWithImpl;
@useResult
$Res call({
 String userId, String username, String? fullName, String? profileUrl, String role, String effectiveStatusKey, String joinStatus, DateTime? statusUpdatedAt, DateTime? statusExpiresAt
});




}
/// @nodoc
class _$HonkParticipantModelCopyWithImpl<$Res>
    implements $HonkParticipantModelCopyWith<$Res> {
  _$HonkParticipantModelCopyWithImpl(this._self, this._then);

  final HonkParticipantModel _self;
  final $Res Function(HonkParticipantModel) _then;

/// Create a copy of HonkParticipantModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? username = null,Object? fullName = freezed,Object? profileUrl = freezed,Object? role = null,Object? effectiveStatusKey = null,Object? joinStatus = null,Object? statusUpdatedAt = freezed,Object? statusExpiresAt = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,profileUrl: freezed == profileUrl ? _self.profileUrl : profileUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,effectiveStatusKey: null == effectiveStatusKey ? _self.effectiveStatusKey : effectiveStatusKey // ignore: cast_nullable_to_non_nullable
as String,joinStatus: null == joinStatus ? _self.joinStatus : joinStatus // ignore: cast_nullable_to_non_nullable
as String,statusUpdatedAt: freezed == statusUpdatedAt ? _self.statusUpdatedAt : statusUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,statusExpiresAt: freezed == statusExpiresAt ? _self.statusExpiresAt : statusExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [HonkParticipantModel].
extension HonkParticipantModelPatterns on HonkParticipantModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HonkParticipantModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HonkParticipantModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HonkParticipantModel value)  $default,){
final _that = this;
switch (_that) {
case _HonkParticipantModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HonkParticipantModel value)?  $default,){
final _that = this;
switch (_that) {
case _HonkParticipantModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String username,  String? fullName,  String? profileUrl,  String role,  String effectiveStatusKey,  String joinStatus,  DateTime? statusUpdatedAt,  DateTime? statusExpiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HonkParticipantModel() when $default != null:
return $default(_that.userId,_that.username,_that.fullName,_that.profileUrl,_that.role,_that.effectiveStatusKey,_that.joinStatus,_that.statusUpdatedAt,_that.statusExpiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String username,  String? fullName,  String? profileUrl,  String role,  String effectiveStatusKey,  String joinStatus,  DateTime? statusUpdatedAt,  DateTime? statusExpiresAt)  $default,) {final _that = this;
switch (_that) {
case _HonkParticipantModel():
return $default(_that.userId,_that.username,_that.fullName,_that.profileUrl,_that.role,_that.effectiveStatusKey,_that.joinStatus,_that.statusUpdatedAt,_that.statusExpiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String username,  String? fullName,  String? profileUrl,  String role,  String effectiveStatusKey,  String joinStatus,  DateTime? statusUpdatedAt,  DateTime? statusExpiresAt)?  $default,) {final _that = this;
switch (_that) {
case _HonkParticipantModel() when $default != null:
return $default(_that.userId,_that.username,_that.fullName,_that.profileUrl,_that.role,_that.effectiveStatusKey,_that.joinStatus,_that.statusUpdatedAt,_that.statusExpiresAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _HonkParticipantModel extends HonkParticipantModel {
  const _HonkParticipantModel({required this.userId, required this.username, this.fullName, this.profileUrl, this.role = 'participant', this.effectiveStatusKey = '', this.joinStatus = 'active', this.statusUpdatedAt, this.statusExpiresAt}): super._();
  factory _HonkParticipantModel.fromJson(Map<String, dynamic> json) => _$HonkParticipantModelFromJson(json);

@override final  String userId;
@override final  String username;
@override final  String? fullName;
@override final  String? profileUrl;
@override@JsonKey() final  String role;
@override@JsonKey() final  String effectiveStatusKey;
@override@JsonKey() final  String joinStatus;
@override final  DateTime? statusUpdatedAt;
@override final  DateTime? statusExpiresAt;

/// Create a copy of HonkParticipantModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HonkParticipantModelCopyWith<_HonkParticipantModel> get copyWith => __$HonkParticipantModelCopyWithImpl<_HonkParticipantModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HonkParticipantModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HonkParticipantModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.profileUrl, profileUrl) || other.profileUrl == profileUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.effectiveStatusKey, effectiveStatusKey) || other.effectiveStatusKey == effectiveStatusKey)&&(identical(other.joinStatus, joinStatus) || other.joinStatus == joinStatus)&&(identical(other.statusUpdatedAt, statusUpdatedAt) || other.statusUpdatedAt == statusUpdatedAt)&&(identical(other.statusExpiresAt, statusExpiresAt) || other.statusExpiresAt == statusExpiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,username,fullName,profileUrl,role,effectiveStatusKey,joinStatus,statusUpdatedAt,statusExpiresAt);

@override
String toString() {
  return 'HonkParticipantModel(userId: $userId, username: $username, fullName: $fullName, profileUrl: $profileUrl, role: $role, effectiveStatusKey: $effectiveStatusKey, joinStatus: $joinStatus, statusUpdatedAt: $statusUpdatedAt, statusExpiresAt: $statusExpiresAt)';
}


}

/// @nodoc
abstract mixin class _$HonkParticipantModelCopyWith<$Res> implements $HonkParticipantModelCopyWith<$Res> {
  factory _$HonkParticipantModelCopyWith(_HonkParticipantModel value, $Res Function(_HonkParticipantModel) _then) = __$HonkParticipantModelCopyWithImpl;
@override @useResult
$Res call({
 String userId, String username, String? fullName, String? profileUrl, String role, String effectiveStatusKey, String joinStatus, DateTime? statusUpdatedAt, DateTime? statusExpiresAt
});




}
/// @nodoc
class __$HonkParticipantModelCopyWithImpl<$Res>
    implements _$HonkParticipantModelCopyWith<$Res> {
  __$HonkParticipantModelCopyWithImpl(this._self, this._then);

  final _HonkParticipantModel _self;
  final $Res Function(_HonkParticipantModel) _then;

/// Create a copy of HonkParticipantModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? username = null,Object? fullName = freezed,Object? profileUrl = freezed,Object? role = null,Object? effectiveStatusKey = null,Object? joinStatus = null,Object? statusUpdatedAt = freezed,Object? statusExpiresAt = freezed,}) {
  return _then(_HonkParticipantModel(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,profileUrl: freezed == profileUrl ? _self.profileUrl : profileUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,effectiveStatusKey: null == effectiveStatusKey ? _self.effectiveStatusKey : effectiveStatusKey // ignore: cast_nullable_to_non_nullable
as String,joinStatus: null == joinStatus ? _self.joinStatus : joinStatus // ignore: cast_nullable_to_non_nullable
as String,statusUpdatedAt: freezed == statusUpdatedAt ? _self.statusUpdatedAt : statusUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,statusExpiresAt: freezed == statusExpiresAt ? _self.statusExpiresAt : statusExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
