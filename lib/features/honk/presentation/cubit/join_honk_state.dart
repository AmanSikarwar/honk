part of 'join_honk_cubit.dart';

@freezed
class JoinHonkState with _$JoinHonkState {
  const factory JoinHonkState.idle() = _Idle;
  const factory JoinHonkState.loading() = _Loading;
  const factory JoinHonkState.pendingApproval(String activityId) =
      _PendingApproval;
  const factory JoinHonkState.success(String activityId) = _Success;
  const factory JoinHonkState.failure(MainFailure failure) = _Failure;
}
