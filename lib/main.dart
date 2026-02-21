import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:honk/core/deep_link/deep_link_handler.dart';
import 'package:honk/core/di/injection.dart';
import 'package:honk/core/env/env.dart';
import 'package:honk/core/router/app_router.dart';
import 'package:honk/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:honk/features/notifications/domain/repositories/i_notification_repository.dart';
import 'package:honk/features/notifications/domain/services/i_notification_runtime_service.dart';
import 'package:honk/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
    debug: kDebugMode,
  );

  await configureDependencies(AppEnv.dev);

  runApp(const HonkApp());
}

class HonkApp extends StatefulWidget {
  const HonkApp({super.key});

  @override
  State<HonkApp> createState() => _HonkAppState();
}

class _HonkAppState extends State<HonkApp> {
  late final AuthBloc _authBloc;
  late final GoRouter _router;
  late final DeepLinkHandler _deepLinkHandler;
  late final INotificationRepository _notificationRepository;
  late final INotificationRuntimeService _notificationRuntimeService;
  StreamSubscription? _deepLinkSubscription;
  StreamSubscription<AuthState>? _authStateSubscription;
  StreamSubscription<String>? _fcmTokenRefreshSubscription;
  StreamSubscription<String>? _notificationOpenSubscription;
  String? _pendingOpenedHonkId;

  Future<void> _handleInitialDeepLink() async {
    final deepLink = await _deepLinkHandler.getInitialAuthDeepLink();
    if (deepLink != null) {
      _handleAuthDeepLink(deepLink);
    }
  }

  void _handleAuthDeepLink(AuthDeepLink deepLink) {
    if (deepLink.hasError) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing deep link: ${deepLink.error}'),
          ),
        );
      }
      return;
    }

    if (deepLink.hasTokenHash) {
      _authBloc.add(
        AuthEvent.handleDeepLinkTokenHash(
          tokenHash: deepLink.tokenHash!,
          type: deepLink.type ?? 'email',
        ),
      );
    } else if (deepLink.hasSessionTokens) {
      _authBloc.add(
        AuthEvent.handleDeepLinkSession(
          accessToken: deepLink.accessToken!,
          refreshToken: deepLink.refreshToken!,
          type: deepLink.type,
        ),
      );
    }
  }

  void _handleNotificationOpened(String honkId) {
    if (honkId.isEmpty) {
      return;
    }

    if (_authBloc.state is! Authenticated) {
      _pendingOpenedHonkId = honkId;
      return;
    }

    _navigateToOpenedHonk(honkId);
  }

  void _navigateToOpenedHonk(String honkId) {
    final location = Uri(
      path: const HomeRoute().location,
      queryParameters: {'opened_honk_id': honkId},
    ).toString();
    _router.go(location);
  }

  @override
  void initState() {
    super.initState();
    _authBloc = getIt<AuthBloc>();
    _router = createAppRouter(_authBloc);
    _deepLinkHandler = getIt<DeepLinkHandler>();
    _notificationRepository = getIt<INotificationRepository>();
    _notificationRuntimeService = getIt<INotificationRuntimeService>();

    _notificationOpenSubscription = _notificationRuntimeService.openedHonkIds
        .listen(_handleNotificationOpened);
    unawaited(_notificationRuntimeService.initialize());

    _authBloc.add(const AuthEvent.checkAuthStatus());
    _syncFcmTokenForCurrentUser();

    _handleInitialDeepLink();

    _deepLinkSubscription = _deepLinkHandler.authDeepLinks.listen(
      _handleAuthDeepLink,
    );

    _authStateSubscription = _authBloc.stream.listen((state) {
      state.whenOrNull(
        authenticated: (_) {
          _syncFcmTokenForCurrentUser();

          final pendingHonkId = _pendingOpenedHonkId;
          if (pendingHonkId != null && pendingHonkId.isNotEmpty) {
            _pendingOpenedHonkId = null;
            _navigateToOpenedHonk(pendingHonkId);
          }
        },
      );
    });
    _fcmTokenRefreshSubscription = _notificationRepository
        .onTokenRefresh()
        .listen((_) {
          unawaited(_notificationRepository.syncFcmToken().run());
        });
  }

  Future<void> _syncFcmTokenForCurrentUser() async {
    final permissionResult = await _notificationRepository
        .requestPermission()
        .run();
    await permissionResult.match((_) async {}, (_) async {
      await _notificationRepository.syncFcmToken().run();
    });
  }

  @override
  void dispose() {
    _deepLinkSubscription?.cancel();
    _authStateSubscription?.cancel();
    _fcmTokenRefreshSubscription?.cancel();
    _notificationOpenSubscription?.cancel();
    unawaited(_notificationRuntimeService.dispose());
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authBloc,
      child: MaterialApp.router(
        title: 'Honk',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            filled: true,
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.purpleAccent,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            filled: true,
          ),
        ),
        routerConfig: _router,
      ),
    );
  }
}
