// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/providers/user/profile_controller.dart';
import '../../../../gen/app_router.dart';
import '../../../../helpers/profile_helpers.dart';
import '../../../../hooks/lifecycle_hook.dart';
import '../../../../providers/enumerations/positive_togglable_state.dart';
import '../../../../services/third_party.dart';

part 'profile_view_model.freezed.dart';
part 'profile_view_model.g.dart';

@freezed
class ProfileViewModelState with _$ProfileViewModelState {
  const factory ProfileViewModelState({
    required String userId,
    @Default(PositiveTogglableState.inactive) PositiveTogglableState pageState,
    @Default(PositiveTogglableState.inactive) PositiveTogglableState connectingState,
    Profile? profile,
    @Default(0) int followersCount,
    @Default(0) int likesCount,
    @Default(0) int postsCount,
    @Default(0) int contentCount,
    @Default([]) List<Profile> notableFollowers,
  }) = _ProfileViewModelState;

  factory ProfileViewModelState.initialState(String userId) => ProfileViewModelState(userId: userId);
}

@riverpod
class ProfileViewModel extends _$ProfileViewModel with LifecycleMixin {
  Color get appBarColor => getSafeProfileColorFromHex(state.profile?.accentColor);

  @override
  ProfileViewModelState build(String userId) {
    return ProfileViewModelState.initialState(userId);
  }

  Future<void> onConnectSelected() async {
    final Logger logger = ref.read(loggerProvider);
    logger.i('Not implemented yet');
    // final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);

    // state = state.copyWith(connectingState: PositiveTogglableState.loading);

    // try {
    //   logger.d('[Profile View Model] - Attempting to connect to user: ${state.userId}');
    //   await firebaseFunctions.httpsCallable('profileNotifications-sendTestNotification').call(<String, dynamic>{
    //     'uid': state.userId,
    //   });
    // } finally {
    //   state = state.copyWith(connectingState: PositiveTogglableState.inactive);
    // }
  }

  Future<void> onAccountSelected() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter router = ref.read(appRouterProvider);

    logger.d('[Profile View Model] - Navigating to account page');
    router.removeWhere((_) => true);
    await router.push(const AccountRoute());
  }
}
