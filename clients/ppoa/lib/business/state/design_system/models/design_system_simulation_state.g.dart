// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'design_system_simulation_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DesignSystemSimulationState _$$_DesignSystemSimulationStateFromJson(
        Map<String, dynamic> json) =>
    _$_DesignSystemSimulationState(
      brand: DesignSystemBrandSimulationState.fromJson(
          json['brand'] as Map<String, dynamic>),
      buttons: DesignSystemButtonsSimulationState.fromJson(
          json['buttons'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_DesignSystemSimulationStateToJson(
        _$_DesignSystemSimulationState instance) =>
    <String, dynamic>{
      'brand': instance.brand,
      'buttons': instance.buttons,
    };
