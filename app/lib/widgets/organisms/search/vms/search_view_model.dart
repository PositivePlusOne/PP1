// Flutter imports:
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:algolia/algolia.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/common/fl_meta.dart';
import '../../../../dtos/database/profile/profile.dart';
import '../../../../hooks/lifecycle_hook.dart';
import '../../../../services/third_party.dart';
import '../../profile/dialogs/profile_modal_dialog.dart';

part 'search_view_model.freezed.dart';
part 'search_view_model.g.dart';

@freezed
class SearchViewModelState with _$SearchViewModelState {
  const factory SearchViewModelState({
    @Default('') String searchQuery,
    @Default([]) List<String> searchProfileResults,
    @Default(false) bool isSearching,
    @Default(false) bool shouldDisplaySearchResults,
    @Default(0) int currentTab,
  }) = _SearchViewModelState;

  factory SearchViewModelState.initialState() => const SearchViewModelState();
}

enum SearchTab {
  posts,
  people,
  events,
  tags,
}

@Riverpod(keepAlive: true)
class SearchViewModel extends _$SearchViewModel with LifecycleMixin {
  @override
  SearchViewModelState build() {
    return SearchViewModelState.initialState();
  }

  Future<void> onErrorLoadingSearchResult(String objectId, Object? exception) async {
    final Logger log = ref.read(loggerProvider);
    log.i('Error loading search result for user $objectId');
    if (exception != null) {
      log.e(exception);
    }

    // Remove the user from the search results
    final List<String> newResults = state.searchProfileResults.where((String id) => id != objectId).toList();
    state = state.copyWith(searchProfileResults: newResults);
  }

  Future<void> onSearchSubmitted(String rawSearchTerm) async {
    final Logger logger = ref.read(loggerProvider);
    final String searchTerm = rawSearchTerm.trim();
    if (searchTerm.isEmpty) {
      return;
    }

    logger.i('Searching for $searchTerm');
    state = state.copyWith(
      isSearching: true,
      shouldDisplaySearchResults: false,
      searchQuery: searchTerm,
      searchProfileResults: [],
    );

    final Algolia algolia = await ref.read(algoliaProvider.future);

    try {
      final AlgoliaQuery query = algolia.instance.index('users').query(searchTerm);
      final AlgoliaQuerySnapshot snapshot = await query.getObjects();
      logger.d('Search results: ${snapshot.hits}');

      for (final AlgoliaObjectSnapshot hit in snapshot.hits) {
        if (hit.data.containsKey('_fl_meta_')) {
          final FlMeta meta = FlMeta.fromJson(hit.data['_fl_meta_'] as Map<String, dynamic>);
          if (meta.id?.isEmpty ?? true) {
            logger.w('Search result has no ID: $meta');
            continue;
          }

          switch (meta.schema ?? '') {
            case 'users':
              state = state.copyWith(searchProfileResults: [...state.searchProfileResults, meta.id!]);
              break;
            default:
              break;
          }
        }
      }

      state = state.copyWith(shouldDisplaySearchResults: true);
    } finally {
      state = state.copyWith(isSearching: false);
    }
  }

  Future<void> onTabTapped(int newTab) async {
    if (state.currentTab == newTab) {
      return;
    }

    state = state.copyWith(currentTab: newTab);
  }

  Future<void> onUserProfileModalRequested(BuildContext context, Profile profile) async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('User profile modal requested: $profile');

    await PositiveDialog.show(context: context, dialog: ProfileModalDialog(profile: profile));
  }
}
