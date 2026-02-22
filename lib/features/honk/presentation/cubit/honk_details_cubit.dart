import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/main_failure.dart';
import '../../domain/entities/honk_activity_details.dart';
import '../../domain/entities/honk_status_option.dart';
import '../../domain/repositories/i_honk_repository.dart';

part 'honk_details_state.dart';
part 'honk_details_cubit.freezed.dart';

@injectable
class HonkDetailsCubit extends Cubit<HonkDetailsState> {
  HonkDetailsCubit(this._repository) : super(const HonkDetailsState());

  final IHonkRepository _repository;
  StreamSubscription<dynamic>? _sub;
  String? _activityId;

  void watch(String activityId) {
    _activityId = activityId;
    _sub?.cancel();
    emit(const HonkDetailsState(isLoading: true));
    _sub = _repository.watchActivityDetails(activityId: activityId).listen((
      result,
    ) {
      result.match(
        (failure) =>
            emit(state.copyWith(isLoading: false, loadFailure: failure)),
        (details) => emit(
          state.copyWith(isLoading: false, details: details, loadFailure: null),
        ),
      );
    });
  }

  Future<void> setStatus({
    required String activityId,
    required DateTime occurrenceStart,
    required String statusKey,
  }) async {
    emit(
      state.copyWith(
        isSavingStatus: true,
        savingStatusKey: statusKey,
        actionError: null,
      ),
    );
    final result = await _repository
        .setParticipantStatus(
          activityId: activityId,
          statusKey: statusKey,
          occurrenceStart: occurrenceStart,
        )
        .run();
    result.match(
      (failure) => emit(
        state.copyWith(
          isSavingStatus: false,
          savingStatusKey: null,
          actionError: failure,
        ),
      ),
      (_) => emit(state.copyWith(isSavingStatus: false, savingStatusKey: null)),
    );
  }

  Future<void> deleteActivity(String activityId) async {
    emit(state.copyWith(isDeleting: true, actionError: null));
    final result = await _repository
        .deleteActivity(activityId: activityId)
        .run();
    result.match(
      (failure) =>
          emit(state.copyWith(isDeleting: false, actionError: failure)),
      (_) => emit(state.copyWith(isDeleting: false, wasDeleted: true)),
    );
  }

  Future<void> leaveActivity(String activityId) async {
    emit(state.copyWith(isLeaving: true, actionError: null));
    final result = await _repository
        .leaveActivity(activityId: activityId)
        .run();
    result.match(
      (failure) => emit(state.copyWith(isLeaving: false, actionError: failure)),
      (_) => emit(state.copyWith(isLeaving: false, wasLeft: true)),
    );
  }

  Future<void> rotateInvite(String activityId) async {
    emit(state.copyWith(isRotatingInvite: true, actionError: null));
    final result = await _repository.rotateInvite(activityId: activityId).run();
    result.match(
      (failure) =>
          emit(state.copyWith(isRotatingInvite: false, actionError: failure)),
      (code) => emit(
        state.copyWith(isRotatingInvite: false, rotatedInviteCode: code),
      ),
    );
  }

  Future<void> updateActivity({
    required String activityId,
    required String activity,
    required String location,
    String? details,
    required DateTime startsAt,
    String? recurrenceRrule,
    required String recurrenceTimezone,
    required int statusResetSeconds,
    required List<HonkStatusOption> statusOptions,
  }) async {
    emit(state.copyWith(isUpdating: true, actionError: null));
    final result = await _repository
        .updateActivity(
          activityId: activityId,
          activity: activity,
          location: location,
          details: details,
          startsAt: startsAt,
          recurrenceRrule: recurrenceRrule,
          recurrenceTimezone: recurrenceTimezone,
          statusResetSeconds: statusResetSeconds,
          statusOptions: statusOptions,
        )
        .run();
    result.match(
      (failure) =>
          emit(state.copyWith(isUpdating: false, actionError: failure)),
      (updatedActivity) {
        final current = state.details;
        if (current != null) {
          emit(
            state.copyWith(
              isUpdating: false,
              details: current.copyWith(
                activity: updatedActivity,
                statusOptions: updatedActivity.statusOptions,
              ),
            ),
          );
        } else {
          emit(state.copyWith(isUpdating: false));
        }
      },
    );
  }

  void clearActionError() {
    emit(state.copyWith(actionError: null));
  }

  void clearRotatedInviteCode() {
    emit(state.copyWith(rotatedInviteCode: null));
  }

  String? get activityId => _activityId;

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
