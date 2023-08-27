// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:fluent_validation/fluent_validation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/geo/positive_place.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/validator_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/location/location_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/atoms/dropdowns/positive_modal_dropdown.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/profile/profile_about_page.dart';
import 'package:app/widgets/organisms/shared/positive_camera_dialog.dart';
import '../../constants/country_constants.dart';
import '../../constants/profile_constants.dart';
import '../../dtos/database/profile/profile.dart';
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
    @Default(false) bool isFocused,
    @Default('') String locationSearchQuery,
    @Default(false) bool hasFailedLocationSearch,
    PositivePlace? place,
    required bool isBusy,
    required FormMode formMode,
    required Map<String, bool> visibilityFlags,
    required String newProfileImagePath,
  }) = _ProfileFormState;

  factory ProfileFormState.fromProfile(Profile? profile, FormMode formMode) {
    final Map<String, bool> visibilityFlags = profile?.buildFormVisibilityFlags() ?? kDefaultVisibilityFlags;

    return ProfileFormState(
      name: profile?.name ?? '',
      displayName: profile?.displayName ?? '',
      birthday: profile?.birthday ?? '',
      interests: profile?.interests ?? {},
      genders: profile?.genders ?? {},
      hivStatus: profile?.hivStatus,
      biography: profile?.biography ?? '',
      accentColor: profile?.accentColor ?? '#2BEDE1',
      place: profile?.place,
      locationSearchQuery: profile?.place?.description ?? '',
      isBusy: false,
      formMode: formMode,
      visibilityFlags: visibilityFlags,
      newProfileImagePath: '',
    );
  }
}

class ProfileValidator extends AbstractValidator<ProfileFormState> {
  static const String under13ValidationCode = "birthday-under13";

  ProfileValidator() {
    ruleFor((e) => e.name, key: 'name').notEmpty().isAlphaNumericWithSpaces();
    ruleFor((e) => e.displayName, key: 'display_name').isDisplayNameLength().isAlphaNumericWithSpaces().isProfane();
    ruleFor((e) => e.birthday, key: 'birthday').isValidISO8601Date().must((date) => validateAge(date, kAgeRequirement13), null, code: ProfileValidator.under13ValidationCode).must((date) => validateAge(date, kAgeRequirement13), null, code: ProfileValidator.under13ValidationCode);
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
  TextEditingController? locationSearchQueryController;

  List<ValidationError> get nameValidationResults => validator.validate(state).getErrorList('name');

  bool get isNameValid => nameValidationResults.isEmpty && !state.isBusy;

  List<ValidationError> get displayNameValidationResults => validator.validate(state).getErrorList('display_name');

  bool get isDisplayNameValid => displayNameValidationResults.isEmpty && !state.isBusy;

  List<ValidationError> get birthdayValidationResults => validator.validate(state).getErrorList('birthday');

  bool get isBirthdayValid => birthdayValidationResults.isEmpty && !state.isBusy;

  bool get isUnder13 => birthdayValidationResults.any((e) => e.code == ProfileValidator.under13ValidationCode);

  List<ValidationError> get interestsValidationResults => validator.validate(state).getErrorList('interests');

  bool get isBiographyValid => biographyValidationResults.isEmpty && !state.isBusy;

  List<ValidationError> get biographyValidationResults => validator.validate(state).getErrorList('biography');

  bool get isInterestsValid => interestsValidationResults.isEmpty && !state.isBusy;

  bool get isDisplayingName => state.visibilityFlags[kVisibilityFlagName] ?? kDefaultVisibilityFlags[kVisibilityFlagName] ?? true;

  bool get isDisplayingBirthday => state.visibilityFlags[kVisibilityFlagBirthday] ?? kDefaultVisibilityFlags[kVisibilityFlagBirthday] ?? true;

  bool get isDisplayingIdentity => state.visibilityFlags[kVisibilityFlagIdentity] ?? kDefaultVisibilityFlags[kVisibilityFlagIdentity] ?? true;

  bool get isDisplayingInterests => state.visibilityFlags[kVisibilityFlagInterests] ?? kDefaultVisibilityFlags[kVisibilityFlagInterests] ?? true;

  bool get isDisplayingGender => state.visibilityFlags[kVisibilityFlagGenders] ?? kDefaultVisibilityFlags[kVisibilityFlagGenders] ?? true;

  bool get isDisplayingLocation => state.visibilityFlags[kVisibilityFlagLocation] ?? kDefaultVisibilityFlags[kVisibilityFlagLocation] ?? true;

  @override
  ProfileFormState build() {
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    return ProfileFormState.fromProfile(profileController.state.currentProfile, FormMode.create);
  }

  void resetState(FormMode formMode) {
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    state = ProfileFormState.fromProfile(profileController.state.currentProfile, formMode);
  }

  Future<bool> onBackSelected(Type type) async {
    if (state.formMode == FormMode.edit) {
      return await onBackEdit();
    }

    return await onBackCreate(type);
  }

  void onFocusedChanged(bool isFocused) {
    state = state.copyWith(isFocused: isFocused);
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

      case ProfileAboutPage:
        // currently this
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

      case ProfilePhotoSelectionRoute:
        appRouter.removeWhere((_) => true);
        appRouter.push(const ProfileReferenceImageWelcomeRoute());
        break;

      case ProfileBiographyEntryRoute:
        appRouter.removeWhere((_) => true);
        appRouter.push(const ProfilePhotoSelectionRoute());
        break;
      default:
        logger.e('Unknown route type: $type');
        break;
    }

    return false;
  }

  Future<bool> onBackEdit() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    logger.i('Navigating back to edit page');
    appRouter.removeLast();

    return false;
  }

  Set<String> buildVisibilityFlags() {
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final Set<String> flags = {};

    //* Add existing flags
    if (profileController.state.currentProfile != null) {
      flags.addAll(profileController.state.currentProfile!.visibilityFlags);
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

  void onNameVisibilityToggleRequested(BuildContext context) {
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

  Future<void> onDisplayNameConfirmed(BuildContext context, String thanksDescription) async {
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
    DateTime initialDate = DateTime(today.year - kAgeRequirement13, today.month, today.day);
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

  void onBirthdayVisibilityToggleRequested(BuildContext context) {
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

    // Check 13 years old requirement
    final DateTime birthday = DateTime.parse(state.birthday);
    final DateTime today = DateTime.now();
    final DateTime thirteenYearsAgo = DateTime(today.year - kAgeRequirement13, today.month, today.day);

    if (birthday.isAfter(thirteenYearsAgo)) {
      logger.e('User is not 13 years old, navigating to age requirement screen');
      await appRouter.push(const ProfileDeleteAccountRoute());
      return;
    }

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

  void onInterestsVisibilityToggleRequested(BuildContext context) {
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

  void onHivStatusVisibilityToggleRequested(BuildContext context) {
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

  void onGenderVisibilityToggleRequested(BuildContext context) {
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

  void onLocationSearchQueryChanged(String str) {
    state = state.copyWith(locationSearchQuery: str);

    if (str.isEmpty && state.place != null) {
      state = state.copyWith(place: null, hasFailedLocationSearch: false);
    }
  }

  void onLocationSearchQueryControllerChanged(TextEditingController controller) {
    locationSearchQueryController = controller;
  }

  void onhasFailedLocationSearch(bool hasFailed) {
    state = state.copyWith(hasFailedLocationSearch: hasFailed);
  }

  void onLocationVisibilityToggleRequested(BuildContext context) {
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

  void setLocationText(String text) {
    if (locationSearchQueryController?.hasListeners ?? false) {
      locationSearchQueryController?.text = text;
    }
  }

  Future<void> onLocationSearchQuerySubmitted(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    final LocationController locationController = ref.read(locationControllerProvider.notifier);
    final BuildContext context = ref.read(appRouterProvider).navigatorKey.currentContext!;

    await PositiveScaffold.dismissKeyboardIfPresent(context);

    if (state.locationSearchQuery.isEmpty) {
      return;
    }

    state = state.copyWith(isBusy: true);

    try {
      logger.i('Searching for location: ${state.locationSearchQuery}');
      final List<PositivePlace> results = await locationController.searchLocation(state.locationSearchQuery, includeLocationAsRegion: true);
      if (results.isEmpty) {
        setLocationText('');
        state = state.copyWith(hasFailedLocationSearch: true, place: null);
        return;
      }

      if (results.length == 1) {
        setLocationText(results.first.description);
        state = state.copyWith(place: results.first, hasFailedLocationSearch: false);
        return;
      }

      final PositivePlace? selectedValue = await PositiveModalDropdown.show<PositivePlace>(
        context,
        values: results,
        valueStringBuilder: (value) => value.description,
      );

      if (selectedValue == null || selectedValue.description.isEmpty || selectedValue.placeId.isEmpty) {
        return;
      }

      setLocationText(selectedValue.description);
      state = state.copyWith(place: selectedValue, hasFailedLocationSearch: false);
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onAutoFindLocation() async {
    final Logger logger = ref.read(loggerProvider);
    final LocationController locationController = ref.read(locationControllerProvider.notifier);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final BuildContext context = appRouter.navigatorKey.currentContext!;

    try {
      logger.i('Auto finding location');
      state = state.copyWith(isBusy: true);
      final List<PositivePlace> places = await locationController.searchNearby();

      if (places.isEmpty) {
        locationSearchQueryController?.text = '';
        state = state.copyWith(hasFailedLocationSearch: true, place: null);
        return;
      }

      state = state.copyWith(hasFailedLocationSearch: false);
      if (places.length == 1) {
        setLocationText(places.first.description);
        state = state.copyWith(place: places.first, hasFailedLocationSearch: false);
        return;
      }

      final PositivePlace? selectedValue = await PositiveModalDropdown.show<PositivePlace>(
        context,
        values: places,
        valueStringBuilder: (value) => value.description,
      );

      if (selectedValue == null) {
        return;
      }

      setLocationText(selectedValue.description);
      state = state.copyWith(place: selectedValue, hasFailedLocationSearch: false);
    } on PermissionStatus catch (_) {
      state = state.copyWith(hasFailedLocationSearch: true);
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onRemoveLocation() async {
    final Logger logger = ref.read(loggerProvider);
    if (state.place?.placeId == null) {
      return;
    }

    logger.i('Removing location');
    state = state.copyWith(isBusy: true);

    try {
      setLocationText('');
      state = state.copyWith(place: null, hasFailedLocationSearch: false);
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onLocationSkipped({bool removeLocation = true}) async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final AppRouter appRouter = ref.read(appRouterProvider);
    logger.i('Skipping location');

    if (removeLocation) {
      state = state.copyWith(place: null);
    }

    final bool hasSamePlace = profileController.state.currentProfile?.place?.placeId == state.place?.placeId;
    final bool hasSameDescription = profileController.state.currentProfile?.place?.description == state.locationSearchQuery;

    final bool isNullLocation = (hasSamePlace && hasSameDescription) && profileController.state.currentProfile?.place?.placeId == null;
    final bool isDifferentLocation = (!hasSamePlace || !hasSameDescription) && removeLocation;
    final bool shouldNotifyBackend = isNullLocation || isDifferentLocation;

    if (shouldNotifyBackend) {
      await onLocationConfirmed();
      return;
    }

    switch (state.formMode) {
      case FormMode.create:
        appRouter.removeUntil((route) => true);
        await appRouter.push(const HomeRoute());
        break;
      case FormMode.edit:
        appRouter.removeLast();
        break;
    }
  }

  Future<void> onLocationConfirmed() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final BuildContext context = appRouter.navigatorKey.currentContext!;

    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    logger.i('Saving location');
    state = state.copyWith(isBusy: true);

    try {
      final Set<String> visibilityFlags = buildVisibilityFlags();
      await profileController.updatePlace(state.place, visibilityFlags);

      logger.i('Successfully saved location');
      state = state.copyWith(isBusy: false);

      switch (state.formMode) {
        case FormMode.create:
          appRouter.removeWhere((route) => true);
          await appRouter.push(const HomeRoute());
          break;
        case FormMode.edit:
          await appRouter.replace(ProfileEditThanksRoute(body: localizations.shared_profile_edit_confirmation_body));
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

  Future<void> onBiographyConfirmed(String thanksDescription) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    final BuildContext context = appRouter.navigatorKey.currentContext!;

    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    state = state.copyWith(isBusy: true);
    logger.i('Saving biography');

    try {
      await profileController.updateBiography(state.biography);

      logger.i('Successfully saved biography');
      state = state.copyWith(isBusy: false);

      switch (state.formMode) {
        case FormMode.create:
          appRouter.removeWhere((route) => true);
          await appRouter.push(const HomeRoute());
          break;
        case FormMode.edit:
          await appRouter.replace(ProfileEditThanksRoute(body: localizations.shared_profile_edit_confirmation_body));
          break;
      }
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onAccentColorConfirmed() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final BuildContext context = appRouter.navigatorKey.currentState!.context;
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    state = state.copyWith(isBusy: true);
    logger.i('Saving accent color');

    final bool shouldUpdateProfileImage = state.formMode == FormMode.edit && state.newProfileImagePath.isNotEmpty;
    final bool shouldUpdateAccentColor = state.formMode == FormMode.edit && state.accentColor.isNotEmpty && state.accentColor != profileController.state.currentProfile?.accentColor;

    try {
      // If the user has selected a new profile image, upload it as this is in the same form.
      final List<Future<void>> futures = <Future<void>>[
        if (shouldUpdateAccentColor) ...<Future<void>>[
          profileController.updateAccentColor(state.accentColor),
        ],
        if (shouldUpdateProfileImage) ...<Future<void>>[
          profileController.updateProfileImage(state.newProfileImagePath),
        ],
      ];

      await Future.wait(futures);

      logger.i('Successfully saved accent color');
      state = state.copyWith(isBusy: false);

      switch (state.formMode) {
        case FormMode.create:
          appRouter.removeWhere((route) => true);
          await appRouter.push(const HomeRoute());
          break;
        case FormMode.edit:
          await appRouter.replace(ProfileEditThanksRoute(body: localizations.shared_profile_edit_confirmation_body));
          break;
      }
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onBiographyAndAccentColorConfirmed() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    state = state.copyWith(isBusy: true);
    logger.i('Saving biography and accent color');

    try {
      await profileController.updateBiography(state.biography);
      await profileController.updateAccentColor(state.accentColor);

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

  Future<void> onChangeImageFromCameraSelected(BuildContext context) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    logger.d("onSelectCamera");
    await appRouter.pop();

    final XFile? result = await showCupertinoDialog(
      context: context,
      builder: (_) {
        return const PositiveCameraDialog();
      },
    );

    if (result == null || result.path.isEmpty) {
      logger.d("onSelectCamera: result is null or not a string");
      return;
    }

    logger.d("onSelectCamera: result is $result");
    state = state.copyWith(newProfileImagePath: result.path);
  }

  Future<void> onChangeImageFromPickerSelected(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final ImagePicker picker = ref.read(imagePickerProvider);

    await appRouter.pop();

    logger.d("[ProfilePhotoViewModel] onImagePicker [start]");
    state = state.copyWith(isBusy: true);

    try {
      final XFile? picture = await picker.pickImage(source: ImageSource.gallery);
      if (picture == null) {
        logger.d("onImagePicker: picture is null");
        return;
      }

      state = state.copyWith(newProfileImagePath: picture.path);
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

  Future<void> onDeleteAccountSelected(BuildContext context) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);

    logger.i('Deleting account');

    logger.i('Account deletion confirmed');
    state = state.copyWith(isBusy: true);

    try {
      await userController.deleteAccount();
      logger.i('Account deleted');
      await appRouter.replace(const HomeRoute());
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }
}
