// Flutter imports:
import 'package:app/services/third_party.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_back_button.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/typography/positive_bulleted_text.dart';
import 'package:app/widgets/molecules/containers/positive_transparent_sheet.dart';
import 'package:app/widgets/molecules/input/positive_rich_text.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/navigation/positive_tab_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';
import 'package:app/providers/user/account_form_controller.dart';
import '../../../helpers/brand_helpers.dart';

/// this is a page to show the organisation's promoted posts - by accessing the feed that is tagged with
/// 'promotion:{userId}' which is a specially constructed tag for orgs to track all their specially constructed posts
@RoutePage()
class AccountPromotedPostsPage extends HookConsumerWidget {
  const AccountPromotedPostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final log = ref.read(loggerProvider);

    final Locale locale = Localizations.localeOf(context);
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final AccountFormControllerProvider provider = accountFormControllerProvider(locale);
    final AccountFormState state = ref.watch(provider);

    // tracking the selected tab with hook for when it changes
    final selectedTab = useState(0);

    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final currentProfileId = profileController.currentProfileId;
    int remainingPromotions = 0;
    if (null != currentProfileId) {
      final String expectedStatisticsKey = profileController.buildExpectedStatisticsCacheKey(profileId: currentProfileId);
      final CacheController cacheController = ref.read(cacheControllerProvider);
      final ProfileStatistics? profileStatistics = cacheController.get<ProfileStatistics>(expectedStatisticsKey);
      // now we finally have the stats, we can see how many promotions we have remaining
      remainingPromotions = profileStatistics?.promotionsPermitted ?? 0;
    }

    return PositiveScaffold(
      decorations: buildType5ScaffoldDecorations(colors),
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            PositiveBackButton(isDisabled: state.isBusy),
            PositiveGlassSheet(
              children: [
                Row(
                  children: [
                    // expanding the text to right-align the number to the end of the row
                    Expanded(
                      child: Text(
                        localisations.page_profile_promoted_posts_posts_remaining,
                        style: typography.styleSubtitleBold,
                      ),
                    ),
                    Text(remainingPromotions.toString(), style: typography.styleSubtitleBold),
                  ],
                ),
              ],
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveTabBar(
              tabs: [localisations.page_profile_promoted_posts_tab_hub(3), localisations.page_profile_promoted_posts_tab_chat(2)],
              onTapped: (index) => selectedTab.value = index,
              tabColours: [colors.green, colors.green],
              index: selectedTab.value,
            ),
          ],
        ),
      ],
    );
  }
}
