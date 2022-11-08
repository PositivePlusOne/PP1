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
    fontWeight: FontWeight.w400,
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
  Future<void> _onCheckboxTapped() async {
    if (!mounted) {
      return;
    }

    await widget.onTapped();
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
            onTap: _onCheckboxTapped,
            child: child,
          ),
        ),
      ),
    );
  }

  Widget buildLargeCheckbox(BuildContext context) {
    return Row(
      children: <Widget>[
        AnimatedContainer(
          duration: kAnimationDurationRegular,
          width: PPOCheckbox.kCheckboxIconBoxRadiusLarge,
          height: PPOCheckbox.kCheckboxIconBoxRadiusLarge,
          decoration: BoxDecoration(
            color: widget.isDisabled ? Colors.transparent : widget.brand.colors.colorBlack,
            borderRadius: BorderRadius.circular(PPOCheckbox.kCheckboxIconBoxRadiusLarge),
            border: Border.all(
              color: widget.brand.colors.colorBlack,
              width: PPOCheckbox.kCheckboxIconBorderWidthLarge,
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Icon(
              UniconsSolid.check,
              size: PPOCheckbox.kCheckboxIconRadiusLarge,
              color: widget.isDisabled ? Colors.transparent : widget.brand.colors.colorWhite,
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
              color: widget.brand.colors.colorBlack,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSmallCheckbox(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: PPOCheckbox.kCheckboxPaddingSmall,
      decoration: BoxDecoration(
        color: widget.brand.colorGray3.toColorFromHex().withOpacity(PPOCheckbox.kCheckboxAreaOpacitySmall),
        borderRadius: BorderRadius.circular(PPOCheckbox.kCheckboxAreaRadiusSmall),
      ),
      child: Row(
        children: <Widget>[
          AnimatedContainer(
            duration: kAnimationDurationRegular,
            width: PPOCheckbox.kCheckboxIconBoxRadiusSmall,
            height: PPOCheckbox.kCheckboxIconBoxRadiusSmall,
            decoration: BoxDecoration(
              color: widget.isDisabled ? Colors.transparent : widget.brand.colorBlack.toColorFromHex(),
              borderRadius: BorderRadius.circular(PPOCheckbox.kCheckboxIconBoxRadiusSmall),
              border: Border.all(
                color: widget.brand.colorBlack.toColorFromHex(),
                width: PPOCheckbox.kCheckboxIconBorderWidthSmall,
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                UniconsSolid.check,
                size: PPOCheckbox.kCheckboxIconRadiusSmall,
                color: widget.isDisabled ? Colors.transparent : widget.brand.colorWhite.toColorFromHex(),
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
                color: widget.brand.colorBlack.toColorFromHex(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
