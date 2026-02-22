// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/honk_participant.dart';

part 'honk_participant_model.freezed.dart';
part 'honk_participant_model.g.dart';

@freezed
abstract class HonkParticipantModel with _$HonkParticipantModel {
  const HonkParticipantModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HonkParticipantModel({
    required String userId,
    required String username,
    required String role,
    required String effectiveStatusKey,
    DateTime? statusUpdatedAt,
    DateTime? statusExpiresAt,
  }) = _HonkParticipantModel;

  HonkParticipant toDomain() => HonkParticipant(
    userId: userId,
    username: username,
    role: role,
    effectiveStatusKey: effectiveStatusKey,
    statusUpdatedAt: statusUpdatedAt?.toUtc(),
    statusExpiresAt: statusExpiresAt?.toUtc(),
  );

  factory HonkParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$HonkParticipantModelFromJson(json);
}
