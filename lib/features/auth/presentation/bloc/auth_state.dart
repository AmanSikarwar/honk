part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;

  const factory AuthState.loading() = AuthLoading;

  const factory AuthState.authenticated(AppUser user) = Authenticated;

  const factory AuthState.unauthenticated() = Unauthenticated;

  const factory AuthState.emailVerificationRequired({required String email}) =
      EmailVerificationRequired;

  const factory AuthState.passwordResetEmailSent() = PasswordResetEmailSent;

  const factory AuthState.passwordUpdated() = PasswordUpdated;

  const factory AuthState.passwordResetReady(AppUser user) = PasswordResetReady;

  const factory AuthState.error(AuthFailure failure) = AuthError;
}
