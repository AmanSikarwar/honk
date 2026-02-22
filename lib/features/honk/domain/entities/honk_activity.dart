import 'package:freezed_annotation/freezed_annotation.dart';

import 'honk_status_option.dart';

part 'honk_activity.freezed.dart';

@freezed
abstract class HonkActivity with _$HonkActivity {
  const factory HonkActivity({
    required String id,
    required String creatorId,
    required String activity,
    required String location,
    String? details,
    required DateTime startsAt,
    String? recurrenceRrule,
    required String recurrenceTimezone,
    required int statusResetSeconds,
    required String inviteCode,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(<HonkStatusOption>[]) List<HonkStatusOption> statusOptions,
  }) = _HonkActivity;
}
