import 'dart:async';

import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/helpers/cryptography_helpers.dart';
import 'package:app/main.dart';
import 'package:app/providers/events/communications/notification_handler_update_request.dart';
import 'package:app/providers/events/connections/relationship_updated_event.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import 'package:app/widgets/behaviours/positive_profile_fetch_behaviour.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

abstract class NotificationHandler {
  NotificationHandler() {
    startListening();
  }

  Logger get logger => providerContainer.read(loggerProvider);

  bool canHandlePayload(NotificationPayload payload, bool isForeground);
  Future<bool> canDisplayPayload(NotificationPayload payload, bool isForeground);
  Future<bool> canTriggerPayload(NotificationPayload payload, bool isForeground);

  final StreamController<NotificationHandlerUpdateRequest> _notificationHandlerUpdateRequestStreamController = StreamController<NotificationHandlerUpdateRequest>.broadcast();
  Stream get notificationHandlerUpdateRequestStream => _notificationHandlerUpdateRequestStreamController.stream;

  Color getBackgroundColor(NotificationPayload payload) {
    return providerContainer.read(designControllerProvider.select((value) => value.colors.white));
  }

  @mustCallSuper
  void startListening() {
    providerContainer.read(eventBusProvider).on<RelationshipUpdatedEvent>().listen(onRelationshipUpdated);
    providerContainer.read(firebaseAuthProvider).authStateChanges().listen(onAuthStateChanged);
  }

  void notifyListeners() {
    _notificationHandlerUpdateRequestStreamController.add(NotificationHandlerUpdateRequest());
  }

  void onRelationshipUpdated(RelationshipUpdatedEvent newRelationship) {
    notifyListeners();
  }

  void onAuthStateChanged(User? newUser) {
    notifyListeners();
  }

  Future<List<Widget>> buildNotificationTrailing(NotificationPayload payload, Profile? profile, Relationship? relationship) async {
    logger.d('buildNotificationTrailing(), payload: $payload');
    return [];
  }

  Future<Widget> buildNotificationLeading(NotificationPayload payload, Profile? profile, Relationship? relationship) async {
    logger.d('buildNotificationLeading(), payload: $payload');

    return PositiveProfileFetchBehaviour(
      userId: payload.sender,
      placeholderBuilder: (BuildContext context) => const PositiveProfileCircularIndicator(),
      errorBuilder: (BuildContext context) => const PositiveProfileCircularIndicator(),
      builder: (BuildContext context, Profile profile, Relationship? relationship) {
        return PositiveProfileCircularIndicator(profile: profile);
      },
    );
  }

  @mustCallSuper
  Future<void> onNotificationTriggered(NotificationPayload payload, bool isForeground) async {
    logger.d('onNotificationTriggered(), payload: $payload, isForeground: $isForeground');
  }

  Future<void> onNotificationDisplayed(NotificationPayload payload, bool isForeground) async {
    logger.d('onNotificationDisplayed(), payload: $payload, isForeground: $isForeground');

    if (payload.title.isEmpty || payload.body.isEmpty) {
      logger.e('onNotificationDisplayed: Unable to localize notification: $payload');
      return;
    }

    if (isForeground) {
      displayForegroundNotification(payload);
    } else {
      displayBackgroundNotification(payload);
    }
  }

  Future<void> displayForegroundNotification(NotificationPayload payload) async {
    final NotificationsController notificationsController = providerContainer.read(notificationsControllerProvider.notifier);
    final AppRouter appRouter = providerContainer.read(appRouterProvider);
    final BuildContext context = appRouter.navigatorKey.currentContext!;
    final NotificationHandler handler = notificationsController.getHandlerForPayload(payload);

    final PositiveNotificationSnackBar snackbar = PositiveNotificationSnackBar(payload: payload, handler: handler);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Future<void> displayBackgroundNotification(NotificationPayload payload) async {
    final logger = providerContainer.read(loggerProvider);
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = providerContainer.read(flutterLocalNotificationsPluginProvider);

    final int id = convertStringToUniqueInt(payload.key);
    final NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        payload.topic.toLocalizedTopic,
        payload.topic.toLocalizedTopic,
      ),
      iOS: DarwinNotificationDetails(
        threadIdentifier: payload.topic.toLocalizedTopic,
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    if (payload.title.isEmpty || payload.body.isEmpty) {
      logger.e('displayBackgroundNotification: Unable to localize notification: $payload');
      return;
    }

    await flutterLocalNotificationsPlugin.show(id, payload.title, payload.body, notificationDetails);
    logger.d('displayBackgroundNotification: $id');
  }
}
