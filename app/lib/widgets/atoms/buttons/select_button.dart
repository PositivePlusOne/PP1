import 'package:app/extensions/color_extensions.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:flutter/material.dart';

import '../../../constants/design_constants.dart';
import '../../../dtos/system/design_colors_model.dart';

class SelectButton extends StatelessWidget {
  const SelectButton({
    super.key,
    required this.label,
    this.tooltip,
    this.isDisabled = false,
    this.isActive = false,
    this.padding = const EdgeInsets.symmetric(vertical: 11.5, horizontal: 20),
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
    required this.colors,
  });

  /// The label of the button.
  final String label;

  /// The optional tooltip of the button.
  final String? tooltip;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// The initial state of the button.
  final bool isActive;

  /// The padding of the button.
  final EdgeInsets? padding;

  /// The callback that is called when the button is selected.
  final void Function(bool isActive)? onChanged;

  /// The color of the button when it is selected.
  final Color? activeColor;

  /// The color of the button when it is not selected.
  final Color? inactiveColor;

  /// The current brand, used to determine the colors.
  final DesignColorsModel colors;

  @override
  Widget build(BuildContext context) {
    final activeColor = this.activeColor ?? colors.teal;
    final inactiveColor = this.inactiveColor ?? colors.black;

    final activeTextColor = activeColor.complimentTextColor(colors);
    final inactiveTextColor = inactiveColor.complimentTextColor(colors);
    final textStyle = PositiveButton.kButtonTextStyleBold.copyWith(
      color: isActive ? activeTextColor : inactiveTextColor,
    );

    return IgnorePointer(
      ignoring: isDisabled,
      child: GestureDetector(
        onTap: () {
          onChanged?.call(!isActive);
        },
        child: MouseRegion(
          onEnter: (_) => {},
          onExit: (_) => {},
          child: Material(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(
                PositiveButton.kButtonBorderRadiusRegular),
            animationDuration: kAnimationDurationRegular,
            child: Tooltip(
              message: tooltip ?? '',
              child: AnimatedContainer(
                padding: padding,
                duration: kAnimationDurationRegular,
                decoration: BoxDecoration(
                  color: isActive ? activeColor : inactiveColor,
                  borderRadius: BorderRadius.circular(
                      PositiveButton.kButtonBorderRadiusRegular),
                ),
                child: AnimatedDefaultTextStyle(
                  duration: kAnimationDurationRegular,
                  style: textStyle,
                  child: Text(
                    label,
                    style: textStyle,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
