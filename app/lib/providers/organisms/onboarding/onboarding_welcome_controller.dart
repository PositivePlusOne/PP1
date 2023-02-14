// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import '../../../hooks/lifecycle_hook.dart';

part 'onboarding_welcome_controller.freezed.dart';
part 'onboarding_welcome_controller.g.dart';

@freezed
class OnboardingWelcomeControllerState with _$OnboardingWelcomeControllerState {
  const factory OnboardingWelcomeControllerState() = _OnboardingWelcomeControllerState;

  factory OnboardingWelcomeControllerState.initialState() => const OnboardingWelcomeControllerState();
}

@riverpod
class OnboardingWelcomeController extends _$OnboardingWelcomeController with LifecycleMixin {
  @override
  OnboardingWelcomeControllerState build() {
    return OnboardingWelcomeControllerState.initialState();
  }

  Future<void> onSignUpSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    await appRouter.push(OnboardingConnectRoute());
  }

  Future<void> onContinueSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    await appRouter.push(OnboardingConnectRoute());
  }
}
