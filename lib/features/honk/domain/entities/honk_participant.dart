import 'package:freezed_annotation/freezed_annotation.dart';

part 'honk_participant.freezed.dart';

@freezed
abstract class HonkParticipant with _$HonkParticipant {
  const HonkParticipant._();

  const factory HonkParticipant({
    required String userId,
    required String username,
    String? fullName,
    String? profileUrl,
    required String role,
    required String effectiveStatusKey,
    DateTime? statusUpdatedAt,
    DateTime? statusExpiresAt,
  }) = _HonkParticipant;

  bool get isCreator => role == 'creator';
}
