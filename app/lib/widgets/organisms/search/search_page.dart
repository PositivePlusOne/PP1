// Flutter imports:
import 'dart:convert';

import 'package:app/widgets/organisms/search/vms/search_view_model.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/widgets/atoms/input/positive_search_field.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SearchViewModel viewModel = ref.read(searchViewModelProvider.notifier);
    final SearchViewModelState state = ref.watch(searchViewModelProvider);

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
                for (final result in state.searchProfileResults) ...<Widget>[
                  ListTile(subtitle: Text(result.toString())),
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
