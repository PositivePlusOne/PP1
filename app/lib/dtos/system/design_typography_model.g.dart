// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'design_typography_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DesignTypographyModel _$$_DesignTypographyModelFromJson(
        Map<String, dynamic> json) =>
    _$_DesignTypographyModel(
      styleHero: textStyleFromJson(json['styleHero'] as Map<String, dynamic>),
      styleBody: textStyleFromJson(json['styleBody'] as Map<String, dynamic>),
      styleTitle: textStyleFromJson(json['styleTitle'] as Map<String, dynamic>),
      styleBold: textStyleFromJson(json['styleBold'] as Map<String, dynamic>),
      styleSubtext:
          textStyleFromJson(json['styleSubtext'] as Map<String, dynamic>),
      styleSubtextBold:
          textStyleFromJson(json['styleSubtextBold'] as Map<String, dynamic>),
      styleButtonRegular:
          textStyleFromJson(json['styleButtonRegular'] as Map<String, dynamic>),
      styleButtonBold:
          textStyleFromJson(json['styleButtonBold'] as Map<String, dynamic>),
      styleHint: textStyleFromJson(json['styleHint'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_DesignTypographyModelToJson(
        _$_DesignTypographyModel instance) =>
    <String, dynamic>{
      'styleHero': textStyleToJson(instance.styleHero),
      'styleBody': textStyleToJson(instance.styleBody),
      'styleTitle': textStyleToJson(instance.styleTitle),
      'styleBold': textStyleToJson(instance.styleBold),
      'styleSubtext': textStyleToJson(instance.styleSubtext),
      'styleSubtextBold': textStyleToJson(instance.styleSubtextBold),
      'styleButtonRegular': textStyleToJson(instance.styleButtonRegular),
      'styleButtonBold': textStyleToJson(instance.styleButtonBold),
      'styleHint': textStyleToJson(instance.styleHint),
    };
