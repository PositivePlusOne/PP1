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
import 'package:app/enumerations/positive_notification_action.dart';
import 'package:app/extensions/future_extensions.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/providers/system/models/positive_notification_model.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import '../../dtos/database/profile/profile.dart';
import '../../services/third_party.dart';
import '../events/positive_relationships_updated_event.dart';
import '../profiles/profile_controller.dart';

// Project imports:

part 'relationship_controller.freezed.dart';
part 'relationship_controller.g.dart';

@freezed
class RelationshipControllerState with _$RelationshipControllerState {
  const factory RelationshipControllerState({
    @Default({}) Set<String> following,
    @Default({}) Set<String> connections,
    @Default({}) Set<String> pendingConnectionRequests,
    @Default({}) Set<String> blockedRelationships,
    @Default({}) Set<String> mutedRelationships,
    @Default({}) Set<String> hiddenRelationships,
  }) = _RelationshipControllerState;

  factory RelationshipControllerState.initialState() => const RelationshipControllerState();
}

@Riverpod(keepAlive: true)
class RelationshipController extends _$RelationshipController {
  StreamSubscription<User?>? userSubscription;
  StreamSubscription<Profile?>? userProfileSubscription;

  final StreamController<PositiveRelationshipsUpdatedEvent> positiveRelationshipsUpdatedController = StreamController.broadcast();

  @override
  RelationshipControllerState build() {
    return RelationshipControllerState.initialState();
  }

  void resetState() {
    final Logger logger = ref.read(loggerProvider);
    logger.i('[Relationship Service] - Resetting state');

    state = RelationshipControllerState.initialState();
    positiveRelationshipsUpdatedController.sink.add(PositiveRelationshipsUpdatedEvent());
  }

  Future<void> setupListeners() async {
    await userSubscription?.cancel();
    await userProfileSubscription?.cancel();

    userSubscription = ref.read(userControllerProvider.notifier).userChangedController.stream.listen(onUserChanged);
    userProfileSubscription = ref.read(profileControllerProvider.notifier).userProfileStreamController.stream.listen(onUserProfileChanged);
  }

  void onUserChanged(User? user) {
    final Logger logger = ref.read(loggerProvider);
    logger.i('[Relationship Service] - User changed: $user - Resetting state');
    resetState();
  }

  void onUserProfileChanged(Profile? event) {
    final Logger logger = ref.read(loggerProvider);
    logger.i('[Relationship Service] - User profile changed: $event - Attempting to update relationships');

    if (event == null) {
      logger.i('[Relationship Service] - User profile is null - Resetting state');
      resetState();
      return;
    }

    failSilently(ref, () => updateBlockedRelationships());
    failSilently(ref, () => updateConnectedRelationships());
    failSilently(ref, () => updateFollowingRelationships());
    failSilently(ref, () => updateMutedRelationships());
    failSilently(ref, () => updateHiddenRelationships());
    failSilently(ref, () => updatePendingConnectionRequests());
  }

  Future<void> updateBlockedRelationships() async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile Service] - Updating blocked relationships');

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('relationship-getBlockedRelationships');
    final HttpsCallableResult response = await callable.call();

    logger.i('[Profile Service] - Blocked relationships loaded: ${response.data}');
    final Map data = json.decodeSafe(response.data);

    if (!data.containsKey('relationships')) {
      logger.e('[Profile Service] - Blocked relationships response is invalid: $response');
      return;
    }

    final Iterable<dynamic> relationships = data['relationships'];
    final Set<String> blockedRelationships = relationships.map((dynamic user) => user.toString()).toSet();
    state = state.copyWith(blockedRelationships: blockedRelationships);
    positiveRelationshipsUpdatedController.sink.add(PositiveRelationshipsUpdatedEvent());
  }

  Future<void> updateConnectedRelationships() async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile Service] - Updating connected relationships');

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('relationship-getConnectedRelationships');
    final HttpsCallableResult response = await callable.call();

    logger.i('[Profile Service] - Connected relationships loaded: ${response.data}');
    final Map data = json.decodeSafe(response.data);

    if (!data.containsKey('relationships')) {
      logger.e('[Profile Service] - Connected relationships response is invalid: $response');
      return;
    }

    final Iterable<dynamic> relationships = data['relationships'];
    final Set<String> connections = relationships.map((dynamic user) => user.toString()).toSet();

    state = state.copyWith(connections: connections);
    positiveRelationshipsUpdatedController.sink.add(PositiveRelationshipsUpdatedEvent());
  }

  Future<void> updateFollowingRelationships() async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile Service] - Updating followers');

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('relationship-getFollowingRelationships');
    final HttpsCallableResult response = await callable.call();

    logger.i('[Profile Service] - Followers loaded: ${response.data}');
    final Map data = json.decodeSafe(response.data);

    if (!data.containsKey('relationships')) {
      logger.e('[Profile Service] - Followers response is invalid: $response');
      return;
    }

    final Iterable<dynamic> relationships = data['relationships'];
    final Set<String> following = relationships.map((dynamic user) => user.toString()).toSet();

    state = state.copyWith(following: following);
    positiveRelationshipsUpdatedController.sink.add(PositiveRelationshipsUpdatedEvent());
  }

  Future<void> updateMutedRelationships() async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile Service] - Updating muted relationships');

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('relationship-getMutedRelationships');
    final HttpsCallableResult response = await callable.call();

    logger.i('[Profile Service] - Muted relationships loaded: ${response.data}');
    final Map data = json.decodeSafe(response.data);

    if (!data.containsKey('relationships')) {
      logger.e('[Profile Service] - Muted relationships response is invalid: $response');
      return;
    }

    final Iterable<dynamic> relationships = data['relationships'];
    final Set<String> mutedRelationships = relationships.map((dynamic user) => user.toString()).toSet();

    state = state.copyWith(mutedRelationships: mutedRelationships);
    positiveRelationshipsUpdatedController.sink.add(PositiveRelationshipsUpdatedEvent());
  }

  Future<void> updateHiddenRelationships() async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile Service] - Updating hidden relationships');

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('relationship-getHiddenRelationships');
    final HttpsCallableResult response = await callable.call();

    logger.i('[Profile Service] - Hidden relationships loaded: ${response.data}');
    final Map data = json.decodeSafe(response.data);

    if (!data.containsKey('relationships')) {
      logger.e('[Profile Service] - Hidden relationships response is invalid: $response');
      return;
    }

    final Iterable<dynamic> relationships = data['relationships'];
    final Set<String> hiddenRelationships = relationships.map((dynamic user) => user.toString()).toSet();

    state = state.copyWith(hiddenRelationships: hiddenRelationships);
    positiveRelationshipsUpdatedController.sink.add(PositiveRelationshipsUpdatedEvent());
  }

  Future<void> updatePendingConnectionRequests() async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile Service] - Updating pending connection requests');

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final HttpsCallable callable = firebaseFunctions.httpsCallable('relationship-getPendingConnectionRequests');
    final HttpsCallableResult response = await callable.call();

    logger.i('[Profile Service] - Pending connection requests loaded: ${response.data}');
    final Map data = json.decodeSafe(response.data);

    if (!data.containsKey('relationships')) {
      logger.e('[Profile Service] - Pending connection requests response is invalid: $response');
      return;
    }

    final Iterable<dynamic> relationships = data['relationships'];
    final Set<String> pendingConnectionRequests = relationships.map((dynamic user) => user.toString()).toSet();

    state = state.copyWith(pendingConnectionRequests: pendingConnectionRequests);
    positiveRelationshipsUpdatedController.sink.add(PositiveRelationshipsUpdatedEvent());
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
    state = state.copyWith(blockedRelationships: {
      ...state.blockedRelationships,
      uid,
    });

    positiveRelationshipsUpdatedController.sink.add(PositiveRelationshipsUpdatedEvent());
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
    state = state.copyWith(blockedRelationships: state.blockedRelationships.where((String blockedUser) => blockedUser != uid).toSet());
    positiveRelationshipsUpdatedController.sink.add(PositiveRelationshipsUpdatedEvent());
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
    state = state.copyWith(connections: {
      ...state.connections,
      uid,
    });

    positiveRelationshipsUpdatedController.sink.add(PositiveRelationshipsUpdatedEvent());
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
    state = state.copyWith(connections: state.connections.where((String connectedUser) => connectedUser != uid).toSet());
    positiveRelationshipsUpdatedController.sink.add(PositiveRelationshipsUpdatedEvent());
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
    state = state.copyWith(following: {
      ...state.following,
      uid,
    });

    positiveRelationshipsUpdatedController.sink.add(PositiveRelationshipsUpdatedEvent());
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
    state = state.copyWith(following: state.following.where((String follower) => follower != uid).toSet());
    positiveRelationshipsUpdatedController.sink.add(PositiveRelationshipsUpdatedEvent());
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
    state = state.copyWith(mutedRelationships: {
      ...state.mutedRelationships,
      uid,
    });

    positiveRelationshipsUpdatedController.sink.add(PositiveRelationshipsUpdatedEvent());
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
    state = state.copyWith(mutedRelationships: state.mutedRelationships.where((String mutedUser) => mutedUser != uid).toSet());
    positiveRelationshipsUpdatedController.sink.add(PositiveRelationshipsUpdatedEvent());
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

    logger.i('[Relationship Service] - Making any needed relationship changes');
    switch (action) {
      case PositiveNotificationAction.disconnected:
        state = state.copyWith(connections: state.connections.where((String connectedUser) => connectedUser != otherUser).toSet());
        break;
      default:
        logger.d('[Relationship Service] - Notification action is not handled: $action');
        break;
    }

    logger.i('[Relationship Service] - Updating notifications to reflect changes');
    await notificationsController.updateNotifications();
  }
}
