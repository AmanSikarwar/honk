import 'dart:async';
import 'dart:developer' as developer;

import 'package:app_links/app_links.dart';
import 'package:injectable/injectable.dart';

abstract class DeepLinkConfig {
  static const String scheme = 'app.honk';

  static const String authHost = 'auth-callback';

  static String get redirectUrl => '$scheme://$authHost';
}

class AuthDeepLink {
  final String? accessToken;
  final String? refreshToken;
  final String? tokenHash;
  final String? type;
  final String? error;
  final String? errorCode;
  final String? errorDescription;

  const AuthDeepLink({
    this.accessToken,
    this.refreshToken,
    this.tokenHash,
    this.type,
    this.error,
    this.errorCode,
    this.errorDescription,
  });

  bool get hasSessionTokens =>
      accessToken != null &&
      accessToken!.isNotEmpty &&
      refreshToken != null &&
      refreshToken!.isNotEmpty;

  bool get hasTokenHash => tokenHash != null && tokenHash!.isNotEmpty;

  bool get hasError => error != null || errorCode != null;

  bool get isRecovery => type == 'recovery';

  bool get isEmailVerification => type == 'signup' || type == 'email';

  @override
  String toString() {
    return 'AuthDeepLink(type: $type, hasSessionTokens: $hasSessionTokens, '
        'hasTokenHash: $hasTokenHash, hasError: $hasError)';
  }
}

@lazySingleton
class DeepLinkHandler {
  final AppLinks _appLinks;

  DeepLinkHandler() : _appLinks = AppLinks();

  Stream<AuthDeepLink> get authDeepLinks {
    return _appLinks.uriLinkStream.map(_parseAuthDeepLink).where((link) {
      return link.hasSessionTokens || link.hasTokenHash || link.hasError;
    });
  }

  Future<AuthDeepLink?> getInitialAuthDeepLink() async {
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri == null) return null;

      final link = _parseAuthDeepLink(uri);
      if (link.hasSessionTokens || link.hasTokenHash || link.hasError) {
        return link;
      }
      return null;
    } catch (e) {
      developer.log(
        'Error getting initial deep link: $e',
        name: 'DeepLinkHandler',
      );
      return null;
    }
  }

  AuthDeepLink _parseAuthDeepLink(Uri uri) {
    developer.log('Parsing deep link: $uri', name: 'DeepLinkHandler');

    final params = <String, String>{};

    if (uri.fragment.isNotEmpty) {
      final fragmentParams = Uri.splitQueryString(uri.fragment);
      params.addAll(fragmentParams);
    }

    params.addAll(uri.queryParameters);

    developer.log('Parsed parameters: $params', name: 'DeepLinkHandler');

    return AuthDeepLink(
      accessToken: params['access_token'],
      refreshToken: params['refresh_token'],
      tokenHash: params['token_hash'],
      type: params['type'],
      error: params['error'],
      errorCode: params['error_code'],
      errorDescription: params['error_description'],
    );
  }
}
