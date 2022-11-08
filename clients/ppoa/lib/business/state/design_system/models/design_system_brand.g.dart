// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'design_system_brand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DesignSystemBrand _$$_DesignSystemBrandFromJson(Map<String, dynamic> json) =>
    _$_DesignSystemBrand(
      colors:
          DesignSystemColors.fromJson(json['colors'] as Map<String, dynamic>),
      typography: DesignSystemTypography.fromJson(
          json['typography'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_DesignSystemBrandToJson(
        _$_DesignSystemBrand instance) =>
    <String, dynamic>{
      'colors': instance.colors,
      'typography': instance.typography,
    };
