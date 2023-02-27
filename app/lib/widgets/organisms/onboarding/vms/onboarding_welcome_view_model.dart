// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import '../../../../hooks/lifecycle_hook.dart';

part 'onboarding_welcome_view_model.freezed.dart';
part 'onboarding_welcome_view_model.g.dart';

@freezed
class OnboardingWelcomeViewModelState with _$OnboardingWelcomeViewModelState {
  const factory OnboardingWelcomeViewModelState() = _OnboardingWelcomeViewModelState;

  factory OnboardingWelcomeViewModelState.initialState() => const OnboardingWelcomeViewModelState();
}

@riverpod
class OnboardingWelcomeViewModel extends _$OnboardingWelcomeViewModel with LifecycleMixin {
  @override
  OnboardingWelcomeViewModelState build() {
    return OnboardingWelcomeViewModelState.initialState();
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
