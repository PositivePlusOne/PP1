// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

import 'design_system_button_simulation_state.dart';

part 'design_system_simulation_state.freezed.dart';
part 'design_system_simulation_state.g.dart';

@freezed
class DesignSystemSimulationState with _$DesignSystemSimulationState {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory DesignSystemSimulationState({
    required DesignSystemButtonSimulationState buttons,
  }) = _DesignSystemSimulationState;

  factory DesignSystemSimulationState.empty() => DesignSystemSimulationState(
        buttons: DesignSystemButtonSimulationState.empty(),
      );

  factory DesignSystemSimulationState.fromJson(Map<String, Object?> json) => _$DesignSystemSimulationStateFromJson(json);
}
