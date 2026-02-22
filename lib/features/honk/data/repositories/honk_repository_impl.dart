import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/data/failure_mapper.dart';
import '../../../../core/domain/main_failure.dart';
import '../../domain/entities/honk_activity.dart';
import '../../domain/entities/honk_activity_details.dart';
import '../../domain/entities/honk_activity_summary.dart';
import '../../domain/entities/honk_participant.dart';
import '../../domain/entities/honk_participant_candidate.dart';
import '../../domain/entities/honk_status_option.dart';
import '../../domain/repositories/i_honk_repository.dart';
import '../../domain/services/honk_recurrence_service.dart';

@LazySingleton(as: IHonkRepository)
class HonkRepositoryImpl implements IHonkRepository {
  HonkRepositoryImpl(this._supabase);

  final SupabaseClient _supabase;
  final HonkRecurrenceService _recurrenceService =
      const HonkRecurrenceService();
  static const _activityColumns =
      'id, creator_id, activity, location, details, starts_at, recurrence_rrule, recurrence_timezone, status_reset_seconds, invite_code, created_at, updated_at';
  static const Duration _requestTimeout = Duration(seconds: 15);
  static const Duration _activitiesPollInterval = Duration(seconds: 6);
  static const Duration _activityDetailsPollInterval = Duration(seconds: 4);

  @override
  TaskEither<MainFailure, List<HonkParticipantCandidate>>
  fetchEligibleParticipants() {
    return TaskEither<MainFailure, List<HonkParticipantCandidate>>.tryCatch(
      () async {
        final currentUserId = _requireCurrentUserId();
        final friendshipsResponse = await _supabase
            .from('friendships')
            .select('user_id, friend_id, status')
            .eq('status', 'accepted');

        final friendshipRows = List<Map<String, dynamic>>.from(
          friendshipsResponse as List,
        );
        final friendIds = friendshipRows
            .map((row) {
              final userId = row['user_id'] as String?;
              final friendId = row['friend_id'] as String?;
              if (userId == null || friendId == null) {
                return null;
              }
              return userId == currentUserId ? friendId : userId;
            })
            .whereType<String>()
            .where((id) => id != currentUserId)
            .toSet()
            .toList(growable: false);

        if (friendIds.isEmpty) {
          return const <HonkParticipantCandidate>[];
        }

        final profilesResponse = await _supabase
            .from('profiles')
            .select('id, username')
            .inFilter('id', friendIds);

        final rows = List<Map<String, dynamic>>.from(profilesResponse as List);
        final candidates =
            rows
                .map(
                  (row) => HonkParticipantCandidate(
                    id: row['id'] as String,
                    username: row['username'] as String,
                  ),
                )
                .toList(growable: false)
              ..sort((a, b) => a.username.compareTo(b.username));
        return candidates;
      },
      mapErrorToMainFailure,
    );
  }

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
        if (created != null) {
          return created;
        }
      } catch (_) {
        // Return a local representation so the create flow succeeds even when
        // post-create reads fail due transient network/policy issues.
      }

      final nowUtc = DateTime.now().toUtc();
      final normalizedDetails = details?.trim();
      final fallbackDetails =
          (normalizedDetails == null || normalizedDetails.isEmpty)
          ? null
          : normalizedDetails;
      return HonkActivity(
        id: activityId,
        creatorId: currentUserId,
        activity: activity.trim(),
        location: location.trim(),
        details: fallbackDetails,
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

    Timer? pollTimer;
    var isFetching = false;
    Future<void> emitSnapshot() async {
      if (isFetching) {
        return;
      }
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
        if (!controller.isClosed) {
          controller.add(right(summaries));
        }
      } catch (error, stackTrace) {
        if (!controller.isClosed) {
          controller.add(left(mapErrorToMainFailure(error, stackTrace)));
        }
      } finally {
        isFetching = false;
      }
    }

    unawaited(emitSnapshot());
    pollTimer = Timer.periodic(_activitiesPollInterval, (_) {
      unawaited(emitSnapshot());
    });

    controller.onCancel = () async {
      pollTimer?.cancel();
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
    Timer? pollTimer;
    var isFetching = false;

    Future<void> emitDetails() async {
      if (isFetching) {
        return;
      }
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

        if (!controller.isClosed) {
          controller.add(right(details));
        }
      } catch (error, stackTrace) {
        if (!controller.isClosed) {
          controller.add(left(mapErrorToMainFailure(error, stackTrace)));
        }
      } finally {
        isFetching = false;
      }
    }

    unawaited(emitDetails());
    pollTimer = Timer.periodic(_activityDetailsPollInterval, (_) {
      unawaited(emitDetails());
    });

    controller.onCancel = () async {
      pollTimer?.cancel();
    };

    return controller.stream;
  }

  Future<List<HonkActivitySummary>> _toActivitySummaries({
    required String currentUserId,
    required List<Map<String, dynamic>> rows,
  }) async {
    if (rows.isEmpty) {
      return const <HonkActivitySummary>[];
    }

    final activityIds = rows
        .map((row) => row['id'] as String?)
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
        .select('activity_id, user_id, left_at')
        .inFilter('activity_id', activityIds)
        .filter('left_at', 'is', null);

    final defaultStatusByActivity = <String, String>{};
    for (final row in List<Map<String, dynamic>>.from(
      optionsResponse as List,
    )) {
      final activityId = row['activity_id'] as String?;
      final statusKey = row['status_key'] as String?;
      if (activityId != null && statusKey != null) {
        defaultStatusByActivity[activityId] = statusKey;
      }
    }

    final participantCountByActivity = <String, int>{};
    for (final row in List<Map<String, dynamic>>.from(
      participantResponse as List,
    )) {
      final activityId = row['activity_id'] as String?;
      if (activityId == null) {
        continue;
      }
      participantCountByActivity.update(
        activityId,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }

    return rows
        .map((row) {
          final activityId = row['id'] as String;
          return HonkActivitySummary(
            id: activityId,
            activity: row['activity'] as String? ?? '',
            location: row['location'] as String? ?? '',
            details: row['details'] as String?,
            startsAt: _asDateTime(row['starts_at']),
            recurrenceRrule: row['recurrence_rrule'] as String?,
            recurrenceTimezone: row['recurrence_timezone'] as String? ?? 'UTC',
            statusResetSeconds: row['status_reset_seconds'] as int? ?? 600,
            defaultStatusKey: defaultStatusByActivity[activityId] ?? '',
            participantCount: participantCountByActivity[activityId] ?? 0,
            isCreator: (row['creator_id'] as String?) == currentUserId,
          );
        })
        .toList(growable: false);
  }

  Future<HonkActivityDetails?> _fetchActivityDetails(String activityId) async {
    final activity = await _withTimeout(_fetchActivityById(activityId));
    if (activity == null) {
      return null;
    }

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

    if (response == null) {
      return null;
    }

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

    if (response == null) {
      return null;
    }

    final row = Map<String, dynamic>.from(response);
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
    return _toActivity(row, options);
  }

  HonkActivity _toActivity(
    Map<String, dynamic> row,
    List<HonkStatusOption> options,
  ) {
    return HonkActivity(
      id: row['id'] as String,
      creatorId: row['creator_id'] as String,
      activity: row['activity'] as String? ?? '',
      location: row['location'] as String? ?? '',
      details: row['details'] as String?,
      startsAt: _asDateTime(row['starts_at']),
      recurrenceRrule: row['recurrence_rrule'] as String?,
      recurrenceTimezone: row['recurrence_timezone'] as String? ?? 'UTC',
      statusResetSeconds: row['status_reset_seconds'] as int? ?? 600,
      inviteCode: row['invite_code'] as String? ?? '',
      createdAt: _asDateTime(row['created_at']),
      updatedAt: _asDateTime(row['updated_at']),
      statusOptions: options,
    );
  }

  List<HonkStatusOption> _parseStatusOptions(dynamic raw) {
    if (raw is! List) {
      return const <HonkStatusOption>[];
    }

    return raw
        .map((entry) => Map<String, dynamic>.from(entry as Map))
        .map(
          (row) => HonkStatusOption(
            statusKey: row['status_key'] as String? ?? '',
            label: row['label'] as String? ?? '',
            sortOrder: row['sort_order'] as int? ?? 0,
            isDefault: row['is_default'] as bool? ?? false,
            isActive: row['is_active'] as bool? ?? true,
          ),
        )
        .toList(growable: false)
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  List<HonkParticipant> _parseParticipants(dynamic raw) {
    if (raw is! List) {
      return const <HonkParticipant>[];
    }

    return raw
        .map((entry) => Map<String, dynamic>.from(entry as Map))
        .map(
          (row) => HonkParticipant(
            userId: row['user_id'] as String? ?? '',
            username: row['username'] as String? ?? '',
            role: row['role'] as String? ?? 'participant',
            effectiveStatusKey: row['effective_status_key'] as String? ?? '',
            statusUpdatedAt: _asDateTimeOrNull(row['status_updated_at']),
            statusExpiresAt: _asDateTimeOrNull(row['status_expires_at']),
          ),
        )
        .toList(growable: false);
  }

  List<Map<String, dynamic>> _serializeStatusOptions(
    List<HonkStatusOption> options,
  ) {
    return options
        .map(
          (option) => {
            'status_key': option.statusKey.trim(),
            'label': option.label.trim(),
            'sort_order': option.sortOrder,
            'is_default': option.isDefault,
          },
        )
        .toList(growable: false);
  }

  DateTime _asDateTime(dynamic value) {
    if (value is DateTime) {
      return value.toUtc();
    }
    if (value is String) {
      return DateTime.parse(value).toUtc();
    }
    throw const MainFailure.databaseFailure('Invalid datetime value.');
  }

  DateTime? _asDateTimeOrNull(dynamic value) {
    if (value == null) {
      return null;
    }
    return _asDateTime(value);
  }

  String _requireCurrentUserId() {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw const MainFailure.authenticationFailure(
        'User must be authenticated for activity operations.',
      );
    }
    return userId;
  }

  Future<T> _withTimeout<T>(Future<T> future) {
    return future.timeout(_requestTimeout);
  }
}
