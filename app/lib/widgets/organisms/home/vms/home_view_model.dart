// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:app/providers/system/system_controller.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/content/universal_links_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/widgets/organisms/login/vms/login_view_model.dart';
import 'package:app/widgets/organisms/search/vms/search_view_model.dart';
import 'package:app/widgets/state/positive_feed_state.dart';
import '../../../../services/third_party.dart';

part 'home_view_model.freezed.dart';
part 'home_view_model.g.dart';

@freezed
class HomeViewModelState with _$HomeViewModelState {
  const factory HomeViewModelState({
    @Default(false) bool isRefreshing,
    @Default(false) bool hasDoneInitialChecks,
    @Default(0) currentTabIndex,
  }) = _HomeViewModelState;

  factory HomeViewModelState.initialState() => const HomeViewModelState();
}

@Riverpod(keepAlive: true)
class HomeViewModel extends _$HomeViewModel with LifecycleMixin {
  @override
  HomeViewModelState build() {
    return HomeViewModelState.initialState();
  }

  @override
  void onFirstRender() {
    final Logger logger = ref.read(loggerProvider);
    logger.d('onFirstRender()');

    final UniversalLinksController universalLinksController = ref.read(universalLinksControllerProvider.notifier);
    universalLinksController.removeInitialLinkFlagInSharedPreferences();

    final SystemController systemController = ref.read(systemControllerProvider.notifier);
    systemController.resetAppBadges();

    checkForRefresh();

    // Add a bit of time before performing the profile checks
    Future.delayed(const Duration(seconds: 5)).then((_) {
      performProfileChecks();
    });
  }

  Future<void> checkForRefresh() async {
    final Logger logger = ref.read(loggerProvider);
    const TargetFeed everyoneTargetFeed = TargetFeed(
      targetSlug: 'tags',
      targetUserId: 'everyone',
    );

    final CacheController cacheController = ref.read(cacheControllerProvider);
    final String everyoneFeedStateKey = PositiveFeedState.buildFeedCacheKey(everyoneTargetFeed);
    final PositiveFeedState? everyoneFeedState = cacheController.get(everyoneFeedStateKey);

    if (everyoneFeedState == null) {
      logger.d('checkForRefresh() - everyoneFeedState is null');
      return;
    }

    bool shouldRefresh = everyoneFeedState.pagingController.value.status == PagingStatus.noItemsFound;
    if (shouldRefresh) {
      logger.d('checkForRefresh() - refreshing everyone feed');
      await everyoneFeedState.onRefresh();
    }

    everyoneFeedState.pagingController.notifyListeners();
  }

  Future<void> performProfileChecks() async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final NotificationsController notificationsController = ref.read(notificationsControllerProvider.notifier);
    final CacheController cacheController = ref.read(cacheControllerProvider);

    final Profile? currentProfile = cacheController.get(profileController.currentProfileId);
    if (currentProfile == null) {
      logger.d('performProfileChecks() - currentProfile is null');
      return;
    }

    if (!profileController.isCurrentlyUserProfile) {
      logger.d('performProfileChecks() - profileController.isCurrentlyUserProfile is false');
      return;
    }

    if (state.hasDoneInitialChecks) {
      logger.d('performProfileChecks() - state.hasDoneInitialChecks is true');
      return;
    }

    try {
      logger.d('performProfileChecks()');
      profileController.updateEmailAddress().ignore();
      profileController.updateFirebaseMessagingToken().then((value) => notificationsController.setupPushNotificationListeners()).ignore();
    } finally {
      state = state.copyWith(hasDoneInitialChecks: true);
    }
  }

  Future<bool> onWillPopScope() async {
    if (state.currentTabIndex != 0) {
      state = state.copyWith(currentTabIndex: 0);
    }

    return false;
  }

  Future<void> onTabSelected(int index) async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('onTabSelected() - index: $index');

    checkForRefresh();

    state = state.copyWith(currentTabIndex: index);
  }

  Future<void> onSignInSelected() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final LoginViewModel loginViewModel = ref.read(loginViewModelProvider.notifier);

    logger.d('onSignInRequested()');
    loginViewModel.resetState();
    await appRouter.push(LoginRoute(senderRoute: HomeRoute));
  }

  Future<void> onTopicSelected(BuildContext context, Tag tag) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d('onTopicSelected() - tag: ${tag.fallback}');
    await appRouter.push(TagFeedRoute(tag: tag));
  }

  Future<void> onSeeMoreTopicsSelected(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d('onSeeMoreTopicsSelected()');
    await appRouter.push(SearchRoute(defaultTab: SearchTab.tags));
  }
}
