// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

import '../interfaces/brand_design_system.dart';

part 'design_system_brand_simulation_state.freezed.dart';
part 'design_system_brand_simulation_state.g.dart';

@freezed
class DesignSystemBrandSimulationState with _$DesignSystemBrandSimulationState, BrandDesignSystem {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory DesignSystemBrandSimulationState({
    required String primaryColor,
    required String secondaryColor,
    required String textColorLight,
    required String textColorDark,
    required double opacityActive,
    required double opacityInactive,
    required double opacityDisabled,
    required double borderRadiusSmall,
    required double borderRadiusMedium,
    required double borderRadiusLarge,
  }) = _DesignSystemBrandSimulationState;

  factory DesignSystemBrandSimulationState.empty() => const DesignSystemBrandSimulationState(
        primaryColor: '#2BEDE1',
        secondaryColor: '#EDB72B',
        textColorDark: '#0C0C0B',
        textColorLight: '#F6F6EC',
        opacityActive: 1.0,
        opacityDisabled: 0.30,
        opacityInactive: 0.10,
        borderRadiusSmall: 0.0,
        borderRadiusMedium: 25.0,
        borderRadiusLarge: 100.0,
      );

  factory DesignSystemBrandSimulationState.fromJson(Map<String, Object?> json) => _$DesignSystemBrandSimulationStateFromJson(json);
}
