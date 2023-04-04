// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_preferences_view_model.freezed.dart';
part 'account_preferences_view_model.g.dart';

@freezed
class AccountPreferencesViewModelState with _$AccountPreferencesViewModelState {
  const factory AccountPreferencesViewModelState({
    @Default(false) bool isBusy,
  }) = _AccountPreferencesViewModelState;

  factory AccountPreferencesViewModelState.initialState() => const AccountPreferencesViewModelState();
}

@riverpod
class AccountPreferencesViewModel extends _$AccountPreferencesViewModel {
  @override
  AccountPreferencesViewModelState build() {
    return AccountPreferencesViewModelState.initialState();
  }
}
