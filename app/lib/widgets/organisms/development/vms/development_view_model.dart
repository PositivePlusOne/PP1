// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/user/user_profile.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/providers/user/profile_controller.dart';
import '../../../../hooks/lifecycle_hook.dart';
import '../../../../services/repositories.dart';
import '../../../../services/third_party.dart';

part 'development_view_model.freezed.dart';
part 'development_view_model.g.dart';

@freezed
class DevelopmentViewModelState with _$DevelopmentViewModelState {
  const factory DevelopmentViewModelState({
    @Default('Pending...') String status,
  }) = _DevelopmentViewModelState;

  factory DevelopmentViewModelState.initialState() => const DevelopmentViewModelState();
}

@riverpod
class DevelopmentViewModel extends _$DevelopmentViewModel with LifecycleMixin {
  @override
  DevelopmentViewModelState build() {
    return DevelopmentViewModelState.initialState();
  }

  Future<void> restartApp() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d('Restarting app');
    appRouter.removeWhere((route) => true);
    await appRouter.push(SplashRoute());
  }

  Future<void> deleteProfile() async {
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final AppRouter appRouter = ref.read(appRouterProvider);

    state = state.copyWith(status: 'Deleting profile');
    await profileController.deleteProfile();

    appRouter.removeWhere((route) => true);
    await appRouter.push(SplashRoute());
  }

  Future<void> resetSharedPreferences() async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('Resetting shared preferences');

    state = state.copyWith(status: 'Resetting shared preferences');

    await ref.read(sharedPreferencesProvider).value?.clear();
    state = state.copyWith(status: 'Shared preferences reset');
  }

  Future<void> resetAccount() async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d('Resetting account');

    state = state.copyWith(status: 'Resetting account');
    if (firebaseAuth.currentUser == null) {
      state = state.copyWith(status: 'No user to reset');
      return;
    }

    await firebaseAuth.currentUser!.delete();
    state = state.copyWith(status: 'Account reset');

    appRouter.removeWhere((route) => true);
    await appRouter.push(SplashRoute());
  }

  Future<void> resetCache() async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('Resetting cache');

    state = state.copyWith(status: 'Resetting cache');

    try {
      final Box<UserProfile> userProfileRepository = await ref.read(userProfileRepositoryProvider.future);
      await userProfileRepository.clear();
    } catch (ex) {
      logger.e('Failed to reset cache', ex);
      state = state.copyWith(status: 'Failed to reset cache');
    }
  }

  Future<void> toggleSemanticsDebugger() async {
    final SystemController systemController = ref.read(systemControllerProvider.notifier);
    systemController.toggleSemanticsDebugger();
  }

  Future<void> toggleDebugMessages() async {
    final SystemController systemController = ref.read(systemControllerProvider.notifier);
    systemController.toggleDebugMessages();
  }
}
