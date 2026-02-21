// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'honk_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HonkEventModel _$HonkEventModelFromJson(Map<String, dynamic> json) =>
    _HonkEventModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      location: json['location'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$HonkEventModelToJson(_HonkEventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'location': instance.location,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'expires_at': instance.expiresAt.toIso8601String(),
    };
