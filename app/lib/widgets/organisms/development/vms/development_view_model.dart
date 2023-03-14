// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import '../../../../hooks/lifecycle_hook.dart';
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
}
