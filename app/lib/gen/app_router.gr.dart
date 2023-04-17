// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AccountDeleteProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountDeleteProfilePage(),
      );
    },
    AccountDetailsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountDetailsPage(),
      );
    },
    AccountRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountPage(),
      );
    },
    AccountPreferencesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountPreferencesPage(),
      );
    },
    AccountUpdatedRoute.name: (routeData) {
      final args = routeData.argsAs<AccountUpdatedRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AccountUpdatedPage(
          body: args.body,
          title: args.title,
          buttonText: args.buttonText,
          onContinueSelected: args.onContinueSelected,
          key: args.key,
        ),
      );
    },
    AccountUpdateEmailAddressRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountUpdateEmailAddressPage(),
      );
    },
    AccountUpdatePasswordRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountUpdatePasswordPage(),
      );
    },
    AccountUpdatePhoneNumberRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountUpdatePhoneNumberPage(),
      );
    },
    AccountVerificationRoute.name: (routeData) {
      final args = routeData.argsAs<AccountVerificationRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AccountVerificationPage(
          title: args.title,
          body: args.body,
          onVerificationSuccess: args.onVerificationSuccess,
          buttonText: args.buttonText,
          key: args.key,
        ),
      );
    },
    ProfileEditSettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileEditSettingsPage(),
      );
    },
    BiometricsPreferencesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const BiometricsPreferencesPage(),
      );
    },
    DevelopmentRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DevelopmentPage(),
      );
    },
    HintDialogRoute.name: (routeData) {
      final args = routeData.argsAs<HintDialogRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HintDialogPage(
          key: args.key,
          widgets: args.widgets,
        ),
      );
    },
    ErrorRoute.name: (routeData) {
      final args = routeData.argsAs<ErrorRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ErrorPage(
          errorMessage: args.errorMessage,
          key: args.key,
        ),
      );
    },
    GuidanceRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const GuidancePage(),
      );
    },
    ChatRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(child: const ChatPage()),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomePage(),
      );
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LoginPage(
          key: args.key,
          senderRoute: args.senderRoute,
        ),
      );
    },
    LoginPasswordRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPasswordPage(),
      );
    },
    LoginWelcomeBackRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginWelcomeBackPage(),
      );
    },
    NotificationsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NotificationsPage(),
      );
    },
    NotificationPreferencesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NotificationPreferencesPage(),
      );
    },
    OnboardingConnectRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OnboardingConnectPage(),
      );
    },
    OnboardingEducationRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OnboardingEducationPage(),
      );
    },
    OnboardingGuidanceRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OnboardingGuidancePage(),
      );
    },
    OnboardingOurPledgeRoute.name: (routeData) {
      final args = routeData.argsAs<OnboardingOurPledgeRouteArgs>(
          orElse: () => const OnboardingOurPledgeRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: OnboardingOurPledgePage(
          style: args.style,
          key: args.key,
        ),
      );
    },
    OnboardingWelcomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OnboardingWelcomePage(),
      );
    },
    OnboardingYourPledgeRoute.name: (routeData) {
      final args = routeData.argsAs<OnboardingYourPledgeRouteArgs>(
          orElse: () => const OnboardingYourPledgeRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: OnboardingYourPledgePage(
          style: args.style,
          key: args.key,
        ),
      );
    },
    ProfileBiographyEntryRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileBiographyEntryPage(),
      );
    },
    ProfileBirthdayEntryRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileBirthdayEntryPage(),
      );
    },
    ProfileDisplayNameEntryRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileDisplayNameEntryPage(),
      );
    },
    ProfileEditThanksRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileEditThanksRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProfileEditThanksPage(
          key: args.key,
          body: args.body,
        ),
      );
    },
    ProfileGenderSelectRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileGenderSelectPage(),
      );
    },
    ProfileHivStatusRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileHivStatusPage(),
      );
    },
    ProfileInterestsEntryRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileInterestsEntryPage(),
      );
    },
    ProfileLocationRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileLocationPage(),
      );
    },
    ProfileNameEntryRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileNameEntryPage(),
      );
    },
    ProfileRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProfilePage(
          userId: args.userId,
          key: args.key,
        ),
      );
    },
    ProfilePhotoRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfilePhotoPage(),
      );
    },
    ProfileReferenceImageRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileReferenceImagePage(),
      );
    },
    ProfileReferenceImageSuccessRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileReferenceImageSuccessPage(),
      );
    },
    ProfileReferenceImageWelcomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileReferenceImageWelcomePage(),
      );
    },
    ProfileWelcomeBackRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileWelcomeBackRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProfileWelcomeBackPage(
          nextPage: args.nextPage,
          key: args.key,
        ),
      );
    },
    RegistrationAccountRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegistrationAccountPage(),
      );
    },
    RegistrationAccountSetupRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegistrationAccountSetupPage(),
      );
    },
    RegistrationEmailEntryRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegistrationEmailEntryPage(),
      );
    },
    RegistrationPasswordEntryRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegistrationPasswordEntryPage(),
      );
    },
    RegistrationPhoneEntryRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegistrationPhoneEntryPage(),
      );
    },
    RegistrationPhoneVerificationRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegistrationPhoneVerificationPage(),
      );
    },
    SearchRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SearchPage(),
      );
    },
    SplashRoute.name: (routeData) {
      final args = routeData.argsAs<SplashRouteArgs>(
          orElse: () => const SplashRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SplashPage(
          key: args.key,
          style: args.style,
        ),
      );
    },
    TermsAndConditionsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TermsAndConditionsPage(),
      );
    },
    ChatConversationsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(child: const ChatConversationsPage()),
      );
    },
    ChatCreateRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ChatCreatePage(),
      );
    },
  };
}

/// generated route for
/// [AccountDeleteProfilePage]
class AccountDeleteProfileRoute extends PageRouteInfo<void> {
  const AccountDeleteProfileRoute({List<PageRouteInfo>? children})
      : super(
          AccountDeleteProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountDeleteProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AccountDetailsPage]
class AccountDetailsRoute extends PageRouteInfo<void> {
  const AccountDetailsRoute({List<PageRouteInfo>? children})
      : super(
          AccountDetailsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountDetailsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AccountPage]
class AccountRoute extends PageRouteInfo<void> {
  const AccountRoute({List<PageRouteInfo>? children})
      : super(
          AccountRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AccountPreferencesPage]
class AccountPreferencesRoute extends PageRouteInfo<void> {
  const AccountPreferencesRoute({List<PageRouteInfo>? children})
      : super(
          AccountPreferencesRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountPreferencesRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
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
    List<PageRouteInfo>? children,
  }) : super(
          AccountUpdatedRoute.name,
          args: AccountUpdatedRouteArgs(
            body: body,
            title: title,
            buttonText: buttonText,
            onContinueSelected: onContinueSelected,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'AccountUpdatedRoute';

  static const PageInfo<AccountUpdatedRouteArgs> page =
      PageInfo<AccountUpdatedRouteArgs>(name);
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
/// [AccountUpdateEmailAddressPage]
class AccountUpdateEmailAddressRoute extends PageRouteInfo<void> {
  const AccountUpdateEmailAddressRoute({List<PageRouteInfo>? children})
      : super(
          AccountUpdateEmailAddressRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountUpdateEmailAddressRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AccountUpdatePasswordPage]
class AccountUpdatePasswordRoute extends PageRouteInfo<void> {
  const AccountUpdatePasswordRoute({List<PageRouteInfo>? children})
      : super(
          AccountUpdatePasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountUpdatePasswordRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AccountUpdatePhoneNumberPage]
class AccountUpdatePhoneNumberRoute extends PageRouteInfo<void> {
  const AccountUpdatePhoneNumberRoute({List<PageRouteInfo>? children})
      : super(
          AccountUpdatePhoneNumberRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountUpdatePhoneNumberRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AccountVerificationPage]
class AccountVerificationRoute
    extends PageRouteInfo<AccountVerificationRouteArgs> {
  AccountVerificationRoute({
    required String title,
    required String body,
    required Future<void> Function() onVerificationSuccess,
    String? buttonText,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          AccountVerificationRoute.name,
          args: AccountVerificationRouteArgs(
            title: title,
            body: body,
            onVerificationSuccess: onVerificationSuccess,
            buttonText: buttonText,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'AccountVerificationRoute';

  static const PageInfo<AccountVerificationRouteArgs> page =
      PageInfo<AccountVerificationRouteArgs>(name);
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
/// [ProfileEditSettingsPage]
class ProfileEditSettingsRoute extends PageRouteInfo<void> {
  const ProfileEditSettingsRoute({List<PageRouteInfo>? children})
      : super(
          ProfileEditSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileEditSettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [BiometricsPreferencesPage]
class BiometricsPreferencesRoute extends PageRouteInfo<void> {
  const BiometricsPreferencesRoute({List<PageRouteInfo>? children})
      : super(
          BiometricsPreferencesRoute.name,
          initialChildren: children,
        );

  static const String name = 'BiometricsPreferencesRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DevelopmentPage]
class DevelopmentRoute extends PageRouteInfo<void> {
  const DevelopmentRoute({List<PageRouteInfo>? children})
      : super(
          DevelopmentRoute.name,
          initialChildren: children,
        );

  static const String name = 'DevelopmentRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HintDialogPage]
class HintDialogRoute extends PageRouteInfo<HintDialogRouteArgs> {
  HintDialogRoute({
    Key? key,
    required List<Widget> widgets,
    List<PageRouteInfo>? children,
  }) : super(
          HintDialogRoute.name,
          args: HintDialogRouteArgs(
            key: key,
            widgets: widgets,
          ),
          initialChildren: children,
        );

  static const String name = 'HintDialogRoute';

  static const PageInfo<HintDialogRouteArgs> page =
      PageInfo<HintDialogRouteArgs>(name);
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
    List<PageRouteInfo>? children,
  }) : super(
          ErrorRoute.name,
          args: ErrorRouteArgs(
            errorMessage: errorMessage,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ErrorRoute';

  static const PageInfo<ErrorRouteArgs> page = PageInfo<ErrorRouteArgs>(name);
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
/// [GuidancePage]
class GuidanceRoute extends PageRouteInfo<void> {
  const GuidanceRoute({List<PageRouteInfo>? children})
      : super(
          GuidanceRoute.name,
          initialChildren: children,
        );

  static const String name = 'GuidanceRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ChatPage]
class ChatRoute extends PageRouteInfo<void> {
  const ChatRoute({List<PageRouteInfo>? children})
      : super(
          ChatRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    Key? key,
    required Type senderRoute,
    List<PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(
            key: key,
            senderRoute: senderRoute,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<LoginRouteArgs> page = PageInfo<LoginRouteArgs>(name);
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
  const LoginPasswordRoute({List<PageRouteInfo>? children})
      : super(
          LoginPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginPasswordRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginWelcomeBackPage]
class LoginWelcomeBackRoute extends PageRouteInfo<void> {
  const LoginWelcomeBackRoute({List<PageRouteInfo>? children})
      : super(
          LoginWelcomeBackRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginWelcomeBackRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NotificationsPage]
class NotificationsRoute extends PageRouteInfo<void> {
  const NotificationsRoute({List<PageRouteInfo>? children})
      : super(
          NotificationsRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NotificationPreferencesPage]
class NotificationPreferencesRoute extends PageRouteInfo<void> {
  const NotificationPreferencesRoute({List<PageRouteInfo>? children})
      : super(
          NotificationPreferencesRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationPreferencesRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OnboardingConnectPage]
class OnboardingConnectRoute extends PageRouteInfo<void> {
  const OnboardingConnectRoute({List<PageRouteInfo>? children})
      : super(
          OnboardingConnectRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingConnectRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OnboardingEducationPage]
class OnboardingEducationRoute extends PageRouteInfo<void> {
  const OnboardingEducationRoute({List<PageRouteInfo>? children})
      : super(
          OnboardingEducationRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingEducationRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OnboardingGuidancePage]
class OnboardingGuidanceRoute extends PageRouteInfo<void> {
  const OnboardingGuidanceRoute({List<PageRouteInfo>? children})
      : super(
          OnboardingGuidanceRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingGuidanceRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OnboardingOurPledgePage]
class OnboardingOurPledgeRoute
    extends PageRouteInfo<OnboardingOurPledgeRouteArgs> {
  OnboardingOurPledgeRoute({
    OnboardingStyle style = OnboardingStyle.home,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          OnboardingOurPledgeRoute.name,
          args: OnboardingOurPledgeRouteArgs(
            style: style,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'OnboardingOurPledgeRoute';

  static const PageInfo<OnboardingOurPledgeRouteArgs> page =
      PageInfo<OnboardingOurPledgeRouteArgs>(name);
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
/// [OnboardingWelcomePage]
class OnboardingWelcomeRoute extends PageRouteInfo<void> {
  const OnboardingWelcomeRoute({List<PageRouteInfo>? children})
      : super(
          OnboardingWelcomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingWelcomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OnboardingYourPledgePage]
class OnboardingYourPledgeRoute
    extends PageRouteInfo<OnboardingYourPledgeRouteArgs> {
  OnboardingYourPledgeRoute({
    OnboardingStyle style = OnboardingStyle.home,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          OnboardingYourPledgeRoute.name,
          args: OnboardingYourPledgeRouteArgs(
            style: style,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'OnboardingYourPledgeRoute';

  static const PageInfo<OnboardingYourPledgeRouteArgs> page =
      PageInfo<OnboardingYourPledgeRouteArgs>(name);
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
/// [ProfileBiographyEntryPage]
class ProfileBiographyEntryRoute extends PageRouteInfo<void> {
  const ProfileBiographyEntryRoute({List<PageRouteInfo>? children})
      : super(
          ProfileBiographyEntryRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileBiographyEntryRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileBirthdayEntryPage]
class ProfileBirthdayEntryRoute extends PageRouteInfo<void> {
  const ProfileBirthdayEntryRoute({List<PageRouteInfo>? children})
      : super(
          ProfileBirthdayEntryRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileBirthdayEntryRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileDisplayNameEntryPage]
class ProfileDisplayNameEntryRoute extends PageRouteInfo<void> {
  const ProfileDisplayNameEntryRoute({List<PageRouteInfo>? children})
      : super(
          ProfileDisplayNameEntryRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileDisplayNameEntryRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileEditThanksPage]
class ProfileEditThanksRoute extends PageRouteInfo<ProfileEditThanksRouteArgs> {
  ProfileEditThanksRoute({
    Key? key,
    required String body,
    List<PageRouteInfo>? children,
  }) : super(
          ProfileEditThanksRoute.name,
          args: ProfileEditThanksRouteArgs(
            key: key,
            body: body,
          ),
          initialChildren: children,
        );

  static const String name = 'ProfileEditThanksRoute';

  static const PageInfo<ProfileEditThanksRouteArgs> page =
      PageInfo<ProfileEditThanksRouteArgs>(name);
}

class ProfileEditThanksRouteArgs {
  const ProfileEditThanksRouteArgs({
    this.key,
    required this.body,
  });

  final Key? key;

  final String body;

  @override
  String toString() {
    return 'ProfileEditThanksRouteArgs{key: $key, body: $body}';
  }
}

/// generated route for
/// [ProfileGenderSelectPage]
class ProfileGenderSelectRoute extends PageRouteInfo<void> {
  const ProfileGenderSelectRoute({List<PageRouteInfo>? children})
      : super(
          ProfileGenderSelectRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileGenderSelectRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileHivStatusPage]
class ProfileHivStatusRoute extends PageRouteInfo<void> {
  const ProfileHivStatusRoute({List<PageRouteInfo>? children})
      : super(
          ProfileHivStatusRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileHivStatusRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileInterestsEntryPage]
class ProfileInterestsEntryRoute extends PageRouteInfo<void> {
  const ProfileInterestsEntryRoute({List<PageRouteInfo>? children})
      : super(
          ProfileInterestsEntryRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileInterestsEntryRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileLocationPage]
class ProfileLocationRoute extends PageRouteInfo<void> {
  const ProfileLocationRoute({List<PageRouteInfo>? children})
      : super(
          ProfileLocationRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileLocationRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileNameEntryPage]
class ProfileNameEntryRoute extends PageRouteInfo<void> {
  const ProfileNameEntryRoute({List<PageRouteInfo>? children})
      : super(
          ProfileNameEntryRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileNameEntryRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    required String userId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ProfileRoute.name,
          args: ProfileRouteArgs(
            userId: userId,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const PageInfo<ProfileRouteArgs> page =
      PageInfo<ProfileRouteArgs>(name);
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
/// [ProfilePhotoPage]
class ProfilePhotoRoute extends PageRouteInfo<void> {
  const ProfilePhotoRoute({List<PageRouteInfo>? children})
      : super(
          ProfilePhotoRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfilePhotoRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileReferenceImagePage]
class ProfileReferenceImageRoute extends PageRouteInfo<void> {
  const ProfileReferenceImageRoute({List<PageRouteInfo>? children})
      : super(
          ProfileReferenceImageRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileReferenceImageRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileReferenceImageSuccessPage]
class ProfileReferenceImageSuccessRoute extends PageRouteInfo<void> {
  const ProfileReferenceImageSuccessRoute({List<PageRouteInfo>? children})
      : super(
          ProfileReferenceImageSuccessRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileReferenceImageSuccessRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileReferenceImageWelcomePage]
class ProfileReferenceImageWelcomeRoute extends PageRouteInfo<void> {
  const ProfileReferenceImageWelcomeRoute({List<PageRouteInfo>? children})
      : super(
          ProfileReferenceImageWelcomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileReferenceImageWelcomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileWelcomeBackPage]
class ProfileWelcomeBackRoute
    extends PageRouteInfo<ProfileWelcomeBackRouteArgs> {
  ProfileWelcomeBackRoute({
    required PageRouteInfo<dynamic> nextPage,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ProfileWelcomeBackRoute.name,
          args: ProfileWelcomeBackRouteArgs(
            nextPage: nextPage,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ProfileWelcomeBackRoute';

  static const PageInfo<ProfileWelcomeBackRouteArgs> page =
      PageInfo<ProfileWelcomeBackRouteArgs>(name);
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
/// [RegistrationAccountPage]
class RegistrationAccountRoute extends PageRouteInfo<void> {
  const RegistrationAccountRoute({List<PageRouteInfo>? children})
      : super(
          RegistrationAccountRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegistrationAccountRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegistrationAccountSetupPage]
class RegistrationAccountSetupRoute extends PageRouteInfo<void> {
  const RegistrationAccountSetupRoute({List<PageRouteInfo>? children})
      : super(
          RegistrationAccountSetupRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegistrationAccountSetupRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegistrationEmailEntryPage]
class RegistrationEmailEntryRoute extends PageRouteInfo<void> {
  const RegistrationEmailEntryRoute({List<PageRouteInfo>? children})
      : super(
          RegistrationEmailEntryRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegistrationEmailEntryRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegistrationPasswordEntryPage]
class RegistrationPasswordEntryRoute extends PageRouteInfo<void> {
  const RegistrationPasswordEntryRoute({List<PageRouteInfo>? children})
      : super(
          RegistrationPasswordEntryRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegistrationPasswordEntryRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegistrationPhoneEntryPage]
class RegistrationPhoneEntryRoute extends PageRouteInfo<void> {
  const RegistrationPhoneEntryRoute({List<PageRouteInfo>? children})
      : super(
          RegistrationPhoneEntryRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegistrationPhoneEntryRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegistrationPhoneVerificationPage]
class RegistrationPhoneVerificationRoute extends PageRouteInfo<void> {
  const RegistrationPhoneVerificationRoute({List<PageRouteInfo>? children})
      : super(
          RegistrationPhoneVerificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegistrationPhoneVerificationRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SearchPage]
class SearchRoute extends PageRouteInfo<void> {
  const SearchRoute({List<PageRouteInfo>? children})
      : super(
          SearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<SplashRouteArgs> {
  SplashRoute({
    Key? key,
    SplashStyle style = SplashStyle.embracePositivity,
    List<PageRouteInfo>? children,
  }) : super(
          SplashRoute.name,
          args: SplashRouteArgs(
            key: key,
            style: style,
          ),
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<SplashRouteArgs> page = PageInfo<SplashRouteArgs>(name);
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
/// [TermsAndConditionsPage]
class TermsAndConditionsRoute extends PageRouteInfo<void> {
  const TermsAndConditionsRoute({List<PageRouteInfo>? children})
      : super(
          TermsAndConditionsRoute.name,
          initialChildren: children,
        );

  static const String name = 'TermsAndConditionsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ChatConversationsPage]
class ChatConversationsRoute extends PageRouteInfo<void> {
  const ChatConversationsRoute({List<PageRouteInfo>? children})
      : super(
          ChatConversationsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatConversationsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ChatCreatePage]
class ChatCreateRoute extends PageRouteInfo<void> {
  const ChatCreateRoute({List<PageRouteInfo>? children})
      : super(
          ChatCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatCreateRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
