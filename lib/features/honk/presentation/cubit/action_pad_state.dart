part of 'action_pad_cubit.dart';

@freezed
class ActionPadState with _$ActionPadState {
  const factory ActionPadState.idle() = _Idle;

  const factory ActionPadState.submitting() = _Submitting;

  const factory ActionPadState.success(HonkEvent honk) = _Success;

  const factory ActionPadState.failure(MainFailure failure) = _Failure;
}
