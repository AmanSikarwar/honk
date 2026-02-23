import 'package:fpdart/fpdart.dart';

import '../../../../core/domain/main_failure.dart';
import '../entities/honk_activity.dart';
import '../entities/honk_activity_details.dart';
import '../entities/honk_activity_summary.dart';
import '../entities/honk_status_option.dart';

abstract class IHonkRepository {
  TaskEither<MainFailure, HonkActivity> createActivity({
    required String activity,
    required String location,
    String? details,
    required int statusResetSeconds,
    required List<HonkStatusOption> statusOptions,
  });

  TaskEither<MainFailure, HonkActivity> updateActivity({
    required String activityId,
    required String activity,
    required String location,
    String? details,
    required int statusResetSeconds,
    required List<HonkStatusOption> statusOptions,
  });

  TaskEither<MainFailure, Unit> deleteActivity({required String activityId});

  TaskEither<MainFailure, String> rotateInvite({required String activityId});

  /// Returns `(activityId, isPending)` where [isPending] means the request
  /// is waiting for creator approval.
  TaskEither<MainFailure, ({String activityId, bool isPending})> joinByInviteCode({
    required String inviteCode,
  });

  TaskEither<MainFailure, Unit> leaveActivity({required String activityId});

  TaskEither<MainFailure, Unit> setParticipantStatus({
    required String activityId,
    required String statusKey,
  });

  TaskEither<MainFailure, Unit> approveJoinRequest({
    required String activityId,
    required String userId,
  });

  TaskEither<MainFailure, Unit> denyJoinRequest({
    required String activityId,
    required String userId,
  });

  Stream<Either<MainFailure, List<HonkActivitySummary>>> watchActivities();

  Stream<Either<MainFailure, HonkActivityDetails>> watchActivityDetails({
    required String activityId,
  });
}
