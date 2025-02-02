// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/color_extensions.dart';
import '../../../constants/design_constants.dart';
import 'enumerations/positive_button_layout.dart';
import 'enumerations/positive_button_size.dart';
import 'enumerations/positive_button_style.dart';

/// Draws a button from the Figma design system.
/// See: [https://www.figma.com/file/vUl7ODc73HwP9kJ9vseJCd/Design-System?node-id=29%3A3645]
///
/// Most components of the buttons are 1 to 1, for example the different style names.
/// To demo this, use the Simulator with [ppo_button_simulation_view.dart].
class PositiveButton extends StatefulWidget {
  const PositiveButton({
    required this.colors,
    required this.onTapped,
    this.label = '',
    this.primaryColor,
    this.focusColor = const Color(0xFFEDB72B),
    this.outlineHoverColorOverride,
    this.tooltip,
    this.icon,
    this.iconWidgetBuilder,
    this.iconColorOverride,
    this.fontColorOverride,
    this.layout = PositiveButtonLayout.iconLeft,
    this.style = PositiveButtonStyle.primary,
    this.size = PositiveButtonSize.large,
    this.isDisabled = false,
    this.isActive = true,
    this.isFocused = false,
    this.forceTappedState = false,
    this.forceIconPadding = false,
    this.height,
    this.width,
    this.padding,
    this.borderWidth,
    this.includeBadge = false,
    this.badgeColour,
    super.key,
  });

  factory PositiveButton.appBarIcon({
    required DesignColorsModel colors,
    required IconData icon,
    required FutureOr<void> Function() onTapped,
    final bool isDisabled = false,
    final String? tooltip,
    final Color? primaryColor,
    final Color? foregroundColor,
    final PositiveButtonSize size = PositiveButtonSize.medium,
    final PositiveButtonStyle style = PositiveButtonStyle.outline,
    final bool includeBadge = false,
    final Color? badgeColorOverride,
  }) {
    return PositiveButton(
      colors: colors,
      primaryColor: primaryColor ?? colors.black,
      style: style,
      layout: PositiveButtonLayout.iconOnly,
      icon: icon,
      iconColorOverride: foregroundColor,
      size: size,
      onTapped: onTapped,
      isDisabled: isDisabled,
      tooltip: tooltip,
      includeBadge: includeBadge,
      badgeColour: badgeColorOverride ?? colors.red,
    );
  }

  factory PositiveButton.standardPrimary({
    required DesignColorsModel colors,
    required String label,
    required FutureOr<void> Function() onTapped,
    final bool isDisabled = false,
    final String? tooltip,
    final Color? primaryColor,
    final Color? foregroundColor,
    final PositiveButtonSize size = PositiveButtonSize.large,
    final PositiveButtonLayout layout = PositiveButtonLayout.textOnly,
    final bool includeBadge = false,
  }) {
    return PositiveButton(
      colors: colors,
      primaryColor: primaryColor ?? colors.black,
      style: PositiveButtonStyle.primary,
      layout: layout,
      label: label,
      iconColorOverride: foregroundColor,
      size: size,
      onTapped: onTapped,
      isDisabled: isDisabled,
      tooltip: tooltip,
      includeBadge: includeBadge,
    );
  }

  factory PositiveButton.standardPrimaryWithIcon({
    required DesignColorsModel colors,
    required IconData icon,
    required String label,
    required FutureOr<void> Function() onTapped,
    final bool isDisabled = false,
    final String? tooltip,
    final Color? primaryColor,
    final Color? foregroundColor,
    final PositiveButtonSize size = PositiveButtonSize.large,
    final PositiveButtonLayout layout = PositiveButtonLayout.iconLeft,
    final bool includeBadge = false,
  }) {
    return PositiveButton(
      colors: colors,
      primaryColor: primaryColor ?? colors.black,
      style: PositiveButtonStyle.primary,
      layout: layout,
      label: label,
      icon: icon,
      iconColorOverride: foregroundColor,
      size: size,
      onTapped: onTapped,
      isDisabled: isDisabled,
      tooltip: tooltip,
      includeBadge: includeBadge,
    );
  }

  /// The current brand, used to determine the colors.
  final DesignColorsModel colors;

  /// A required callback, returning a future so can be used in mutators.
  final FutureOr<void> Function() onTapped;

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

  /// Overrides the icon color if required, for example white on a white background.
  final Color? iconColorOverride;

  /// Overrides the font color if required, for example white on a white background.
  final Color? fontColorOverride;

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

  /// By default the primary colour used is text black, you can override that with this property.
  final Color? primaryColor;

  /// By default the focus colour used is yellow, you can override that with this property.
  final Color focusColor;

  /// Overrides the outline colour if required, for example white on a white background.
  final Color? outlineHoverColorOverride;

  /// Overrides the default centering of the text to force padding if the button is too small.
  final bool forceIconPadding;

  /// On an icon only style, this will add a badge to the top right of the icon.
  final bool includeBadge;

  /// Overwrite the badge colour.
  final Color? badgeColour;

  final double? height;
  final double? width;

  final EdgeInsets? padding;

  final double? borderWidth;

  /// The text style for most button designs
  static const TextStyle kButtonTextStyleBold = TextStyle(
    fontFamily: 'AlbertSans',
    fontWeight: FontWeight.w900,
    fontSize: 14.0,
  );

  static const TextStyle kButtonTextStyleNavigation = TextStyle(
    fontFamily: 'AlbertSans',
    fontWeight: FontWeight.w800,
    fontSize: 12.0,
  );

  static const TextStyle kButtonTextStyleTab = TextStyle(
    fontFamily: 'AlbertSans',
    fontWeight: FontWeight.w800,
    fontSize: 10.0,
  );

  /// The button padding for most buttons in the design system.
  static const EdgeInsets kButtonPaddingLarge = EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0);
  static const EdgeInsets kButtonPaddingMedium = EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0);
  static const EdgeInsets kButtonPaddingSmall = EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0);
  static const EdgeInsets kButtonPaddingTiny = EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0);
  static const EdgeInsets kButtonPaddingNavigation = EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0);

  static const EdgeInsets kIconPaddingLarge = EdgeInsets.symmetric(horizontal: 13.0, vertical: 13.0);
  static const EdgeInsets kIconPaddingMedium = EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0);
  static const EdgeInsets kIconPaddingSmall = EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0);

  /// The normal border width of a PPO button.
  static const double kButtonBorderWidthNone = 0.0;
  static const double kButtonBorderWidth = 1.0;
  static const double kButtonBorderWidthHovered = 2.0;

  // The border radius of a regular PPO button.
  static const double kButtonBorderRadiusRegular = 100.0;

  // The button icon radius used
  static const double kButtonIconRadiusTab = 30.0;
  static const double kButtonIconRadiusRegular = 24.0;
  static const double kButtonIconRadiusSmall = 18.0;

  // Opacities used in the buttons
  static const double kButtonOpacityFull = 1.0;
  static const double kButtonOpacityGhostEnabled = 0.65;

  static const double kButtonOpacityOutlineBorderDark = 0.3;
  static const double kButtonOpacityOutlineBackgroundDark = 0.02;
  static const double kButtonOpacityOutlineBorderLight = 0.5;
  static const double kButtonOpacityOutlineBackgroundLight = 0.1;

  static const double kButtonOpacityGhost = 0.25;
  static const double kButtonOpacityMedium = 0.3;
  static const double kButtonOpacityLow = 0.2;

  @override
  PositiveButtonState createState() => PositiveButtonState();
}

class PositiveButtonState extends State<PositiveButton> {
  bool _isTappedOrHovered = false;

  Future<void> onTapChanged(bool value, bool fireCallback) async {
    if (!mounted) {
      return;
    }
    try {
      if (fireCallback) {
        await widget.onTapped();
      }
    } finally {
      if (mounted) {
        setState(() => _isTappedOrHovered = value);
      }
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
    assert(widget.label.isNotEmpty || widget.layout == PositiveButtonLayout.iconOnly, 'A label must be supplied for a button that is not icon only.');
    assert(widget.layout != PositiveButtonLayout.iconOnly || widget.icon != null, 'An icon must be supplied for a button that is icon only.');

    final bool displayTappedState = _isTappedOrHovered || widget.forceTappedState;

    late Color materialColor;
    late Color backgroundColor;

    late Color textColor;
    late TextStyle textStyle;

    late double borderWidth;
    late Color borderColor;
    late double borderRadius;

    late Color badgeColour;

    double? paddingWidth;

    late EdgeInsets calculatedPadding;

    late Color iconColor;
    late double iconRadius;
    double iconPadding = 10.0;

    final Color primaryColor = widget.primaryColor ?? widget.colors.black;

    switch (widget.size) {
      case PositiveButtonSize.large:
        calculatedPadding = widget.padding ?? PositiveButton.kButtonPaddingLarge;
        iconRadius = PositiveButton.kButtonIconRadiusRegular;
        break;
      case PositiveButtonSize.medium:
        calculatedPadding = widget.padding ?? PositiveButton.kButtonPaddingMedium;
        iconRadius = PositiveButton.kButtonIconRadiusRegular;
        break;
      case PositiveButtonSize.small:
        calculatedPadding = widget.padding ?? PositiveButton.kButtonPaddingSmall;
        iconRadius = PositiveButton.kButtonIconRadiusSmall;
        break;
    }

    switch (widget.style) {
      case PositiveButtonStyle.primary:
        materialColor = primaryColor;
        backgroundColor = primaryColor;
        textColor = primaryColor.complimentTextColor;
        textStyle = PositiveButton.kButtonTextStyleBold.copyWith(color: textColor);
        borderWidth = PositiveButton.kButtonBorderWidthNone;
        borderColor = primaryColor;
        borderRadius = PositiveButton.kButtonBorderRadiusRegular;
        badgeColour = widget.badgeColour ?? widget.colors.red;
        iconColor = primaryColor.complimentTextColor;

        if (widget.isFocused) {
          borderColor = widget.focusColor;
        }

        if (displayTappedState) {
          materialColor = Colors.transparent;
          backgroundColor = Colors.transparent;
          textColor = primaryColor;
          iconColor = primaryColor;
          textStyle = PositiveButton.kButtonTextStyleBold.copyWith(color: textColor);
          borderColor = primaryColor;
          borderWidth = PositiveButton.kButtonBorderWidthHovered;

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

      case PositiveButtonStyle.primaryBorder:
        materialColor = primaryColor;
        backgroundColor = primaryColor;
        textColor = primaryColor.complimentTextColor;
        textStyle = PositiveButton.kButtonTextStyleBold.copyWith(color: textColor);
        borderWidth = PositiveButton.kButtonBorderWidth;
        borderColor = primaryColor.complimentTextColor;
        borderRadius = PositiveButton.kButtonBorderRadiusRegular;
        badgeColour = widget.badgeColour ?? widget.colors.red;
        iconColor = primaryColor.complimentTextColor;

        if (widget.isFocused) {
          borderColor = widget.focusColor;
        }

        if (displayTappedState) {
          materialColor = Colors.transparent;
          backgroundColor = Colors.transparent;
          textColor = primaryColor;
          iconColor = primaryColor;
          textStyle = PositiveButton.kButtonTextStyleBold.copyWith(color: textColor);
          borderColor = primaryColor;
          borderWidth = PositiveButton.kButtonBorderWidthHovered;

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

      case PositiveButtonStyle.ghost:
        materialColor = widget.colors.colorGray1.withOpacity(PositiveButton.kButtonOpacityGhost);
        backgroundColor = widget.colors.colorGray1.withOpacity(PositiveButton.kButtonOpacityGhost);
        textColor = widget.colors.black.withOpacity(PositiveButton.kButtonOpacityGhostEnabled);
        iconColor = widget.colors.black.withOpacity(PositiveButton.kButtonOpacityGhostEnabled);
        textStyle = PositiveButton.kButtonTextStyleBold.copyWith(color: textColor);
        borderWidth = PositiveButton.kButtonBorderWidthNone;
        borderColor = widget.colors.colorGray1.withOpacity(PositiveButton.kButtonOpacityGhost);
        borderRadius = PositiveButton.kButtonBorderRadiusRegular;
        badgeColour = widget.badgeColour ?? widget.colors.red;

        if (widget.isFocused) {
          borderColor = widget.focusColor;
        }

        if (displayTappedState) {
          materialColor = widget.colors.colorGray1.withOpacity(PositiveButton.kButtonOpacityGhost);
          backgroundColor = widget.colors.colorGray1.withOpacity(PositiveButton.kButtonOpacityGhost);
          textColor = widget.colors.colorGray7.withOpacity(PositiveButton.kButtonOpacityGhost);
          iconColor = widget.colors.colorGray7.withOpacity(PositiveButton.kButtonOpacityGhost);
          textStyle = PositiveButton.kButtonTextStyleBold.copyWith(color: textColor);
          borderColor = widget.colors.colorGray1.withOpacity(PositiveButton.kButtonOpacityGhost);
          borderWidth = PositiveButton.kButtonBorderWidthHovered;

          if (widget.outlineHoverColorOverride != null) {
            textColor = widget.outlineHoverColorOverride!;
            iconColor = widget.outlineHoverColorOverride!;
            borderColor = widget.outlineHoverColorOverride!;
            textStyle = PositiveButton.kButtonTextStyleBold.copyWith(color: textColor);
          }
        }

        if (widget.isDisabled) {
          materialColor = widget.colors.colorGray1.withOpacity(PositiveButton.kButtonOpacityGhost);
          backgroundColor = widget.colors.colorGray1.withOpacity(PositiveButton.kButtonOpacityGhost);
          textColor = widget.colors.colorGray7.withOpacity(PositiveButton.kButtonOpacityGhost);
          iconColor = widget.colors.colorGray7.withOpacity(PositiveButton.kButtonOpacityGhost);
          textStyle = PositiveButton.kButtonTextStyleBold.copyWith(color: textColor);
          borderColor = widget.colors.colorGray1.withOpacity(PositiveButton.kButtonOpacityGhost);
        }
        break;

      case PositiveButtonStyle.outline:
        final Brightness brightness = primaryColor.computeLuminance() > 0.5 ? Brightness.light : Brightness.dark;
        final Color newBackgroundColor = switch (brightness) {
          Brightness.dark => widget.colors.black.withOpacity(PositiveButton.kButtonOpacityOutlineBackgroundDark),
          Brightness.light => widget.colors.white.withOpacity(PositiveButton.kButtonOpacityOutlineBackgroundLight),
        };

        final Color newBorderColor = switch (brightness) {
          Brightness.dark => widget.colors.black.withOpacity(PositiveButton.kButtonOpacityOutlineBorderDark),
          Brightness.light => widget.colors.white.withOpacity(PositiveButton.kButtonOpacityOutlineBorderLight),
        };

        materialColor = newBackgroundColor;
        backgroundColor = newBackgroundColor;
        iconColor = primaryColor;
        textColor = primaryColor;
        textStyle = PositiveButton.kButtonTextStyleBold.copyWith(color: textColor);
        borderWidth = PositiveButton.kButtonBorderWidth;
        borderColor = newBorderColor;
        borderRadius = PositiveButton.kButtonBorderRadiusRegular;
        badgeColour = widget.badgeColour ?? widget.colors.red;

        if (widget.isFocused) {
          borderColor = widget.focusColor;
        }

        if (displayTappedState) {
          borderColor = widget.colors.black;
        }

        if (widget.isDisabled) {
          textColor = primaryColor.withOpacity(PositiveButton.kButtonOpacityLow);
          iconColor = primaryColor.withOpacity(PositiveButton.kButtonOpacityLow);
          textStyle = PositiveButton.kButtonTextStyleBold.copyWith(color: textColor);
          borderColor = widget.colors.black.withOpacity(PositiveButton.kButtonOpacityLow);
        }
        break;

      case PositiveButtonStyle.text:
        materialColor = Colors.transparent;
        backgroundColor = Colors.transparent;
        textColor = primaryColor;
        textStyle = PositiveButton.kButtonTextStyleBold.copyWith(color: textColor);
        borderWidth = PositiveButton.kButtonBorderWidthNone;
        borderColor = Colors.transparent;
        borderRadius = PositiveButton.kButtonBorderRadiusRegular;
        badgeColour = widget.badgeColour ?? widget.colors.red;
        iconColor = primaryColor;

        if (widget.isFocused) {
          borderColor = widget.focusColor;
        }

        if (displayTappedState) {
          iconColor = widget.colors.teal;
          borderColor = widget.colors.teal;
          borderWidth = PositiveButton.kButtonBorderWidthHovered;
        }

        if (widget.isDisabled) {
          textColor = primaryColor.withOpacity(PositiveButton.kButtonOpacityMedium);
          iconColor = primaryColor.withOpacity(PositiveButton.kButtonOpacityMedium);
          textStyle = PositiveButton.kButtonTextStyleBold.copyWith(color: textColor);
        }
        break;

      case PositiveButtonStyle.navigation:
        materialColor = Colors.transparent;
        backgroundColor = Colors.transparent;
        textColor = widget.colors.colorGray6;
        textStyle = PositiveButton.kButtonTextStyleNavigation.copyWith(color: textColor);
        borderWidth = PositiveButton.kButtonBorderWidthNone;
        calculatedPadding = widget.padding ?? PositiveButton.kButtonPaddingNavigation;
        borderColor = Colors.transparent;
        borderRadius = PositiveButton.kButtonBorderRadiusRegular;
        badgeColour = widget.badgeColour ?? widget.colors.red;
        iconColor = widget.colors.colorGray6;
        iconRadius = PositiveButton.kButtonIconRadiusRegular;

        if (widget.isActive) {
          materialColor = widget.colors.white;
          backgroundColor = widget.colors.white;
          textColor = widget.primaryColor ?? widget.colors.red;
          textStyle = PositiveButton.kButtonTextStyleNavigation.copyWith(color: textColor);
          iconColor = widget.primaryColor ?? widget.colors.red;
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
          borderWidth = PositiveButton.kButtonBorderWidthHovered;
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
        textColor = widget.iconColorOverride ?? widget.colors.colorGray6;
        iconColor = widget.iconColorOverride ?? widget.colors.colorGray6;
        textStyle = PositiveButton.kButtonTextStyleTab.copyWith(color: textColor);
        borderWidth = PositiveButton.kButtonBorderWidthNone;
        borderColor = Colors.transparent;
        borderRadius = PositiveButton.kButtonBorderRadiusRegular;
        badgeColour = widget.badgeColour ?? widget.colors.red;
        calculatedPadding = widget.padding ?? EdgeInsets.zero;
        iconRadius = PositiveButton.kButtonIconRadiusTab;

        if (widget.isActive) {
          materialColor = primaryColor;
          backgroundColor = primaryColor;
          textStyle = PositiveButton.kButtonTextStyleTab.copyWith(color: textColor);
        }

        if (displayTappedState) {
          materialColor = widget.colors.green;
          backgroundColor = widget.colors.green;
          textColor = widget.colors.colorGray6;
          textStyle = PositiveButton.kButtonTextStyleTab.copyWith(color: textColor);
          borderWidth = PositiveButton.kButtonBorderWidthHovered;
        }

        if (widget.isDisabled) {
          materialColor = widget.colors.white;
          backgroundColor = widget.colors.white;
          textColor = widget.colors.colorGray4;
          textStyle = PositiveButton.kButtonTextStyleTab.copyWith(color: textColor);
        }
        break;

      case PositiveButtonStyle.post:
        materialColor = primaryColor.withOpacity(kOpacityFaint);
        backgroundColor = Colors.white;
        iconColor = Colors.black;
        textColor = Colors.black;
        textStyle = PositiveButton.kButtonTextStyleBold.copyWith(color: textColor);
        borderWidth = kPaddingNone;
        borderColor = Colors.transparent;
        borderRadius = PositiveButton.kButtonBorderRadiusRegular;
        badgeColour = widget.badgeColour ?? widget.colors.red;

        paddingWidth = kPaddingSmallMedium;

        if (widget.isDisabled) {
          materialColor = Colors.transparent;
          backgroundColor = Colors.transparent;
          textColor = primaryColor;
          iconColor = primaryColor;
          textStyle = PositiveButton.kButtonTextStyleBold.copyWith(color: textColor);
          borderWidth = kPaddingNone;
          borderRadius = PositiveButton.kButtonBorderRadiusRegular;
          borderColor = primaryColor;
        }
        break;
    }

    if (widget.iconColorOverride != null) {
      iconColor = widget.iconColorOverride!;
    }

    if (widget.fontColorOverride != null) {
      textColor = widget.fontColorOverride!;
      textStyle = textStyle.copyWith(color: textColor);
    }

    // This widget is the standard widget when using non-navigation buttons, or icon only buttons.
    // It will expand horizontally to fit its space, however for the other two buttons see below.
    late Widget mainWidget;

    if (widget.style == PositiveButtonStyle.navigation) {
      mainWidget = Stack(
        alignment: Alignment.center,
        fit: StackFit.loose,
        children: <Widget>[
          Column(
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
          ),
          if (widget.includeBadge) ...<Widget>[
            Align(
              alignment: Alignment.center,
              child: Transform.translate(
                // Use iconRadius as the offset to ensure the badge is close to the icon.
                offset: Offset(iconRadius * 0.60, -iconRadius * 0.85),
                child: Container(
                  width: iconPadding,
                  height: iconPadding,
                  decoration: BoxDecoration(
                    color: badgeColour,
                    borderRadius: BorderRadius.circular(iconPadding),
                  ),
                ),
              ),
            ),
          ],
        ],
      );
    } else if (widget.layout == PositiveButtonLayout.iconOnly) {
      switch (widget.size) {
        case PositiveButtonSize.large:
          calculatedPadding = widget.padding ?? PositiveButton.kIconPaddingLarge;
          break;
        case PositiveButtonSize.medium:
          calculatedPadding = widget.padding ?? PositiveButton.kIconPaddingMedium;
          break;
        case PositiveButtonSize.small:
          calculatedPadding = widget.padding ?? PositiveButton.kIconPaddingSmall;
          break;
      }

      late final Widget icon;
      if (widget.iconWidgetBuilder != null) {
        icon = widget.iconWidgetBuilder!(iconColor);
      } else {
        icon = Icon(widget.icon, color: iconColor, size: iconRadius);
      }

      mainWidget = Stack(
        alignment: Alignment.center,
        fit: StackFit.loose,
        clipBehavior: Clip.none,
        children: <Widget>[
          icon,
          if (widget.includeBadge) ...<Widget>[
            Transform.translate(
              // Use iconRadius as the offset to ensure the badge is close to the icon.
              offset: Offset(iconRadius * 0.55, -iconRadius * 0.55),
              child: Container(
                width: iconPadding,
                height: iconPadding,
                decoration: BoxDecoration(
                  color: badgeColour,
                  borderRadius: BorderRadius.circular(iconPadding),
                ),
              ),
            ),
          ],
        ],
      );
    } else {
      mainWidget = Stack(
        alignment: Alignment.center,
        fit: StackFit.loose,
        children: <Widget>[
          if (widget.layout == PositiveButtonLayout.iconLeft) ...<Widget>[
            if (widget.iconWidgetBuilder != null) ...<Widget>[
              Positioned(
                left: kPaddingNone,
                child: widget.iconWidgetBuilder!(iconColor),
              ),
            ],
            if (widget.iconWidgetBuilder == null) ...<Widget>[
              Positioned(
                left: kPaddingNone,
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
              Positioned(
                right: kPaddingNone,
                child: widget.iconWidgetBuilder!(iconColor),
              ),
            ],
            if (widget.iconWidgetBuilder == null) ...<Widget>[
              Positioned(
                right: kPaddingNone,
                child: Icon(widget.icon, color: iconColor, size: iconRadius),
              ),
            ],
          ],
        ],
      );
    }

    final double? widgetHeight = widget.height == null ? null : widget.height! - (paddingWidth ?? kPaddingNone);

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
              child: Padding(
                padding: EdgeInsets.all(paddingWidth ?? kPaddingNone),
                child: AnimatedContainer(
                  padding: widget.padding ?? (calculatedPadding - EdgeInsets.all(widget.borderWidth ?? borderWidth)).clamp(EdgeInsets.zero, const EdgeInsets.all(double.infinity)),
                  duration: kAnimationDurationRegular,
                  height: widgetHeight,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: (widget.borderWidth ?? borderWidth) == kBorderThicknessNone
                        ? null
                        : Border.all(
                            color: borderColor,
                            width: widget.borderWidth ?? borderWidth,
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
      ),
    );
  }
}
