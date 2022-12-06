// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:ppoa/business/extensions/brand_extensions.dart';
import '../../../../business/state/design_system/models/design_system_brand.dart';
import '../../../constants/ppo_design_constants.dart';
import 'enumerations/ppo_button_layout.dart';
import 'enumerations/ppo_button_style.dart';

/// Draws an button from the Figma design system.
/// See: [https://www.figma.com/file/vUl7ODc73HwP9kJ9vseJCd/Design-System?node-id=29%3A3645]
///
/// Most components of the buttons are 1 to 1, for example the different style names.
/// To demo this, use the Simulator with [ppo_button_simulation_view.dart].
class PPOButton extends StatefulWidget {
  const PPOButton({
    required this.brand,
    required this.onTapped,
    required this.label,
    this.tooltip,
    this.icon,
    this.iconWidget,
    this.layout = PPOButtonLayout.iconLeft,
    this.style = PPOButtonStyle.primary,
    this.isDisabled = false,
    this.isActive = true,
    this.isFocused = false,
    this.forceTappedState = false,
    this.activeColor,
    super.key,
  });

  /// The brand to apply to the button
  final DesignSystemBrand brand;

  /// A required callback, returning a future so can be used in mutators.
  final Future<void> Function() onTapped;

  /// The label is the text displayed on the button.
  /// If the style is [iconOnly], then it will instead be applied to the tooltip.
  final String label;

  /// The tooltip if the button is held or hovered.
  final String? tooltip;

  /// The icon if supplied as part of an included layout type.
  /// This will assert and throw if null on a required layout type.
  final IconData? icon;

  /// An optional replacement to icon data which instead uses the widget as a replacement to IconData.
  final Widget? iconWidget;

  /// The layout applied to the button.
  /// This is how the text and icons are positioned within the button.
  final PPOButtonLayout layout;

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

  /// By default the primary colour used is teal, you can override that with this property.
  final Color? activeColor;

  /// The text style for most button designs
  static const TextStyle kButtonTextStyleBold = TextStyle(
    fontFamily: kFontAlbertSans,
    fontWeight: FontWeight.w900,
    fontSize: 14.0,
  );

  /// The text style for label and minor button designs
  static const TextStyle kButtonTextStyleRegular = TextStyle(
    fontFamily: kFontAlbertSans,
    fontWeight: FontWeight.w600,
    fontSize: 14.0,
  );

  /// The text style for navigation button designs
  static const TextStyle kButtonTextStyleNavigation = TextStyle(
    fontFamily: kFontAlbertSans,
    fontWeight: FontWeight.w800,
    fontSize: 12.0,
  );

  /// The button padding for most buttons in the design system.
  static const EdgeInsets kButtonPaddingRegular = EdgeInsets.symmetric(
    vertical: 8.0,
    horizontal: 20.0,
  );

  /// The button padding for icon only buttons in the design system.
  static const EdgeInsets kButtonPaddingIconOnly = EdgeInsets.symmetric(
    vertical: 8.0,
    horizontal: 8.0,
  );

  /// The button padding for large circular buttons in the design system.
  static const EdgeInsets kButtonPaddingLargeCircular = EdgeInsets.symmetric(
    vertical: 8.0,
    horizontal: 8.0,
  );

  /// The button padding for the navigation button in the design system.
  static const EdgeInsets kButtonPaddingNavigation = EdgeInsets.symmetric(
    vertical: 10.0,
    horizontal: 15.0,
  );

  /// The button padding for the minor and label buttons in the design system.
  static const EdgeInsets kButtonPaddingDense = EdgeInsets.symmetric(
    vertical: 5.0,
    horizontal: 20.0,
  );

  /// The normal spacing between the label and the icon if available.
  static const double kButtonIconSpacing = 10.0;

  /// The normal border width of a PPO button.
  static const double kButtonBorderWidth = 2.0;

  // The border radius of a regular PPO button.
  static const double kButtonBorderRadiusRegular = 100.0;

  // The border radius of a navigation button.
  static const double kButtonBorderRadiusNavigation = 25.0;

  // The button icon radius used in non-dense layouts.
  static const double kButtonIconRadiusRegular = 24.0;

  // The button icon radius used in dense layouts.
  static const double kButtonIconRadiusDense = 18.0;

  @override
  State<PPOButton> createState() => _PPOButtonState();
}

class _PPOButtonState extends State<PPOButton> {
  bool _isTappedOrHovered = false;

  Future<void> onTapChanged(bool value, bool fireCallback) async {
    if (!mounted) {
      return;
    }

    if (fireCallback) {
      await widget.onTapped();
    }

    if (mounted) {
      setState(() => _isTappedOrHovered = value);
    }
  }

  void onHoverChanged(bool value) {
    if (!mounted) {
      return;
    }

    setState(() => _isTappedOrHovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final bool displayTappedState = _isTappedOrHovered || widget.forceTappedState;

    late Color materialColor;
    late Color backgroundColor;

    late Color textColor;
    late TextStyle textStyle;

    late double borderWidth;
    late Color borderColor;
    late double borderRadius;

    late EdgeInsets padding;

    late Color iconColor;
    late double iconRadius;

    switch (widget.style) {
      case PPOButtonStyle.primary:
        materialColor = widget.brand.colors.white;
        backgroundColor = widget.activeColor ?? widget.brand.colors.teal;
        textColor = (widget.activeColor ?? widget.brand.colors.teal).complimentTextColor(widget.brand);
        textStyle = PPOButton.kButtonTextStyleBold.copyWith(color: textColor);
        borderWidth = PPOButton.kButtonBorderWidth;
        borderColor = widget.activeColor ?? widget.brand.colors.teal;
        borderRadius = PPOButton.kButtonBorderRadiusRegular;
        padding = PPOButton.kButtonPaddingRegular;
        iconColor = (widget.activeColor ?? widget.brand.colors.teal).complimentTextColor(widget.brand);
        iconRadius = PPOButton.kButtonIconRadiusRegular;

        if (widget.isFocused) {
          borderColor = widget.brand.colors.yellow;
        }

        if (displayTappedState) {
          backgroundColor = Colors.transparent;
          textColor = widget.activeColor ?? widget.brand.colors.teal;
          iconColor = widget.activeColor ?? widget.brand.colors.teal;
          textStyle = PPOButton.kButtonTextStyleBold.copyWith(color: textColor);
          borderColor = widget.activeColor ?? widget.brand.colors.teal;
        }

        if (widget.isDisabled) {
          materialColor = widget.brand.colors.colorGray1;
          backgroundColor = widget.brand.colors.colorGray1;
          textColor = widget.brand.colors.colorGray4;
          iconColor = widget.brand.colors.colorGray4;
          textStyle = PPOButton.kButtonTextStyleBold.copyWith(color: textColor);
          borderColor = widget.brand.colors.colorGray1;
        }
        break;

      case PPOButtonStyle.secondary:
        materialColor = widget.brand.colors.black;
        backgroundColor = widget.brand.colors.black;
        textColor = widget.brand.colors.white;
        textStyle = PPOButton.kButtonTextStyleBold.copyWith(color: textColor);
        borderWidth = PPOButton.kButtonBorderWidth;
        borderColor = widget.brand.colors.black;
        borderRadius = PPOButton.kButtonBorderRadiusRegular;
        padding = PPOButton.kButtonPaddingRegular;
        iconColor = widget.brand.colors.white;
        iconRadius = PPOButton.kButtonIconRadiusRegular;

        if (widget.isFocused) {
          borderColor = widget.brand.colors.yellow;
        }

        if (displayTappedState) {
          materialColor = Colors.transparent;
          backgroundColor = Colors.transparent;
          textColor = widget.brand.colors.white;
          iconColor = widget.brand.colors.white;
          textStyle = PPOButton.kButtonTextStyleBold.copyWith(color: textColor);
          borderColor = widget.brand.colors.white;
        }

        if (widget.isDisabled) {
          materialColor = widget.brand.colors.white;
          backgroundColor = widget.brand.colors.white;
          textColor = widget.brand.colors.colorGray4;
          iconColor = widget.brand.colors.colorGray4;
          textStyle = PPOButton.kButtonTextStyleBold.copyWith(color: textColor);
          borderColor = widget.brand.colors.white;
        }
        break;

      case PPOButtonStyle.tertiary:
        materialColor = widget.brand.colors.white;
        backgroundColor = widget.brand.colors.white;
        textColor = widget.brand.colors.black;
        textStyle = PPOButton.kButtonTextStyleBold.copyWith(color: textColor);
        borderWidth = PPOButton.kButtonBorderWidth;
        borderColor = widget.brand.colors.white;
        borderRadius = PPOButton.kButtonBorderRadiusRegular;
        padding = PPOButton.kButtonPaddingRegular;
        iconColor = widget.brand.colors.black;
        iconRadius = PPOButton.kButtonIconRadiusRegular;

        if (widget.isFocused) {
          borderColor = widget.brand.colors.yellow;
        }

        if (displayTappedState) {
          materialColor = Colors.transparent;
          backgroundColor = Colors.transparent;
          textColor = widget.brand.colors.black;
          iconColor = widget.brand.colors.black;
          textStyle = PPOButton.kButtonTextStyleBold.copyWith(color: textColor);
          borderColor = widget.brand.colors.black;
        }

        if (widget.isDisabled) {
          materialColor = widget.brand.colors.colorGray1;
          backgroundColor = widget.brand.colors.colorGray1;
          textColor = widget.brand.colors.colorGray4;
          iconColor = widget.brand.colors.colorGray4;
          textStyle = PPOButton.kButtonTextStyleBold.copyWith(color: textColor);
          borderColor = widget.brand.colors.colorGray1;
        }
        break;

      case PPOButtonStyle.ghost:
        materialColor = widget.brand.colors.black.withOpacity(0.3);
        backgroundColor = widget.brand.colors.white.withOpacity(0.1);
        textColor = widget.brand.colors.white;
        textStyle = PPOButton.kButtonTextStyleBold.copyWith(color: textColor);
        borderWidth = PPOButton.kButtonBorderWidth;
        borderColor = widget.brand.colors.white.withOpacity(0.1);
        borderRadius = PPOButton.kButtonBorderRadiusRegular;
        padding = PPOButton.kButtonPaddingRegular;
        iconColor = widget.brand.colors.white;
        iconRadius = PPOButton.kButtonIconRadiusRegular;

        if (widget.isFocused) {
          materialColor = Colors.transparent;
          backgroundColor = Colors.transparent;
          borderColor = widget.brand.colors.yellow;
        }

        if (displayTappedState) {
          materialColor = Colors.transparent;
          backgroundColor = Colors.transparent;
          textColor = widget.brand.colors.black;
          iconColor = widget.brand.colors.black;
          textStyle = PPOButton.kButtonTextStyleBold.copyWith(color: textColor);
          borderWidth = PPOButton.kButtonBorderWidth;
          borderColor = widget.brand.colors.black;
        }

        if (widget.isDisabled) {
          materialColor = Colors.transparent;
          backgroundColor = Colors.transparent;
          textColor = widget.brand.colors.colorGray4;
          iconColor = widget.brand.colors.colorGray4;
          textStyle = PPOButton.kButtonTextStyleBold.copyWith(color: textColor);
          borderColor = widget.brand.colors.white.withOpacity(0.2);
        }
        break;

      case PPOButtonStyle.minor:
        materialColor = widget.brand.colors.white;
        backgroundColor = widget.brand.colors.white;
        textColor = widget.brand.colors.colorGray7;
        textStyle = PPOButton.kButtonTextStyleRegular.copyWith(color: textColor);
        borderWidth = PPOButton.kButtonBorderWidth;
        borderColor = widget.brand.colors.colorGray2;
        borderRadius = PPOButton.kButtonBorderRadiusRegular;
        padding = PPOButton.kButtonPaddingDense;
        iconColor = widget.brand.colors.colorGray7;
        iconRadius = PPOButton.kButtonIconRadiusDense;

        if (widget.isActive) {
          materialColor = widget.brand.colors.teal;
          backgroundColor = widget.brand.colors.teal;
          textColor = widget.brand.colors.black;
          textStyle = PPOButton.kButtonTextStyleRegular.copyWith(color: textColor);
          iconColor = widget.brand.colors.black;
          borderColor = widget.brand.colors.teal;
        }

        if (widget.isFocused) {
          materialColor = widget.brand.colors.white;
          backgroundColor = widget.brand.colors.white;
          textColor = widget.brand.colors.colorGray7;
          textStyle = PPOButton.kButtonTextStyleRegular.copyWith(color: textColor);
          iconColor = widget.brand.colors.colorGray7;
          borderColor = widget.brand.colors.yellow;
        }

        if (displayTappedState) {
          materialColor = widget.brand.colors.white;
          backgroundColor = widget.brand.colors.white;
          textColor = widget.brand.colors.teal;
          iconColor = widget.brand.colors.teal;
          textStyle = PPOButton.kButtonTextStyleRegular.copyWith(color: textColor);
          borderWidth = PPOButton.kButtonBorderWidth;
          borderColor = widget.brand.colors.teal;
        }

        if (widget.isDisabled) {
          materialColor = widget.brand.colors.colorGray1;
          backgroundColor = widget.brand.colors.colorGray1;
          textColor = widget.brand.colors.colorGray4;
          iconColor = widget.brand.colors.colorGray4;
          textStyle = PPOButton.kButtonTextStyleRegular.copyWith(color: textColor);
          borderColor = widget.brand.colors.colorGray1.withOpacity(0.2);
        }
        break;

      case PPOButtonStyle.text:
        materialColor = Colors.transparent;
        backgroundColor = Colors.transparent;
        textColor = widget.brand.colors.black;
        textStyle = PPOButton.kButtonTextStyleBold.copyWith(color: textColor);
        borderWidth = PPOButton.kButtonBorderWidth;
        borderColor = Colors.transparent;
        borderRadius = PPOButton.kButtonBorderRadiusRegular;
        padding = PPOButton.kButtonPaddingDense;
        iconColor = widget.brand.colors.black;
        iconRadius = PPOButton.kButtonIconRadiusDense;

        if (displayTappedState) {
          textColor = widget.brand.colors.teal;
          iconColor = widget.brand.colors.teal;
          textStyle = PPOButton.kButtonTextStyleBold.copyWith(color: textColor);
          borderWidth = PPOButton.kButtonBorderWidth;
          borderColor = widget.brand.colors.teal;
        }

        if (widget.isDisabled) {
          textColor = widget.brand.colors.colorGray4;
          iconColor = widget.brand.colors.colorGray4;
          textStyle = PPOButton.kButtonTextStyleBold.copyWith(color: textColor);
        }
        break;

      case PPOButtonStyle.navigation:
        materialColor = Colors.transparent;
        backgroundColor = Colors.transparent;
        textColor = widget.brand.colors.colorGray6;
        textStyle = PPOButton.kButtonTextStyleBold.copyWith(color: textColor);
        borderWidth = PPOButton.kButtonBorderWidth;
        borderColor = Colors.transparent;
        borderRadius = PPOButton.kButtonBorderRadiusRegular;
        padding = PPOButton.kButtonPaddingNavigation;
        iconColor = widget.brand.colors.colorGray7;
        iconRadius = PPOButton.kButtonIconRadiusRegular;

        if (widget.isActive) {
          materialColor = widget.brand.colors.white;
          backgroundColor = widget.brand.colors.white;
          textColor = widget.brand.colors.purple;
          textStyle = PPOButton.kButtonTextStyleBold.copyWith(color: textColor);
          iconColor = widget.brand.colors.purple;
          borderColor = widget.brand.colors.white;
        }

        if (widget.isFocused) {
          materialColor = widget.brand.colors.white;
          backgroundColor = widget.brand.colors.white;
          textColor = widget.brand.colors.colorGray7;
          textStyle = PPOButton.kButtonTextStyleBold.copyWith(color: textColor);
          iconColor = widget.brand.colors.colorGray7;
          borderColor = widget.brand.colors.yellow;
        }

        if (displayTappedState) {
          materialColor = widget.brand.colors.white;
          backgroundColor = widget.brand.colors.white;
          textColor = widget.brand.colors.colorGray7;
          textStyle = PPOButton.kButtonTextStyleBold.copyWith(color: textColor);
          iconColor = widget.brand.colors.colorGray7;
          borderColor = widget.brand.colors.white;
        }

        if (widget.isDisabled) {
          materialColor = widget.brand.colors.white;
          backgroundColor = widget.brand.colors.white;
          textColor = widget.brand.colors.colorGray4;
          textStyle = PPOButton.kButtonTextStyleBold.copyWith(color: textColor);
          iconColor = widget.brand.colors.colorGray4;
          borderColor = widget.brand.colors.white;
        }
        break;

      case PPOButtonStyle.largeIcon:
        textColor = widget.brand.colors.colorGray7;
        textStyle = PPOButton.kButtonTextStyleRegular.copyWith(color: textColor);
        materialColor = widget.brand.colors.black;
        backgroundColor = widget.brand.colors.black;
        borderWidth = PPOButton.kButtonBorderWidth;
        borderColor = widget.brand.colors.black;
        borderRadius = PPOButton.kButtonBorderRadiusRegular;
        padding = PPOButton.kButtonPaddingLargeCircular;
        iconColor = widget.brand.colors.white;
        iconRadius = PPOButton.kButtonIconRadiusRegular;

        if (widget.isActive) {
          iconColor = widget.brand.colors.purple;
          materialColor = widget.brand.colors.white;
          backgroundColor = widget.brand.colors.white;
          borderColor = widget.brand.colors.white;
        }

        if (widget.isFocused) {
          iconColor = widget.brand.colors.colorGray7;
          materialColor = widget.brand.colors.white;
          backgroundColor = widget.brand.colors.white;
          borderColor = widget.brand.colors.yellow;
        }

        if (displayTappedState) {
          iconColor = widget.brand.colors.colorGray7;
          materialColor = widget.brand.colors.white;
          backgroundColor = widget.brand.colors.white;
          borderColor = widget.brand.colors.white;
        }

        if (widget.isDisabled) {
          iconColor = widget.brand.colors.colorGray4;
          materialColor = widget.brand.colors.white;
          backgroundColor = widget.brand.colors.white;
          borderColor = widget.brand.colors.white;
        }
        break;

      case PPOButtonStyle.label:
        materialColor = widget.brand.colors.colorGray1;
        backgroundColor = widget.brand.colors.colorGray1;
        textColor = widget.brand.colors.colorGray7;
        textStyle = PPOButton.kButtonTextStyleRegular.copyWith(color: textColor);
        borderWidth = PPOButton.kButtonBorderWidth;
        borderColor = widget.brand.colors.colorGray1;
        borderRadius = PPOButton.kButtonBorderRadiusRegular;
        padding = PPOButton.kButtonPaddingDense;
        iconColor = widget.brand.colors.black;
        iconRadius = PPOButton.kButtonIconRadiusDense;
        break;
    }

    // This widget is the standard widget when using non-navigation buttons, or icon only buttons.
    // It will expand horizontally to fit its space, however for the other two buttons see below.
    late Widget mainWidget;

    if (widget.style == PPOButtonStyle.navigation) {
      mainWidget = Column(
        children: <Widget>[
          if (widget.iconWidget != null) ...<Widget>[
            widget.iconWidget!,
          ],
          if (widget.iconWidget == null) ...<Widget>[
            Icon(widget.icon, color: iconColor, size: iconRadius),
          ],
          Text(
            widget.label,
            style: textStyle,
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else if (widget.layout == PPOButtonLayout.iconOnly || widget.style == PPOButtonStyle.largeIcon) {
      if (widget.layout == PPOButtonLayout.iconOnly) {
        padding = PPOButton.kButtonPaddingIconOnly;
      }

      if (widget.style == PPOButtonStyle.largeIcon) {
        padding = PPOButton.kButtonPaddingLargeCircular;
      }

      mainWidget = widget.iconWidget ?? Icon(widget.icon, color: iconColor, size: iconRadius);
    } else {
      mainWidget = Stack(
        fit: StackFit.loose,
        children: <Widget>[
          if (widget.layout == PPOButtonLayout.iconLeft) ...<Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: widget.iconWidget ?? Icon(widget.icon, color: iconColor, size: iconRadius),
            ),
          ],
          SizedBox(
            height: iconRadius,
            child: Align(
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.label,
                  style: textStyle,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ),
          ),
          if (widget.layout == PPOButtonLayout.iconRight) ...<Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: widget.iconWidget ?? Icon(widget.icon, color: iconColor, size: iconRadius),
            ),
          ],
        ],
      );
    }

    return IgnorePointer(
      ignoring: widget.isDisabled,
      child: GestureDetector(
        onTapDown: (_) => onTapChanged(true, false),
        onTapUp: (_) => onTapChanged(false, true),
        onTapCancel: () => onTapChanged(false, false),
        child: MouseRegion(
          onEnter: (_) => onHoverChanged(true),
          onExit: (_) => onHoverChanged(false),
          child: Material(
            color: materialColor,
            borderRadius: BorderRadius.circular(borderRadius),
            animationDuration: kAnimationDurationRegular,
            child: Tooltip(
              message: widget.tooltip ?? '',
              child: AnimatedContainer(
                padding: padding,
                duration: kAnimationDurationRegular,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: borderColor,
                    width: borderWidth,
                  ),
                ),
                child: AnimatedDefaultTextStyle(
                  duration: kAnimationDurationRegular,
                  style: textStyle,
                  child: mainWidget,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
