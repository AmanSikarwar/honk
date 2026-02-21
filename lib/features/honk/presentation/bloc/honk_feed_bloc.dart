import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/main_failure.dart';
import '../../domain/entities/honk_event.dart';
import '../../domain/repositories/i_honk_repository.dart';

part 'honk_feed_bloc.freezed.dart';
part 'honk_feed_event.dart';
part 'honk_feed_state.dart';

@injectable
class HonkFeedBloc extends Bloc<HonkFeedEvent, HonkFeedState> {
  HonkFeedBloc(this._honkRepository) : super(const HonkFeedState.initial()) {
    on<_Started>(_onStarted);
    on<_HonksUpdated>(_onHonksUpdated);
  }

  final IHonkRepository _honkRepository;
  StreamSubscription<Either<MainFailure, List<HonkEvent>>>?
  _honkFeedSubscription;

  Future<void> _onStarted(_Started event, Emitter<HonkFeedState> emit) async {
    emit(const HonkFeedState.loadInProgress());

    await _honkFeedSubscription?.cancel();
    _honkFeedSubscription = _honkRepository.watchFriendsHonks().listen((
      result,
    ) {
      add(HonkFeedEvent.honksUpdated(result));
    });
  }

  void _onHonksUpdated(_HonksUpdated event, Emitter<HonkFeedState> emit) {
    event.result.match(
      (failure) => emit(HonkFeedState.loadFailure(failure)),
      (honks) => emit(HonkFeedState.loadSuccess(honks)),
    );
  }

  @override
  Future<void> close() async {
    await _honkFeedSubscription?.cancel();
    return super.close();
  }
}
