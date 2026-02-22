import 'package:freezed_annotation/freezed_annotation.dart';

part 'honk_status_option.freezed.dart';

@freezed
abstract class HonkStatusOption with _$HonkStatusOption {
  const factory HonkStatusOption({
    required String statusKey,
    required String label,
    required int sortOrder,
    required bool isDefault,
    @Default(true) bool isActive,
  }) = _HonkStatusOption;
}
