// Flutter imports:
import 'package:app/dtos/database/user/user_profile.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/content/topic.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/content/topics_controller.dart';
import 'package:app/widgets/atoms/input/positive_search_field.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/search/vms/search_view_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../molecules/navigation/positive_tab_bar.dart';
import '../../molecules/tiles/positive_profile_tile.dart';
import '../../molecules/tiles/positive_topic_tile.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SearchViewModel viewModel = ref.read(searchViewModelProvider.notifier);
    final SearchViewModelState state = ref.watch(searchViewModelProvider);

    final TopicsController topicsController = ref.watch(topicsControllerProvider.notifier);
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return PositiveScaffold(
      bottomNavigationBar: PositiveNavigationBar(
        mediaQuery: mediaQuery,
        index: 1,
      ),
      headingWidgets: <Widget>[
        SliverPadding(
          padding: EdgeInsets.only(
            top: mediaQuery.padding.top + kPaddingSmall,
            bottom: kPaddingSmall,
            left: kPaddingMedium,
            right: kPaddingMedium,
          ),
          sliver: SliverToBoxAdapter(
            child: PositiveSearchField(
              onSubmitted: viewModel.onSearchSubmitted,
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(left: kPaddingMedium, right: kPaddingMedium, bottom: kPaddingMedium + mediaQuery.padding.bottom),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                PositiveTabBar(
                  index: state.currentTab,
                  onTapped: viewModel.onTabTapped,
                  tabs: const <String>[
                    'Posts',
                    'People',
                    'Events',
                    'Tags',
                  ],
                ),
                const SizedBox(height: kPaddingSmall),
                if (state.isSearching) ...<Widget>[
                  const PositiveLoadingIndicator(),
                  const SizedBox(height: kPaddingSmall),
                ],
                if (state.currentTab == 1)
                  ...<Widget>[
                    for (final UserProfile result in state.searchProfileResults) ...<Widget>[
                      PositiveProfileTile(
                        profile: result,
                        onTap: () => viewModel.onUserProfileTapped(result),
                      ),
                    ],
                  ].spaceWithVertical(kPaddingSmall),
                if (state.currentTab == 3)
                  ...<Widget>[
                    for (final Topic topic in topicsController.state.topics) ...<Widget>[
                      PositiveTopicTile(
                        colors: colors,
                        typography: typography,
                        topic: topic,
                      ),
                    ],
                  ].spaceWithVertical(kPaddingSmall),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
