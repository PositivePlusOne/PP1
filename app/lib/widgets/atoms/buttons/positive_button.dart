// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/color_extensions.dart';
import '../../../constants/design_constants.dart';
import 'enumerations/positive_button_layout.dart';
import 'enumerations/positive_button_size.dart';
import 'enumerations/positive_button_style.dart';

/// Draws an button from the Figma design system.
/// See: [https://www.figma.com/file/vUl7ODc73HwP9kJ9vseJCd/Design-System?node-id=29%3A3645]
///
/// Most components of the buttons are 1 to 1, for example the different style names.
/// To demo this, use the Simulator with [ppo_button_simulation_view.dart].
class PositiveButton extends StatefulWidget {
  const PositiveButton({
    required this.colors,
    required this.onTapped,
    this.label = '',
    this.primaryColor = Colors.white,
    this.focusColor = const Color(0xFFEDB72B),
    this.outlineHoverColorOverride,
    this.tooltip,
    this.icon,
    this.iconWidgetBuilder,
    this.layout = PositiveButtonLayout.iconLeft,
    this.style = PositiveButtonStyle.primary,
    this.size = PositiveButtonSize.large,
    this.isDisabled = false,
    this.isActive = true,
    this.isFocused = false,
    this.forceTappedState = false,
    this.forceIconPadding = false,
    super.key,
  });

  /// The current brand, used to determine the colors.
  final DesignColorsModel colors;

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
  final PositiveButtonLayout layout;

  /// The design button style for the button.
  /// Examples of this can be seen in figma or the documentation for each.
  final PositiveButtonStyle style;

  /// The design sizes. Changes the padding and margins
  final PositiveButtonSize size;

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

  /// Overrides the default centering of the text to force padding if the button is too small.
  final bool forceIconPadding;

  /// The text style for most button designs
  static const TextStyle kButtonTextStyleBold = TextStyle(
    fontFamily: 'AlbertSans',
    fontWeight: FontWeight.w900,
    fontSize: 14.0,
  );

  static const TextStyle kButtonTextStyleNavigation = TextStyle(
    fontFamily: 'AlbertSans',
    fontWeight: FontWeight.w800,
    fontSize: 11.0,
  );

  static const TextStyle kButtonTextStyleTab = TextStyle(
    fontFamily: 'AlbertSans',
    fontWeight: FontWeight.w800,
    fontSize: 10.0,
  );

  /// The button padding for most buttons in the design system.
  static const EdgeInsets kButtonPaddingLarge = EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0);
  static const EdgeInsets kButtonPaddingMedium = EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0);
  static const EdgeInsets kButtonPaddingSmall = EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0);
  static const EdgeInsets kButtonPaddingNavigation = EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0);

  static const EdgeInsets kIconPaddingLarge = EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0);
  static const EdgeInsets kIconPaddingMedium = EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0);
  static const EdgeInsets kIconPaddingSmall = EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0);

  /// The normal border width of a PPO button.
  static const double kButtonBorderWidth = 2.0;

  // The border radius of a regular PPO button.
  static const double kButtonBorderRadiusRegular = 100.0;

  // The button icon radius used
  static const double kButtonIconRadiusTab = 30.0;
  static const double kButtonIconRadiusRegular = 24.0;
  static const double kButtonIconRadiusSmall = 18.0;

  // Opacities used in the buttons
  static const double kButtonOpacityFull = 1.0;
  static const double kButtonOpacityMedium = 0.3;
  static const double kButtonOpacityLow = 0.2;

  @override
  State<PositiveButton> createState() => _PositiveButtonState();
}

class _PositiveButtonState extends State<PositiveButton> {
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
      case PositiveButtonSize.large:
        padding = PositiveButton.kButtonPaddingLarge;
        iconRadius = PositiveButton.kButtonIconRadiusRegular;
        break;
      case PositiveButtonSize.medium:
        padding = PositiveButton.kButtonPaddingMedium;
        iconRadius = PositiveButton.kButtonIconRadiusRegular;
        break;
      case PositiveButtonSize.small:
        padding = PositiveButton.kButtonPaddingSmall;
        iconRadius = PositiveButton.kButtonIconRadiusSmall;
        break;
    }

    switch (widget.style) {
      case PositiveButtonStyle.primary:
        materialColor = widget.primaryColor;
        backgroundColor = widget.primaryColor;
        textColor = widget.primaryColor.complimentTextColor(widget.colors);
        textStyle = PositiveButton.kButtonTextStyleBold.copyWith(color: textColor);
        borderWidth = PositiveButton.kButtonBorderWidth;
        borderColor = widget.primaryColor;
        borderRadius = PositiveButton.kButtonBorderRadiusRegular;
        iconColor = widget.primaryColor.complimentTextColor(widget.colors);

        if (widget.isFocused) {
          borderColor = widget.focusColor;
        }

        if (displayTappedState) {
          materialColor = Colors.transparent;
          backgroundColor = Colors.transparent;
          textColor = widget.primaryColor;
          iconColor = widget.primaryColor;
          textStyle = PositiveButton.kButtonTextStyleBold.copyWith(color: textColor);
          borderColor = widget.primaryColor;

          if (widget.outlineHoverColorOverride != null) {
            textColor = widget.outlineHoverColorOverride!;
            iconColor = widget.outlineHoverColorOverride!;
            borderColor = widget.outlineHoverColorOverride!;
            textStyle = PositiveButton.kButtonTextStyleBold.copyWith(color: textColor);
          }
        }

        if (widget.isDisabled) {
          materialColor = widget.colors.colorGray1;
          backgroundColor = widget.colors.colorGray1;
          textColor = widget.colors.colorGray4;
          iconColor = widget.colors.colorGray4;
          textStyle = PositiveButton.kButtonTextStyleBold.copyWith(color: textColor);
          borderColor = widget.colors.colorGray1;
        }
        break;

      case PositiveButtonStyle.outline:
        materialColor = Colors.transparent;
        backgroundColor = Colors.transparent;
        iconColor = widget.primaryColor;
        textColor = widget.primaryColor;
        textStyle = PositiveButton.kButtonTextStyleBold.copyWith(color: textColor);
        borderWidth = PositiveButton.kButtonBorderWidth;
        borderColor = widget.primaryColor.withOpacity(PositiveButton.kButtonOpacityMedium);
        borderRadius = PositiveButton.kButtonBorderRadiusRegular;

        if (widget.isFocused) {
          borderColor = widget.focusColor;
        }

        if (displayTappedState) {
          borderColor = widget.primaryColor;
        }

        if (widget.isDisabled) {
          textColor = widget.primaryColor.withOpacity(PositiveButton.kButtonOpacityLow);
          iconColor = widget.primaryColor.withOpacity(PositiveButton.kButtonOpacityLow);
          textStyle = PositiveButton.kButtonTextStyleBold.copyWith(color: textColor);
          borderColor = widget.primaryColor.withOpacity(PositiveButton.kButtonOpacityLow);
        }
        break;

      case PositiveButtonStyle.text:
        materialColor = Colors.transparent;
        backgroundColor = Colors.transparent;
        textColor = widget.colors.black;
        textStyle = PositiveButton.kButtonTextStyleBold.copyWith(color: textColor);
        borderWidth = PositiveButton.kButtonBorderWidth;
        borderColor = Colors.transparent;
        borderRadius = PositiveButton.kButtonBorderRadiusRegular;
        iconColor = widget.colors.black;

        if (widget.isFocused) {
          borderColor = widget.focusColor;
        }

        if (displayTappedState) {
          iconColor = widget.colors.teal;
          borderWidth = PositiveButton.kButtonBorderWidth;
          borderColor = widget.colors.teal;
        }

        if (widget.isDisabled) {
          textColor = widget.colors.black.withOpacity(PositiveButton.kButtonOpacityMedium);
          iconColor = widget.colors.black.withOpacity(PositiveButton.kButtonOpacityMedium);
          textStyle = PositiveButton.kButtonTextStyleBold.copyWith(color: textColor);
        }
        break;

      case PositiveButtonStyle.navigation:
        materialColor = Colors.transparent;
        backgroundColor = Colors.transparent;
        textColor = widget.colors.colorGray6;
        textStyle = PositiveButton.kButtonTextStyleNavigation.copyWith(color: textColor);
        borderWidth = PositiveButton.kButtonBorderWidth;
        borderColor = Colors.transparent;
        borderRadius = PositiveButton.kButtonBorderRadiusRegular;
        iconColor = widget.colors.colorGray7;
        padding = PositiveButton.kButtonPaddingNavigation;
        iconRadius = PositiveButton.kButtonIconRadiusRegular;

        if (widget.isActive) {
          materialColor = widget.colors.white;
          backgroundColor = widget.colors.white;
          textColor = widget.colors.purple;
          textStyle = PositiveButton.kButtonTextStyleNavigation.copyWith(color: textColor);
          iconColor = widget.colors.purple;
          borderColor = widget.colors.white;
        }

        if (widget.isFocused) {
          materialColor = widget.colors.white;
          backgroundColor = widget.colors.white;
          textColor = widget.colors.colorGray7;
          textStyle = PositiveButton.kButtonTextStyleNavigation.copyWith(color: textColor);
          iconColor = widget.colors.colorGray7;
          borderColor = widget.focusColor;
        }

        if (displayTappedState) {
          materialColor = widget.colors.white;
          backgroundColor = widget.colors.white;
          textColor = widget.colors.colorGray7;
          textStyle = PositiveButton.kButtonTextStyleNavigation.copyWith(color: textColor);
          iconColor = widget.colors.colorGray7;
          borderColor = widget.colors.white;
        }

        if (widget.isDisabled) {
          materialColor = widget.colors.white;
          backgroundColor = widget.colors.white;
          textColor = widget.colors.colorGray4;
          textStyle = PositiveButton.kButtonTextStyleNavigation.copyWith(color: textColor);
          iconColor = widget.colors.colorGray4;
          borderColor = widget.colors.white;
        }
        break;

      case PositiveButtonStyle.tab:
        materialColor = Colors.transparent;
        backgroundColor = Colors.transparent;
        textColor = widget.colors.colorGray6;
        iconColor = widget.colors.colorGray6;
        textStyle = PositiveButton.kButtonTextStyleTab.copyWith(color: textColor);
        borderWidth = PositiveButton.kButtonBorderWidth;
        borderColor = Colors.transparent;
        borderRadius = PositiveButton.kButtonBorderRadiusRegular;
        padding = EdgeInsets.zero;
        iconRadius = PositiveButton.kButtonIconRadiusTab;

        if (widget.isActive) {
          materialColor = widget.primaryColor;
          backgroundColor = widget.primaryColor;
          textStyle = PositiveButton.kButtonTextStyleTab.copyWith(color: textColor);
        }

        if (displayTappedState) {
          materialColor = widget.colors.green;
          backgroundColor = widget.colors.green;
          textColor = widget.colors.colorGray6;
          textStyle = PositiveButton.kButtonTextStyleTab.copyWith(color: textColor);
        }

        if (widget.isDisabled) {
          materialColor = widget.colors.white;
          backgroundColor = widget.colors.white;
          textColor = widget.colors.colorGray4;
          textStyle = PositiveButton.kButtonTextStyleTab.copyWith(color: textColor);
        }
        break;
    }

    // This widget is the standard widget when using non-navigation buttons, or icon only buttons.
    // It will expand horizontally to fit its space, however for the other two buttons see below.
    late Widget mainWidget;

    if (widget.style == PositiveButtonStyle.navigation) {
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else if (widget.layout == PositiveButtonLayout.iconOnly) {
      switch (widget.size) {
        case PositiveButtonSize.large:
          padding = PositiveButton.kIconPaddingLarge;
          break;
        case PositiveButtonSize.medium:
          padding = PositiveButton.kIconPaddingMedium;
          break;
        case PositiveButtonSize.small:
          padding = PositiveButton.kIconPaddingSmall;
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
          if (widget.layout == PositiveButtonLayout.iconLeft) ...<Widget>[
            if (widget.iconWidgetBuilder != null) ...<Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: widget.iconWidgetBuilder!(iconColor),
              ),
            ],
            if (widget.iconWidgetBuilder == null) ...<Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Icon(widget.icon, color: iconColor, size: iconRadius),
              ),
            ],
          ],
          Padding(
            padding: EdgeInsets.only(
              left: widget.forceIconPadding && widget.layout == PositiveButtonLayout.iconLeft ? iconRadius + kPaddingSmall : 0.0,
              right: widget.forceIconPadding && widget.layout == PositiveButtonLayout.iconRight ? iconRadius + kPaddingSmall : 0.0,
            ),
            child: SizedBox(
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
          ),
          if (widget.layout == PositiveButtonLayout.iconRight) ...<Widget>[
            if (widget.iconWidgetBuilder != null) ...<Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: widget.iconWidgetBuilder!(iconColor),
              ),
            ],
            if (widget.iconWidgetBuilder == null) ...<Widget>[
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
