// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/friendship.dart';

part 'friendship_model.freezed.dart';
part 'friendship_model.g.dart';

@freezed
abstract class FriendshipModel with _$FriendshipModel {
  const FriendshipModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory FriendshipModel({
    required String userId,
    required String friendId,
    required String status,
  }) = _FriendshipModel;

  factory FriendshipModel.fromDomain(Friendship friendship) {
    return FriendshipModel(
      userId: friendship.userId,
      friendId: friendship.friendId,
      status: friendship.status,
    );
  }

  Friendship toDomain() {
    return Friendship(userId: userId, friendId: friendId, status: status);
  }

  factory FriendshipModel.fromJson(Map<String, dynamic> json) =>
      _$FriendshipModelFromJson(json);
}
