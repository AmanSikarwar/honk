import 'package:fpdart/fpdart.dart';

import '../../../../core/domain/main_failure.dart';
import '../entities/honk_event.dart';

abstract class IHonkRepository {
  TaskEither<MainFailure, Unit> broadcastHonk(HonkEvent honk);

  Stream<Either<MainFailure, List<HonkEvent>>> watchFriendsHonks();
}
