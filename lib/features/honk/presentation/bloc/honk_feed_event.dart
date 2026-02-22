part of 'honk_feed_bloc.dart';

@freezed
class HonkFeedEvent with _$HonkFeedEvent {
  const factory HonkFeedEvent.started() = _Started;

  const factory HonkFeedEvent.honksUpdated(
    Either<MainFailure, List<HonkActivitySummary>> result,
  ) = _HonksUpdated;
}
