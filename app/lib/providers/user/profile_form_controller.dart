// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:fluent_validation/fluent_validation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_webservice/places.dart';
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
    required Set<String> interests,
    required Set<String> genders,
    String? hivStatus,
    String? hivStatusCategory,
    required String biography,
    required String accentColor,
    required bool isBusy,
    required FormMode formMode,
    required Map<String, bool> visibilityFlags,
  }) = _ProfileFormState;

  factory ProfileFormState.fromUserProfile(UserProfile? userProfile, FormMode formMode) {
    final Map<String, bool> visibilityFlags = userProfile?.buildFormVisibilityFlags() ?? kDefaultVisibilityFlags;

    return ProfileFormState(
      name: userProfile?.name ?? '',
      displayName: userProfile?.displayName ?? '',
      birthday: userProfile?.birthday ?? '',
      interests: userProfile?.interests ?? {},
      genders: userProfile?.genders ?? {},
      hivStatus: userProfile?.hivStatus,
      biography: userProfile?.biography ?? '',
      accentColor: userProfile?.accentColor ?? '#2BEDE1',
      isBusy: false,
      formMode: formMode,
      visibilityFlags: visibilityFlags,
    );
  }
}

class ProfileValidator extends AbstractValidator<ProfileFormState> {
  static const String under13ValidationCode = "birthday-under16";
  static const String under16ValidationCode = "birthday-under13";

  ProfileValidator() {
    ruleFor((e) => e.name, key: 'name').notEmpty();
    ruleFor((e) => e.displayName, key: 'display_name').notEmpty();
    ruleFor((e) => e.birthday, key: 'birthday').isValidISO8601Date().must((date) => validateAge(date, kAgeRequirement13), null, code: ProfileValidator.under13ValidationCode).must((date) => validateAge(date, kAgeRequirement16), null, code: ProfileValidator.under16ValidationCode);
    ruleFor((e) => e.interests, key: 'interests').isMinimumInterestsLength();
    ruleFor((e) => e.biography, key: 'biography').maxLength(200);
  }

  bool validateAge(dynamic date, int minAge) {
    final DateTime? birthday = DateTime.tryParse(date);
    if (birthday == null) {
      return false;
    }
    return DateTime(birthday.year + minAge, birthday.month, birthday.day).isBefore(DateTime.now());
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

  bool get isUnder13 => birthdayValidationResults.any((e) => e.code == ProfileValidator.under13ValidationCode);

  bool get isUnder16 => birthdayValidationResults.any((e) => e.code == ProfileValidator.under16ValidationCode);

  List<ValidationError> get interestsValidationResults => validator.validate(state).getErrorList('interests');

  bool get isBiographyValid => biographyValidationResults.isEmpty && !state.isBusy;

  List<ValidationError> get biographyValidationResults => validator.validate(state).getErrorList('biography');

  bool get isInterestsValid => interestsValidationResults.isEmpty && !state.isBusy;

  bool get isDisplayingName => state.visibilityFlags[kVisibilityFlagName] ?? kDefaultVisibilityFlags[kVisibilityFlagName] ?? true;

  bool get isDisplayingBirthday => state.visibilityFlags[kVisibilityFlagBirthday] ?? kDefaultVisibilityFlags[kVisibilityFlagBirthday] ?? true;

  bool get isDisplayingIdentity => state.visibilityFlags[kVisibilityFlagIdentity] ?? kDefaultVisibilityFlags[kVisibilityFlagIdentity] ?? true;

  bool get isDisplayingMedical => state.visibilityFlags[kVisibilityFlagMedical] ?? kDefaultVisibilityFlags[kVisibilityFlagMedical] ?? true;

  bool get isDisplayingInterests => state.visibilityFlags[kVisibilityFlagInterests] ?? kDefaultVisibilityFlags[kVisibilityFlagInterests] ?? true;

  bool get isDisplayingGender => state.visibilityFlags[kVisibilityFlagGenders] ?? kDefaultVisibilityFlags[kVisibilityFlagGenders] ?? true;

  bool get isDisplayingLocation => state.visibilityFlags[kVisibilityFlagLocation] ?? kDefaultVisibilityFlags[kVisibilityFlagLocation] ?? true;

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
    if (state.formMode == FormMode.edit) {
      return onBackEdit(type);
    }

    return onBackCreate(type);
  }

  Future<bool> onBackCreate(Type type) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    logger.i('Navigating back to create page');

    switch (type) {
      case ProfileDisplayNameEntryRoute:
        appRouter.removeWhere((_) => true);
        appRouter.push(const ProfileNameEntryRoute());
        break;

      case ProfileBirthdayEntryRoute:
        appRouter.removeWhere((_) => true);
        appRouter.push(const ProfileDisplayNameEntryRoute());
        break;

      case ProfileHivStatusRoute:
        appRouter.removeWhere((_) => true);
        appRouter.push(const ProfileGenderSelectRoute());
        break;

      case ProfileInterestsEntryRoute:
        appRouter.removeWhere((_) => true);
        appRouter.push(const ProfileHivStatusRoute());
        break;
      case ProfileGenderSelectRoute:
        appRouter.removeWhere((_) => true);
        appRouter.push(const ProfileBirthdayEntryRoute());
        break;
      case ProfileLocationRoute:
        appRouter.removeWhere((_) => true);
        appRouter.push(const ProfileInterestsEntryRoute());
        break;

      case ProfileReferenceImageWelcomeRoute:
        appRouter.removeWhere((_) => true);
        appRouter.push(const ProfileLocationRoute());
        break;

      case ProfilePhotoRoute:
        appRouter.removeWhere((_) => true);
        appRouter.push(const ProfileReferenceImageWelcomeRoute());
        break;

      case ProfileBiographyEntryRoute:
        appRouter.removeWhere((_) => true);
        appRouter.push(const ProfilePhotoRoute());
        break;
      default:
        logger.e('Unknown route type: $type');
        break;
    }

    return false;
  }

  Future<bool> onBackEdit(Type type) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    logger.i('Navigating back to create page');
    appRouter.replace(const AccountProfileEditSettingsRoute());
    return false;
  }

  Set<String> buildVisibilityFlags() {
    final ProfileControllerState profileState = ref.read(profileControllerProvider);
    final Set<String> flags = {};

    //* Add existing flags
    if (profileState.userProfile != null) {
      flags.addAll(profileState.userProfile!.visibilityFlags);
    }

    //* Override with new values
    for (final String key in state.visibilityFlags.keys) {
      if (state.visibilityFlags[key] ?? true) {
        flags.add(key);
      } else {
        flags.remove(key);
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
      final Set<String> visibilityFlags = buildVisibilityFlags();
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

  Future<void> onDisplayNameConfirmed(String thanksDescription) async {
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
          await appRouter.replace(ProfileEditThanksRoute(body: thanksDescription));
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
    final today = DateTime.now();
    DateTime initialDate = DateTime(today.year - kAgeRequirement16, today.month, today.day);
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
      final Set<String> visibilityFlags = buildVisibilityFlags();
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

    final Set<String> interests = {...state.interests};
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

  Future<void> onHivStatusHelpRequested(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    logger.i('Requesting interests help');

    final HintDialogRoute hint = buildProfileHivStatusHint(context);
    await appRouter.push(hint);
  }

  Future<void> onInterestsConfirmed({required String thanksDescription}) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    state = state.copyWith(isBusy: true);
    logger.i('Saving interests');

    try {
      final Set<String> visibilityFlags = buildVisibilityFlags();
      await profileController.updateInterests(state.interests, visibilityFlags);
      logger.i('Successfully saved interests');
      state = state.copyWith(isBusy: false);

      switch (state.formMode) {
        case FormMode.create:
          appRouter.removeWhere((route) => true);
          await appRouter.push(const HomeRoute());
          break;
        case FormMode.edit:
          await appRouter.replace(ProfileEditThanksRoute(body: thanksDescription));
          break;
      }
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  void onHivStatusVisibilityToggleRequested() {
    final Logger logger = ref.read(loggerProvider);
    logger.i('Toggling hiv status visibility');

    state = state.copyWith(
      visibilityFlags: {
        ...state.visibilityFlags,
        kVisibilityFlagHivStatus: !(state.visibilityFlags[kVisibilityFlagHivStatus] ?? true),
      },
    );
  }

  void onHivStatusToggled(String status) {
    final Logger logger = ref.read(loggerProvider);
    logger.i('Toggling status: $status');
    if (status == state.hivStatus) {
      state = state.copyWith(hivStatus: null);
    } else {
      state = state.copyWith(hivStatus: status);
    }
  }

  void onHivStatusCategoryToggled(String category) {
    final Logger logger = ref.read(loggerProvider);
    logger.i('Toggling hiv category status: $category');
    if (category == state.hivStatusCategory) {
      state = state.copyWith(hivStatusCategory: null, hivStatus: null);
    } else {
      state = state.copyWith(hivStatusCategory: category, hivStatus: null);
    }
  }

  void onHivStatusConfirm({required String thanksDescription}) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    state = state.copyWith(isBusy: true);
    logger.i('Saving hiv status');

    try {
      final Set<String> visibilityFlags = buildVisibilityFlags();
      await profileController.updateHivStatus(state.hivStatus ?? "", visibilityFlags);
      logger.i('Successfully saved hiv status');
      state = state.copyWith(isBusy: false);

      switch (state.formMode) {
        case FormMode.create:
          appRouter.removeWhere((route) => true);
          await appRouter.push(const HomeRoute());
          break;
        case FormMode.edit:
          await appRouter.replace(ProfileEditThanksRoute(body: thanksDescription));
          break;
      }
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  void onGenderSelected(String option) {
    // only update the state if the options have been fetched
    final Set<String> selectedOptions = {...state.genders};
    if (selectedOptions.contains(option)) {
      selectedOptions.remove(option);
    } else {
      selectedOptions.add(option);
    }

    state = state.copyWith(genders: selectedOptions);
  }

  Future<void> onGenderHelpRequested(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    logger.i('Requesting interests help');

    final HintDialogRoute hint = buildProfileGenderHint(context);
    await appRouter.push(hint);
  }

  void onGenderVisibilityToggleRequested() {
    final Logger logger = ref.read(loggerProvider);
    logger.i('Toggling genders visibility');

    state = state.copyWith(
      visibilityFlags: {
        ...state.visibilityFlags,
        kVisibilityFlagGenders: !(state.visibilityFlags[kVisibilityFlagGenders] ?? true),
      },
    );
  }

  Future<void> onGenderConfirmed(String thanksDescription) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    state = state.copyWith(isBusy: true);
    logger.i('Saving genders');

    try {
      final Set<String> visibilityFlags = buildVisibilityFlags();
      await profileController.updateGenders(state.genders, visibilityFlags);
      logger.i('Successfully saved genders');
      state = state.copyWith(isBusy: false);

      switch (state.formMode) {
        case FormMode.create:
          appRouter.removeWhere((route) => true);
          await appRouter.push(const HomeRoute());
          break;
        case FormMode.edit:
          await appRouter.replace(ProfileEditThanksRoute(body: thanksDescription));
          break;
      }
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  void onLocationVisibilityToggleRequested() {
    final Logger logger = ref.read(loggerProvider);
    logger.i('Toggling location visibility');

    state = state.copyWith(
      visibilityFlags: {
        ...state.visibilityFlags,
        kVisibilityFlagLocation: !(state.visibilityFlags[kVisibilityFlagLocation] ?? true),
      },
    );
  }

  Future<void> onLocationHelpRequested(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    logger.i('Requesting interests help');

    final HintDialogRoute hint = buildProfileLocationHint(context);
    await appRouter.push(hint);
  }

  Future<void> onLocationConfirmed(Location? location, String thanksDescription) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    state = state.copyWith(isBusy: true);
    logger.i('Saving location');

    try {
      final Set<String> visibilityFlags = buildVisibilityFlags();
      await profileController.updateLocation(location, visibilityFlags);
      logger.i('Successfully saved location');
      state = state.copyWith(isBusy: false);

      switch (state.formMode) {
        case FormMode.create:
          appRouter.removeWhere((route) => true);
          await appRouter.push(const HomeRoute());
          break;
        case FormMode.edit:
          await appRouter.replace(ProfileEditThanksRoute(body: thanksDescription));
          break;
      }
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  void onAccentColorSelected(String color) {
    state = state.copyWith(accentColor: color);
  }

  void onBiographyChanged(String biography) {
    state = state.copyWith(biography: biography);
  }

  Future<void> onBiographyAndAccentColorConfirmed() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    state = state.copyWith(isBusy: true);
    logger.i('Saving biography and accent color');

    try {
      final biographyFuture = profileController.updateBiography(state.biography);
      final colorFuture = profileController.updateAccentColor(state.accentColor);
      await Future.wait([biographyFuture, colorFuture]);

      logger.i('Successfully saved biography and accent color');
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
