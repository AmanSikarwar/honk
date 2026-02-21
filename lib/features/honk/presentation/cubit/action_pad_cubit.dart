import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/main_failure.dart';
import '../../domain/entities/honk_event.dart';
import '../../domain/repositories/i_honk_repository.dart';

part 'action_pad_state.dart';
part 'action_pad_cubit.freezed.dart';

@injectable
class ActionPadCubit extends Cubit<ActionPadState> {
  ActionPadCubit(this._honkRepository) : super(const ActionPadState.idle());

  final IHonkRepository _honkRepository;

  Future<void> broadcastHonk({
    required String userId,
    required String location,
    required String status,
    Duration ttl = const Duration(minutes: 30),
  }) async {
    emit(const ActionPadState.submitting());

    final now = DateTime.now().toUtc();
    final honk = HonkEvent(
      id: 'local-${now.microsecondsSinceEpoch}',
      userId: userId,
      location: location,
      status: status,
      createdAt: now,
      expiresAt: now.add(ttl),
    );

    final result = await _honkRepository.broadcastHonk(honk).run();
    result.match(
      (failure) => emit(ActionPadState.failure(failure)),
      (_) => emit(ActionPadState.success(honk)),
    );
  }

  void reset() {
    emit(const ActionPadState.idle());
  }
}
