// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/guards/biometrics_guard.dart';
import 'package:app/widgets/animations/positive_page_animation.dart';
import 'package:app/widgets/organisms/biometrics/biometrics_preferences_page.dart';
import 'package:app/widgets/organisms/error/error_page.dart';
import 'package:app/widgets/organisms/home/home_page.dart';
import 'package:app/widgets/organisms/onboarding/onboarding_connect_page.dart';
import 'package:app/widgets/organisms/onboarding/onboarding_education_page.dart';
import 'package:app/widgets/organisms/onboarding/onboarding_guidance_page.dart';
import 'package:app/widgets/organisms/onboarding/onboarding_welcome_page.dart';
import 'package:app/widgets/organisms/registration/registration_email_entry_page.dart';
import 'package:app/widgets/organisms/terms_and_conditions/terms_and_conditions_page.dart';
import '../guards/authentication_guard.dart';
import '../guards/notification_guard.dart';
import '../guards/pledge_guard.dart';
import '../guards/profile_guard.dart';
import '../guards/splash_guard.dart';
import '../widgets/organisms/home/chat_list_page.dart';
import '../widgets/organisms/home/chat_page.dart';
import '../widgets/organisms/home/components/chat_stream_wrapper.dart';
import '../widgets/organisms/notifications/notification_preferences_page.dart';
import '../widgets/organisms/onboarding/enumerations/onboarding_style.dart';
import '../widgets/organisms/onboarding/onboarding_our_pledge_page.dart';
import '../widgets/organisms/onboarding/onboarding_your_pledge_page.dart';
import '../widgets/organisms/registration/registration_account_page.dart';
import '../widgets/organisms/registration/registration_account_setup_page.dart';
import '../widgets/organisms/registration/registration_password_entry_page.dart';
import '../widgets/organisms/registration/registration_phone_entry_page.dart';
import '../widgets/organisms/registration/registration_phone_verification_page.dart';
import '../widgets/organisms/search/search_page.dart';
import '../widgets/organisms/splash/splash_page.dart';

part 'app_router.g.dart';
part 'app_router.gr.dart';

@Riverpod(keepAlive: true)
AppRouter appRouter(AppRouterRef ref) {
  return AppRouter(
    authenticationGuard: AuthenticationGuard(),
    pledgeGuard: PledgeGuard(),
    notificationGuard: NotificationGuard(),
    biometricsGuard: BiometricsGuard(),
    profileGuard: ProfileGuard(),
    splashGuard: SplashGuard(),
  );
}

const List<Type> kCommonGuards = [
  PledgeGuard,
  AuthenticationGuard,
  NotificationGuard,
  BiometricsGuard,
  ProfileGuard,
];

@CustomAutoRouter(
  replaceInRouteName: 'Page,Route', // Page suffixes are replaced with Route
  transitionsBuilder: PositivePageAnimation.radialTransition,
  durationInMilliseconds: PositivePageAnimation.durationMillis,
  routes: [
    AutoRoute(page: SplashPage, guards: [SplashGuard], initial: true),
    AutoRoute(page: OnboardingWelcomePage, path: '/onboarding/welcome'),
    AutoRoute(page: OnboardingConnectPage, path: '/onboarding/connect'),
    AutoRoute(page: OnboardingEducationPage, path: '/onboarding/education'),
    AutoRoute(page: OnboardingGuidancePage, path: '/onboarding/guidance'),
    AutoRoute(page: OnboardingOurPledgePage, path: '/onboarding/our-pledge'),
    AutoRoute(page: OnboardingYourPledgePage, path: '/onboarding/your-pledge'),
    AutoRoute(page: RegistrationAccountPage, path: '/registration/account'),
    AutoRoute(page: RegistrationEmailEntryPage, path: '/registration/create/email'),
    AutoRoute(page: RegistrationPasswordEntryPage, path: '/registration/create/password'),
    AutoRoute(page: RegistrationPhoneEntryPage, path: '/registration/create/phone'),
    AutoRoute(page: RegistrationPhoneVerificationPage, path: '/registration/create/phone/verify'),
    AutoRoute(page: RegistrationAccountSetupPage, path: '/registration/profile/start'),
    AutoRoute(page: TermsAndConditionsPage, path: '/terms'),
    AutoRoute(page: NotificationPreferencesPage, path: '/notifications'),
    AutoRoute(page: BiometricsPreferencesPage, path: '/biometrics'),
    AutoRoute(page: ErrorPage, path: '/error'),
    AutoRoute(page: HomePage, path: '/home', guards: kCommonGuards),
    AutoRoute(page: SearchPage, path: '/search', guards: kCommonGuards),
    AutoRoute(page: ChatListPage, path: '/chat/list'),
    AutoRoute(page: ChatPage, path: '/chat/current'),
    RedirectRoute(path: '*', redirectTo: '/'),
  ],
)
class AppRouter extends _$AppRouter {
  AppRouter({
    required super.authenticationGuard,
    required super.pledgeGuard,
    required super.notificationGuard,
    required super.biometricsGuard,
    required super.profileGuard,
    required super.splashGuard,
  });
}

extension AppRouterExtensions on AppRouter {
  void removeAll() {
    removeWhere((route) => true);
  }

  Future<void> removeAllAndPush(PageRouteInfo<dynamic> route) async {
    removeAll();
    await push(route);
  }
}
