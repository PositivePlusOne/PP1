// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:

part 'profile_view_model.freezed.dart';
part 'profile_view_model.g.dart';

@freezed
class ProfileViewModelState with _$ProfileViewModelState {
  const factory ProfileViewModelState({
    @Default(false) bool isBusy,
    Object? currentError,
  }) = _ProfileViewModelState;

  factory ProfileViewModelState.initialState() => const ProfileViewModelState();
}

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  @override
  ProfileViewModelState build() {
    return ProfileViewModelState.initialState();
  }
}
