// Dart imports:
import 'dart:async';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent_validation/fluent_validation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/user/profile_controller.dart';
import '../../services/third_party.dart';

part 'profile_form_controller.freezed.dart';
part 'profile_form_controller.g.dart';

//* Used as a shared view model for the profile setup and edit pages
@freezed
class ProfileFormState with _$ProfileFormState {
  const factory ProfileFormState({
    required String name,
    required String displayName,
    required bool isBusy,
    required FormMode formMode,
  }) = _ProfileFormState;

  factory ProfileFormState.initialState() => const ProfileFormState(
        name: '',
        displayName: '',
        isBusy: false,
        formMode: FormMode.create,
      );
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

  @override
  ProfileFormState build() {
    return ProfileFormState.initialState();
  }

  void resetState() {
    state = ProfileFormState.initialState();
  }

  void onNameChanged(String value) {
    state = state.copyWith(name: value.trim());
  }

  void onDisplayNameChanged(String value) {
    state = state.copyWith(displayName: value.trim());
  }

  Future<void> onNameConfirmed() async {
    //TODO(andy): implement saving name
  }

  Future<void> onDisplayNameConfirmed() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);

    if (!isDisplayNameValid || firebaseAuth.currentUser == null) {
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
