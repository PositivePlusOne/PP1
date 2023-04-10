// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'app_router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter({
    GlobalKey<NavigatorState>? navigatorKey,
    required this.splashGuard,
    required this.signedOutGuard,
    required this.signedInGuard,
    required this.profileExistsGuard,
    required this.pledgeGuard,
    required this.authProviderGuard,
    required this.notificationGuard,
    required this.biometricsGuard,
    required this.profileSetupGuard,
    required this.developmentGuard,
  }) : super(navigatorKey);

  final SplashGuard splashGuard;

  final SignedOutGuard signedOutGuard;

  final SignedInGuard signedInGuard;

  final ProfileExistsGuard profileExistsGuard;

  final PledgeGuard pledgeGuard;

  final AuthProviderGuard authProviderGuard;

  final NotificationGuard notificationGuard;

  final BiometricsGuard biometricsGuard;

  final ProfileSetupGuard profileSetupGuard;

  final DevelopmentGuard developmentGuard;

  @override
  final Map<String, PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      final args = routeData.argsAs<SplashRouteArgs>(orElse: () => const SplashRouteArgs());
      return CustomPage<dynamic>(
        routeData: routeData,
        child: SplashPage(
          key: args.key,
          style: args.style,
        ),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    OnboardingWelcomeRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const OnboardingWelcomePage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    OnboardingConnectRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const OnboardingConnectPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    OnboardingEducationRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const OnboardingEducationPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    OnboardingGuidanceRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const OnboardingGuidancePage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    OnboardingOurPledgeRoute.name: (routeData) {
      final args = routeData.argsAs<OnboardingOurPledgeRouteArgs>(orElse: () => const OnboardingOurPledgeRouteArgs());
      return CustomPage<dynamic>(
        routeData: routeData,
        child: OnboardingOurPledgePage(
          style: args.style,
          key: args.key,
        ),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    OnboardingYourPledgeRoute.name: (routeData) {
      final args = routeData.argsAs<OnboardingYourPledgeRouteArgs>(orElse: () => const OnboardingYourPledgeRouteArgs());
      return CustomPage<dynamic>(
        routeData: routeData,
        child: OnboardingYourPledgePage(
          style: args.style,
          key: args.key,
        ),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    RegistrationAccountRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const RegistrationAccountPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    RegistrationEmailEntryRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const RegistrationEmailEntryPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    RegistrationPasswordEntryRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const RegistrationPasswordEntryPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    RegistrationPhoneEntryRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const RegistrationPhoneEntryPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    RegistrationPhoneVerificationRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const RegistrationPhoneVerificationPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    RegistrationAccountSetupRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const RegistrationAccountSetupPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>();
      return CustomPage<dynamic>(
        routeData: routeData,
        child: LoginPage(
          key: args.key,
          senderRoute: args.senderRoute,
        ),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    LoginPasswordRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const LoginPasswordPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    LoginWelcomeBackRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const LoginWelcomeBackPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    NotificationPreferencesRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const NotificationPreferencesPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    BiometricsPreferencesRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const BiometricsPreferencesPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProfileRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileRouteArgs>();
      return CustomPage<dynamic>(
        routeData: routeData,
        child: ProfilePage(
          userId: args.userId,
          key: args.key,
        ),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProfileWelcomeBackRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileWelcomeBackRouteArgs>();
      return CustomPage<dynamic>(
        routeData: routeData,
        child: ProfileWelcomeBackPage(
          nextPage: args.nextPage,
          key: args.key,
        ),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProfileNameEntryRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const ProfileNameEntryPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProfileHivStatusRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const ProfileHivStatusPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProfileDisplayNameEntryRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const ProfileDisplayNameEntryPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProfileBirthdayEntryRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const ProfileBirthdayEntryPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProfileGenderSelectRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const ProfileGenderSelectPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProfileInterestsEntryRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const ProfileInterestsEntryPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProfileImageWelcomeRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const ProfileImageWelcomePage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProfileImageRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const ProfileImagePage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProfileImageSuccessRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const ProfileImageSuccessPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProfileImageDialogRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const ProfileImageDialogPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    HomeRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const HomePage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    SearchRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const SearchPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ChatListRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(child: const ChatListPage()),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ChatRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(child: const ChatPage()),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    AccountRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const AccountPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    AccountDetailsRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const AccountDetailsPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    AccountUpdateEmailAddressRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const AccountUpdateEmailAddressPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    AccountUpdatePhoneNumberRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const AccountUpdatePhoneNumberPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    AccountUpdatePasswordRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const AccountUpdatePasswordPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    AccountDeleteProfileRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const AccountDeleteProfilePage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    AccountVerificationRoute.name: (routeData) {
      final args = routeData.argsAs<AccountVerificationRouteArgs>();
      return CustomPage<dynamic>(
        routeData: routeData,
        child: AccountVerificationPage(
          title: args.title,
          body: args.body,
          onVerificationSuccess: args.onVerificationSuccess,
          buttonText: args.buttonText,
          key: args.key,
        ),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    AccountUpdatedRoute.name: (routeData) {
      final args = routeData.argsAs<AccountUpdatedRouteArgs>();
      return CustomPage<dynamic>(
        routeData: routeData,
        child: AccountUpdatedPage(
          body: args.body,
          title: args.title,
          buttonText: args.buttonText,
          onContinueSelected: args.onContinueSelected,
          key: args.key,
        ),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProfileEditSettingsRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const ProfileEditSettingsPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    AccountPreferencesRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const AccountPreferencesPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    GuidanceRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const GuidancePage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    TermsAndConditionsRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const TermsAndConditionsPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    HintDialogRoute.name: (routeData) {
      final args = routeData.argsAs<HintDialogRouteArgs>();
      return CustomPage<dynamic>(
        routeData: routeData,
        child: HintDialogPage(
          key: args.key,
          widgets: args.widgets,
        ),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ErrorRoute.name: (routeData) {
      final args = routeData.argsAs<ErrorRouteArgs>();
      return CustomPage<dynamic>(
        routeData: routeData,
        child: ErrorPage(
          errorMessage: args.errorMessage,
          key: args.key,
        ),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
    DevelopmentRoute.name: (routeData) {
      return CustomPage<dynamic>(
        routeData: routeData,
        child: const DevelopmentPage(),
        transitionsBuilder: PositivePageAnimation.radialTransitionBuilder,
        durationInMilliseconds: 1000,
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(
          SplashRoute.name,
          path: '/',
          guards: [splashGuard],
        ),
        RouteConfig(
          OnboardingWelcomeRoute.name,
          path: '/onboarding/welcome',
        ),
        RouteConfig(
          OnboardingConnectRoute.name,
          path: '/onboarding/connect',
        ),
        RouteConfig(
          OnboardingEducationRoute.name,
          path: '/onboarding/education',
        ),
        RouteConfig(
          OnboardingGuidanceRoute.name,
          path: '/onboarding/guidance',
        ),
        RouteConfig(
          OnboardingOurPledgeRoute.name,
          path: '/onboarding/our-pledge',
        ),
        RouteConfig(
          OnboardingYourPledgeRoute.name,
          path: '/onboarding/your-pledge',
        ),
        RouteConfig(
          RegistrationAccountRoute.name,
          path: '/registration/account',
        ),
        RouteConfig(
          RegistrationEmailEntryRoute.name,
          path: '/registration/create/email',
        ),
        RouteConfig(
          RegistrationPasswordEntryRoute.name,
          path: '/registration/create/password',
        ),
        RouteConfig(
          RegistrationPhoneEntryRoute.name,
          path: '/registration/create/phone',
        ),
        RouteConfig(
          RegistrationPhoneVerificationRoute.name,
          path: '/registration/create/phone/verify',
        ),
        RouteConfig(
          RegistrationAccountSetupRoute.name,
          path: '/registration/profile/start',
        ),
        RouteConfig(
          LoginRoute.name,
          path: '/login',
          guards: [signedOutGuard],
        ),
        RouteConfig(
          LoginPasswordRoute.name,
          path: '/login/password',
          guards: [signedOutGuard],
        ),
        RouteConfig(
          LoginWelcomeBackRoute.name,
          path: '/login/success',
        ),
        RouteConfig(
          NotificationPreferencesRoute.name,
          path: '/notifications',
        ),
        RouteConfig(
          BiometricsPreferencesRoute.name,
          path: '/biometrics',
        ),
        RouteConfig(
          ProfileRoute.name,
          path: '/profile/view/:userId',
          guards: [
            signedInGuard,
            profileExistsGuard,
          ],
        ),
        RouteConfig(
          ProfileWelcomeBackRoute.name,
          path: '/profile/setup/continue',
        ),
        RouteConfig(
          ProfileNameEntryRoute.name,
          path: '/profile/setup/name',
          guards: [
            signedInGuard,
            profileExistsGuard,
          ],
        ),
        RouteConfig(
          ProfileHivStatusRoute.name,
          path: '/registration/profile/hiv-status',
          guards: [
            signedInGuard,
            profileExistsGuard,
          ],
        ),
        RouteConfig(
          ProfileDisplayNameEntryRoute.name,
          path: '/profile/setup/display-name',
          guards: [
            signedInGuard,
            profileExistsGuard,
          ],
        ),
        RouteConfig(
          ProfileBirthdayEntryRoute.name,
          path: '/profile/setup/birthday',
          guards: [
            signedInGuard,
            profileExistsGuard,
          ],
        ),
        RouteConfig(
          ProfileGenderSelectRoute.name,
          path: '/profile/setup/gender',
          guards: [
            signedInGuard,
            profileExistsGuard,
          ],
        ),
        RouteConfig(
          ProfileInterestsEntryRoute.name,
          path: '/profile/setup/interests',
          guards: [
            signedInGuard,
            profileExistsGuard,
          ],
        ),
        RouteConfig(
          ProfileImageWelcomeRoute.name,
          path: '/profile/setup/image/welcome',
          guards: [
            signedInGuard,
            profileExistsGuard,
          ],
        ),
        RouteConfig(
          ProfileImageRoute.name,
          path: '/profile/setup/image',
          guards: [
            signedInGuard,
            profileExistsGuard,
          ],
        ),
        RouteConfig(
          ProfileImageSuccessRoute.name,
          path: '/profile/setup/image/success',
          guards: [
            signedInGuard,
            profileExistsGuard,
          ],
        ),
        RouteConfig(
          ProfileImageDialogRoute.name,
          path: '/profile/setup/image/help',
          guards: [
            signedInGuard,
            profileExistsGuard,
          ],
        ),
        RouteConfig(
          HomeRoute.name,
          path: '/home',
          guards: [
            pledgeGuard,
            authProviderGuard,
            notificationGuard,
            biometricsGuard,
            profileSetupGuard,
          ],
        ),
        RouteConfig(
          SearchRoute.name,
          path: '/search',
          guards: [
            pledgeGuard,
            authProviderGuard,
            notificationGuard,
            biometricsGuard,
            profileSetupGuard,
            signedInGuard,
          ],
        ),
        RouteConfig(
          ChatListRoute.name,
          path: '/chat/list',
          guards: [
            pledgeGuard,
            authProviderGuard,
            notificationGuard,
            biometricsGuard,
            profileSetupGuard,
            signedInGuard,
          ],
        ),
        RouteConfig(
          ChatRoute.name,
          path: '/chat/current',
          guards: [
            pledgeGuard,
            authProviderGuard,
            notificationGuard,
            biometricsGuard,
            profileSetupGuard,
            signedInGuard,
          ],
        ),
        RouteConfig(
          AccountRoute.name,
          path: '/account',
          guards: [
            pledgeGuard,
            authProviderGuard,
            notificationGuard,
            biometricsGuard,
            profileSetupGuard,
            signedInGuard,
          ],
        ),
        RouteConfig(
          AccountDetailsRoute.name,
          path: '/account/details',
          guards: [
            pledgeGuard,
            authProviderGuard,
            notificationGuard,
            biometricsGuard,
            profileSetupGuard,
            signedInGuard,
          ],
        ),
        RouteConfig(
          AccountUpdateEmailAddressRoute.name,
          path: '/account/update/email',
          guards: [
            pledgeGuard,
            authProviderGuard,
            notificationGuard,
            biometricsGuard,
            profileSetupGuard,
            signedInGuard,
          ],
        ),
        RouteConfig(
          AccountUpdatePhoneNumberRoute.name,
          path: '/account/update/phone',
          guards: [
            pledgeGuard,
            authProviderGuard,
            notificationGuard,
            biometricsGuard,
            profileSetupGuard,
            signedInGuard,
          ],
        ),
        RouteConfig(
          AccountUpdatePasswordRoute.name,
          path: '/account/update/password',
          guards: [
            pledgeGuard,
            authProviderGuard,
            notificationGuard,
            biometricsGuard,
            profileSetupGuard,
            signedInGuard,
          ],
        ),
        RouteConfig(
          AccountDeleteProfileRoute.name,
          path: '/account/delete',
          guards: [
            pledgeGuard,
            authProviderGuard,
            notificationGuard,
            biometricsGuard,
            profileSetupGuard,
            signedInGuard,
          ],
        ),
        RouteConfig(
          AccountVerificationRoute.name,
          path: '/account/verification',
        ),
        RouteConfig(
          AccountUpdatedRoute.name,
          path: '/account/update/complete',
        ),
        RouteConfig(
          ProfileEditSettingsRoute.name,
          path: '/account/profile',
          guards: [
            signedInGuard,
            profileExistsGuard,
          ],
        ),
        RouteConfig(
          AccountPreferencesRoute.name,
          path: '/account/preferences',
          guards: [
            pledgeGuard,
            authProviderGuard,
            notificationGuard,
            biometricsGuard,
            profileSetupGuard,
            signedInGuard,
          ],
        ),
        RouteConfig(
          GuidanceRoute.name,
          path: '/guidance',
          guards: [
            pledgeGuard,
            authProviderGuard,
            notificationGuard,
            biometricsGuard,
            profileSetupGuard,
            signedInGuard,
          ],
        ),
        RouteConfig(
          TermsAndConditionsRoute.name,
          path: '/terms',
        ),
        RouteConfig(
          HintDialogRoute.name,
          path: '/help/dialog',
        ),
        RouteConfig(
          ErrorRoute.name,
          path: '/error',
        ),
        RouteConfig(
          DevelopmentRoute.name,
          path: '/devtools',
          guards: [developmentGuard],
        ),
        RouteConfig(
          '*#redirect',
          path: '*',
          redirectTo: '/',
          fullMatch: true,
        ),
      ];
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<SplashRouteArgs> {
  SplashRoute({
    Key? key,
    SplashStyle style = SplashStyle.embracePositivity,
  }) : super(
          SplashRoute.name,
          path: '/',
          args: SplashRouteArgs(
            key: key,
            style: style,
          ),
        );

  static const String name = 'SplashRoute';
}

class SplashRouteArgs {
  const SplashRouteArgs({
    this.key,
    this.style = SplashStyle.embracePositivity,
  });

  final Key? key;

  final SplashStyle style;

  @override
  String toString() {
    return 'SplashRouteArgs{key: $key, style: $style}';
  }
}

/// generated route for
/// [OnboardingWelcomePage]
class OnboardingWelcomeRoute extends PageRouteInfo<void> {
  const OnboardingWelcomeRoute()
      : super(
          OnboardingWelcomeRoute.name,
          path: '/onboarding/welcome',
        );

  static const String name = 'OnboardingWelcomeRoute';
}

/// generated route for
/// [OnboardingConnectPage]
class OnboardingConnectRoute extends PageRouteInfo<void> {
  const OnboardingConnectRoute()
      : super(
          OnboardingConnectRoute.name,
          path: '/onboarding/connect',
        );

  static const String name = 'OnboardingConnectRoute';
}

/// generated route for
/// [OnboardingEducationPage]
class OnboardingEducationRoute extends PageRouteInfo<void> {
  const OnboardingEducationRoute()
      : super(
          OnboardingEducationRoute.name,
          path: '/onboarding/education',
        );

  static const String name = 'OnboardingEducationRoute';
}

/// generated route for
/// [OnboardingGuidancePage]
class OnboardingGuidanceRoute extends PageRouteInfo<void> {
  const OnboardingGuidanceRoute()
      : super(
          OnboardingGuidanceRoute.name,
          path: '/onboarding/guidance',
        );

  static const String name = 'OnboardingGuidanceRoute';
}

/// generated route for
/// [OnboardingOurPledgePage]
class OnboardingOurPledgeRoute extends PageRouteInfo<OnboardingOurPledgeRouteArgs> {
  OnboardingOurPledgeRoute({
    OnboardingStyle style = OnboardingStyle.home,
    Key? key,
  }) : super(
          OnboardingOurPledgeRoute.name,
          path: '/onboarding/our-pledge',
          args: OnboardingOurPledgeRouteArgs(
            style: style,
            key: key,
          ),
        );

  static const String name = 'OnboardingOurPledgeRoute';
}

class OnboardingOurPledgeRouteArgs {
  const OnboardingOurPledgeRouteArgs({
    this.style = OnboardingStyle.home,
    this.key,
  });

  final OnboardingStyle style;

  final Key? key;

  @override
  String toString() {
    return 'OnboardingOurPledgeRouteArgs{style: $style, key: $key}';
  }
}

/// generated route for
/// [OnboardingYourPledgePage]
class OnboardingYourPledgeRoute extends PageRouteInfo<OnboardingYourPledgeRouteArgs> {
  OnboardingYourPledgeRoute({
    OnboardingStyle style = OnboardingStyle.home,
    Key? key,
  }) : super(
          OnboardingYourPledgeRoute.name,
          path: '/onboarding/your-pledge',
          args: OnboardingYourPledgeRouteArgs(
            style: style,
            key: key,
          ),
        );

  static const String name = 'OnboardingYourPledgeRoute';
}

class OnboardingYourPledgeRouteArgs {
  const OnboardingYourPledgeRouteArgs({
    this.style = OnboardingStyle.home,
    this.key,
  });

  final OnboardingStyle style;

  final Key? key;

  @override
  String toString() {
    return 'OnboardingYourPledgeRouteArgs{style: $style, key: $key}';
  }
}

/// generated route for
/// [RegistrationAccountPage]
class RegistrationAccountRoute extends PageRouteInfo<void> {
  const RegistrationAccountRoute()
      : super(
          RegistrationAccountRoute.name,
          path: '/registration/account',
        );

  static const String name = 'RegistrationAccountRoute';
}

/// generated route for
/// [RegistrationEmailEntryPage]
class RegistrationEmailEntryRoute extends PageRouteInfo<void> {
  const RegistrationEmailEntryRoute()
      : super(
          RegistrationEmailEntryRoute.name,
          path: '/registration/create/email',
        );

  static const String name = 'RegistrationEmailEntryRoute';
}

/// generated route for
/// [RegistrationPasswordEntryPage]
class RegistrationPasswordEntryRoute extends PageRouteInfo<void> {
  const RegistrationPasswordEntryRoute()
      : super(
          RegistrationPasswordEntryRoute.name,
          path: '/registration/create/password',
        );

  static const String name = 'RegistrationPasswordEntryRoute';
}

/// generated route for
/// [RegistrationPhoneEntryPage]
class RegistrationPhoneEntryRoute extends PageRouteInfo<void> {
  const RegistrationPhoneEntryRoute()
      : super(
          RegistrationPhoneEntryRoute.name,
          path: '/registration/create/phone',
        );

  static const String name = 'RegistrationPhoneEntryRoute';
}

/// generated route for
/// [RegistrationPhoneVerificationPage]
class RegistrationPhoneVerificationRoute extends PageRouteInfo<void> {
  const RegistrationPhoneVerificationRoute()
      : super(
          RegistrationPhoneVerificationRoute.name,
          path: '/registration/create/phone/verify',
        );

  static const String name = 'RegistrationPhoneVerificationRoute';
}

/// generated route for
/// [RegistrationAccountSetupPage]
class RegistrationAccountSetupRoute extends PageRouteInfo<void> {
  const RegistrationAccountSetupRoute()
      : super(
          RegistrationAccountSetupRoute.name,
          path: '/registration/profile/start',
        );

  static const String name = 'RegistrationAccountSetupRoute';
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    Key? key,
    required Type senderRoute,
  }) : super(
          LoginRoute.name,
          path: '/login',
          args: LoginRouteArgs(
            key: key,
            senderRoute: senderRoute,
          ),
        );

  static const String name = 'LoginRoute';
}

class LoginRouteArgs {
  const LoginRouteArgs({
    this.key,
    required this.senderRoute,
  });

  final Key? key;

  final Type senderRoute;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, senderRoute: $senderRoute}';
  }
}

/// generated route for
/// [LoginPasswordPage]
class LoginPasswordRoute extends PageRouteInfo<void> {
  const LoginPasswordRoute()
      : super(
          LoginPasswordRoute.name,
          path: '/login/password',
        );

  static const String name = 'LoginPasswordRoute';
}

/// generated route for
/// [LoginWelcomeBackPage]
class LoginWelcomeBackRoute extends PageRouteInfo<void> {
  const LoginWelcomeBackRoute()
      : super(
          LoginWelcomeBackRoute.name,
          path: '/login/success',
        );

  static const String name = 'LoginWelcomeBackRoute';
}

/// generated route for
/// [NotificationPreferencesPage]
class NotificationPreferencesRoute extends PageRouteInfo<void> {
  const NotificationPreferencesRoute()
      : super(
          NotificationPreferencesRoute.name,
          path: '/notifications',
        );

  static const String name = 'NotificationPreferencesRoute';
}

/// generated route for
/// [BiometricsPreferencesPage]
class BiometricsPreferencesRoute extends PageRouteInfo<void> {
  const BiometricsPreferencesRoute()
      : super(
          BiometricsPreferencesRoute.name,
          path: '/biometrics',
        );

  static const String name = 'BiometricsPreferencesRoute';
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    required String userId,
    Key? key,
  }) : super(
          ProfileRoute.name,
          path: '/profile/view/:userId',
          args: ProfileRouteArgs(
            userId: userId,
            key: key,
          ),
        );

  static const String name = 'ProfileRoute';
}

class ProfileRouteArgs {
  const ProfileRouteArgs({
    required this.userId,
    this.key,
  });

  final String userId;

  final Key? key;

  @override
  String toString() {
    return 'ProfileRouteArgs{userId: $userId, key: $key}';
  }
}

/// generated route for
/// [ProfileWelcomeBackPage]
class ProfileWelcomeBackRoute extends PageRouteInfo<ProfileWelcomeBackRouteArgs> {
  ProfileWelcomeBackRoute({
    required PageRouteInfo<dynamic> nextPage,
    Key? key,
  }) : super(
          ProfileWelcomeBackRoute.name,
          path: '/profile/setup/continue',
          args: ProfileWelcomeBackRouteArgs(
            nextPage: nextPage,
            key: key,
          ),
        );

  static const String name = 'ProfileWelcomeBackRoute';
}

class ProfileWelcomeBackRouteArgs {
  const ProfileWelcomeBackRouteArgs({
    required this.nextPage,
    this.key,
  });

  final PageRouteInfo<dynamic> nextPage;

  final Key? key;

  @override
  String toString() {
    return 'ProfileWelcomeBackRouteArgs{nextPage: $nextPage, key: $key}';
  }
}

/// generated route for
/// [ProfileNameEntryPage]
class ProfileNameEntryRoute extends PageRouteInfo<void> {
  const ProfileNameEntryRoute()
      : super(
          ProfileNameEntryRoute.name,
          path: '/profile/setup/name',
        );

  static const String name = 'ProfileNameEntryRoute';
}

/// generated route for
/// [ProfileHivStatusPage]
class ProfileHivStatusRoute extends PageRouteInfo<void> {
  const ProfileHivStatusRoute()
      : super(
          ProfileHivStatusRoute.name,
          path: '/registration/profile/hiv-status',
        );

  static const String name = 'ProfileHivStatusRoute';
}

/// generated route for
/// [ProfileDisplayNameEntryPage]
class ProfileDisplayNameEntryRoute extends PageRouteInfo<void> {
  const ProfileDisplayNameEntryRoute()
      : super(
          ProfileDisplayNameEntryRoute.name,
          path: '/profile/setup/display-name',
        );

  static const String name = 'ProfileDisplayNameEntryRoute';
}

/// generated route for
/// [ProfileBirthdayEntryPage]
class ProfileBirthdayEntryRoute extends PageRouteInfo<void> {
  const ProfileBirthdayEntryRoute()
      : super(
          ProfileBirthdayEntryRoute.name,
          path: '/profile/setup/birthday',
        );

  static const String name = 'ProfileBirthdayEntryRoute';
}

/// generated route for
/// [ProfileGenderSelectPage]
class ProfileGenderSelectRoute extends PageRouteInfo<void> {
  const ProfileGenderSelectRoute()
      : super(
          ProfileGenderSelectRoute.name,
          path: '/profile/setup/gender',
        );

  static const String name = 'ProfileGenderSelectRoute';
}

/// generated route for
/// [ProfileInterestsEntryPage]
class ProfileInterestsEntryRoute extends PageRouteInfo<void> {
  const ProfileInterestsEntryRoute()
      : super(
          ProfileInterestsEntryRoute.name,
          path: '/profile/setup/interests',
        );

  static const String name = 'ProfileInterestsEntryRoute';
}

/// generated route for
/// [ProfileImageWelcomePage]
class ProfileImageWelcomeRoute extends PageRouteInfo<void> {
  const ProfileImageWelcomeRoute()
      : super(
          ProfileImageWelcomeRoute.name,
          path: '/profile/setup/image/welcome',
        );

  static const String name = 'ProfileImageWelcomeRoute';
}

/// generated route for
/// [ProfileImagePage]
class ProfileImageRoute extends PageRouteInfo<void> {
  const ProfileImageRoute()
      : super(
          ProfileImageRoute.name,
          path: '/profile/setup/image',
        );

  static const String name = 'ProfileImageRoute';
}

/// generated route for
/// [ProfileImageSuccessPage]
class ProfileImageSuccessRoute extends PageRouteInfo<void> {
  const ProfileImageSuccessRoute()
      : super(
          ProfileImageSuccessRoute.name,
          path: '/profile/setup/image/success',
        );

  static const String name = 'ProfileImageSuccessRoute';
}

/// generated route for
/// [ProfileImageDialogPage]
class ProfileImageDialogRoute extends PageRouteInfo<void> {
  const ProfileImageDialogRoute()
      : super(
          ProfileImageDialogRoute.name,
          path: '/profile/setup/image/help',
        );

  static const String name = 'ProfileImageDialogRoute';
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/home',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [SearchPage]
class SearchRoute extends PageRouteInfo<void> {
  const SearchRoute()
      : super(
          SearchRoute.name,
          path: '/search',
        );

  static const String name = 'SearchRoute';
}

/// generated route for
/// [ChatListPage]
class ChatListRoute extends PageRouteInfo<void> {
  const ChatListRoute()
      : super(
          ChatListRoute.name,
          path: '/chat/list',
        );

  static const String name = 'ChatListRoute';
}

/// generated route for
/// [ChatPage]
class ChatRoute extends PageRouteInfo<void> {
  const ChatRoute()
      : super(
          ChatRoute.name,
          path: '/chat/current',
        );

  static const String name = 'ChatRoute';
}

/// generated route for
/// [AccountPage]
class AccountRoute extends PageRouteInfo<void> {
  const AccountRoute()
      : super(
          AccountRoute.name,
          path: '/account',
        );

  static const String name = 'AccountRoute';
}

/// generated route for
/// [AccountDetailsPage]
class AccountDetailsRoute extends PageRouteInfo<void> {
  const AccountDetailsRoute()
      : super(
          AccountDetailsRoute.name,
          path: '/account/details',
        );

  static const String name = 'AccountDetailsRoute';
}

/// generated route for
/// [AccountUpdateEmailAddressPage]
class AccountUpdateEmailAddressRoute extends PageRouteInfo<void> {
  const AccountUpdateEmailAddressRoute()
      : super(
          AccountUpdateEmailAddressRoute.name,
          path: '/account/update/email',
        );

  static const String name = 'AccountUpdateEmailAddressRoute';
}

/// generated route for
/// [AccountUpdatePhoneNumberPage]
class AccountUpdatePhoneNumberRoute extends PageRouteInfo<void> {
  const AccountUpdatePhoneNumberRoute()
      : super(
          AccountUpdatePhoneNumberRoute.name,
          path: '/account/update/phone',
        );

  static const String name = 'AccountUpdatePhoneNumberRoute';
}

/// generated route for
/// [AccountUpdatePasswordPage]
class AccountUpdatePasswordRoute extends PageRouteInfo<void> {
  const AccountUpdatePasswordRoute()
      : super(
          AccountUpdatePasswordRoute.name,
          path: '/account/update/password',
        );

  static const String name = 'AccountUpdatePasswordRoute';
}

/// generated route for
/// [AccountDeleteProfilePage]
class AccountDeleteProfileRoute extends PageRouteInfo<void> {
  const AccountDeleteProfileRoute()
      : super(
          AccountDeleteProfileRoute.name,
          path: '/account/delete',
        );

  static const String name = 'AccountDeleteProfileRoute';
}

/// generated route for
/// [AccountVerificationPage]
class AccountVerificationRoute extends PageRouteInfo<AccountVerificationRouteArgs> {
  AccountVerificationRoute({
    required String title,
    required String body,
    required Future<void> Function() onVerificationSuccess,
    String? buttonText,
    Key? key,
  }) : super(
          AccountVerificationRoute.name,
          path: '/account/verification',
          args: AccountVerificationRouteArgs(
            title: title,
            body: body,
            onVerificationSuccess: onVerificationSuccess,
            buttonText: buttonText,
            key: key,
          ),
        );

  static const String name = 'AccountVerificationRoute';
}

class AccountVerificationRouteArgs {
  const AccountVerificationRouteArgs({
    required this.title,
    required this.body,
    required this.onVerificationSuccess,
    this.buttonText,
    this.key,
  });

  final String title;

  final String body;

  final Future<void> Function() onVerificationSuccess;

  final String? buttonText;

  final Key? key;

  @override
  String toString() {
    return 'AccountVerificationRouteArgs{title: $title, body: $body, onVerificationSuccess: $onVerificationSuccess, buttonText: $buttonText, key: $key}';
  }
}

/// generated route for
/// [AccountUpdatedPage]
class AccountUpdatedRoute extends PageRouteInfo<AccountUpdatedRouteArgs> {
  AccountUpdatedRoute({
    required String body,
    String? title,
    String? buttonText,
    Future<void> Function()? onContinueSelected,
    Key? key,
  }) : super(
          AccountUpdatedRoute.name,
          path: '/account/update/complete',
          args: AccountUpdatedRouteArgs(
            body: body,
            title: title,
            buttonText: buttonText,
            onContinueSelected: onContinueSelected,
            key: key,
          ),
        );

  static const String name = 'AccountUpdatedRoute';
}

class AccountUpdatedRouteArgs {
  const AccountUpdatedRouteArgs({
    required this.body,
    this.title,
    this.buttonText,
    this.onContinueSelected,
    this.key,
  });

  final String body;

  final String? title;

  final String? buttonText;

  final Future<void> Function()? onContinueSelected;

  final Key? key;

  @override
  String toString() {
    return 'AccountUpdatedRouteArgs{body: $body, title: $title, buttonText: $buttonText, onContinueSelected: $onContinueSelected, key: $key}';
  }
}

/// generated route for
/// [ProfileEditSettingsPage]
class ProfileEditSettingsRoute extends PageRouteInfo<void> {
  const ProfileEditSettingsRoute()
      : super(
          ProfileEditSettingsRoute.name,
          path: '/account/profile',
        );

  static const String name = 'ProfileEditSettingsRoute';
}

/// generated route for
/// [AccountPreferencesPage]
class AccountPreferencesRoute extends PageRouteInfo<void> {
  const AccountPreferencesRoute()
      : super(
          AccountPreferencesRoute.name,
          path: '/account/preferences',
        );

  static const String name = 'AccountPreferencesRoute';
}

/// generated route for
/// [GuidancePage]
class GuidanceRoute extends PageRouteInfo<void> {
  const GuidanceRoute()
      : super(
          GuidanceRoute.name,
          path: '/guidance',
        );

  static const String name = 'GuidanceRoute';
}

/// generated route for
/// [TermsAndConditionsPage]
class TermsAndConditionsRoute extends PageRouteInfo<void> {
  const TermsAndConditionsRoute()
      : super(
          TermsAndConditionsRoute.name,
          path: '/terms',
        );

  static const String name = 'TermsAndConditionsRoute';
}

/// generated route for
/// [HintDialogPage]
class HintDialogRoute extends PageRouteInfo<HintDialogRouteArgs> {
  HintDialogRoute({
    Key? key,
    required List<Widget> widgets,
  }) : super(
          HintDialogRoute.name,
          path: '/help/dialog',
          args: HintDialogRouteArgs(
            key: key,
            widgets: widgets,
          ),
        );

  static const String name = 'HintDialogRoute';
}

class HintDialogRouteArgs {
  const HintDialogRouteArgs({
    this.key,
    required this.widgets,
  });

  final Key? key;

  final List<Widget> widgets;

  @override
  String toString() {
    return 'HintDialogRouteArgs{key: $key, widgets: $widgets}';
  }
}

/// generated route for
/// [ErrorPage]
class ErrorRoute extends PageRouteInfo<ErrorRouteArgs> {
  ErrorRoute({
    required String errorMessage,
    Key? key,
  }) : super(
          ErrorRoute.name,
          path: '/error',
          args: ErrorRouteArgs(
            errorMessage: errorMessage,
            key: key,
          ),
        );

  static const String name = 'ErrorRoute';
}

class ErrorRouteArgs {
  const ErrorRouteArgs({
    required this.errorMessage,
    this.key,
  });

  final String errorMessage;

  final Key? key;

  @override
  String toString() {
    return 'ErrorRouteArgs{errorMessage: $errorMessage, key: $key}';
  }
}

/// generated route for
/// [DevelopmentPage]
class DevelopmentRoute extends PageRouteInfo<void> {
  const DevelopmentRoute()
      : super(
          DevelopmentRoute.name,
          path: '/devtools',
        );

  static const String name = 'DevelopmentRoute';
}
