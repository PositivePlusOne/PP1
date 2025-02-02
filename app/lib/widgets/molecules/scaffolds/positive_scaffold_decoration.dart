// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:app/extensions/number_extensions.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold_decoration_model.dart';

/// Scaffold Decorations return a positioned widget which can be positioned within a [PositiveScaffold].
/// These allow pages to include optional decorations in the slivers which appear at the bottom of the scroll content.
/// See: https://www.figma.com/file/3cU3IcSF7dM8CstyuzpTRw/Mobile-App?node-id=68%3A12639&t=Sj190GYqL3YU9mco-4
///
/// These are drawn in a square box and positioned within, the height is set to the smallest of:
/// 1) The height of the device / 2
/// 2) 300px applying pixel ratio
///
/// The size of the decoration is always half the size of the box.
class PositiveScaffoldDecoration extends StatelessWidget {
  const PositiveScaffoldDecoration({
    required this.asset,
    this.alignment = Alignment.center,
    this.color = Colors.black,
    this.scale = 1.0,
    this.offset = const Offset(0, 0),
    this.rotationDegrees = 0.0,
    super.key,
  });

  factory PositiveScaffoldDecoration.fromPageDecoration(PositiveScaffoldDecorationModel decoration) {
    return PositiveScaffoldDecoration(
      asset: decoration.asset,
      alignment: decoration.alignment,
      color: decoration.color,
      offset: Offset(decoration.offsetX, decoration.offsetY),
      rotationDegrees: decoration.rotationDegrees,
      scale: decoration.scale,
    );
  }

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

    final double rrad = rotationDegrees.degreeToRadian;

    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: Transform.rotate(
          angle: rrad,
          child: Transform.translate(
            offset: offset,
            child: Transform.scale(
              scale: scale,
              child: SvgPicture.asset(
                asset,
                height: assetSize,
                width: assetSize,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
