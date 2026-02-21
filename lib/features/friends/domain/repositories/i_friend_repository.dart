import 'package:fpdart/fpdart.dart';

import '../../../../core/domain/main_failure.dart';
import '../entities/profile.dart';

abstract class IFriendRepository {
  TaskEither<MainFailure, List<Profile>> searchUsers({required String query});

  TaskEither<MainFailure, Unit> addFriend({required String friendId});

  TaskEither<MainFailure, List<Profile>> fetchFriends();
}
