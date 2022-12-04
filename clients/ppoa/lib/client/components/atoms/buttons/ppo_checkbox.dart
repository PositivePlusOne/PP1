// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:ppoa/business/extensions/brand_extensions.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/client/components/atoms/buttons/enumerations/ppo_checkbox_style.dart';
import '../../../constants/ppo_design_constants.dart';

class PPOCheckbox extends StatefulWidget {
  const PPOCheckbox({
    required this.brand,
    required this.onTapped,
    required this.label,
    this.tooltip = '',
    this.style = PPOCheckboxStyle.large,
    this.isChecked = true,
    this.isDisabled = false,
    super.key,
  });

  final DesignSystemBrand brand;
  final PPOCheckboxStyle style;

  final Future<void> Function() onTapped;
  final bool isDisabled;
  final bool isChecked;

  final String label;
  final String tooltip;

  static const TextStyle kCheckboxTextStyleSmall = TextStyle(
    fontFamily: kFontAlbertSans,
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
  );

  static const int kCheckboxMaxLineLength = 1;

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
  State<PPOCheckbox> createState() => _PPOCheckboxState();
}

class _PPOCheckboxState extends State<PPOCheckbox> {
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
      case PPOCheckboxStyle.large:
        child = buildLargeCheckbox(context);
        break;
      case PPOCheckboxStyle.small:
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
    Color borderColor = widget.brand.colors.black;
    double iconOpacity = 0.0;

    if (widget.isChecked) {
      containerColor = widget.brand.colors.black;
      iconOpacity = 1.0;
    }

    if (_isTappedOrHovered) {
      containerColor = widget.brand.colors.colorGray4;
      borderColor = widget.brand.colors.colorGray7;
      iconOpacity = 0.0;
    }

    return Row(
      children: <Widget>[
        AnimatedContainer(
          duration: kAnimationDurationRegular,
          width: PPOCheckbox.kCheckboxIconBoxRadiusLarge,
          height: PPOCheckbox.kCheckboxIconBoxRadiusLarge,
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(PPOCheckbox.kCheckboxIconBoxRadiusLarge),
            border: Border.all(
              color: borderColor,
              width: PPOCheckbox.kCheckboxIconBorderWidthLarge,
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            child: AnimatedOpacity(
              opacity: iconOpacity,
              duration: kAnimationDurationRegular,
              child: Icon(
                UniconsSolid.check,
                size: PPOCheckbox.kCheckboxIconRadiusLarge,
                color: widget.brand.colors.white,
              ),
            ),
          ),
        ),
        PPOCheckbox.kCheckboxIconSpacingLarge.asHorizontalWidget,
        Expanded(
          child: Text(
            widget.label,
            maxLines: PPOCheckbox.kCheckboxMaxLineLength,
            overflow: TextOverflow.ellipsis,
            style: PPOCheckbox.kCheckboxTextStyleSmall.copyWith(
              color: widget.brand.colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSmallCheckbox(BuildContext context) {
    //! TODO(ryan): Fix this
    return Container(
      width: double.infinity,
      padding: PPOCheckbox.kCheckboxPaddingSmall,
      decoration: BoxDecoration(
        color: widget.brand.colors.colorGray3.withOpacity(PPOCheckbox.kCheckboxAreaOpacitySmall),
        borderRadius: BorderRadius.circular(PPOCheckbox.kCheckboxAreaRadiusSmall),
      ),
      child: Row(
        children: <Widget>[
          AnimatedContainer(
            duration: kAnimationDurationRegular,
            width: PPOCheckbox.kCheckboxIconBoxRadiusSmall,
            height: PPOCheckbox.kCheckboxIconBoxRadiusSmall,
            decoration: BoxDecoration(
              color: widget.isDisabled ? Colors.transparent : widget.brand.colors.black,
              borderRadius: BorderRadius.circular(PPOCheckbox.kCheckboxIconBoxRadiusSmall),
              border: Border.all(
                color: widget.brand.colors.black,
                width: PPOCheckbox.kCheckboxIconBorderWidthSmall,
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                UniconsSolid.check,
                size: PPOCheckbox.kCheckboxIconRadiusSmall,
                color: widget.isDisabled ? Colors.transparent : widget.brand.colors.white,
              ),
            ),
          ),
          PPOCheckbox.kCheckboxIconSpacingSmall.asHorizontalWidget,
          Expanded(
            child: Text(
              widget.label,
              maxLines: PPOCheckbox.kCheckboxMaxLineLength,
              overflow: TextOverflow.ellipsis,
              style: PPOCheckbox.kCheckboxTextStyleSmall.copyWith(
                color: widget.brand.colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
