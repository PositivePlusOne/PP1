// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/enrichment/promotions.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';

class PositivePromotedChannelListTile extends ConsumerWidget {
  const PositivePromotedChannelListTile({
    required this.promotion,
    required this.promotedActivity,
    required this.owner,
    this.isEnabled = true,
    this.onTap,
    super.key,
  });

  final bool isEnabled;
  final void Function(BuildContext context)? onTap;

  final Promotion promotion;
  final Activity? promotedActivity;
  final Profile owner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final String promotedDescription = (promotedActivity?.generalConfiguration?.content ?? '');

    return PositiveTapBehaviour(
      isEnabled: isEnabled,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(kPaddingSmall),
        constraints: const BoxConstraints(maxHeight: kIconHuge + 2 * kPaddingSmall),
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: Row(
          children: <Widget>[
            PositiveProfileCircularIndicator(
              profile: owner,
              size: kIconHuge,
            ),
            const SizedBox(width: kPaddingSmall),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FittedBox(
                    child: Text(
                      promotion.title,
                      maxLines: 1,
                      style: typography.styleTitle.copyWith(color: colors.colorGray7),
                    ),
                  ),
                  if (promotedDescription.isNotEmpty) ...<Widget>[
                    Text(
                      promotedDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: typography.styleSubtext.copyWith(color: colors.colorGray4),
                    ),
                  ],
                  Text(
                    promotion.linkText.isEmpty ? localizations.shared_actions_view_more : promotion.linkText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: typography.styleSubtext.copyWith(color: colors.linkBlue),
                  ),
                ],
              ),
            ),
            const SizedBox(width: kPaddingSmall),
            Container(
              height: 26.0,
              padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall, vertical: kPaddingExtraSmall),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kBorderRadiusHuge),
                color: colors.colorGray1,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    UniconsLine.link_alt,
                    color: colors.colorGray7,
                    size: kIconExtraSmall,
                  ),
                  const SizedBox(width: kPaddingExtraSmall),
                  Text(
                    localizations.post_promoted_label,
                    style: typography.styleSubtextBold.copyWith(color: colors.colorGray7),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
