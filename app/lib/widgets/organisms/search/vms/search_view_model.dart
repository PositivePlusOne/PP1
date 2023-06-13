// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import '../../../../dtos/database/profile/profile.dart';
import '../../../../gen/app_router.dart';
import '../../../../hooks/lifecycle_hook.dart';
import '../../../../services/third_party.dart';
import '../../profile/dialogs/profile_modal_dialog.dart';
import 'package:app/extensions/riverpod_extensions.dart';

part 'search_view_model.freezed.dart';
part 'search_view_model.g.dart';

@freezed
class SearchViewModelState with _$SearchViewModelState {
  const factory SearchViewModelState({
    @Default('') String searchQuery,
    @Default([]) List<String> searchProfileResults,
    @Default(false) bool isBusy,
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

  Future<bool> onWillPopScope() async {
    final AppRouter router = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    logger.i("Pop Search page, push Home page");
    router.removeWhere((route) => true);
    router.push(const HomeRoute());
    return false;
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

    final FirebaseFunctions functions = ref.read(firebaseFunctionsProvider);

    late final String searchIndex;
    switch (state.currentTab) {
      case 1:
        searchIndex = 'users';
        break;
      case 3:
        searchIndex = 'tags';
        break;
      default:
        searchIndex = 'activities';
        break;
    }

    try {
      final HttpsCallableResult response = await functions.httpsCallable('search-search').call(<String, dynamic>{
        'query': searchTerm,
        'index': searchIndex,
      });

      if (response.data == null) {
        logger.w('Search response data is null');
        return;
      }

      final Map<String, Object?> mapData = json.decodeSafe(response.data);
      //? Cache data  for use by other Widgets
      ref.cacheResponseData(mapData);
      parseSearchData(mapData);

      state = state.copyWith(shouldDisplaySearchResults: true);
    } finally {
      state = state.copyWith(isSearching: false);
    }
  }

  void parseSearchData(Map<String, dynamic> data) {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseAuth auth = ref.read(firebaseAuthProvider);

    final String userId = auth.currentUser?.uid ?? '';
    final List<dynamic> profiles = (data.containsKey('users') ? data['users'] : []).map((dynamic profile) => profile as Map<String, dynamic>).toList();
    final List<Profile> newProfiles = [];

    final List<dynamic> activities = (data.containsKey('activities') ? data['activities'] : []).map((dynamic profile) => profile as Map<String, dynamic>).toList();
    final List<Profile> newActivities = [];

    for (final dynamic profile in profiles) {
      try {
        logger.d('requestNextTimelinePage() - parsing profile: $profile');
        final Profile newProfile = Profile.fromJson(profile);
        final String profileId = newProfile.flMeta?.id ?? '';
        if (profileId.isEmpty) {
          logger.e('requestNextTimelinePage() - Failed to cache profile: $profile');
          continue;
        }

        newProfiles.add(newProfile);
      } catch (ex) {
        logger.e('requestNextTimelinePage() - Failed to cache profile: $profile - ex: $ex');
      }
    }

    for (final dynamic activity in activities) {
      try {
        logger.d('requestNextTimelinePage() - parsing profile: $activity');
        final Profile newActivity = Profile.fromJson(activity);
        final String activityId = newActivity.flMeta?.id ?? '';
        if (activityId.isEmpty) {
          logger.e('requestNextTimelinePage() - Failed to cache profile: $activity');
          continue;
        }

        newActivities.add(newActivity);
      } catch (ex) {
        logger.e('requestNextTimelinePage() - Failed to cache profile: $activity - ex: $ex');
      }
    }

    // Get all fl_id's from the profiles
    final List<String> profileIds = newProfiles.map((Profile profile) => profile.flMeta?.id ?? '').toList();

    // Filter out the profiles are empty or the current user
    final List<String> newResults = profileIds.where((String id) => id.isNotEmpty && id != userId).toList();

    state = state.copyWith(searchProfileResults: newResults);
  }

  Future<void> onTabTapped(int newTab) async {
    if (state.currentTab == newTab) {
      return;
    }

    state = state.copyWith(currentTab: newTab);
  }

  Future<void> onUserProfileModalRequested(BuildContext context, String uid) async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
    final UserController userController = ref.read(userControllerProvider.notifier);

    logger.d('User profile modal requested: $uid');
    if (uid.isEmpty) {
      logger.w('User profile modal requested with empty uid');
      return;
    }

    state = state.copyWith(isBusy: true);

    try {
      final Profile profile = await profileController.getProfile(uid);
      final Relationship relationship = await relationshipController.getRelationship([userController.state.user!.uid, uid]);

      await ProfileModalDialog.show(
        context: context,
        profile: profile,
        relationship: relationship,
      );
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }
}
