// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/enumerations/positive_notification_action.dart';
import 'package:app/extensions/future_extensions.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/providers/system/models/positive_notification_model.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import '../../dtos/database/profile/profile.dart';
import '../../services/third_party.dart';
import '../events/relationships_updated_event.dart';
import '../profiles/profile_controller.dart';

// Project imports:

part 'relationship_controller.freezed.dart';
part 'relationship_controller.g.dart';

@freezed
class RelationshipControllerState with _$RelationshipControllerState {
  const factory RelationshipControllerState({
    @Default({}) Set<Relationship> currentUserRelationships,
  }) = _RelationshipControllerState;

  factory RelationshipControllerState.initialState() => const RelationshipControllerState();
}

@Riverpod(keepAlive: true)
class RelationshipController extends _$RelationshipController {
  StreamSubscription<User?>? userSubscription;

  final StreamController<RelationshipsUpdatedEvent> positiveRelationshipsUpdatedController = StreamController.broadcast();

  @override
  RelationshipControllerState build() {
    return RelationshipControllerState.initialState();
  }

  void resetState() {
    final Logger logger = ref.read(loggerProvider);
    logger.i('[Relationship Service] - Resetting state');

    state = RelationshipControllerState.initialState();
    positiveRelationshipsUpdatedController.sink.add(RelationshipsUpdatedEvent());
  }

  Future<void> setupListeners() async {
    await userSubscription?.cancel();
    userSubscription = ref.read(userControllerProvider.notifier).userChangedController.stream.listen(onUserChanged);
  }

  void onUserChanged(User? user) {
    final Logger logger = ref.read(loggerProvider);
    logger.i('[Relationship Service] - User changed: $user - Resetting state');

    if (user == null) {
      logger.i('[Relationship Service] - User is null - Resetting state');
      resetState();
    }
  }

  void appendRelationships(HttpsCallableResult response) {
    final Logger logger = ref.read(loggerProvider);
    final Map data = json.decodeSafe(response.data);

    if (!data.containsKey('relationships')) {
      logger.e('[Profile Service] - Relationships response is invalid: $response');
      return;
    }

    final Iterable<dynamic> relationships = data['relationships'];
    final Set<Relationship> relationshipsSet = <Relationship>{};

    for (final relationship in relationships) {
      try {
        final Relationship relationshipDto = Relationship.fromJson(relationship);
        relationshipsSet.add(relationshipDto);
      } catch (e) {
        logger.e('[Profile Service] - Failed to parse relationship: $relationship');
      }
    }

    logger.d('[Profile Service] - Relationships parsed: $relationshipsSet');
    state = state.copyWith(currentUserRelationships: relationshipsSet);

    positiveRelationshipsUpdatedController.sink.add(RelationshipsUpdatedEvent());
  }

  Future<void> getRelationships() async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile Service] - Updating relationships for user');

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('relationship-getRelationships');
    final HttpsCallableResult response = await callable.call();

    logger.i('[Profile Service] - Relationships loaded: ${response.data}');
    appendRelationships(response);
  }

  Future<void> blockRelationship(String uid) async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile Service] - Blocking user: $uid');

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('relationship-blockRelationship');
    final HttpsCallableResult response = await callable.call({
      'target': uid,
    });

    logger.i('[Profile Service] - Blocked user: $response');
    appendRelationships(response);
  }

  Future<void> unblockRelationship(String uid) async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile Service] - Unblocking user: $uid');

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('relationship-unblockRelationship');
    final HttpsCallableResult response = await callable.call({
      'target': uid,
    });

    logger.i('[Profile Service] - Unblocked user: $response');
    appendRelationships(response);
  }

  Future<void> connectRelationship(String uid) async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile Service] - Connecting user: $uid');

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('relationship-connectRelationship');
    final HttpsCallableResult response = await callable.call({
      'target': uid,
    });

    logger.i('[Profile Service] - Connected user: $response');
    appendRelationships(response);
  }

  Future<void> disconnectRelationship(String uid) async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile Service] - Disconnecting user: $uid');

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('relationship-disconnectRelationship');
    final HttpsCallableResult response = await callable.call({
      'target': uid,
    });

    logger.i('[Profile Service] - Disconnected user: $response');
    appendRelationships(response);
  }

  Future<void> followRelationship(String uid) async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile Service] - Following user: $uid');

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('relationship-followRelationship');
    final HttpsCallableResult response = await callable.call({
      'target': uid,
    });

    logger.i('[Profile Service] - Followed user: $response');
    appendRelationships(response);
  }

  Future<void> unfollowRelationship(String uid) async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile Service] - Unfollowing user: $uid');

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('relationship-unfollowRelationship');
    final HttpsCallableResult response = await callable.call({
      'target': uid,
    });

    logger.i('[Profile Service] - Unfollowed user: $response');
    appendRelationships(response);
  }

  Future<void> muteRelationship(String uid) async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile Service] - Muting user: $uid');

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('relationship-muteRelationship');
    final HttpsCallableResult response = await callable.call({
      'target': uid,
    });

    logger.i('[Profile Service] - Muted user: $response');
    appendRelationships(response);
  }

  Future<void> unmuteRelationship(String uid) async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile Service] - Unmuting user: $uid');

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('relationship-unmuteRelationship');
    final HttpsCallableResult response = await callable.call({
      'target': uid,
    });

    logger.i('[Profile Service] - Unmuted user: $response');
    appendRelationships(response);
  }

  Future<void> hideRelationship(String uid) async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile Service] - Hiding user: $uid');

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('relationship-hideRelationship');
    final HttpsCallableResult response = await callable.call({
      'target': uid,
    });

    logger.i('[Profile Service] - Hid user: $response');
    appendRelationships(response);
  }

  Future<void> unhideRelationship(String uid) async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile Service] - Unhiding user: $uid');

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('relationship-unhideRelationship');
    final HttpsCallableResult response = await callable.call({
      'target': uid,
    });

    logger.i('[Profile Service] - Unhid user: $response');
    appendRelationships(response);
  }

  Future<void> handleNotificationAction(PositiveNotificationModel model, {bool isBackground = true}) async {
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final NotificationsController notificationsController = ref.read(notificationsControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    logger.d('[Relationship Service] - Attempting to handle notification action: $model');
    if (firebaseAuth.currentUser == null) {
      logger.d('[Relationship Service] - User is not logged in');
      return;
    }

    if (isBackground) {
      logger.d('[Relationship Service] - Notification action is in background');
      return;
    }

    final PositiveNotificationAction action = PositiveNotificationAction.fromString(model.action);
    if (!action.isRelationshipChange) {
      logger.d('[Relationship Service] - Notification action is not a relationship change');
      return;
    }

    final Map<String, dynamic> data = json.decodeSafe(model.actionData);
    final String sender = data.containsKey('sender') ? data['sender'].toString() : '';
    final String target = data.containsKey('target') ? data['target'].toString() : '';
    final String otherUser = sender == firebaseAuth.currentUser?.uid ? target : sender;

    if (firebaseAuth.currentUser != null && otherUser != firebaseAuth.currentUser?.uid) {
      logger.e('[Relationship Service] - Notification action data is invalid or target is not the current user');
      return;
    }

    logger.i('[Relationship Service] - Updating notifications to reflect changes');
    await notificationsController.updateNotifications();
  }
}
