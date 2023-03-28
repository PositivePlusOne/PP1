// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/number_extensions.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/resources/resources.dart';
import 'package:app/widgets/atoms/iconography/positive_stamp.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../atoms/buttons/positive_button.dart';
import '../../molecules/containers/positive_glass_sheet.dart';

class PositiveBreatherPageTemplate extends ConsumerWidget {
  const PositiveBreatherPageTemplate({
    required this.title,
    required this.body,
    required this.buttonText,
    required this.onContinueSelected,
    this.isBusy = false,
    super.key,
  });

  final String title;
  final String body;
  final String buttonText;

  final Future<void> Function() onContinueSelected;
  final bool isBusy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    const double decorationHeightMin = 400;
    final double decorationHeightMax = max(mediaQueryData.size.height / 2, decorationHeightMin);
    const double badgeRadius = 166.0;
    const double imageTopOffset = badgeRadius / 4;

    return PositiveScaffold(
      hideBottomPadding: true,
      onWillPopScope: () async => false,
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            Text(
              title,
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              body,
              style: typography.styleBody.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingMedium),
          ],
        ),
        SliverFillRemaining(
          fillOverscroll: false,
          hasScrollBody: false,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            constraints: BoxConstraints(
              maxHeight: decorationHeightMax,
              minHeight: decorationHeightMin,
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: imageTopOffset,
                  left: 0.0,
                  bottom: 0.0,
                  right: 0.0,
                  child: Image.asset(
                    MockImages.bike,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 0.0,
                  left: kPaddingMedium,
                  child: Transform.rotate(
                    angle: 15.0.degreeToRadian,
                    child: PositiveStamp.smile(
                      colors: colors,
                      fillColour: colors.yellow,
                      size: badgeRadius,
                    ),
                  ),
                ),
                Positioned(
                  bottom: mediaQueryData.padding.bottom + kPaddingMedium,
                  left: kPaddingSmall,
                  right: kPaddingSmall,
                  child: PositiveGlassSheet(
                    children: <Widget>[
                      PositiveButton(
                        colors: colors,
                        primaryColor: colors.black,
                        label: buttonText,
                        onTapped: onContinueSelected,
                        isDisabled: isBusy,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
