part of 'honk_details_cubit.dart';

@freezed
abstract class HonkDetailsState with _$HonkDetailsState {
  const factory HonkDetailsState({
    @Default(true) bool isLoading,
    HonkActivityDetails? details,
    MainFailure? loadFailure,
    @Default(false) bool isSavingStatus,
    String? savingStatusKey,
    @Default(false) bool isDeleting,
    @Default(false) bool isLeaving,
    @Default(false) bool isRotatingInvite,
    @Default(false) bool isUpdating,
    String? rotatedInviteCode,
    MainFailure? actionError,
    @Default(false) bool wasDeleted,
    @Default(false) bool wasLeft,
  }) = _HonkDetailsState;
}
