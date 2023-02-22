// Package imports:
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/key_constants.dart';
import '../../../hooks/lifecycle_hook.dart';
import '../../../services/third_party.dart';

part 'notification_preferences_controller.freezed.dart';
part 'notification_preferences_controller.g.dart';

@freezed
class NotificationPreferencesControllerState with _$NotificationPreferencesControllerState {
  const factory NotificationPreferencesControllerState() = _NotificationPreferencesControllerState;

  factory NotificationPreferencesControllerState.initialState() => const NotificationPreferencesControllerState();
}

@riverpod
class NotificationPreferencesController extends _$NotificationPreferencesController with LifecycleMixin {
  @override
  NotificationPreferencesControllerState build() {
    return NotificationPreferencesControllerState.initialState();
  }

  Future<void> onPermitSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final SystemController systemController = ref.read(systemControllerProvider.notifier);

    await analyticsController.trackEvent(AnalyticEvents.notificationPreferencesEnabled);
    await sharedPreferences.setBool(kNotificationsAcceptedKey, true);

    // Request first permissions to setup listeners and first dialogs
    await systemController.requestPushNotificationPermissions();
    await systemController.setupPushNotificationListeners();

    appRouter.removeWhere((route) => true);
    appRouter.push(const HomeRoute());
  }

  Future<void> onDenySelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);

    await analyticsController.trackEvent(AnalyticEvents.notificationPreferencesDisabled);
    await sharedPreferences.setBool(kNotificationsAcceptedKey, false);

    appRouter.removeWhere((route) => true);
    await appRouter.push(const HomeRoute());
  }
}
