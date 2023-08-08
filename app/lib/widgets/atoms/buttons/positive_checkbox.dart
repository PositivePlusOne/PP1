// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:app/providers/system/design_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Package imports:
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import '../../../constants/design_constants.dart';
import 'enumerations/positive_checkbox_style.dart';

class PositiveCheckbox extends StatefulWidget {
  const PositiveCheckbox({
    required this.colors,
    required this.onTapped,
    required this.label,
    this.icon,
    this.tooltip = '',
    this.style = PositiveCheckboxStyle.large,
    this.isChecked = true,
    this.isDisabled = false,
    this.iconBackground,
    super.key,
  });

  final Color? iconBackground;
  final DesignColorsModel colors;
  final PositiveCheckboxStyle style;

  final FutureOr<void> Function() onTapped;
  final bool isDisabled;
  final bool isChecked;

  final Widget? icon;

  final String label;
  final String tooltip;

  static const TextStyle kCheckboxTextStyleSmall = TextStyle(
    fontFamily: 'AlbertSans',
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
  );

  static const TextStyle kCheckboxTextStyleLight = TextStyle(
    fontFamily: 'AlbertSans',
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
  );
  static const int kCheckboxMaxLineLength = 1;

  static const double kCheckboxIconRadiusTiny = 14.0;
  static const double kCheckboxIconRadiusSmall = 18.0;
  static const double kCheckboxIconBoxRadiusSmall = 24.0;

  static const double kCheckboxIconRadiusLarge = 24.0;
  static const double kCheckboxIconBoxRadiusLarge = 44.0;

  static const double kCheckboxAreaRadiusSmall = 10.0;

  static const double kCheckboxIconBorderWidthSmall = 2.0;
  static const double kCheckboxIconBorderWidthLarge = 2.0;

  static const double kCheckboxAreaOpacitySmall = 0.25;

  static const double kCheckboxIconSpacingSmall = 15.0;
  static const double kCheckboxIconSpacingLarge = 10.0;

  static const EdgeInsets kCheckboxPaddingSmall = EdgeInsets.symmetric(
    horizontal: 10.0,
    vertical: 5.0,
  );

  @override
  State<PositiveCheckbox> createState() => _PositiveCheckboxState();
}

class _PositiveCheckboxState extends State<PositiveCheckbox> {
  bool _isTappedOrHovered = false;

  Future<void> onTapChanged(bool value, bool fireCallback) async {
    if (!mounted) {
      return;
    }

    if (fireCallback) {
      await widget.onTapped();
    }

    setState(() => _isTappedOrHovered = value);
  }

  void onHoverChanged(bool value) {
    if (!mounted) {
      return;
    }

    setState(() => _isTappedOrHovered = value);
  }

  @override
  Widget build(BuildContext context) {
    late Widget child;
    switch (widget.style) {
      case PositiveCheckboxStyle.large:
        child = buildLargeCheckbox(context);
        break;
      case PositiveCheckboxStyle.small:
        child = buildSmallCheckbox(context);
        break;
    }

    return Material(
      type: MaterialType.transparency,
      child: Tooltip(
        message: widget.tooltip,
        child: IgnorePointer(
          ignoring: widget.isDisabled,
          child: GestureDetector(
            onTapDown: (_) => onTapChanged(true, false),
            onTapUp: (_) => onTapChanged(false, true),
            onTapCancel: () => onTapChanged(false, false),
            child: MouseRegion(
              onEnter: (_) => onHoverChanged(true),
              onExit: (_) => onHoverChanged(false),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLargeCheckbox(BuildContext context) {
    Color containerColor = Colors.transparent;
    Color borderColor = widget.colors.black;
    double iconOpacity = 0.0;

    if (widget.isChecked) {
      containerColor = widget.colors.black;
      iconOpacity = 1.0;
    }

    if (_isTappedOrHovered) {
      containerColor = widget.colors.colorGray4;
      borderColor = widget.colors.colorGray7;
      iconOpacity = 0.0;
    }

    return Row(
      children: <Widget>[
        AnimatedContainer(
          duration: kAnimationDurationRegular,
          width: PositiveCheckbox.kCheckboxIconBoxRadiusLarge,
          height: PositiveCheckbox.kCheckboxIconBoxRadiusLarge,
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(PositiveCheckbox.kCheckboxIconBoxRadiusLarge),
            border: Border.all(
              color: borderColor,
              width: PositiveCheckbox.kCheckboxIconBorderWidthLarge,
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            child: AnimatedOpacity(
              opacity: iconOpacity,
              duration: kAnimationDurationRegular,
              child: widget.icon ??
                  Icon(
                    UniconsSolid.check,
                    size: PositiveCheckbox.kCheckboxIconRadiusLarge,
                    color: widget.colors.white,
                  ),
            ),
          ),
        ),
        const SizedBox(width: PositiveCheckbox.kCheckboxIconSpacingLarge),
        Expanded(
          child: Text(
            widget.label,
            maxLines: PositiveCheckbox.kCheckboxMaxLineLength,
            overflow: TextOverflow.ellipsis,
            style: PositiveCheckbox.kCheckboxTextStyleLight.copyWith(
              color: widget.colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSmallCheckbox(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: PositiveCheckbox.kCheckboxPaddingSmall,
      decoration: BoxDecoration(
        color: widget.colors.colorGray3.withOpacity(PositiveCheckbox.kCheckboxAreaOpacitySmall),
        borderRadius: BorderRadius.circular(PositiveCheckbox.kCheckboxAreaRadiusSmall),
      ),
      child: Row(
        children: <Widget>[
          PositiveCheckboxIndicator(
            backgroundColor: widget.isDisabled ? Colors.transparent : widget.iconBackground ?? widget.colors.black,
            borderColor: widget.iconBackground,
            icon: widget.icon,
            isChecked: !widget.isDisabled,
          ),
          const SizedBox(width: PositiveCheckbox.kCheckboxIconSpacingSmall),
          Expanded(
            child: Text(
              widget.label,
              maxLines: PositiveCheckbox.kCheckboxMaxLineLength,
              overflow: TextOverflow.ellipsis,
              style: PositiveCheckbox.kCheckboxTextStyleLight.copyWith(
                color: widget.colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PositiveCheckboxIndicator extends ConsumerWidget {
  const PositiveCheckboxIndicator({
    required this.backgroundColor,
    this.borderColor,
    this.icon,
    this.isChecked = false,
    this.radius = PositiveCheckbox.kCheckboxIconRadiusSmall,
    super.key,
  });

  final Color backgroundColor;
  final Color? borderColor;
  final Widget? icon;

  final bool isChecked;

  final double radius;

  static const double kIconRadiusRatio = 1.2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    return AnimatedContainer(
      duration: kAnimationDurationRegular,
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: borderColor ?? colors.black,
          width: PositiveCheckbox.kCheckboxIconBorderWidthSmall,
        ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: icon ??
            Icon(
              UniconsSolid.check,
              size: radius / kIconRadiusRatio,
              color: !isChecked ? Colors.transparent : colors.white,
            ),
      ),
    );
  }
}
