import 'honk_activity.dart';
import 'honk_participant.dart';
import 'honk_status_option.dart';

class HonkActivityDetails {
  const HonkActivityDetails({
    required this.activity,
    required this.occurrenceStart,
    required this.statusOptions,
    required this.participants,
    required this.currentUserId,
  });

  final HonkActivity activity;
  final DateTime occurrenceStart;
  final List<HonkStatusOption> statusOptions;
  final List<HonkParticipant> participants;
  final String currentUserId;

  HonkParticipant? get currentUserParticipant {
    for (final participant in participants) {
      if (participant.userId == currentUserId) {
        return participant;
      }
    }
    return null;
  }

  bool get isCreator => activity.creatorId == currentUserId;
}
