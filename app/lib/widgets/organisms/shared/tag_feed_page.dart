// Flutter imports:
import 'package:app/extensions/localization_extensions.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/cache_hook.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/behaviours/positive_feed_pagination_behaviour.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/state/positive_feed_state.dart';

/// this is a page to show the feed of activities for all promoted activities, commonly created
/// with a user ID to show the activities that user in particular has promoted, but can be called
/// with a null [userId] to show all the promoted activities
@RoutePage()
class PromotedFeedPage extends _TargetFeedPage {
  /// constructor to just use the base class and create the feed required
  PromotedFeedPage({String? userId, Key? key})
      : super(
            key: key,
            feed: TargetFeed.fromPromoted(userId: userId),
            // the title is fixed from the localizations
            displayTitle: appLocalizations.shared_promotions_title);
}

/// this is a page to show the feed of activities for a particular tag specified
@RoutePage()
class TagFeedPage extends _TargetFeedPage {
  /// constructor to just use the base class and create the feed required
  TagFeedPage({
    Key? key,
    required Tag tag,
  }) : super(
          key: key,
          feed: TargetFeed.fromTag(tag.key),
          displayTitle: tag.topic?.fallback ?? tag.fallback,
        );
}

/// a common base class to show a target feed of data from a tag created in the derived classes [PromotedFeedPage] or [TagFeedPage]
class _TargetFeedPage extends HookConsumerWidget {
  final TargetFeed feed;
  final String displayTitle;
  const _TargetFeedPage({
    super.key,
    required this.feed,
    required this.displayTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final CacheController cacheController = ref.read(cacheControllerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    final Profile? currentProfile = ref.watch(profileControllerProvider.select((value) => value.currentProfile));

    final String feedStateKey = PositiveFeedState.buildFeedCacheKey(feed);
    final PositiveFeedState feedState = cacheController.get(feedStateKey) ?? PositiveFeedState.buildNewState(feed: feed, currentProfileId: currentProfile?.flMeta?.id ?? '');

    useCacheHook(keys: [feedStateKey]);

    return PositiveScaffold(
      visibleComponents: const {
        PositiveScaffoldComponent.headingWidgets,
        PositiveScaffoldComponent.decorationWidget,
        PositiveScaffoldComponent.footerPadding,
      },
      bottomNavigationBar: PositiveNavigationBar(
        mediaQuery: mediaQueryData,
        index: NavigationBarIndex.search,
      ),
      headingWidgets: <Widget>[
        SliverPinnedHeader(
          child: PositiveTapBehaviour(
            onTap: (_) => appRouter.removeLast(),
            child: TagPagePinnedHeader(mediaQueryData: mediaQueryData, colors: colors, displayTitle: displayTitle, typography: typography),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: kPaddingSmall)),
        PositiveFeedPaginationBehaviour(
          feed: feed,
          currentProfile: currentProfile,
          feedState: feedState,
        ),
      ],
    );
  }
}

class TagPagePinnedHeader extends StatelessWidget {
  const TagPagePinnedHeader({
    super.key,
    required this.mediaQueryData,
    required this.colors,
    required this.displayTitle,
    required this.typography,
  });

  final MediaQueryData mediaQueryData;
  final DesignColorsModel colors;
  final String displayTitle;
  final DesignTypographyModel typography;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: mediaQueryData.padding.top + kPaddingSmall, bottom: kPaddingSmall, left: kPaddingMedium, right: kPaddingMedium),
      padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall, vertical: kPaddingExtraSmall),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(kBorderRadiusLarge),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            UniconsLine.angle_left,
            size: 24.0,
            color: colors.black,
          ),
          const SizedBox(width: kPaddingSmall),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                displayTitle,
                style: typography.styleHeroExtraSmall.copyWith(color: colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
