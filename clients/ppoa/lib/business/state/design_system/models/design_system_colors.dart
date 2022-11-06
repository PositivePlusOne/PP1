// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:ppoa/business/extensions/brand_extensions.dart';
import 'package:ppoa/business/state/converters/color_json_converter.dart';

part 'design_system_colors.freezed.dart';
part 'design_system_colors.g.dart';

@freezed
class DesignSystemColors with _$DesignSystemColors {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory DesignSystemColors({
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color primaryColor,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color secondaryColor,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color focusColor,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color colorWhite,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color colorBlack,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color colorGray1,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color colorGray2,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color colorGray4,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color colorGray6,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color colorGray7,
  }) = _DesignSystemColors;

  factory DesignSystemColors.empty() => DesignSystemColors(
        primaryColor: '#2BEDE1'.toColorFromHex(),
        secondaryColor: '#8E3AE2'.toColorFromHex(),
        focusColor: '#EDB72B'.toColorFromHex(),
        colorWhite: '#FFFFFF'.toColorFromHex(),
        colorBlack: '#0C0C0B'.toColorFromHex(),
        colorGray1: '#F6F6EC'.toColorFromHex(),
        colorGray2: '#DADAD3'.toColorFromHex(),
        colorGray4: '#A4A49D'.toColorFromHex(),
        colorGray6: '#6B6B67'.toColorFromHex(),
        colorGray7: '#4A4A47'.toColorFromHex(),
      );

  factory DesignSystemColors.fromJson(Map<String, Object?> json) => _$DesignSystemColorsFromJson(json);
}
