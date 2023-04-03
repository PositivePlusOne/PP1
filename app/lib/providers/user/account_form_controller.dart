// Dart imports:
import 'dart:async';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:fluent_validation/factories/abstract_validator.dart';
import 'package:fluent_validation/models/validation_error.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/constants/country_constants.dart';
import 'package:app/events/authentication/phone_verification_failed_event.dart';
import 'package:app/extensions/validator_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/user/profile_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import '../../dtos/localization/country.dart';
import '../../events/authentication/phone_verification_code_sent_event.dart';
import '../../events/authentication/phone_verification_complete_event.dart';
import '../../events/authentication/phone_verification_timeout_event.dart';
import '../../services/third_party.dart';
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
    ruleFor((e) => e.emailAddress, key: 'email').isValidEmailAddress();
    ruleFor((e) => e.password, key: 'password').meetsPasswordComplexity();
    ruleFor((e) => e.country, key: 'phone-prefix').notNull();
    ruleFor((e) => e.phoneNumber, key: 'phone').isValidPhoneNumber();
    ruleFor((e) => e.pin, key: 'pin').length(6, 6);

    if (currentEmailAddress.isNotEmpty) {
      ruleFor((e) => e.emailAddress, key: 'email').notEqual(currentEmailAddress);
    }

    if (currentPhoneNumber.isNotEmpty) {
      ruleFor((e) => e.phoneNumber, key: 'phone').notEqual(currentPhoneNumber);
    }
  }

  final String currentEmailAddress;
  final String currentPhoneNumber;
}

enum AccountEditTarget {
  email,
  phone,
  password,
}

@Riverpod(keepAlive: true)
class AccountFormController extends _$AccountFormController {
  StreamSubscription<PhoneVerificationTimeoutEvent>? phoneTimeoutSubscription;
  StreamSubscription<PhoneVerificationFailedEvent>? phoneFailedSubscription;
  StreamSubscription<PhoneVerificationCodeSentEvent>? phoneCodeSentSubscription;
  StreamSubscription<PhoneVerificationCompleteEvent>? phoneCompleteSubscription;

  NewAccountValidator validator = NewAccountValidator();

  List<ValidationError> get emailValidationResults => validator.validate(state).getErrorList('email');
  bool get isEmailValid => emailValidationResults.isEmpty;

  List<ValidationError> get passwordValidationResults => validator.validate(state).getErrorList('password');
  bool get isPasswordValid => passwordValidationResults.isEmpty;

  List<ValidationError> get phoneValidationResults => validator.validate(state).getErrorList('phone');
  bool get isPhoneValid => phoneValidationResults.isEmpty;

  List<ValidationError> get pinValidationResults => validator.validate(state).getErrorList('pin');
  bool get isPinValid => pinValidationResults.isEmpty;

  @override
  AccountFormState build() {
    return AccountFormState.initialState();
  }

  void resetState({FormMode formMode = FormMode.create, AccountEditTarget editTarget = AccountEditTarget.email}) {
    phoneTimeoutSubscription?.cancel();
    phoneFailedSubscription?.cancel();
    phoneCodeSentSubscription?.cancel();
    phoneCompleteSubscription?.cancel();

    final ProfileControllerState profileState = ref.read(profileControllerProvider);

    validator = NewAccountValidator(
      currentEmailAddress: profileState.userProfile?.email ?? '',
      currentPhoneNumber: profileState.userProfile?.phoneNumber ?? '',
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

  Future<void> onEmailAddressConfirmed() async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    if (!isEmailValid) {
      return;
    }

    if (state.formMode == FormMode.create) {
      logger.d('Creating new account with email: ${state.emailAddress}');
      await appRouter.push(const RegistrationPasswordEntryRoute());
    }

    if (state.formMode == FormMode.edit) {
      logger.d('Updating email address to: ${state.emailAddress}');
      final String phoneNumber = userController.state.user?.phoneNumber ?? '';
      if (phoneNumber.isEmpty) {
        throw Exception('User does not have a mobile number');
      }

      await onVerificationRequested();
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

    if (state.formMode == FormMode.edit) {
      logger.d('Updating password');
      final String phoneNumber = userController.state.user?.phoneNumber ?? '';
      if (phoneNumber.isEmpty) {
        throw Exception('User does not have a mobile number');
      }

      await onVerificationRequested();
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

    if (!isPinValid) {
      logger.e('Pin is not valid');
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

    if (!isPinValid) {
      logger.e('Pin is not valid');
      return;
    }

    state = state.copyWith(isBusy: true);

    try {
      final String phoneNumber = buildPhoneNumber();

      final UserController userController = ref.read(userControllerProvider.notifier);
      await userController.updatePhoneNumber(state.pin);
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

  Future<void> onVerificationRequested() async {
    final Logger logger = ref.read(loggerProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);
    final EventBus eventBus = ref.read(eventBusProvider);

    state = state.copyWith(isBusy: true);

    try {
      final String actualPhoneNumber = userController.state.user?.phoneNumber ?? '';
      if (actualPhoneNumber.isEmpty) {
        logger.e('Phone number is not valid');
        return;
      }

      await phoneCompleteSubscription?.cancel();
      await phoneTimeoutSubscription?.cancel();
      await phoneFailedSubscription?.cancel();
      await phoneCodeSentSubscription?.cancel();

      phoneCompleteSubscription = eventBus.on<PhoneVerificationCompleteEvent>().listen(onPhoneVerificationComplete);
      phoneTimeoutSubscription = eventBus.on<PhoneVerificationTimeoutEvent>().listen(onPhoneVerificationTimeout);
      phoneFailedSubscription = eventBus.on<PhoneVerificationFailedEvent>().listen(onPhoneVerificationFailed);
      phoneCodeSentSubscription = eventBus.on<PhoneVerificationCodeSentEvent>().listen(onPhoneVerificationCodeSent);

      // All routes here redirect on success, via a callback.
      await userController.verifyPhoneNumber(actualPhoneNumber);
    } catch (ex) {
      logger.e('Error verifying existing phone number', ex);
      state = state.copyWith(isBusy: false);
    }
  }

  String buildPhoneNumber() {
    final StringBuffer phoneNumberBuffer = StringBuffer();

    if (!state.phoneNumber.startsWith('+')) {
      phoneNumberBuffer.write('+${state.country.phoneCode}');
    }

    if (state.phoneNumber.startsWith('0')) {
      phoneNumberBuffer.write(state.phoneNumber.substring(1));
    } else {
      phoneNumberBuffer.write(state.phoneNumber);
    }

    final String actualPhoneNumber = phoneNumberBuffer.toString();
    return actualPhoneNumber;
  }

  Future<void> onPhoneNumberConfirmed() async {
    final Logger logger = ref.read(loggerProvider);
    final EventBus eventBus = ref.read(eventBusProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);

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

      await phoneCompleteSubscription?.cancel();
      await phoneTimeoutSubscription?.cancel();
      await phoneFailedSubscription?.cancel();
      await phoneCodeSentSubscription?.cancel();

      phoneCompleteSubscription = eventBus.on<PhoneVerificationCompleteEvent>().listen(onPhoneVerificationComplete);
      phoneTimeoutSubscription = eventBus.on<PhoneVerificationTimeoutEvent>().listen(onPhoneVerificationTimeout);
      phoneFailedSubscription = eventBus.on<PhoneVerificationFailedEvent>().listen(onPhoneVerificationFailed);
      phoneCodeSentSubscription = eventBus.on<PhoneVerificationCodeSentEvent>().listen(onPhoneVerificationCodeSent);

      // All routes here redirect on success, via a callback.
      await userController.verifyPhoneNumber(actualPhoneNumber);
    } catch (ex) {
      logger.e('Error verifying phone number', ex);
      state = state.copyWith(isBusy: false);
    }
  }

  void onPhoneVerificationFailed(PhoneVerificationFailedEvent event) {
    state = state.copyWith(isBusy: false);
  }

  void onPhoneVerificationTimeout(PhoneVerificationTimeoutEvent event) {
    state = state.copyWith(isBusy: false);
  }

  void onPhoneVerificationCodeSent(PhoneVerificationCodeSentEvent event) {
    state = state.copyWith(isBusy: false);

    final AppRouter appRouter = ref.read(appRouterProvider);
    appRouter.removeWhere((route) => true);

    //* Go to verification page for registration
    if (state.formMode == FormMode.create) {
      appRouter.push(const HomeRoute());
    }

    //* Go to verification page for updates
    if (state.formMode == FormMode.edit) {
      const String title = 'Verification';
      String body = 'We have sent a verification code to your phone number. Please enter it below to confirm.';
      Future Function()? onVerificationSuccess;

      switch (state.editTarget) {
        case AccountEditTarget.email:
          onVerificationSuccess = onChangeEmailRequested;
          break;
        case AccountEditTarget.password:
          onVerificationSuccess = onChangePasswordRequested;
          break;
        case AccountEditTarget.phone:
          body = 'We have sent a verification code to your new phone number. Please enter it below to confirm.';
          onVerificationSuccess = onChangePhoneNumberRequested;
          break;
      }

      final AccountVerificationRoute route = AccountVerificationRoute(
        title: title,
        body: body,
        onVerificationSuccess: onVerificationSuccess,
      );

      appRouter.push(route);
    }
  }

  Future<void> onPinConfirmed() async {
    if (!isPinValid) {
      return;
    }

    state = state.copyWith(isBusy: true);

    try {
      final UserController userController = ref.read(userControllerProvider.notifier);

      //* If the edit target is a new phone number, then we skip reauthentication
      if (state.editTarget == AccountEditTarget.phone) {
        onPhoneVerificationComplete(null);
        return;
      }

      if (userController.isUserLoggedIn && userController.isPhoneProviderLinked) {
        await userController.reauthenticatePhoneProvider(state.pin);
      } else if (userController.isUserLoggedIn) {
        await userController.linkPhoneProvider(state.pin);
      } else {
        await userController.signInWithPhoneProvider(state.pin);
      }

      onPhoneVerificationComplete(null);
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  void onPhoneVerificationComplete(PhoneVerificationCompleteEvent? event) {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.i('Phone verification complete, navigating to next page');
    state = state.copyWith(isBusy: false);

    //* Go to next page or home during account setup
    if (state.formMode == FormMode.create) {
      logger.d('Create form mode, navigating to home');
      appRouter.removeWhere((route) => true);
      appRouter.push(const HomeRoute());
    }

    //* Perform edit actions and continue
    if (state.formMode == FormMode.edit) {
      logger.d('Edit form mode, performing edit actions');
      switch (state.editTarget) {
        case AccountEditTarget.email:
          onChangeEmailRequested();
          break;
        case AccountEditTarget.phone:
          onChangePhoneNumberRequested();
          break;
        case AccountEditTarget.password:
          onChangePasswordRequested();
          break;
      }
    }
  }
}
