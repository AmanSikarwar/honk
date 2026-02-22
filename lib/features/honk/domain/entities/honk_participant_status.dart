class HonkParticipantStatus {
  const HonkParticipantStatus({
    required this.activityId,
    required this.userId,
    required this.occurrenceStart,
    required this.statusKey,
    required this.updatedAt,
    required this.expiresAt,
  });

  final String activityId;
  final String userId;
  final DateTime occurrenceStart;
  final String statusKey;
  final DateTime updatedAt;
  final DateTime expiresAt;
}
