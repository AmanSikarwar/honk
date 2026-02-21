import 'package:freezed_annotation/freezed_annotation.dart';

part 'honk_event.freezed.dart';
part 'honk_event.g.dart';

@freezed
abstract class HonkEvent with _$HonkEvent {
  const factory HonkEvent({
    required String id,
    required String userId,
    required String location,
    required String status,
    String? details,
    required DateTime createdAt,
    required DateTime expiresAt,
  }) = _HonkEvent;

  factory HonkEvent.fromJson(Map<String, dynamic> json) =>
      _$HonkEventFromJson(json);
}
