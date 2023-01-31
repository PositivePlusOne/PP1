import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ppoa/business/extensions/brand_extensions.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/client/components/atoms/buttons/enumerations/ppo_button_layout.dart';
import 'package:ppoa/client/components/atoms/buttons/enumerations/ppo_button_style.dart';
import 'package:ppoa/client/components/atoms/buttons/ppo_button.dart';
import 'package:ppoa/client/constants/ppo_design_constants.dart';
import 'package:ppoa/client/extensions/math_extensions.dart';

import '../../../resources/resources.dart';

class HomeAccountActivationPanel extends StatelessWidget {
  const HomeAccountActivationPanel({
    required this.branding,
    super.key,
  });

  final DesignSystemBrand branding;

  final double kPanelRadius = 20.0;
  final double kPanelHeight = 100.0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(kPanelRadius),
      child: Container(
        height: kPanelHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: branding.colors.white,
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              right: 0,
              top: -20.0,
              child: Transform.rotate(
                angle: -15.0.degreeToRadian,
                child: SvgPicture.asset(
                  SvgImages.decorationArrowRight,
                  color: branding.colors.yellow,
                  width: 75.0,
                ),
              ),
            ),
            Positioned(
              right: 35.0,
              top: -20.0,
              child: Transform.rotate(
                angle: 25.0.degreeToRadian,
                child: SvgPicture.asset(
                  SvgImages.decorationEye,
                  color: branding.colors.green,
                  width: 110.0,
                ),
              ),
            ),
            Positioned(
              right: -20.0,
              bottom: -40.0,
              child: Transform.rotate(
                angle: -15.0.degreeToRadian,
                child: SvgPicture.asset(
                  SvgImages.decorationStar,
                  color: branding.colors.purple,
                  width: 100.0,
                ),
              ),
            ),
            Positioned(
              right: 45.0,
              bottom: -20.0,
              child: Transform.rotate(
                angle: -15.0.degreeToRadian,
                child: SvgPicture.asset(
                  SvgImages.decorationRings,
                  color: branding.colors.teal,
                  width: 110.0,
                ),
              ),
            ),
            Positioned(
              top: kPaddingMedium,
              bottom: kPaddingMedium,
              left: kPaddingMedium,
              right: kPaddingMedium,
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Activate Your Account',
                            maxLines: 1,
                            style: branding.typography.styleTitle.copyWith(color: branding.colors.black),
                          ),
                        ),
                        Text(
                          'Engage and connect with the community',
                          maxLines: 2,
                          style: branding.typography.styleBody.copyWith(color: branding.colors.black),
                        ),
                      ],
                    ),
                  ),
                  kPaddingMedium.asHorizontalWidget,
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: PPOButton(
                      brand: branding,
                      onTapped: () async {},
                      label: 'Sign In',
                      layout: PPOButtonLayout.textOnly,
                      style: PPOButtonStyle.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
