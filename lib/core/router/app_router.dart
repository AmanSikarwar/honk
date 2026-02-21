import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/email_verification_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/update_password_page.dart';

part 'app_router.g.dart';

@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomePage();
  }
}

@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginPage();
  }
}

@TypedGoRoute<SignUpRoute>(path: '/signup')
class SignUpRoute extends GoRouteData with $SignUpRoute {
  const SignUpRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SignUpPage();
  }
}

@TypedGoRoute<ForgotPasswordRoute>(path: '/forgot-password')
class ForgotPasswordRoute extends GoRouteData with $ForgotPasswordRoute {
  const ForgotPasswordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ForgotPasswordPage();
  }
}

@TypedGoRoute<UpdatePasswordRoute>(path: '/update-password')
class UpdatePasswordRoute extends GoRouteData with $UpdatePasswordRoute {
  const UpdatePasswordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const UpdatePasswordPage();
  }
}

@TypedGoRoute<EmailVerificationRoute>(path: '/verify-email/:email')
class EmailVerificationRoute extends GoRouteData with $EmailVerificationRoute {
  final String email;

  const EmailVerificationRoute({required this.email});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EmailVerificationPage(email: email);
  }
}

/// Temporary home page placeholder.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Honk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const AuthEvent.signOut());
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = state.whenOrNull(authenticated: (user) => user);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, size: 80, color: Colors.green),
                const SizedBox(height: 24),
                Text(
                  'Welcome!',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                if (user != null) ...[
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (user.displayName != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      user.displayName!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

GoRouter createAppRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: const LoginRoute().location,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final isAuthenticated = authState is Authenticated;
      final isPasswordResetReady = authState is PasswordResetReady;
      final isAuthRoute =
          state.matchedLocation == const LoginRoute().location ||
          state.matchedLocation == const SignUpRoute().location ||
          state.matchedLocation == const ForgotPasswordRoute().location ||
          state.matchedLocation.startsWith('/verify-email');

      if (authState is EmailVerificationRequired) {
        if (!state.matchedLocation.startsWith('/verify-email')) {
          return EmailVerificationRoute(email: authState.email).location;
        }
        return null;
      }

      if (isPasswordResetReady) {
        if (state.matchedLocation != const UpdatePasswordRoute().location) {
          return const UpdatePasswordRoute().location;
        }
        return null;
      }

      if (isAuthenticated && isAuthRoute) {
        return const HomeRoute().location;
      }

      if (!isAuthenticated && !isAuthRoute && !isPasswordResetReady) {
        return const LoginRoute().location;
      }

      if (state.matchedLocation == const UpdatePasswordRoute().location) {
        return null;
      }

      return null;
    },
    routes: $appRoutes,
  );
}

/// A [ChangeNotifier] that refreshes when the [Stream] emits.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
