// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/honk_status_option.dart';

part 'honk_status_option_model.freezed.dart';
part 'honk_status_option_model.g.dart';

@freezed
abstract class HonkStatusOptionModel with _$HonkStatusOptionModel {
  const HonkStatusOptionModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HonkStatusOptionModel({
    required String statusKey,
    required String label,
    required int sortOrder,
    @Default(false) bool isDefault,
    @Default(true) bool isActive,
  }) = _HonkStatusOptionModel;

  HonkStatusOption toDomain() => HonkStatusOption(
    statusKey: statusKey,
    label: label,
    sortOrder: sortOrder,
    isDefault: isDefault,
    isActive: isActive,
  );

  factory HonkStatusOptionModel.fromJson(Map<String, dynamic> json) =>
      _$HonkStatusOptionModelFromJson(json);
}
