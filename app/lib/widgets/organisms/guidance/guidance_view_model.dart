// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import '../../../gen/app_router.dart';
import '../../../services/third_party.dart';

part 'guidance_view_model.freezed.dart';
part 'guidance_view_model.g.dart';

@freezed
class GuidanceViewModelState with _$GuidanceViewModelState {
  const factory GuidanceViewModelState({
    @Default(false) bool isRefreshing,
  }) = _GuidanceViewModelState;

  factory GuidanceViewModelState.initialState() => const GuidanceViewModelState();
}

@riverpod
class GuidanceViewModel extends _$GuidanceViewModel {
  @override
  GuidanceViewModelState build() {
    return GuidanceViewModelState.initialState();
  }

  Future<void> onAccountSelected() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    logger.d('onAccountSelected()');

    if (firebaseAuth.currentUser == null) {
      logger.e('onAccountSelected() - user is null');
      await appRouter.push(const RegistrationAccountRoute());
    } else {
      logger.d('onAccountSelected() - user is not null');
      await appRouter.push(const AccountRoute());
    }
  }

  Future<void> onNotificationsSelected() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d('onNotificationsSelected()');
    await appRouter.push(const NotificationsRoute());
  }
}
