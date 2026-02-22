part of 'create_honk_cubit.dart';

@freezed
abstract class CreateHonkState with _$CreateHonkState {
  const factory CreateHonkState({
    @Default(false) bool isSubmitting,
    HonkActivity? createdActivity,
    MainFailure? submissionFailure,
  }) = _CreateHonkState;
}
