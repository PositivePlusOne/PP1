// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/user/user_profile.dart';
import '../../../../hooks/lifecycle_hook.dart';

part 'profile_view_model.freezed.dart';
part 'profile_view_model.g.dart';

@freezed
class ProfileViewModelState with _$ProfileViewModelState {
  const factory ProfileViewModelState({
    @Default(false) bool isBusy,
    UserProfile? userProfile,
    required String userId,
  }) = _ProfileViewModelState;

  factory ProfileViewModelState.initialState(String userId) => ProfileViewModelState(userId: userId);
}

@riverpod
class ProfileViewModel extends _$ProfileViewModel with LifecycleMixin {
  @override
  ProfileViewModelState build(String userId) {
    return ProfileViewModelState.initialState(userId);
  }

  @override
  void onFirstRender() {
    loadProfile();
    super.onFirstRender();
  }

  Future<void> loadProfile() async {
    //* Update state
    state = state.copyWith(isBusy: true);

    //* Add fake load to test title
    await Future<void>.delayed(const Duration(seconds: 5));

    try {} finally {
      state = state.copyWith(isBusy: false);
    }
  }
}
