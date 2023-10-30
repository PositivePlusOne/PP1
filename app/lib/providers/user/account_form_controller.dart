// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent_validation/factories/abstract_validator.dart';
import 'package:fluent_validation/models/validation_error.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:app/extensions/string_extensions.dart';
import 'package:app/extensions/validator_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/system/system_controller.dart';
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
    required Locale locale,
    FormMode formMode = FormMode.create,
    AccountEditTarget editTarget = AccountEditTarget.email,
  }) =>
      AccountFormState(
        emailAddress: '',
        password: '',
        country: Country.fromLocale(locale),
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
      ruleFor((e) => e.emailAddress, key: 'email');
    }

    if (currentPhoneNumber.isNotEmpty) {
      ruleFor((e) => e.phoneNumber.buildPhoneNumber(e.country), key: 'phone');
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

  bool get doesNewPhoneNumberMatchCurrent => state.phoneNumber.buildPhoneNumber(state.country) == providerContainer.read(profileControllerProvider).currentProfile?.phoneNumber;

  List<ValidationError> get pinValidationResults => validator.validate(state).getErrorList('pin');
  bool get isPinValid => pinValidationResults.isEmpty;

  @override
  AccountFormState build(Locale locale) {
    return AccountFormState.initialState(locale: locale);
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

  void resetState(Locale locale, {FormMode formMode = FormMode.create, AccountEditTarget editTarget = AccountEditTarget.email}) {
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    validator = NewAccountValidator(
      currentEmailAddress: profileController.state.currentProfile?.email ?? '',
      currentPhoneNumber: profileController.state.currentProfile?.phoneNumber ?? '',
    );

    state = AccountFormState.initialState(locale: locale, formMode: formMode, editTarget: editTarget);
    if (formMode == FormMode.edit) {
      String country = '';
      String phoneNumber = '';
      if (profileController.state.currentProfile?.phoneNumber.isNotEmpty == true) {
        (String, String) numberComponents = (profileController.state.currentProfile!.phoneNumber).formatPhoneNumberIntoComponents();
        country = numberComponents.$1;
        phoneNumber = numberComponents.$2;
      }

      state = state.copyWith(
        emailAddress: profileController.state.currentProfile!.email,
        phoneNumber: phoneNumber,
        country: Country.fromPhoneCode(country) ?? Country.fromLocale(locale),
      );
    } else {
      state = state.copyWith(
        emailAddress: '',
        phoneNumber: '',
        country: Country.fromLocale(locale),
      );
    }
  }

  void onEmailAddressChanged(String value) {
    state = state.copyWith(emailAddress: value.trim());
  }

  void onPhoneNumberChanged(String value) {
    state = state.copyWith(phoneNumber: value.trim());
  }

  void onCountryChanged(Country? value) {
    if (value == null) {
      return;
    }

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
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final Logger logger = ref.read(loggerProvider);

    try {
      logger.d('Deleting account');
      if (firebaseAuth.currentUser == null) {
        throw Exception('User is not signed in');
      }

      await profileController.deleteProfile();
      if (profileController.isCurrentlyOrganisation) {
        profileController.switchProfile(firebaseAuth.currentUser!.uid);
        return;
      }

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
    final AppLocalizations localisations = AppLocalizations.of(appRouter.navigatorKey.currentContext!)!;

    logger.d('Updating email address to: ${state.emailAddress}');
    if (!isEmailValid) {
      logger.e('Email address is not valid');
      return;
    }

    state = state.copyWith(isBusy: true);

    try {
      //? User profiles are bound to firebase auth users, so we need to update the email address of the firebase auth user
      if (profileController.isCurrentlyUserProfile) {
        final UserController userController = ref.read(userControllerProvider.notifier);
        logger.d('Updating email address of the authenticated user');
        await userController.updateEmailAddress(state.emailAddress);
      }

      //? Then we need to update the email address of the profile
      await profileController.updateEmailAddress(emailAddress: state.emailAddress);

      final AccountUpdatedRoute route = AccountUpdatedRoute(
        title: localisations.page_account_actions_change_email_address_updated_title,
        body: localisations.page_account_actions_change_email_address_updated_body,
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
    final SystemController systemController = ref.read(systemControllerProvider.notifier);

    if (!isPasswordValid) {
      return;
    }

    logger.d('Creating new account with email provider');
    state = state.copyWith(isBusy: true);

    try {
      if (userController.currentUser == null) {
        await userController.registerEmailPasswordProvider(state.emailAddress, state.password);
      } else {
        await userController.linkEmailPasswordProvider(state.emailAddress, state.password);
      }

      await systemController.updateSystemConfiguration();
      state = state.copyWith(isBusy: false);
      appRouter.removeWhere((route) => true);
      await appRouter.push(const RegistrationAccountSetupRoute());
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

  Future<void> onPhoneNumberConfirmed(BuildContext context) async {
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
      logger.e('Error verifying phone number. $ex');
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
