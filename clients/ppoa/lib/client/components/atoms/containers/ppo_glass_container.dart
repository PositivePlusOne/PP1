// Flutter imports:
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ppoa/business/extensions/brand_extensions.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';

class PPOGlassContainer extends StatelessWidget {
  const PPOGlassContainer({
    required this.brand,
    required this.children,
    this.canDismiss = false,
    this.onDismissRequested,
    super.key,
  });

  final DesignSystemBrand brand;
  final bool canDismiss;
  final Future<void> Function()? onDismissRequested;

  final List<Widget> children;

  static const double kGlassContainerPadding = 15.0;
  static const double kGlassContainerBorderRadia = 40.0;
  static const double kGlassContainerOpacity = 0.25;
  static const double kGlassContainerSigmaBlur = 10.0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(kGlassContainerBorderRadia),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: kGlassContainerSigmaBlur, sigmaY: kGlassContainerSigmaBlur),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(kGlassContainerPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kGlassContainerBorderRadia),
            color: brand.colorGray2.toColorFromHex().withOpacity(kGlassContainerOpacity),
          ),
          child: Column(
            children: <Widget>[
              // TODO(ryan): Dismiss button
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
