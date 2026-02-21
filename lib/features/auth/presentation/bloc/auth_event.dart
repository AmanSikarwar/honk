part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.checkAuthStatus() = CheckAuthStatus;

  const factory AuthEvent.signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) = SignUpWithEmailAndPassword;

  const factory AuthEvent.signInWithEmailAndPassword({
    required String email,
    required String password,
  }) = SignInWithEmailAndPassword;

  const factory AuthEvent.signInWithGoogle() = SignInWithGoogle;

  const factory AuthEvent.signOut() = SignOut;

  const factory AuthEvent.sendPasswordResetEmail({required String email}) =
      SendPasswordResetEmail;

  const factory AuthEvent.updatePassword({required String newPassword}) =
      UpdatePassword;

  const factory AuthEvent.resendVerificationEmail({required String email}) =
      ResendVerificationEmail;

  const factory AuthEvent.verifyOtp({
    required String email,
    required String token,
    required String type,
  }) = VerifyOtp;

  const factory AuthEvent.handleDeepLinkTokenHash({
    required String tokenHash,
    required String type,
  }) = HandleDeepLinkTokenHash;

  const factory AuthEvent.handleDeepLinkSession({
    required String accessToken,
    required String refreshToken,
    String? type,
  }) = HandleDeepLinkSession;

  const factory AuthEvent.authStateChanged({
    AppUser? user,
    required String eventType,
  }) = AuthStateChanged;
}
