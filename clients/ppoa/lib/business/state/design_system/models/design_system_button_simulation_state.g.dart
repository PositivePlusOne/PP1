// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'design_system_button_simulation_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DesignSystemButtonsSimulationState
    _$$_DesignSystemButtonsSimulationStateFromJson(Map<String, dynamic> json) =>
        _$_DesignSystemButtonsSimulationState(
          buttonLabel: json['button_label'] as String,
          buttonStyle: $enumDecode(_$ButtonStyleEnumMap, json['button_style']),
          isEnabled: json['is_enabled'] as bool,
          iconType: json['icon_type'] as String,
        );

Map<String, dynamic> _$$_DesignSystemButtonsSimulationStateToJson(
        _$_DesignSystemButtonsSimulationState instance) =>
    <String, dynamic>{
      'button_label': instance.buttonLabel,
      'button_style': _$ButtonStyleEnumMap[instance.buttonStyle]!,
      'is_enabled': instance.isEnabled,
      'icon_type': instance.iconType,
    };

const _$ButtonStyleEnumMap = {
  ButtonStyle.iconLeft: 'iconLeft',
  ButtonStyle.iconRight: 'iconRight',
  ButtonStyle.iconOnly: 'iconOnly',
  ButtonStyle.textOnly: 'textOnly',
};
