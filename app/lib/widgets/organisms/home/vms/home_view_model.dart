// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/content/universal_links_controller.dart';
import 'package:app/providers/location/location_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/widgets/organisms/login/vms/login_view_model.dart';
import 'package:app/widgets/organisms/search/vms/search_view_model.dart';
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

abstract class IHomeViewModel {
  HomeViewModelState build();
  Future<void> onFirstRender();
  Future<bool> onWillPopScope();
  Future<void> onTabSelected(int index);
  Future<void> onSignInSelected();
  Future<void> onTopicSelected(BuildContext context, Tag tag);
  Future<void> onSeeMoreTopicsSelected(BuildContext context);
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

    try {
      // Attempt to request location permission
      final LocationController locationController = ref.read(locationControllerProvider.notifier);
      locationController.requestLocationPermission();
    } catch (e) {
      logger.e('onFirstRender() - error requesting location permission: $e');
    }

    performProfileChecks();
    cleanupRouter();
  }

  // If we land on the home page, we want to clear the router stack
  // And verify the only route is the home route
  Future<void> cleanupRouter() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d('cleanupRouter()');
    appRouter.stack.removeWhere((element) => element.routeData.name != HomeRoute.name);
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
