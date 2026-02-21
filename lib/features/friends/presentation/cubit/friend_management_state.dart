part of 'friend_management_cubit.dart';

@freezed
abstract class FriendManagementState with _$FriendManagementState {
  const factory FriendManagementState({
    @Default(false) bool isLoading,
    @Default(<Profile>[]) List<Profile> friends,
    @Default(<Profile>[]) List<Profile> searchResults,
    @Default('') String searchQuery,
    MainFailure? failure,
  }) = _FriendManagementState;
}
