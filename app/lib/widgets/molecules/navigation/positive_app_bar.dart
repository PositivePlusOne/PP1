// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import '../../../../resources/resources.dart';
import '../../../constants/design_constants.dart';
import '../../atoms/buttons/positive_button.dart';

class PositiveAppBar extends StatelessWidget with PreferredSizeWidget {
  const PositiveAppBar({
    super.key,
    this.trailing = const <Widget>[],
    this.foregroundColor = Colors.black,
    this.backgroundColor = Colors.transparent,
    this.applyLeadingandTrailingPadding = false,
    this.safeAreaQueryData,
  });

  final Color foregroundColor;
  final Color backgroundColor;

  final bool applyLeadingandTrailingPadding;
  final MediaQueryData? safeAreaQueryData;

  final List<Widget> trailing;

  @override
  Size get preferredSize => Size(double.infinity, PositiveButton.kButtonIconRadiusRegular + PositiveButton.kButtonPaddingMedium.vertical + (kPaddingSmall * 2) + (safeAreaQueryData?.padding.top ?? 0));

  static const String kPositiveLogoTag = 'pp1-app-bar-hero';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: preferredSize.height,
      width: preferredSize.width,
      child: AnimatedContainer(
        duration: kAnimationDurationRegular,
        color: backgroundColor,
        padding: EdgeInsets.only(
          left: applyLeadingandTrailingPadding ? kPaddingLarge : 0,
          right: applyLeadingandTrailingPadding ? kPaddingLarge : 0,
          top: safeAreaQueryData?.padding.top ?? 0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Hero(
                tag: kPositiveLogoTag,
                child: SvgPicture.asset(
                  SvgImages.logosFooter,
                  width: kLogoMaximumWidth,
                  color: foregroundColor,
                ),
              ),
            ),
            const Spacer(),
            for (final Widget trailingWidget in trailing) ...<Widget>[
              trailingWidget,
              if (trailingWidget != trailing.last) ...<Widget>[
                const SizedBox(width: kPaddingSmall),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
