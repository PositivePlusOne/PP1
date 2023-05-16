// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/user/account_form_controller.dart';
import 'package:app/providers/user/user_controller.dart';
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

    if (userController.googleProvider == null) {
      logger.d('onDisconnectGoogleProviderPressed: Google provider is null');
      return;
    }

    logger.d('onDisconnectGoogleProviderPressed');
    state = state.copyWith(isBusy: true);

    try {
      logger.d('onDisconnectGoogleProviderPressed');
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
}
