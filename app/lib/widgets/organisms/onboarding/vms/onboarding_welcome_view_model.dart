// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/providers/user/pledge_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/organisms/login/vms/login_view_model.dart';
import 'package:app/widgets/organisms/onboarding/enumerations/onboarding_style.dart';
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

  Future<void> onSignUpSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final PledgeControllerState pledgeState = await ref.read(asyncPledgeControllerProvider.future);
    final LoginViewModel loginViewModel = ref.read(loginViewModelProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    if (!pledgeState.arePledgesAccepted) {
      logger.w('Pledges not accepted, navigating to onboarding');
      await appRouter.push(OnboardingOurPledgeRoute(style: OnboardingStyle.registration));
    } else {
      logger.i('Pledges accepted, navigating to login');
      loginViewModel.resetState();
      await appRouter.push(LoginRoute(senderRoute: RegistrationAccountRoute));
    }
  }

  Future<void> onContinueSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final PledgeControllerState pledgeState = await ref.read(asyncPledgeControllerProvider.future);
    final Logger logger = ref.read(loggerProvider);

    if (!pledgeState.arePledgesAccepted) {
      logger.w('Pledges not accepted, navigating to onboarding');
      await appRouter.push(const OnboardingConnectRoute());
    } else {
      logger.i('Pledges accepted, navigating to home');
      await appRouter.push(const HomeRoute());
    }
  }
}
