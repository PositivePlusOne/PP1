// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/content/topic.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/providers/content/topics_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/atoms/input/positive_search_field.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/search/vms/search_view_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../behaviours/positive_profile_fetch_behaviour.dart';
import '../../molecules/navigation/positive_tab_bar.dart';
import '../../molecules/tiles/positive_search_loading_tile.dart';
import '../../molecules/tiles/positive_search_profile_tile.dart';
import '../../molecules/tiles/positive_topic_tile.dart';

@RoutePage()
class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final SearchViewModel viewModel = ref.read(searchViewModelProvider.notifier);
    final SearchViewModelState state = ref.watch(searchViewModelProvider);
    final ProfileController profileController = ref.watch(profileControllerProvider.notifier);

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
              initialText: state.searchQuery,
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
                  margin: EdgeInsets.zero,
                  tabs: const <String>[
                    'Posts',
                    'People',
                    'Events',
                    'Tags',
                  ],
                ),
                const SizedBox(height: kPaddingSmall),
                if (state.isSearching && !state.shouldDisplaySearchResults) ...<Widget>[
                  const PositiveLoadingIndicator(),
                  const SizedBox(height: kPaddingSmall),
                ],
                if (!state.isSearching && !state.shouldDisplaySearchResults) ...<Widget>[
                  Text(
                    localizations.page_search_subtitle_pending,
                    style: typography.styleSubtext.copyWith(color: colors.colorGray7),
                  ),
                ],
                if (state.shouldDisplaySearchResults && state.currentTab == 1)
                  ...<Widget>[
                    for (final String userId in state.searchProfileResults) ...<Widget>[
                      PositiveProfileFetchBehaviour(
                        userId: userId,
                        onErrorLoadingProfile: viewModel.onErrorLoadingSearchResult,
                        errorBuilder: (_) => const PositiveSearchLoadingTile(),
                        placeholderBuilder: (_) => const PositiveSearchLoadingTile(),
                        builder: (context, result) => PositiveSearchProfileTile(
                          profile: result,
                          onTap: () => profileController.viewProfile(result),
                          onOptionsTapped: () => viewModel.onUserProfileModalRequested(context, result),
                        ),
                      ),
                    ],
                  ].spaceWithVertical(kPaddingSmall),
                if (state.shouldDisplaySearchResults && state.currentTab == 3)
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
