import 'dart:async';

import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/main.dart';
import 'package:app/providers/events/communications/notification_handler_update_request.dart';
import 'package:app/providers/events/connections/relationship_updated_event.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:app/widgets/behaviours/positive_profile_fetch_behaviour.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

abstract class NotificationHandler {
  NotificationHandler() {
    startListening();
  }

  bool canHandle(NotificationPayload payload);
  Future<List<Widget>> Function(BuildContext context, NotificationPayload payload, Profile profile, Relationship? relationship)? buildNotificationTrailing;

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

  @mustCallSuper
  Future<void> onNotificationReceived(NotificationPayload payload) async {
    final Logger logger = providerContainer.read(loggerProvider);
    logger.d('onNotificationReceived(), payload: $payload');
  }

  Future<Widget> buildNotificationLeading(BuildContext context, NotificationPayload payload, Profile profile, Relationship? relationship) async {
    final Logger logger = providerContainer.read(loggerProvider);
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
}
