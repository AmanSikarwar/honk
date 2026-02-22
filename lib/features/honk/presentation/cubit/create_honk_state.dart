part of 'create_honk_cubit.dart';

@freezed
abstract class CreateHonkState with _$CreateHonkState {
  const factory CreateHonkState({
    @Default(false) bool isLoadingParticipants,
    @Default(<HonkParticipantCandidate>[])
    List<HonkParticipantCandidate> eligibleParticipants,
    MainFailure? participantsFailure,
    @Default(false) bool isSubmitting,
    HonkActivity? createdActivity,
    MainFailure? submissionFailure,
  }) = _CreateHonkState;
}
