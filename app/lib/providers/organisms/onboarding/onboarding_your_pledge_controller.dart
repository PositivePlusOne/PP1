import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../hooks/lifecycle_hook.dart';

part 'onboarding_your_pledge_controller.freezed.dart';
part 'onboarding_your_pledge_controller.g.dart';

@freezed
class OnboardingYourPledgeControllerState with _$OnboardingYourPledgeControllerState {
  const factory OnboardingYourPledgeControllerState({
    @Default(false) bool hasAcceptedPledge,
  }) = _OnboardingYourPledgeControllerState;

  factory OnboardingYourPledgeControllerState.initialState() => const OnboardingYourPledgeControllerState(
        hasAcceptedPledge: false,
      );
}

@riverpod
class OnboardingYourPledgeController extends _$OnboardingYourPledgeController with LifecycleMixin {
  @override
  OnboardingYourPledgeControllerState build() {
    return OnboardingYourPledgeControllerState.initialState();
  }
}
