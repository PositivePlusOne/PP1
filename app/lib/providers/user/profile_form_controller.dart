// Dart imports:
import 'dart:async';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fluent_validation/fluent_validation.dart';

part 'profile_form_controller.freezed.dart';
part 'profile_form_controller.g.dart';

@freezed
class ProfileFormState with _$ProfileFormState {
  const factory ProfileFormState({
    required String name,
    required bool isBusy,
    Object? currentError,
  }) = _ProfileFormState;

  factory ProfileFormState.initialState() => const ProfileFormState(name: '', isBusy: false);
}

class ProfileValidator extends AbstractValidator<ProfileFormState> {
  ProfileValidator() {
    ruleFor((e) => e.name, key: 'name').notEmpty();
  }
}

@Riverpod(keepAlive: true)
class ProfileFormController extends _$ProfileFormController {
  final ProfileValidator validator = ProfileValidator();

  List<ValidationError> get nameValidationResults => validator.validate(state).getErrorList('name');
  bool get isNameValid => nameValidationResults.isEmpty && !state.isBusy;

  @override
  ProfileFormState build() {
    return ProfileFormState.initialState();
  }

  void onNameChanged(String value) {
    state = state.copyWith(name: value.trim());
  }

  Future<void> onNameConfirmed() async {
    //TODO(andy): implement saving name
  }
}
