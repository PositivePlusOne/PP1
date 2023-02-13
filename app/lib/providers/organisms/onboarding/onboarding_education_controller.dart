// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import '../../../gen/app_router.dart';
import '../../../hooks/lifecycle_hook.dart';

part 'onboarding_education_controller.freezed.dart';
part 'onboarding_education_controller.g.dart';

@freezed
class OnboardingEducationControllerState with _$OnboardingEducationControllerState {
  const factory OnboardingEducationControllerState() = _OnboardingEducationControllerState;

  factory OnboardingEducationControllerState.initialState() => const OnboardingEducationControllerState();
}

@riverpod
class OnboardingEducationController extends _$OnboardingEducationController with LifecycleMixin {
  @override
  OnboardingEducationControllerState build() {
    return OnboardingEducationControllerState.initialState();
  }

  Future<void> onContinueSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    await appRouter.push(OnboardingGuidanceRoute());
  }
}
