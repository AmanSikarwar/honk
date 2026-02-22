import 'package:freezed_annotation/freezed_annotation.dart';

import 'honk_activity.dart';
import 'honk_participant.dart';
import 'honk_status_option.dart';

part 'honk_activity_details.freezed.dart';

@freezed
abstract class HonkActivityDetails with _$HonkActivityDetails {
  const HonkActivityDetails._();

  const factory HonkActivityDetails({
    required HonkActivity activity,
    required DateTime occurrenceStart,
    required List<HonkStatusOption> statusOptions,
    required List<HonkParticipant> participants,
    required String currentUserId,
  }) = _HonkActivityDetails;

  HonkParticipant? get currentUserParticipant {
    for (final p in participants) {
      if (p.userId == currentUserId) return p;
    }
    return null;
  }

  bool get isCreator => activity.creatorId == currentUserId;
}
