// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'design_system_brand_simulation_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DesignSystemBrandSimulationState
    _$$_DesignSystemBrandSimulationStateFromJson(Map<String, dynamic> json) =>
        _$_DesignSystemBrandSimulationState(
          primaryColor: json['primary_color'] as String,
          secondaryColor: json['secondary_color'] as String,
          textColorLight: json['text_color_light'] as String,
          textColorDark: json['text_color_dark'] as String,
          opacityActive: (json['opacity_active'] as num).toDouble(),
          opacityInactive: (json['opacity_inactive'] as num).toDouble(),
          opacityDisabled: (json['opacity_disabled'] as num).toDouble(),
          borderRadiusSmall: (json['border_radius_small'] as num).toDouble(),
          borderRadiusMedium: (json['border_radius_medium'] as num).toDouble(),
          borderRadiusLarge: (json['border_radius_large'] as num).toDouble(),
        );

Map<String, dynamic> _$$_DesignSystemBrandSimulationStateToJson(
        _$_DesignSystemBrandSimulationState instance) =>
    <String, dynamic>{
      'primary_color': instance.primaryColor,
      'secondary_color': instance.secondaryColor,
      'text_color_light': instance.textColorLight,
      'text_color_dark': instance.textColorDark,
      'opacity_active': instance.opacityActive,
      'opacity_inactive': instance.opacityInactive,
      'opacity_disabled': instance.opacityDisabled,
      'border_radius_small': instance.borderRadiusSmall,
      'border_radius_medium': instance.borderRadiusMedium,
      'border_radius_large': instance.borderRadiusLarge,
    };
