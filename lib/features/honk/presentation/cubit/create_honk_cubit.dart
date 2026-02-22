import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/main_failure.dart';
import '../../domain/entities/honk_activity.dart';
import '../../domain/entities/honk_participant_candidate.dart';
import '../../domain/entities/honk_status_option.dart';
import '../../domain/repositories/i_honk_repository.dart';

part 'create_honk_state.dart';
part 'create_honk_cubit.freezed.dart';

@injectable
class CreateHonkCubit extends Cubit<CreateHonkState> {
  CreateHonkCubit(this._repository) : super(const CreateHonkState()) {
    loadEligibleParticipants();
  }

  final IHonkRepository _repository;

  Future<void> loadEligibleParticipants() async {
    emit(
      state.copyWith(isLoadingParticipants: true, participantsFailure: null),
    );
    final result = await _repository.fetchEligibleParticipants().run();
    result.match(
      (failure) => emit(
        state.copyWith(
          isLoadingParticipants: false,
          participantsFailure: failure,
        ),
      ),
      (candidates) => emit(
        state.copyWith(
          isLoadingParticipants: false,
          eligibleParticipants: candidates,
        ),
      ),
    );
  }

  Future<void> createActivity({
    required String activity,
    required String location,
    String? details,
    required DateTime startsAt,
    String? recurrenceRrule,
    required String recurrenceTimezone,
    required int statusResetSeconds,
    required List<HonkStatusOption> statusOptions,
    required List<String> participantIds,
  }) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        createdActivity: null,
        submissionFailure: null,
      ),
    );
    final result = await _repository
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
      (failure) =>
          emit(state.copyWith(isSubmitting: false, submissionFailure: failure)),
      (created) =>
          emit(state.copyWith(isSubmitting: false, createdActivity: created)),
    );
  }

  void resetSubmission() {
    emit(
      state.copyWith(
        createdActivity: null,
        submissionFailure: null,
        isSubmitting: false,
      ),
    );
  }
}
