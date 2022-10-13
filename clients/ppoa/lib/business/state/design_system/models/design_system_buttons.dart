// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import '../enumerations/button_style.dart';

part 'design_system_buttons.freezed.dart';
part 'design_system_buttons.g.dart';

@freezed
class DesignSystemButtons with _$DesignSystemButtons {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory DesignSystemButtons({
    required String buttonLabel,
    required ButtonStyle buttonStyle,
    required bool isEnabled,
    required String iconType,
  }) = _DesignSystemButtons;

  factory DesignSystemButtons.empty() => const DesignSystemButtons(
        buttonLabel: 'Follow',
        buttonStyle: ButtonStyle.textOnly,
        isEnabled: true,
        iconType: 'Check',
      );

  factory DesignSystemButtons.fromJson(Map<String, Object?> json) => _$DesignSystemButtonsFromJson(json);
}
