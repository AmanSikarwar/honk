// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthFailure {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthFailure()';
}


}

/// @nodoc
class $AuthFailureCopyWith<$Res>  {
$AuthFailureCopyWith(AuthFailure _, $Res Function(AuthFailure) __);
}


/// Adds pattern-matching-related methods to [AuthFailure].
extension AuthFailurePatterns on AuthFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ServerError value)?  serverError,TResult Function( EmailAlreadyInUse value)?  emailAlreadyInUse,TResult Function( InvalidEmailAndPasswordCombination value)?  invalidEmailAndPasswordCombination,TResult Function( WeakPassword value)?  weakPassword,TResult Function( UserNotFound value)?  userNotFound,TResult Function( EmailNotVerified value)?  emailNotVerified,TResult Function( TooManyRequests value)?  tooManyRequests,TResult Function( NetworkError value)?  networkError,TResult Function( CancelledByUser value)?  cancelledByUser,TResult Function( Unknown value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ServerError() when serverError != null:
return serverError(_that);case EmailAlreadyInUse() when emailAlreadyInUse != null:
return emailAlreadyInUse(_that);case InvalidEmailAndPasswordCombination() when invalidEmailAndPasswordCombination != null:
return invalidEmailAndPasswordCombination(_that);case WeakPassword() when weakPassword != null:
return weakPassword(_that);case UserNotFound() when userNotFound != null:
return userNotFound(_that);case EmailNotVerified() when emailNotVerified != null:
return emailNotVerified(_that);case TooManyRequests() when tooManyRequests != null:
return tooManyRequests(_that);case NetworkError() when networkError != null:
return networkError(_that);case CancelledByUser() when cancelledByUser != null:
return cancelledByUser(_that);case Unknown() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ServerError value)  serverError,required TResult Function( EmailAlreadyInUse value)  emailAlreadyInUse,required TResult Function( InvalidEmailAndPasswordCombination value)  invalidEmailAndPasswordCombination,required TResult Function( WeakPassword value)  weakPassword,required TResult Function( UserNotFound value)  userNotFound,required TResult Function( EmailNotVerified value)  emailNotVerified,required TResult Function( TooManyRequests value)  tooManyRequests,required TResult Function( NetworkError value)  networkError,required TResult Function( CancelledByUser value)  cancelledByUser,required TResult Function( Unknown value)  unknown,}){
final _that = this;
switch (_that) {
case ServerError():
return serverError(_that);case EmailAlreadyInUse():
return emailAlreadyInUse(_that);case InvalidEmailAndPasswordCombination():
return invalidEmailAndPasswordCombination(_that);case WeakPassword():
return weakPassword(_that);case UserNotFound():
return userNotFound(_that);case EmailNotVerified():
return emailNotVerified(_that);case TooManyRequests():
return tooManyRequests(_that);case NetworkError():
return networkError(_that);case CancelledByUser():
return cancelledByUser(_that);case Unknown():
return unknown(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ServerError value)?  serverError,TResult? Function( EmailAlreadyInUse value)?  emailAlreadyInUse,TResult? Function( InvalidEmailAndPasswordCombination value)?  invalidEmailAndPasswordCombination,TResult? Function( WeakPassword value)?  weakPassword,TResult? Function( UserNotFound value)?  userNotFound,TResult? Function( EmailNotVerified value)?  emailNotVerified,TResult? Function( TooManyRequests value)?  tooManyRequests,TResult? Function( NetworkError value)?  networkError,TResult? Function( CancelledByUser value)?  cancelledByUser,TResult? Function( Unknown value)?  unknown,}){
final _that = this;
switch (_that) {
case ServerError() when serverError != null:
return serverError(_that);case EmailAlreadyInUse() when emailAlreadyInUse != null:
return emailAlreadyInUse(_that);case InvalidEmailAndPasswordCombination() when invalidEmailAndPasswordCombination != null:
return invalidEmailAndPasswordCombination(_that);case WeakPassword() when weakPassword != null:
return weakPassword(_that);case UserNotFound() when userNotFound != null:
return userNotFound(_that);case EmailNotVerified() when emailNotVerified != null:
return emailNotVerified(_that);case TooManyRequests() when tooManyRequests != null:
return tooManyRequests(_that);case NetworkError() when networkError != null:
return networkError(_that);case CancelledByUser() when cancelledByUser != null:
return cancelledByUser(_that);case Unknown() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message)?  serverError,TResult Function()?  emailAlreadyInUse,TResult Function()?  invalidEmailAndPasswordCombination,TResult Function()?  weakPassword,TResult Function()?  userNotFound,TResult Function()?  emailNotVerified,TResult Function()?  tooManyRequests,TResult Function()?  networkError,TResult Function()?  cancelledByUser,TResult Function( String message)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ServerError() when serverError != null:
return serverError(_that.message);case EmailAlreadyInUse() when emailAlreadyInUse != null:
return emailAlreadyInUse();case InvalidEmailAndPasswordCombination() when invalidEmailAndPasswordCombination != null:
return invalidEmailAndPasswordCombination();case WeakPassword() when weakPassword != null:
return weakPassword();case UserNotFound() when userNotFound != null:
return userNotFound();case EmailNotVerified() when emailNotVerified != null:
return emailNotVerified();case TooManyRequests() when tooManyRequests != null:
return tooManyRequests();case NetworkError() when networkError != null:
return networkError();case CancelledByUser() when cancelledByUser != null:
return cancelledByUser();case Unknown() when unknown != null:
return unknown(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message)  serverError,required TResult Function()  emailAlreadyInUse,required TResult Function()  invalidEmailAndPasswordCombination,required TResult Function()  weakPassword,required TResult Function()  userNotFound,required TResult Function()  emailNotVerified,required TResult Function()  tooManyRequests,required TResult Function()  networkError,required TResult Function()  cancelledByUser,required TResult Function( String message)  unknown,}) {final _that = this;
switch (_that) {
case ServerError():
return serverError(_that.message);case EmailAlreadyInUse():
return emailAlreadyInUse();case InvalidEmailAndPasswordCombination():
return invalidEmailAndPasswordCombination();case WeakPassword():
return weakPassword();case UserNotFound():
return userNotFound();case EmailNotVerified():
return emailNotVerified();case TooManyRequests():
return tooManyRequests();case NetworkError():
return networkError();case CancelledByUser():
return cancelledByUser();case Unknown():
return unknown(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message)?  serverError,TResult? Function()?  emailAlreadyInUse,TResult? Function()?  invalidEmailAndPasswordCombination,TResult? Function()?  weakPassword,TResult? Function()?  userNotFound,TResult? Function()?  emailNotVerified,TResult? Function()?  tooManyRequests,TResult? Function()?  networkError,TResult? Function()?  cancelledByUser,TResult? Function( String message)?  unknown,}) {final _that = this;
switch (_that) {
case ServerError() when serverError != null:
return serverError(_that.message);case EmailAlreadyInUse() when emailAlreadyInUse != null:
return emailAlreadyInUse();case InvalidEmailAndPasswordCombination() when invalidEmailAndPasswordCombination != null:
return invalidEmailAndPasswordCombination();case WeakPassword() when weakPassword != null:
return weakPassword();case UserNotFound() when userNotFound != null:
return userNotFound();case EmailNotVerified() when emailNotVerified != null:
return emailNotVerified();case TooManyRequests() when tooManyRequests != null:
return tooManyRequests();case NetworkError() when networkError != null:
return networkError();case CancelledByUser() when cancelledByUser != null:
return cancelledByUser();case Unknown() when unknown != null:
return unknown(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ServerError implements AuthFailure {
  const ServerError(this.message);
  

 final  String message;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerErrorCopyWith<ServerError> get copyWith => _$ServerErrorCopyWithImpl<ServerError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthFailure.serverError(message: $message)';
}


}

/// @nodoc
abstract mixin class $ServerErrorCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory $ServerErrorCopyWith(ServerError value, $Res Function(ServerError) _then) = _$ServerErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ServerErrorCopyWithImpl<$Res>
    implements $ServerErrorCopyWith<$Res> {
  _$ServerErrorCopyWithImpl(this._self, this._then);

  final ServerError _self;
  final $Res Function(ServerError) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ServerError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class EmailAlreadyInUse implements AuthFailure {
  const EmailAlreadyInUse();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmailAlreadyInUse);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthFailure.emailAlreadyInUse()';
}


}




/// @nodoc


class InvalidEmailAndPasswordCombination implements AuthFailure {
  const InvalidEmailAndPasswordCombination();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvalidEmailAndPasswordCombination);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthFailure.invalidEmailAndPasswordCombination()';
}


}




/// @nodoc


class WeakPassword implements AuthFailure {
  const WeakPassword();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeakPassword);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthFailure.weakPassword()';
}


}




/// @nodoc


class UserNotFound implements AuthFailure {
  const UserNotFound();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserNotFound);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthFailure.userNotFound()';
}


}




/// @nodoc


class EmailNotVerified implements AuthFailure {
  const EmailNotVerified();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmailNotVerified);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthFailure.emailNotVerified()';
}


}




/// @nodoc


class TooManyRequests implements AuthFailure {
  const TooManyRequests();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TooManyRequests);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthFailure.tooManyRequests()';
}


}




/// @nodoc


class NetworkError implements AuthFailure {
  const NetworkError();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthFailure.networkError()';
}


}




/// @nodoc


class CancelledByUser implements AuthFailure {
  const CancelledByUser();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CancelledByUser);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthFailure.cancelledByUser()';
}


}




/// @nodoc


class Unknown implements AuthFailure {
  const Unknown(this.message);
  

 final  String message;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnknownCopyWith<Unknown> get copyWith => _$UnknownCopyWithImpl<Unknown>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Unknown&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthFailure.unknown(message: $message)';
}


}

/// @nodoc
abstract mixin class $UnknownCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory $UnknownCopyWith(Unknown value, $Res Function(Unknown) _then) = _$UnknownCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$UnknownCopyWithImpl<$Res>
    implements $UnknownCopyWith<$Res> {
  _$UnknownCopyWithImpl(this._self, this._then);

  final Unknown _self;
  final $Res Function(Unknown) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(Unknown(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
