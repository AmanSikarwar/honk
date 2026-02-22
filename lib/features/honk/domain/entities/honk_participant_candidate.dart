import 'package:freezed_annotation/freezed_annotation.dart';

part 'honk_participant_candidate.freezed.dart';

@freezed
abstract class HonkParticipantCandidate with _$HonkParticipantCandidate {
  const factory HonkParticipantCandidate({
    required String id,
    required String username,
  }) = _HonkParticipantCandidate;
}
