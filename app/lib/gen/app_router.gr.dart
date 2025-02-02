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
    AccountCommunitiesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountCommunitiesPage(),
      );
    },
    AccountConfirmPasswordRoute.name: (routeData) {
      final args = routeData.argsAs<AccountConfirmPasswordRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AccountConfirmPasswordPage(
          key: args.key,
          pageType: args.pageType,
        ),
      );
    },
    AccountConnectEmailRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountConnectEmailPage(),
      );
    },
    AccountConnectSocialRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountConnectSocialPage(),
      );
    },
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
    AccountProfileEditSettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountProfileEditSettingsPage(),
      );
    },
    AccountPromotedPostsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountPromotedPostsPage(),
      );
    },
    AccountPromotedPostsPromotionRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountPromotedPostsPromotionPage(),
      );
    },
    AccountSocialDisconnectionRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountSocialDisconnectionPage(),
      );
    },
    AccountUpdateEmailAddressRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountUpdateEmailAddressPage(),
      );
    },
    AccountUpdateNameRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountUpdateNamePage(),
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
    BiometricsPreferencesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const BiometricsPreferencesPage(),
      );
    },
    ChatConversationsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(child: const ChatConversationsPage()),
      );
    },
    ChatMembersRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ChatMembersPage(),
      );
    },
    ChatRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(child: const ChatPage()),
      );
    },
    CreateConversationRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CreateConversationPage(),
      );
    },
    CreatePostRoute.name: (routeData) {
      final args = routeData.argsAs<CreatePostRouteArgs>(
          orElse: () => const CreatePostRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CreatePostPage(
          isEditPage: args.isEditPage,
          activityData: args.activityData,
          key: args.key,
        ),
      );
    },
    DevelopmentRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DevelopmentPage(),
      );
    },
    ErrorRoute.name: (routeData) {
      final args = routeData.argsAs<ErrorRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ErrorPage(
          errorMessage: args.errorMessage,
          errorExplanation: args.errorExplanation,
          shouldSignOutOnContinue: args.shouldSignOutOnContinue,
          key: args.key,
        ),
      );
    },
    ForgottenPasswordRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ForgottenPasswordPage(),
      );
    },
    ForgottenPasswordRecoveryRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ForgottenPasswordRecoveryPage(),
      );
    },
    GuidanceDirectoryEntryRoute.name: (routeData) {
      final args = routeData.argsAs<GuidanceDirectoryEntryRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: GuidanceDirectoryEntryPage(
          guidanceEntryId: args.guidanceEntryId,
          key: args.key,
        ),
      );
    },
    GuidanceDirectoryRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const GuidanceDirectoryPage(),
      );
    },
    GuidanceEntryRoute.name: (routeData) {
      final args = routeData.argsAs<GuidanceEntryRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: GuidanceEntryPage(
          entryId: args.entryId,
          searchTerm: args.searchTerm,
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
    HomeLoginPromptRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeLoginPromptPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomePage(),
      );
    },
    LoginAccountRecoveryRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginAccountRecoveryPage(),
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
    MediaRoute.name: (routeData) {
      final args = routeData.argsAs<MediaRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: MediaPage(
          key: args.key,
          media: args.media,
        ),
      );
    },
    NotificationPreferencesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NotificationPreferencesPage(),
      );
    },
    NotificationsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NotificationsPage(),
      );
    },
    OnboardingOurPledgeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OnboardingOurPledgePage(),
      );
    },
    OnboardingWelcomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OnboardingWelcomePage(),
      );
    },
    OnboardingYourPledgeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OnboardingYourPledgePage(),
      );
    },
    OrganisationCompanySectorSelectRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OrganisationCompanySectorSelectPage(),
      );
    },
    OrganisationNameSetupRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OrganisationNameSetupPage(),
      );
    },
    PostRoute.name: (routeData) {
      final args = routeData.argsAs<PostRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PostPage(
          activityId: args.activityId,
          feed: args.feed,
          reactionId: args.reactionId,
          promotionId: args.promotionId,
          key: args.key,
        ),
      );
    },
    PostReactionsRoute.name: (routeData) {
      final args = routeData.argsAs<PostReactionsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PostReactionsPage(
          activity: args.activity,
          feed: args.feed,
          reactionType: args.reactionType,
          key: args.key,
        ),
      );
    },
    PostShareRoute.name: (routeData) {
      final args = routeData.argsAs<PostShareRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PostSharePage(
          activityId: args.activityId,
          origin: args.origin,
          key: args.key,
        ),
      );
    },
    ProfileAboutRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileAboutPage(),
      );
    },
    ProfileAccentPhotoRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileAccentPhotoPage(),
      );
    },
    ProfileBiographyEntryRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileBiographyEntryPage(),
      );
    },
    ProfileBirthdayDeleteAccountRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileBirthdayDeleteAccountPage(),
      );
    },
    ProfileBirthdayEntryRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileBirthdayEntryPage(),
      );
    },
    ProfileDetailsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileDetailsPage(),
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
          title: args.title,
          body: args.body,
          continueText: args.continueText,
          returnStyle: args.returnStyle,
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
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfilePage(),
      );
    },
    ProfilePhotoSelectionRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfilePhotoSelectionPage(),
      );
    },
    ProfileReferenceImageCameraRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileReferenceImageCameraPage(),
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
    RegistrationCompleteRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegistrationCompletePage(),
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
    SearchRoute.name: (routeData) {
      final args = routeData.argsAs<SearchRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SearchPage(
          defaultTab: args.defaultTab,
          key: args.key,
        ),
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
    TagFeedRoute.name: (routeData) {
      final args = routeData.argsAs<TagFeedRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TagFeedPage(
          key: args.key,
          tag: args.tag,
        ),
      );
    },
    TermsAndConditionsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TermsAndConditionsPage(),
      );
    },
    VerificationDialogRoute.name: (routeData) {
      final args = routeData.argsAs<VerificationDialogRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: VerificationDialogPage(
          onVerified: args.onVerified,
          emailAddress: args.emailAddress,
          key: args.key,
        ),
      );
    },
  };
}

/// generated route for
/// [AccountCommunitiesPage]
class AccountCommunitiesRoute extends PageRouteInfo<void> {
  const AccountCommunitiesRoute({List<PageRouteInfo>? children})
      : super(
          AccountCommunitiesRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountCommunitiesRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AccountConfirmPasswordPage]
class AccountConfirmPasswordRoute
    extends PageRouteInfo<AccountConfirmPasswordRouteArgs> {
  AccountConfirmPasswordRoute({
    Key? key,
    required AccountConfirmPageType pageType,
    List<PageRouteInfo>? children,
  }) : super(
          AccountConfirmPasswordRoute.name,
          args: AccountConfirmPasswordRouteArgs(
            key: key,
            pageType: pageType,
          ),
          initialChildren: children,
        );

  static const String name = 'AccountConfirmPasswordRoute';

  static const PageInfo<AccountConfirmPasswordRouteArgs> page =
      PageInfo<AccountConfirmPasswordRouteArgs>(name);
}

class AccountConfirmPasswordRouteArgs {
  const AccountConfirmPasswordRouteArgs({
    this.key,
    required this.pageType,
  });

  final Key? key;

  final AccountConfirmPageType pageType;

  @override
  String toString() {
    return 'AccountConfirmPasswordRouteArgs{key: $key, pageType: $pageType}';
  }
}

/// generated route for
/// [AccountConnectEmailPage]
class AccountConnectEmailRoute extends PageRouteInfo<void> {
  const AccountConnectEmailRoute({List<PageRouteInfo>? children})
      : super(
          AccountConnectEmailRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountConnectEmailRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AccountConnectSocialPage]
class AccountConnectSocialRoute extends PageRouteInfo<void> {
  const AccountConnectSocialRoute({List<PageRouteInfo>? children})
      : super(
          AccountConnectSocialRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountConnectSocialRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
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
/// [AccountProfileEditSettingsPage]
class AccountProfileEditSettingsRoute extends PageRouteInfo<void> {
  const AccountProfileEditSettingsRoute({List<PageRouteInfo>? children})
      : super(
          AccountProfileEditSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountProfileEditSettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AccountPromotedPostsPage]
class AccountPromotedPostsRoute extends PageRouteInfo<void> {
  const AccountPromotedPostsRoute({List<PageRouteInfo>? children})
      : super(
          AccountPromotedPostsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountPromotedPostsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AccountPromotedPostsPromotionPage]
class AccountPromotedPostsPromotionRoute extends PageRouteInfo<void> {
  const AccountPromotedPostsPromotionRoute({List<PageRouteInfo>? children})
      : super(
          AccountPromotedPostsPromotionRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountPromotedPostsPromotionRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AccountSocialDisconnectionPage]
class AccountSocialDisconnectionRoute extends PageRouteInfo<void> {
  const AccountSocialDisconnectionRoute({List<PageRouteInfo>? children})
      : super(
          AccountSocialDisconnectionRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountSocialDisconnectionRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
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
/// [AccountUpdateNamePage]
class AccountUpdateNameRoute extends PageRouteInfo<void> {
  const AccountUpdateNameRoute({List<PageRouteInfo>? children})
      : super(
          AccountUpdateNameRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountUpdateNameRoute';

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
/// [ChatMembersPage]
class ChatMembersRoute extends PageRouteInfo<void> {
  const ChatMembersRoute({List<PageRouteInfo>? children})
      : super(
          ChatMembersRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatMembersRoute';

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
/// [CreateConversationPage]
class CreateConversationRoute extends PageRouteInfo<void> {
  const CreateConversationRoute({List<PageRouteInfo>? children})
      : super(
          CreateConversationRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateConversationRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CreatePostPage]
class CreatePostRoute extends PageRouteInfo<CreatePostRouteArgs> {
  CreatePostRoute({
    bool isEditPage = false,
    ActivityData? activityData,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          CreatePostRoute.name,
          args: CreatePostRouteArgs(
            isEditPage: isEditPage,
            activityData: activityData,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'CreatePostRoute';

  static const PageInfo<CreatePostRouteArgs> page =
      PageInfo<CreatePostRouteArgs>(name);
}

class CreatePostRouteArgs {
  const CreatePostRouteArgs({
    this.isEditPage = false,
    this.activityData,
    this.key,
  });

  final bool isEditPage;

  final ActivityData? activityData;

  final Key? key;

  @override
  String toString() {
    return 'CreatePostRouteArgs{isEditPage: $isEditPage, activityData: $activityData, key: $key}';
  }
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
/// [ErrorPage]
class ErrorRoute extends PageRouteInfo<ErrorRouteArgs> {
  ErrorRoute({
    required String errorMessage,
    String errorExplanation = '',
    bool shouldSignOutOnContinue = false,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ErrorRoute.name,
          args: ErrorRouteArgs(
            errorMessage: errorMessage,
            errorExplanation: errorExplanation,
            shouldSignOutOnContinue: shouldSignOutOnContinue,
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
    this.errorExplanation = '',
    this.shouldSignOutOnContinue = false,
    this.key,
  });

  final String errorMessage;

  final String errorExplanation;

  final bool shouldSignOutOnContinue;

  final Key? key;

  @override
  String toString() {
    return 'ErrorRouteArgs{errorMessage: $errorMessage, errorExplanation: $errorExplanation, shouldSignOutOnContinue: $shouldSignOutOnContinue, key: $key}';
  }
}

/// generated route for
/// [ForgottenPasswordPage]
class ForgottenPasswordRoute extends PageRouteInfo<void> {
  const ForgottenPasswordRoute({List<PageRouteInfo>? children})
      : super(
          ForgottenPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgottenPasswordRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ForgottenPasswordRecoveryPage]
class ForgottenPasswordRecoveryRoute extends PageRouteInfo<void> {
  const ForgottenPasswordRecoveryRoute({List<PageRouteInfo>? children})
      : super(
          ForgottenPasswordRecoveryRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgottenPasswordRecoveryRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [GuidanceDirectoryEntryPage]
class GuidanceDirectoryEntryRoute
    extends PageRouteInfo<GuidanceDirectoryEntryRouteArgs> {
  GuidanceDirectoryEntryRoute({
    required String guidanceEntryId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          GuidanceDirectoryEntryRoute.name,
          args: GuidanceDirectoryEntryRouteArgs(
            guidanceEntryId: guidanceEntryId,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'GuidanceDirectoryEntryRoute';

  static const PageInfo<GuidanceDirectoryEntryRouteArgs> page =
      PageInfo<GuidanceDirectoryEntryRouteArgs>(name);
}

class GuidanceDirectoryEntryRouteArgs {
  const GuidanceDirectoryEntryRouteArgs({
    required this.guidanceEntryId,
    this.key,
  });

  final String guidanceEntryId;

  final Key? key;

  @override
  String toString() {
    return 'GuidanceDirectoryEntryRouteArgs{guidanceEntryId: $guidanceEntryId, key: $key}';
  }
}

/// generated route for
/// [GuidanceDirectoryPage]
class GuidanceDirectoryRoute extends PageRouteInfo<void> {
  const GuidanceDirectoryRoute({List<PageRouteInfo>? children})
      : super(
          GuidanceDirectoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'GuidanceDirectoryRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [GuidanceEntryPage]
class GuidanceEntryRoute extends PageRouteInfo<GuidanceEntryRouteArgs> {
  GuidanceEntryRoute({
    required String entryId,
    String searchTerm = '',
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          GuidanceEntryRoute.name,
          args: GuidanceEntryRouteArgs(
            entryId: entryId,
            searchTerm: searchTerm,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'GuidanceEntryRoute';

  static const PageInfo<GuidanceEntryRouteArgs> page =
      PageInfo<GuidanceEntryRouteArgs>(name);
}

class GuidanceEntryRouteArgs {
  const GuidanceEntryRouteArgs({
    required this.entryId,
    this.searchTerm = '',
    this.key,
  });

  final String entryId;

  final String searchTerm;

  final Key? key;

  @override
  String toString() {
    return 'GuidanceEntryRouteArgs{entryId: $entryId, searchTerm: $searchTerm, key: $key}';
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
/// [HomeLoginPromptPage]
class HomeLoginPromptRoute extends PageRouteInfo<void> {
  const HomeLoginPromptRoute({List<PageRouteInfo>? children})
      : super(
          HomeLoginPromptRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeLoginPromptRoute';

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
/// [LoginAccountRecoveryPage]
class LoginAccountRecoveryRoute extends PageRouteInfo<void> {
  const LoginAccountRecoveryRoute({List<PageRouteInfo>? children})
      : super(
          LoginAccountRecoveryRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginAccountRecoveryRoute';

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
/// [MediaPage]
class MediaRoute extends PageRouteInfo<MediaRouteArgs> {
  MediaRoute({
    Key? key,
    required Media media,
    List<PageRouteInfo>? children,
  }) : super(
          MediaRoute.name,
          args: MediaRouteArgs(
            key: key,
            media: media,
          ),
          initialChildren: children,
        );

  static const String name = 'MediaRoute';

  static const PageInfo<MediaRouteArgs> page = PageInfo<MediaRouteArgs>(name);
}

class MediaRouteArgs {
  const MediaRouteArgs({
    this.key,
    required this.media,
  });

  final Key? key;

  final Media media;

  @override
  String toString() {
    return 'MediaRouteArgs{key: $key, media: $media}';
  }
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
/// [OnboardingOurPledgePage]
class OnboardingOurPledgeRoute extends PageRouteInfo<void> {
  const OnboardingOurPledgeRoute({List<PageRouteInfo>? children})
      : super(
          OnboardingOurPledgeRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingOurPledgeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
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
class OnboardingYourPledgeRoute extends PageRouteInfo<void> {
  const OnboardingYourPledgeRoute({List<PageRouteInfo>? children})
      : super(
          OnboardingYourPledgeRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingYourPledgeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OrganisationCompanySectorSelectPage]
class OrganisationCompanySectorSelectRoute extends PageRouteInfo<void> {
  const OrganisationCompanySectorSelectRoute({List<PageRouteInfo>? children})
      : super(
          OrganisationCompanySectorSelectRoute.name,
          initialChildren: children,
        );

  static const String name = 'OrganisationCompanySectorSelectRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OrganisationNameSetupPage]
class OrganisationNameSetupRoute extends PageRouteInfo<void> {
  const OrganisationNameSetupRoute({List<PageRouteInfo>? children})
      : super(
          OrganisationNameSetupRoute.name,
          initialChildren: children,
        );

  static const String name = 'OrganisationNameSetupRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PostPage]
class PostRoute extends PageRouteInfo<PostRouteArgs> {
  PostRoute({
    required String activityId,
    required TargetFeed feed,
    String reactionId = '',
    String promotionId = '',
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          PostRoute.name,
          args: PostRouteArgs(
            activityId: activityId,
            feed: feed,
            reactionId: reactionId,
            promotionId: promotionId,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'PostRoute';

  static const PageInfo<PostRouteArgs> page = PageInfo<PostRouteArgs>(name);
}

class PostRouteArgs {
  const PostRouteArgs({
    required this.activityId,
    required this.feed,
    this.reactionId = '',
    this.promotionId = '',
    this.key,
  });

  final String activityId;

  final TargetFeed feed;

  final String reactionId;

  final String promotionId;

  final Key? key;

  @override
  String toString() {
    return 'PostRouteArgs{activityId: $activityId, feed: $feed, reactionId: $reactionId, promotionId: $promotionId, key: $key}';
  }
}

/// generated route for
/// [PostReactionsPage]
class PostReactionsRoute extends PageRouteInfo<PostReactionsRouteArgs> {
  PostReactionsRoute({
    required Activity activity,
    required TargetFeed feed,
    required String reactionType,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          PostReactionsRoute.name,
          args: PostReactionsRouteArgs(
            activity: activity,
            feed: feed,
            reactionType: reactionType,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'PostReactionsRoute';

  static const PageInfo<PostReactionsRouteArgs> page =
      PageInfo<PostReactionsRouteArgs>(name);
}

class PostReactionsRouteArgs {
  const PostReactionsRouteArgs({
    required this.activity,
    required this.feed,
    required this.reactionType,
    this.key,
  });

  final Activity activity;

  final TargetFeed feed;

  final String reactionType;

  final Key? key;

  @override
  String toString() {
    return 'PostReactionsRouteArgs{activity: $activity, feed: $feed, reactionType: $reactionType, key: $key}';
  }
}

/// generated route for
/// [PostSharePage]
class PostShareRoute extends PageRouteInfo<PostShareRouteArgs> {
  PostShareRoute({
    required String activityId,
    required String origin,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          PostShareRoute.name,
          args: PostShareRouteArgs(
            activityId: activityId,
            origin: origin,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'PostShareRoute';

  static const PageInfo<PostShareRouteArgs> page =
      PageInfo<PostShareRouteArgs>(name);
}

class PostShareRouteArgs {
  const PostShareRouteArgs({
    required this.activityId,
    required this.origin,
    this.key,
  });

  final String activityId;

  final String origin;

  final Key? key;

  @override
  String toString() {
    return 'PostShareRouteArgs{activityId: $activityId, origin: $origin, key: $key}';
  }
}

/// generated route for
/// [ProfileAboutPage]
class ProfileAboutRoute extends PageRouteInfo<void> {
  const ProfileAboutRoute({List<PageRouteInfo>? children})
      : super(
          ProfileAboutRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileAboutRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileAccentPhotoPage]
class ProfileAccentPhotoRoute extends PageRouteInfo<void> {
  const ProfileAccentPhotoRoute({List<PageRouteInfo>? children})
      : super(
          ProfileAccentPhotoRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileAccentPhotoRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
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
/// [ProfileBirthdayDeleteAccountPage]
class ProfileBirthdayDeleteAccountRoute extends PageRouteInfo<void> {
  const ProfileBirthdayDeleteAccountRoute({List<PageRouteInfo>? children})
      : super(
          ProfileBirthdayDeleteAccountRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileBirthdayDeleteAccountRoute';

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
/// [ProfileDetailsPage]
class ProfileDetailsRoute extends PageRouteInfo<void> {
  const ProfileDetailsRoute({List<PageRouteInfo>? children})
      : super(
          ProfileDetailsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileDetailsRoute';

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
    required String title,
    required String body,
    required String continueText,
    ProfileEditThanksReturnStyle returnStyle =
        ProfileEditThanksReturnStyle.popToEditSettings,
    List<PageRouteInfo>? children,
  }) : super(
          ProfileEditThanksRoute.name,
          args: ProfileEditThanksRouteArgs(
            key: key,
            title: title,
            body: body,
            continueText: continueText,
            returnStyle: returnStyle,
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
    required this.title,
    required this.body,
    required this.continueText,
    this.returnStyle = ProfileEditThanksReturnStyle.popToEditSettings,
  });

  final Key? key;

  final String title;

  final String body;

  final String continueText;

  final ProfileEditThanksReturnStyle returnStyle;

  @override
  String toString() {
    return 'ProfileEditThanksRouteArgs{key: $key, title: $title, body: $body, continueText: $continueText, returnStyle: $returnStyle}';
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
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfilePhotoSelectionPage]
class ProfilePhotoSelectionRoute extends PageRouteInfo<void> {
  const ProfilePhotoSelectionRoute({List<PageRouteInfo>? children})
      : super(
          ProfilePhotoSelectionRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfilePhotoSelectionRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileReferenceImageCameraPage]
class ProfileReferenceImageCameraRoute extends PageRouteInfo<void> {
  const ProfileReferenceImageCameraRoute({List<PageRouteInfo>? children})
      : super(
          ProfileReferenceImageCameraRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileReferenceImageCameraRoute';

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
/// [RegistrationCompletePage]
class RegistrationCompleteRoute extends PageRouteInfo<void> {
  const RegistrationCompleteRoute({List<PageRouteInfo>? children})
      : super(
          RegistrationCompleteRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegistrationCompleteRoute';

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
/// [SearchPage]
class SearchRoute extends PageRouteInfo<SearchRouteArgs> {
  SearchRoute({
    required SearchTab defaultTab,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          SearchRoute.name,
          args: SearchRouteArgs(
            defaultTab: defaultTab,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static const PageInfo<SearchRouteArgs> page = PageInfo<SearchRouteArgs>(name);
}

class SearchRouteArgs {
  const SearchRouteArgs({
    required this.defaultTab,
    this.key,
  });

  final SearchTab defaultTab;

  final Key? key;

  @override
  String toString() {
    return 'SearchRouteArgs{defaultTab: $defaultTab, key: $key}';
  }
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
/// [TagFeedPage]
class TagFeedRoute extends PageRouteInfo<TagFeedRouteArgs> {
  TagFeedRoute({
    Key? key,
    required Tag tag,
    List<PageRouteInfo>? children,
  }) : super(
          TagFeedRoute.name,
          args: TagFeedRouteArgs(
            key: key,
            tag: tag,
          ),
          initialChildren: children,
        );

  static const String name = 'TagFeedRoute';

  static const PageInfo<TagFeedRouteArgs> page =
      PageInfo<TagFeedRouteArgs>(name);
}

class TagFeedRouteArgs {
  const TagFeedRouteArgs({
    this.key,
    required this.tag,
  });

  final Key? key;

  final Tag tag;

  @override
  String toString() {
    return 'TagFeedRouteArgs{key: $key, tag: $tag}';
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
/// [VerificationDialogPage]
class VerificationDialogRoute
    extends PageRouteInfo<VerificationDialogRouteArgs> {
  VerificationDialogRoute({
    required Future<void> Function() onVerified,
    required String emailAddress,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          VerificationDialogRoute.name,
          args: VerificationDialogRouteArgs(
            onVerified: onVerified,
            emailAddress: emailAddress,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'VerificationDialogRoute';

  static const PageInfo<VerificationDialogRouteArgs> page =
      PageInfo<VerificationDialogRouteArgs>(name);
}

class VerificationDialogRouteArgs {
  const VerificationDialogRouteArgs({
    required this.onVerified,
    required this.emailAddress,
    this.key,
  });

  final Future<void> Function() onVerified;

  final String emailAddress;

  final Key? key;

  @override
  String toString() {
    return 'VerificationDialogRouteArgs{onVerified: $onVerified, emailAddress: $emailAddress, key: $key}';
  }
}
