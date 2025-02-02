// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/organisms/splash/splash_page.dart';
import '../../../../hooks/lifecycle_hook.dart';

part 'error_view_model.freezed.dart';
part 'error_view_model.g.dart';

@freezed
class ErrorViewModelState with _$ErrorViewModelState {
  const factory ErrorViewModelState({
    @Default(false) bool isBusy,
  }) = _ErrorViewModelState;

  factory ErrorViewModelState.initialState() => const ErrorViewModelState();
}

@riverpod
class ErrorViewModel extends _$ErrorViewModel with LifecycleMixin {
  @override
  ErrorViewModelState build() {
    return ErrorViewModelState.initialState();
  }

  Future<void> onContinueSelected({
    bool signOut = false,
  }) async {
    state = state.copyWith(isBusy: true);

    try {
      if (signOut) {
        final UserController userController = ref.read(userControllerProvider.notifier);
        await userController.signOut(shouldNavigate: false);
      }

      final AppRouter appRouter = ref.read(appRouterProvider);
      appRouter.replaceAll([SplashRoute(style: SplashStyle.tomorrowStartsNow)]);
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }
}
