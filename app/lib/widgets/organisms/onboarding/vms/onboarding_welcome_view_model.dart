// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/providers/user/pledge_controller.dart';
import 'package:app/services/third_party.dart';
import '../../../../hooks/lifecycle_hook.dart';

part 'onboarding_welcome_view_model.freezed.dart';
part 'onboarding_welcome_view_model.g.dart';

@freezed
class OnboardingWelcomeViewModelState with _$OnboardingWelcomeViewModelState {
  const factory OnboardingWelcomeViewModelState() = _OnboardingWelcomeViewModelState;

  factory OnboardingWelcomeViewModelState.initialState() => const OnboardingWelcomeViewModelState();
}

@riverpod
class OnboardingWelcomeViewModel extends _$OnboardingWelcomeViewModel with LifecycleMixin {
  @override
  OnboardingWelcomeViewModelState build() {
    return OnboardingWelcomeViewModelState.initialState();
  }

  Future<void> onContinueSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final PledgeControllerState pledgeState = await ref.read(asyncPledgeControllerProvider.future);
    final Logger logger = ref.read(loggerProvider);

    if (!pledgeState.arePledgesAccepted) {
      logger.w('Pledges not accepted, navigating to onboarding');
      await appRouter.push(const OnboardingOurPledgeRoute());
    } else {
      logger.i('Pledges accepted, navigating to home');
      await appRouter.push(const HomeRoute());
    }
  }
}
