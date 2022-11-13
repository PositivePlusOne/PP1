import 'dart:math';
import '../../../extensions/math_extensions.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// PPO Decorations return a positioned widget which can be positioned within a [PPOScaffold].
/// These allow pages to include optional decorations in the slivers which appear at the bottom of the scroll content.
/// See: https://www.figma.com/file/3cU3IcSF7dM8CstyuzpTRw/Mobile-App?node-id=68%3A12639&t=Sj190GYqL3YU9mco-4
///
/// These are drawn in a square box and positioned within, the height is set to the smallest of:
/// 1) The height of the device / 2
/// 2) 400px applying pixel ratio
///
/// The size of the decoration is always half the size of the box.
class PPODecoration extends StatelessWidget {
  const PPODecoration({
    required this.asset,
    this.alignment = Alignment.center,
    this.color = Colors.black,
    this.scale = 1.0,
    this.offset = const Offset(0, 0),
    this.rotationDegrees = 0.0,
    super.key,
  });

  final String asset;
  final Alignment alignment;
  final Color color;
  final double scale;

  final Offset offset;
  final double rotationDegrees;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Size screenSize = mediaQueryData.size;
    final double assetSize = min(screenSize.height / 2, 400) / 2;

    // As we can't know the size, we need our offset to be -1 to 1.
    // We can do the math here to figure out the actual offset.
    final double odx = (offset.dx.abs() * assetSize) * (offset.dx.isNegative ? -1 : 1);
    final double ody = (offset.dy.abs() * assetSize) * (offset.dy.isNegative ? -1 : 1);
    final double rrad = rotationDegrees.degreeToRadian;

    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: Transform.rotate(
          angle: rrad,
          child: Transform.scale(
            scale: scale,
            origin: Offset(odx, ody),
            child: SvgPicture.asset(
              asset,
              height: assetSize,
              width: assetSize,
              color: color,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
