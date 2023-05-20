// Flutter imports:
import 'package:app/widgets/organisms/profile/vms/profile_view_model.dart';
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
import 'package:app/constants/templates.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:app/providers/user/user_controller.dart';
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

enum UserFeedbackStyle {
  genericFeedback,
  userReport,
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

    logger.d('onEditAccountButtonPressed');

    appRouter.push(const AccountProfileEditSettingsRoute());
  }

  Future<void> onViewProfileButtonSelected() async {
    final ProfileViewModel profileViewModel = ref.read(profileViewModelProvider.notifier);
    final FirebaseAuth auth = ref.read(firebaseAuthProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    logger.d('onViewProfileButtonSelected');
    state = state.copyWith(isBusy: true);

    try {
      await profileViewModel.preloadUserProfile(auth.currentUser!.uid);
    } finally {
      state = state.copyWith(isBusy: false);
    }

    appRouter.push(const ProfileRoute());
  }

  Future<void> onAccountDetailsButtonSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    logger.d('onAccountDetailsButtonSelected');
    appRouter.push(const AccountDetailsRoute());
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

  Future<void> onFeedbackSubmitted(
    BuildContext context, {
    UserFeedbackStyle feedbackStyle = UserFeedbackStyle.genericFeedback,
    Profile? reporter,
    Profile? reportee,
  }) async {
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
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

    String content = state.feedback.content;

    if (feedbackStyle == UserFeedbackStyle.userReport && (reporter == null || reportee == null)) {
      throw Exception('Reporter and reportee must be provided for user reports');
    }

    if (feedbackStyle == UserFeedbackStyle.userReport) {
      content = userReportTemplate(reportee!, reporter!, content);
      await relationshipController.blockRelationship(reportee.flMeta!.id!);
    }

    try {
      final User? user = auth.currentUser;
      if (user == null) {
        logger.e('Cannot send feedback without a user');
        return;
      }

      final HttpsCallable callable = functions.httpsCallable('system-submitFeedback');
      await callable.call(<String, dynamic>{
        'feedback': content,
        'style': feedbackStyle.name,
      });

      logger.d('Feedback sent');
    } catch (ex) {
      logger.e('Failed to send feedback', ex);
    } finally {
      state = state.copyWith(isBusy: false);
      Navigator.pop(context);
    }
  }

  Future<void> onAccountPreferencesRequested(BuildContext context) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    logger.d('onAccountPreferencesRequested');
    await appRouter.push(const AccountPreferencesRoute());
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
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);

    logger.d('onSignOutButtonPressed');
    state = state.copyWith(isBusy: true);

    try {
      Navigator.pop(context);

      await userController.signOut();
      profileController.resetState();
      relationshipController.resetState();
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }
}
