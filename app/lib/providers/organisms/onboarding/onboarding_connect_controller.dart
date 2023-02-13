// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import '../../../hooks/lifecycle_hook.dart';

part 'onboarding_connect_controller.freezed.dart';
part 'onboarding_connect_controller.g.dart';

@freezed
class OnboardingConnectControllerState with _$OnboardingConnectControllerState {
  const factory OnboardingConnectControllerState() = _OnboardingConnectControllerState;

  factory OnboardingConnectControllerState.initialState() => const OnboardingConnectControllerState();
}

@riverpod
class OnboardingConnectController extends _$OnboardingConnectController with LifecycleMixin {
  @override
  OnboardingConnectControllerState build() {
    return OnboardingConnectControllerState.initialState();
  }

  Future<void> onContinueSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    await appRouter.push(OnboardingEducationRoute());
  }
}
