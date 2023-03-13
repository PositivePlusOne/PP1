// Dart imports:
import 'dart:async';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/content/topics_controller.dart';
import 'package:app/providers/user/messaging_controller.dart';
import 'package:app/providers/user/profile_controller.dart';
import '../../../../services/third_party.dart';

part 'home_view_model.freezed.dart';
part 'home_view_model.g.dart';

@freezed
class HomeViewModelState with _$HomeViewModelState {
  const factory HomeViewModelState({
    @Default(false) bool isRefreshing,
  }) = _HomeViewModelState;

  factory HomeViewModelState.initialState() => const HomeViewModelState();
}

@riverpod
class HomeViewModel extends _$HomeViewModel with LifecycleMixin {
  final RefreshController refreshController = RefreshController();

  @override
  HomeViewModelState build() {
    return HomeViewModelState.initialState();
  }

  @override
  void onFirstRender() {
    onRefresh();
    super.onFirstRender();
  }

  Future<void> onRefresh() async {
    final Logger logger = ref.read(loggerProvider);
    final TopicsController topicsController = ref.read(topicsControllerProvider.notifier);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final MessagingController messagingController = ref.read(messagingControllerProvider.notifier);
    state = state.copyWith(isRefreshing: true);

    try {
      await profileController.updateFirebaseMessagingToken();
      await messagingController.connectStreamUser();
      await topicsController.updateTopics();
    } catch (e) {
      logger.d('onRefresh() - error: $e');
    } finally {
      state = state.copyWith(isRefreshing: false);
    }
  }

  Future<void> onAccountSelected() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    logger.d('onAccountSelected()');

    await appRouter.push(const AccountRoute());
  }
}
