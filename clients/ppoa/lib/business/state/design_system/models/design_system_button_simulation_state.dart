// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

import '../enumerations/button_icon_alignment.dart';

part 'design_system_button_simulation_state.freezed.dart';
part 'design_system_button_simulation_state.g.dart';

@freezed
class DesignSystemButtonSimulationState with _$DesignSystemButtonSimulationState {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory DesignSystemButtonSimulationState({
    required String buttonLabel,
    required bool isEnabled,
    required String iconStyle,
    required ButtonIconAlignment iconAlignment,
  }) = _DesignSystemButtonSimulationState;

  factory DesignSystemButtonSimulationState.empty() => const DesignSystemButtonSimulationState(
        buttonLabel: 'Follow',
        isEnabled: true,
        iconStyle: 'Check',
        iconAlignment: ButtonIconAlignment.left,
      );

  factory DesignSystemButtonSimulationState.fromJson(Map<String, Object?> json) => _$DesignSystemButtonSimulationStateFromJson(json);
}
