class HonkParticipant {
  const HonkParticipant({
    required this.userId,
    required this.username,
    required this.role,
    required this.effectiveStatusKey,
    required this.statusUpdatedAt,
    required this.statusExpiresAt,
  });

  final String userId;
  final String username;
  final String role;
  final String effectiveStatusKey;
  final DateTime? statusUpdatedAt;
  final DateTime? statusExpiresAt;

  bool get isCreator => role == 'creator';
}
