// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import '../interfaces/brand_design_system.dart';

part 'design_system_brand.freezed.dart';
part 'design_system_brand.g.dart';

@freezed
class DesignSystemBrand with _$DesignSystemBrand, BrandDesignSystem {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory DesignSystemBrand({
    required String primaryColor,
    required String secondaryColor,
    required String textColorLight,
    required String textColorDark,
    required double opacityActive,
    required double opacityInactive,
    required double opacityDisabled,
    required double borderRadiusSmall,
    required double borderRadiusMedium,
    required double borderRadiusLarge,
  }) = _DesignSystemBrand;

  factory DesignSystemBrand.empty() => const DesignSystemBrand(
        primaryColor: '#2BEDE1',
        secondaryColor: '#EDB72B',
        textColorDark: '#0C0C0B',
        textColorLight: '#F6F6EC',
        opacityActive: 1.0,
        opacityDisabled: 0.30,
        opacityInactive: 0.10,
        borderRadiusSmall: 0.0,
        borderRadiusMedium: 25.0,
        borderRadiusLarge: 100.0,
      );

  factory DesignSystemBrand.fromJson(Map<String, Object?> json) => _$DesignSystemBrandFromJson(json);
}
