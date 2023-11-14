// Dart imports:

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/dtos/database/pagination/pagination.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/providers/profiles/events/profile_switched_event.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/services/search_api_service.dart';
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
    required SearchTab currentTab,
    @Default(false) bool isBusy,
    @Default(false) bool isSearching,
    @Default('') String searchQuery,
    @Default([]) List<Profile> searchUsersResults,
    @Default([]) List<Activity> searchPostsResults,
    @Default([]) List<Tag> searchTagResults,
    @Default('') String searchUsersCursor,
    @Default('') String searchPostsCursor,
    @Default('') String searchTagsCursor,
    @Default(false) bool hasSearchedTags,
    @Default(false) bool hasSearchedPosts,
    @Default(false) bool hasSearchedUsers,
  }) = _SearchViewModelState;

  factory SearchViewModelState.initialState(SearchTab tab) => SearchViewModelState(
        currentTab: tab,
      );
}

enum SearchTab {
  posts(0, 'activities'),
  users(1, 'users'),
  tags(2, 'tags');

  final int pageIndex;
  final String searchIndex;

  const SearchTab(this.pageIndex, this.searchIndex);
}

@Riverpod(keepAlive: true)
class SearchViewModel extends _$SearchViewModel with LifecycleMixin {
  StreamSubscription<ProfileSwitchedEvent>? onProfileChanged;
  final TextEditingController searchTextController = TextEditingController();

  @override
  SearchViewModelState build(SearchTab tab) {
    setupListeners();
    return SearchViewModelState.initialState(tab);
  }

  Future<void> setupListeners() async {
    final EventBus eventBus = ref.read(eventBusProvider);
    await onProfileChanged?.cancel();
    onProfileChanged = eventBus.on<ProfileSwitchedEvent>().listen((event) {
      onProfileSwitched(event);
    });
  }

  void onProfileSwitched(ProfileSwitchedEvent event) {
    state = SearchViewModelState.initialState(tab);
  }

  bool get hasSearched => switch (state.currentTab) {
        SearchTab.users => state.hasSearchedUsers,
        SearchTab.posts => state.hasSearchedPosts,
        SearchTab.tags => state.hasSearchedTags,
      };

  String searchNotFoundTitle(AppLocalizations localisations) => switch (state.currentTab) {
        SearchTab.users => localisations.page_search_people_not_found_title,
        SearchTab.posts => localisations.page_search_posts_not_found_title,
        SearchTab.tags => localisations.page_search_tags_not_found_title,
      };

  String searchNotFoundBody(AppLocalizations localisations) => switch (state.currentTab) {
        SearchTab.users => localisations.page_search_people_not_found_body,
        SearchTab.posts => localisations.page_search_posts_not_found_body,
        SearchTab.tags => localisations.page_search_tags_not_found_body,
      };

  Future<bool> onWillPopScope() async {
    final AppRouter router = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    logger.i("Pop Search page, push Home page");
    router.removeWhere((route) => true);
    router.push(const HomeRoute());
    return false;
  }

  Future<void> onSearchChanged(String searchTerm) async {
    if (searchTerm.isEmpty) {
      state = state.copyWith(
        searchQuery: searchTerm,
        searchUsersResults: [],
        searchUsersCursor: '',
        searchPostsResults: [],
        searchPostsCursor: '',
        searchTagResults: [],
        searchTagsCursor: '',
      );
      return;
    }

    state = state.copyWith(searchQuery: searchTerm);
  }

  void updateHasSearched(bool newValue) {
    switch (state.currentTab) {
      case SearchTab.users:
        state = state.copyWith(
          hasSearchedUsers: newValue,
        );
        break;

      case SearchTab.posts:
        state = state.copyWith(
          hasSearchedPosts: newValue,
        );
        break;

      case SearchTab.tags:
        state = state.copyWith(
          hasSearchedTags: newValue,
        );
        break;
      default:
    }
  }

  Future<void> onSearchSubmitted(String rawSearchTerm) async {
    final Logger logger = ref.read(loggerProvider);
    final SearchApiService searchApiService = await ref.read(searchApiServiceProvider.future);
    final String searchTerm = rawSearchTerm.trim();
    if (searchTerm.isEmpty) {
      return;
    }

    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final CacheController cacheController = ref.read(cacheControllerProvider);

    updateHasSearched(true);

    logger.i('Searching for $searchTerm');
    state = state.copyWith(
      isSearching: true,
      searchQuery: searchTerm,
      // We don't support pagination for now
      searchUsersResults: [],
      searchUsersCursor: '',
      searchPostsResults: [],
      searchPostsCursor: '',
      searchTagResults: [],
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
            SearchTab.tags => state.searchTagsCursor,
          },
        ),
        fromJson: switch (state.currentTab) {
          SearchTab.users => (json) => Profile.fromJson(json),
          SearchTab.posts => (json) => Activity.fromJson(json),
          SearchTab.tags => (json) => Tag.fromJson(json),
        },
      );

      updateHasSearched(true);

      if (response.results.isEmpty) {
        logger.w('Search response data is null');
        return;
      }

      switch (state.currentTab) {
        case SearchTab.users:
          final List<Profile> results = response.results.cast<Profile>();

          // Remove all the profiles which we cannot display on the feed
          final String currentProfileId = profileController.currentProfile?.flMeta?.id ?? '';
          final List<Profile> filteredResults = results.where((profile) {
            final bool isCurrentUser = currentProfileId.isNotEmpty && profile.flMeta?.id == currentProfileId;
            if (isCurrentUser) {
              return false;
            }

            if (currentProfileId.isNotEmpty) {
              final String relationshipId = [currentProfileId, profile.flMeta?.id ?? ''].asGUID;
              final Relationship? relationship = cacheController.get(relationshipId);
              final bool canDisplayOnFeed = profile.canDisplayOnFeed(relationship: relationship);
              return canDisplayOnFeed;
            }

            return true;
          }).toList();

          state = state.copyWith(searchUsersCursor: response.cursor, searchUsersResults: state.searchUsersResults + filteredResults);
          break;
        case SearchTab.tags:
          final List<Tag> results = response.results.cast<Tag>();
          results.removeWhere((element) => TagHelpers.isPromoted(element.key));
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

    if (searchTextController.text.isNotEmpty) {
      onSearchSubmitted(searchTextController.text);
    }
  }

  Future<void> onTopicSelected(BuildContext context, Tag tag) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d('onTopicSelected() - tag: ${tag.fallback}');
    await appRouter.push(TagFeedRoute(tag: tag));
  }
}
