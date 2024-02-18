// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/animations/positive_badge_entry_animation.dart';
import 'package:app/widgets/atoms/iconography/positive_stamp.dart';

class EmbracePositivityPlaceholder extends ConsumerWidget {
  const EmbracePositivityPlaceholder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final Size kTextSize = localizations.page_splash_section_embrace_positivity_second_line.getTextSize(typography.styleHero);

    final double kBadgePaddingLeft = kTextSize.width * 0.75;
    const double kBadgePaddingTop = 265.0;

    return Stack(
      children: <Widget>[
        Positioned(
          left: kPaddingExtraLarge,
          top: kPaddingSplashTextBreak,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                localizations.page_splash_section_embrace_positivity_first_line,
                style: typography.styleHero.copyWith(color: colors.black),
              ),
              Text(
                localizations.page_splash_section_embrace_positivity_second_line,
                style: typography.styleHero.copyWith(color: colors.black),
              ),
            ],
          ),
        ),
        Positioned(
          left: kBadgePaddingLeft,
          top: kBadgePaddingTop,
          child: PositiveBadgeEntryAnimation(
            child: PositiveStamp.onePlus(
              colors: colors,
              size: kBadgeSmallSize,
              text: '${localizations.shared_badges_positive}\n${localizations.shared_badges_positive}',
              color: colors.purple,
              textColor: colors.purple,
            ),
          ),
        ),
      ],
    );
  }
}
