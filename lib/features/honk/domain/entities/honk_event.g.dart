// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'honk_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HonkEvent _$HonkEventFromJson(Map<String, dynamic> json) => _HonkEvent(
  id: json['id'] as String,
  userId: json['userId'] as String,
  location: json['location'] as String,
  status: json['status'] as String,
  details: json['details'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  expiresAt: DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$HonkEventToJson(_HonkEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'location': instance.location,
      'status': instance.status,
      'details': instance.details,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
    };
