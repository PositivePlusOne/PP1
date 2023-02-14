// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/converters/alignment_json_converter.dart';
import '../../../dtos/converters/color_json_converter.dart';

part 'positive_scaffold_decoration_model.freezed.dart';
part 'positive_scaffold_decoration_model.g.dart';

@freezed
class PositiveScaffoldDecorationModel with _$PositiveScaffoldDecorationModel {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory PositiveScaffoldDecorationModel({
    required String asset,
    @JsonKey(fromJson: alignmentFromJson, toJson: alignmentToJson) required Alignment alignment,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color color,
    required double scale,
    required double offsetX,
    required double offsetY,
    required double rotationDegrees,
  }) = _PositiveScaffoldDecorationModel;

  factory PositiveScaffoldDecorationModel.fromJson(Map<String, Object?> json) => _$PositiveScaffoldDecorationModelFromJson(json);
}
