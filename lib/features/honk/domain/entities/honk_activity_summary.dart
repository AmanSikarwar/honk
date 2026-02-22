class HonkActivitySummary {
  const HonkActivitySummary({
    required this.id,
    required this.activity,
    required this.location,
    required this.details,
    required this.startsAt,
    required this.recurrenceRrule,
    required this.recurrenceTimezone,
    required this.statusResetSeconds,
    required this.defaultStatusKey,
    required this.participantCount,
    required this.isCreator,
  });

  final String id;
  final String activity;
  final String location;
  final String? details;
  final DateTime startsAt;
  final String? recurrenceRrule;
  final String recurrenceTimezone;
  final int statusResetSeconds;
  final String defaultStatusKey;
  final int participantCount;
  final bool isCreator;
}
