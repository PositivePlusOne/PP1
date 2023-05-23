// Dart imports:
import 'dart:async';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
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
  @override
  HomeViewModelState build() {
    return HomeViewModelState.initialState();
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
}
