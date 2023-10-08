// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent_validation/factories/abstract_validator.dart';
import 'package:fluent_validation/models/validation_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/constants/templates.dart';
import 'package:app/dtos/database/feedback/feedback_type.dart';
import 'package:app/dtos/database/feedback/feedback_wrapper.dart';
import 'package:app/dtos/database/feedback/report_type.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/extensions/validator_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/api.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import 'package:app/widgets/atoms/input/positive_text_field_dropdown.dart';
import 'package:app/widgets/organisms/account/dialogs/account_feedback_dialog.dart';
import 'package:app/widgets/organisms/account/dialogs/account_sign_out_dialog.dart';
import 'package:app/widgets/organisms/profile/vms/profile_view_model.dart';
import '../../../../hooks/lifecycle_hook.dart';
import '../../../../services/third_party.dart';
import '../../../molecules/dialogs/positive_dialog.dart';

part 'account_view_model.freezed.dart';
part 'account_view_model.g.dart';

@freezed
class AccountViewModelState with _$AccountViewModelState {
  const factory AccountViewModelState({
    @Default(false) bool isBusy,
    required FeedbackWrapper feedback,
  }) = _AccountViewModelState;

  factory AccountViewModelState.fromFeedbackType(FeedbackType type) => AccountViewModelState(
        feedback: FeedbackWrapper(
          content: '',
          feedbackType: type,
          reportType: const ReportType.unknown(),
        ),
      );
}

class FeedbackValidator extends AbstractValidator<FeedbackWrapper> {
  FeedbackValidator() {
    ruleFor((e) => e.content, key: 'content').minLength(AccountFeedbackDialog.kFeedbackMinimumLength);
    ruleFor((e) => e.content, key: 'content').maxLength(AccountFeedbackDialog.kFeedbackMaximumLength);
    ruleFor((e) => e, key: 'feedbackType').isValidReportTypeOrNotAReport();
  }
}

@riverpod
class AccountViewModel extends _$AccountViewModel with LifecycleMixin {
  final FeedbackValidator feedbackValidator = FeedbackValidator();

  @override
  AccountViewModelState build(FeedbackType feedbackType) {
    return AccountViewModelState.fromFeedbackType(feedbackType);
  }

  Future<void> onBackButtonPressed() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    logger.d('onBackButtonPressed');
    appRouter.removeLast();
  }

  Future<void> onSwitchProfileRequested() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final String currentProfileId = profileController.state.currentProfile?.flMeta?.id ?? '';
    final CacheController cacheController = ref.read(cacheControllerProvider);
    if (currentProfileId.isEmpty) {
      logger.e('onSwitchProfileRequested: currentProfileId is empty');
      return;
    }

    final Iterable<String> profileIds = profileController.state.availableProfileIds.where((element) => element != currentProfileId);
    final List<Profile> profiles = profileIds.map((e) => cacheController.get(e)).whereNotNull().cast<Profile>().toList();

    logger.d('onSwitchProfileRequested: currentProfileId: $currentProfileId, profileIds: $profileIds, profiles: $profiles');
    if (profiles.isEmpty) {
      logger.e('onSwitchProfileRequested: profiles is empty');
      return;
    }

    logger.d('onSwitchAccountRequested');
    final BuildContext context = appRouter.navigatorKey.currentContext!;
    final Profile? profile = await PositiveTextFieldDropdown.showDropdownDialog<Profile>(
      context: context,
      values: profiles,
      valueStringBuilder: (value) => (value as Profile).displayName,
    );

    final String requestedProfileId = profile?.flMeta?.id ?? '';
    if (requestedProfileId.isEmpty) {
      logger.e('onSwitchProfileRequested: requestedProfileId is empty');
      return;
    }

    logger.d('onSwitchProfileRequested: requestedProfileId: $requestedProfileId');
    profileController.switchProfile(requestedProfileId);
  }

  Future<void> onEditAccountButtonPressed() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    logger.d('onEditAccountButtonPressed');

    appRouter.push(const AccountProfileEditSettingsRoute());
  }

  Future<void> onViewProfileButtonSelected(Profile? currentProfile) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);

    if (currentProfile == null) {
      logger.e('onViewProfileButtonSelected: currentProfile is null');
      return;
    }

    logger.d('onViewProfileButtonSelected');
    state = state.copyWith(isBusy: true);

    try {
      final ProfileViewModel profileViewModel = ref.read(profileViewModelProvider.notifier);
      final String currentProfileId = currentProfile.flMeta?.id ?? '';
      if (currentProfileId.isEmpty) {
        logger.e('onViewProfileButtonSelected: currentProfileId is empty');
        return;
      }

      await profileViewModel.preloadUserProfile(currentProfileId);
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

  Future<void> onPromotedPostsbuttonSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    logger.d('onAccountDetailsButtonSelected');
    appRouter.push(const AccountPromotedPostsRoute());
  }

  Future<void> onMyCommunitiesButtonPressed() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    logger.d('onMyCommunitiesButtonPressed');
    appRouter.push(const AccountCommunitiesRoute());
  }

  Future<void> onProvideFeedbackButtonPressed(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('onProvideFeedbackButtonPressed');

    state = state.copyWith(feedback: FeedbackWrapper.empty());

    await PositiveDialog.show(
      title: 'Provide Feedback',
      context: context,
      child: const AccountFeedbackDialog(),
    );
  }

  void onFeedbackUpdated(String content) {
    state = state.copyWith(
      feedback: state.feedback.copyWith(content: content),
    );
  }

  void onReportTypeUpdated(ReportType reportType) {
    state = state.copyWith(
      feedback: state.feedback.copyWith(reportType: reportType),
    );
  }

  Future<void> onFeedbackSubmitted({
    Profile? reporter,
    Profile? reportee,
  }) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final BuildContext context = appRouter.navigatorKey.currentContext!;
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
    final FirebaseFunctions functions = ref.read(firebaseFunctionsProvider);
    final Logger logger = ref.read(loggerProvider);
    logger.d('onFeedbackSubmitted');

    final ValidationResult validationResult = feedbackValidator.validate(state.feedback);
    if (validationResult.hasError) {
      logger.e('Feedback is invalid');
      return;
    }

    state = state.copyWith(isBusy: true);
    String content = state.feedback.content;

    if (state.feedback.feedbackType == const FeedbackType.userReport() && (reporter == null || reportee == null)) {
      throw Exception('Reporter and reportee must be provided for user reports');
    } else if (state.feedback.feedbackType == const FeedbackType.userReport()) {
      content = userReportTemplate(reportee!, reporter!, content);
      await relationshipController.blockRelationship(reportee.flMeta!.id!);
    }

    try {
      final SystemApiService systemApiService = await ref.read(systemApiServiceProvider.future);
      await systemApiService.submitFeedback(
        content: content,
        feedbackType: state.feedback.feedbackType,
        reportType: state.feedback.reportType,
      );

      await appRouter.pop();
      feedbackType.when(
        unknown: () {},
        userReport: () => ScaffoldMessenger.of(context).showSnackBar(PositiveSnackBar(content: const Text("User Reported"))),
        postReport: () => ScaffoldMessenger.of(context).showSnackBar(PositiveSnackBar(content: const Text("Post Reported"))),
        genericFeedback: () => ScaffoldMessenger.of(context).showSnackBar(PositiveSnackBar(content: const Text("Feedback Sent"))),
      );
    } catch (ex) {
      logger.e('Failed to send feedback. $ex');
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onPostFeedbackSubmitted({
    required Profile? reporter,
    required Profile reportee,
    required String reportedPost,
  }) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final BuildContext context = appRouter.navigatorKey.currentContext!;
    final FirebaseFunctions functions = ref.read(firebaseFunctionsProvider);
    final FirebaseAuth auth = ref.read(firebaseAuthProvider);
    final Logger logger = ref.read(loggerProvider);
    logger.d('onPostFeedbackSubmitted');

    if (state.feedback.feedbackType != const FeedbackType.postReport()) {
      throw Exception('Feedback type must be post report');
    }

    final ValidationResult validationResult = feedbackValidator.validate(state.feedback);
    if (validationResult.hasError) {
      logger.e('Feedback is invalid');
      return;
    }

    state = state.copyWith(isBusy: true);
    final String content = state.feedback.content.trim();
    final String template = postReportTemplate(
      reportedPost,
      reportee,
      reporter ?? Profile.empty(),
      content,
    );

    try {
      final User? user = auth.currentUser;
      if (user == null) {
        logger.e('Cannot send feedback without a user');
        return;
      }

      final HttpsCallable callable = functions.httpsCallable('system-submitFeedback');
      await callable.call(<String, dynamic>{
        'content': template,
        'feedbackType': FeedbackType.toJson(state.feedback.feedbackType),
        'reportType': ReportType.toJson(state.feedback.reportType),
      });

      await appRouter.pop();
      feedbackType.when(
        unknown: () {},
        userReport: () => ScaffoldMessenger.of(context).showSnackBar(PositiveSnackBar(content: const Text("User Reported"))),
        postReport: () => ScaffoldMessenger.of(context).showSnackBar(PositiveSnackBar(content: const Text("Post Reported"))),
        genericFeedback: () => ScaffoldMessenger.of(context).showSnackBar(PositiveSnackBar(content: const Text("Feedback Sent"))),
      );
    } catch (ex) {
      logger.e('Failed to send feedback. $ex');
    } finally {
      state = state.copyWith(isBusy: false);
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
      title: 'Sign Out',
      context: context,
      child: const AccountSignOutDialog(),
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
