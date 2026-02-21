import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/main_failure.dart';
import '../../domain/repositories/i_notification_repository.dart';

part 'notification_sync_cubit.freezed.dart';
part 'notification_sync_state.dart';

@injectable
class NotificationSyncCubit extends Cubit<NotificationSyncState> {
  NotificationSyncCubit(this._notificationRepository)
    : super(const NotificationSyncState.idle());

  final INotificationRepository _notificationRepository;

  Future<void> syncToken() async {
    emit(const NotificationSyncState.syncInProgress());

    final result = await _notificationRepository
        .requestPermission()
        .flatMap((_) => _notificationRepository.syncFcmToken())
        .run();

    result.match(
      (failure) => emit(NotificationSyncState.syncFailure(failure)),
      (_) => emit(const NotificationSyncState.syncSuccess()),
    );
  }

  void reset() {
    emit(const NotificationSyncState.idle());
  }
}
