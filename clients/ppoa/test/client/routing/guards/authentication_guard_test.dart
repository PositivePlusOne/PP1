// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ppo_package_test/helpers/ppo_test_helpers.dart';

// Project imports:
import 'package:ppoa/business/models/features/onboarding_step.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/design_system/models/design_system_state.dart';
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';
import 'package:ppoa/business/state/environment/models/environment.dart';
import 'package:ppoa/business/state/system/system_state.dart';
import 'package:ppoa/business/state/user/models/user.dart';
import 'package:ppoa/client/routing/app_router.gr.dart';
import 'package:ppoa/client/routing/guards/authentication_guard.dart';
import 'package:ppoa/client/splash/splash_lifecycle.dart';
import '../../../business/helpers/app_state_helpers.dart';
import '../../../mocktail/fallback_helpers.dart';
import '../mocks/mock_navigation_resolver.dart';
import '../mocks/mock_router.dart';

void main() {
  setUpAll(() {
    registerMockFallbackValues();
  });

  testZephyr('', 'When logged in, then authentication guard will continue', testAuthGuardLoggedIn);
  testZephyr('', 'When logged out with onboarding steps, then authentication guard will redirect', testAuthGuardOnboarding);
  testZephyr('', 'When logged out without onboarding steps, then authentication guard will redirect', testAuthGuardSplash);
}

Future<void> testAuthGuardSplash(String testCaseName) async {
  final AppState initialState = AppState(
    user: User.empty(),
    systemState: SystemState.empty(),
    designSystem: DesignSystemState.empty(),
    environment: const Environment(
      type: EnvironmentType.test,
      onboardingSteps: [],
    ),
  );

  final MockRouter router = MockRouter();
  final MockNavigationResolver navigationResolver = MockNavigationResolver();
  final AuthenticationGuard authenticationGuard = AuthenticationGuard();

  await setTestServiceState(initialState);

  when(() => router.push(any())).thenAnswer((_) async {
    return null;
  });

  authenticationGuard.onNavigation(navigationResolver, router);

  verifyNever(() => navigationResolver.next(any()));
  verify(() => router.push(SplashRoute(style: SplashStyle.values.first))).called(1);
}

Future<void> testAuthGuardOnboarding(String testCaseName) async {
  final AppState initialState = AppState(
    user: User.empty(),
    systemState: SystemState.empty(),
    designSystem: DesignSystemState.empty(),
    environment: const Environment(
      type: EnvironmentType.test,
      onboardingSteps: <OnboardingStep>[
        OnboardingStep(type: OnboardingStepType.feature),
      ],
    ),
  );

  final MockRouter router = MockRouter();
  final MockNavigationResolver navigationResolver = MockNavigationResolver();
  final AuthenticationGuard authenticationGuard = AuthenticationGuard();

  await setTestServiceState(initialState);

  when(() => router.push(any())).thenAnswer((_) async {
    return null;
  });

  authenticationGuard.onNavigation(navigationResolver, router);

  verifyNever(() => navigationResolver.next(any()));
  verify(() => router.push(OnboardingRoute(stepIndex: 0))).called(1);
}

Future<void> testAuthGuardLoggedIn(String testCaseName) async {
  final AppState initialState = AppState(
    environment: Environment.initialState(environmentType: EnvironmentType.test),
    systemState: SystemState.empty(),
    designSystem: DesignSystemState.empty(),
    user: const User(id: 'mock-user', hasCreatedProfile: false),
  );

  final MockRouter router = MockRouter();
  final MockNavigationResolver navigationResolver = MockNavigationResolver();
  final AuthenticationGuard authenticationGuard = AuthenticationGuard();

  await setTestServiceState(initialState);

  authenticationGuard.onNavigation(navigationResolver, router);

  verify(() => navigationResolver.next(any())).called(1);
}
