// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'design_system_brand.dart';

part 'design_system_state.freezed.dart';
part 'design_system_state.g.dart';

@freezed
class DesignSystemState with _$DesignSystemState {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory DesignSystemState({
    required DesignSystemBrand brand,
  }) = _DesignSystemState;

  factory DesignSystemState.empty() => DesignSystemState(
        brand: DesignSystemBrand.empty(),
      );

  factory DesignSystemState.fromJson(Map<String, Object?> json) => _$DesignSystemStateFromJson(json);
}
