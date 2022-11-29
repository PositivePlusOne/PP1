import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ppo_package_test/helpers/ppo_test_helpers.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/client/onboarding/onboarding_page.dart';
import 'package:ppoa/client/routing/app_router.gr.dart';

import '../../mocktail/fallback_helpers.dart';
import '../helpers/app_state_builder.dart';
import '../helpers/widget_tester_helpers.dart';
import '../routing/mocks/mock_router.dart';

void main() {
  setUpAll(() {
    registerMockFallbackValues();
  });

  testZephyrWidgets('', 'Can continue from the Onboarding page successfully to the next step', testCanContinue);
  testZephyrWidgets('', 'Can skip from the Onboarding page to the pledge', testCanSkip);
  testZephyrWidgets('', 'Can sign in from the Onboarding page and be sent to the pledge', testCanSignIn);
  testZephyrWidgets('', 'Can go back from the Onboarding page, back to the welcome component', testCanBack);
}

Future<void> testCanBack(WidgetTester widgetTester, String testCaseName) async {
  await _renderPage(widgetTester, displayPledgeOnly: true);

  final Finder backFinder = find.text('Back');
  await widgetTester.tap(backFinder);

  final MockRouter router = GetIt.instance.get<AppRouter>() as MockRouter;
  verify(() => router.push(OnboardingRoute(stepIndex: 0, displayPledgeOnly: false))).called(1);
}

Future<void> testCanSignIn(WidgetTester widgetTester, String testCaseName) async {
  await _renderPage(widgetTester);

  final Finder continueFinder = find.text('Sign In / Register');
  await widgetTester.tap(continueFinder);

  final MockRouter router = GetIt.instance.get<AppRouter>() as MockRouter;
  verify(() => router.push(OnboardingRoute(stepIndex: 0, displayPledgeOnly: true))).called(1);
}

Future<void> testCanSkip(WidgetTester widgetTester, String testCaseName) async {
  await _renderPage(widgetTester);

  final Finder skipFinder = find.text('Skip');
  await widgetTester.tap(skipFinder);

  final MockRouter router = GetIt.instance.get<AppRouter>() as MockRouter;
  verify(() => router.push(OnboardingRoute(stepIndex: 2))).called(1);
}

Future<void> testCanContinue(WidgetTester widgetTester, String testCaseName) async {
  await _renderPage(widgetTester);

  final Finder continueFinder = find.text('Sign In / Register');
  await widgetTester.tap(continueFinder);

  final MockRouter router = GetIt.instance.get<AppRouter>() as MockRouter;
  verify(() => router.push(OnboardingRoute(stepIndex: 1))).called(1);
}

Future<void> _renderPage(WidgetTester widgetTester, {int stepIndex = 0, bool displayPledgeOnly = false}) async {
  final AppStateBuilder appStateBuilder = AppStateBuilder.create()..withMockOnboardingStepsAndFeatures();
  final AppState appState = appStateBuilder.appState;
  final OnboardingPage onboardingPage = OnboardingPage(stepIndex: stepIndex, displayPledgeOnly: displayPledgeOnly);

  await pumpWidgetWithProviderScopeAndServices(onboardingPage, appState, widgetTester);
}
