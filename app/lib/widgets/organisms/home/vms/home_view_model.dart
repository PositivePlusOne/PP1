// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/widgets/organisms/login/vms/login_view_model.dart';
import '../../../../services/third_party.dart';

part 'home_view_model.freezed.dart';
part 'home_view_model.g.dart';

@freezed
class HomeViewModelState with _$HomeViewModelState {
  const factory HomeViewModelState({
    @Default(false) bool isRefreshing,
    @Default(0) currentTabIndex,
  }) = _HomeViewModelState;

  factory HomeViewModelState.initialState() => const HomeViewModelState();
}

@Riverpod(keepAlive: true)
class HomeViewModel extends _$HomeViewModel with LifecycleMixin {
  ScrollController scrollController = ScrollController();

  @override
  HomeViewModelState build() {
    return HomeViewModelState.initialState();
  }

  @override
  void onFirstRender() {
    super.onFirstRender();
    resetControllers();
  }

  void resetControllers() {
    final Logger logger = ref.read(loggerProvider);
    logger.d('resetControllers()');

    scrollController = ScrollController();
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

    resetControllers();
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
