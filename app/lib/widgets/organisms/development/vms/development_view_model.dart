// Package imports:
import 'package:app/providers/system/notifications_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/services/api.dart';
import '../../../../hooks/lifecycle_hook.dart';
import '../../../../services/third_party.dart';

part 'development_view_model.freezed.dart';
part 'development_view_model.g.dart';

@freezed
class DevelopmentViewModelState with _$DevelopmentViewModelState {
  const factory DevelopmentViewModelState({
    @Default(false) bool displaySelectablePostIDs,
    @Default(false) bool darkMode,
    @Default('Pending...') String status,
  }) = _DevelopmentViewModelState;

  factory DevelopmentViewModelState.initialState() => const DevelopmentViewModelState();
}

@Riverpod(keepAlive: true)
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

  Future<void> toggleSelectablePostIDs() async {
    final Logger logger = ref.read(loggerProvider);

    logger.d('Toggling selectable post IDs');
    state = state.copyWith(status: 'Toggling selectable IDs to ${!state.displaySelectablePostIDs}');
    state = state.copyWith(displaySelectablePostIDs: !state.displaySelectablePostIDs);
  }

  Future<void> toggleDarkMode() async {
    final Logger logger = ref.read(loggerProvider);

    logger.d('Toggling dark mode');
    state = state.copyWith(status: 'Toggling dark mode to ${!state.darkMode}');
    state = state.copyWith(darkMode: !state.darkMode);
  }

  Future<void> displayAuthClaims() async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    logger.d('Displaying auth claims');

    state = state.copyWith(status: 'Displaying auth claims');

    try {
      final Map<String, dynamic> claims = (await firebaseAuth.currentUser?.getIdTokenResult())?.claims ?? {};
      logger.d('Auth claims: $claims');
      state = state.copyWith(status: 'Auth claims: $claims');
    } catch (ex) {
      logger.e('Failed to display auth claims. $ex');
      state = state.copyWith(status: 'Failed to display auth claims');
    }
  }

  Future<void> displayNotificationSettings() async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseMessaging firebaseMessaging = ref.read(firebaseMessagingProvider);
    logger.d('Displaying notification settings');

    state = state.copyWith(status: 'Displaying notification settings');
    try {
      final NotificationSettings settings = await firebaseMessaging.getNotificationSettings();
      final Map<String, dynamic> settingsMap = {
        'alert': settings.alert,
        'announcement': settings.announcement,
        'authorizationStatus': settings.authorizationStatus,
        'badge': settings.badge,
        'carPlay': settings.carPlay,
        'lockScreen': settings.lockScreen,
        'notificationCenter': settings.notificationCenter,
        'showPreviews': settings.showPreviews,
        'timeSensitive': settings.timeSensitive,
        'criticalAlert': settings.criticalAlert,
        'sound': settings.sound,
      };

      logger.d('Notification settings: $settingsMap');
      state = state.copyWith(status: 'Notification settings: $settingsMap');
    } catch (ex) {
      logger.e('Failed to display notification settings. $ex');
      state = state.copyWith(status: 'Failed to display notification settings');
    }
  }

  Future<void> sendTestNotification() async {
    final Logger logger = ref.read(loggerProvider);
    final SystemApiService systemApiService = await ref.read(systemApiServiceProvider.future);
    logger.d('Sending test notification');

    state = state.copyWith(status: 'Sending test notification');

    try {
      await systemApiService.sendTestNotification();
      logger.d('Successfully sent test notification');
      state = state.copyWith(status: 'Successfully sent test notification');
    } catch (ex) {
      logger.e('Failed to send test notification. $ex');
      state = state.copyWith(status: 'Failed to send test notification');
    }
  }
}
