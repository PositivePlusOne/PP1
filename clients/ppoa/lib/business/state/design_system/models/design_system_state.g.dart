// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'design_system_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DesignSystemState _$$_DesignSystemStateFromJson(Map<String, dynamic> json) =>
    _$_DesignSystemState(
      brand: DesignSystemBrand.fromJson(json['brand'] as Map<String, dynamic>),
      buttons:
          DesignSystemButtons.fromJson(json['buttons'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_DesignSystemStateToJson(
        _$_DesignSystemState instance) =>
    <String, dynamic>{
      'brand': instance.brand,
      'buttons': instance.buttons,
    };
