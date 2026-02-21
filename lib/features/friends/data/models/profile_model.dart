// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/profile.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
abstract class ProfileModel with _$ProfileModel {
  const ProfileModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ProfileModel({
    required String id,
    required String username,
    String? fcmToken,
  }) = _ProfileModel;

  factory ProfileModel.fromDomain(Profile profile) {
    return ProfileModel(
      id: profile.id,
      username: profile.username,
      fcmToken: profile.fcmToken,
    );
  }

  Profile toDomain() {
    return Profile(id: id, username: username, fcmToken: fcmToken);
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}
