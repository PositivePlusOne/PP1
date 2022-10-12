// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'design_system_button_simulation_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DesignSystemButtonSimulationState
    _$$_DesignSystemButtonSimulationStateFromJson(Map<String, dynamic> json) =>
        _$_DesignSystemButtonSimulationState(
          buttonLabel: json['button_label'] as String,
          isEnabled: json['is_enabled'] as bool,
          iconStyle: json['icon_style'] as String,
          iconAlignment:
              $enumDecode(_$ButtonIconAlignmentEnumMap, json['icon_alignment']),
        );

Map<String, dynamic> _$$_DesignSystemButtonSimulationStateToJson(
        _$_DesignSystemButtonSimulationState instance) =>
    <String, dynamic>{
      'button_label': instance.buttonLabel,
      'is_enabled': instance.isEnabled,
      'icon_style': instance.iconStyle,
      'icon_alignment': _$ButtonIconAlignmentEnumMap[instance.iconAlignment]!,
    };

const _$ButtonIconAlignmentEnumMap = {
  ButtonIconAlignment.left: 'left',
  ButtonIconAlignment.right: 'right',
  ButtonIconAlignment.none: 'none',
};
