// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/user/user_profile.dart';
import 'package:app/providers/user/profile_controller.dart';
import '../../../../gen/app_router.dart';
import '../../../../hooks/lifecycle_hook.dart';
import '../../../../providers/enuumerations/positive_togglable_state.dart';
import '../../../../services/third_party.dart';

part 'profile_view_model.freezed.dart';
part 'profile_view_model.g.dart';

@freezed
class ProfileViewModelState with _$ProfileViewModelState {
  const factory ProfileViewModelState({
    required String userId,
    @Default(PositiveTogglableState.inactive) PositiveTogglableState pageState,
    @Default(PositiveTogglableState.inactive) PositiveTogglableState connectingState,
    UserProfile? userProfile,
    @Default(0) int followersCount,
    @Default(0) int likesCount,
    @Default(0) int postsCount,
    @Default(0) int contentCount,
    @Default([]) List<UserProfile> notableFollowers,
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
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile View Model] - Loading profile for user: ${state.userId}');

    state = state.copyWith(pageState: PositiveTogglableState.loading);

    try {
      final UserProfile profile = await profileController.getProfileById(state.userId);
      logger.i('[Profile View Model] - Loaded profile: $profile');

      state = state.copyWith(pageState: PositiveTogglableState.active, userProfile: profile);
    } catch (_) {
      logger.e('[Profile View Model] - Failed to load profile');
      state = state.copyWith(pageState: PositiveTogglableState.error, userProfile: null);
      rethrow;
    }
  }

  Future<void> onConnectSelected() async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);

    state = state.copyWith(connectingState: PositiveTogglableState.loading);

    try {
      logger.d('[Profile View Model] - Attempting to connect to user: ${state.userId}');
      await firebaseFunctions.httpsCallable('profileNotifications-sendTestNotification').call(<String, dynamic>{
        'uid': state.userId,
      });
    } finally {
      state = state.copyWith(connectingState: PositiveTogglableState.inactive);
    }
  }

  Future<void> onAccountSelected() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter router = ref.read(appRouterProvider);

    logger.d('[Profile View Model] - Navigating to account page');
    router.removeWhere((_) => true);
    await router.push(const AccountRoute());
  }
}
