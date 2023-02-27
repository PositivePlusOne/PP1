// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import '../../../../gen/app_router.dart';
import '../../../../hooks/lifecycle_hook.dart';

part 'onboarding_education_view_model.freezed.dart';
part 'onboarding_education_view_model.g.dart';

@freezed
class OnboardingEducationViewModelState with _$OnboardingEducationViewModelState {
  const factory OnboardingEducationViewModelState() = _OnboardingEducationViewModelState;

  factory OnboardingEducationViewModelState.initialState() => const OnboardingEducationViewModelState();
}

@riverpod
class OnboardingEducationViewModel extends _$OnboardingEducationViewModel with LifecycleMixin {
  @override
  OnboardingEducationViewModelState build() {
    return OnboardingEducationViewModelState.initialState();
  }

  Future<void> onContinueSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    await appRouter.push(OnboardingGuidanceRoute());
  }

  Future<void> onSkipSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    await appRouter.push(OnboardingOurPledgeRoute());
  }
}
