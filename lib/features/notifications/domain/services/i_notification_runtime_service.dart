import 'dart:async';

abstract class INotificationRuntimeService {
  Stream<String> get openedHonkIds;

  Future<void> initialize();

  Future<void> dispose();
}
