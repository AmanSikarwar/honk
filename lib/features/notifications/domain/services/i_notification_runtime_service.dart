import 'dart:async';

abstract class INotificationRuntimeService {
  Stream<String> get openedActivityIds;

  Future<void> initialize();

  Future<void> dispose();
}
