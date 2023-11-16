// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import '../../../../hooks/lifecycle_hook.dart';

part 'onboarding_our_pledge_view_model.freezed.dart';
part 'onboarding_our_pledge_view_model.g.dart';

@freezed
class OnboardingOurPledgeViewModelState with _$OnboardingOurPledgeViewModelState {
  const factory OnboardingOurPledgeViewModelState({
    @Default(false) bool hasAcceptedPledge,
  }) = _OnboardingOurPledgeViewModelState;

  factory OnboardingOurPledgeViewModelState.initialState() => const OnboardingOurPledgeViewModelState(
        hasAcceptedPledge: false,
      );
}

@riverpod
class OnboardingOurPledgeViewModel extends _$OnboardingOurPledgeViewModel with LifecycleMixin {
  @override
  OnboardingOurPledgeViewModelState build() {
    return OnboardingOurPledgeViewModelState.initialState();
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
    await appRouter.push(const OnboardingYourPledgeRoute());
  }
}
