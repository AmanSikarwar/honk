import 'honk_status_option.dart';

class HonkActivity {
  const HonkActivity({
    required this.id,
    required this.creatorId,
    required this.activity,
    required this.location,
    required this.details,
    required this.startsAt,
    required this.recurrenceRrule,
    required this.recurrenceTimezone,
    required this.statusResetSeconds,
    required this.inviteCode,
    required this.createdAt,
    required this.updatedAt,
    required this.statusOptions,
  });

  final String id;
  final String creatorId;
  final String activity;
  final String location;
  final String? details;
  final DateTime startsAt;
  final String? recurrenceRrule;
  final String recurrenceTimezone;
  final int statusResetSeconds;
  final String inviteCode;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<HonkStatusOption> statusOptions;

  HonkActivity copyWith({
    String? id,
    String? creatorId,
    String? activity,
    String? location,
    String? details,
    DateTime? startsAt,
    String? recurrenceRrule,
    String? recurrenceTimezone,
    int? statusResetSeconds,
    String? inviteCode,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<HonkStatusOption>? statusOptions,
  }) {
    return HonkActivity(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      activity: activity ?? this.activity,
      location: location ?? this.location,
      details: details ?? this.details,
      startsAt: startsAt ?? this.startsAt,
      recurrenceRrule: recurrenceRrule ?? this.recurrenceRrule,
      recurrenceTimezone: recurrenceTimezone ?? this.recurrenceTimezone,
      statusResetSeconds: statusResetSeconds ?? this.statusResetSeconds,
      inviteCode: inviteCode ?? this.inviteCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      statusOptions: statusOptions ?? this.statusOptions,
    );
  }
}
