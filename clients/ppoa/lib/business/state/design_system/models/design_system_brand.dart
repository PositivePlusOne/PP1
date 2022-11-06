// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

import 'design_system_typography.dart';
import 'design_system_colors.dart';

part 'design_system_brand.freezed.dart';
part 'design_system_brand.g.dart';

@freezed
class DesignSystemBrand with _$DesignSystemBrand {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory DesignSystemBrand({
    required DesignSystemColors colors,
    required DesignSystemTypography typography,
  }) = _DesignSystemBrand;

  factory DesignSystemBrand.empty() => DesignSystemBrand(
        colors: DesignSystemColors.empty(),
        typography: DesignSystemTypography.empty(),
      );

  factory DesignSystemBrand.fromJson(Map<String, Object?> json) => _$DesignSystemBrandFromJson(json);
}
