// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:ppoa/business/extensions/brand_extensions.dart';
import '../../../../business/state/design_system/models/design_system_brand.dart';
import '../../../constants/ppo_design_constants.dart';
import 'enumerations/ppo_button_layout.dart';
import 'enumerations/ppo_button_size.dart';
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
    this.primaryColor = Colors.white,
    this.focusColor = const Color(0xFFEDB72B),
    this.outlineHoverColorOverride,
    this.tooltip,
    this.icon,
    this.iconWidgetBuilder,
    this.layout = PPOButtonLayout.iconLeft,
    this.style = PPOButtonStyle.primary,
    this.size = PPOButtonSize.large,
    this.isDisabled = false,
    this.isActive = true,
    this.isFocused = false,
    this.forceTappedState = false,
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
  final Widget Function(Color primaryColor)? iconWidgetBuilder;

  /// The layout applied to the button.
  /// This is how the text and icons are positioned within the button.
  final PPOButtonLayout layout;

  /// The design button style for the button.
  /// Examples of this can be seen in figma or the documentation for each.
  final PPOButtonStyle style;

  /// The design sizes. Changes the padding and margins
  final PPOButtonSize size;

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

  /// By default the primary colour used is white, you can override that with this property.
  final Color primaryColor;

  /// By default the focus colour used is yellow, you can override that with this property.
  final Color focusColor;

  /// Overrides the outline colour if required, for example white on a white background.
  final Color? outlineHoverColorOverride;

  /// The text style for most button designs
  static const TextStyle kButtonTextStyleBold = TextStyle(
    fontFamily: kFontAlbertSans,
    fontWeight: FontWeight.w900,
    fontSize: 14.0,
  );

  /// The button padding for most buttons in the design system.
  static const EdgeInsets kButtonPaddingLarge = EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0);
  static const EdgeInsets kButtonPaddingMedium = EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0);
  static const EdgeInsets kButtonPaddingSmall = EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0);
  static const EdgeInsets kIconPaddingLarge = EdgeInsets.symmetric(horizontal: 13.0, vertical: 13.0);
  static const EdgeInsets kIconPaddingMedium = EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0);
  static const EdgeInsets kIconPaddingSmall = EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0);

  /// The normal border width of a PPO button.
  static const double kButtonBorderWidth = 2.0;

  // The border radius of a regular PPO button.
  static const double kButtonBorderRadiusRegular = 100.0;

  // The button icon radius used
  static const double kButtonIconRadiusRegular = 24.0;
  static const double kButtonIconRadiusSmall = 18.0;

  // Opacities used in the buttons
  static const double kButtonOpacityFull = 1.0;
  static const double kButtonOpacityMedium = 0.3;
  static const double kButtonOpacityLow = 0.2;

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

    switch (widget.size) {
      case PPOButtonSize.large:
        padding = PPOButton.kButtonPaddingLarge;
        iconRadius = PPOButton.kButtonIconRadiusRegular;
        break;
      case PPOButtonSize.medium:
        padding = PPOButton.kButtonPaddingMedium;
        iconRadius = PPOButton.kButtonIconRadiusRegular;
        break;
      case PPOButtonSize.small:
        padding = PPOButton.kButtonPaddingSmall;
        iconRadius = PPOButton.kButtonIconRadiusSmall;
        break;
    }

    switch (widget.style) {
      case PPOButtonStyle.primary:
        materialColor = widget.primaryColor;
        backgroundColor = widget.primaryColor;
        textColor = widget.primaryColor.complimentTextColor(widget.brand);
        textStyle = PPOButton.kButtonTextStyleBold.copyWith(color: textColor);
        borderWidth = PPOButton.kButtonBorderWidth;
        borderColor = widget.primaryColor;
        borderRadius = PPOButton.kButtonBorderRadiusRegular;
        iconColor = widget.primaryColor.complimentTextColor(widget.brand);

        if (widget.isFocused) {
          borderColor = widget.focusColor;
        }

        if (displayTappedState) {
          materialColor = Colors.transparent;
          backgroundColor = Colors.transparent;
          textColor = widget.primaryColor;
          iconColor = widget.primaryColor;
          textStyle = PPOButton.kButtonTextStyleBold.copyWith(color: textColor);
          borderColor = widget.primaryColor;

          if (widget.outlineHoverColorOverride != null) {
            textColor = widget.outlineHoverColorOverride!;
            iconColor = widget.outlineHoverColorOverride!;
            borderColor = widget.outlineHoverColorOverride!;
            textStyle = PPOButton.kButtonTextStyleBold.copyWith(color: textColor);
          }
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

      case PPOButtonStyle.outline:
        materialColor = Colors.transparent;
        backgroundColor = Colors.transparent;
        iconColor = widget.primaryColor;
        textColor = widget.primaryColor;
        textStyle = PPOButton.kButtonTextStyleBold.copyWith(color: textColor);
        borderWidth = PPOButton.kButtonBorderWidth;
        borderColor = widget.primaryColor.withOpacity(PPOButton.kButtonOpacityMedium);
        borderRadius = PPOButton.kButtonBorderRadiusRegular;

        if (widget.isFocused) {
          borderColor = widget.focusColor;
        }

        if (displayTappedState) {
          borderColor = widget.primaryColor;
        }

        if (widget.isDisabled) {
          textColor = widget.primaryColor.withOpacity(PPOButton.kButtonOpacityLow);
          iconColor = widget.primaryColor.withOpacity(PPOButton.kButtonOpacityLow);
          textStyle = PPOButton.kButtonTextStyleBold.copyWith(color: textColor);
          borderColor = widget.primaryColor.withOpacity(PPOButton.kButtonOpacityLow);
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
        iconColor = widget.brand.colors.black;

        if (widget.isFocused) {
          borderColor = widget.focusColor;
        }

        if (displayTappedState) {
          iconColor = widget.brand.colors.teal;
          borderWidth = PPOButton.kButtonBorderWidth;
          borderColor = widget.brand.colors.teal;
        }

        if (widget.isDisabled) {
          textColor = widget.brand.colors.black.withOpacity(PPOButton.kButtonOpacityMedium);
          iconColor = widget.brand.colors.black.withOpacity(PPOButton.kButtonOpacityMedium);
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
        iconColor = widget.brand.colors.colorGray7;

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
          borderColor = widget.focusColor;
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
    }

    // This widget is the standard widget when using non-navigation buttons, or icon only buttons.
    // It will expand horizontally to fit its space, however for the other two buttons see below.
    late Widget mainWidget;

    if (widget.style == PPOButtonStyle.navigation) {
      mainWidget = Column(
        children: <Widget>[
          if (widget.iconWidgetBuilder != null) ...<Widget>[
            widget.iconWidgetBuilder!(iconColor),
          ],
          if (widget.iconWidgetBuilder == null) ...<Widget>[
            Icon(widget.icon, color: iconColor, size: iconRadius),
          ],
          Text(
            widget.label,
            style: textStyle,
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else if (widget.layout == PPOButtonLayout.iconOnly) {
      switch (widget.size) {
        case PPOButtonSize.large:
          padding = PPOButton.kIconPaddingLarge;
          break;
        case PPOButtonSize.medium:
          padding = PPOButton.kIconPaddingMedium;
          break;
        case PPOButtonSize.small:
          padding = PPOButton.kIconPaddingSmall;
          break;
      }

      if (widget.iconWidgetBuilder != null) {
        mainWidget = widget.iconWidgetBuilder!(iconColor);
      } else {
        mainWidget = Icon(widget.icon, color: iconColor, size: iconRadius);
      }
    } else {
      mainWidget = Stack(
        fit: StackFit.loose,
        children: <Widget>[
          if (widget.layout == PPOButtonLayout.iconLeft) ...<Widget>[
            if (widget.iconWidgetBuilder != null) ...<Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: widget.iconWidgetBuilder!(iconColor),
              ),
            ],
            if (widget.outlineHoverColorOverride == null) ...<Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Icon(widget.icon, color: iconColor, size: iconRadius),
              ),
            ],
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
            if (widget.outlineHoverColorOverride != null) ...<Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: widget.iconWidgetBuilder!(iconColor),
              ),
            ],
            if (widget.outlineHoverColorOverride == null) ...<Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Icon(widget.icon, color: iconColor, size: iconRadius),
              ),
            ],
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
