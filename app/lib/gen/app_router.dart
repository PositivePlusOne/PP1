// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/widgets/animations/positive_page_animation.dart';
import 'package:app/widgets/organisms/onboarding/onboarding_connect_page.dart';
import 'package:app/widgets/organisms/onboarding/onboarding_education_page.dart';
import 'package:app/widgets/organisms/onboarding/onboarding_guidance_page.dart';
import 'package:app/widgets/organisms/onboarding/onboarding_welcome_page.dart';
import '../widgets/organisms/onboarding/enumerations/onboarding_style.dart';
import '../widgets/organisms/onboarding/onboarding_our_pledge_page.dart';
import '../widgets/organisms/onboarding/onboarding_your_pledge_page.dart';
import '../widgets/organisms/splash/splash_page.dart';

part 'app_router.g.dart';
part 'app_router.gr.dart';

@Riverpod(keepAlive: true)
AppRouter appRouter(AppRouterRef ref) {
  return AppRouter();
}

@CustomAutoRouter(
  replaceInRouteName: 'Page,Route', // Page suffixes are replaced with Route
  transitionsBuilder: PositivePageAnimation.radialTransition,
  durationInMilliseconds: PositivePageAnimation.durationMillis,
  routes: [
    AutoRoute(page: SplashPage, initial: true),
    AutoRoute(page: OnboardingWelcomePage, path: '/onboarding/welcome'),
    AutoRoute(page: OnboardingConnectPage, path: '/onboarding/connect'),
    AutoRoute(page: OnboardingEducationPage, path: '/onboarding/education'),
    AutoRoute(page: OnboardingGuidancePage, path: '/onboarding/guidance'),
    AutoRoute(page: OnboardingOurPledgePage, path: '/onboarding/our-pledge'),
    AutoRoute(page: OnboardingYourPledgePage, path: '/onboarding/your-pledge'),
  ],
)
class AppRouter extends _$AppRouter {}
