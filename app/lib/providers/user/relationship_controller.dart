// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/extensions/future_extensions.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/helpers/relationship_helpers.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import '../../services/third_party.dart';
import '../events/connections/relationship_updated_event.dart';

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

  final StreamController<RelationshipUpdatedEvent> positiveRelationshipsUpdatedController = StreamController.broadcast();

  @override
  RelationshipControllerState build() {
    return RelationshipControllerState.initialState();
  }

  void resetState() {
    final Logger logger = ref.read(loggerProvider);
    logger.i('[Relationship Service] - Resetting state');

    state = RelationshipControllerState.initialState();
    positiveRelationshipsUpdatedController.sink.add(RelationshipUpdatedEvent(null));
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

  void appendRelationships(dynamic response) {
    final Logger logger = ref.read(loggerProvider);

    final Map relationshipMap = json.decodeSafe(response);

    if (!relationshipMap.containsKey('relationships')) {
      logger.e('[Profile Service] - Relationships response is invalid: $relationshipMap');
      return;
    }

    final Iterable<dynamic> relationships = relationshipMap['relationships'];
    for (final relationship in relationships) {
      try {
        final Relationship relationshipDto = Relationship.fromJson(relationship);
        appendRelationship(relationshipDto);
      } catch (e) {
        logger.e('[Profile Service] - Failed to parse relationship: $relationship');
      }
    }
  }

  void appendRelationship(Relationship relationship) {
    final Logger logger = ref.read(loggerProvider);
    final List<String> sortedMembers = [...relationship.members.map((e) => e.memberId)]..sort();
    final String relationshipId = sortedMembers.join('-');
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);

    logger.d('[Profile Service] - Adding relationship to cache: $relationship');
    cacheController.addToCache(relationshipId, relationship);
    positiveRelationshipsUpdatedController.sink.add(RelationshipUpdatedEvent(relationship));
  }

  Future<Relationship> getRelationship(List<String> members, {bool skipCacheLookup = false}) async {
    final Logger logger = ref.read(loggerProvider);
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
    logger.d('[Profile Service] - Getting relationship for user');

    if (members.length < 2) {
      logger.e('[Profile Service] - Relationship members must be at least 2');
      return Relationship.empty();
    }

    final String relationshipId = buildRelationshipIdentifier(members);
    Relationship? relationship;

    if (relationshipId.isEmpty) {
      logger.e('[Profile Service] - Relationship ID is empty');
      return Relationship.empty();
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

    // TODO(ryan): Update endpoint to check if the relationship is one the user is a member of
    final HttpsCallableResult response = await callable.call({
      'members': members,
    });

    logger.i('[Profile Service] - Relationship loaded: ${response.data}');
    appendRelationships(response.data);

    return cacheController.getFromCache(relationshipId) ?? Relationship.empty();
  }

  bool hasPendingConnectionRequestToCurrentUser(String uid) {
    final Logger logger = ref.read(loggerProvider);
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
    final UserController userController = ref.read(userControllerProvider.notifier);
    logger.d('[Profile Service] - Checking if user has pending relationship to current user: $uid');

    final String currentUserId = userController.currentUser?.uid ?? '';
    final List<String> sortedMembers = [currentUserId, uid]..sort();
    final String relationshipId = sortedMembers.join('-');

    final Relationship? relationship = cacheController.getFromCache(relationshipId);
    if (relationship == null) {
      logger.d('[Profile Service] - User has no relationship to current user: $uid');
      return false;
    }

    final Set<RelationshipState> relationshipStates = relationship.relationshipStatesForEntity(currentUserId);
    final bool hasPendingRelationship = !relationshipStates.contains(RelationshipState.sourceConnected) && relationshipStates.contains(RelationshipState.targetConnected);
    logger.d('[Profile Service] - User has pending relationship to current user: $hasPendingRelationship');

    return hasPendingRelationship;
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
}
