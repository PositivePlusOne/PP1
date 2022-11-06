// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'design_system_brand.freezed.dart';
part 'design_system_brand.g.dart';

@freezed
class DesignSystemBrand with _$DesignSystemBrand {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory DesignSystemBrand({
    required String primaryColor,
    required String secondaryColor,
    required String focusColor,
    required String colorWhite,
    required String colorBlack,
    required String colorGray1,
    required String colorGray2,
    required String colorGray3,
    required String colorGray4,
    required String colorGray6,
    required String colorGray7,
  }) = _DesignSystemBrand;

  factory DesignSystemBrand.empty() => const DesignSystemBrand(
        primaryColor: '#2BEDE1',
        secondaryColor: '#8E3AE2',
        focusColor: '#EDB72B',
        colorWhite: '#FFFFFF',
        colorBlack: '#0C0C0B',
        colorGray1: '#F6F6EC',
        colorGray2: '#DADAD3',
        colorGray3: '#D3D3D3',
        colorGray4: '#A4A49D',
        colorGray6: '#6B6B67',
        colorGray7: '#4A4A47',
      );

  factory DesignSystemBrand.fromJson(Map<String, Object?> json) => _$DesignSystemBrandFromJson(json);
}
