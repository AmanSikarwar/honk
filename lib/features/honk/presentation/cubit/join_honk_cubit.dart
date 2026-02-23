import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/domain/main_failure.dart';
import '../../domain/repositories/i_honk_repository.dart';

part 'join_honk_state.dart';
part 'join_honk_cubit.freezed.dart';

@injectable
class JoinHonkCubit extends Cubit<JoinHonkState> {
  JoinHonkCubit(this._repository, this._supabase) : super(const JoinHonkState.idle());

  final IHonkRepository _repository;
  final SupabaseClient _supabase;
  RealtimeChannel? _approvalChannel;

  Future<void> joinByCode(String code) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) return;
    emit(const JoinHonkState.loading());
    final result = await _repository.joinByInviteCode(inviteCode: trimmed).run();
    result.match((failure) => emit(JoinHonkState.failure(failure)), (record) {
      if (record.isPending) {
        emit(JoinHonkState.pendingApproval(record.activityId));
        _watchForApproval(record.activityId);
      } else {
        emit(JoinHonkState.success(record.activityId));
      }
    });
  }

  void _watchForApproval(String activityId) {
    _approvalChannel?.unsubscribe();
    _approvalChannel = _supabase
        .channel('join_approval_$activityId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'honk_activity_participants',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'activity_id',
            value: activityId,
          ),
          callback: (payload) {
            final newRecord = payload.newRecord;
            if (newRecord['join_status'] == 'active') {
              _approvalChannel?.unsubscribe();
              _approvalChannel = null;
              emit(JoinHonkState.success(activityId));
            }
          },
        )
        .subscribe();
  }

  void reset() {
    _approvalChannel?.unsubscribe();
    _approvalChannel = null;
    emit(const JoinHonkState.idle());
  }

  @override
  Future<void> close() {
    _approvalChannel?.unsubscribe();
    return super.close();
  }
}
