import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../pages/login_page.dart';

class AuthWrapper extends StatelessWidget {
  final Widget child;

  const AuthWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_getErrorMessage(state.failure)),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return state.when(
          initial: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
          loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
          authenticated: (user) => child,
          unauthenticated: () => const LoginPage(),
          emailVerificationRequired: (email) => const LoginPage(),
          passwordResetEmailSent: () => const LoginPage(),
          passwordUpdated: () => const LoginPage(),
          passwordResetReady: (user) => const LoginPage(), // Will be redirected by router
          error: (failure) => const LoginPage(),
        );
      },
    );
  }

  String _getErrorMessage(dynamic failure) {
    return failure.when(
      serverError: (message) => message,
      emailAlreadyInUse: () => 'This email is already registered',
      invalidEmailAndPasswordCombination: () => 'Invalid email or password',
      weakPassword: () => 'Password is too weak',
      userNotFound: () => 'No account found with this email',
      emailNotVerified: () => 'Please verify your email first',
      tooManyRequests: () => 'Too many attempts. Please try again later',
      networkError: () => 'Network error. Please check your connection',
      cancelledByUser: () => 'Operation cancelled',
      unknown: (message) => message,
    );
  }
}
