// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import '../../../../resources/resources.dart';
import '../../../constants/design_constants.dart';
import '../../atoms/buttons/positive_button.dart';

class PositiveAppBar extends StatelessWidget {
  const PositiveAppBar({
    super.key,
    this.trailing,
    this.foregroundColor = Colors.black,
    this.backgroundColor = Colors.transparent,
    this.includePadding = false,
  });

  final Widget? trailing;

  final Color foregroundColor;
  final Color backgroundColor;

  final bool includePadding;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return AnimatedContainer(
      duration: kAnimationDurationRegular,
      padding: includePadding
          ? EdgeInsets.only(
              top: mediaQuery.padding.top + kPaddingMedium,
              left: kPaddingMedium,
              right: kPaddingMedium,
              bottom: kPaddingMedium,
            )
          : EdgeInsets.zero,
      color: backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: SvgPicture.asset(
              SvgImages.logosFooter,
              width: kLogoMaximumWidth,
              color: foregroundColor,
            ),
          ),
          if (trailing != null) ...<Widget>[
            trailing!,
          ],
          if (trailing == null) ...<Widget>[
            SizedBox(
              height: PositiveButton.kButtonIconRadiusRegular + (PositiveButton.kIconPaddingLarge.bottom * 2),
            ),
          ],
        ],
      ),
    );
  }
}
