// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'design_system_typography.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DesignSystemTypography _$$_DesignSystemTypographyFromJson(
        Map<String, dynamic> json) =>
    _$_DesignSystemTypography(
      styleHero: textStyleFromJson(json['style_hero'] as Map<String, dynamic>),
      styleBody: textStyleFromJson(json['style_body'] as Map<String, dynamic>),
      styleTitle:
          textStyleFromJson(json['style_title'] as Map<String, dynamic>),
      styleBold: textStyleFromJson(json['style_bold'] as Map<String, dynamic>),
      styleSubtext:
          textStyleFromJson(json['style_subtext'] as Map<String, dynamic>),
      styleSubtextBold:
          textStyleFromJson(json['style_subtext_bold'] as Map<String, dynamic>),
      styleButtonRegular: textStyleFromJson(
          json['style_button_regular'] as Map<String, dynamic>),
      styleButtonBold:
          textStyleFromJson(json['style_button_bold'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_DesignSystemTypographyToJson(
        _$_DesignSystemTypography instance) =>
    <String, dynamic>{
      'style_hero': textStyleToJson(instance.styleHero),
      'style_body': textStyleToJson(instance.styleBody),
      'style_title': textStyleToJson(instance.styleTitle),
      'style_bold': textStyleToJson(instance.styleBold),
      'style_subtext': textStyleToJson(instance.styleSubtext),
      'style_subtext_bold': textStyleToJson(instance.styleSubtextBold),
      'style_button_regular': textStyleToJson(instance.styleButtonRegular),
      'style_button_bold': textStyleToJson(instance.styleButtonBold),
    };
