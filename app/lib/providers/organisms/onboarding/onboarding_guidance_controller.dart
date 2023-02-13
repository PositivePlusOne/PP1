import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../hooks/lifecycle_hook.dart';

part 'onboarding_guidance_controller.freezed.dart';
part 'onboarding_guidance_controller.g.dart';

@freezed
class OnboardingGuidanceControllerState with _$OnboardingGuidanceControllerState {
  const factory OnboardingGuidanceControllerState() = _OnboardingGuidanceControllerState;

  factory OnboardingGuidanceControllerState.initialState() => const OnboardingGuidanceControllerState();
}

@riverpod
class OnboardingConnectController extends _$OnboardingConnectController with LifecycleMixin {
  @override
  OnboardingGuidanceControllerState build() {
    return OnboardingGuidanceControllerState.initialState();
  }
}
