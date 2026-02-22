import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/main_failure.dart';
import '../../domain/entities/honk_activity.dart';
import '../../domain/entities/honk_status_option.dart';
import '../../domain/repositories/i_honk_repository.dart';

part 'action_pad_state.dart';
part 'action_pad_cubit.freezed.dart';

@injectable
class ActionPadCubit extends Cubit<ActionPadState> {
  ActionPadCubit(this._honkRepository) : super(const ActionPadState.idle());

  final IHonkRepository _honkRepository;

  Future<void> createActivity({
    required String activity,
    required String location,
    String? details,
    required DateTime startsAt,
    required String recurrenceTimezone,
    String? recurrenceRrule,
    required int statusResetSeconds,
    required List<HonkStatusOption> statusOptions,
    required List<String> participantIds,
  }) async {
    emit(const ActionPadState.submitting());
    final result = await _honkRepository
        .createActivity(
          activity: activity,
          location: location,
          details: details,
          startsAt: startsAt,
          recurrenceRrule: recurrenceRrule,
          recurrenceTimezone: recurrenceTimezone,
          statusResetSeconds: statusResetSeconds,
          statusOptions: statusOptions,
          participantIds: participantIds,
        )
        .run();
    result.match(
      (failure) => emit(ActionPadState.failure(failure)),
      (createdActivity) => emit(ActionPadState.success(createdActivity)),
    );
  }

  void reset() {
    emit(const ActionPadState.idle());
  }
}
