import 'package:fpdart/fpdart.dart';

import '../../../../core/domain/main_failure.dart';

abstract class INotificationRepository {
  TaskEither<MainFailure, Unit> requestPermission();

  TaskEither<MainFailure, String?> getFcmToken();

  Stream<String> onTokenRefresh();

  TaskEither<MainFailure, Unit> syncFcmToken();
}
