import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/events/content/activities.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/behaviours/positive_feed_pagination_behaviour.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:unicons/unicons.dart';

@RoutePage()
class TagFeedPage extends ConsumerWidget {
  const TagFeedPage({
    super.key,
    required this.tag,
  });

  final Tag tag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final AppRouter appRouter = ref.read(appRouterProvider);

    final TargetFeed feed = TargetFeed.fromTag(tag);

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
            child: TagPagePinnedHeader(mediaQueryData: mediaQueryData, colors: colors, tag: tag, typography: typography),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: kPaddingSmall)),
        PositiveFeedPaginationBehaviour(feed: feed),
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
                tag.topic?.fallback ?? tag.fallback,
                style: typography.styleHeroExtraSmall.copyWith(color: colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
