// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:app/extensions/string_extensions.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:app/services/api.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import '../../../../dtos/database/activities/activities.dart';
import '../../../../dtos/database/profile/profile.dart';
import '../../../../gen/app_router.dart';
import '../../../../hooks/lifecycle_hook.dart';
import '../../../../services/third_party.dart';
import '../../profile/dialogs/profile_modal_dialog.dart';

part 'search_view_model.freezed.dart';
part 'search_view_model.g.dart';

@freezed
class SearchViewModelState with _$SearchViewModelState {
  const factory SearchViewModelState({
    @Default('') String searchQuery,
    @Default([]) List<Profile> searchUsersResults,
    @Default([]) List<Activity> searchPostsResults,
    @Default([]) List<Activity> searchEventsResults,
    @Default(false) bool isBusy,
    @Default(false) bool isSearching,
    @Default(false) bool shouldDisplaySearchResults,
    @Default(SearchTab.posts) SearchTab currentTab,
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
      shouldDisplaySearchResults: false,
      searchQuery: searchTerm,
      searchUsersResults: [],
    );

    try {
      final List<Map<String, Object?>> response = await searchApiService.search(
        query: searchTerm,
        index: state.currentTab.searchIndex,
      );

      if (response.isEmpty) {
        logger.w('Search response data is null');
        return;
      }

      switch (state.currentTab) {
        case SearchTab.users:
          parseUserSearchData(response);
          break;
        case SearchTab.events:
          parseActivitySearchData(response);
          break;
        case SearchTab.topics:
          break;
        default:
          parseActivitySearchData(response);
          break;
      }

      state = state.copyWith(shouldDisplaySearchResults: true);
    } finally {
      state = state.copyWith(isSearching: false);
    }
  }

  void parseUserSearchData(List<Map<String, dynamic>> response) {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseAuth auth = ref.read(firebaseAuthProvider);

    final String userId = auth.currentUser?.uid ?? '';
    final List<Profile> profiles = response.map((Map<String, dynamic> profile) => Profile.fromJson(profile)).toList();
    final List<Profile> newProfiles = [];

    for (int i = 0; i < profiles.length; i++) {
      final Profile profile = profiles[i];

      try {
        logger.d('requestNextTimelinePage() - parsing profile: $profile');
        final String profileId = profile.flMeta?.id ?? '';
        if (profileId.isEmpty || profileId == userId) {
          continue;
        }

        newProfiles.add(profile);
      } catch (ex) {
        logger.e('requestNextTimelinePage() - Failed to cache profile: $profile - ex: $ex');
      }
    }

    state = state.copyWith(searchUsersResults: newProfiles);
  }

  void parseActivitySearchData(List<Map<String, dynamic>> response) {
    final Logger logger = ref.read(loggerProvider);

    final List<dynamic> activities = response.map((dynamic activity) => json.decodeSafe(activity)).toList();
    final List<Activity> newActivities = [];

    for (final dynamic activity in activities) {
      try {
        logger.d('requestNextTimelinePage() - parsing activity: $activity');
        final Activity newActivity = Activity.fromJson(activity);
        final String activityId = newActivity.flMeta?.id ?? '';
        if (activityId.isEmpty) {
          logger.e('requestNextTimelinePage() - Failed to cache activity: $activity');
          continue;
        }

        newActivity.generalConfiguration!.type.when(
          post: () {
            if (state.currentTab == SearchTab.posts) {
              newActivities.add(newActivity);
            }
          },
          event: () {
            if (state.currentTab == SearchTab.events) {
              newActivities.add(newActivity);
            }
          },
          clip: () {
            if (state.currentTab == SearchTab.posts) {
              newActivities.add(newActivity);
            }
          },
          repost: () {
            if (state.currentTab == SearchTab.posts) {
              newActivities.add(newActivity);
            }
          },
        );
      } catch (ex) {
        logger.e('requestNextTimelinePage() - Failed to cache activity: $activity - ex: $ex');
      }
    }

    switch (state.currentTab) {
      case SearchTab.posts:
        state = state.copyWith(searchPostsResults: newActivities);
        break;
      default:
        state = state.copyWith(searchEventsResults: newActivities);
    }
  }

  Future<void> onTabTapped(SearchTab newTab) async {
    if (state.currentTab == newTab) {
      return;
    }

    state = state.copyWith(currentTab: newTab);
  }

  Future<void> onUserProfileModalRequested(BuildContext context, String uid) async {
    final Logger logger = ref.read(loggerProvider);
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
    final FirebaseAuth auth = ref.read(firebaseAuthProvider);

    logger.d('User profile modal requested: $uid');
    if (uid.isEmpty || auth.currentUser == null) {
      logger.w('User profile modal requested with empty uid');
      return;
    }

    state = state.copyWith(isBusy: true);

    try {
      final Profile? profile = cacheController.getFromCache(uid);
      if (profile == null) {
        logger.w('User profile modal requested with empty profile');
        return;
      }

      final List<String> members = <String>[
        auth.currentUser?.uid ?? '',
        profile.flMeta?.id ?? '',
      ];

      final Relationship relationship = cacheController.getFromCache(members.asGUID) ?? Relationship.empty(members);

      await PositiveDialog.show(
        context: context,
        useSafeArea: false,
        child: ProfileModalDialog(profile: profile, relationship: relationship),
      );
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }
}
