// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/widgets/organisms/profile/profile_about_page.dart';
import 'package:app/guards/biometrics_guard.dart';
import 'package:app/widgets/organisms/account/account_update_email_address_page.dart';
import 'package:app/widgets/organisms/account/account_verification_page.dart';
import 'package:app/widgets/organisms/biometrics/biometrics_preferences_page.dart';
import 'package:app/widgets/organisms/error/error_page.dart';
import 'package:app/widgets/organisms/home/home_page.dart';
import 'package:app/widgets/organisms/onboarding/onboarding_connect_page.dart';
import 'package:app/widgets/organisms/onboarding/onboarding_education_page.dart';
import 'package:app/widgets/organisms/onboarding/onboarding_guidance_page.dart';
import 'package:app/widgets/organisms/onboarding/onboarding_welcome_page.dart';
import 'package:app/widgets/organisms/profile/profile_edit_thanks_page.dart';
import 'package:app/widgets/organisms/profile/profile_gender_select_page.dart';
import 'package:app/widgets/organisms/profile/profile_hiv_status_page.dart';
import 'package:app/widgets/organisms/profile/profile_location_page.dart';
import 'package:app/widgets/organisms/profile/profile_page.dart';
import 'package:app/widgets/organisms/registration/registration_email_entry_page.dart';
import 'package:app/widgets/organisms/terms_and_conditions/terms_and_conditions_page.dart';
import '../guards/auth_provider_guard.dart';
import '../guards/development_guard.dart';
import '../guards/notification_guard.dart';
import '../guards/pledge_guard.dart';
import '../guards/profile_exists_guard.dart';
import '../guards/profile_setup_guard.dart';
import '../guards/signed_in_guard.dart';
import '../guards/signed_out_guard.dart';
import '../guards/splash_guard.dart';
import '../widgets/animations/positive_page_animation.dart';
import '../widgets/organisms/account/account_delete_profile_page.dart';
import '../widgets/organisms/account/account_details_page.dart';
import '../widgets/organisms/account/account_page.dart';
import '../widgets/organisms/account/account_preferences_page.dart';
import '../widgets/organisms/account/account_profile_edit_settings_page.dart';
import '../widgets/organisms/account/account_update_password_page.dart';
import '../widgets/organisms/account/account_update_phone_number_page.dart';
import '../widgets/organisms/account/account_updated_page.dart';
import '../widgets/organisms/development/development_page.dart';
import '../widgets/organisms/dialogs/hint_dialog_page.dart';
import '../widgets/organisms/guidance/guidance_page.dart';
import '../widgets/organisms/home/chat_conversations_page.dart';
import '../widgets/organisms/home/chat_create_page.dart';
import '../widgets/organisms/home/chat_page.dart';
import '../widgets/organisms/login/login_page.dart';
import '../widgets/organisms/login/login_password_page.dart';
import '../widgets/organisms/login/login_welcome_back_page.dart';
import '../widgets/organisms/notifications/notification_preferences_page.dart';
import '../widgets/organisms/notifications/notifications_page.dart';
import '../widgets/organisms/onboarding/enumerations/onboarding_style.dart';
import '../widgets/organisms/onboarding/onboarding_our_pledge_page.dart';
import '../widgets/organisms/onboarding/onboarding_your_pledge_page.dart';
import '../widgets/organisms/profile/profile_biography_entry_page.dart';
import '../widgets/organisms/profile/profile_birthday_entry_page.dart';
import '../widgets/organisms/profile/profile_display_name_entry_page.dart';
import '../widgets/organisms/profile/profile_interests_entry_page.dart';
import '../widgets/organisms/profile/profile_name_entry_page.dart';
import '../widgets/organisms/profile/profile_photo_page.dart';
import '../widgets/organisms/profile/profile_reference_image_page.dart';
import '../widgets/organisms/profile/profile_reference_image_success_page.dart';
import '../widgets/organisms/profile/profile_reference_image_welcome_page.dart';
import '../widgets/organisms/profile/profile_welcome_back_page.dart';
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
  return AppRouter();
}

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  final SignedInGuard signedInGuard = SignedInGuard();
  final SignedOutGuard signedOutGuard = SignedOutGuard();
  final AuthProviderGuard authProviderGuard = AuthProviderGuard();
  final PledgeGuard pledgeGuard = PledgeGuard();
  final NotificationGuard notificationGuard = NotificationGuard();
  final BiometricsGuard biometricsGuard = BiometricsGuard();
  final ProfileSetupGuard profileSetupGuard = ProfileSetupGuard();
  final ProfileExistsGuard profileExistsGuard = ProfileExistsGuard();
  final SplashGuard splashGuard = SplashGuard();
  final DevelopmentGuard developmentGuard = DevelopmentGuard();

  List<AutoRouteGuard> get kCommonGuards => [
        pledgeGuard,
        authProviderGuard,
        notificationGuard,
        biometricsGuard,
        profileSetupGuard,
      ];

  @override
  RouteType get defaultRouteType => const RouteType.custom(
        transitionsBuilder: PositivePageAnimation.radialTransition,
        durationInMilliseconds: PositivePageAnimation.durationMillis,
      );

  @override
  List<AutoRoute> get routes => [
        // //* Onboarding and splash
        AutoRoute(page: SplashRoute.page, guards: [splashGuard], path: '/'),
        AutoRoute(page: OnboardingWelcomeRoute.page, path: '/onboarding/welcome'),
        AutoRoute(page: OnboardingConnectRoute.page, path: '/onboarding/connect'),
        AutoRoute(page: OnboardingEducationRoute.page, path: '/onboarding/education'),
        AutoRoute(page: OnboardingGuidanceRoute.page, path: '/onboarding/guidance'),
        AutoRoute(page: OnboardingOurPledgeRoute.page, path: '/onboarding/our-pledge'),
        AutoRoute(page: OnboardingYourPledgeRoute.page, path: '/onboarding/your-pledge'),
        //* Registration and Onboarding
        AutoRoute(page: RegistrationAccountRoute.page, path: '/registration/account'),
        AutoRoute(page: RegistrationEmailEntryRoute.page, path: '/registration/create/email'),
        AutoRoute(page: RegistrationPasswordEntryRoute.page, path: '/registration/create/password'),
        AutoRoute(page: RegistrationPhoneEntryRoute.page, path: '/registration/create/phone'),
        AutoRoute(page: RegistrationPhoneVerificationRoute.page, path: '/registration/create/phone/verify'),
        AutoRoute(page: RegistrationAccountSetupRoute.page, path: '/registration/profile/start'),
        //* Login and Authentication
        AutoRoute(page: LoginRoute.page, path: '/login', guards: [signedOutGuard]),
        AutoRoute(page: LoginPasswordRoute.page, path: '/login/password', guards: [signedOutGuard]),
        AutoRoute(page: LoginWelcomeBackRoute.page, path: '/login/success'),
        //* User Preferences Configuration
        AutoRoute(page: NotificationPreferencesRoute.page, path: '/notifications'),
        AutoRoute(page: BiometricsPreferencesRoute.page, path: '/biometrics'),
        //* Profile and Profile Configuration
        AutoRoute(page: ProfileRoute.page, path: '/profile/view/:userId', guards: [signedInGuard, profileExistsGuard]),
        AutoRoute(page: ProfileWelcomeBackRoute.page, path: '/profile/setup/continue'),
        AutoRoute(page: ProfileNameEntryRoute.page, path: '/profile/setup/name', guards: [signedInGuard, profileExistsGuard]),
        AutoRoute(page: ProfileHivStatusRoute.page, path: '/registration/profile/hiv-status', guards: [signedInGuard, profileExistsGuard]),
        AutoRoute(page: ProfileDisplayNameEntryRoute.page, path: '/profile/setup/display-name', guards: [signedInGuard, profileExistsGuard]),
        AutoRoute(page: ProfileBirthdayEntryRoute.page, path: '/profile/setup/birthday', guards: [signedInGuard, profileExistsGuard]),
        AutoRoute(page: ProfileGenderSelectRoute.page, path: '/profile/setup/gender', guards: [signedInGuard, profileExistsGuard]),
        AutoRoute(page: ProfileInterestsEntryRoute.page, path: '/profile/setup/interests', guards: [signedInGuard, profileExistsGuard]),
        AutoRoute(page: ProfileLocationRoute.page, path: '/profile/setup/map-location', guards: [signedInGuard, profileExistsGuard]),
        AutoRoute(page: ProfileReferenceImageWelcomeRoute.page, path: '/profile/setup/location', guards: [signedInGuard, profileExistsGuard]),
        AutoRoute(page: ProfileReferenceImageRoute.page, path: '/profile/setup/images/references', guards: [signedInGuard, profileExistsGuard]),
        AutoRoute(page: ProfileReferenceImageSuccessRoute.page, path: '/profile/setup/images/references/success', guards: [signedInGuard, profileExistsGuard]),
        AutoRoute(page: ProfilePhotoRoute.page, path: '/profile/setup/images/profile', guards: [signedInGuard, profileExistsGuard]),
        AutoRoute(page: ProfileBiographyEntryRoute.page, path: '/profile/setup/biography', guards: [signedInGuard, profileExistsGuard]),
        AutoRoute(page: ProfileAboutRoute.page, path: '/profile/about', guards: [signedInGuard, profileExistsGuard]),
        //* Home and direct affiliates
        AutoRoute(page: HomeRoute.page, path: '/home', guards: kCommonGuards),
        AutoRoute(page: SearchRoute.page, path: '/search', guards: [...kCommonGuards, signedInGuard]),
        AutoRoute(page: ChatCreateRoute.page, path: '/chat/new', guards: [...kCommonGuards, signedInGuard]),
        AutoRoute(page: ChatConversationsRoute.page, path: '/chat/conversations', guards: [...kCommonGuards, signedInGuard]),
        AutoRoute(page: ChatRoute.page, path: '/chat/current', guards: [...kCommonGuards, signedInGuard]),
        //* Account
        AutoRoute(page: AccountRoute.page, path: '/account', guards: [...kCommonGuards, signedInGuard]),
        AutoRoute(page: AccountDetailsRoute.page, path: '/account/details', guards: [...kCommonGuards, signedInGuard]),
        AutoRoute(page: AccountUpdateEmailAddressRoute.page, path: '/account/update/email', guards: [...kCommonGuards, signedInGuard]),
        AutoRoute(page: AccountUpdatePhoneNumberRoute.page, path: '/account/update/phone', guards: [...kCommonGuards, signedInGuard]),
        AutoRoute(page: AccountUpdatePasswordRoute.page, path: '/account/update/password', guards: [...kCommonGuards, signedInGuard]),
        AutoRoute(page: AccountDeleteProfileRoute.page, path: '/account/delete', guards: [...kCommonGuards, signedInGuard]),
        AutoRoute(page: AccountVerificationRoute.page, path: '/account/verification'),
        AutoRoute(page: AccountUpdatedRoute.page, path: '/account/update/complete'),
        AutoRoute(page: AccountProfileEditSettingsRoute.page, path: '/account/profile', guards: [signedInGuard, profileExistsGuard]),
        AutoRoute(page: ProfileEditThanksRoute.page, path: '/account/profile/thanks', guards: [signedInGuard]),
        AutoRoute(page: AccountPreferencesRoute.page, path: '/account/preferences', guards: [...kCommonGuards, signedInGuard]),
        //* Notifications
        AutoRoute(page: NotificationsRoute.page, path: '/notifications', guards: [...kCommonGuards, signedInGuard]),
        //* Guidance
        AutoRoute(page: GuidanceRoute.page, path: '/guidance', guards: [...kCommonGuards, signedInGuard]),
        // * Dialogs
        AutoRoute(page: TermsAndConditionsRoute.page, path: '/terms'),
        AutoRoute(page: HintDialogRoute.page, path: '/help/dialog'),
        //* Other
        AutoRoute(page: ErrorRoute.page, path: '/error'),
        AutoRoute(page: DevelopmentRoute.page, path: '/devtools', guards: [developmentGuard]),
        RedirectRoute(path: '*', redirectTo: '/'),
      ];
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
