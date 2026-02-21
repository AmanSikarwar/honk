part of 'notification_sync_cubit.dart';

@freezed
class NotificationSyncState with _$NotificationSyncState {
  const factory NotificationSyncState.idle() = _Idle;

  const factory NotificationSyncState.syncInProgress() = _SyncInProgress;

  const factory NotificationSyncState.syncSuccess() = _SyncSuccess;

  const factory NotificationSyncState.syncFailure(MainFailure failure) =
      _SyncFailure;
}
