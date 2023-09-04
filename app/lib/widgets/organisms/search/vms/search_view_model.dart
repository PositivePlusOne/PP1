// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/dtos/database/pagination/pagination.dart';
import 'package:app/services/search_api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/extensions/json_extensions.dart';
import 'package:app/services/api.dart';
import '../../../../dtos/database/activities/activities.dart';
import '../../../../dtos/database/profile/profile.dart';
import '../../../../gen/app_router.dart';
import '../../../../hooks/lifecycle_hook.dart';
import '../../../../services/third_party.dart';

// Flutter imports:

part 'search_view_model.freezed.dart';
part 'search_view_model.g.dart';

@freezed
class SearchViewModelState with _$SearchViewModelState {
  const factory SearchViewModelState({
    @Default(false) bool isBusy,
    @Default(false) bool isSearching,
    @Default('') String searchQuery,
    @Default(SearchTab.posts) SearchTab currentTab,
    @Default([]) List<Profile> searchUsersResults,
    @Default([]) List<Activity> searchPostsResults,
    @Default([]) List<Activity> searchEventsResults,
    @Default([]) List<Tag> searchTagResults,
    @Default('') String searchUsersCursor,
    @Default('') String searchPostsCursor,
    @Default('') String searchEventsCursor,
    @Default('') String searchTagsCursor,
  }) = _SearchViewModelState;

  factory SearchViewModelState.initialState() => const SearchViewModelState();
}

enum SearchTab {
  posts(0, 'activities'),
  users(1, 'users'),
  events(2, 'activities'),
  topics(3, 'topics');

  final int pageIndex;
  final String searchIndex;

  const SearchTab(this.pageIndex, this.searchIndex);
}

@Riverpod(keepAlive: true)
class SearchViewModel extends _$SearchViewModel with LifecycleMixin {
  @override
  SearchViewModelState build() {
    return SearchViewModelState.initialState();
  }

  Future<bool> onWillPopScope() async {
    final AppRouter router = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    logger.i("Pop Search page, push Home page");
    router.removeWhere((route) => true);
    router.push(const HomeRoute());
    return false;
  }

  Future<void> onSearchChanged(String searchTerm) async {
    state = state.copyWith(searchQuery: searchTerm);
  }

  Future<void> onSearchSubmitted(String rawSearchTerm) async {
    final Logger logger = ref.read(loggerProvider);
    final SearchApiService searchApiService = await ref.read(searchApiServiceProvider.future);
    final String searchTerm = rawSearchTerm.trim();
    if (searchTerm.isEmpty) {
      return;
    }

    logger.i('Searching for $searchTerm');
    state = state.copyWith(
      isSearching: true,
      searchQuery: searchTerm,
      // We don't support pagination for now
      searchUsersCursor: '',
      searchPostsCursor: '',
      searchEventsCursor: '',
      searchTagsCursor: '',
    );

    try {
      final SearchResult<Object> response = await searchApiService.search(
        query: searchTerm,
        index: state.currentTab.searchIndex,
        pagination: Pagination(
          cursor: switch (state.currentTab) {
            SearchTab.users => state.searchUsersCursor,
            SearchTab.posts => state.searchPostsCursor,
            SearchTab.events => state.searchEventsCursor,
            SearchTab.topics => state.searchTagsCursor,
          },
        ),
        fromJson: switch (state.currentTab) {
          SearchTab.users => (json) => Profile.fromJson(json),
          SearchTab.posts => (json) => Activity.fromJson(json),
          SearchTab.events => (json) => Activity.fromJson(json),
          SearchTab.topics => (json) => Tag.fromJson(json),
        },
      );

      if (response.results.isEmpty) {
        logger.w('Search response data is null');
        return;
      }

      switch (state.currentTab) {
        case SearchTab.users:
          final List<Profile> results = response.results.cast<Profile>();
          state = state.copyWith(searchUsersCursor: response.cursor, searchUsersResults: state.searchUsersResults + results);
          break;
        case SearchTab.events:
          final List<Activity> results = response.results.cast<Activity>();
          state = state.copyWith(searchEventsCursor: response.cursor, searchEventsResults: state.searchEventsResults + results);
          break;
        case SearchTab.topics:
          final List<Tag> results = response.results.cast<Tag>();
          state = state.copyWith(searchTagsCursor: response.cursor, searchTagResults: state.searchTagResults + results);
          break;
        case SearchTab.posts:
          final List<Activity> results = response.results.cast<Activity>();
          state = state.copyWith(searchPostsCursor: response.cursor, searchPostsResults: state.searchPostsResults + results);
          break;
      }
    } finally {
      state = state.copyWith(isSearching: false);
    }
  }

  Future<void> onTabTapped(SearchTab newTab) async {
    if (state.currentTab == newTab) {
      return;
    }

    state = state.copyWith(currentTab: newTab);
  }
}
