// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent_validation/fluent_validation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/constants/auth_constants.dart';
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_back_button.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/indicators/positive_page_indicator.dart';
import 'package:app/widgets/atoms/input/positive_pin_entry.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../providers/system/design_controller.dart';

@RoutePage()
class VerificationDialogPage extends StatefulHookConsumerWidget {
  const VerificationDialogPage({
    required this.onVerified,
    required this.phoneNumber,
    super.key,
  });

  final Future<void> Function() onVerified;
  final String phoneNumber;

  @override
  ConsumerState<VerificationDialogPage> createState() => _VerificationDialogPageState();
}

class VerificationDialogPageValidator extends AbstractValidator<_VerificationDialogPageState> {
  VerificationDialogPageValidator() {
    ruleFor((e) => e.currentPin, key: 'pin').length(6, 6);
  }
}

enum VerificationDialogType {
  linkPhone,
  changePhone,
  verifyPhone,
}

class _VerificationDialogPageState extends ConsumerState<VerificationDialogPage> {
  final VerificationDialogPageValidator validator = VerificationDialogPageValidator();

  List<ValidationError> get pinValidationResults => validator.validate(this).getErrorList('pin');
  bool get isPinValid => pinValidationResults.isEmpty;

  String currentPin = '';
  bool isPinConfirmed = false;
  bool isBusy = false;
  int? forceResendingToken;
  String verificationId = '';
  TextEditingController? pinController;
  FocusNode? pinFocusNode;

  late final VerificationDialogType type;

  String get cacheKey => 'verification_${widget.phoneNumber}';

  double get currentStepIndex {
    switch (type) {
      case VerificationDialogType.linkPhone:
        return 3;
      default:
        return 1;
    }
  }

  int get totalStepIndex {
    switch (type) {
      case VerificationDialogType.linkPhone:
        return 6;
      default:
        return 2;
    }
  }

  @override
  void initState() {
    super.initState();

    if (!providerContainer.read(userControllerProvider.notifier).isPhoneProviderLinked) {
      type = VerificationDialogType.linkPhone;
    } else if (providerContainer.read(firebaseAuthProvider).currentUser?.phoneNumber != widget.phoneNumber) {
      type = VerificationDialogType.changePhone;
    } else {
      type = VerificationDialogType.verifyPhone;
    }

    // Wait until the first frame to load any data
    WidgetsBinding.instance.addPostFrameCallbackWithAnimationDelay(callback: onFirstRender);
  }

  Future<void> onFirstRender() async {
    restoreVerificationData();

    if (verificationId.isEmpty) {
      onResendCodeRequested();
    } else {
      pinFocusNode?.requestFocus();
    }
  }

  Color getTextFieldTintColor(DesignColorsModel colors) {
    if (currentPin.isEmpty) {
      return colors.purple;
    }

    return isPinConfirmed ? colors.green : colors.red;
  }

  void restoreVerificationData() {
    final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);
    final Map<String, dynamic>? verificationData = cacheController.getFromCache(cacheKey);

    if (verificationData != null) {
      verificationId = verificationData['verificationId'] as String;
      forceResendingToken = verificationData['forceResendingToken'] as int?;
    }
  }

  void persistVerificationData(String verificationId, int? forceResendingToken) {
    final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

    // Make a new map using the phone number, verification id, and force resending token
    final Map<String, dynamic> verificationData = <String, dynamic>{
      'phoneNumber': widget.phoneNumber,
      'verificationId': verificationId,
      'forceResendingToken': forceResendingToken,
    };

    cacheController.addToCache(cacheKey, verificationData);
    verificationId = verificationId;
    forceResendingToken = forceResendingToken;
  }

  void clearVerificationData() {
    final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);
    cacheController.removeFromCache(cacheKey);

    verificationId = '';
    forceResendingToken = null;
  }

  Future<void> onResendCodeRequested() async {
    final Logger logger = providerContainer.read(loggerProvider);
    final FirebaseAuth auth = providerContainer.read(firebaseAuthProvider);

    setState(() => isBusy = true);

    try {
      logger.i('Resending verification code to ${widget.phoneNumber}');
      await auth.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        codeSent: onPhoneVerificationCodeSent,
        codeAutoRetrievalTimeout: onPhoneVerificationCodeTimeout,
        verificationCompleted: onPhoneVerificationComplete,
        verificationFailed: onPhoneVerificationFailed,
        forceResendingToken: forceResendingToken,
      );
    } catch (ex) {
      onPhoneVerificationFailed(null);
    }
  }

  void onPinChanged(String pin) {
    currentPin = pin;
    isPinConfirmed = false;

    if (mounted) {
      setState(() {});
    }

    onPinConfirmed();
  }

  Future<void> onPinConfirmed() async {
    if (!isPinValid) {
      return;
    }

    await PositiveScaffold.dismissKeyboardIfPresent(context);

    final PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: currentPin,
    );

    await onPhoneVerificationComplete(phoneAuthCredential);
  }

  void onPhoneVerificationCodeTimeout(String verificationId) {
    final Logger logger = providerContainer.read(loggerProvider);
    final AppRouter router = providerContainer.read(appRouterProvider);

    clearVerificationData();

    if (!mounted) {
      return;
    }

    logger.i('Verification code timeout, returning to previous page');
    router.removeLast();
  }

  Future<void> onPhoneVerificationComplete(PhoneAuthCredential phoneAuthCredential) async {
    final User user = providerContainer.read(firebaseAuthProvider).currentUser!;

    if (mounted) {
      setState(() => isBusy = true);
    }

    try {
      switch (type) {
        case VerificationDialogType.linkPhone:
          await user.linkWithCredential(phoneAuthCredential);
          break;
        case VerificationDialogType.changePhone:
          await user.updatePhoneNumber(phoneAuthCredential);
          break;
        case VerificationDialogType.verifyPhone:
          await user.reauthenticateWithCredential(phoneAuthCredential);
          break;
      }

      isPinConfirmed = true;
      clearVerificationData();
    } finally {
      if (mounted) {
        setState(() => isBusy = false);
      }
    }
  }

  Future<void> onContinuePressed() async {
    final AppRouter router = providerContainer.read(appRouterProvider);
    final Logger logger = providerContainer.read(loggerProvider);

    if (!isPinConfirmed) {
      logger.e('PIN not confirmed, ignoring continue press');
      return;
    }

    logger.i('User confirmed PIN, returning to previous page');
    await widget.onVerified();

    router.removeLast();
  }

  Future<void> onPhoneVerificationFailed(FirebaseAuthException? error) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final AppRouter router = providerContainer.read(appRouterProvider);

    logger.e('Verification failed, returning to previous page: ${error?.message}');

    clearVerificationData();
    router.removeLast();

    await Future<void>.delayed(kAnimationDurationRegular);
    throw error ?? Exception('Unknown error');
  }

  void onPhoneVerificationCodeSent(String verificationId, int? forceResendingToken) {
    final Logger logger = providerContainer.read(loggerProvider);

    logger.d('Verification code sent: $verificationId to ${widget.phoneNumber} with token $forceResendingToken');
    this.verificationId = verificationId;
    this.forceResendingToken = forceResendingToken;

    if (mounted) {
      setState(() => isBusy = false);
      WidgetsBinding.instance.addPostFrameCallback((_) => pinFocusNode?.requestFocus());
    }
  }

  void onControllerCreated(TextEditingController controller) {
    pinController = controller;
  }

  void onFocusNodeCreated(FocusNode focusNode) {
    pinFocusNode = focusNode;
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    final Color tintColor = getTextFieldTintColor(colors);

    return PositiveScaffold(
      backgroundColor: colors.colorGray1,
      footerWidgets: <Widget>[
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          onTapped: onContinuePressed,
          isDisabled: !isPinConfirmed || isBusy,
          label: type == VerificationDialogType.verifyPhone ? localisations.shared_actions_update : localisations.shared_actions_continue,
        ),
      ],
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const PositiveBackButton(),
                const SizedBox(width: kPaddingSmall),
                PositivePageIndicator(
                  color: colors.black,
                  pagesNum: totalStepIndex,
                  currentPage: currentStepIndex,
                ),
              ],
            ),
            const SizedBox(height: kPaddingMedium),
            Text(
              localisations.page_account_verify_account_title,
              style: typography.styleHero.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingSmall),
            Text(
              localisations.page_account_verify_account_body,
              style: typography.styleBody.copyWith(color: colors.black),
            ),
            const SizedBox(height: kPaddingSmallMedium),
            Align(
              alignment: Alignment.centerLeft,
              child: IntrinsicWidth(
                child: PositiveButton(
                  colors: colors,
                  primaryColor: colors.black,
                  label: localisations.page_account_verify_account_resend_code,
                  style: PositiveButtonStyle.text,
                  size: PositiveButtonSize.small,
                  isDisabled: isBusy,
                  onTapped: onResendCodeRequested,
                ),
              ),
            ),
            const SizedBox(height: kPaddingLarge),
            PositivePinEntry(
              pinLength: kVerificationCodeLength,
              tintColor: tintColor,
              isEnabled: !isBusy && !isPinConfirmed,
              onPinChanged: onPinChanged,
              onControllerCreated: onControllerCreated,
              onFocusNodeCreated: onFocusNodeCreated,
              autofocus: false,
            ),
          ],
        ),
      ],
    );
  }
}
