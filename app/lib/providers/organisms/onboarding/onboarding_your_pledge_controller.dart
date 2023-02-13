// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import '../../../gen/app_router.dart';
import '../../../hooks/lifecycle_hook.dart';
import '../../../widgets/organisms/onboarding/enumerations/onboarding_style.dart';

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

  Future<void> onBackSelected() async {
    final AppRouter appRouter = ref.watch(appRouterProvider);
    appRouter.pop();
  }

  Future<void> onToggleCheckbox() async {
    state = state.copyWith(
      hasAcceptedPledge: !state.hasAcceptedPledge,
    );
  }

  Future<void> onContinueSelected(OnboardingStyle style) async {
    final AppRouter appRouter = ref.watch(appRouterProvider);
  }

  void onLinkTapped(String text, String? href, String title) {
    // TODO(ryan): Handle internal link tap
  }
}
