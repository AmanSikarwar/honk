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

  Stream<Uri> get uriLinks => _appLinks.uriLinkStream;

  Stream<AuthDeepLink> get authDeepLinks {
    return uriLinks.map(parseAuthDeepLink).where((link) {
      return link.hasSessionTokens || link.hasTokenHash || link.hasError;
    });
  }

  Stream<String> get inviteCodes => uriLinks
      .map(parseInviteCode)
      .where((inviteCode) => inviteCode != null && inviteCode.isNotEmpty)
      .cast<String>();

  Future<Uri?> getInitialLink() async {
    try {
      return await _appLinks.getInitialLink();
    } catch (e) {
      developer.log('Error getting initial deep link: $e', name: 'DeepLinkHandler');
      return null;
    }
  }

  Future<AuthDeepLink?> getInitialAuthDeepLink() async {
    final uri = await getInitialLink();
    if (uri == null) {
      return null;
    }

    final link = parseAuthDeepLink(uri);
    if (link.hasSessionTokens || link.hasTokenHash || link.hasError) {
      return link;
    }
    return null;
  }

  Future<String?> getInitialInviteCode() async {
    final uri = await getInitialLink();
    if (uri == null) {
      return null;
    }
    return parseInviteCode(uri);
  }

  AuthDeepLink parseAuthDeepLink(Uri uri) {
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

  String? parseInviteCode(Uri uri) {
    final queryCode = uri.queryParameters['invite_code']?.trim();
    if (queryCode != null && queryCode.isNotEmpty) {
      return queryCode;
    }

    final code = uri.queryParameters['code']?.trim();
    if (code != null && code.isNotEmpty) {
      return code;
    }

    final host = uri.host.toLowerCase();
    final segments = uri.pathSegments
        .map((segment) => segment.trim())
        .where((segment) => segment.isNotEmpty)
        .toList(growable: false);

    if (host == 'join') {
      if (segments.isNotEmpty) {
        return segments.first;
      }
      return null;
    }

    if (segments.length >= 2 && segments.first.toLowerCase() == 'join') {
      return segments[1];
    }

    return null;
  }
}
