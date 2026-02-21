import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/entities/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<AuthStateChangeEvent>? _authStateSubscription;

  AuthBloc(this._authRepository) : super(const AuthState.initial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SignUpWithEmailAndPassword>(_onSignUpWithEmailAndPassword);
    on<SignInWithEmailAndPassword>(_onSignInWithEmailAndPassword);
    on<SignInWithGoogle>(_onSignInWithGoogle);
    on<SignOut>(_onSignOut);
    on<SendPasswordResetEmail>(_onSendPasswordResetEmail);
    on<UpdatePassword>(_onUpdatePassword);
    on<ResendVerificationEmail>(_onResendVerificationEmail);
    on<VerifyOtp>(_onVerifyOtp);
    on<HandleDeepLinkTokenHash>(_onHandleDeepLinkTokenHash);
    on<HandleDeepLinkSession>(_onHandleDeepLinkSession);
    on<AuthStateChanged>(_onAuthStateChanged);

    _authStateSubscription = _authRepository.authStateChanges.listen(
      (event) => add(
        AuthEvent.authStateChanged(
          user: event.user,
          eventType: event.eventType.name,
        ),
      ),
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    final user = _authRepository.currentUser;
    if (user != null) {
      emit(AuthState.authenticated(user));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onSignUpWithEmailAndPassword(
    SignUpWithEmailAndPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _authRepository.signUpWithEmailAndPassword(
      email: event.email,
      password: event.password,
    );

    if (result.failure != null) {
      emit(AuthState.error(result.failure!));
    } else if (result.user != null) {
      if (!result.user!.emailConfirmed) {
        emit(AuthState.emailVerificationRequired(email: event.email));
      } else {
        emit(AuthState.authenticated(result.user!));
      }
    }
  }

  Future<void> _onSignInWithEmailAndPassword(
    SignInWithEmailAndPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _authRepository.signInWithEmailAndPassword(
      email: event.email,
      password: event.password,
    );

    if (result.failure != null) {
      emit(AuthState.error(result.failure!));
    } else if (result.user != null) {
      emit(AuthState.authenticated(result.user!));
    }
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _authRepository.signInWithGoogle();

    if (result.failure != null) {
      // Don't show error if user cancelled
      if (result.failure is CancelledByUser) {
        emit(const AuthState.unauthenticated());
      } else {
        emit(AuthState.error(result.failure!));
      }
    } else if (result.user != null) {
      emit(AuthState.authenticated(result.user!));
    }
  }

  Future<void> _onSignOut(SignOut event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());

    final failure = await _authRepository.signOut();

    if (failure != null) {
      emit(AuthState.error(failure));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onSendPasswordResetEmail(
    SendPasswordResetEmail event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final failure = await _authRepository.sendPasswordResetEmail(
      email: event.email,
    );

    if (failure != null) {
      emit(AuthState.error(failure));
    } else {
      emit(const AuthState.passwordResetEmailSent());
    }
  }

  Future<void> _onUpdatePassword(
    UpdatePassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final failure = await _authRepository.updatePassword(
      newPassword: event.newPassword,
    );

    if (failure != null) {
      emit(AuthState.error(failure));
    } else {
      emit(const AuthState.passwordUpdated());
    }
  }

  Future<void> _onResendVerificationEmail(
    ResendVerificationEmail event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final failure = await _authRepository.resendVerificationEmail(
      email: event.email,
    );

    if (failure != null) {
      emit(AuthState.error(failure));
    } else {
      emit(AuthState.emailVerificationRequired(email: event.email));
    }
  }

  Future<void> _onVerifyOtp(VerifyOtp event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());

    final otpType = switch (event.type) {
      'signup' => OtpType.signup,
      'recovery' => OtpType.recovery,
      _ => OtpType.email,
    };

    final result = await _authRepository.verifyOtp(
      email: event.email,
      token: event.token,
      type: otpType,
    );

    if (result.failure != null) {
      emit(AuthState.error(result.failure!));
    } else if (result.user != null) {
      emit(AuthState.authenticated(result.user!));
    }
  }

  void _onAuthStateChanged(AuthStateChanged event, Emitter<AuthState> emit) {
    if (event.eventType == AuthChangeEventType.passwordRecovery.name &&
        event.user != null) {
      emit(AuthState.passwordResetReady(event.user!));
      return;
    }

    if (event.user != null) {
      emit(AuthState.authenticated(event.user!));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onHandleDeepLinkTokenHash(
    HandleDeepLinkTokenHash event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final otpType = switch (event.type) {
      'signup' => OtpType.signup,
      'recovery' => OtpType.recovery,
      _ => OtpType.email,
    };

    final result = await _authRepository.verifyOtpWithTokenHash(
      tokenHash: event.tokenHash,
      type: otpType,
    );

    if (result.failure != null) {
      emit(AuthState.error(result.failure!));
    } else if (result.user != null) {
      if (event.type == 'recovery') {
        emit(AuthState.passwordResetReady(result.user!));
      } else {
        emit(AuthState.authenticated(result.user!));
      }
    }
  }

  Future<void> _onHandleDeepLinkSession(
    HandleDeepLinkSession event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _authRepository.setSessionFromTokens(
      accessToken: event.accessToken,
      refreshToken: event.refreshToken,
    );

    if (result.failure != null) {
      emit(AuthState.error(result.failure!));
    } else if (result.user != null) {
      if (event.type == 'recovery') {
        emit(AuthState.passwordResetReady(result.user!));
      } else {
        emit(AuthState.authenticated(result.user!));
      }
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
