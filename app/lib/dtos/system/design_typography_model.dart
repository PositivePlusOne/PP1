// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import '../converters/text_style_json_converter.dart';

part 'design_typography_model.freezed.dart';
part 'design_typography_model.g.dart';

@freezed
class DesignTypographyModel with _$DesignTypographyModel {
  factory DesignTypographyModel({
    @JsonKey(fromJson: textStyleFromJson, toJson: textStyleToJson) required TextStyle styleHero,
    @JsonKey(fromJson: textStyleFromJson, toJson: textStyleToJson) required TextStyle styleSuperSize,
    @JsonKey(fromJson: textStyleFromJson, toJson: textStyleToJson) required TextStyle styleBody,
    @JsonKey(fromJson: textStyleFromJson, toJson: textStyleToJson) required TextStyle styleTitle,
    @JsonKey(fromJson: textStyleFromJson, toJson: textStyleToJson) required TextStyle styleTitleTwo,
    @JsonKey(fromJson: textStyleFromJson, toJson: textStyleToJson) required TextStyle styleSubtitle,
    @JsonKey(fromJson: textStyleFromJson, toJson: textStyleToJson) required TextStyle styleBold,
    @JsonKey(fromJson: textStyleFromJson, toJson: textStyleToJson) required TextStyle styleSubtext,
    @JsonKey(fromJson: textStyleFromJson, toJson: textStyleToJson) required TextStyle styleSubtextBold,
    @JsonKey(fromJson: textStyleFromJson, toJson: textStyleToJson) required TextStyle styleButtonRegular,
    @JsonKey(fromJson: textStyleFromJson, toJson: textStyleToJson) required TextStyle styleButtonBold,
    @JsonKey(fromJson: textStyleFromJson, toJson: textStyleToJson) required TextStyle styleTopic,
  }) = _DesignTypographyModel;

  factory DesignTypographyModel.empty() => DesignTypographyModel(
        styleHero: const TextStyle(
          fontFamily: 'BN',
          fontWeight: FontWeight.w400,
          fontSize: 48.0,
        ),
        styleSuperSize: const TextStyle(
          fontFamily: 'BN',
          fontWeight: FontWeight.w400,
          fontSize: 30.0,
        ),
        styleBody: const TextStyle(
          fontFamily: 'AlbertSans',
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
        ),
        styleTitle: const TextStyle(
          fontFamily: 'AlbertSans',
          fontWeight: FontWeight.w700,
          fontSize: 18.0,
        ),
        styleTitleTwo: const TextStyle(
          fontFamily: 'BN',
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
        ),
        styleSubtitle: const TextStyle(
          fontFamily: 'AlbertSans',
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
        ),
        styleBold: const TextStyle(
          fontFamily: 'AlbertSans',
          fontWeight: FontWeight.w600,
          fontSize: 16.0,
        ),
        styleSubtext: const TextStyle(
          fontFamily: 'AlbertSans',
          fontWeight: FontWeight.w400,
          fontSize: 10.0,
        ),
        styleSubtextBold: const TextStyle(
          fontFamily: 'AlbertSans',
          fontWeight: FontWeight.w800,
          fontSize: 10.0,
        ),
        styleButtonRegular: const TextStyle(
          fontFamily: 'AlbertSans',
          fontWeight: FontWeight.w600,
          fontSize: 14.0,
        ),
        styleButtonBold: const TextStyle(
          fontFamily: 'AlbertSans',
          fontWeight: FontWeight.w900,
          fontSize: 14.0,
        ),
        styleTopic: const TextStyle(
          fontFamily: 'BN',
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
      );

  factory DesignTypographyModel.fromJson(Map<String, Object?> json) => _$DesignTypographyModelFromJson(json);
}
