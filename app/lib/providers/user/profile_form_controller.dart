// Dart imports:
import 'dart:async';

// Package imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/helpers/dialog_helpers.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/typography/positive_bulleted_text.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent_validation/fluent_validation.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/user/profile_controller.dart';
import '../../constants/profile_constants.dart';
import '../../dtos/database/user/user_profile.dart';
import '../../services/third_party.dart';

part 'profile_form_controller.freezed.dart';
part 'profile_form_controller.g.dart';

//* Used as a shared view model for the profile setup and edit pages
@freezed
class ProfileFormState with _$ProfileFormState {
  const factory ProfileFormState({
    required String name,
    required Map<String, bool> visibilityFlags,
    required String displayName,
    required bool isBusy,
    required FormMode formMode,
  }) = _ProfileFormState;

  factory ProfileFormState.fromUserProfile(UserProfile? userProfile, FormMode formMode) {
    final Map<String, bool> visibilityFlags = userProfile?.buildFormVisibilityFlags() ?? {};

    return ProfileFormState(
      name: userProfile?.name ?? '',
      displayName: userProfile?.displayName ?? '',
      visibilityFlags: formMode == FormMode.create ? kDefaultVisibilityFlags : visibilityFlags, //! We assume defaults if in the creation state
      isBusy: false,
      formMode: formMode,
    );
  }
}

class ProfileValidator extends AbstractValidator<ProfileFormState> {
  ProfileValidator() {
    ruleFor((e) => e.name, key: 'name').notEmpty();
    ruleFor((e) => e.displayName, key: 'display_name').notEmpty();
  }
}

@Riverpod(keepAlive: true)
class ProfileFormController extends _$ProfileFormController {
  final ProfileValidator validator = ProfileValidator();

  List<ValidationError> get nameValidationResults => validator.validate(state).getErrorList('name');
  bool get isNameValid => nameValidationResults.isEmpty && !state.isBusy;

  List<ValidationError> get displayNameValidationResults => validator.validate(state).getErrorList('display_name');
  bool get isDisplayNameValid => displayNameValidationResults.isEmpty && !state.isBusy;

  bool get isDisplayingName => state.visibilityFlags[kVisibilityFlagName] ?? true;
  bool get isDisplayingBirthday => state.visibilityFlags[kVisibilityFlagBirthday] ?? true;
  bool get isDisplayingIdentity => state.visibilityFlags[kVisibilityFlagIdentity] ?? true;
  bool get isDisplayingMedical => state.visibilityFlags[kVisibilityFlagMedical] ?? true;
  bool get isDisplayingInterests => state.visibilityFlags[kVisibilityFlagInterests] ?? true;
  bool get isDisplayingLocation => state.visibilityFlags[kVisibilityFlagLocation] ?? true;

  @override
  ProfileFormState build() {
    final ProfileControllerState profileState = ref.read(profileControllerProvider);
    return ProfileFormState.fromUserProfile(profileState.userProfile, FormMode.create);
  }

  void resetState(FormMode formMode) {
    final ProfileControllerState profileState = ref.read(profileControllerProvider);
    state = ProfileFormState.fromUserProfile(profileState.userProfile, formMode);
  }

  List<String> buildVisibilityFlags() {
    final ProfileControllerState profileState = ref.read(profileControllerProvider);
    final List<String> flags = [];

    //* Add existing flags
    if (profileState.userProfile != null) {
      flags.addAll(profileState.userProfile!.visibilityFlags);
    }

    //* Override with new values
    for (final String key in state.visibilityFlags.keys) {
      if (state.visibilityFlags[key] ?? true) {
        flags.add(key);
      }
    }

    return flags;
  }

  void onNameChanged(String value) {
    state = state.copyWith(name: value.trim());
  }

  void onNameVisibilityToggleRequested() {
    final Logger logger = ref.read(loggerProvider);
    logger.i('Toggling name visibility');

    state = state.copyWith(
      visibilityFlags: {
        ...state.visibilityFlags,
        'name': !(state.visibilityFlags['name'] ?? true),
      },
    );
  }

  Future<void> onNameHelpRequested(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    logger.i('Requesting name help');

    final HintDialogRoute hint = buildProfileNameHint(context);
    await appRouter.push(hint);
  }

  void onDisplayNameChanged(String value) {
    state = state.copyWith(displayName: value.trim());
  }

  Future<void> onDisplayNameHelpRequested(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    logger.i('Requesting display name help');

    final HintDialogRoute hint = buildProfileDisplayNameHint(context);
    await appRouter.push(hint);
  }

  Future<void> onNameConfirmed() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    if (!isNameValid) {
      logger.e('Name is invalid');
      return;
    }

    state = state.copyWith(isBusy: true);
    logger.i('Saving name: ${state.name}');

    try {
      final List<String> visibilityFlags = buildVisibilityFlags();
      await profileController.updateName(state.name, visibilityFlags);
      logger.i('Successfully saved name: ${state.name}');
      state = state.copyWith(isBusy: false);

      switch (state.formMode) {
        case FormMode.create:
          appRouter.removeWhere((route) => true);
          await appRouter.push(const HomeRoute());
          break;
        case FormMode.edit:
          await appRouter.pop();
          break;
      }
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onDisplayNameConfirmed() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    if (!isDisplayNameValid) {
      return;
    }

    state = state.copyWith(isBusy: true);
    logger.i('Saving display name: ${state.displayName}');

    try {
      await profileController.updateDisplayName(state.displayName);
      logger.i('Successfully saved display name: ${state.displayName}');
      state = state.copyWith(isBusy: false);

      switch (state.formMode) {
        case FormMode.create:
          appRouter.removeWhere((route) => true);
          await appRouter.push(const HomeRoute());
          break;
        case FormMode.edit:
          await appRouter.pop();
          break;
      }
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }
}
