// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/extensions/color_extensions.dart';
import '../converters/color_json_converter.dart';

// Project imports:

part 'design_colors_model.freezed.dart';
part 'design_colors_model.g.dart';

@freezed
class DesignColorsModel with _$DesignColorsModel {
  const factory DesignColorsModel({
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color teal,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color purple,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color green,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color yellow,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color red,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color pink,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color white,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color black,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color linkBlue,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color colorGray1,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color colorGray2,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color colorGray3,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color colorGray4,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color colorGray5,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color colorGray6,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color colorGray7,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color colorGray8,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color transparent,
    @JsonKey(fromJson: colorFromJson, toJson: colorToJson) required Color defualtUserColour,
  }) = _DesignColorsModel;

  static List<String> get selectableProfileColorStrings {
    return selectableProfileColors.map((e) => e.toHex()).toList();
  }

  static List<Color> get selectableProfileColors {
    final DesignColorsModel model = DesignColorsModel.empty();
    return [
      model.pink,
      model.green,
      model.yellow,
      model.teal,
      model.purple,
    ];
  }

  factory DesignColorsModel.empty() => DesignColorsModel(
        teal: '#2BEDE1'.toColorFromHex(),
        purple: '#8E3AE2'.toColorFromHex(),
        green: '#29E774'.toColorFromHex(),
        yellow: '#EDB72B'.toColorFromHex(),
        red: '#ED2B2B'.toColorFromHex(),
        pink: '#ECACD0'.toColorFromHex(),
        white: '#FFFFFF'.toColorFromHex(),
        black: '#0C0C0B'.toColorFromHex(),
        linkBlue: '#3769EA'.toColorFromHex(),
        colorGray1: '#F6F6EC'.toColorFromHex(),
        colorGray2: '#DADAD3'.toColorFromHex(),
        colorGray3: '#D3D3D3'.toColorFromHex(),
        colorGray4: '#A4A49D'.toColorFromHex(),
        colorGray5: '#878782'.toColorFromHex(),
        colorGray6: '#6B6B67'.toColorFromHex(),
        colorGray7: '#4A4A47'.toColorFromHex(),
        colorGray8: '#2f2f2f'.toColorFromHex(),
        transparent: '#00000000'.toColorFromHex(),
        defualtUserColour: '#D3D3D3'.toColorFromHex(),
      );

  factory DesignColorsModel.fromJson(Map<String, Object?> json) => _$DesignColorsModelFromJson(json);
}
