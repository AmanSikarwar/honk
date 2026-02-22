// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'honk_status_option_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HonkStatusOptionModel _$HonkStatusOptionModelFromJson(
  Map<String, dynamic> json,
) => _HonkStatusOptionModel(
  statusKey: json['status_key'] as String,
  label: json['label'] as String,
  sortOrder: (json['sort_order'] as num).toInt(),
  isDefault: json['is_default'] as bool? ?? false,
  isActive: json['is_active'] as bool? ?? true,
);

Map<String, dynamic> _$HonkStatusOptionModelToJson(
  _HonkStatusOptionModel instance,
) => <String, dynamic>{
  'status_key': instance.statusKey,
  'label': instance.label,
  'sort_order': instance.sortOrder,
  'is_default': instance.isDefault,
  'is_active': instance.isActive,
};
