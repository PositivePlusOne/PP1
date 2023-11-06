// Flutter imports:
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
import 'package:app/extensions/tag_extensions.dart';
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

@RoutePage()
class TagFeedPage extends StatefulHookConsumerWidget {
  const TagFeedPage({
    super.key,
    required this.tag,
  });

  final Tag tag;

  @override
  ConsumerState<TagFeedPage> createState() => _TagFeedPageState();
}

class _TagFeedPageState extends ConsumerState<TagFeedPage> {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final CacheController cacheController = ref.read(cacheControllerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    final TargetFeed feed = TargetFeed.fromTag(widget.tag.key);

    final Profile? currentProfile = ref.watch(profileControllerProvider.select((value) => value.currentProfile));

    final String feedStateKey = PositiveFeedState.buildFeedCacheKey(feed);
    final PositiveFeedState feedState = cacheController.get(feedStateKey) ?? PositiveFeedState.buildNewState(feed: feed, currentProfileId: currentProfile?.flMeta?.id ?? '');

    useCacheHook(keys: [feedStateKey]);

    onWillPopScope() async {
      // If the route is the only one, we want to replace to home
      if (appRouter.stack.length == 1) {
        appRouter.replace(const HomeRoute());
        return false;
      }

      appRouter.removeLast();
      return false;
    }

    return PositiveScaffold(
      onWillPopScope: onWillPopScope,
      onRefresh: () => feedState.requestRefresh(feedStateKey),
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
            onTap: (_) => onWillPopScope(),
            child: TagPagePinnedHeader(mediaQueryData: mediaQueryData, colors: colors, tag: widget.tag, typography: typography),
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
    required this.tag,
    required this.typography,
  });

  final MediaQueryData mediaQueryData;
  final DesignColorsModel colors;
  final Tag tag;
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
                tag.toLocale,
                style: typography.styleHeroExtraSmall.copyWith(color: colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
