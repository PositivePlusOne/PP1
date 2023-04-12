// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/extensions/json_extensions.dart';
import '../../services/third_party.dart';

part 'relationship_controller.freezed.dart';
part 'relationship_controller.g.dart';

@freezed
class RelationshipControllerState with _$RelationshipControllerState {
  const factory RelationshipControllerState({
    @Default({}) Set<String> followers,
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
  @override
  RelationshipControllerState build() {
    return RelationshipControllerState.initialState();
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
  }

  Future<void> updateFollowers() async {
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
    final Set<String> followers = relationships.map((dynamic user) => user.toString()).toSet();
    state = state.copyWith(followers: followers);
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
    state = state.copyWith(followers: {
      ...state.followers,
      uid,
    });
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
    state = state.copyWith(followers: state.followers.where((String follower) => follower != uid).toSet());
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
  }
}
