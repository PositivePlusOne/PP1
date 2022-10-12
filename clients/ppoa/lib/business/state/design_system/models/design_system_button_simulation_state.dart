// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

import '../enumerations/button_style.dart';

part 'design_system_button_simulation_state.freezed.dart';
part 'design_system_button_simulation_state.g.dart';

@freezed
class DesignSystemButtonsSimulationState with _$DesignSystemButtonsSimulationState {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory DesignSystemButtonsSimulationState({
    required String buttonLabel,
    required ButtonStyle buttonStyle,
    required bool isEnabled,
    required String iconType,
  }) = _DesignSystemButtonsSimulationState;

  factory DesignSystemButtonsSimulationState.empty() => const DesignSystemButtonsSimulationState(
        buttonLabel: 'Follow',
        buttonStyle: ButtonStyle.textOnly,
        isEnabled: true,
        iconType: 'Check',
      );

  factory DesignSystemButtonsSimulationState.fromJson(Map<String, Object?> json) => _$DesignSystemButtonsSimulationStateFromJson(json);
}
