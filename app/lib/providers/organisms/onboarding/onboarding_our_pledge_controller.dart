import 'package:app/gen/app_router.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../hooks/lifecycle_hook.dart';

part 'onboarding_our_pledge_controller.freezed.dart';
part 'onboarding_our_pledge_controller.g.dart';

@freezed
class OnboardingOurPledgeControllerState with _$OnboardingOurPledgeControllerState {
  const factory OnboardingOurPledgeControllerState({
    @Default(false) bool hasAcceptedPledge,
  }) = _OnboardingOurPledgeControllerState;

  factory OnboardingOurPledgeControllerState.initialState() => const OnboardingOurPledgeControllerState(
        hasAcceptedPledge: false,
      );
}

@riverpod
class OnboardingOurPledgeController extends _$OnboardingOurPledgeController with LifecycleMixin {
  @override
  OnboardingOurPledgeControllerState build() {
    return OnboardingOurPledgeControllerState.initialState();
  }

  Future<void> onBackSelected() async {
    final AppRouter appRouter = ref.watch(appRouterProvider);
    appRouter.pop();
  }

  Future<void> onToggleCheckbox() async {
    state = state.copyWith(
      hasAcceptedPledge: !state.hasAcceptedPledge,
    );
  }

  Future<void> onContinueSelected() async {
    final AppRouter appRouter = ref.watch(appRouterProvider);
  }
}
