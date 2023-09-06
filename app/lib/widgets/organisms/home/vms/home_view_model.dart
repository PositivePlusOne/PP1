// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/src/widgets/framework.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/widgets/organisms/login/vms/login_view_model.dart';
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

    // Add a bit of time before performing the profile checks
    Future.delayed(const Duration(seconds: 5)).then((_) {
      performProfileChecks();
    });
  }

  Future<void> performProfileChecks() async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final NotificationsController notificationsController = ref.read(notificationsControllerProvider.notifier);

    if (state.hasDoneInitialChecks) {
      logger.d('performProfileChecks() - state.hasDoneInitialChecks is true');
      return;
    }

    if (profileController.currentProfileId == null) {
      logger.d('onRefresh() - profileController.currentProfileId is null');
      return;
    }

    logger.d('performProfileChecks()');
    try {
      await profileController.updatePhoneNumber();
      await profileController.updateEmailAddress();
      await profileController.updateFirebaseMessagingToken();
      await notificationsController.setupPushNotificationListeners();
    } finally {
      state = state.copyWith(hasDoneInitialChecks: true);
    }
  }

  Future<void> onRefresh() async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);

    if (profileController.currentProfileId == null) {
      logger.d('onRefresh() - profileController.currentProfileId is null');
      return;
    }

    try {
      logger.d('onRefresh()');
      state = state.copyWith(isRefreshing: true);
      final String cacheId = 'feeds:timeline-${profileController.currentProfileId}';
      final PositiveFeedState? feedState = cacheController.getFromCache<PositiveFeedState>(cacheId);

      // Check if the feed is already loaded
      if (feedState != null && (feedState.pagingController.itemList?.isNotEmpty ?? false)) {
        feedState.pagingController.refresh();
      }
    } finally {
      state = state.copyWith(isRefreshing: false);
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
}
