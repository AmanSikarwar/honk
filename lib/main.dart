import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:honk/core/deep_link/deep_link_handler.dart';
import 'package:honk/core/di/injection.dart';
import 'package:honk/core/env/env.dart';
import 'package:honk/core/router/app_router.dart';
import 'package:honk/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:honk/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
  StreamSubscription? _deepLinkSubscription;

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

  @override
  void initState() {
    super.initState();
    _authBloc = getIt<AuthBloc>();
    _router = createAppRouter(_authBloc);
    _deepLinkHandler = getIt<DeepLinkHandler>();

    _authBloc.add(const AuthEvent.checkAuthStatus());

    _handleInitialDeepLink();

    _deepLinkSubscription = _deepLinkHandler.authDeepLinks.listen(
      _handleAuthDeepLink,
    );
  }

  @override
  void dispose() {
    _deepLinkSubscription?.cancel();
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
