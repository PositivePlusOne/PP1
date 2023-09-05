// Flutter imports:
import 'package:app/providers/profiles/tags_controller.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/atoms/input/positive_search_field.dart';
import 'package:app/widgets/molecules/content/positive_activity_widget.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/search/vms/search_view_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../molecules/navigation/positive_tab_bar.dart';
import '../../molecules/tiles/positive_profile_list_tile.dart';
import '../../molecules/tiles/positive_topic_tile.dart';

@RoutePage()
class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final SearchViewModel viewModel = ref.read(searchViewModelProvider.notifier);

    final List<Tag> tags = ref.watch(tagsControllerProvider.select((value) => value.topicTags));
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final String searchQuery = ref.watch(searchViewModelProvider.select((value) => value.searchQuery));
    final SearchTab currentTab = ref.watch(searchViewModelProvider.select((value) => value.currentTab));
    final bool isBusy = ref.watch(searchViewModelProvider.select((value) => value.isBusy));
    final bool isSearching = ref.watch(searchViewModelProvider.select((value) => value.isSearching));

    final List<Profile> searchUserResults = ref.watch(searchViewModelProvider.select((value) => value.searchUsersResults));
    final List<Activity> searchPostsResults = ref.watch(searchViewModelProvider.select((value) => value.searchPostsResults));
    final List<Activity> searchEventsResults = ref.watch(searchViewModelProvider.select((value) => value.searchEventsResults));
    final List<Tag> searchTagResults = ref.watch(searchViewModelProvider.select((value) => value.searchTagResults));

    final bool canDisplaySearchResults = switch (currentTab) {
      SearchTab.users => searchUserResults.isNotEmpty,
      SearchTab.posts => searchPostsResults.isNotEmpty,
      SearchTab.events => searchEventsResults.isNotEmpty,
      SearchTab.tags => true,
    };

    return PositiveScaffold(
      isBusy: isBusy,
      onWillPopScope: viewModel.onWillPopScope,
      bottomNavigationBar: PositiveNavigationBar(
        mediaQuery: mediaQuery,
        index: NavigationBarIndex.search,
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
              initialText: searchQuery,
              onChange: viewModel.onSearchChanged,
              onSubmitted: viewModel.onSearchSubmitted,
              isEnabled: !isBusy,
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(left: kPaddingMedium, right: kPaddingMedium, bottom: kPaddingMedium + mediaQuery.padding.bottom),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                PositiveTabBar(
                  index: currentTab.index,
                  onTapped: (index) => viewModel.onTabTapped(SearchTab.values[index]),
                  margin: EdgeInsets.zero,
                  tabColours: <Color>[
                    colors.green,
                    colors.yellow,
                    colors.teal,
                    colors.purple,
                  ],
                  tabs: const <String>[
                    'Posts',
                    'People',
                    'Events',
                    'Tags',
                  ],
                ),
                const SizedBox(height: kPaddingSmall),
                if (isSearching && !canDisplaySearchResults) ...<Widget>[
                  const PositiveLoadingIndicator(),
                  const SizedBox(height: kPaddingSmall),
                ],
                if (!isSearching && !canDisplaySearchResults) ...<Widget>[
                  Text(
                    localizations.page_search_subtitle_pending,
                    style: typography.styleSubtext.copyWith(color: colors.colorGray7),
                  ),
                ],
                if (canDisplaySearchResults && currentTab == SearchTab.users)
                  ...<Widget>[
                    for (final Profile profile in searchUserResults) ...<Widget>[
                      PositiveProfileListTile(profile: profile, isEnabled: !isBusy),
                    ],
                  ].spaceWithVertical(kPaddingSmall),
                if (canDisplaySearchResults && currentTab == SearchTab.events)
                  ...<Widget>[
                    for (final Activity activity in searchEventsResults) ...<Widget>[
                      PositiveActivityWidget(activity: activity),
                    ],
                  ].spaceWithVertical(kPaddingSmall),
                if (canDisplaySearchResults && currentTab == SearchTab.posts)
                  ...<Widget>[
                    for (final Activity activity in searchPostsResults) ...<Widget>[
                      PositiveActivityWidget(activity: activity),
                    ],
                  ].spaceWithVertical(kPaddingSmall),
                if (canDisplaySearchResults && currentTab == SearchTab.tags && searchTagResults.isEmpty)
                  StaggeredGrid.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: kPaddingSmall,
                    mainAxisSpacing: kPaddingSmall,
                    axisDirection: AxisDirection.down,
                    children: [
                      for (final Tag tag in tags) ...<Widget>[
                        PositiveTopicTile(
                          colors: colors,
                          typography: typography,
                          tag: tag,
                        ),
                      ],
                    ],
                  )
                else if (!canDisplaySearchResults && currentTab == SearchTab.tags && searchTagResults.isNotEmpty)
                  ...<Widget>[
                    for (final Tag tag in searchTagResults.isEmpty ? tags : searchTagResults) ...<Widget>[
                      PositiveTopicTile(
                        colors: colors,
                        typography: typography,
                        tag: tag,
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
