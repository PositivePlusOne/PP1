// Dart imports:
import 'dart:async';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/content/topics_controller.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/providers/user/messaging_controller.dart';
import 'package:app/providers/user/profile_controller.dart';
import 'package:app/widgets/organisms/login/vms/login_view_model.dart';
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
  RefreshController refreshController = RefreshController();

  @override
  HomeViewModelState build() {
    return HomeViewModelState.initialState();
  }

  @override
  void onFirstRender() {
    refreshController = RefreshController();
    onRefresh();

    super.onFirstRender();
  }

  Future<void> onRefresh() async {
    final Logger logger = ref.read(loggerProvider);
    final NotificationsController notificationsController = ref.read(notificationsControllerProvider.notifier);
    final TopicsController topicsController = ref.read(topicsControllerProvider.notifier);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final MessagingController messagingController = ref.read(messagingControllerProvider.notifier);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);

    if (firebaseAuth.currentUser == null) {
      logger.e('onRefresh() - user is null');
      return;
    }

    state = state.copyWith(isRefreshing: true);

    try {
      await profileController.updateFirebaseMessagingToken();
      await messagingController.connectStreamUser();
      await topicsController.updateTopics();
      await notificationsController.updateNotifications();
    } catch (e) {
      logger.d('onRefresh() - error: $e');
    } finally {
      refreshController.refreshCompleted();
      state = state.copyWith(isRefreshing: false);
    }
  }

  Future<void> onSignInSelected() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final LoginViewModel loginViewModel = ref.read(loginViewModelProvider.notifier);

    logger.d('onSignInRequested()');
    loginViewModel.resetState();
    await appRouter.push(LoginRoute(senderRoute: HomeRoute));
  }

  Future<void> onAccountSelected() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    logger.d('onAccountSelected()');

    if (firebaseAuth.currentUser == null) {
      logger.e('onAccountSelected() - user is null');
      await appRouter.push(const RegistrationAccountRoute());
    } else {
      logger.d('onAccountSelected() - user is not null');
      await appRouter.push(const AccountRoute());
    }
  }

  Future<void> onNotificationsSelected() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d('onNotificationsSelected()');
    await appRouter.push(const NotificationsRoute());
  }
}
