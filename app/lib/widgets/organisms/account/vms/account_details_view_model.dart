// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/user/account_form_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/organisms/profile/profile_edit_thanks_page.dart';
import '../../../../services/third_party.dart';

part 'account_details_view_model.freezed.dart';
part 'account_details_view_model.g.dart';

@freezed
class AccountDetailsViewModelState with _$AccountDetailsViewModelState {
  const factory AccountDetailsViewModelState({
    @Default(false) bool isBusy,
  }) = _AccountDetailsViewModelState;

  factory AccountDetailsViewModelState.initialState() => const AccountDetailsViewModelState();
}

@riverpod
class AccountDetailsViewModel extends _$AccountDetailsViewModel {
  @override
  AccountDetailsViewModelState build() {
    return AccountDetailsViewModelState.initialState();
  }

  Future<void> onUpdateEmailAddressButtonPressed() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final AccountFormController accountFormController = ref.read(accountFormControllerProvider.notifier);

    logger.d('onUpdateEmailAddressButtonPressed');
    accountFormController.resetState(formMode: FormMode.edit, editTarget: AccountEditTarget.email);
    await appRouter.push(const AccountUpdateEmailAddressRoute());
  }

  Future<void> onUpdatePhoneNumberButtonPressed() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final AccountFormController accountFormController = ref.read(accountFormControllerProvider.notifier);

    logger.d('onUpdatePhoneNumberButtonPressed');
    accountFormController.resetState(formMode: FormMode.edit, editTarget: AccountEditTarget.phone);
    await appRouter.push(const AccountUpdatePhoneNumberRoute());
  }

  Future<void> onUpdatePasswordButtonPressed() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final AccountFormController accountFormController = ref.read(accountFormControllerProvider.notifier);

    logger.d('onUpdatePasswordButtonPressed');
    accountFormController.resetState(formMode: FormMode.edit, editTarget: AccountEditTarget.password);
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
      if (googleSignIn.currentUser != null) {
        logger.d('onDisconnectGoogleProviderPressed: disconnecting google sign in');
        await googleSignIn.disconnect();
      }

      await userController.disconnectSocialProvider(userController.googleProvider!, PositiveSocialProvider.google);
    } catch (e) {
      logger.e('onDisconnectGoogleProviderPressed: $e');
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onDeleteAccountButtonPressed() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final AccountFormController accountFormController = ref.read(accountFormControllerProvider.notifier);

    logger.d('onUpdatePasswordButtonPressed');
    accountFormController.resetState(formMode: FormMode.edit, editTarget: AccountEditTarget.deleteProfile);
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

    logger.d('onConnectAppleUserRequested');
    state = state.copyWith(isBusy: true);

    try {
      logger.d('onConnectAppleUserRequested');
      await userController.registerAppleProvider();

      await appRouter.replace(ProfileEditThanksRoute(
        body: 'You can now use your Apple account to access Positive+1',
        returnStyle: ProfileEditThanksReturnStyle.popToAccountDetails,
      ));
    } catch (e) {
      logger.e('onConnectAppleUserRequested: $e');
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onConnectFacebookUserRequested() async {
    final Logger logger = ref.read(loggerProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);
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
