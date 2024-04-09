// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/widgets/animations/positive_tile_entry_animation.dart';

class NoPostsPlaceholder extends StatelessWidget {
  const NoPostsPlaceholder({
    super.key,
    required this.typography,
    required this.colors,
  });

  final DesignTypographyModel typography;
  final DesignColorsModel colors;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Size screenSize = mediaQueryData.size;
    final double decorationBoxSize = min(screenSize.height / 2, 400);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Positioned(
          left: 0.0,
          right: 0.0,
          top: kPaddingSmall,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 120.0),
              child: Text(
                'No Posts to Display',
                textAlign: TextAlign.center,
                style: typography.styleSubtitleBold.copyWith(color: colors.colorGray8, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: PositiveTileEntryAnimation(
            direction: AxisDirection.down,
            child: SizedBox(
              height: decorationBoxSize,
              width: decorationBoxSize,
              child: Stack(children: buildType2ScaffoldDecorations(colors)),
            ),
          ),
        ),
      ],
    );
  }
}
