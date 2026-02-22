// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/honk_activity.dart';

part 'honk_activity_model.freezed.dart';
part 'honk_activity_model.g.dart';

@freezed
abstract class HonkActivityModel with _$HonkActivityModel {
  const HonkActivityModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HonkActivityModel({
    required String id,
    required String creatorId,
    required String activity,
    required String location,
    String? details,
    required int statusResetSeconds,
    required String inviteCode,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _HonkActivityModel;

  HonkActivity toDomain() => HonkActivity(
    id: id,
    creatorId: creatorId,
    activity: activity,
    location: location,
    details: details,
    statusResetSeconds: statusResetSeconds,
    inviteCode: inviteCode,
    createdAt: createdAt.toUtc(),
    updatedAt: updatedAt.toUtc(),
  );

  factory HonkActivityModel.fromJson(Map<String, dynamic> json) =>
      _$HonkActivityModelFromJson(json);
}
