import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/data/failure_mapper.dart';
import '../../../../core/domain/main_failure.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/i_friend_repository.dart';
import '../models/profile_model.dart';

@LazySingleton(as: IFriendRepository)
class FriendRepositoryImpl implements IFriendRepository {
  FriendRepositoryImpl(this._supabase);

  final SupabaseClient _supabase;

  @override
  TaskEither<MainFailure, List<Profile>> searchUsers({required String query}) {
    return TaskEither<MainFailure, List<Profile>>.tryCatch(() async {
      final currentUserId = _requireCurrentUserId();
      final trimmedQuery = query.trim();

      if (trimmedQuery.isEmpty) {
        return const <Profile>[];
      }

      final response = await _supabase
          .from('profiles')
          .select('id, username, fcm_token')
          .ilike('username', '%${_escapeLikePattern(trimmedQuery)}%')
          .neq('id', currentUserId)
          .limit(20);

      final rows = List<Map<String, dynamic>>.from(response as List);
      return rows
          .map((row) => ProfileModel.fromJson(row).toDomain())
          .toList(growable: false);
    }, mapErrorToMainFailure);
  }

  @override
  TaskEither<MainFailure, Unit> addFriend({required String friendId}) {
    return TaskEither<MainFailure, Unit>.tryCatch(() async {
      final currentUserId = _requireCurrentUserId();
      if (friendId == currentUserId) {
        throw const MainFailure.databaseFailure(
          'Cannot add yourself as friend.',
        );
      }

      await _supabase.from('friendships').upsert([
        {'user_id': currentUserId, 'friend_id': friendId, 'status': 'accepted'},
        {'user_id': friendId, 'friend_id': currentUserId, 'status': 'accepted'},
      ], onConflict: 'user_id,friend_id');

      return unit;
    }, mapErrorToMainFailure);
  }

  @override
  TaskEither<MainFailure, List<Profile>> fetchFriends() {
    return TaskEither<MainFailure, List<Profile>>.tryCatch(() async {
      final currentUserId = _requireCurrentUserId();

      final friendshipsResponse = await _supabase
          .from('friendships')
          .select('user_id, friend_id, status')
          .eq('status', 'accepted');

      final friendshipRows = List<Map<String, dynamic>>.from(
        friendshipsResponse as List,
      );
      final friendIds = friendshipRows
          .map((row) {
            final userId = row['user_id'] as String?;
            final friendId = row['friend_id'] as String?;
            if (userId == null || friendId == null) {
              return null;
            }
            return userId == currentUserId ? friendId : userId;
          })
          .whereType<String>()
          .where((id) => id != currentUserId)
          .toSet()
          .toList(growable: false);

      if (friendIds.isEmpty) {
        return const <Profile>[];
      }

      final profilesResponse = await _supabase
          .from('profiles')
          .select('id, username, fcm_token')
          .inFilter('id', friendIds);

      final profileRows = List<Map<String, dynamic>>.from(
        profilesResponse as List,
      );
      final friends =
          profileRows
              .map((row) => ProfileModel.fromJson(row).toDomain())
              .toList(growable: false)
            ..sort((a, b) => a.username.compareTo(b.username));

      return friends;
    }, mapErrorToMainFailure);
  }

  String _requireCurrentUserId() {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw const MainFailure.authenticationFailure(
        'User must be authenticated for friendship operations.',
      );
    }
    return userId;
  }

  String _escapeLikePattern(String input) {
    return input
        .replaceAll(r'\', r'\\')
        .replaceAll('%', r'\%')
        .replaceAll('_', r'\_');
  }
}
