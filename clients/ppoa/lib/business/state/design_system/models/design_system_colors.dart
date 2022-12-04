// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:ppoa/business/converters/color_json_converter.dart';
import 'package:ppoa/business/extensions/brand_extensions.dart';

part 'design_system_colors.freezed.dart';
part 'design_system_colors.g.dart';

@freezed
class DesignSystemColors with _$DesignSystemColors {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory DesignSystemColors({
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color teal,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color purple,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color green,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color yellow,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color pink,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color white,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color black,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color colorGray1,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color colorGray2,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color colorGray3,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color colorGray4,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color colorGray6,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color colorGray7,
  }) = _DesignSystemColors;

  factory DesignSystemColors.empty() => DesignSystemColors(
        teal: '#2BEDE1'.toColorFromHex(),
        purple: '#8E3AE2'.toColorFromHex(),
        green: '#29E774'.toColorFromHex(),
        yellow: '#EDB72B'.toColorFromHex(),
        pink: '#ECACD0'.toColorFromHex(),
        white: '#FFFFFF'.toColorFromHex(),
        black: '#0C0C0B'.toColorFromHex(),
        colorGray1: '#F6F6EC'.toColorFromHex(),
        colorGray2: '#DADAD3'.toColorFromHex(),
        colorGray3: '#D3D3D3'.toColorFromHex(),
        colorGray4: '#A4A49D'.toColorFromHex(),
        colorGray6: '#6B6B67'.toColorFromHex(),
        colorGray7: '#4A4A47'.toColorFromHex(),
      );

  factory DesignSystemColors.fromJson(Map<String, Object?> json) => _$DesignSystemColorsFromJson(json);
}
