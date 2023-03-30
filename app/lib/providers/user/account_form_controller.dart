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
  }) = _AccountFormState;

  factory AccountFormState.initialState({
    FormMode formMode = FormMode.create,
  }) =>
      AccountFormState(
        emailAddress: '',
        password: '',
        country: kCountryList.firstWhere((element) => element.phoneCode == '44'),
        phoneNumber: '',
        pin: '',
        isBusy: false,
        formMode: formMode,
      );
}

class NewAccountValidator extends AbstractValidator<AccountFormState> {
  NewAccountValidator() {
    ruleFor((e) => e.emailAddress, key: 'email').isValidEmailAddress();
    ruleFor((e) => e.password, key: 'password').meetsPasswordComplexity();
    ruleFor((e) => e.country, key: 'phone-prefix').notNull();
    ruleFor((e) => e.phoneNumber, key: 'phone').isValidPhoneNumber();
    ruleFor((e) => e.pin, key: 'pin').length(6, 6);
  }
}

@Riverpod(keepAlive: true)
class AccountFormController extends _$AccountFormController {
  StreamSubscription<PhoneVerificationTimeoutEvent>? phoneTimeoutSubscription;
  StreamSubscription<PhoneVerificationFailedEvent>? phoneFailedSubscription;
  StreamSubscription<PhoneVerificationCodeSentEvent>? phoneCodeSentSubscription;
  StreamSubscription<PhoneVerificationCompleteEvent>? phoneCompleteSubscription;

  final NewAccountValidator validator = NewAccountValidator();

  List<ValidationError> get emailValidationResults => validator.validate(state).getErrorList('email');
  bool get isEmailValid => emailValidationResults.isEmpty && !state.isBusy;

  List<ValidationError> get passwordValidationResults => validator.validate(state).getErrorList('password');
  bool get isPasswordValid => passwordValidationResults.isEmpty && !state.isBusy;

  List<ValidationError> get phoneValidationResults => validator.validate(state).getErrorList('phone');
  bool get isPhoneValid => phoneValidationResults.isEmpty && !state.isBusy;

  List<ValidationError> get pinValidationResults => validator.validate(state).getErrorList('pin');
  bool get isPinValid => pinValidationResults.isEmpty && !state.isBusy;

  @override
  AccountFormState build() {
    return AccountFormState.initialState();
  }

  void resetState({FormMode formMode = FormMode.create}) {
    phoneTimeoutSubscription?.cancel();
    phoneFailedSubscription?.cancel();
    phoneCodeSentSubscription?.cancel();
    phoneCompleteSubscription?.cancel();

    state = AccountFormState.initialState(formMode: formMode);

    if (formMode == FormMode.edit) {
      // TODO: Preload details
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
    if (!isEmailValid) {
      return;
    }

    final AppRouter appRouter = ref.read(appRouterProvider);
    await appRouter.push(const RegistrationPasswordEntryRoute());
  }

  Future<void> onPasswordConfirmed() async {
    if (!isPasswordValid) {
      return;
    }

    state = state.copyWith(isBusy: true);

    try {
      final UserController userController = ref.read(userControllerProvider.notifier);
      final AppRouter appRouter = ref.read(appRouterProvider);

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

  Future<void> onPhoneNumberConfirmed() async {
    if (!isPhoneValid) {
      return;
    }

    state = state.copyWith(isBusy: true);

    try {
      final UserController userController = ref.read(userControllerProvider.notifier);
      final EventBus eventBus = ref.read(eventBusProvider);

      final StringBuffer phoneNumberBuffer = StringBuffer();
      phoneNumberBuffer.write('+${state.country.phoneCode}');
      if (state.phoneNumber.startsWith('0')) {
        phoneNumberBuffer.write(state.phoneNumber.substring(1));
      } else {
        phoneNumberBuffer.write(state.phoneNumber);
      }

      final String actualPhoneNumber = phoneNumberBuffer.toString();

      phoneCompleteSubscription = eventBus.on<PhoneVerificationCompleteEvent>().listen(onPhoneVerificationComplete);
      phoneTimeoutSubscription = eventBus.on<PhoneVerificationTimeoutEvent>().listen(onPhoneVerificationTimeout);
      phoneFailedSubscription = eventBus.on<PhoneVerificationFailedEvent>().listen(onPhoneVerificationFailed);
      phoneCodeSentSubscription = eventBus.on<PhoneVerificationCodeSentEvent>().listen(onPhoneVerificationCodeSent);

      // Navigation in this case is handled by the phone auth provider.
      await userController.verifyPhoneNumber(actualPhoneNumber);
    } finally {
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
    final AppRouter appRouter = ref.read(appRouterProvider);
    appRouter.removeWhere((route) => true);

    //* Go to next page or home during account setup
    if (state.formMode == FormMode.create) {
      appRouter.push(const HomeRoute());
    }

    //* Go to success placeholder page
    if (state.formMode == FormMode.edit) {
      appRouter.push(const HomeRoute());
    }
  }

  Future<void> onPinConfirmed() async {
    if (!isPinValid) {
      return;
    }

    state = state.copyWith(isBusy: true);

    try {
      final UserController userController = ref.read(userControllerProvider.notifier);

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

    //* Go to next page or home during account setup
    if (state.formMode == FormMode.create) {
      logger.d('Create form mode, navigating to home');
      appRouter.removeWhere((route) => true);
      appRouter.push(const HomeRoute());
    }

    //* Go to success placeholder page
    if (state.formMode == FormMode.edit) {
      logger.d('Edit form mode, navigating to completion view');
      appRouter.removeWhere((route) => true);
      appRouter.push(const HomeRoute());
    }
  }
}
