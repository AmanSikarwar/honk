// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent()';
}


}

/// @nodoc
class $AuthEventCopyWith<$Res>  {
$AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}


/// Adds pattern-matching-related methods to [AuthEvent].
extension AuthEventPatterns on AuthEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CheckAuthStatus value)?  checkAuthStatus,TResult Function( SignUpWithEmailAndPassword value)?  signUpWithEmailAndPassword,TResult Function( SignInWithEmailAndPassword value)?  signInWithEmailAndPassword,TResult Function( SignInWithGoogle value)?  signInWithGoogle,TResult Function( SignOut value)?  signOut,TResult Function( SendPasswordResetEmail value)?  sendPasswordResetEmail,TResult Function( UpdatePassword value)?  updatePassword,TResult Function( ResendVerificationEmail value)?  resendVerificationEmail,TResult Function( VerifyOtp value)?  verifyOtp,TResult Function( HandleDeepLinkTokenHash value)?  handleDeepLinkTokenHash,TResult Function( HandleDeepLinkSession value)?  handleDeepLinkSession,TResult Function( AuthStateChanged value)?  authStateChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CheckAuthStatus() when checkAuthStatus != null:
return checkAuthStatus(_that);case SignUpWithEmailAndPassword() when signUpWithEmailAndPassword != null:
return signUpWithEmailAndPassword(_that);case SignInWithEmailAndPassword() when signInWithEmailAndPassword != null:
return signInWithEmailAndPassword(_that);case SignInWithGoogle() when signInWithGoogle != null:
return signInWithGoogle(_that);case SignOut() when signOut != null:
return signOut(_that);case SendPasswordResetEmail() when sendPasswordResetEmail != null:
return sendPasswordResetEmail(_that);case UpdatePassword() when updatePassword != null:
return updatePassword(_that);case ResendVerificationEmail() when resendVerificationEmail != null:
return resendVerificationEmail(_that);case VerifyOtp() when verifyOtp != null:
return verifyOtp(_that);case HandleDeepLinkTokenHash() when handleDeepLinkTokenHash != null:
return handleDeepLinkTokenHash(_that);case HandleDeepLinkSession() when handleDeepLinkSession != null:
return handleDeepLinkSession(_that);case AuthStateChanged() when authStateChanged != null:
return authStateChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CheckAuthStatus value)  checkAuthStatus,required TResult Function( SignUpWithEmailAndPassword value)  signUpWithEmailAndPassword,required TResult Function( SignInWithEmailAndPassword value)  signInWithEmailAndPassword,required TResult Function( SignInWithGoogle value)  signInWithGoogle,required TResult Function( SignOut value)  signOut,required TResult Function( SendPasswordResetEmail value)  sendPasswordResetEmail,required TResult Function( UpdatePassword value)  updatePassword,required TResult Function( ResendVerificationEmail value)  resendVerificationEmail,required TResult Function( VerifyOtp value)  verifyOtp,required TResult Function( HandleDeepLinkTokenHash value)  handleDeepLinkTokenHash,required TResult Function( HandleDeepLinkSession value)  handleDeepLinkSession,required TResult Function( AuthStateChanged value)  authStateChanged,}){
final _that = this;
switch (_that) {
case CheckAuthStatus():
return checkAuthStatus(_that);case SignUpWithEmailAndPassword():
return signUpWithEmailAndPassword(_that);case SignInWithEmailAndPassword():
return signInWithEmailAndPassword(_that);case SignInWithGoogle():
return signInWithGoogle(_that);case SignOut():
return signOut(_that);case SendPasswordResetEmail():
return sendPasswordResetEmail(_that);case UpdatePassword():
return updatePassword(_that);case ResendVerificationEmail():
return resendVerificationEmail(_that);case VerifyOtp():
return verifyOtp(_that);case HandleDeepLinkTokenHash():
return handleDeepLinkTokenHash(_that);case HandleDeepLinkSession():
return handleDeepLinkSession(_that);case AuthStateChanged():
return authStateChanged(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CheckAuthStatus value)?  checkAuthStatus,TResult? Function( SignUpWithEmailAndPassword value)?  signUpWithEmailAndPassword,TResult? Function( SignInWithEmailAndPassword value)?  signInWithEmailAndPassword,TResult? Function( SignInWithGoogle value)?  signInWithGoogle,TResult? Function( SignOut value)?  signOut,TResult? Function( SendPasswordResetEmail value)?  sendPasswordResetEmail,TResult? Function( UpdatePassword value)?  updatePassword,TResult? Function( ResendVerificationEmail value)?  resendVerificationEmail,TResult? Function( VerifyOtp value)?  verifyOtp,TResult? Function( HandleDeepLinkTokenHash value)?  handleDeepLinkTokenHash,TResult? Function( HandleDeepLinkSession value)?  handleDeepLinkSession,TResult? Function( AuthStateChanged value)?  authStateChanged,}){
final _that = this;
switch (_that) {
case CheckAuthStatus() when checkAuthStatus != null:
return checkAuthStatus(_that);case SignUpWithEmailAndPassword() when signUpWithEmailAndPassword != null:
return signUpWithEmailAndPassword(_that);case SignInWithEmailAndPassword() when signInWithEmailAndPassword != null:
return signInWithEmailAndPassword(_that);case SignInWithGoogle() when signInWithGoogle != null:
return signInWithGoogle(_that);case SignOut() when signOut != null:
return signOut(_that);case SendPasswordResetEmail() when sendPasswordResetEmail != null:
return sendPasswordResetEmail(_that);case UpdatePassword() when updatePassword != null:
return updatePassword(_that);case ResendVerificationEmail() when resendVerificationEmail != null:
return resendVerificationEmail(_that);case VerifyOtp() when verifyOtp != null:
return verifyOtp(_that);case HandleDeepLinkTokenHash() when handleDeepLinkTokenHash != null:
return handleDeepLinkTokenHash(_that);case HandleDeepLinkSession() when handleDeepLinkSession != null:
return handleDeepLinkSession(_that);case AuthStateChanged() when authStateChanged != null:
return authStateChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  checkAuthStatus,TResult Function( String email,  String password)?  signUpWithEmailAndPassword,TResult Function( String email,  String password)?  signInWithEmailAndPassword,TResult Function()?  signInWithGoogle,TResult Function()?  signOut,TResult Function( String email)?  sendPasswordResetEmail,TResult Function( String newPassword)?  updatePassword,TResult Function( String email)?  resendVerificationEmail,TResult Function( String email,  String token,  String type)?  verifyOtp,TResult Function( String tokenHash,  String type)?  handleDeepLinkTokenHash,TResult Function( String accessToken,  String refreshToken,  String? type)?  handleDeepLinkSession,TResult Function( AppUser? user,  String eventType)?  authStateChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CheckAuthStatus() when checkAuthStatus != null:
return checkAuthStatus();case SignUpWithEmailAndPassword() when signUpWithEmailAndPassword != null:
return signUpWithEmailAndPassword(_that.email,_that.password);case SignInWithEmailAndPassword() when signInWithEmailAndPassword != null:
return signInWithEmailAndPassword(_that.email,_that.password);case SignInWithGoogle() when signInWithGoogle != null:
return signInWithGoogle();case SignOut() when signOut != null:
return signOut();case SendPasswordResetEmail() when sendPasswordResetEmail != null:
return sendPasswordResetEmail(_that.email);case UpdatePassword() when updatePassword != null:
return updatePassword(_that.newPassword);case ResendVerificationEmail() when resendVerificationEmail != null:
return resendVerificationEmail(_that.email);case VerifyOtp() when verifyOtp != null:
return verifyOtp(_that.email,_that.token,_that.type);case HandleDeepLinkTokenHash() when handleDeepLinkTokenHash != null:
return handleDeepLinkTokenHash(_that.tokenHash,_that.type);case HandleDeepLinkSession() when handleDeepLinkSession != null:
return handleDeepLinkSession(_that.accessToken,_that.refreshToken,_that.type);case AuthStateChanged() when authStateChanged != null:
return authStateChanged(_that.user,_that.eventType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  checkAuthStatus,required TResult Function( String email,  String password)  signUpWithEmailAndPassword,required TResult Function( String email,  String password)  signInWithEmailAndPassword,required TResult Function()  signInWithGoogle,required TResult Function()  signOut,required TResult Function( String email)  sendPasswordResetEmail,required TResult Function( String newPassword)  updatePassword,required TResult Function( String email)  resendVerificationEmail,required TResult Function( String email,  String token,  String type)  verifyOtp,required TResult Function( String tokenHash,  String type)  handleDeepLinkTokenHash,required TResult Function( String accessToken,  String refreshToken,  String? type)  handleDeepLinkSession,required TResult Function( AppUser? user,  String eventType)  authStateChanged,}) {final _that = this;
switch (_that) {
case CheckAuthStatus():
return checkAuthStatus();case SignUpWithEmailAndPassword():
return signUpWithEmailAndPassword(_that.email,_that.password);case SignInWithEmailAndPassword():
return signInWithEmailAndPassword(_that.email,_that.password);case SignInWithGoogle():
return signInWithGoogle();case SignOut():
return signOut();case SendPasswordResetEmail():
return sendPasswordResetEmail(_that.email);case UpdatePassword():
return updatePassword(_that.newPassword);case ResendVerificationEmail():
return resendVerificationEmail(_that.email);case VerifyOtp():
return verifyOtp(_that.email,_that.token,_that.type);case HandleDeepLinkTokenHash():
return handleDeepLinkTokenHash(_that.tokenHash,_that.type);case HandleDeepLinkSession():
return handleDeepLinkSession(_that.accessToken,_that.refreshToken,_that.type);case AuthStateChanged():
return authStateChanged(_that.user,_that.eventType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  checkAuthStatus,TResult? Function( String email,  String password)?  signUpWithEmailAndPassword,TResult? Function( String email,  String password)?  signInWithEmailAndPassword,TResult? Function()?  signInWithGoogle,TResult? Function()?  signOut,TResult? Function( String email)?  sendPasswordResetEmail,TResult? Function( String newPassword)?  updatePassword,TResult? Function( String email)?  resendVerificationEmail,TResult? Function( String email,  String token,  String type)?  verifyOtp,TResult? Function( String tokenHash,  String type)?  handleDeepLinkTokenHash,TResult? Function( String accessToken,  String refreshToken,  String? type)?  handleDeepLinkSession,TResult? Function( AppUser? user,  String eventType)?  authStateChanged,}) {final _that = this;
switch (_that) {
case CheckAuthStatus() when checkAuthStatus != null:
return checkAuthStatus();case SignUpWithEmailAndPassword() when signUpWithEmailAndPassword != null:
return signUpWithEmailAndPassword(_that.email,_that.password);case SignInWithEmailAndPassword() when signInWithEmailAndPassword != null:
return signInWithEmailAndPassword(_that.email,_that.password);case SignInWithGoogle() when signInWithGoogle != null:
return signInWithGoogle();case SignOut() when signOut != null:
return signOut();case SendPasswordResetEmail() when sendPasswordResetEmail != null:
return sendPasswordResetEmail(_that.email);case UpdatePassword() when updatePassword != null:
return updatePassword(_that.newPassword);case ResendVerificationEmail() when resendVerificationEmail != null:
return resendVerificationEmail(_that.email);case VerifyOtp() when verifyOtp != null:
return verifyOtp(_that.email,_that.token,_that.type);case HandleDeepLinkTokenHash() when handleDeepLinkTokenHash != null:
return handleDeepLinkTokenHash(_that.tokenHash,_that.type);case HandleDeepLinkSession() when handleDeepLinkSession != null:
return handleDeepLinkSession(_that.accessToken,_that.refreshToken,_that.type);case AuthStateChanged() when authStateChanged != null:
return authStateChanged(_that.user,_that.eventType);case _:
  return null;

}
}

}

/// @nodoc


class CheckAuthStatus implements AuthEvent {
  const CheckAuthStatus();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckAuthStatus);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.checkAuthStatus()';
}


}




/// @nodoc


class SignUpWithEmailAndPassword implements AuthEvent {
  const SignUpWithEmailAndPassword({required this.email, required this.password});
  

 final  String email;
 final  String password;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignUpWithEmailAndPasswordCopyWith<SignUpWithEmailAndPassword> get copyWith => _$SignUpWithEmailAndPasswordCopyWithImpl<SignUpWithEmailAndPassword>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignUpWithEmailAndPassword&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString() {
  return 'AuthEvent.signUpWithEmailAndPassword(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class $SignUpWithEmailAndPasswordCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $SignUpWithEmailAndPasswordCopyWith(SignUpWithEmailAndPassword value, $Res Function(SignUpWithEmailAndPassword) _then) = _$SignUpWithEmailAndPasswordCopyWithImpl;
@useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class _$SignUpWithEmailAndPasswordCopyWithImpl<$Res>
    implements $SignUpWithEmailAndPasswordCopyWith<$Res> {
  _$SignUpWithEmailAndPasswordCopyWithImpl(this._self, this._then);

  final SignUpWithEmailAndPassword _self;
  final $Res Function(SignUpWithEmailAndPassword) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,}) {
  return _then(SignUpWithEmailAndPassword(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SignInWithEmailAndPassword implements AuthEvent {
  const SignInWithEmailAndPassword({required this.email, required this.password});
  

 final  String email;
 final  String password;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignInWithEmailAndPasswordCopyWith<SignInWithEmailAndPassword> get copyWith => _$SignInWithEmailAndPasswordCopyWithImpl<SignInWithEmailAndPassword>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignInWithEmailAndPassword&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString() {
  return 'AuthEvent.signInWithEmailAndPassword(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class $SignInWithEmailAndPasswordCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $SignInWithEmailAndPasswordCopyWith(SignInWithEmailAndPassword value, $Res Function(SignInWithEmailAndPassword) _then) = _$SignInWithEmailAndPasswordCopyWithImpl;
@useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class _$SignInWithEmailAndPasswordCopyWithImpl<$Res>
    implements $SignInWithEmailAndPasswordCopyWith<$Res> {
  _$SignInWithEmailAndPasswordCopyWithImpl(this._self, this._then);

  final SignInWithEmailAndPassword _self;
  final $Res Function(SignInWithEmailAndPassword) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,}) {
  return _then(SignInWithEmailAndPassword(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SignInWithGoogle implements AuthEvent {
  const SignInWithGoogle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignInWithGoogle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.signInWithGoogle()';
}


}




/// @nodoc


class SignOut implements AuthEvent {
  const SignOut();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignOut);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.signOut()';
}


}




/// @nodoc


class SendPasswordResetEmail implements AuthEvent {
  const SendPasswordResetEmail({required this.email});
  

 final  String email;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendPasswordResetEmailCopyWith<SendPasswordResetEmail> get copyWith => _$SendPasswordResetEmailCopyWithImpl<SendPasswordResetEmail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendPasswordResetEmail&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,email);

@override
String toString() {
  return 'AuthEvent.sendPasswordResetEmail(email: $email)';
}


}

/// @nodoc
abstract mixin class $SendPasswordResetEmailCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $SendPasswordResetEmailCopyWith(SendPasswordResetEmail value, $Res Function(SendPasswordResetEmail) _then) = _$SendPasswordResetEmailCopyWithImpl;
@useResult
$Res call({
 String email
});




}
/// @nodoc
class _$SendPasswordResetEmailCopyWithImpl<$Res>
    implements $SendPasswordResetEmailCopyWith<$Res> {
  _$SendPasswordResetEmailCopyWithImpl(this._self, this._then);

  final SendPasswordResetEmail _self;
  final $Res Function(SendPasswordResetEmail) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,}) {
  return _then(SendPasswordResetEmail(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UpdatePassword implements AuthEvent {
  const UpdatePassword({required this.newPassword});
  

 final  String newPassword;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdatePasswordCopyWith<UpdatePassword> get copyWith => _$UpdatePasswordCopyWithImpl<UpdatePassword>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdatePassword&&(identical(other.newPassword, newPassword) || other.newPassword == newPassword));
}


@override
int get hashCode => Object.hash(runtimeType,newPassword);

@override
String toString() {
  return 'AuthEvent.updatePassword(newPassword: $newPassword)';
}


}

/// @nodoc
abstract mixin class $UpdatePasswordCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $UpdatePasswordCopyWith(UpdatePassword value, $Res Function(UpdatePassword) _then) = _$UpdatePasswordCopyWithImpl;
@useResult
$Res call({
 String newPassword
});




}
/// @nodoc
class _$UpdatePasswordCopyWithImpl<$Res>
    implements $UpdatePasswordCopyWith<$Res> {
  _$UpdatePasswordCopyWithImpl(this._self, this._then);

  final UpdatePassword _self;
  final $Res Function(UpdatePassword) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? newPassword = null,}) {
  return _then(UpdatePassword(
newPassword: null == newPassword ? _self.newPassword : newPassword // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ResendVerificationEmail implements AuthEvent {
  const ResendVerificationEmail({required this.email});
  

 final  String email;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResendVerificationEmailCopyWith<ResendVerificationEmail> get copyWith => _$ResendVerificationEmailCopyWithImpl<ResendVerificationEmail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResendVerificationEmail&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,email);

@override
String toString() {
  return 'AuthEvent.resendVerificationEmail(email: $email)';
}


}

/// @nodoc
abstract mixin class $ResendVerificationEmailCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $ResendVerificationEmailCopyWith(ResendVerificationEmail value, $Res Function(ResendVerificationEmail) _then) = _$ResendVerificationEmailCopyWithImpl;
@useResult
$Res call({
 String email
});




}
/// @nodoc
class _$ResendVerificationEmailCopyWithImpl<$Res>
    implements $ResendVerificationEmailCopyWith<$Res> {
  _$ResendVerificationEmailCopyWithImpl(this._self, this._then);

  final ResendVerificationEmail _self;
  final $Res Function(ResendVerificationEmail) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,}) {
  return _then(ResendVerificationEmail(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class VerifyOtp implements AuthEvent {
  const VerifyOtp({required this.email, required this.token, required this.type});
  

 final  String email;
 final  String token;
 final  String type;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerifyOtpCopyWith<VerifyOtp> get copyWith => _$VerifyOtpCopyWithImpl<VerifyOtp>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerifyOtp&&(identical(other.email, email) || other.email == email)&&(identical(other.token, token) || other.token == token)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,email,token,type);

@override
String toString() {
  return 'AuthEvent.verifyOtp(email: $email, token: $token, type: $type)';
}


}

/// @nodoc
abstract mixin class $VerifyOtpCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $VerifyOtpCopyWith(VerifyOtp value, $Res Function(VerifyOtp) _then) = _$VerifyOtpCopyWithImpl;
@useResult
$Res call({
 String email, String token, String type
});




}
/// @nodoc
class _$VerifyOtpCopyWithImpl<$Res>
    implements $VerifyOtpCopyWith<$Res> {
  _$VerifyOtpCopyWithImpl(this._self, this._then);

  final VerifyOtp _self;
  final $Res Function(VerifyOtp) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? token = null,Object? type = null,}) {
  return _then(VerifyOtp(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class HandleDeepLinkTokenHash implements AuthEvent {
  const HandleDeepLinkTokenHash({required this.tokenHash, required this.type});
  

 final  String tokenHash;
 final  String type;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HandleDeepLinkTokenHashCopyWith<HandleDeepLinkTokenHash> get copyWith => _$HandleDeepLinkTokenHashCopyWithImpl<HandleDeepLinkTokenHash>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HandleDeepLinkTokenHash&&(identical(other.tokenHash, tokenHash) || other.tokenHash == tokenHash)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,tokenHash,type);

@override
String toString() {
  return 'AuthEvent.handleDeepLinkTokenHash(tokenHash: $tokenHash, type: $type)';
}


}

/// @nodoc
abstract mixin class $HandleDeepLinkTokenHashCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $HandleDeepLinkTokenHashCopyWith(HandleDeepLinkTokenHash value, $Res Function(HandleDeepLinkTokenHash) _then) = _$HandleDeepLinkTokenHashCopyWithImpl;
@useResult
$Res call({
 String tokenHash, String type
});




}
/// @nodoc
class _$HandleDeepLinkTokenHashCopyWithImpl<$Res>
    implements $HandleDeepLinkTokenHashCopyWith<$Res> {
  _$HandleDeepLinkTokenHashCopyWithImpl(this._self, this._then);

  final HandleDeepLinkTokenHash _self;
  final $Res Function(HandleDeepLinkTokenHash) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tokenHash = null,Object? type = null,}) {
  return _then(HandleDeepLinkTokenHash(
tokenHash: null == tokenHash ? _self.tokenHash : tokenHash // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class HandleDeepLinkSession implements AuthEvent {
  const HandleDeepLinkSession({required this.accessToken, required this.refreshToken, this.type});
  

 final  String accessToken;
 final  String refreshToken;
 final  String? type;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HandleDeepLinkSessionCopyWith<HandleDeepLinkSession> get copyWith => _$HandleDeepLinkSessionCopyWithImpl<HandleDeepLinkSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HandleDeepLinkSession&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,type);

@override
String toString() {
  return 'AuthEvent.handleDeepLinkSession(accessToken: $accessToken, refreshToken: $refreshToken, type: $type)';
}


}

/// @nodoc
abstract mixin class $HandleDeepLinkSessionCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $HandleDeepLinkSessionCopyWith(HandleDeepLinkSession value, $Res Function(HandleDeepLinkSession) _then) = _$HandleDeepLinkSessionCopyWithImpl;
@useResult
$Res call({
 String accessToken, String refreshToken, String? type
});




}
/// @nodoc
class _$HandleDeepLinkSessionCopyWithImpl<$Res>
    implements $HandleDeepLinkSessionCopyWith<$Res> {
  _$HandleDeepLinkSessionCopyWithImpl(this._self, this._then);

  final HandleDeepLinkSession _self;
  final $Res Function(HandleDeepLinkSession) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,Object? type = freezed,}) {
  return _then(HandleDeepLinkSession(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class AuthStateChanged implements AuthEvent {
  const AuthStateChanged({this.user, required this.eventType});
  

 final  AppUser? user;
 final  String eventType;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStateChangedCopyWith<AuthStateChanged> get copyWith => _$AuthStateChangedCopyWithImpl<AuthStateChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthStateChanged&&(identical(other.user, user) || other.user == user)&&(identical(other.eventType, eventType) || other.eventType == eventType));
}


@override
int get hashCode => Object.hash(runtimeType,user,eventType);

@override
String toString() {
  return 'AuthEvent.authStateChanged(user: $user, eventType: $eventType)';
}


}

/// @nodoc
abstract mixin class $AuthStateChangedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $AuthStateChangedCopyWith(AuthStateChanged value, $Res Function(AuthStateChanged) _then) = _$AuthStateChangedCopyWithImpl;
@useResult
$Res call({
 AppUser? user, String eventType
});


$AppUserCopyWith<$Res>? get user;

}
/// @nodoc
class _$AuthStateChangedCopyWithImpl<$Res>
    implements $AuthStateChangedCopyWith<$Res> {
  _$AuthStateChangedCopyWithImpl(this._self, this._then);

  final AuthStateChanged _self;
  final $Res Function(AuthStateChanged) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = freezed,Object? eventType = null,}) {
  return _then(AuthStateChanged(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AppUser?,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppUserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $AppUserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc
mixin _$AuthState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState()';
}


}

/// @nodoc
class $AuthStateCopyWith<$Res>  {
$AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthInitial value)?  initial,TResult Function( AuthLoading value)?  loading,TResult Function( Authenticated value)?  authenticated,TResult Function( Unauthenticated value)?  unauthenticated,TResult Function( EmailVerificationRequired value)?  emailVerificationRequired,TResult Function( PasswordResetEmailSent value)?  passwordResetEmailSent,TResult Function( PasswordUpdated value)?  passwordUpdated,TResult Function( PasswordResetReady value)?  passwordResetReady,TResult Function( AuthError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthInitial() when initial != null:
return initial(_that);case AuthLoading() when loading != null:
return loading(_that);case Authenticated() when authenticated != null:
return authenticated(_that);case Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case EmailVerificationRequired() when emailVerificationRequired != null:
return emailVerificationRequired(_that);case PasswordResetEmailSent() when passwordResetEmailSent != null:
return passwordResetEmailSent(_that);case PasswordUpdated() when passwordUpdated != null:
return passwordUpdated(_that);case PasswordResetReady() when passwordResetReady != null:
return passwordResetReady(_that);case AuthError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthInitial value)  initial,required TResult Function( AuthLoading value)  loading,required TResult Function( Authenticated value)  authenticated,required TResult Function( Unauthenticated value)  unauthenticated,required TResult Function( EmailVerificationRequired value)  emailVerificationRequired,required TResult Function( PasswordResetEmailSent value)  passwordResetEmailSent,required TResult Function( PasswordUpdated value)  passwordUpdated,required TResult Function( PasswordResetReady value)  passwordResetReady,required TResult Function( AuthError value)  error,}){
final _that = this;
switch (_that) {
case AuthInitial():
return initial(_that);case AuthLoading():
return loading(_that);case Authenticated():
return authenticated(_that);case Unauthenticated():
return unauthenticated(_that);case EmailVerificationRequired():
return emailVerificationRequired(_that);case PasswordResetEmailSent():
return passwordResetEmailSent(_that);case PasswordUpdated():
return passwordUpdated(_that);case PasswordResetReady():
return passwordResetReady(_that);case AuthError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthInitial value)?  initial,TResult? Function( AuthLoading value)?  loading,TResult? Function( Authenticated value)?  authenticated,TResult? Function( Unauthenticated value)?  unauthenticated,TResult? Function( EmailVerificationRequired value)?  emailVerificationRequired,TResult? Function( PasswordResetEmailSent value)?  passwordResetEmailSent,TResult? Function( PasswordUpdated value)?  passwordUpdated,TResult? Function( PasswordResetReady value)?  passwordResetReady,TResult? Function( AuthError value)?  error,}){
final _that = this;
switch (_that) {
case AuthInitial() when initial != null:
return initial(_that);case AuthLoading() when loading != null:
return loading(_that);case Authenticated() when authenticated != null:
return authenticated(_that);case Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case EmailVerificationRequired() when emailVerificationRequired != null:
return emailVerificationRequired(_that);case PasswordResetEmailSent() when passwordResetEmailSent != null:
return passwordResetEmailSent(_that);case PasswordUpdated() when passwordUpdated != null:
return passwordUpdated(_that);case PasswordResetReady() when passwordResetReady != null:
return passwordResetReady(_that);case AuthError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( AppUser user)?  authenticated,TResult Function()?  unauthenticated,TResult Function( String email)?  emailVerificationRequired,TResult Function()?  passwordResetEmailSent,TResult Function()?  passwordUpdated,TResult Function( AppUser user)?  passwordResetReady,TResult Function( AuthFailure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthInitial() when initial != null:
return initial();case AuthLoading() when loading != null:
return loading();case Authenticated() when authenticated != null:
return authenticated(_that.user);case Unauthenticated() when unauthenticated != null:
return unauthenticated();case EmailVerificationRequired() when emailVerificationRequired != null:
return emailVerificationRequired(_that.email);case PasswordResetEmailSent() when passwordResetEmailSent != null:
return passwordResetEmailSent();case PasswordUpdated() when passwordUpdated != null:
return passwordUpdated();case PasswordResetReady() when passwordResetReady != null:
return passwordResetReady(_that.user);case AuthError() when error != null:
return error(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( AppUser user)  authenticated,required TResult Function()  unauthenticated,required TResult Function( String email)  emailVerificationRequired,required TResult Function()  passwordResetEmailSent,required TResult Function()  passwordUpdated,required TResult Function( AppUser user)  passwordResetReady,required TResult Function( AuthFailure failure)  error,}) {final _that = this;
switch (_that) {
case AuthInitial():
return initial();case AuthLoading():
return loading();case Authenticated():
return authenticated(_that.user);case Unauthenticated():
return unauthenticated();case EmailVerificationRequired():
return emailVerificationRequired(_that.email);case PasswordResetEmailSent():
return passwordResetEmailSent();case PasswordUpdated():
return passwordUpdated();case PasswordResetReady():
return passwordResetReady(_that.user);case AuthError():
return error(_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( AppUser user)?  authenticated,TResult? Function()?  unauthenticated,TResult? Function( String email)?  emailVerificationRequired,TResult? Function()?  passwordResetEmailSent,TResult? Function()?  passwordUpdated,TResult? Function( AppUser user)?  passwordResetReady,TResult? Function( AuthFailure failure)?  error,}) {final _that = this;
switch (_that) {
case AuthInitial() when initial != null:
return initial();case AuthLoading() when loading != null:
return loading();case Authenticated() when authenticated != null:
return authenticated(_that.user);case Unauthenticated() when unauthenticated != null:
return unauthenticated();case EmailVerificationRequired() when emailVerificationRequired != null:
return emailVerificationRequired(_that.email);case PasswordResetEmailSent() when passwordResetEmailSent != null:
return passwordResetEmailSent();case PasswordUpdated() when passwordUpdated != null:
return passwordUpdated();case PasswordResetReady() when passwordResetReady != null:
return passwordResetReady(_that.user);case AuthError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class AuthInitial implements AuthState {
  const AuthInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.initial()';
}


}




/// @nodoc


class AuthLoading implements AuthState {
  const AuthLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.loading()';
}


}




/// @nodoc


class Authenticated implements AuthState {
  const Authenticated(this.user);
  

 final  AppUser user;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticatedCopyWith<Authenticated> get copyWith => _$AuthenticatedCopyWithImpl<Authenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Authenticated&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'AuthState.authenticated(user: $user)';
}


}

/// @nodoc
abstract mixin class $AuthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthenticatedCopyWith(Authenticated value, $Res Function(Authenticated) _then) = _$AuthenticatedCopyWithImpl;
@useResult
$Res call({
 AppUser user
});


$AppUserCopyWith<$Res> get user;

}
/// @nodoc
class _$AuthenticatedCopyWithImpl<$Res>
    implements $AuthenticatedCopyWith<$Res> {
  _$AuthenticatedCopyWithImpl(this._self, this._then);

  final Authenticated _self;
  final $Res Function(Authenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(Authenticated(
null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AppUser,
  ));
}

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppUserCopyWith<$Res> get user {
  
  return $AppUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc


class Unauthenticated implements AuthState {
  const Unauthenticated();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Unauthenticated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.unauthenticated()';
}


}




/// @nodoc


class EmailVerificationRequired implements AuthState {
  const EmailVerificationRequired({required this.email});
  

 final  String email;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmailVerificationRequiredCopyWith<EmailVerificationRequired> get copyWith => _$EmailVerificationRequiredCopyWithImpl<EmailVerificationRequired>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmailVerificationRequired&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,email);

@override
String toString() {
  return 'AuthState.emailVerificationRequired(email: $email)';
}


}

/// @nodoc
abstract mixin class $EmailVerificationRequiredCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $EmailVerificationRequiredCopyWith(EmailVerificationRequired value, $Res Function(EmailVerificationRequired) _then) = _$EmailVerificationRequiredCopyWithImpl;
@useResult
$Res call({
 String email
});




}
/// @nodoc
class _$EmailVerificationRequiredCopyWithImpl<$Res>
    implements $EmailVerificationRequiredCopyWith<$Res> {
  _$EmailVerificationRequiredCopyWithImpl(this._self, this._then);

  final EmailVerificationRequired _self;
  final $Res Function(EmailVerificationRequired) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,}) {
  return _then(EmailVerificationRequired(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class PasswordResetEmailSent implements AuthState {
  const PasswordResetEmailSent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordResetEmailSent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.passwordResetEmailSent()';
}


}




/// @nodoc


class PasswordUpdated implements AuthState {
  const PasswordUpdated();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordUpdated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.passwordUpdated()';
}


}




/// @nodoc


class PasswordResetReady implements AuthState {
  const PasswordResetReady(this.user);
  

 final  AppUser user;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PasswordResetReadyCopyWith<PasswordResetReady> get copyWith => _$PasswordResetReadyCopyWithImpl<PasswordResetReady>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordResetReady&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'AuthState.passwordResetReady(user: $user)';
}


}

/// @nodoc
abstract mixin class $PasswordResetReadyCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $PasswordResetReadyCopyWith(PasswordResetReady value, $Res Function(PasswordResetReady) _then) = _$PasswordResetReadyCopyWithImpl;
@useResult
$Res call({
 AppUser user
});


$AppUserCopyWith<$Res> get user;

}
/// @nodoc
class _$PasswordResetReadyCopyWithImpl<$Res>
    implements $PasswordResetReadyCopyWith<$Res> {
  _$PasswordResetReadyCopyWithImpl(this._self, this._then);

  final PasswordResetReady _self;
  final $Res Function(PasswordResetReady) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(PasswordResetReady(
null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AppUser,
  ));
}

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppUserCopyWith<$Res> get user {
  
  return $AppUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc


class AuthError implements AuthState {
  const AuthError(this.failure);
  

 final  AuthFailure failure;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthErrorCopyWith<AuthError> get copyWith => _$AuthErrorCopyWithImpl<AuthError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'AuthState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $AuthErrorCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthErrorCopyWith(AuthError value, $Res Function(AuthError) _then) = _$AuthErrorCopyWithImpl;
@useResult
$Res call({
 AuthFailure failure
});


$AuthFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$AuthErrorCopyWithImpl<$Res>
    implements $AuthErrorCopyWith<$Res> {
  _$AuthErrorCopyWithImpl(this._self, this._then);

  final AuthError _self;
  final $Res Function(AuthError) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(AuthError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AuthFailure,
  ));
}

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthFailureCopyWith<$Res> get failure {
  
  return $AuthFailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
