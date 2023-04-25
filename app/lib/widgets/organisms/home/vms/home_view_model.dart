// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/widgets/organisms/login/vms/login_view_model.dart';
import '../../../../dtos/database/activities/activities.dart';
import '../../../../services/third_party.dart';

part 'home_view_model.freezed.dart';
part 'home_view_model.g.dart';

@freezed
class HomeViewModelState with _$HomeViewModelState {
  const factory HomeViewModelState({
    @Default(false) bool isRefreshing,
    @Default(false) bool hasPerformedInitialRefresh,
    @Default(0) currentTabIndex,
    @Default([]) List<Activity> events,
  }) = _HomeViewModelState;

  factory HomeViewModelState.initialState() => const HomeViewModelState();
}

@Riverpod(keepAlive: true)
class HomeViewModel extends _$HomeViewModel with LifecycleMixin {
  final RefreshController refreshController = RefreshController();

  @override
  HomeViewModelState build() {
    return HomeViewModelState.initialState();
  }

  @override
  void onFirstRender() {
    if (!state.hasPerformedInitialRefresh) {
      onRefresh();
      state = state.copyWith(hasPerformedInitialRefresh: true);
    }

    super.onFirstRender();
  }

  Future<void> onTabSelected(int index) async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('onTabSelected() - index: $index');
    state = state.copyWith(currentTabIndex: index);
  }

  Future<void> onRefresh() async {
    final Logger logger = ref.read(loggerProvider);
    final NotificationsController notificationsController = ref.read(notificationsControllerProvider.notifier);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);

    if (firebaseAuth.currentUser == null) {
      logger.e('onRefresh() - user is null');
      return;
    }

    state = state.copyWith(isRefreshing: true);

    try {
      await Future.wait([
        notificationsController.updateNotifications(),
        updateEvents(),
      ]);
    } catch (e) {
      logger.d('onRefresh() - error: $e');
    } finally {
      refreshController.refreshCompleted();
      state = state.copyWith(isRefreshing: false);
    }
  }

  Future<void> updateEvents() async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('updateEvents()', 'HomeViewModel');

    final FirebaseFunctions functions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = functions.httpsCallable('activities-getEventActivities');
    final HttpsCallableResult result = await callable.call();

    logger.d('updateEvents() - result: ${result.data}');
    final List<dynamic> events = (json.decode(result.data) as Map<String, dynamic>).values.toList();
    final List<Activity> activities = events.map((dynamic e) => Activity.fromJson(e as Map<String, dynamic>)).toList();

    state = state.copyWith(events: activities);
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
