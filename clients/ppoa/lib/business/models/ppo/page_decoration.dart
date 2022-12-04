// Package imports:
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ppoa/business/converters/alignment_json_converter.dart';

import '../../converters/color_json_converter.dart';

part 'page_decoration.freezed.dart';
part 'page_decoration.g.dart';

@freezed
class PageDecoration with _$PageDecoration {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory PageDecoration({
    required String asset,
    @JsonKey(fromJson: alignmentFromJson, toJson: alignmentToJson) required Alignment alignment,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color color,
    required double scale,
    required double offsetX,
    required double offsetY,
    required double rotationDegrees,
  }) = _PageDecoration;

  factory PageDecoration.fromJson(Map<String, Object?> json) => _$PageDecorationFromJson(json);
}
