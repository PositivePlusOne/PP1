// Dart imports:
import 'dart:async';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/providers/shared/mixin/busy_state_delegate_mixin.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:app/widgets/state/positive_feed_state.dart';
import '../../../../gen/app_router.dart';
import '../../../../hooks/lifecycle_hook.dart';
import '../../../../services/third_party.dart';

// Flutter imports:

part 'profile_view_model.freezed.dart';
part 'profile_view_model.g.dart';

@freezed
class ProfileViewModelState with _$ProfileViewModelState {
  const factory ProfileViewModelState({
    required String targetProfileId,
    @Default(false) bool isBusy,
  }) = _ProfileViewModelState;

  factory ProfileViewModelState.initialState(String targetId) => ProfileViewModelState(
        targetProfileId: targetId,
      );
}

@Riverpod(keepAlive: true)
class ProfileViewModel extends _$ProfileViewModel with LifecycleMixin, BusyStateDelegateMixin {
  @override
  ProfileViewModelState build(String targetId) {
    return ProfileViewModelState.initialState(targetId);
  }

  @override
  void updateBusyState(bool isBusy) {
    state = state.copyWith(isBusy: isBusy);
  }

  Future<void> onRefresh(PositiveFeedState feedState, String cacheKey) async {
    final Logger logger = ref.read(loggerProvider);
    final CacheController cacheController = ref.read(cacheControllerProvider);

    logger.d('onRefresh()');
    cacheController.remove(cacheKey);
    feedState.knownActivities.clear();
    feedState.pagingController.refresh();

    // Wait until the first page is loaded
    int counter = 0;
    while (feedState.pagingController.itemList == null && counter < 10) {
      await Future.delayed(const Duration(milliseconds: 500));
      counter++;

      // Check for an error
      if (feedState.pagingController.error != null) {
        throw feedState.pagingController.error!;
      }
    }

    cacheController.add(key: cacheKey, value: feedState);
  }

  Future<void> onAccountSelected() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter router = ref.read(appRouterProvider);

    logger.d('[Profile View Model] - Navigating to account page');
    router.removeWhere((_) => true);
    await router.push(const AccountRoute());
  }

  Future<void> onDisconnectSelected() async {
    final Logger logger = ref.read(loggerProvider);
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
    final AppRouter router = ref.read(appRouterProvider);

    logger.d('[Profile View Model] - Disconnecting from profile');
    if (state.targetProfileId.isEmpty ?? true) {
      logger.e('[Profile View Model] - Profile ID is empty');
      return;
    }

    state = state.copyWith(isBusy: true);

    try {
      await relationshipController.disconnectRelationship(state.targetProfileId ?? '');
      state = state.copyWith(isBusy: false);

      // Pop the disconnect dialog
      router.pop();
    } catch (e) {
      logger.e('[Profile View Model] - Error disconnecting from profile: $e');
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }
}
