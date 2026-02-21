import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/data/failure_mapper.dart';
import '../../../../core/domain/main_failure.dart';
import '../../domain/entities/honk_event.dart';
import '../../domain/entities/honk_details.dart';
import '../../domain/repositories/i_honk_repository.dart';
import '../models/honk_event_model.dart';

@LazySingleton(as: IHonkRepository)
class HonkRepositoryImpl implements IHonkRepository {
  HonkRepositoryImpl(this._supabase);

  final SupabaseClient _supabase;

  @override
  TaskEither<MainFailure, Unit> broadcastHonk(HonkEvent honk) {
    return TaskEither<MainFailure, Unit>.tryCatch(() async {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw const MainFailure.authenticationFailure(
          'User must be authenticated to honk.',
        );
      }

      final model = HonkEventModel.fromDomain(honk).copyWith(userId: user.id);

      await _supabase.from('honks').insert({
        'user_id': model.userId,
        'location': model.location,
        'status': model.status,
        'created_at': model.createdAt.toUtc().toIso8601String(),
        'expires_at': model.expiresAt.toUtc().toIso8601String(),
      });

      return unit;
    }, mapErrorToMainFailure);
  }

  @override
  TaskEither<MainFailure, HonkDetails?> fetchHonkDetails({
    required String honkId,
  }) {
    return TaskEither<MainFailure, HonkDetails?>.tryCatch(() async {
      final trimmedHonkId = honkId.trim();
      if (trimmedHonkId.isEmpty) {
        return null;
      }

      final honkResponse = await _supabase
          .from('honks')
          .select('id, user_id, location, status, created_at, expires_at')
          .eq('id', trimmedHonkId)
          .maybeSingle();

      if (honkResponse == null) {
        return null;
      }

      final honk = HonkEventModel.fromJson(
        Map<String, dynamic>.from(honkResponse),
      ).toDomain();

      final profileResponse = await _supabase
          .from('profiles')
          .select('username')
          .eq('id', honk.userId)
          .maybeSingle();

      return HonkDetails(
        honk: honk,
        senderUsername: profileResponse == null
            ? null
            : profileResponse['username'] as String?,
      );
    }, mapErrorToMainFailure);
  }

  @override
  Stream<Either<MainFailure, List<HonkEvent>>> watchFriendsHonks() {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      return Stream.value(
        left(
          const MainFailure.authenticationFailure(
            'User must be authenticated to watch honks.',
          ),
        ),
      );
    }

    final controller = StreamController<Either<MainFailure, List<HonkEvent>>>();
    StreamSubscription<List<Map<String, dynamic>>>? friendshipsSubscription;
    StreamSubscription<List<Map<String, dynamic>>>? honksSubscription;
    Set<String> activeFriendIds = const <String>{};

    void emitFailure(Object error, [StackTrace? stackTrace]) {
      if (!controller.isClosed) {
        controller.add(
          left(mapErrorToMainFailure(error, stackTrace ?? StackTrace.current)),
        );
      }
    }

    Future<void> bindHonksForFriends(Set<String> friendIds) async {
      if (_sameStringSets(activeFriendIds, friendIds)) {
        return;
      }

      activeFriendIds = friendIds;
      await honksSubscription?.cancel();
      honksSubscription = null;

      if (friendIds.isEmpty) {
        if (!controller.isClosed) {
          controller.add(const Right(<HonkEvent>[]));
        }
        return;
      }

      honksSubscription = _supabase
          .from('honks')
          .stream(primaryKey: ['id'])
          .inFilter('user_id', friendIds.toList(growable: false))
          .order('created_at', ascending: false)
          .listen((rows) {
            final honks = rows
                .map((row) => HonkEventModel.fromJson(row).toDomain())
                .where((honk) => honk.expiresAt.isAfter(DateTime.now().toUtc()))
                .toList(growable: false);
            if (!controller.isClosed) {
              controller.add(right<MainFailure, List<HonkEvent>>(honks));
            }
          }, onError: emitFailure);
    }

    friendshipsSubscription = _supabase
        .from('friendships')
        .stream(primaryKey: ['user_id', 'friend_id'])
        .listen((rows) {
          final friendIds = rows
              .where((row) => row['status'] == 'accepted')
              .map((row) {
                final userId = row['user_id'] as String?;
                final friendId = row['friend_id'] as String?;
                if (userId == null || friendId == null) {
                  return null;
                }
                return userId == user.id ? friendId : userId;
              })
              .whereType<String>()
              .where((id) => id != user.id)
              .toSet();
          unawaited(bindHonksForFriends(friendIds));
        }, onError: emitFailure);

    controller.onCancel = () async {
      await honksSubscription?.cancel();
      await friendshipsSubscription?.cancel();
    };

    return controller.stream;
  }

  bool _sameStringSets(Set<String> leftSet, Set<String> rightSet) {
    if (leftSet.length != rightSet.length) {
      return false;
    }

    for (final value in leftSet) {
      if (!rightSet.contains(value)) {
        return false;
      }
    }

    return true;
  }
}
