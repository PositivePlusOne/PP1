// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/common/events/force_feed_rebuild_event.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/api.dart';
import '../../services/third_party.dart';

part 'relationship_controller.freezed.dart';
part 'relationship_controller.g.dart';

@freezed
class RelationshipControllerState with _$RelationshipControllerState {
  const factory RelationshipControllerState() = _RelationshipControllerState;
  factory RelationshipControllerState.initialState() => const RelationshipControllerState();
}

enum PositiveConnectionRequestType {
  unknown,
  sent,
  accepting,
  declining,
  cancelling,
  disconnecting;

  String get locale {
    switch (this) {
      case PositiveConnectionRequestType.unknown:
        return 'Unknown';
      case PositiveConnectionRequestType.sent:
        return 'Sent';
      case PositiveConnectionRequestType.accepting:
        return 'Accepting';
      case PositiveConnectionRequestType.declining:
        return 'Declining';
      case PositiveConnectionRequestType.cancelling:
        return 'Cancelling';
      case PositiveConnectionRequestType.disconnecting:
        return 'Disconnecting';
    }
  }
}

@Riverpod(keepAlive: true)
class RelationshipController extends _$RelationshipController {
  StreamSubscription<User?>? userSubscription;

  @override
  RelationshipControllerState build() {
    return RelationshipControllerState.initialState();
  }

  void resetState() {
    final Logger logger = ref.read(loggerProvider);
    logger.i('[Relationship Service] - Resetting state');

    state = RelationshipControllerState.initialState();
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
    final CacheController cacheController = ref.read(cacheControllerProvider);

    logger.d('[Profile Service] - Adding relationship to cache: $relationship');
    cacheController.add(key: relationshipId, value: relationship);
  }

  bool hasPendingConnectionRequestToCurrentUser(String uid) {
    final Logger logger = ref.read(loggerProvider);
    final CacheController cacheController = ref.read(cacheControllerProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);
    logger.d('[Profile Service] - Checking if user has pending relationship to current user: $uid');

    final String currentUserId = userController.currentUser?.uid ?? '';
    final List<String> sortedMembers = [currentUserId, uid]..sort();
    final String relationshipId = sortedMembers.join('-');

    final Relationship? relationship = cacheController.get(relationshipId);
    if (relationship == null) {
      logger.d('[Profile Service] - User has no relationship to current user: $uid');
      return false;
    }

    final Set<RelationshipState> relationshipStates = relationship.relationshipStatesForEntity(currentUserId);
    final bool hasPendingRelationship = !relationshipStates.contains(RelationshipState.sourceConnected) && relationshipStates.contains(RelationshipState.targetConnected);
    logger.d('[Profile Service] - User has pending relationship to current user: $hasPendingRelationship');

    return hasPendingRelationship;
  }

  PositiveConnectionRequestType getPositiveConnectionRequestTypeForRelationship(String targetUserId, bool connFlag) {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final CacheController cacheController = ref.read(cacheControllerProvider);

    final String currentUserId = profileController.currentProfileId ?? '';
    final String relationshipId = [currentUserId, targetUserId].asGUID;
    final Relationship? relationship = cacheController.get(relationshipId);

    if (relationship == null) {
      logger.d('[Profile Service] - User has no relationship to current user: $targetUserId');
      return PositiveConnectionRequestType.unknown;
    }

    final Set<RelationshipState> relationshipStates = relationship.relationshipStatesForEntity(currentUserId);

    // If we are connected, then we are disconnecting
    if (relationshipStates.contains(RelationshipState.sourceConnected) && relationshipStates.contains(RelationshipState.targetConnected)) {
      return PositiveConnectionRequestType.disconnecting;
    }

    // If they are pending, then we are cancelling
    if (relationshipStates.contains(RelationshipState.sourceConnected) && !relationshipStates.contains(RelationshipState.targetConnected)) {
      return PositiveConnectionRequestType.cancelling;
    }

    // If we are pending with a negative connection flag, then we are declining
    if (!relationshipStates.contains(RelationshipState.sourceConnected) && relationshipStates.contains(RelationshipState.targetConnected) && !connFlag) {
      return PositiveConnectionRequestType.declining;
    }

    // If we are pending with a positive connection flag, then we are accepting
    if (!relationshipStates.contains(RelationshipState.sourceConnected) && relationshipStates.contains(RelationshipState.targetConnected) && connFlag) {
      return PositiveConnectionRequestType.accepting;
    }

    // If we are not connected, then we are sending
    if (!relationshipStates.contains(RelationshipState.sourceConnected) && !relationshipStates.contains(RelationshipState.targetConnected)) {
      return PositiveConnectionRequestType.sent;
    }

    return PositiveConnectionRequestType.unknown;
  }

  Future<void> blockRelationship(String uid) async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final EventBus eventBus = ref.read(eventBusProvider);

    if (profileController.currentProfileId == null || uid.isEmpty) {
      logger.d('[Profile Service] - Cannot block user: $uid');
      return;
    }

    final CacheController cacheController = ref.read(cacheControllerProvider);
    final String relationshipId = [profileController.currentProfileId!, uid].asGUID;
    final Relationship? relationship = cacheController.get(relationshipId);
    final Set<RelationshipState> relationshipStates = relationship?.relationshipStatesForEntity(profileController.currentProfileId!) ?? {};
    if (relationshipStates.contains(RelationshipState.sourceBlocked)) {
      logger.d('[Profile Service] - User is already blocked: $uid');
      return;
    }

    logger.d('[Profile Service] - Blocking user: $uid');
    final RelationshipApiService relationshipApiService = await ref.read(relationshipApiServiceProvider.future);
    await relationshipApiService.blockRelationship(uid: uid);
    await analyticsController.trackEvent(AnalyticEvents.profileBlocked, properties: {'targetUserId': uid});

    logger.i('[Profile Service] - Blocked user: $uid');
    eventBus.fire(ForceFeedRebuildEvent());
  }

  Future<void> unblockRelationship(String uid) async {
    final Logger logger = ref.read(loggerProvider);
    final RelationshipApiService relationshipApiService = await ref.read(relationshipApiServiceProvider.future);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final EventBus eventBus = ref.read(eventBusProvider);

    logger.d('[Profile Service] - Unblocking user: $uid');
    await relationshipApiService.unblockRelationship(uid: uid);
    await analyticsController.trackEvent(AnalyticEvents.profileUnblocked, properties: {'targetUserId': uid});

    logger.d('[Profile Service] - Unblocked user: $uid');
    eventBus.fire(ForceFeedRebuildEvent());
  }

  Future<void> connectRelationship(String uid) async {
    final Logger logger = ref.read(loggerProvider);
    final RelationshipApiService relationshipApiService = await ref.read(relationshipApiServiceProvider.future);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final EventBus eventBus = ref.read(eventBusProvider);
    final PositiveConnectionRequestType connectionType = getPositiveConnectionRequestTypeForRelationship(uid, true);

    logger.d('[Profile Service] - Connecting user: $uid');
    await relationshipApiService.connectRelationship(uid: uid);

    if (connectionType == PositiveConnectionRequestType.accepting) {
      await analyticsController.trackEvent(AnalyticEvents.profileConnectionRequestAccepted, properties: {'targetUserId': uid});
    } else {
      await analyticsController.trackEvent(AnalyticEvents.profileConnectionRequestSent, properties: {'targetUserId': uid});
    }

    eventBus.fire(ForceFeedRebuildEvent());
    logger.i('[Profile Service] - Connected user: $uid');
  }

  Future<void> disconnectRelationship(String uid) async {
    final Logger logger = ref.read(loggerProvider);
    final RelationshipApiService relationshipApiService = await ref.read(relationshipApiServiceProvider.future);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final EventBus eventBus = ref.read(eventBusProvider);
    final PositiveConnectionRequestType connectionType = getPositiveConnectionRequestTypeForRelationship(uid, false);

    logger.d('[Profile Service] - Disconnecting user: $uid');
    await relationshipApiService.disconnectRelationship(uid: uid);

    if (connectionType == PositiveConnectionRequestType.declining) {
      await analyticsController.trackEvent(AnalyticEvents.profileConnectionRequestDeclined, properties: {'targetUserId': uid});
    } else {
      await analyticsController.trackEvent(AnalyticEvents.profileDisconnected, properties: {'targetUserId': uid});
    }

    logger.i('[Profile Service] - Disconnected user: $uid');
    eventBus.fire(ForceFeedRebuildEvent());
  }

  Future<void> followRelationship(String uid) async {
    final Logger logger = ref.read(loggerProvider);
    final RelationshipApiService relationshipApiService = await ref.read(relationshipApiServiceProvider.future);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    logger.d('[Profile Service] - Following user: $uid');

    await relationshipApiService.followRelationship(uid: uid);
    await analyticsController.trackEvent(AnalyticEvents.profileFollowed, properties: {'targetUserId': uid});
    logger.i('[Profile Service] - Followed user: $uid');
  }

  Future<void> unfollowRelationship(String uid) async {
    final Logger logger = ref.read(loggerProvider);
    final RelationshipApiService relationshipApiService = await ref.read(relationshipApiServiceProvider.future);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    logger.d('[Profile Service] - Unfollowing user: $uid');

    await relationshipApiService.unfollowRelationship(uid: uid);
    await analyticsController.trackEvent(AnalyticEvents.profileUnfollowed, properties: {'targetUserId': uid});
    logger.i('[Profile Service] - Unfollowed user: $uid');
  }

  Future<void> muteRelationship(String uid) async {
    final Logger logger = ref.read(loggerProvider);
    final RelationshipApiService relationshipApiService = await ref.read(relationshipApiServiceProvider.future);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    logger.d('[Profile Service] - Muting user: $uid');

    await relationshipApiService.muteRelationship(uid: uid);
    await analyticsController.trackEvent(AnalyticEvents.profileMuted, properties: {'targetUserId': uid});
    logger.i('[Profile Service] - Muted user: $uid');
  }

  Future<void> unmuteRelationship(String uid) async {
    final Logger logger = ref.read(loggerProvider);
    final RelationshipApiService relationshipApiService = await ref.read(relationshipApiServiceProvider.future);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    logger.d('[Profile Service] - Unmuting user: $uid');

    await relationshipApiService.unmuteRelationship(uid: uid);
    await analyticsController.trackEvent(AnalyticEvents.profileUnmuted, properties: {'targetUserId': uid});
    logger.i('[Profile Service] - Unmuted user: $uid');
  }

  Future<void> hideRelationship(String uid) async {
    final Logger logger = ref.read(loggerProvider);
    final RelationshipApiService relationshipApiService = await ref.read(relationshipApiServiceProvider.future);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final EventBus eventBus = ref.read(eventBusProvider);

    logger.d('[Profile Service] - Hiding user: $uid');
    await relationshipApiService.hideRelationship(uid: uid);
    await analyticsController.trackEvent(AnalyticEvents.profileHidden, properties: {'targetUserId': uid});

    logger.i('[Profile Service] - Hid user: $uid');
    eventBus.fire(ForceFeedRebuildEvent());
  }

  Future<void> unhideRelationship(String uid) async {
    final Logger logger = ref.read(loggerProvider);
    final RelationshipApiService relationshipApiService = await ref.read(relationshipApiServiceProvider.future);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final EventBus eventBus = ref.read(eventBusProvider);

    logger.d('[Profile Service] - Unhiding user: $uid');
    await relationshipApiService.unhideRelationship(uid: uid);
    await analyticsController.trackEvent(AnalyticEvents.profileUnhidden, properties: {'targetUserId': uid});

    logger.i('[Profile Service] - Unhid user: $uid');
    eventBus.fire(ForceFeedRebuildEvent());
  }
}
