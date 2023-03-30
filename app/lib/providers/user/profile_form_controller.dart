// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:auto_route/src/route/page_route_info.dart';
import 'package:fluent_validation/fluent_validation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/validator_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/user/profile_controller.dart';
import '../../constants/country_constants.dart';
import '../../constants/profile_constants.dart';
import '../../dtos/database/user/user_profile.dart';
import '../../helpers/dialog_hint_helpers.dart';
import '../../helpers/dialog_picker_helpers.dart';
import '../../services/third_party.dart';

part 'profile_form_controller.freezed.dart';
part 'profile_form_controller.g.dart';

//* Used as a shared view model for the profile setup and edit pages
@freezed
class ProfileFormState with _$ProfileFormState {
  const factory ProfileFormState({
    required String name,
    required String displayName,
    required String birthday,
    required List<String> interests,
    required Map<String, bool> visibilityFlags,
    required bool isBusy,
    required FormMode formMode,
  }) = _ProfileFormState;

  factory ProfileFormState.fromUserProfile(UserProfile? userProfile, FormMode formMode) {
    final Map<String, bool> visibilityFlags = userProfile?.buildFormVisibilityFlags() ?? {};

    return ProfileFormState(
      name: userProfile?.name ?? '',
      displayName: userProfile?.displayName ?? '',
      birthday: userProfile?.birthday ?? '',
      interests: userProfile?.interests ?? [],
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
    ruleFor((e) => e.birthday, key: 'birthday').isValidISO8601Date();
    ruleFor((e) => e.interests, key: 'interests').isMinimumInterestsLength();
  }
}

@Riverpod(keepAlive: true)
class ProfileFormController extends _$ProfileFormController {
  final ProfileValidator validator = ProfileValidator();

  TextEditingController? birthdayTextController;

  List<ValidationError> get nameValidationResults => validator.validate(state).getErrorList('name');
  bool get isNameValid => nameValidationResults.isEmpty && !state.isBusy;

  List<ValidationError> get displayNameValidationResults => validator.validate(state).getErrorList('display_name');
  bool get isDisplayNameValid => displayNameValidationResults.isEmpty && !state.isBusy;

  List<ValidationError> get birthdayValidationResults => validator.validate(state).getErrorList('birthday');
  bool get isBirthdayValid => birthdayValidationResults.isEmpty && !state.isBusy;

  List<ValidationError> get interestsValidationResults => validator.validate(state).getErrorList('interests');
  bool get isInterestsValid => interestsValidationResults.isEmpty && !state.isBusy;

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

  Future<bool> onBackSelected(Type type) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    logger.i('Navigating back');

    switch (type) {
      case ProfileDisplayNameEntryRoute:
        appRouter.removeWhere((_) => true);
        appRouter.push(const ProfileNameEntryRoute());
        break;
      case ProfileBirthdayEntryRoute:
        appRouter.removeWhere((_) => true);
        appRouter.push(const ProfileDisplayNameEntryRoute());
        break;
      case ProfileInterestsEntryRoute:
        appRouter.removeWhere((_) => true);
        // TODO(ryan): Update this.
        appRouter.push(const ProfileBirthdayEntryRoute());
        break;
      default:
        logger.e('Unknown route type: $type');
        break;
    }

    return false;
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

  void onBirthdayTextControllerCreated(TextEditingController controller) {
    final Logger logger = ref.read(loggerProvider);
    logger.i('Text controller attached to birthday field');

    birthdayTextController = controller;
  }

  void onChangeBirthdayRequested(BuildContext context) async {
    DateTime initialDate = DateTime.now().subtract(kMinimumAgeRequirement);
    if (state.birthday.isNotEmpty) {
      initialDate = DateTime.parse(state.birthday);
    }

    final DateTime? newBirthday = await showPositiveDatePickerDialog(
      context,
      initialDate: initialDate,
      lastDate: DateTime.now(),
    );

    if (newBirthday != null) {
      onBirthdayChanged(newBirthday);
    }
  }

  void onBirthdayChanged(DateTime value) {
    final Logger logger = ref.read(loggerProvider);
    logger.i('Updating birthday: $value');

    birthdayTextController?.text = kDefaultDateFormat.format(value);
    state = state.copyWith(birthday: value.toIso8601String());
  }

  void onBirthdayVisibilityToggleRequested() {
    final Logger logger = ref.read(loggerProvider);
    logger.i('Toggling birthday visibility');

    state = state.copyWith(
      visibilityFlags: {
        ...state.visibilityFlags,
        'birthday': !(state.visibilityFlags['birthday'] ?? true),
      },
    );
  }

  Future<void> onBirthdayHelpRequested(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    logger.i('Requesting birthday help');

    final HintDialogRoute hint = buildProfileBirthdayHint(context);
    await appRouter.push(hint);
  }

  Future<void> onBirthdayConfirmed() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    if (!isBirthdayValid) {
      return;
    }

    state = state.copyWith(isBusy: true);
    logger.i('Saving birthday: ${state.birthday}');

    try {
      final List<String> visibilityFlags = buildVisibilityFlags();
      await profileController.updateBirthday(state.birthday, visibilityFlags);
      logger.i('Successfully saved birthday: ${state.birthday}');
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

  void onInterestToggled(String interestKey) {
    final Logger logger = ref.read(loggerProvider);
    logger.i('Toggling interest: $interestKey');

    final List<String> interests = [...state.interests];
    if (interests.contains(interestKey)) {
      interests.remove(interestKey);
    } else {
      interests.add(interestKey);
    }

    state = state.copyWith(interests: interests);
  }

  void onInterestsVisibilityToggleRequested() {
    final Logger logger = ref.read(loggerProvider);
    logger.i('Toggling interests visibility');

    state = state.copyWith(
      visibilityFlags: {
        ...state.visibilityFlags,
        'interests': !(state.visibilityFlags['interests'] ?? true),
      },
    );
  }

  Future<void> onInterestsHelpRequested(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    logger.i('Requesting interests help');

    final HintDialogRoute hint = buildProfileInterestsHint(context);
    await appRouter.push(hint);
  }

  Future<void> onInterestsConfirmed() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    state = state.copyWith(isBusy: true);
    logger.i('Saving interests');

    try {
      final List<String> visibilityFlags = buildVisibilityFlags();
      await profileController.updateInterests(state.interests, visibilityFlags);
      logger.i('Successfully saved interests');
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

  Future<void> onProfileSetupContinueSelected(PageRouteInfo route) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    logger.i('Navigating to $route');
    appRouter.removeWhere((route) => true);
    await appRouter.push(route);
  }
}
