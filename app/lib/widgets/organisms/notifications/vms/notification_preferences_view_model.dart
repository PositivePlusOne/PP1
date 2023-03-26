// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/system/notifications_controller.dart';
import '../../../../constants/key_constants.dart';
import '../../../../hooks/lifecycle_hook.dart';
import '../../../../services/third_party.dart';

part 'notification_preferences_view_model.freezed.dart';
part 'notification_preferences_view_model.g.dart';

@freezed
class NotificationPreferencesViewModelState with _$NotificationPreferencesViewModelState {
  const factory NotificationPreferencesViewModelState() = _NotificationPreferencesViewModelState;

  factory NotificationPreferencesViewModelState.initialState() => const NotificationPreferencesViewModelState();
}

@riverpod
class NotificationPreferencesViewModel extends _$NotificationPreferencesViewModel with LifecycleMixin {
  @override
  NotificationPreferencesViewModelState build() {
    return NotificationPreferencesViewModelState.initialState();
  }

  Future<void> onPermitSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final NotificationsController notificationsController = ref.read(notificationsControllerProvider.notifier);

    await analyticsController.trackEvent(AnalyticEvents.notificationPreferencesEnabled);
    await sharedPreferences.setBool(kNotificationsAcceptedKey, true);

    // Request first permissions to setup listeners and first dialogs
    await notificationsController.requestPushNotificationPermissions();
    await notificationsController.setupPushNotificationListeners();

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
