part of 'honk_feed_bloc.dart';

@freezed
class HonkFeedState with _$HonkFeedState {
  const factory HonkFeedState.initial() = _Initial;

  const factory HonkFeedState.loadInProgress() = _LoadInProgress;

  const factory HonkFeedState.loadSuccess(List<HonkEvent> honks) = _LoadSuccess;

  const factory HonkFeedState.loadFailure(MainFailure failure) = _LoadFailure;
}
