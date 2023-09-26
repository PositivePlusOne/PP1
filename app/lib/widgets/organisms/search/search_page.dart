// Flutter imports:
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
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/providers/profiles/tags_controller.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/atoms/input/positive_search_field.dart';
import 'package:app/widgets/atoms/typography/positive_title_body_widget.dart';
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
  const SearchPage({
    required this.defaultTab,
    super.key,
  });

  final SearchTab defaultTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final SearchViewModelProvider provider = searchViewModelProvider(defaultTab);
    final SearchViewModel viewModel = ref.read(provider.notifier);

    final List<Tag> tags = ref.watch(tagsControllerProvider.select((value) => value.topicTags));
    final DesignColorsModel colours = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final String searchQuery = ref.watch(provider.select((value) => value.searchQuery));
    final SearchTab currentTab = ref.watch(provider.select((value) => value.currentTab));
    final bool isBusy = ref.watch(provider.select((value) => value.isBusy));
    final bool isSearching = ref.watch(provider.select((value) => value.isSearching));

    final List<Profile> searchUserResults = ref.watch(provider.select((value) => value.searchUsersResults));
    final List<Activity> searchPostsResults = ref.watch(provider.select((value) => value.searchPostsResults));
    final List<Tag> searchTagResults = ref.watch(provider.select((value) => value.searchTagResults));

    final bool canDisplaySearchResults = switch (currentTab) {
      SearchTab.users => searchUserResults.isNotEmpty,
      SearchTab.posts => searchPostsResults.isNotEmpty,
      SearchTab.tags => true,
    };

    final List<Widget> searchResultWidgets = [];

    if (!canDisplaySearchResults) {
      if (isSearching) {
        searchResultWidgets.addAll(
          [
            const PositiveLoadingIndicator(),
            const SizedBox(height: kPaddingSmall),
          ],
        );
      } else {
        if (viewModel.hasSearched) {
          searchResultWidgets.addAll(
            [
              const SizedBox(height: kPaddingExtraLarge),
              PositiaveTitleBodyWidget(
                title: viewModel.searchNotFoundTitle(localisations),
                body: viewModel.searchNotFoundBody(localisations),
              ),
            ],
          );
        } else {
          searchResultWidgets.addAll(
            [
              Text(
                localisations.page_search_subtitle_pending,
                style: typography.styleSubtext.copyWith(color: colours.colorGray7),
              ),
            ],
          );
        }
      }
    }

    if (canDisplaySearchResults) {
      switch (currentTab) {
        case SearchTab.users:
          searchResultWidgets.addAll([
            for (final Profile profile in searchUserResults) ...<Widget>[
              PositiveProfileListTile(profile: profile, isEnabled: !isBusy),
            ],
          ].spaceWithVertical(kPaddingSmall));
          break;

        case SearchTab.posts:
          searchResultWidgets.addAll([
            for (final Activity activity in searchPostsResults) ...<Widget>[
              PositiveActivityWidget(activity: activity),
            ],
          ].spaceWithVertical(kPaddingMedium));
          break;

        case SearchTab.tags:
          searchResultWidgets.addAll(
            [
              StaggeredGrid.count(
                crossAxisCount: 2,
                crossAxisSpacing: kPaddingSmall,
                mainAxisSpacing: kPaddingSmall,
                axisDirection: AxisDirection.down,
                children: <Widget>[
                  for (final Tag tag in searchTagResults.isEmpty ? tags : searchTagResults) ...<Widget>[
                    PositiveTopicTile(
                      colors: colours,
                      typography: typography,
                      tag: tag,
                      onTap: (context) => viewModel.onTopicSelected(context, tag),
                    ),
                  ],
                ],
              )
            ],
          );
          break;

        default:
      }
    }

    return PositiveScaffold(
      isBusy: isBusy,
      onWillPopScope: viewModel.onWillPopScope,
      visibleComponents: {
        PositiveScaffoldComponent.headingWidgets,
        if (!canDisplaySearchResults && viewModel.hasSearched && !isSearching) PositiveScaffoldComponent.decorationWidget,
      },
      decorations: buildType1ScaffoldDecorations(colours),
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
          padding: EdgeInsets.only(
            left: kPaddingMedium,
            right: kPaddingMedium,
            bottom: kPaddingMedium + mediaQuery.padding.bottom,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                PositiveTabBar(
                  index: currentTab.index,
                  onTapped: (index) => viewModel.onTabTapped(SearchTab.values[index]),
                  margin: EdgeInsets.zero,
                  tabColours: <Color>[
                    colours.green,
                    colours.yellow,
                    // colours.teal,
                    colours.purple,
                  ],
                  tabs: <String>[
                    localisations.page_search_tab_posts,
                    localisations.page_search_tab_people,
                    // localisations.page_search_tab_events,
                    localisations.page_search_tab_tags,
                  ],
                ),
                const SizedBox(height: kPaddingSmall),
                ...searchResultWidgets,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
