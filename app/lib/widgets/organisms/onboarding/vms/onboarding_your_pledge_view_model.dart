// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/providers/user/pledge_controller.dart';
import '../../../../gen/app_router.dart';
import '../../../../hooks/lifecycle_hook.dart';

part 'onboarding_your_pledge_view_model.freezed.dart';
part 'onboarding_your_pledge_view_model.g.dart';

@freezed
class OnboardingYourPledgeViewModelState with _$OnboardingYourPledgeViewModelState {
  const factory OnboardingYourPledgeViewModelState({
    @Default(false) bool hasAcceptedPledge,
  }) = _OnboardingYourPledgeViewModelState;

  factory OnboardingYourPledgeViewModelState.initialState() => const OnboardingYourPledgeViewModelState(
        hasAcceptedPledge: false,
      );
}

@riverpod
class OnboardingYourPledgeViewModel extends _$OnboardingYourPledgeViewModel with LifecycleMixin {
  @override
  OnboardingYourPledgeViewModelState build() {
    return OnboardingYourPledgeViewModelState.initialState();
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
    final AsyncPledgeController pledgeController = ref.watch(asyncPledgeControllerProvider.notifier);
    await pledgeController.notifyPledgesAccepted();

    final AppRouter appRouter = ref.read(appRouterProvider);
    await appRouter.replaceAll([const HomeRoute()]);
  }

  Future<void> onLinkTapped(String link) async {
    //! This is only the terms and conditions link
    final AppRouter appRouter = ref.read(appRouterProvider);
    await appRouter.push(const TermsAndConditionsRoute());
  }
}
