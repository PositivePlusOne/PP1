// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/constants/profile_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/account_form_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/api.dart';
import 'package:app/widgets/organisms/post/component/positive_clip_External_shader.dart';
import 'package:app/widgets/organisms/profile/profile_edit_thanks_page.dart';
import 'package:app/widgets/organisms/shared/positive_camera_dialog.dart';
import '../../../../services/third_party.dart';

part 'account_details_view_model.freezed.dart';
part 'account_details_view_model.g.dart';

@freezed
class AccountDetailsViewModelState with _$AccountDetailsViewModelState {
  const factory AccountDetailsViewModelState({
    @Default(false) bool isBusy,
    UserInfo? emailUserInfo,
    UserInfo? googleUserInfo,
    UserInfo? facebookUserInfo,
    UserInfo? appleUserInfo,
  }) = _AccountDetailsViewModelState;

  factory AccountDetailsViewModelState.initialState() => const AccountDetailsViewModelState();
}

@riverpod
class AccountDetailsViewModel extends _$AccountDetailsViewModel with LifecycleMixin {
  StreamSubscription<User?>? _userChangesSubscription;

  @override
  AccountDetailsViewModelState build() {
    return AccountDetailsViewModelState.initialState();
  }

  @override
  void onFirstRender() {
    final Logger logger = ref.read(loggerProvider);

    logger.d('AccountDetailsViewModel onFirstRender');
    setupListeners();
    updateSocialProviders();
  }

  Future<void> setupListeners() async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);

    logger.d('AccountDetailsViewModel setupListeners');
    await _userChangesSubscription?.cancel();
    _userChangesSubscription = firebaseAuth.userChanges().listen((User? user) {
      logger.d('AccountDetailsViewModel userChanges: $user');
      updateSocialProviders();
    });
  }

  Future<void> onChangeImageFromCameraSelected(BuildContext context) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final Size screenSize = MediaQuery.of(context).size;
    final double topPaddingCameraShader = (screenSize.height - screenSize.width) / 2;

    logger.d("onSelectCamera");
    await appRouter.pop();

    state = state.copyWith(isBusy: true);

    final XFile? result = await showCupertinoDialog(
      context: context,
      builder: (_) {
        return Stack(
          children: [
            const Positioned.fill(
              child: PositiveCameraDialog(
                displayCameraShade: false,
              ),
            ),
            Positioned.fill(
              child: PositiveClipExternalShader(
                paddingLeft: kPaddingNone,
                paddingRight: kPaddingNone,
                paddingTop: topPaddingCameraShader,
                paddingBottom: topPaddingCameraShader,
                colour: colours.black.withOpacity(kOpacityBarrier),
                radius: kBorderRadiusInfinite,
              ),
            ),
          ],
        );
      },
    );

    state = state.copyWith(isBusy: false);

    if (result == null || result.path.isEmpty) {
      logger.d("onSelectCamera: result is null or not a string");
      return;
    }

    logger.d("onSelectCamera: result is $result");
    await onImageUploadRequest(result);
  }

  Future<void> onChangeImageFromPickerSelected(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final ImagePicker picker = ref.read(imagePickerProvider);

    await appRouter.pop();

    logger.d("[AccountDetails] onImagePicker [start]");
    final XFile? picture = await picker.pickImage(source: ImageSource.gallery);
    if (picture == null) {
      logger.d("onImagePicker: picture is null");
      return;
    }

    logger.d("onImagePicker: picture is $picture");
    await onImageUploadRequest(picture);
  }

  Future<void> onImageUploadRequest(XFile? picture) async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    if (picture == null) {
      logger.d("onImageUploadRequest: picture is null");
      return;
    }

    try {
      logger.d("onImageUploadRequest: picture is $picture");
      state = state.copyWith(isBusy: true);

      final Profile? profile = profileController.currentProfile;
      final String profileId = profile?.flMeta?.id ?? '';
      if (profileId.isEmpty || profile == null) {
        logger.e('No profile found');
        return;
      }

      await profileController.updateProfileImage(picture);
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> updateSocialProviders() async {
    final Logger logger = ref.read(loggerProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);

    logger.d('updateSocialProviders');
    state = state.copyWith(
      emailUserInfo: userController.passwordProvider,
      googleUserInfo: userController.googleProvider,
      facebookUserInfo: userController.facebookProvider,
      appleUserInfo: userController.appleProvider,
    );
  }

  Future<void> onUpdateNameButtonPressed(BuildContext context, Locale locale, AccountFormController controller) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d('onUpdateNameButtonPressed');
    controller.resetState(locale, formMode: FormMode.edit, editTarget: AccountEditTarget.name);
    await appRouter.push(const AccountUpdateNameRoute());
  }

  Future<void> onUpdateEmailAddressButtonPressed(BuildContext context, Locale locale, AccountFormController controller) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d('onUpdateEmailAddressButtonPressed');
    controller.resetState(locale, formMode: FormMode.edit, editTarget: AccountEditTarget.email);
    await appRouter.push(const AccountUpdateEmailAddressRoute());
  }

  Future<void> onUndeleteAccountButtonPressed(BuildContext context, Locale locale, AccountFormController controller) async {
    final Logger logger = ref.read(loggerProvider);

    try {
      logger.i('Undeleting profile');
      state = state.copyWith(isBusy: true);

      final AppRouter appRouter = ref.read(appRouterProvider);
      final ProfileApiService profileApiService = await ref.read(profileApiServiceProvider.future);
      final ProfileController profileController = ref.read(profileControllerProvider.notifier);
      final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);

      final Profile? profile = profileController.currentProfile;
      final String profileId = profile?.flMeta?.id ?? '';
      if (profileId.isEmpty || profile == null) {
        logger.e('No profile found');
        return;
      }

      final Set<String> accountFlags = profile.accountFlags;
      if (!accountFlags.contains(kFeatureFlagPendingDeletion)) {
        logger.i('Profile is not pending deletion');
        return;
      }

      await profileApiService.toggleProfileDeletion(uid: profileId);
      await analyticsController.trackEvent(AnalyticEvents.accountDeletionCancelled);
      await appRouter.pop();
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onUpdatePhoneNumberButtonPressed(BuildContext context, Locale locale, AccountFormController controller) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d('onUpdatePhoneNumberButtonPressed');
    controller.resetState(locale, formMode: FormMode.edit, editTarget: AccountEditTarget.phone);
    await appRouter.push(const AccountUpdatePhoneNumberRoute());
  }

  Future<void> onUpdatePasswordButtonPressed(BuildContext context, Locale locale, AccountFormController controller) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d('onUpdatePasswordButtonPressed');
    controller.resetState(locale, formMode: FormMode.edit, editTarget: AccountEditTarget.password);
    await appRouter.push(const AccountUpdatePasswordRoute());
  }

  Future<void> onDisconnectAppleProviderPressed() async {
    final Logger logger = ref.read(loggerProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);

    if (userController.appleProvider == null) {
      logger.d('onDisconnectAppleProviderPressed: Apple provider is null');
      return;
    }

    try {
      logger.d('onDisconnectAppleProviderPressed');
      state = state.copyWith(isBusy: true);
      await userController.disconnectAuthProvider(userController.appleProvider!, PositiveAuthProvider.apple);
      state = state.copyWith(appleUserInfo: null);
    } catch (e) {
      logger.e('onDisconnectAppleProviderPressed: $e');
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onDisconnectFacebookProviderPressed() async {
    final Logger logger = ref.read(loggerProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);

    if (userController.facebookProvider == null) {
      logger.d('onDisconnectFacebookProviderPressed: Facebook provider is null');
      return;
    }

    try {
      logger.d('onDisconnectFacebookProviderPressed');
      state = state.copyWith(isBusy: true);
      await userController.disconnectAuthProvider(userController.facebookProvider!, PositiveAuthProvider.facebook);
      state = state.copyWith(facebookUserInfo: null);
    } catch (e) {
      logger.e('onDisconnectFacebookProviderPressed: $e');
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onDisconnectGoogleProviderPressed() async {
    final Logger logger = ref.read(loggerProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);
    final GoogleSignIn googleSignIn = ref.read(googleSignInProvider);

    if (userController.googleProvider == null) {
      logger.d('onDisconnectGoogleProviderPressed: Google provider is null');
      return;
    }

    try {
      logger.d('onDisconnectGoogleProviderPressed');
      state = state.copyWith(isBusy: true);
      await userController.disconnectAuthProvider(userController.googleProvider!, PositiveAuthProvider.google);
      if (googleSignIn.currentUser != null) {
        await googleSignIn.signOut();
      }

      state = state.copyWith(googleUserInfo: null);
    } catch (e) {
      logger.e('onDisconnectGoogleProviderPressed: $e');
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onDisconnectEmailProviderPressed() async {
    final Logger logger = ref.read(loggerProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);

    if (userController.passwordProvider == null) {
      logger.d('onDisconnectEmailProviderPressed: Email provider is null');
      return;
    }

    // Check to see if this is the only provider
    // If so, first prompt the user to add an email address
    if (userController.allProviders.length == 1) {
      throw Exception('Cannot disconnect email provider when it is the only provider');
    }

    try {
      logger.d('onDisconnectEmailProviderPressed');
      state = state.copyWith(isBusy: true);
      await userController.disconnectAuthProvider(userController.passwordProvider!, PositiveAuthProvider.email);
      state = state.copyWith(emailUserInfo: null);
    } catch (e) {
      logger.e('onDisconnectEmailProviderPressed: $e');
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onDeleteAccountButtonPressed(BuildContext context, Locale locale, AccountFormController controller) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d('onUpdatePasswordButtonPressed');
    controller.resetState(locale, formMode: FormMode.edit, editTarget: AccountEditTarget.deleteProfile);
    await appRouter.push(const AccountDeleteProfileRoute());
  }

  Future<void> onConnectEmailUserRequested() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d('onConnectSocialUserRequested');
    await appRouter.push(const AccountConnectEmailRoute());
  }

  Future<void> onConnectSocialUserRequested() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d('onConnectSocialUserRequested');
    await appRouter.push(const AccountConnectSocialRoute());
  }

  Future<void> onConnectAppleUserRequested(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));

    final AppLocalizations localisations = AppLocalizations.of(context)!;

    logger.d('onConnectAppleUserRequested');
    state = state.copyWith(isBusy: true);

    try {
      logger.d('onConnectAppleUserRequested');
      await userController.registerAppleProvider();
      if (!userController.isAppleProviderLinked) {
        logger.d('onConnectAppleUserRequested: Apple provider is not linked');
        return;
      }

      await appRouter.replace(ProfileEditThanksRoute(
        title: localisations.page_account_actions_change_social_connect_updated_title,
        continueText: localisations.page_account_actions_change_return_profile,
        body: localisations.page_account_actions_change_social_connect_updated_body_apple,
        returnStyle: ProfileEditThanksReturnStyle.popToAccountDetails,
      ));
    } catch (e) {
      // when the login doesn't work - we are happy it just closing
      logger.e('onConnectAppleUserRequested: $e');
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onConnectFacebookUserRequested(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    logger.d('onConnectFacebookUserRequested');
    state = state.copyWith(isBusy: true);

    try {
      logger.d('onConnectFacebookUserRequested');
      // TODO(ryan): Implement Facebook provider
      // await userController.registerFacebookProvider();
      await appRouter.replace(ProfileEditThanksRoute(
        title: localisations.page_account_actions_change_social_connect_updated_title,
        continueText: localisations.page_account_actions_change_return_profile,
        body: localisations.page_account_actions_change_social_connect_updated_body_facebook,
        returnStyle: ProfileEditThanksReturnStyle.popToAccountDetails,
      ));
    } catch (e) {
      logger.e('onConnectFacebookUserRequested: $e');
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onConnectGoogleUserRequested(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    logger.d('onConnectGoogleUserRequested');
    state = state.copyWith(isBusy: true);

    try {
      logger.d('onConnectGoogleUserRequested');
      await userController.registerGoogleProvider();
      if (!userController.isGoogleProviderLinked) {
        logger.d('onConnectGoogleUserRequested: Google provider is not linked');
        return;
      }

      await appRouter.replace(
        ProfileEditThanksRoute(
          title: localisations.page_account_actions_change_social_connect_updated_title,
          continueText: localisations.page_account_actions_change_return_account,
          body: localisations.page_account_actions_change_social_connect_updated_body_google,
          returnStyle: ProfileEditThanksReturnStyle.popToAccountDetails,
        ),
      );
    } catch (e) {
      logger.e('onConnectGoogleUserRequested: $e');
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }
}
