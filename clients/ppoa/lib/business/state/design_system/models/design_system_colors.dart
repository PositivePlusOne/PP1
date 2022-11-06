// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'design_system_colors.freezed.dart';
part 'design_system_colors.g.dart';

@freezed
class DesignSystemColors with _$DesignSystemColors {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory DesignSystemColors({
    required String primaryColor,
    required String secondaryColor,
    required String focusColor,
    required String colorWhite,
    required String colorBlack,
    required String colorGray1,
    required String colorGray2,
    required String colorGray4,
    required String colorGray6,
    required String colorGray7,
  }) = _DesignSystemColors;

  factory DesignSystemColors.empty() => const DesignSystemColors(
        primaryColor: '#2BEDE1',
        secondaryColor: '#8E3AE2',
        focusColor: '#EDB72B',
        colorWhite: '#FFFFFF',
        colorBlack: '#0C0C0B',
        colorGray1: '#F6F6EC',
        colorGray2: '#DADAD3',
        colorGray4: '#A4A49D',
        colorGray6: '#6B6B67',
        colorGray7: '#4A4A47',
      );

  factory DesignSystemColors.fromJson(Map<String, Object?> json) => _$DesignSystemColorsFromJson(json);
}
