import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/email_verification_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/update_password_page.dart';
import '../../features/friends/presentation/cubit/friend_management_cubit.dart';
import '../../features/friends/presentation/pages/friend_management_page.dart';
import '../../features/honk/presentation/bloc/honk_feed_bloc.dart';
import '../../features/honk/presentation/cubit/action_pad_cubit.dart';
import '../../features/honk/domain/repositories/i_honk_repository.dart';
import '../../features/honk/presentation/pages/home_dashboard_page.dart';
import '../../features/honk/presentation/pages/honk_details_page.dart';
import '../../features/honk/presentation/pages/invite_join_page.dart';
import '../../features/notifications/presentation/cubit/notification_sync_cubit.dart';
import '../../features/notifications/presentation/pages/settings_page.dart';
import '../di/injection.dart';

part 'app_router.g.dart';

@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              getIt<HonkFeedBloc>()..add(const HonkFeedEvent.started()),
        ),
        BlocProvider(create: (_) => getIt<ActionPadCubit>()),
      ],
      child: const HomeDashboardPage(),
    );
  }
}

@TypedGoRoute<HonkDetailsRoute>(path: '/activities/:activityId')
class HonkDetailsRoute extends GoRouteData with $HonkDetailsRoute {
  final String activityId;

  const HonkDetailsRoute({required this.activityId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return HonkDetailsPage(
      activityId: activityId,
      honkRepository: getIt<IHonkRepository>(),
    );
  }
}

@TypedGoRoute<InviteJoinRoute>(path: '/join/:inviteCode')
class InviteJoinRoute extends GoRouteData with $InviteJoinRoute {
  const InviteJoinRoute({required this.inviteCode});

  final String inviteCode;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return InviteJoinPage(
      inviteCode: inviteCode,
      honkRepository: getIt<IHonkRepository>(),
    );
  }
}

@TypedGoRoute<FriendManagementRoute>(path: '/friends')
class FriendManagementRoute extends GoRouteData with $FriendManagementRoute {
  const FriendManagementRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (_) => getIt<FriendManagementCubit>(),
      child: const FriendManagementPage(),
    );
  }
}

@TypedGoRoute<SettingsRoute>(path: '/settings')
class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (_) => getIt<NotificationSyncCubit>(),
      child: const SettingsPage(),
    );
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
