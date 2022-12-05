// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import '../../../../resources/resources.dart';
import '../../../constants/ppo_design_constants.dart';
import '../../../constants/ppo_design_keys.dart';
import '../../atoms/buttons/ppo_button.dart';

class PPOAppBar extends StatelessWidget {
  const PPOAppBar({
    super.key,
    this.trailing,
    this.foregroundColor = Colors.black,
  });

  final Widget? trailing;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Hero(
          tag: kTagAppBarLogo,
          child: Align(
            alignment: Alignment.centerLeft,
            child: SvgPicture.asset(
              SvgImages.logosFooter,
              width: kLogoMaximumWidth,
              color: foregroundColor,
            ),
          ),
        ),
        if (trailing != null) ...<Widget>[
          trailing!,
        ],
        if (trailing == null) ...<Widget>[
          SizedBox(
            height: PPOButton.kButtonIconRadiusRegular + (PPOButton.kButtonPaddingIconOnly.bottom * 2),
          ),
        ],
      ],
    );
  }
}
