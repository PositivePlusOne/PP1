// Package imports:
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:system_settings/system_settings.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/mutators/base_mutator.dart';
import 'package:ppoa/client/simulation/enumerations/simulator_tile_type.dart';
import '../../state/user/enumerations/notification_preference.dart';

class ToggleNotificationPreferencesAction extends BaseMutator with ServiceMixin {
  @override
  String get simulationTitle => 'Toggle notification preferences';

  @override
  String get simulationDescription => 'Uses the notification preferences enum to toggle system topics';

  @override
  SimulatorTileType get simulatorTileType => SimulatorTileType.none;

  @override
  Future<void> simulateAction(AppStateNotifier notifier, List params) async {}

  @override
  Future<void> action(AppStateNotifier notifier, List params) async {
    log.info('Attempting to subscribe to message topics');
    if (!locator.isRegistered<FirebaseMessaging>()) {
      log.severe('Cannot subscribe without messaging plugin');
      return;
    }

    if (!stateNotifier.state.user.hasCreatedProfile) {
      log.severe('Cannot set notification preferences without a valid user');
    }

    final List<NotificationPreference> preferences = params.whereType<NotificationPreference>().toList();
    final NotificationSettings notificationSettings = await firebaseMessaging.requestPermission();

    if (notificationSettings.authorizationStatus != AuthorizationStatus.authorized) {
      log.info('Missing notification preferences, requesting from settings');
      await SystemSettings.appNotifications();
      return;
    }

    // Unsubscribe from all old topics
    for (final NotificationPreference preference in NotificationPreference.values) {
      await firebaseMessaging.unsubscribeFromTopic(preference.toString());
    }

    // Subscribe to all relevant topics
    for (final NotificationPreference preference in preferences) {
      await firebaseMessaging.subscribeToTopic(preference.toString());
    }

    log.info('Subscribed to topics successfully');
    return super.action(notifier, params);
  }
}
