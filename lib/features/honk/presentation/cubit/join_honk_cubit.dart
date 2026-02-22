import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/main_failure.dart';
import '../../domain/repositories/i_honk_repository.dart';

part 'join_honk_state.dart';
part 'join_honk_cubit.freezed.dart';

@injectable
class JoinHonkCubit extends Cubit<JoinHonkState> {
  JoinHonkCubit(this._repository) : super(const JoinHonkState.idle());

  final IHonkRepository _repository;

  Future<void> joinByCode(String code) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) return;
    emit(const JoinHonkState.loading());
    final result = await _repository
        .joinByInviteCode(inviteCode: trimmed)
        .run();
    result.match(
      (failure) => emit(JoinHonkState.failure(failure)),
      (activityId) => emit(JoinHonkState.success(activityId)),
    );
  }

  void reset() => emit(const JoinHonkState.idle());
}
