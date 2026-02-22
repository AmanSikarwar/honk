import 'package:fpdart/fpdart.dart';

import '../../../../core/domain/main_failure.dart';
import '../entities/honk_activity.dart';
import '../entities/honk_activity_details.dart';
import '../entities/honk_activity_summary.dart';
import '../entities/honk_participant_candidate.dart';
import '../entities/honk_status_option.dart';

abstract class IHonkRepository {
  TaskEither<MainFailure, List<HonkParticipantCandidate>>
  fetchEligibleParticipants();

  TaskEither<MainFailure, HonkActivity> createActivity({
    required String activity,
    required String location,
    String? details,
    required DateTime startsAt,
    String? recurrenceRrule,
    required String recurrenceTimezone,
    required int statusResetSeconds,
    required List<HonkStatusOption> statusOptions,
    required List<String> participantIds,
  });

  TaskEither<MainFailure, HonkActivity> updateActivity({
    required String activityId,
    required String activity,
    required String location,
    String? details,
    required DateTime startsAt,
    String? recurrenceRrule,
    required String recurrenceTimezone,
    required int statusResetSeconds,
    required List<HonkStatusOption> statusOptions,
  });

  TaskEither<MainFailure, Unit> deleteActivity({required String activityId});

  TaskEither<MainFailure, String> rotateInvite({required String activityId});

  TaskEither<MainFailure, String> joinByInviteCode({required String inviteCode});

  TaskEither<MainFailure, Unit> leaveActivity({required String activityId});

  TaskEither<MainFailure, Unit> setParticipantStatus({
    required String activityId,
    required String statusKey,
    DateTime? occurrenceStart,
  });

  Stream<Either<MainFailure, List<HonkActivitySummary>>> watchActivities();

  Stream<Either<MainFailure, HonkActivityDetails>> watchActivityDetails({
    required String activityId,
  });
}
