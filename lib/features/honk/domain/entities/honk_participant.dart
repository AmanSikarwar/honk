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
    @Default('participant') String role,
    @Default('') String effectiveStatusKey,
    @Default('active') String joinStatus,
    DateTime? statusUpdatedAt,
    DateTime? statusExpiresAt,
  }) = _HonkParticipant;

  bool get isCreator => role == 'creator';
  bool get isPending => joinStatus == 'pending';
}
