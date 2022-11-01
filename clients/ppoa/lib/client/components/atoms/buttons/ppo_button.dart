// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'enumerations/ppo_button_style.dart';

/// Draws an button from the Figma design system.
/// See: [https://www.figma.com/file/vUl7ODc73HwP9kJ9vseJCd/Design-System?node-id=29%3A3645]
///
/// Most components of the buttons are 1 to 1, for example the different style names.
/// To demo this, use the Simulator with [ppo_button_simulation_view.dart].
class PPOButton extends StatefulWidget {
  const PPOButton({
    required this.onTapped,
    required this.label,
    this.icon,
    this.style = PPOButtonStyle.primary,
    this.isDisabled = false,
    this.isActive = true,
    this.isFocused = false,
    this.forceTappedState = false,
    super.key,
  });

  /// A required callback, returning a future so can be used in mutators.
  final Future<void> Function() onTapped;

  /// The label is the text displayed on the button.
  /// If the style is [iconOnly], then it will instead be applied to the tooltip.
  final String label;

  /// The icon if supplied as part of an included layout type.
  /// This will assert and throw if null on a required layout type.
  final IconData? icon;

  /// The design button style for the button.
  /// Examples of this can be seen in figma or the documentation for each.
  final PPOButtonStyle style;

  /// Sets the style for the disabled state and disables tap callbacks.
  /// This is different from the [isActive] flag as this will effect the design.
  final bool isDisabled;

  /// Sets the style for the active state.
  /// This is different from the [isDisabled] flag as this will effect the design.
  final bool isActive;

  /// Sets the focus for the active state.
  final bool isFocused;

  /// Sets the tapped state to true, regardless of if the button is tapped or not.
  /// This is mainly used for demonstration purposes.
  final bool forceTappedState;

  @override
  State<PPOButton> createState() => _PPOButtonState();
}

class _PPOButtonState extends State<PPOButton> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
