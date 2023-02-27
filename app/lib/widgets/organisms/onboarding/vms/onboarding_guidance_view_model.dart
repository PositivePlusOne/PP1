// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/widgets/organisms/onboarding/enumerations/onboarding_style.dart';
import '../../../../gen/app_router.dart';
import '../../../../hooks/lifecycle_hook.dart';

part 'onboarding_guidance_view_model.freezed.dart';
part 'onboarding_guidance_view_model.g.dart';

@freezed
class OnboardingGuidanceViewModelState with _$OnboardingGuidanceViewModelState {
  const factory OnboardingGuidanceViewModelState() = _OnboardingGuidanceViewModelState;

  factory OnboardingGuidanceViewModelState.initialState() => const OnboardingGuidanceViewModelState();
}

@riverpod
class OnboardingGuidanceViewModel extends _$OnboardingGuidanceViewModel with LifecycleMixin {
  @override
  OnboardingGuidanceViewModelState build() {
    return OnboardingGuidanceViewModelState.initialState();
  }

  Future<void> onContinueSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    await appRouter.push(OnboardingOurPledgeRoute(style: OnboardingStyle.includeFeatures));
  }

  Future<void> onSkipSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    await appRouter.push(OnboardingOurPledgeRoute());
  }
}
