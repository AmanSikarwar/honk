import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/data/failure_mapper.dart';
import '../../../../core/domain/main_failure.dart';
import '../../domain/entities/honk_event.dart';
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
  Stream<Either<MainFailure, List<HonkEvent>>> watchFriendsHonks() async* {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      yield left(
        const MainFailure.authenticationFailure(
          'User must be authenticated to watch honks.',
        ),
      );
      return;
    }

    final friendIdsEither =
        await TaskEither<MainFailure, List<String>>.tryCatch(() async {
          final response = await _supabase
              .from('friendships')
              .select('friend_id')
              .eq('user_id', user.id)
              .eq('status', 'accepted');

          final rows = List<Map<String, dynamic>>.from(response as List);
          return rows
              .map((row) => row['friend_id'] as String)
              .toSet()
              .toList(growable: false);
        }, mapErrorToMainFailure).run();

    yield* friendIdsEither.match(
      (failure) async* {
        yield left(failure);
      },
      (friendIds) async* {
        if (friendIds.isEmpty) {
          yield const Right(<HonkEvent>[]);
          return;
        }

        yield* _supabase
            .from('honks')
            .stream(primaryKey: ['id'])
            .inFilter('user_id', friendIds)
            .order('created_at', ascending: false)
            .map((rows) {
              final honks = rows
                  .map((row) => HonkEventModel.fromJson(row).toDomain())
                  .where(
                    (honk) => honk.expiresAt.isAfter(DateTime.now().toUtc()),
                  )
                  .toList(growable: false);
              return right<MainFailure, List<HonkEvent>>(honks);
            })
            .transform(_streamErrorTransformer<List<HonkEvent>>());
      },
    );
  }

  StreamTransformer<Either<MainFailure, T>, Either<MainFailure, T>>
  _streamErrorTransformer<T>() {
    return StreamTransformer<
      Either<MainFailure, T>,
      Either<MainFailure, T>
    >.fromHandlers(
      handleError: (error, stackTrace, sink) {
        sink.add(left(mapErrorToMainFailure(error, stackTrace)));
      },
    );
  }
}
