// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/honk_event.dart';

part 'honk_event_model.freezed.dart';
part 'honk_event_model.g.dart';

@freezed
abstract class HonkEventModel with _$HonkEventModel {
  const HonkEventModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HonkEventModel({
    required String id,
    required String userId,
    required String location,
    required String status,
    required DateTime createdAt,
    required DateTime expiresAt,
  }) = _HonkEventModel;

  factory HonkEventModel.fromDomain(HonkEvent honk) {
    return HonkEventModel(
      id: honk.id,
      userId: honk.userId,
      location: honk.location,
      status: honk.status,
      createdAt: honk.createdAt,
      expiresAt: honk.expiresAt,
    );
  }

  HonkEvent toDomain() {
    return HonkEvent(
      id: id,
      userId: userId,
      location: location,
      status: status,
      createdAt: createdAt,
      expiresAt: expiresAt,
    );
  }

  factory HonkEventModel.fromJson(Map<String, dynamic> json) =>
      _$HonkEventModelFromJson(json);
}
