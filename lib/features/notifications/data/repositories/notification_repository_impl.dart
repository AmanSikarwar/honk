import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/data/failure_mapper.dart';
import '../../../../core/domain/main_failure.dart';
import '../../domain/repositories/i_notification_repository.dart';

@LazySingleton(as: INotificationRepository)
class NotificationRepositoryImpl implements INotificationRepository {
  NotificationRepositoryImpl(this._messaging, this._supabase);

  final FirebaseMessaging _messaging;
  final SupabaseClient _supabase;

  @override
  TaskEither<MainFailure, Unit> requestPermission() {
    return TaskEither<MainFailure, Unit>.tryCatch(() async {
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        throw const MainFailure.permissionFailure(
          'Notification permission denied.',
        );
      }

      return unit;
    }, mapErrorToMainFailure);
  }

  @override
  TaskEither<MainFailure, String?> getFcmToken() {
    return TaskEither<MainFailure, String?>.tryCatch(
      _messaging.getToken,
      mapErrorToMainFailure,
    );
  }

  @override
  Stream<String> onTokenRefresh() => _messaging.onTokenRefresh;

  @override
  TaskEither<MainFailure, Unit> syncFcmToken() {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      return TaskEither.of(unit);
    }

    return getFcmToken().flatMap((token) {
      if (token == null || token.isEmpty) {
        return TaskEither.of(unit);
      }

      return TaskEither<MainFailure, Unit>.tryCatch(() async {
        final fallbackUsername =
            user.email?.split('@').first ?? 'user_${user.id.substring(0, 8)}';

        await _supabase.from('profiles').upsert({
          'id': user.id,
          'username':
              user.userMetadata?['username'] as String? ?? fallbackUsername,
          'fcm_token': token,
        }, onConflict: 'id');

        return unit;
      }, mapErrorToMainFailure);
    });
  }
}
