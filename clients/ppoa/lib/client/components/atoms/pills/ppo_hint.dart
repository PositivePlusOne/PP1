// Flutter imports:
import 'dart:ui';

import 'package:flutter/material.dart';

// Project imports:
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import '../../../constants/ppo_design_constants.dart';

class PPOHint extends StatelessWidget {
  const PPOHint({
    required this.brand,
    required this.label,
    required this.icon,
    required this.iconColor,
    super.key,
  });

  final DesignSystemBrand brand;
  final String label;

  final IconData icon;
  final Color iconColor;

  static const TextStyle kTextStyle = TextStyle(
    fontFamily: kFontAlbertSans,
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
  );

  static const EdgeInsets kEdgeInsets = EdgeInsets.symmetric(
    horizontal: 10.0,
    vertical: 5.0,
  );

  static const double kIconSpacing = 10.0;
  static const double kIconRadius = 22.0;

  static final BorderRadius kBorderRadius = BorderRadius.circular(10.0);
  static const double kOpacity = 0.25;
  static const double kSigmaBlur = 12.5;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: kBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: kSigmaBlur, sigmaY: kSigmaBlur),
        child: Container(
          padding: kEdgeInsets,
          decoration: BoxDecoration(
            color: brand.colors.colorGray3.withOpacity(kOpacity),
            borderRadius: kBorderRadius,
          ),
          child: Row(
            children: <Widget>[
              Icon(icon, size: kIconRadius, color: iconColor),
              const SizedBox(width: kIconSpacing),
              Expanded(
                child: Text(
                  label,
                  style: kTextStyle.copyWith(color: brand.colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
