import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/main_failure.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/i_friend_repository.dart';

part 'friend_management_cubit.freezed.dart';
part 'friend_management_state.dart';

@injectable
class FriendManagementCubit extends Cubit<FriendManagementState> {
  FriendManagementCubit(this._friendRepository)
    : super(const FriendManagementState()) {
    _startWatching();
  }

  final IFriendRepository _friendRepository;
  int _searchRequestCounter = 0;
  StreamSubscription<dynamic>? _friendsSub;

  void _startWatching() {
    _friendsSub?.cancel();
    emit(state.copyWith(isLoading: true, failure: null));
    _friendsSub = _friendRepository.watchFriends().listen((result) {
      result.match(
        (failure) => emit(state.copyWith(isLoading: false, failure: failure)),
        (friends) => emit(
          state.copyWith(isLoading: false, friends: friends, failure: null),
        ),
      );
    });
  }

  /// Manually triggers a fresh fetch and re-starts the realtime subscription.
  Future<void> loadFriends() async {
    _startWatching();
  }

  Future<void> searchUsers(String query) async {
    final trimmed = query.trim();
    final requestId = ++_searchRequestCounter;
    emit(state.copyWith(searchQuery: trimmed, failure: null));

    if (trimmed.isEmpty) {
      emit(state.copyWith(searchResults: const <Profile>[]));
      return;
    }

    final result = await _friendRepository.searchUsers(query: trimmed).run();
    if (isClosed || requestId != _searchRequestCounter) {
      return;
    }

    result.match(
      (failure) => emit(state.copyWith(failure: failure)),
      (results) => emit(state.copyWith(searchResults: results, failure: null)),
    );
  }

  Future<void> addFriend(String friendId) async {
    emit(state.copyWith(isLoading: true, failure: null));

    final addResult = await _friendRepository
        .addFriend(friendId: friendId)
        .run();

    addResult.match(
      (failure) => emit(state.copyWith(isLoading: false, failure: failure)),
      (_) {
        // Remove from search results immediately for snappy UX.
        // The friends list itself updates automatically via the realtime stream.
        emit(
          state.copyWith(
            isLoading: false,
            searchResults: state.searchResults
                .where((profile) => profile.id != friendId)
                .toList(growable: false),
          ),
        );
      },
    );
  }

  @override
  Future<void> close() async {
    await _friendsSub?.cancel();
    return super.close();
  }
}
