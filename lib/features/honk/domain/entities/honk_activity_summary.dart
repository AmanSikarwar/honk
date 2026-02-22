import 'package:freezed_annotation/freezed_annotation.dart';

part 'honk_activity_summary.freezed.dart';

@freezed
abstract class HonkActivitySummary with _$HonkActivitySummary {
  const factory HonkActivitySummary({
    required String id,
    required String activity,
    required String location,
    String? details,
    required int statusResetSeconds,
    required String defaultStatusKey,
    required int participantCount,
    required bool isCreator,
  }) = _HonkActivitySummary;
}
