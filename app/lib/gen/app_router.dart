// Flutter imports:
import 'package:app/providers/organisms/registration/registration_email_entry_page.dart';
import 'package:app/widgets/organisms/terms_and_conditions/terms_and_conditions_page.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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
import '../widgets/organisms/registration/registration_account_page.dart';
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
    AutoRoute(page: RegistrationAccountPage, path: '/registration/account'),
    AutoRoute(page: RegistrationEmailEntryPage, path: '/registration/create/email'),
    AutoRoute(page: TermsAndConditionsPage, path: '/terms'),
  ],
)
class AppRouter extends _$AppRouter {}
