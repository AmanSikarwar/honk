import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

import '../../domain/services/i_notification_runtime_service.dart';

@LazySingleton(as: INotificationRuntimeService)
class NotificationRuntimeService implements INotificationRuntimeService {
  NotificationRuntimeService(this._messaging, this._localNotifications);

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;

  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;
  final StreamController<String> _openedHonkIdsController =
      StreamController<String>.broadcast();
  bool _initialized = false;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'honk_notifications',
    'Honk Notifications',
    description: 'Notifications for incoming honks from friends.',
    importance: Importance.high,
  );

  @override
  Stream<String> get openedHonkIds => _openedHonkIdsController.stream;

  @override
  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    try {
      const initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
        macOS: DarwinInitializationSettings(),
      );

      await _localNotifications.initialize(settings: initializationSettings);

      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_channel);

      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      _onMessageSubscription = FirebaseMessaging.onMessage.listen(
        _showForegroundNotification,
      );
      _onMessageOpenedAppSubscription = FirebaseMessaging.onMessageOpenedApp
          .listen(_handleMessageOpenedApp);

      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageOpenedApp(initialMessage);
      }
      _initialized = true;
    } catch (error, stackTrace) {
      debugPrint('Failed to initialize notification runtime service: $error');
      debugPrint('$stackTrace');
    }
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) {
      return;
    }

    try {
      final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _localNotifications.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: notificationDetails,
      );
    } catch (error, stackTrace) {
      debugPrint('Failed to show foreground notification: $error');
      debugPrint('$stackTrace');
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    final honkId = message.data['honk_id'];
    if (honkId is String && honkId.isNotEmpty) {
      _openedHonkIdsController.add(honkId);
    }
  }

  @override
  Future<void> dispose() async {
    await _onMessageSubscription?.cancel();
    await _onMessageOpenedAppSubscription?.cancel();
    _onMessageSubscription = null;
    _onMessageOpenedAppSubscription = null;
    _initialized = false;
  }
}
