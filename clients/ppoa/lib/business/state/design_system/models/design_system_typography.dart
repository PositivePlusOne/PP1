// Package imports:
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../converters/text_style_json_converter.dart';

part 'design_system_typography.freezed.dart';
part 'design_system_typography.g.dart';

@freezed
class DesignSystemTypography with _$DesignSystemTypography {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  factory DesignSystemTypography({
    @JsonKey(fromJson: textStyleFromJson, toJson: textStyleToJson) required TextStyle styleHero,
  }) = _DesignSystemTypography;

  factory DesignSystemTypography.empty() => DesignSystemTypography(
        styleHero: const TextStyle(
          fontFamily: 'BN',
          fontWeight: FontWeight.w400,
          fontSize: 48.0,
        ),
      );

  factory DesignSystemTypography.fromJson(Map<String, Object?> json) => _$DesignSystemTypographyFromJson(json);
}
