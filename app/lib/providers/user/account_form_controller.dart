// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fluent_validation/factories/abstract_validator.dart';
import 'package:fluent_validation/models/validation_error.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:app/constants/country_constants.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/extensions/validator_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/user/pledge_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import '../../dtos/localization/country.dart';
import '../../helpers/dialog_hint_helpers.dart';
import '../../main.dart';
import '../../services/third_party.dart';
import '../profiles/profile_controller.dart';
import '../shared/enumerations/form_mode.dart';

part 'account_form_controller.freezed.dart';
part 'account_form_controller.g.dart';

@freezed
class AccountFormState with _$AccountFormState {
  const factory AccountFormState({
    required String emailAddress,
    required String password,
    required Country country,
    required String phoneNumber,
    required String pin,
    required bool isBusy,
    required FormMode formMode,
    required AccountEditTarget editTarget,
  }) = _AccountFormState;

  factory AccountFormState.initialState({
    FormMode formMode = FormMode.create,
    AccountEditTarget editTarget = AccountEditTarget.email,
  }) =>
      AccountFormState(
        emailAddress: '',
        password: '',
        country: kCountryList.firstWhere((element) => element.phoneCode == '44'),
        phoneNumber: '',
        pin: '',
        isBusy: false,
        formMode: formMode,
        editTarget: editTarget,
      );
}

class NewAccountValidator extends AbstractValidator<AccountFormState> {
  NewAccountValidator({
    this.currentEmailAddress = '',
    this.currentPhoneNumber = '',
  }) {
    ruleFor((e) => e.emailAddress, key: 'email').isFormattedEmailAddress();
    ruleFor((e) => e.password, key: 'password').meetsPasswordComplexity();
    ruleFor((e) => e.country, key: 'phone-prefix').notNull();
    ruleFor((e) => e.phoneNumber, key: 'phone').isValidPhoneNumber();
    ruleFor((e) => e.pin, key: 'pin').length(6, 6);

    if (currentEmailAddress.isNotEmpty) {
      ruleFor((e) => e.emailAddress, key: 'email').notEqual(currentEmailAddress);
    }

    if (currentPhoneNumber.isNotEmpty) {
      ruleFor((e) => e.phoneNumber.buildPhoneNumber(e.country), key: 'phone').notEqual(currentPhoneNumber);
    }
  }

  final String currentEmailAddress;
  final String currentPhoneNumber;
}

enum AccountEditTarget {
  email,
  phone,
  password,
  deleteProfile,
}

@Riverpod(keepAlive: true)
class AccountFormController extends _$AccountFormController {
  NewAccountValidator validator = NewAccountValidator();

  List<ValidationError> get emailValidationResults => validator.validate(state).getErrorList('email');
  bool get isEmailValid => emailValidationResults.isEmpty;

  List<ValidationError> get passwordValidationResults => validator.validate(state).getErrorList('password');
  bool get isPasswordValid => passwordValidationResults.isEmpty;

  //TODO(S): This requires fuller thought, should be viable for usa and uk, this is different for other countries and depends on country code
  //? Possible solution by google at: https://github.com/google/libphonenumber
  List<ValidationError> get phoneValidationResults => validator.validate(state).getErrorList('phone');

  bool get isPhoneValid {
    return (phoneValidationResults.isEmpty && state.phoneNumber.length >= 7 && state.phoneNumber.length <= 11);
  }

  List<ValidationError> get pinValidationResults => validator.validate(state).getErrorList('pin');
  bool get isPinValid => pinValidationResults.isEmpty;

  @override
  AccountFormState build() {
    return AccountFormState.initialState();
  }

  Future<bool> onWillPopScope() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);
    final String currentRoute = appRouter.current.name;

    switch (currentRoute) {
      case RegistrationEmailEntryRoute.name:
      case RegistrationPhoneEntryRoute.name:
        try {
          state = state.copyWith(isBusy: true);
          await userController.signOut();
        } finally {
          state = state.copyWith(isBusy: false);
        }

        await appRouter.replace(const RegistrationAccountRoute());
        break;
      default:
        appRouter.stack.length > 1 ? appRouter.removeLast() : appRouter.replace(const RegistrationAccountRoute());
        break;
    }

    return true;
  }

  void resetState({FormMode formMode = FormMode.create, AccountEditTarget editTarget = AccountEditTarget.email}) {
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    validator = NewAccountValidator(
      currentEmailAddress: profileController.currentProfile?.email ?? '',
      currentPhoneNumber: profileController.currentProfile?.phoneNumber ?? '',
    );

    state = AccountFormState.initialState(formMode: formMode, editTarget: editTarget);
    if (formMode == FormMode.edit) {
      // TODO: Preload details (optional)
    }
  }

  void onEmailAddressChanged(String value) {
    state = state.copyWith(emailAddress: value.trim());
  }

  void onPhoneNumberChanged(String value) {
    state = state.copyWith(phoneNumber: value.trim());
  }

  void onCountryChanged(Country value) {
    state = state.copyWith(country: value);
  }

  void onPasswordChanged(String value) {
    state = state.copyWith(password: value.trim());
  }

  void onPinChanged(String value) {
    state = state.copyWith(pin: value.trim());
  }

  Future<void> onDeleteProfileRequested() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final UserController userController = ref.read(userControllerProvider.notifier);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    final AsyncPledgeController pledgeProvider = providerContainer.read(asyncPledgeControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    try {
      logger.d('Deleting account');
      await profileController.deleteProfile();
      await userController.signOut(shouldNavigate: false);
      await sharedPreferences.clear();
      await pledgeProvider.resetState();

      final AccountUpdatedRoute route = AccountUpdatedRoute(
        body: 'Your account deletion has been started and you will no longer be able to access your account. You will receive an email once your account has been deleted.',
        buttonText: 'Close App',
        onContinueSelected: () async {
          appRouter.removeWhere((route) => true);
          await appRouter.push(const HomeRoute());
        },
      );

      state = state.copyWith(isBusy: false);
      appRouter.removeWhere((route) => true);
      await appRouter.push(route);
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onEmailAddressConfirmed() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    if (!isEmailValid) {
      return;
    }

    if (state.formMode == FormMode.create) {
      logger.d('Creating new account with email: ${state.emailAddress}');
      await appRouter.push(const RegistrationPasswordEntryRoute());
    }
  }

  Future<void> onChangeEmailRequested() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    logger.d('Updating email address to: ${state.emailAddress}');
    if (!isEmailValid) {
      logger.e('Email address is not valid');
      return;
    }

    state = state.copyWith(isBusy: true);

    try {
      final UserController userController = ref.read(userControllerProvider.notifier);
      await userController.updateEmailAddress(state.emailAddress);
      await profileController.updateEmailAddress(emailAddress: state.emailAddress);

      final AccountUpdatedRoute route = AccountUpdatedRoute(
        body: 'Your email address has been changed',
      );

      state = state.copyWith(isBusy: false);
      appRouter.removeWhere((route) => true);
      await appRouter.push(route);
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onPasswordConfirmed() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);

    if (!isPasswordValid) {
      return;
    }

    logger.d('Creating new account with email provider');
    state = state.copyWith(isBusy: true);

    try {
      if (userController.isUserLoggedIn) {
        await userController.linkEmailPasswordProvider(state.emailAddress, state.password);
      } else {
        await userController.registerEmailPasswordProvider(state.emailAddress, state.password);
      }

      //* We remove the busy flag else the router will not call finally until the page is popped.
      state = state.copyWith(isBusy: false);

      await appRouter.push(const HomeRoute());
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onChangePasswordRequested() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    logger.d('Updating password');
    if (!isPasswordValid) {
      logger.e('Password is not valid');
      return;
    }

    state = state.copyWith(isBusy: true);

    try {
      final UserController userController = ref.read(userControllerProvider.notifier);
      await userController.updatePassword(state.password);

      final AccountUpdatedRoute route = AccountUpdatedRoute(
        body: 'Your password has been changed',
      );

      state = state.copyWith(isBusy: false);
      appRouter.removeWhere((route) => true);
      await appRouter.push(route);
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onChangePhoneNumberRequested() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    logger.d('Updating phone number to: ${state.phoneNumber}');
    if (!isPhoneValid) {
      logger.e('Phone number is not valid');
      return;
    }

    state = state.copyWith(isBusy: true);

    try {
      final String phoneNumber = buildPhoneNumber();

      await userController.updatePhoneNumber(phoneNumber);
      await profileController.updatePhoneNumber(phoneNumber: phoneNumber);

      final AccountUpdatedRoute route = AccountUpdatedRoute(
        body: 'Your phone number has been changed',
      );

      state = state.copyWith(isBusy: false);
      appRouter.removeWhere((route) => true);
      await appRouter.push(route);
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  String buildPhoneNumber() {
    return state.phoneNumber.buildPhoneNumber(state.country);
  }

  Future<void> onPhoneNumberConfirmed() async {
    final Logger logger = ref.read(loggerProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final AppRouter appRouter = ref.read(appRouterProvider);

    if (!isPhoneValid) {
      logger.e('Phone number is not valid');
      return;
    }

    state = state.copyWith(isBusy: true);

    try {
      final String actualPhoneNumber = buildPhoneNumber();
      if (actualPhoneNumber.isEmpty) {
        logger.e('Phone number is not valid');
        return;
      }

      await userController.updatePhoneNumber(actualPhoneNumber);
      await profileController.updatePhoneNumber(phoneNumber: actualPhoneNumber);
      appRouter.removeWhere((route) => true);
      await appRouter.push(const HomeRoute());
    } catch (ex) {
      logger.e('Error verifying phone number', ex);
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onPhoneHelpRequested(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    logger.i('Requesting phone help');

    final HintDialogRoute hint = buildAccountPhoneHint(context);
    await appRouter.push(hint);
  }
}
