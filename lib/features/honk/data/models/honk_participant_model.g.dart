// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'honk_participant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HonkParticipantModel _$HonkParticipantModelFromJson(
  Map<String, dynamic> json,
) => _HonkParticipantModel(
  userId: json['user_id'] as String,
  username: json['username'] as String,
  fullName: json['full_name'] as String?,
  profileUrl: json['profile_url'] as String?,
  role: json['role'] as String? ?? 'participant',
  effectiveStatusKey: json['effective_status_key'] as String? ?? '',
  joinStatus: json['join_status'] as String? ?? 'active',
  statusUpdatedAt: json['status_updated_at'] == null
      ? null
      : DateTime.parse(json['status_updated_at'] as String),
  statusExpiresAt: json['status_expires_at'] == null
      ? null
      : DateTime.parse(json['status_expires_at'] as String),
);

Map<String, dynamic> _$HonkParticipantModelToJson(
  _HonkParticipantModel instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'username': instance.username,
  'full_name': instance.fullName,
  'profile_url': instance.profileUrl,
  'role': instance.role,
  'effective_status_key': instance.effectiveStatusKey,
  'join_status': instance.joinStatus,
  'status_updated_at': instance.statusUpdatedAt?.toIso8601String(),
  'status_expires_at': instance.statusExpiresAt?.toIso8601String(),
};
