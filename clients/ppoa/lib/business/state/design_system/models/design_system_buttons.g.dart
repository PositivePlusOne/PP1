// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'design_system_buttons.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DesignSystemButtons _$$_DesignSystemButtonsFromJson(
        Map<String, dynamic> json) =>
    _$_DesignSystemButtons(
      buttonLabel: json['button_label'] as String,
      buttonStyle: $enumDecode(_$ButtonStyleEnumMap, json['button_style']),
      isEnabled: json['is_enabled'] as bool,
      iconType: json['icon_type'] as String,
    );

Map<String, dynamic> _$$_DesignSystemButtonsToJson(
        _$_DesignSystemButtons instance) =>
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
