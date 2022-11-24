import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ppoa/business/models/features/onboarding_step.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/business/state/design_system/models/design_system_state.dart';
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';
import 'package:ppoa/business/state/environment/models/environment.dart';
import 'package:ppoa/business/state/user/models/user.dart';
import 'package:ppoa/client/routing/app_router.gr.dart';
import 'package:ppoa/client/routing/guards/authentication_guard.dart';

import '../../../business/helpers/app_state_helpers.dart';
import '../../../mocktail/fallback_helpers.dart';
import '../mocks/mock_navigation_resolver.dart';
import '../mocks/mock_router.dart';

void main() {
  setUpAll(() {
    registerMockFallbackValues();
  });

  test('When logged in, then authentication guard will continue', testAuthGuardLoggedIn);
  test('When logged out with onboarding steps, then authentication guard will redirect', testAuthGuardOnboarding);
  test('When logged out without onboarding steps, then authentication guard will redirect', testAuthGuardSplash);
}

Future<void> testAuthGuardSplash() async {
  final AppState initialState = AppState(
    user: User.empty(),
    designSystem: DesignSystemState.empty(),
    environment: const Environment(
      type: EnvironmentType.test,
      onboardingFeatures: [],
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
  verify(() => router.push(const SplashRoute())).called(1);
}

Future<void> testAuthGuardOnboarding() async {
  final AppState initialState = AppState(
    user: User.empty(),
    designSystem: DesignSystemState.empty(),
    environment: const Environment(
      type: EnvironmentType.test,
      onboardingFeatures: [],
      onboardingSteps: <OnboardingStep>[
        OnboardingStep(type: OnboardingStepType.feature, key: '', markdown: ''),
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
  verify(() => router.push(const OnboardingRoute())).called(1);
}

Future<void> testAuthGuardLoggedIn() async {
  final AppState initialState = AppState(
    environment: Environment.initialState(environmentType: EnvironmentType.test),
    designSystem: DesignSystemState.empty(),
    user: const User(displayName: '', emailAddress: '', id: 'mock-user'),
  );

  final MockRouter router = MockRouter();
  final MockNavigationResolver navigationResolver = MockNavigationResolver();
  final AuthenticationGuard authenticationGuard = AuthenticationGuard();

  await setTestServiceState(initialState);

  authenticationGuard.onNavigation(navigationResolver, router);

  verify(() => navigationResolver.next(any())).called(1);
}
