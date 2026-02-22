// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'honk_activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HonkActivityModel _$HonkActivityModelFromJson(Map<String, dynamic> json) =>
    _HonkActivityModel(
      id: json['id'] as String,
      creatorId: json['creator_id'] as String,
      activity: json['activity'] as String,
      location: json['location'] as String,
      details: json['details'] as String?,
      statusResetSeconds: (json['status_reset_seconds'] as num).toInt(),
      inviteCode: json['invite_code'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$HonkActivityModelToJson(_HonkActivityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creator_id': instance.creatorId,
      'activity': instance.activity,
      'location': instance.location,
      'details': instance.details,
      'status_reset_seconds': instance.statusResetSeconds,
      'invite_code': instance.inviteCode,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
