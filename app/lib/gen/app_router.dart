// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/guards/biometrics_guard.dart';
import 'package:app/guards/organisation_setup_guard.dart';
import 'package:app/guards/profile_display_guard.dart';
import 'package:app/guards/security_guard.dart';
import 'package:app/widgets/organisms/account/account_communities_page.dart';
import 'package:app/widgets/organisms/account/account_connect_email_page.dart';
import 'package:app/widgets/organisms/account/account_promoted_posts_page.dart';
import 'package:app/widgets/organisms/account/account_promoted_posts_promotion_page.dart';
import 'package:app/widgets/organisms/account/account_social_disconnection_page.dart';
import 'package:app/widgets/organisms/account/account_update_email_address_page.dart';
import 'package:app/widgets/organisms/account/account_update_name_page.dart';
import 'package:app/widgets/organisms/biometrics/biometrics_preferences_page.dart';
import 'package:app/widgets/organisms/chat/chat_members_page.dart';
import 'package:app/widgets/organisms/chat/chat_page.dart';
import 'package:app/widgets/organisms/chat/create_conversation_page.dart';
import 'package:app/widgets/organisms/dialogs/verification_dialog_page.dart';
import 'package:app/widgets/organisms/error/error_page.dart';
import 'package:app/widgets/organisms/gallery/media_page.dart';
import 'package:app/widgets/organisms/guidance/guidance_entry_page.dart';
import 'package:app/widgets/organisms/home/home_login_prompt_page.dart';
import 'package:app/widgets/organisms/home/home_page.dart';
import 'package:app/widgets/organisms/login/login_account_recovery_page.dart';
import 'package:app/widgets/organisms/onboarding/onboarding_welcome_page.dart';
import 'package:app/widgets/organisms/post/post_page.dart';
import 'package:app/widgets/organisms/post/post_reactions_page.dart';
import 'package:app/widgets/organisms/post/post_share_page.dart';
import 'package:app/widgets/organisms/post/vms/create_post_data_structures.dart';
import 'package:app/widgets/organisms/profile/views/organisation_setup/organisation_company_sectors_select_page.dart';
import 'package:app/widgets/organisms/profile/views/organisation_setup/organisation_name_setup_page.dart';
import 'package:app/widgets/organisms/profile/views/profile_about_page.dart';
import 'package:app/widgets/organisms/profile/views/profile_details_page.dart';
import 'package:app/widgets/organisms/profile/views/profile_page.dart';
import 'package:app/widgets/organisms/profile/views/profile_setup/profile_accent_photo_page.dart';
import 'package:app/widgets/organisms/profile/views/profile_setup/profile_biography_entry_page.dart';
import 'package:app/widgets/organisms/profile/views/profile_setup/profile_birthday_delete_account_page.dart';
import 'package:app/widgets/organisms/profile/views/profile_setup/profile_birthday_entry_page.dart';
import 'package:app/widgets/organisms/profile/views/profile_setup/profile_display_name_entry_page.dart';
import 'package:app/widgets/organisms/profile/views/profile_setup/profile_edit_thanks_page.dart';
import 'package:app/widgets/organisms/profile/views/profile_setup/profile_gender_select_page.dart';
import 'package:app/widgets/organisms/profile/views/profile_setup/profile_hiv_status_page.dart';
import 'package:app/widgets/organisms/profile/views/profile_setup/profile_interests_entry_page.dart';
import 'package:app/widgets/organisms/profile/views/profile_setup/profile_location_page.dart';
import 'package:app/widgets/organisms/profile/views/profile_setup/profile_name_entry_page.dart';
import 'package:app/widgets/organisms/profile/views/profile_setup/profile_photo_selection_page.dart';
import 'package:app/widgets/organisms/profile/views/profile_setup/profile_reference_image_camera_page.dart';
import 'package:app/widgets/organisms/profile/views/profile_setup/profile_reference_image_success_page.dart';
import 'package:app/widgets/organisms/profile/views/profile_setup/profile_reference_image_welcome_page.dart';
import 'package:app/widgets/organisms/profile/views/profile_welcome_back_page.dart';
import 'package:app/widgets/organisms/registration/registration_complete_page.dart';
import 'package:app/widgets/organisms/registration/registration_email_entry_page.dart';
import 'package:app/widgets/organisms/search/vms/search_view_model.dart';
import 'package:app/widgets/organisms/shared/tag_feed_page.dart';
import 'package:app/widgets/organisms/terms_and_conditions/terms_and_conditions_page.dart';
import '../guards/auth_setup_guard.dart';
import '../guards/notification_guard.dart';
import '../guards/pledge_guard.dart';
import '../guards/profile_setup_guard.dart';
import '../guards/signed_in_guard.dart';
import '../guards/signed_out_guard.dart';
import '../guards/splash_guard.dart';
import '../widgets/animations/positive_page_animation.dart';
import '../widgets/organisms/account/account_confirm_password_page.dart';
import '../widgets/organisms/account/account_connect_social_page.dart';
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
import '../widgets/organisms/guidance/guidance_directory_entry_page.dart';
import '../widgets/organisms/guidance/guidance_directory_page.dart';
import '../widgets/organisms/guidance/guidance_page.dart';
import '../widgets/organisms/home/chat_conversations_page.dart';
import '../widgets/organisms/login/forgotten_password_page.dart';
import '../widgets/organisms/login/forgotten_password_recovery_page.dart';
import '../widgets/organisms/login/login_page.dart';
import '../widgets/organisms/login/login_password_page.dart';
import '../widgets/organisms/login/login_welcome_back_page.dart';
import '../widgets/organisms/notifications/notification_preferences_page.dart';
import '../widgets/organisms/notifications/notifications_page.dart';
import '../widgets/organisms/onboarding/onboarding_our_pledge_page.dart';
import '../widgets/organisms/onboarding/onboarding_your_pledge_page.dart';
import '../widgets/organisms/post/create_post_page.dart';
import '../widgets/organisms/registration/registration_account_page.dart';
import '../widgets/organisms/registration/registration_account_setup_page.dart';
import '../widgets/organisms/registration/registration_password_entry_page.dart';
import '../widgets/organisms/registration/registration_phone_entry_page.dart';
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
  final AuthSetupGuard authSetupGuard = AuthSetupGuard();
  final PledgeGuard pledgeGuard = PledgeGuard();
  final NotificationGuard notificationGuard = NotificationGuard();
  final BiometricsGuard biometricsGuard = BiometricsGuard();
  final ProfileSetupGuard profileSetupGuard = ProfileSetupGuard();
  final OrganisationSetupGuard organisationSetupGuard = OrganisationSetupGuard();
  final ProfileDisplayGuard profileDisplayGuard = ProfileDisplayGuard();
  final SplashGuard splashGuard = SplashGuard();
  final SecurityGuard securityGuard = SecurityGuard();

  List<AutoRouteGuard> get kCommonGuards => [
        pledgeGuard,
        authSetupGuard,
        notificationGuard,
        biometricsGuard,
        securityGuard,
      ];

  @override
  RouteType get defaultRouteType => const CupertinoRouteType();

  @override
  List<AutoRoute> get routes => [
        // //* Onboarding and splash
        CustomRoute(page: SplashRoute.page, guards: [splashGuard], path: '/', transitionsBuilder: CircularClipRoute.clipRoute),
        CustomRoute(page: OnboardingWelcomeRoute.page, path: '/onboarding/welcome', transitionsBuilder: CircularClipRoute.clipRoute),
        AutoRoute(page: OnboardingOurPledgeRoute.page, path: '/onboarding/our-pledge'),
        AutoRoute(page: OnboardingYourPledgeRoute.page, path: '/onboarding/your-pledge'),
        //* Registration and Onboarding
        AutoRoute(page: RegistrationAccountRoute.page, path: '/registration/account'),
        AutoRoute(page: RegistrationEmailEntryRoute.page, path: '/registration/create/email'),
        AutoRoute(page: RegistrationPasswordEntryRoute.page, path: '/registration/create/password'),
        AutoRoute(page: RegistrationPhoneEntryRoute.page, path: '/registration/create/phone'),
        AutoRoute(page: RegistrationAccountSetupRoute.page, path: '/registration/profile/start'),
        AutoRoute(page: RegistrationCompleteRoute.page, path: '/registration/profile/complete'),
        //* Login and Authentication
        AutoRoute(page: LoginRoute.page, path: '/login', guards: [signedOutGuard]),
        AutoRoute(page: LoginPasswordRoute.page, path: '/login/password', guards: [signedOutGuard]),
        AutoRoute(page: LoginWelcomeBackRoute.page, path: '/login/success'),
        AutoRoute(page: LoginAccountRecoveryRoute.page, path: '/login/recovery'),
        AutoRoute(page: ForgottenPasswordRoute.page, path: '/login/password-forgotten', guards: [signedOutGuard]),
        AutoRoute(page: ForgottenPasswordRecoveryRoute.page, path: '/login/password-forgotten-recovery', guards: [signedOutGuard]),
        //* User Preferences Configuration
        AutoRoute(page: NotificationPreferencesRoute.page, path: '/notifications'),
        AutoRoute(page: BiometricsPreferencesRoute.page, path: '/biometrics'),
        //* Organisation Setup
        AutoRoute(page: OrganisationNameSetupRoute.page, path: '/organisation/setup/name', guards: [signedInGuard]),
        AutoRoute(page: OrganisationCompanySectorSelectRoute.page, path: '/organisation/setup/sectors', guards: [signedInGuard]),
        //* Profile Setup
        AutoRoute(page: ProfileWelcomeBackRoute.page, path: '/profile/setup/continue', guards: [signedInGuard]),
        AutoRoute(page: ProfileNameEntryRoute.page, path: '/profile/setup/name', guards: [signedInGuard]),
        AutoRoute(page: ProfileHivStatusRoute.page, path: '/registration/profile/hiv-status', guards: [signedInGuard]),
        AutoRoute(page: ProfileDisplayNameEntryRoute.page, path: '/profile/setup/display-name', guards: [signedInGuard]),
        AutoRoute(page: ProfileBirthdayEntryRoute.page, path: '/profile/setup/birthday', guards: [signedInGuard]),
        AutoRoute(page: ProfileBirthdayDeleteAccountRoute.page, path: '/profile/setup/delete', guards: [signedInGuard]),
        AutoRoute(page: ProfileGenderSelectRoute.page, path: '/profile/setup/gender', guards: [signedInGuard]),
        AutoRoute(page: ProfileInterestsEntryRoute.page, path: '/profile/setup/interests', guards: [signedInGuard]),
        AutoRoute(page: ProfileLocationRoute.page, path: '/profile/setup/map-location', guards: [signedInGuard]),
        AutoRoute(page: ProfileReferenceImageWelcomeRoute.page, path: '/profile/setup/references/start', guards: [signedInGuard]),
        AutoRoute(page: ProfileReferenceImageCameraRoute.page, path: '/profile/setup/references/camera', guards: [signedInGuard]),
        AutoRoute(page: ProfileReferenceImageSuccessRoute.page, path: '/profile/setup/images/references/success', guards: [signedInGuard]),
        AutoRoute(page: ProfileAccentPhotoRoute.page, path: '/profile/setup/accent', guards: [signedInGuard]),
        AutoRoute(page: ProfilePhotoSelectionRoute.page, path: '/profile/setup/images/profile', guards: [signedInGuard]),
        AutoRoute(page: ProfileBiographyEntryRoute.page, path: '/profile/setup/biography', guards: [signedInGuard]),
        AutoRoute(page: ProfileEditThanksRoute.page, path: '/profile/setup/thanks', guards: kCommonGuards),
        //* Profile
        AutoRoute(page: ProfileRoute.page, path: '/profile/view', guards: [profileDisplayGuard]),
        AutoRoute(page: ProfileDetailsRoute.page, path: '/profile/details/view', guards: [profileDisplayGuard]),
        AutoRoute(page: ProfileAboutRoute.page, path: '/profile/about', guards: [signedInGuard]),
        //* Home and direct affiliates
        AutoRoute(page: HomeRoute.page, path: '/home', guards: [pledgeGuard, authSetupGuard, profileSetupGuard, organisationSetupGuard, notificationGuard, biometricsGuard, securityGuard]),
        AutoRoute(page: HomeLoginPromptRoute.page, path: '/home/login', guards: [...kCommonGuards]),
        AutoRoute(page: SearchRoute.page, path: '/search', guards: kCommonGuards),
        AutoRoute(page: ChatConversationsRoute.page, path: '/chat/conversations', guards: kCommonGuards),
        AutoRoute(page: CreateConversationRoute.page, path: '/chat/connections_list', guards: [...kCommonGuards, signedInGuard]),
        AutoRoute(page: ChatMembersRoute.page, path: '/chat/members', guards: kCommonGuards),
        AutoRoute(page: ChatRoute.page, path: '/chat/current', guards: kCommonGuards),
        //* Account
        AutoRoute(page: AccountRoute.page, path: '/account', guards: kCommonGuards),
        AutoRoute(page: AccountDetailsRoute.page, path: '/account/details', guards: kCommonGuards),
        AutoRoute(page: AccountCommunitiesRoute.page, path: '/account/communities', guards: kCommonGuards),
        AutoRoute(page: AccountUpdateNameRoute.page, path: '/account/update/name', guards: kCommonGuards),
        AutoRoute(page: AccountUpdateEmailAddressRoute.page, path: '/account/update/email', guards: kCommonGuards),
        AutoRoute(page: AccountUpdatePhoneNumberRoute.page, path: '/account/update/phone', guards: kCommonGuards),
        AutoRoute(page: AccountUpdatePasswordRoute.page, path: '/account/update/password', guards: kCommonGuards),
        AutoRoute(page: AccountConfirmPasswordRoute.page, path: '/account/confirm/password', guards: kCommonGuards),
        AutoRoute(page: AccountConnectEmailRoute.page, path: '/account/connect/email', guards: kCommonGuards),
        AutoRoute(page: AccountSocialDisconnectionRoute.page, path: '/account/connect/email/social', guards: kCommonGuards),
        AutoRoute(page: AccountDeleteProfileRoute.page, path: '/account/delete', guards: kCommonGuards),
        AutoRoute(page: AccountUpdatedRoute.page, path: '/account/update/complete', guards: kCommonGuards),
        AutoRoute(page: AccountProfileEditSettingsRoute.page, path: '/account/profile', guards: kCommonGuards),
        AutoRoute(page: AccountPreferencesRoute.page, path: '/account/preferences', guards: kCommonGuards),
        AutoRoute(page: AccountConnectSocialRoute.page, path: '/account/connect/social', guards: kCommonGuards),
        AutoRoute(page: AccountPromotedPostsRoute.page, path: '/account/posts/promoted_posts', guards: kCommonGuards),
        AutoRoute(page: AccountPromotedPostsPromotionRoute.page, path: '/account/posts/promoted_promotion', guards: kCommonGuards),
        //* Notifications
        AutoRoute(page: NotificationsRoute.page, path: '/notifications', guards: kCommonGuards),
        //* Guidance
        AutoRoute(page: GuidanceRoute.page, path: '/guidance', guards: kCommonGuards),
        AutoRoute(page: GuidanceDirectoryRoute.page, path: '/guidance/directory', guards: kCommonGuards),
        AutoRoute(page: GuidanceDirectoryEntryRoute.page, path: '/guidance/directory/:id', guards: kCommonGuards),
        AutoRoute(page: GuidanceEntryRoute.page, path: '/guidance/:id', guards: kCommonGuards),
        //* Content
        AutoRoute(page: MediaRoute.page, path: '/media', guards: kCommonGuards),
        AutoRoute(page: PostRoute.page, path: '/post'),
        AutoRoute(page: PostReactionsRoute.page, path: '/post/reactions'),
        AutoRoute(page: TagFeedRoute.page, path: '/tag/:tag', guards: kCommonGuards),
        AutoRoute(page: CreatePostRoute.page, path: '/post/create', guards: [...kCommonGuards, signedInGuard]),
        AutoRoute(page: PostShareRoute.page, path: '/post/share'),
        //* Dialogs
        AutoRoute(page: TermsAndConditionsRoute.page, path: '/terms'),
        AutoRoute(page: HintDialogRoute.page, path: '/help/dialog'),
        AutoRoute(page: VerificationDialogRoute.page, path: '/verification/dialog'),
        //* Other
        AutoRoute(page: ErrorRoute.page, path: '/error'),
        AutoRoute(page: DevelopmentRoute.page, path: '/devtools'),
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
