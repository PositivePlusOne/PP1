// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/enumerations/positive_notification_action.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/providers/system/models/positive_notification_model.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import '../../services/third_party.dart';
import '../events/relationships_updated_event.dart';

// Project imports:

part 'relationship_controller.freezed.dart';
part 'relationship_controller.g.dart';

@freezed
class RelationshipControllerState with _$RelationshipControllerState {
  const factory RelationshipControllerState() = _RelationshipControllerState;
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

  void appendRelationships(Map responseMap) {
    final Logger logger = ref.read(loggerProvider);
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
    final Map relationshipMap = json.decodeSafe(responseMap);

    if (!relationshipMap.containsKey('relationships')) {
      logger.e('[Profile Service] - Relationships response is invalid: $responseMap');
      return;
    }

    final Iterable<dynamic> relationships = relationshipMap['relationships'];
    final List<Relationship> parsedRelationships = <Relationship>[];

    for (final relationship in relationships) {
      try {
        final Relationship relationshipDto = Relationship.fromJson(relationship);
        parsedRelationships.add(relationshipDto);
      } catch (e) {
        logger.e('[Profile Service] - Failed to parse relationship: $relationship');
      }
    }

    // Calculate the relationship ID based on the members
    parsedRelationships.sort();
    final String relationshipId = parsedRelationships.map((e) => e.id).join('-');
    if (relationshipId.isEmpty) {
      logger.e('[Profile Service] - Relationship ID is empty');
      return;
    }

    logger.d('[Profile Service] - Relationships parsed: $parsedRelationships');
    cacheController.addToCache(relationshipId, parsedRelationships);
    positiveRelationshipsUpdatedController.sink.add(RelationshipsUpdatedEvent());
  }

  Future<Relationship?> getRelationship(List<String> members, {bool skipCacheLookup = false}) async {
    final Logger logger = ref.read(loggerProvider);
    final UserControllerState userState = ref.read(userControllerProvider);
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);

    logger.d('[Profile Service] - Getting relationship for user');
    if (userState.user == null || !members.any((element) => element == userState.user!.uid)) {
      throw Exception('User is not a member of the relationship');
    }

    // The ID will be the names sorted alphabetically and joined with a dash
    members.sort();
    final String relationshipId = members.join('-');
    Relationship? relationship;

    if (relationshipId.isEmpty) {
      throw Exception('Relationship ID is empty');
    }

    if (!skipCacheLookup) {
      relationship = cacheController.getFromCache(relationshipId);
      if (relationship != null) {
        logger.d('[Profile Service] - Relationship found in cache: $relationship');
        return relationship;
      }
    }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('relationship-getRelationship');
    final HttpsCallableResult response = await callable.call({
      'members': members,
    });

    logger.i('[Profile Service] - Relationship loaded: ${response.data}');
    appendRelationships(response.data);

    return cacheController.getFromCache(relationshipId);
  }

  Future<void> getRelationships() async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile Service] - Updating relationships for user');

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('relationship-getRelationships');
    final HttpsCallableResult response = await callable.call();

    logger.i('[Profile Service] - Relationships loaded: ${response.data}');
    appendRelationships(response.data);
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
    appendRelationships(response.data);
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
    appendRelationships(response.data);
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
    appendRelationships(response.data);
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
    appendRelationships(response.data);
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
    appendRelationships(response.data);
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
    appendRelationships(response.data);
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
    appendRelationships(response.data);
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
    appendRelationships(response.data);
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
    appendRelationships(response.data);
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
    appendRelationships(response.data);
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
    if (action == PositiveNotificationAction.relationshipUpdated) {
      logger.d('[Relationship Service] - Notification action is not a relationship change');
      return;
    }

    try {
      final Map<String, dynamic> data = json.decodeSafe(model.actionData);
      final Relationship relationship = Relationship.fromJson(data);

      logger.d('[Relationship Service] - Detected relationship change: $relationship');
      appendRelationships({
        'relationships': [relationship],
      });
    } catch (e) {
      logger.e('[Relationship Service] - Failed to decode notification action data: $e');
    }

    logger.i('[Relationship Service] - Updating notifications to reflect changes');
    await notificationsController.updateNotifications();
  }
}
