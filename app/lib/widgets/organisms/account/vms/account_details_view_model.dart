// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/account_form_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import 'package:app/widgets/organisms/profile/profile_edit_thanks_page.dart';
import '../../../../services/third_party.dart';

part 'account_details_view_model.freezed.dart';
part 'account_details_view_model.g.dart';

@freezed
class AccountDetailsViewModelState with _$AccountDetailsViewModelState {
  const factory AccountDetailsViewModelState({
    @Default(false) bool isBusy,
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

  Future<void> updateSocialProviders() async {
    final Logger logger = ref.read(loggerProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);

    logger.d('updateSocialProviders');
    state = state.copyWith(
      googleUserInfo: userController.googleProvider,
      facebookUserInfo: userController.facebookProvider,
      appleUserInfo: userController.appleProvider,
    );
  }

  Future<void> onUpdateEmailAddressButtonPressed(BuildContext context, Locale locale, AccountFormController controller) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d('onUpdateEmailAddressButtonPressed');
    controller.resetState(locale, formMode: FormMode.edit, editTarget: AccountEditTarget.email);
    await appRouter.push(const AccountUpdateEmailAddressRoute());
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

    state = state.copyWith(isBusy: true);

    try {
      logger.d('onDisconnectAppleProviderPressed');
      await userController.disconnectSocialProvider(userController.appleProvider!, PositiveSocialProvider.apple);
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

    logger.d('onDisconnectFacebookProviderPressed');
    state = state.copyWith(isBusy: true);

    try {
      logger.d('onDisconnectFacebookProviderPressed');
      await userController.disconnectSocialProvider(userController.facebookProvider!, PositiveSocialProvider.facebook);
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

    logger.d('onDisconnectGoogleProviderPressed');
    state = state.copyWith(isBusy: true);

    try {
      logger.d('onDisconnectGoogleProviderPressed');
      await userController.disconnectSocialProvider(userController.googleProvider!, PositiveSocialProvider.google);
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

  Future<void> onDeleteAccountButtonPressed(BuildContext context, Locale locale, AccountFormController controller) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d('onUpdatePasswordButtonPressed');
    controller.resetState(locale, formMode: FormMode.edit, editTarget: AccountEditTarget.deleteProfile);
    await appRouter.push(const AccountDeleteProfileRoute());
  }

  Future<void> onConnectSocialUserRequested() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d('onConnectSocialUserRequested');
    await appRouter.push(const AccountConnectSocialRoute());
  }

  Future<void> onConnectAppleUserRequested() async {
    final Logger logger = ref.read(loggerProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));

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
        body: 'You can now use your Apple account to access Positive+1',
        returnStyle: ProfileEditThanksReturnStyle.popToAccountDetails,
      ));
    } catch (e) {
      logger.e('onConnectAppleUserRequested: $e');
      final SnackBar snackBar = PositiveGenericSnackBar(
        title: "Login Failed",
        icon: UniconsLine.envelope_exclamation,
        backgroundColour: colours.black,
      );

      if (appRouter.navigatorKey.currentContext != null) {
        ScaffoldMessenger.of(appRouter.navigatorKey.currentContext!).showSnackBar(snackBar);
      }
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onConnectFacebookUserRequested() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d('onConnectFacebookUserRequested');
    state = state.copyWith(isBusy: true);

    try {
      logger.d('onConnectFacebookUserRequested');
      // TODO(ryan): Implement Facebook provider
      // await userController.registerFacebookProvider();
      await appRouter.replace(ProfileEditThanksRoute(
        body: 'You can now use your Facebook account to access Positive+1',
        returnStyle: ProfileEditThanksReturnStyle.popToAccountDetails,
      ));
    } catch (e) {
      logger.e('onConnectFacebookUserRequested: $e');
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onConnectGoogleUserRequested() async {
    final Logger logger = ref.read(loggerProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);
    final AppRouter appRouter = ref.read(appRouterProvider);

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
          body: 'You can now use your Google account to access Positive+1',
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
