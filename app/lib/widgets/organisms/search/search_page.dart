// Flutter imports:
import 'package:app/dtos/database/content/topic.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/content/topics_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/widgets/atoms/input/positive_search_field.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/search/vms/search_view_model.dart';

import '../../../providers/system/design_controller.dart';
import '../../molecules/navigation/positive_tab_bar.dart';

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
      children: <Widget>[
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
          padding: const EdgeInsets.only(
            left: kPaddingMedium,
            right: kPaddingMedium,
          ),
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
                  const CupertinoActivityIndicator(),
                ],
                if (state.currentTab == 3) ...<Widget>[
                  for (final Topic topic in topicsController.state.topics) ...<Widget>[
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: colors.yellow,
                      ),
                      padding: const EdgeInsets.all(kPaddingMedium),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '#',
                            style: typography.styleTopic.copyWith(
                              color: colors.black.withOpacity(0.15),
                            ),
                          ),
                          const SizedBox(height: kPaddingSmall),
                          Text(
                            topic.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: typography.styleTopic.copyWith(color: colors.black),
                          ),
                        ],
                      ),
                    ),
                    if (topicsController.state.topics.indexOf(topic) != topicsController.state.topics.length - 1) ...<Widget>[
                      const SizedBox(height: kPaddingSmall),
                    ],
                  ],
                ],
                if (state.currentTab == 1) ...<Widget>[
                  for (final result in state.searchProfileResults) ...<Widget>[
                    ListTile(subtitle: Text(result.toString())),
                  ],
                ],
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(bottom: kPaddingMedium + mediaQuery.padding.bottom),
        ),
      ],
    );
  }
}
