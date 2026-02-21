import '../entities/app_user.dart';
import '../entities/auth_failure.dart';

class AuthStateChangeEvent {
  final AppUser? user;
  final AuthChangeEventType eventType;

  const AuthStateChangeEvent({required this.user, required this.eventType});
}

enum AuthChangeEventType {
  initialSession,
  signedIn,
  signedOut,
  passwordRecovery,
  tokenRefreshed,
  userUpdated,
  userDeleted,
  mfaChallengeVerified,
}

abstract class AuthRepository {
  /// Stream of authentication state changes with event type.
  Stream<AuthStateChangeEvent> get authStateChanges;

  /// Get the currently signed-in user, or null if not signed in.
  AppUser? get currentUser;

  /// Check if a user is currently signed in.
  bool get isSignedIn;

  /// Sign up with email and password.
  /// Sends a confirmation email to the user.
  Future<({AppUser? user, AuthFailure? failure})> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sign in with email and password.
  Future<({AppUser? user, AuthFailure? failure})> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sign in with Google using native sign-in flow.
  Future<({AppUser? user, AuthFailure? failure})> signInWithGoogle();

  /// Sign out the current user.
  Future<AuthFailure?> signOut();

  /// Send password reset email.
  Future<AuthFailure?> sendPasswordResetEmail({required String email});

  /// Update the user's password (user must be authenticated).
  Future<AuthFailure?> updatePassword({required String newPassword});

  /// Resend email verification.
  Future<AuthFailure?> resendVerificationEmail({required String email});

  /// Verify OTP token (for email verification or password reset).
  Future<({AppUser? user, AuthFailure? failure})> verifyOtp({
    required String email,
    required String token,
    required OtpType type,
  });

  /// Verify OTP using token hash (for deep link flows).
  Future<({AppUser? user, AuthFailure? failure})> verifyOtpWithTokenHash({
    required String tokenHash,
    required OtpType type,
  });

  /// Set session from deep link tokens (implicit flow).
  Future<({AppUser? user, AuthFailure? failure})> setSessionFromTokens({
    required String accessToken,
    required String refreshToken,
  });
}

enum OtpType { signup, recovery, email }
