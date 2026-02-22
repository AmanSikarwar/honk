import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/data/failure_mapper.dart';
import '../../../../core/domain/main_failure.dart';
import '../../../friends/domain/repositories/i_friend_repository.dart';
import '../../domain/entities/honk_activity.dart';
import '../../domain/entities/honk_activity_details.dart';
import '../../domain/entities/honk_activity_summary.dart';
import '../../domain/entities/honk_participant.dart';
import '../../domain/entities/honk_participant_candidate.dart';
import '../../domain/entities/honk_status_option.dart';
import '../../domain/repositories/i_honk_repository.dart';
import '../../domain/services/honk_recurrence_service.dart';
import '../models/honk_activity_model.dart';
import '../models/honk_participant_model.dart';
import '../models/honk_status_option_model.dart';

@LazySingleton(as: IHonkRepository)
class HonkRepositoryImpl implements IHonkRepository {
  HonkRepositoryImpl(this._supabase, this._friendRepository);

  final SupabaseClient _supabase;
  final IFriendRepository _friendRepository;
  final HonkRecurrenceService _recurrenceService =
      const HonkRecurrenceService();

  static const Duration _requestTimeout = Duration(seconds: 15);
  static const _activityColumns =
      'id, creator_id, activity, location, details, starts_at, recurrence_rrule, '
      'recurrence_timezone, status_reset_seconds, invite_code, created_at, updated_at';

  // ── Participants ─────────────────────────────────────────────────────────────

  @override
  TaskEither<MainFailure, List<HonkParticipantCandidate>>
  fetchEligibleParticipants() {
    return _friendRepository.fetchFriends().map(
      (friends) => friends
          .map((f) => HonkParticipantCandidate(id: f.id, username: f.username))
          .toList(growable: false),
    );
  }

  // ── Mutations ─────────────────────────────────────────────────────────────────

  @override
  TaskEither<MainFailure, HonkActivity> createActivity({
    required String activity,
    required String location,
    String? details,
    required DateTime startsAt,
    String? recurrenceRrule,
    required String recurrenceTimezone,
    required int statusResetSeconds,
    required List<HonkStatusOption> statusOptions,
    required List<String> participantIds,
  }) {
    return TaskEither<MainFailure, HonkActivity>.tryCatch(() async {
      final currentUserId = _requireCurrentUserId();
      final response = await _withTimeout(
        _supabase.rpc(
          'create_honk_activity',
          params: {
            'p_activity': activity,
            'p_location': location,
            'p_details': details,
            'p_starts_at': startsAt.toUtc().toIso8601String(),
            'p_recurrence_rrule': recurrenceRrule,
            'p_recurrence_timezone': recurrenceTimezone,
            'p_status_reset_seconds': statusResetSeconds,
            'p_status_options': _serializeStatusOptions(statusOptions),
            'p_participant_ids': participantIds,
          },
        ),
      );

      final row = Map<String, dynamic>.from(response as Map);
      final activityId = row['activity_id'] as String?;
      if (activityId == null || activityId.isEmpty) {
        throw const MainFailure.databaseFailure(
          'Failed to create activity. Missing activity id.',
        );
      }
      final inviteCode = row['invite_code'] as String? ?? '';

      try {
        final created = await _withTimeout(_fetchActivityById(activityId));
        if (created != null) return created;
      } catch (_) {
        // Fall through.
      }

      final nowUtc = DateTime.now().toUtc();
      final trimmedDetails = details?.trim();
      return HonkActivity(
        id: activityId,
        creatorId: currentUserId,
        activity: activity.trim(),
        location: location.trim(),
        details: (trimmedDetails == null || trimmedDetails.isEmpty)
            ? null
            : trimmedDetails,
        startsAt: startsAt.toUtc(),
        recurrenceRrule: recurrenceRrule?.trim().isEmpty == true
            ? null
            : recurrenceRrule?.trim(),
        recurrenceTimezone: recurrenceTimezone.trim().isEmpty
            ? 'UTC'
            : recurrenceTimezone.trim(),
        statusResetSeconds: statusResetSeconds,
        inviteCode: inviteCode,
        createdAt: nowUtc,
        updatedAt: nowUtc,
        statusOptions: statusOptions,
      );
    }, mapErrorToMainFailure);
  }

  @override
  TaskEither<MainFailure, HonkActivity> updateActivity({
    required String activityId,
    required String activity,
    required String location,
    String? details,
    required DateTime startsAt,
    String? recurrenceRrule,
    required String recurrenceTimezone,
    required int statusResetSeconds,
    required List<HonkStatusOption> statusOptions,
  }) {
    return TaskEither<MainFailure, HonkActivity>.tryCatch(() async {
      _requireCurrentUserId();
      await _withTimeout(
        _supabase.rpc(
          'update_honk_activity',
          params: {
            'p_activity_id': activityId,
            'p_activity': activity,
            'p_location': location,
            'p_details': details,
            'p_starts_at': startsAt.toUtc().toIso8601String(),
            'p_recurrence_rrule': recurrenceRrule,
            'p_recurrence_timezone': recurrenceTimezone,
            'p_status_reset_seconds': statusResetSeconds,
            'p_status_options': _serializeStatusOptions(statusOptions),
          },
        ),
      );

      final updated = await _withTimeout(_fetchActivityById(activityId));
      if (updated == null) {
        throw const MainFailure.databaseFailure(
          'Updated activity could not be loaded.',
        );
      }
      return updated;
    }, mapErrorToMainFailure);
  }

  @override
  TaskEither<MainFailure, Unit> deleteActivity({required String activityId}) {
    return TaskEither<MainFailure, Unit>.tryCatch(() async {
      final currentUserId = _requireCurrentUserId();
      await _withTimeout(
        _supabase
            .from('honk_activities')
            .delete()
            .eq('id', activityId)
            .eq('creator_id', currentUserId),
      );
      return unit;
    }, mapErrorToMainFailure);
  }

  @override
  TaskEither<MainFailure, String> rotateInvite({required String activityId}) {
    return TaskEither<MainFailure, String>.tryCatch(() async {
      _requireCurrentUserId();
      final response = await _withTimeout(
        _supabase.rpc(
          'rotate_honk_invite_code',
          params: {'p_activity_id': activityId},
        ),
      );
      final row = Map<String, dynamic>.from(response as Map);
      final code = row['invite_code'] as String?;
      if (code == null || code.isEmpty) {
        throw const MainFailure.databaseFailure(
          'Failed to rotate invite code.',
        );
      }
      return code;
    }, mapErrorToMainFailure);
  }

  @override
  TaskEither<MainFailure, String> joinByInviteCode({
    required String inviteCode,
  }) {
    return TaskEither<MainFailure, String>.tryCatch(() async {
      _requireCurrentUserId();
      final response = await _withTimeout(
        _supabase.rpc(
          'join_honk_activity_by_code',
          params: {'p_invite_code': inviteCode.trim()},
        ),
      );
      final row = Map<String, dynamic>.from(response as Map);
      final activityId = row['activity_id'] as String?;
      if (activityId == null || activityId.isEmpty) {
        throw const MainFailure.databaseFailure('Join failed.');
      }
      return activityId;
    }, mapErrorToMainFailure);
  }

  @override
  TaskEither<MainFailure, Unit> leaveActivity({required String activityId}) {
    return TaskEither<MainFailure, Unit>.tryCatch(() async {
      _requireCurrentUserId();
      await _withTimeout(
        _supabase.rpc(
          'leave_honk_activity',
          params: {'p_activity_id': activityId},
        ),
      );
      return unit;
    }, mapErrorToMainFailure);
  }

  @override
  TaskEither<MainFailure, Unit> setParticipantStatus({
    required String activityId,
    required String statusKey,
    DateTime? occurrenceStart,
  }) {
    return TaskEither<MainFailure, Unit>.tryCatch(() async {
      _requireCurrentUserId();
      await _withTimeout(
        _supabase.rpc(
          'set_honk_status',
          params: {
            'p_activity_id': activityId,
            'p_status_key': statusKey,
            'p_occurrence_start': occurrenceStart?.toUtc().toIso8601String(),
          },
        ),
      );
      return unit;
    }, mapErrorToMainFailure);
  }

  // ── Realtime streams ──────────────────────────────────────────────────────────

  @override
  Stream<Either<MainFailure, List<HonkActivitySummary>>> watchActivities() {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      return Stream.value(
        left(
          const MainFailure.authenticationFailure(
            'User must be authenticated to watch activities.',
          ),
        ),
      );
    }

    final controller =
        StreamController<Either<MainFailure, List<HonkActivitySummary>>>();
    RealtimeChannel? channel;
    var isFetching = false;

    Future<void> emitSnapshot() async {
      if (isFetching || controller.isClosed) return;
      isFetching = true;
      try {
        final response = await _withTimeout(
          _supabase
              .from('honk_activities')
              .select(_activityColumns)
              .order('updated_at', ascending: false),
        );
        final rows = List<Map<String, dynamic>>.from(response as List);
        final summaries = await _toActivitySummaries(
          currentUserId: currentUserId,
          rows: rows,
        );
        if (!controller.isClosed) controller.add(right(summaries));
      } catch (e, st) {
        if (!controller.isClosed) {
          controller.add(left(mapErrorToMainFailure(e, st)));
        }
      } finally {
        isFetching = false;
      }
    }

    unawaited(emitSnapshot());

    channel = _supabase
        .channel(
          'feed_${currentUserId}_${DateTime.now().millisecondsSinceEpoch}',
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'honk_activities',
          callback: (_) => unawaited(emitSnapshot()),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'honk_activity_participants',
          callback: (_) => unawaited(emitSnapshot()),
        )
        .subscribe();

    controller.onCancel = () async {
      await channel?.unsubscribe();
    };

    return controller.stream;
  }

  @override
  Stream<Either<MainFailure, HonkActivityDetails>> watchActivityDetails({
    required String activityId,
  }) {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      return Stream.value(
        left(
          const MainFailure.authenticationFailure(
            'User must be authenticated to watch activity details.',
          ),
        ),
      );
    }

    final controller =
        StreamController<Either<MainFailure, HonkActivityDetails>>();
    RealtimeChannel? channel;
    var isFetching = false;

    Future<void> emitDetails() async {
      if (isFetching || controller.isClosed) return;
      isFetching = true;
      try {
        final details = await _withTimeout(_fetchActivityDetails(activityId));
        if (details == null) {
          if (!controller.isClosed) {
            controller.add(
              left(
                const MainFailure.databaseFailure('Activity no longer exists.'),
              ),
            );
          }
          return;
        }
        if (!controller.isClosed) controller.add(right(details));
      } catch (e, st) {
        if (!controller.isClosed) {
          controller.add(left(mapErrorToMainFailure(e, st)));
        }
      } finally {
        isFetching = false;
      }
    }

    unawaited(emitDetails());

    channel = _supabase
        .channel(
          'details_${activityId}_${DateTime.now().millisecondsSinceEpoch}',
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'honk_activities',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: activityId,
          ),
          callback: (_) => unawaited(emitDetails()),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'honk_activity_participants',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'activity_id',
            value: activityId,
          ),
          callback: (_) => unawaited(emitDetails()),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'honk_participant_statuses',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'activity_id',
            value: activityId,
          ),
          callback: (_) => unawaited(emitDetails()),
        )
        .subscribe();

    controller.onCancel = () async {
      await channel?.unsubscribe();
    };

    return controller.stream;
  }

  // ── Private helpers ───────────────────────────────────────────────────────────

  Future<List<HonkActivitySummary>> _toActivitySummaries({
    required String currentUserId,
    required List<Map<String, dynamic>> rows,
  }) async {
    if (rows.isEmpty) return const <HonkActivitySummary>[];

    final activityIds = rows
        .map((r) => r['id'] as String?)
        .whereType<String>()
        .toList(growable: false);

    final optionsResponse = await _supabase
        .from('honk_activity_status_options')
        .select('activity_id, status_key')
        .inFilter('activity_id', activityIds)
        .eq('is_active', true)
        .eq('is_default', true);

    final participantResponse = await _supabase
        .from('honk_activity_participants')
        .select('activity_id, user_id')
        .inFilter('activity_id', activityIds)
        .filter('left_at', 'is', null);

    final defaultStatusByActivity = <String, String>{};
    for (final row in List<Map<String, dynamic>>.from(
      optionsResponse as List,
    )) {
      final aId = row['activity_id'] as String?;
      final sk = row['status_key'] as String?;
      if (aId != null && sk != null) defaultStatusByActivity[aId] = sk;
    }

    final participantCountByActivity = <String, int>{};
    for (final row in List<Map<String, dynamic>>.from(
      participantResponse as List,
    )) {
      final aId = row['activity_id'] as String?;
      if (aId == null) continue;
      participantCountByActivity.update(aId, (v) => v + 1, ifAbsent: () => 1);
    }

    return rows
        .map((row) {
          final model = HonkActivityModel.fromJson(row);
          final aId = model.id;
          return HonkActivitySummary(
            id: aId,
            activity: model.activity,
            location: model.location,
            details: model.details,
            startsAt: model.startsAt.toUtc(),
            recurrenceRrule: model.recurrenceRrule,
            recurrenceTimezone: model.recurrenceTimezone,
            statusResetSeconds: model.statusResetSeconds,
            defaultStatusKey: defaultStatusByActivity[aId] ?? '',
            participantCount: participantCountByActivity[aId] ?? 0,
            isCreator: model.creatorId == currentUserId,
          );
        })
        .toList(growable: false);
  }

  Future<HonkActivityDetails?> _fetchActivityDetails(String activityId) async {
    final activity = await _withTimeout(_fetchActivityById(activityId));
    if (activity == null) return null;

    final nowUtc = DateTime.now().toUtc();
    final occurrenceStart = _recurrenceService.resolveOccurrence(
      startsAt: activity.startsAt,
      recurrenceRrule: activity.recurrenceRrule,
      nowUtc: nowUtc,
    );

    final response = await _withTimeout(
      _supabase.rpc(
        'get_honk_activity_details',
        params: {
          'p_activity_id': activityId,
          'p_occurrence_start': occurrenceStart.toIso8601String(),
        },
      ),
    );
    if (response == null) return null;

    final data = Map<String, dynamic>.from(response as Map);
    final options = _parseStatusOptions(data['status_options']);
    final participants = _parseParticipants(data['participants']);
    final currentUserId = _requireCurrentUserId();

    return HonkActivityDetails(
      activity: activity.copyWith(statusOptions: options),
      occurrenceStart: _asDateTime(data['occurrence_start']),
      statusOptions: options,
      participants: participants,
      currentUserId: currentUserId,
    );
  }

  Future<HonkActivity?> _fetchActivityById(String activityId) async {
    final response = await _withTimeout(
      _supabase
          .from('honk_activities')
          .select(_activityColumns)
          .eq('id', activityId)
          .maybeSingle(),
    );
    if (response == null) return null;

    final optionsResponse = await _withTimeout(
      _supabase
          .from('honk_activity_status_options')
          .select(
            'activity_id, status_key, label, sort_order, is_default, is_active',
          )
          .eq('activity_id', activityId)
          .eq('is_active', true)
          .order('sort_order', ascending: true),
    );
    final options = _parseStatusOptions(optionsResponse);
    return HonkActivityModel.fromJson(
      Map<String, dynamic>.from(response),
    ).toDomain().copyWith(statusOptions: options);
  }

  List<HonkStatusOption> _parseStatusOptions(dynamic raw) {
    if (raw is! List) return const <HonkStatusOption>[];
    return raw
        .map(
          (e) => HonkStatusOptionModel.fromJson(
            Map<String, dynamic>.from(e as Map),
          ).toDomain(),
        )
        .toList(growable: false)
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  List<HonkParticipant> _parseParticipants(dynamic raw) {
    if (raw is! List) return const <HonkParticipant>[];
    return raw
        .map(
          (e) => HonkParticipantModel.fromJson(
            Map<String, dynamic>.from(e as Map),
          ).toDomain(),
        )
        .toList(growable: false);
  }

  List<Map<String, dynamic>> _serializeStatusOptions(
    List<HonkStatusOption> options,
  ) {
    return options
        .map(
          (o) => {
            'status_key': o.statusKey.trim(),
            'label': o.label.trim(),
            'sort_order': o.sortOrder,
            'is_default': o.isDefault,
          },
        )
        .toList(growable: false);
  }

  DateTime _asDateTime(dynamic value) {
    if (value is DateTime) return value.toUtc();
    if (value is String) return DateTime.parse(value).toUtc();
    throw const MainFailure.databaseFailure('Invalid datetime value.');
  }

  String _requireCurrentUserId() {
    final id = _supabase.auth.currentUser?.id;
    if (id == null) {
      throw const MainFailure.authenticationFailure(
        'User must be authenticated for activity operations.',
      );
    }
    return id;
  }

  Future<T> _withTimeout<T>(Future<T> future) =>
      future.timeout(_requestTimeout);
}
