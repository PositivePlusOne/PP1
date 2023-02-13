// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/widgets/organisms/onboarding/enumerations/onboarding_style.dart';
import '../../../gen/app_router.dart';
import '../../../hooks/lifecycle_hook.dart';

part 'onboarding_guidance_controller.freezed.dart';
part 'onboarding_guidance_controller.g.dart';

@freezed
class OnboardingGuidanceControllerState with _$OnboardingGuidanceControllerState {
  const factory OnboardingGuidanceControllerState() = _OnboardingGuidanceControllerState;

  factory OnboardingGuidanceControllerState.initialState() => const OnboardingGuidanceControllerState();
}

@riverpod
class OnboardingGuidanceController extends _$OnboardingGuidanceController with LifecycleMixin {
  @override
  OnboardingGuidanceControllerState build() {
    return OnboardingGuidanceControllerState.initialState();
  }

  Future<void> onContinueSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    await appRouter.push(OnboardingOurPledgeRoute(style: OnboardingStyle.includeFeatures));
  }
}
