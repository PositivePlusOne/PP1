// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'system_state.freezed.dart';
part 'system_state.g.dart';

@freezed
class SystemState with _$SystemState {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory SystemState({
    required bool isBusy,
  }) = _SystemState;

  factory SystemState.empty() => const SystemState(
        isBusy: false,
      );

  factory SystemState.fromJson(Map<String, Object?> json) => _$SystemStateFromJson(json);
}
