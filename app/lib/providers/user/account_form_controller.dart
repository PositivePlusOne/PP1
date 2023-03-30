// Dart imports:
import 'dart:async';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:event_bus/event_bus.dart';
import 'package:fluent_validation/factories/abstract_validator.dart';
import 'package:fluent_validation/models/validation_error.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/constants/country_constants.dart';
import 'package:app/events/authentication/phone_verification_failed_event.dart';
import 'package:app/extensions/validator_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/user/user_controller.dart';
import '../../dtos/localization/country.dart';
import '../../events/authentication/phone_verification_code_sent_event.dart';
import '../../events/authentication/phone_verification_timeout_event.dart';
import '../../services/third_party.dart';

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
  }) = _AccountFormState;

  factory AccountFormState.initialState() => AccountFormState(
        emailAddress: '',
        password: '',
        country: kCountryList.firstWhere((element) => element.phoneCode == '44'),
        phoneNumber: '',
        pin: '',
        isBusy: false,
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

  final NewAccountValidator validator = NewAccountValidator();

  List<ValidationError> get emailValidationResults => validator.validate(state).getErrorList('email');
  bool get isEmailValid => emailValidationResults.isEmpty && !state.isBusy;

  List<ValidationError> get passwordValidationResults => validator.validate(state).getErrorList('password');
  bool get isPasswordValid => passwordValidationResults.isEmpty && !state.isBusy;

  List<ValidationError> get phoneValidationResults => validator.validate(state).getErrorList('phone');
  bool get isPhoneValid => phoneValidationResults.isEmpty && !state.isBusy;

  List<ValidationError> get pinValidationResults => validator.validate(state).getErrorList('pin');
  bool get isPinValid => pinValidationResults.isEmpty && !state.isBusy;

  void onPhoneVerificationFailed(PhoneVerificationFailedEvent event) {
    state = state.copyWith(isBusy: false);
  }

  void onPhoneVerificationTimeout(PhoneVerificationTimeoutEvent event) {
    state = state.copyWith(isBusy: false);
  }

  void onPhoneVerificationCodeSent(PhoneVerificationCodeSentEvent event) {
    state = state.copyWith(isBusy: false);

    phoneTimeoutSubscription?.cancel();
    phoneFailedSubscription?.cancel();
    phoneCodeSentSubscription?.cancel();

    final AppRouter appRouter = ref.read(appRouterProvider);
    appRouter.removeWhere((route) => true);
    appRouter.push(const HomeRoute());
  }

  @override
  AccountFormState build() {
    return AccountFormState.initialState();
  }

  void resetState() {
    state = AccountFormState.initialState();
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

      await phoneTimeoutSubscription?.cancel();
      await phoneFailedSubscription?.cancel();
      await phoneCodeSentSubscription?.cancel();

      phoneTimeoutSubscription = eventBus.on<PhoneVerificationTimeoutEvent>().listen(onPhoneVerificationTimeout);
      phoneFailedSubscription = eventBus.on<PhoneVerificationFailedEvent>().listen(onPhoneVerificationFailed);
      phoneCodeSentSubscription = eventBus.on<PhoneVerificationCodeSentEvent>().listen(onPhoneVerificationCodeSent);

      // Navigation in this case is handled by the phone auth provider.
      await userController.verifyPhoneNumber(actualPhoneNumber);
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onPinConfirmed({
    PageRouteInfo nextRoute = const HomeRoute(),
    bool replaceRoute = true,
  }) async {
    if (!isPinValid) {
      return;
    }

    state = state.copyWith(isBusy: true);

    try {
      final AppRouter appRouter = ref.read(appRouterProvider);
      final UserController userController = ref.read(userControllerProvider.notifier);

      if (userController.isUserLoggedIn && userController.isPhoneProviderLinked) {
      } else if (userController.isUserLoggedIn) {
        await userController.linkPhoneProvider(state.pin);
      } else {
        await userController.registerPhoneProvider(state.pin);
      }

      state = state.copyWith(isBusy: false);
      if (replaceRoute) {
        appRouter.removeWhere((route) => true);
      }

      await appRouter.push(nextRoute);
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }
}
