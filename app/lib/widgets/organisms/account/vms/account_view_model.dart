// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent_validation/factories/abstract_validator.dart';
import 'package:fluent_validation/models/validation_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/organisms/account/dialogs/account_feedback_dialog.dart';
import 'package:app/widgets/organisms/account/dialogs/account_sign_out_dialog.dart';
import '../../../../dtos/database/feedback/user_feedback.dart';
import '../../../../hooks/lifecycle_hook.dart';
import '../../../../services/third_party.dart';
import '../../../molecules/dialogs/positive_dialog.dart';

part 'account_view_model.freezed.dart';
part 'account_view_model.g.dart';

@freezed
class AccountViewModelState with _$AccountViewModelState {
  const factory AccountViewModelState({
    @Default(false) bool isBusy,
    required UserFeedback feedback,
  }) = _AccountViewModelState;

  factory AccountViewModelState.initialState() => AccountViewModelState(
        feedback: UserFeedback.empty(),
      );
}

class UserFeedbackValidator extends AbstractValidator<UserFeedback> {
  UserFeedbackValidator() {
    ruleFor((e) => e.content, key: 'content').minLength(AccountFeedbackDialog.kFeedbackMinimumLength);
    ruleFor((e) => e.content, key: 'content').maxLength(AccountFeedbackDialog.kFeedbackMaximumLength);
  }
}

@riverpod
class AccountViewModel extends _$AccountViewModel with LifecycleMixin {
  final UserFeedbackValidator userFeedbackValidator = UserFeedbackValidator();

  @override
  AccountViewModelState build() {
    return AccountViewModelState.initialState();
  }

  Future<void> onBackButtonPressed() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    logger.d('onBackButtonPressed');
    appRouter.removeLast();
  }

  Future<void> onEditAccountButtonPressed() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    throw UnimplementedError();
    // logger.d('onEditAccountButtonPressed');
    // appRouter.push(const EditAccountRoute());
  }

  Future<void> onProvideFeedbackButtonPressed(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('onProvideFeedbackButtonPressed');

    state = state.copyWith(
      feedback: state.feedback.copyWith(content: ''),
    );

    await PositiveDialog.show(
      context: context,
      dialog: const AccountFeedbackDialog(),
    );
  }

  void onFeedbackUpdated(String content) {
    state = state.copyWith(
      feedback: state.feedback.copyWith(content: content.trim()),
    );
  }

  Future<void> onFeedbackSubmitted(BuildContext context) async {
    final FirebaseFunctions functions = ref.read(firebaseFunctionsProvider);
    final FirebaseAuth auth = ref.read(firebaseAuthProvider);
    final Logger logger = ref.read(loggerProvider);

    logger.d('onFeedbackSubmitted');
    logger.d(state.feedback.content);

    final ValidationResult validationResult = userFeedbackValidator.validate(state.feedback);
    if (validationResult.hasError) {
      logger.e('Feedback is invalid');
      return;
    }

    state = state.copyWith(isBusy: true);

    try {
      final User? user = auth.currentUser;
      if (user == null) {
        logger.e('Cannot send feedback without a user');
        return;
      }

      final HttpsCallable callable = functions.httpsCallable('system-submitFeedback');
      await callable.call(<String, dynamic>{
        'feedback': state.feedback.content,
      });

      logger.d('Feedback sent');
    } catch (ex) {
      logger.e('Failed to send feedback', ex);
    } finally {
      state = state.copyWith(isBusy: false);
      Navigator.pop(context);
    }
  }

  Future<void> onSignOutRequested(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('onSignOutRequested');

    await PositiveDialog.show(
      context: context,
      dialog: const AccountSignOutDialog(),
    );
  }

  Future<void> onSignOutConfirmed(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);

    logger.d('onSignOutButtonPressed');
    await userController.signOut();
  }
}
