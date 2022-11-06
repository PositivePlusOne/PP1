// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'design_system_colors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DesignSystemColors _$$_DesignSystemColorsFromJson(
        Map<String, dynamic> json) =>
    _$_DesignSystemColors(
      primaryColor: colorFromJson(json['primary_color'] as String),
      secondaryColor: colorFromJson(json['secondary_color'] as String),
      focusColor: colorFromJson(json['focus_color'] as String),
      colorWhite: colorFromJson(json['color_white'] as String),
      colorBlack: colorFromJson(json['color_black'] as String),
      colorGray1: colorFromJson(json['color_gray1'] as String),
      colorGray2: colorFromJson(json['color_gray2'] as String),
      colorGray4: colorFromJson(json['color_gray4'] as String),
      colorGray6: colorFromJson(json['color_gray6'] as String),
      colorGray7: colorFromJson(json['color_gray7'] as String),
    );

Map<String, dynamic> _$$_DesignSystemColorsToJson(
        _$_DesignSystemColors instance) =>
    <String, dynamic>{
      'primary_color': colorToJson(instance.primaryColor),
      'secondary_color': colorToJson(instance.secondaryColor),
      'focus_color': colorToJson(instance.focusColor),
      'color_white': colorToJson(instance.colorWhite),
      'color_black': colorToJson(instance.colorBlack),
      'color_gray1': colorToJson(instance.colorGray1),
      'color_gray2': colorToJson(instance.colorGray2),
      'color_gray4': colorToJson(instance.colorGray4),
      'color_gray6': colorToJson(instance.colorGray6),
      'color_gray7': colorToJson(instance.colorGray7),
    };
