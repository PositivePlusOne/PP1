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
import 'package:app/widgets/organisms/profile/hiv_status_page.dart';
import 'package:app/widgets/organisms/profile/profile_page.dart';
import 'package:app/widgets/organisms/registration/registration_email_entry_page.dart';
import 'package:app/widgets/organisms/terms_and_conditions/terms_and_conditions_page.dart';
import '../guards/auth_provider_guard.dart';
import '../guards/authentication_guard.dart';
import '../guards/development_guard.dart';
import '../guards/notification_guard.dart';
import '../guards/pledge_guard.dart';
import '../guards/profile_exists_guard.dart';
import '../guards/profile_setup_guard.dart';
import '../guards/splash_guard.dart';
import '../widgets/organisms/account/account_page.dart';
import '../widgets/organisms/development/development_page.dart';
import '../widgets/organisms/dialogs/hint_dialog_page.dart';
import '../widgets/organisms/home/chat_list_page.dart';
import '../widgets/organisms/home/chat_page.dart';
import '../widgets/organisms/notifications/notification_preferences_page.dart';
import '../widgets/organisms/onboarding/enumerations/onboarding_style.dart';
import '../widgets/organisms/onboarding/onboarding_our_pledge_page.dart';
import '../widgets/organisms/onboarding/onboarding_your_pledge_page.dart';
import '../widgets/organisms/profile/dialogs/profile_image_dialog_page.dart';
import '../widgets/organisms/profile/profile_birthday_entry_page.dart';
import '../widgets/organisms/profile/profile_display_name_entry_page.dart';
import '../widgets/organisms/profile/profile_edit/profile_edit_settings_page.dart';
import '../widgets/organisms/profile/profile_image_page.dart';
import '../widgets/organisms/profile/profile_image_success_page.dart';
import '../widgets/organisms/profile/profile_image_welcome_page.dart';
import '../widgets/organisms/profile/profile_name_entry_page.dart';
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
    authProviderGuard: AuthProviderGuard(),
    pledgeGuard: PledgeGuard(),
    notificationGuard: NotificationGuard(),
    biometricsGuard: BiometricsGuard(),
    profileSetupGuard: ProfileSetupGuard(),
    profileExistsGuard: ProfileExistsGuard(),
    splashGuard: SplashGuard(),
    developmentGuard: DevelopmentGuard(),
  );
}

const List<Type> kCommonGuards = [
  PledgeGuard,
  AuthProviderGuard,
  NotificationGuard,
  BiometricsGuard,
  ProfileSetupGuard,
];

@CustomAutoRouter(
  replaceInRouteName: 'Page,Route', // Page suffixes are replaced with Route
  transitionsBuilder: PositivePageAnimation.radialTransition,
  durationInMilliseconds: PositivePageAnimation.durationMillis,
  routes: [
    //* Onboarding and splash
    AutoRoute(page: SplashPage, guards: [SplashGuard], initial: true),
    AutoRoute(page: OnboardingWelcomePage, path: '/onboarding/welcome'),
    AutoRoute(page: OnboardingConnectPage, path: '/onboarding/connect'),
    AutoRoute(page: OnboardingEducationPage, path: '/onboarding/education'),
    AutoRoute(page: OnboardingGuidancePage, path: '/onboarding/guidance'),
    AutoRoute(page: OnboardingOurPledgePage, path: '/onboarding/our-pledge'),
    AutoRoute(page: OnboardingYourPledgePage, path: '/onboarding/your-pledge'),
    //* Registration
    AutoRoute(page: RegistrationAccountPage, path: '/registration/account'),
    AutoRoute(page: RegistrationEmailEntryPage, path: '/registration/create/email'),
    AutoRoute(page: RegistrationPasswordEntryPage, path: '/registration/create/password'),
    AutoRoute(page: RegistrationPhoneEntryPage, path: '/registration/create/phone'),
    AutoRoute(page: HIVStatusPage, path: '/registration/profile/hiv-status'),
    AutoRoute(page: RegistrationPhoneVerificationPage, path: '/registration/create/phone/verify'),
    AutoRoute(page: RegistrationAccountSetupPage, path: '/registration/profile/start'),
    //* User Preferences Configuration
    AutoRoute(page: NotificationPreferencesPage, path: '/notifications'),
    AutoRoute(page: BiometricsPreferencesPage, path: '/biometrics'),
    //* Profile and Profile Configuration
    AutoRoute(page: ProfilePage, path: '/profile/view/:userId', guards: [AuthenticationGuard, ProfileExistsGuard]),
    AutoRoute(page: ProfileNameEntryPage, path: '/profile/setup/name', guards: [AuthenticationGuard, ProfileExistsGuard]),
    AutoRoute(page: ProfileDisplayNameEntryPage, path: '/profile/setup/display-name', guards: [AuthenticationGuard, ProfileExistsGuard]),
    AutoRoute(page: ProfileBirthdayEntryPage, path: '/profile/setup/birthday', guards: [AuthenticationGuard, ProfileExistsGuard]),
    AutoRoute(page: ProfileImageWelcomePage, path: '/profile/setup/image/welcome', guards: [AuthenticationGuard, ProfileExistsGuard]),
    AutoRoute(page: ProfileImagePage, path: '/profile/setup/image', guards: [AuthenticationGuard, ProfileExistsGuard]),
    AutoRoute(page: ProfileImageSuccessPage, path: '/profile/setup/image/success', guards: [AuthenticationGuard, ProfileExistsGuard]),
    AutoRoute(page: ProfileImageDialogPage, path: '/profile/setup/image/help', guards: [AuthenticationGuard, ProfileExistsGuard]),
    //* User Edit Profile
    AutoRoute(page: ProfileEditSettingsPage, path: '/profile/edit-settings', guards: [AuthenticationGuard, ProfileExistsGuard]),
    //TODO: update pages as and when they are created
    // AutoRoute(page: ProfileEditSettingsPage, path: '/profile/edit-settings/display-name', guards: [AuthenticationGuard, ProfileExistsGuard]),
    // AutoRoute(page: ProfileEditSettingsPage, path: '/profile/edit-settings/about-you', guards: [AuthenticationGuard, ProfileExistsGuard]),
    // AutoRoute(page: ProfileEditSettingsPage, path: '/profile/edit-settings/gender', guards: [AuthenticationGuard, ProfileExistsGuard]),
    // AutoRoute(page: ProfileEditSettingsPage, path: '/profile/edit-settings/hiv-status', guards: [AuthenticationGuard, ProfileExistsGuard]),
    // AutoRoute(page: ProfileEditSettingsPage, path: '/profile/edit-settings/location', guards: [AuthenticationGuard, ProfileExistsGuard]),
    // AutoRoute(page: ProfileEditSettingsPage, path: '/profile/edit-settings/your-interests', guards: [AuthenticationGuard, ProfileExistsGuard]),
    // AutoRoute(page: ProfileEditSettingsPage, path: '/profile/edit-settings/profile-image', guards: [AuthenticationGuard, ProfileExistsGuard]),
    //* Home and direct affiliates
    AutoRoute(page: HomePage, path: '/home', guards: kCommonGuards),
    AutoRoute(page: SearchPage, path: '/search', guards: [...kCommonGuards, AuthenticationGuard]),
    AutoRoute(page: AccountPage, path: '/account', guards: [...kCommonGuards, AuthenticationGuard]),
    AutoRoute(page: ChatListPage, path: '/chat/list', guards: [...kCommonGuards, AuthenticationGuard]),
    AutoRoute(page: ChatPage, path: '/chat/current', guards: [...kCommonGuards, AuthenticationGuard]),
    // * Dialogs
    AutoRoute(page: TermsAndConditionsPage, path: '/terms'),
    AutoRoute(page: HintDialogPage, path: '/help/dialog'),
    //* Other
    AutoRoute(page: ErrorPage, path: '/error'),
    AutoRoute(page: DevelopmentPage, path: '/devtools', guards: [DevelopmentGuard]),
    RedirectRoute(path: '*', redirectTo: '/'),
  ],
)
class AppRouter extends _$AppRouter {
  AppRouter({
    required super.authenticationGuard,
    required super.authProviderGuard,
    required super.pledgeGuard,
    required super.notificationGuard,
    required super.biometricsGuard,
    required super.profileSetupGuard,
    required super.profileExistsGuard,
    required super.splashGuard,
    required super.developmentGuard,
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
