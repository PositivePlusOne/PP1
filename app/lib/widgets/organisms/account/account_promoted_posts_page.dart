// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/localization_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/user/account_form_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/positive_back_button.dart';
import 'package:app/widgets/behaviours/positive_feed_pagination_behaviour.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/navigation/positive_tab_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/state/positive_feed_state.dart';
import '../../../helpers/brand_helpers.dart';
import '../../../providers/system/design_controller.dart';

/// this is a page to show the organisation's promoted posts - by accessing the feed that is tagged with
/// 'promotion:{userId}' which is a specially constructed tag for orgs to track all their specially constructed posts
@RoutePage()
class AccountPromotedPostsPage extends HookConsumerWidget {
  const AccountPromotedPostsPage({super.key});

  /// return the widget to show in the currently active tab
  Widget _activeTab(
    int selectedTab,
    ProfileController profileController,
    DesignTypographyModel typography,
    TargetFeed feed,
    PositiveFeedState feedState,
  ) {
    switch (selectedTab) {
      case 0:
        return PositiveFeedPaginationBehaviour(
          feed: feed,
          currentProfile: profileController.currentProfile,
          feedState: feedState,
          emptyDataWidget: _emptyDataWidget(typography, selectedTab),
        );
      case 1:
        //TODO the feed for promoted 'chats'
        return SliverToBoxAdapter(child: _emptyDataWidget(typography, selectedTab));
      default:
        // should never get here, not a recognised tab index
        return const SliverToBoxAdapter(child: Center(child: Text('ERROR')));
    }
  }

  /// when there are no hub posts - we want to show a special big text entry explaining why
  Widget _emptyDataWidget(DesignTypographyModel typography, int selectedTab) => Padding(
        padding: const EdgeInsets.only(left: kPaddingLarge, right: kPaddingLarge),
        child: PositiveGlassSheet(children: [
          const SizedBox(height: kPaddingLarge),
          Text(
            appLocalizations.page_profile_personal_data_no_posts_title,
            style: typography.styleHero,
          ),
          const SizedBox(height: kPaddingLarge),
          Text(
            selectedTab == 0 ? appLocalizations.page_profile_personal_data_no_hub_posts : appLocalizations.page_profile_personal_data_no_chat_posts,
            style: typography.styleSubtitle,
          ),
        ]),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final log = ref.read(loggerProvider);

    final Locale locale = Localizations.localeOf(context);
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final AccountFormControllerProvider provider = accountFormControllerProvider(locale);
    final AccountFormState state = ref.watch(provider);

    final CacheController cacheController = ref.read(cacheControllerProvider);

    // tracking the selected tab with hook for when it changes
    final selectedTab = useState(0);
    final itemHubCount = useState('?');
    final itemChatCount = useState('?');

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

    // get our feed for all promoted activities from this user
    final feed = TargetFeed.fromPromoted(userId: currentProfileId);

    // and the state for that
    final String expectedFeedStateKey = PositiveFeedState.buildFeedCacheKey(feed);
    final PositiveFeedState feedState = cacheController.get(expectedFeedStateKey) ?? PositiveFeedState.buildNewState(feed: feed, currentProfileId: currentProfileId!);

    // we have the feed state now (from the cache) are there items already inside?
    itemHubCount.value = feedState.pagingController.itemList?.length.toString() ?? itemHubCount.value;

    // and listen for any changes to the page so we can update when the page does
    // and set this value to update the view
    feedState.pagingController.addListener(() {
      log.i('page updated ${feedState.pagingController.itemList?.length ?? 0}');
      itemHubCount.value = feedState.pagingController.itemList?.length.toString() ?? itemHubCount.value;
    });

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
              tabs: [
                PositiveTabEntry(colour: colors.green, title: localisations.page_profile_promoted_posts_tab_hub(itemHubCount.value)),
                PositiveTabEntry(colour: colors.green, title: localisations.page_profile_promoted_posts_tab_chat(itemChatCount.value)),
              ],
              onTapped: (index) => selectedTab.value = index,
              index: selectedTab.value,
            ),
            const SizedBox(height: kPaddingMedium),
          ],
        ),
        _activeTab(selectedTab.value, profileController, typography, feed, feedState),
      ],
    );
  }
}
