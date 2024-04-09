// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sliver_tools/sliver_tools.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/localization_extensions.dart';
import 'package:app/helpers/brand_helpers.dart';

class SliverNoPostsPlaceholder extends StatelessWidget {
  const SliverNoPostsPlaceholder({
    super.key,
    required this.typography,
    required this.colors,
    this.emptyDataWidget,
  });

  final DesignTypographyModel typography;
  final DesignColorsModel colors;
  final Widget? emptyDataWidget;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Size screenSize = mediaQueryData.size;
    final double decorationBoxSize = min(screenSize.height / 2, 400);

    return SliverStack(
      positionedAlignment: Alignment.bottomCenter,
      children: <Widget>[
        SliverFillRemaining(
          fillOverscroll: false,
          hasScrollBody: false,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: decorationBoxSize,
              width: decorationBoxSize,
              child: Stack(children: buildType2ScaffoldDecorations(colors)),
            ),
          ),
        ),
        SliverPositioned(
          left: 0.0,
          right: 0.0,
          top: kPaddingSmall,
          child: Align(
            alignment: Alignment.topCenter,
            child: emptyDataWidget ??
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 120.0),
                  child: Text(
                    appLocalizations.post_dialog_no_posts_to_display,
                    textAlign: TextAlign.center,
                    style: typography.styleSubtitleBold.copyWith(color: colors.colorGray8, fontWeight: FontWeight.w900),
                  ),
                ),
          ),
        ),
      ],
    );
  }
}
