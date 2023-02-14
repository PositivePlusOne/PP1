// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/iconography/positive_stamp.dart';

class TomorrowStartsNowPlaceholder extends ConsumerWidget {
  const TomorrowStartsNowPlaceholder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    final Size screenSize = mediaQueryData.size;

    final Size kTextSize = localizations.page_splash_section_tomorrow_starts_now_third_line.getTextSize(typography.styleHero);
    double badgePaddingLeft = kTextSize.width * 0.65;

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
              Text(localizations.page_splash_section_tomorrow_starts_now_first_line, style: typography.styleHero.copyWith(color: colors.black)),
              Text(localizations.page_splash_section_tomorrow_starts_now_second_line, style: typography.styleHero.copyWith(color: colors.black)),
              Text(localizations.page_splash_section_tomorrow_starts_now_third_line, style: typography.styleHero.copyWith(color: colors.black)),
            ],
          ),
        ),
        Positioned(
          left: badgePaddingLeft,
          top: 310.0,
          child: PositiveStamp.onePlus(
            colors: colors,
            size: kBadgeSmallSize,
            text: '${localizations.shared_badges_positive}\n${localizations.shared_badges_positive}',
            color: colors.yellow,
            textColor: colors.yellow,
            animate: true,
          ),
        ),
      ],
    );
  }
}
