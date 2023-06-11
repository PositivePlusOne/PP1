// Flutter imports:
import 'package:app/widgets/animations/positive_badge_entry_animation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/iconography/positive_stamp.dart';

class YourConditionYourTermsPlaceholder extends ConsumerWidget {
  const YourConditionYourTermsPlaceholder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Size screenSize = mediaQueryData.size;

    final Size kTextSize = localizations.page_splash_section_your_condition_your_terms_fourth_line.getTextSize(typography.styleHero);
    double badgePaddingLeft = kTextSize.width * 1.35;

    //* Layout sanity check
    if ((screenSize.width - kPaddingMedium) < (badgePaddingLeft + kBadgeSmallSize)) {
      badgePaddingLeft = screenSize.width - kPaddingMedium - kBadgeSmallSize;
    }

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
              Text(localizations.page_splash_section_your_condition_your_terms_first_line, style: typography.styleHero.copyWith(color: colors.black)),
              Text(localizations.page_splash_section_your_condition_your_terms_second_line, style: typography.styleHero.copyWith(color: colors.black)),
              Text(localizations.page_splash_section_your_condition_your_terms_third_line, style: typography.styleHero.copyWith(color: colors.black)),
              Text(localizations.page_splash_section_your_condition_your_terms_fourth_line, style: typography.styleHero.copyWith(color: colors.black)),
            ],
          ),
        ),
        Positioned(
          left: badgePaddingLeft,
          top: 340.0,
          child: PositiveBadgeEntryAnimation(
            child: PositiveStamp.victory(
              colors: colors,
              size: kBadgeSmallSize,
              text: localizations.shared_badges_drama,
              color: colors.black,
              textColor: colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
