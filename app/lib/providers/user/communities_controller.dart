// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:app/dtos/database/profile/profile.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/common/endpoint_response.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/database/relationships/relationship_member.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/relationship_search_api_service.dart';
import '../../services/third_party.dart';

part 'communities_controller.freezed.dart';
part 'communities_controller.g.dart';

@freezed
class CommunitiesControllerState with _$CommunitiesControllerState {
  const factory CommunitiesControllerState({
    required User? currentUser,
    required Profile? currentProfile,
    required CommunityType selectedCommunityType,
    @Default(false) bool isBusy,
    @Default({}) Set<String> followerProfileIds,
    @Default('') String followerPaginationCursor,
    @Default(true) bool hasMoreFollowers,
    @Default({}) Set<String> followingProfileIds,
    @Default('') String followingPaginationCursor,
    @Default(true) bool hasMoreFollowing,
    @Default({}) Set<String> blockedProfileIds,
    @Default('') String blockedPaginationCursor,
    @Default(true) bool hasMoreBlocked,
    @Default({}) Set<String> connectedProfileIds,
    @Default('') String connectedPaginationCursor,
    @Default(true) bool hasMoreConnected,
    @Default({}) Set<String> managedProfileIds,
    @Default('') String managedPaginationCursor,
    @Default(true) bool hasMoreManaged,
  }) = _CommunitiesControllerState;

  factory CommunitiesControllerState.initialState({
    required Profile? currentProfile,
    required User? currentUser,
  }) {
    final bool isManagedProfile = currentProfile != null && currentUser != null && currentProfile.flMeta?.id != currentUser.uid;
    return CommunitiesControllerState(
      currentUser: currentUser,
      currentProfile: currentProfile,
      selectedCommunityType: isManagedProfile ? CommunityType.managed : CommunityType.connected,
    );
  }
}

enum CommunityType {
  followers,
  following,
  blocked,
  connected,
  managed;

  static const List<CommunityType> userProfileCommunityTypes = [CommunityType.followers, CommunityType.following, CommunityType.blocked, CommunityType.connected];
  static const List<CommunityType> managedProfileCommunityTypes = [CommunityType.followers, CommunityType.following, CommunityType.managed];

  // The community locales are inverted as the backend uses the opposite terminology
  String toLocale(bool isManagedProfile) {
    return switch (this) {
      CommunityType.followers => 'Following',
      CommunityType.following => 'Followers',
      CommunityType.blocked => 'Blocked',
      CommunityType.connected => 'Connections',
      CommunityType.managed => isManagedProfile ? 'Team Members' : 'Managed',
    };
  }
}

@Riverpod(keepAlive: true)
class CommunitiesController extends _$CommunitiesController {
  StreamSubscription<User?>? _userChangesSubscription;
  StreamSubscription<CacheKeyUpdatedEvent>? _cacheKeyUpdatedSubscription;

  bool get hasLoadedInitialData => state.followerProfileIds.isNotEmpty || state.followingProfileIds.isNotEmpty || state.blockedProfileIds.isNotEmpty || state.connectedProfileIds.isNotEmpty;

  @override
  CommunitiesControllerState build({
    required Profile? currentProfile,
    required User? currentUser,
  }) {
    return CommunitiesControllerState.initialState(
      currentProfile: currentProfile,
      currentUser: currentUser,
    );
  }

  Future<void> setupListeners() async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final EventBus eventBus = ref.read(eventBusProvider);
    final Logger logger = ref.read(loggerProvider);

    await _userChangesSubscription?.cancel();
    _userChangesSubscription = userController.userChangedController.stream.listen(onUserChanged);

    await _cacheKeyUpdatedSubscription?.cancel();
    _cacheKeyUpdatedSubscription = eventBus.on<CacheKeyUpdatedEvent>().listen(onCacheRecordUpdated);
    logger.i('CommunitiesController - setupListeners - User changes subscription setup');

    if (!hasLoadedInitialData) {
      logger.i('CommunitiesController - setupListeners - Loading initial community data');
      unawaited(onUserChanged(userController.currentUser));
    }
  }

  void setSelectedCommunityType(dynamic value) {
    if (value is CommunityType) {
      state = state.copyWith(selectedCommunityType: value);
    }
  }

  /// Called when a cache record is updated
  /// Checks if the record is a relationship, and attempts to mirror the change in the local state
  void onCacheRecordUpdated(CacheKeyUpdatedEvent event) {
    if (event.value is! Relationship) {
      return;
    }

    updateCommunityRelationship(event.value as Relationship);
  }

  void updateCommunityRelationship(Relationship relationship) {
    final UserController userController = ref.read(userControllerProvider.notifier);
    if (userController.currentUser == null) {
      return;
    }

    final List<RelationshipState> relationshipStates = relationship.relationshipStatesForEntity(userController.currentUser!.uid).toList();
    if (relationshipStates.isEmpty) {
      return;
    }

    final String otherMemberId = relationship.members.firstWhere((RelationshipMember member) => member.memberId != userController.currentUser!.uid).memberId;
    final bool isConnection = state.connectedProfileIds.contains(otherMemberId);
    final bool isFollower = state.followerProfileIds.contains(otherMemberId);
    final bool isFollowing = state.followingProfileIds.contains(otherMemberId);
    final bool isBlocked = state.blockedProfileIds.contains(otherMemberId);

    if (relationshipStates.contains(RelationshipState.sourceConnected) && relationshipStates.contains(RelationshipState.targetConnected)) {
      if (!isConnection) {
        state = state.copyWith(connectedProfileIds: {...state.connectedProfileIds, otherMemberId});
      }
    } else {
      if (isConnection) {
        state = state.copyWith(connectedProfileIds: {...state.connectedProfileIds.where((element) => element != otherMemberId)});
      }
    }

    if (relationshipStates.contains(RelationshipState.sourceFollowed)) {
      if (!isFollower) {
        state = state.copyWith(followerProfileIds: {...state.followerProfileIds, otherMemberId});
      }
    } else {
      if (isFollower) {
        state = state.copyWith(followerProfileIds: {...state.followerProfileIds.where((element) => element != otherMemberId)});
      }
    }

    if (relationshipStates.contains(RelationshipState.targetFollowing)) {
      if (!isFollowing) {
        state = state.copyWith(followingProfileIds: {...state.followingProfileIds, otherMemberId});
      }
    } else {
      if (isFollowing) {
        state = state.copyWith(followingProfileIds: {...state.followingProfileIds.where((element) => element != otherMemberId)});
      }
    }

    if (relationshipStates.contains(RelationshipState.sourceBlocked)) {
      if (!isBlocked) {
        state = state.copyWith(blockedProfileIds: {...state.blockedProfileIds, otherMemberId});
      }
    } else {
      if (isBlocked) {
        state = state.copyWith(blockedProfileIds: {...state.blockedProfileIds.where((element) => element != otherMemberId)});
      }
    }
  }

  Future<void> onUserChanged(User? user) async {
    final Logger logger = ref.read(loggerProvider);
    logger.i('CommunitiesController - onUserChanged - User changed');

    if (user == null) {
      logger.i('CommunitiesController - onUserChanged - User is null');
      resetCommunityData();
      return;
    }

    unawaited(loadInitialCommunityData());
  }

  void resetCommunityData({User? user}) {
    final Logger logger = ref.read(loggerProvider);
    logger.i('CommunitiesController - resetCommunityData - Resetting community data');

    state = state.copyWith(
      selectedCommunityType: CommunityType.connected,
      followerProfileIds: {},
      followerPaginationCursor: '',
      hasMoreFollowers: true,
      followingProfileIds: {},
      followingPaginationCursor: '',
      hasMoreFollowing: true,
      blockedProfileIds: {},
      blockedPaginationCursor: '',
      hasMoreBlocked: true,
      connectedProfileIds: {},
      connectedPaginationCursor: '',
      hasMoreConnected: true,
      managedProfileIds: {},
      managedPaginationCursor: '',
      hasMoreManaged: true,
    );
  }

  void resetCommunityDataForType({required CommunityType type}) {
    final Logger logger = ref.read(loggerProvider);
    logger.i('CommunitiesController - resetCommunityDataForType - Resetting community data for type: $type');

    state = switch (type) {
      CommunityType.connected => state.copyWith(
          connectedProfileIds: {},
          connectedPaginationCursor: '',
          hasMoreConnected: true,
        ),
      CommunityType.followers => state.copyWith(
          followerProfileIds: {},
          followerPaginationCursor: '',
          hasMoreFollowers: true,
        ),
      CommunityType.following => state.copyWith(
          followingProfileIds: {},
          followingPaginationCursor: '',
          hasMoreFollowing: true,
        ),
      CommunityType.blocked => state.copyWith(
          blockedProfileIds: {},
          blockedPaginationCursor: '',
          hasMoreBlocked: true,
        ),
      CommunityType.managed => state.copyWith(
          managedProfileIds: {},
          managedPaginationCursor: '',
          hasMoreManaged: true,
        ),
    };
  }

  Future<void> loadInitialCommunityData() async {
    final Logger logger = ref.read(loggerProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);
    logger.i('CommunitiesController - loadInitialCommunityData - Loading initial community data');

    if (userController.currentUser == null) {
      logger.w('CommunitiesController - loadInitialCommunityData - User is null');
      return;
    }

    if (hasLoadedInitialData) {
      logger.i('CommunitiesController - loadInitialCommunityData - Initial community data already loaded');
      return;
    }

    await Future.wait([
      loadNextCommunityData(type: CommunityType.followers),
      loadNextCommunityData(type: CommunityType.following),
      loadNextCommunityData(type: CommunityType.blocked),
      loadNextCommunityData(type: CommunityType.connected),
      loadNextCommunityData(type: CommunityType.managed),
    ]);
  }

  Future<void> loadNextCommunityData({
    required CommunityType type,
  }) async {
    final Logger logger = ref.read(loggerProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);
    logger.i('CommunitiesController - loadNextCommunityData - Loading next community data');

    if (userController.currentUser == null) {
      logger.d('CommunitiesController - loadNextCommunityData - User is null');
      return;
    }

    final bool canGetNext = switch (type) {
      CommunityType.connected => state.hasMoreConnected,
      CommunityType.followers => state.hasMoreFollowers,
      CommunityType.following => state.hasMoreFollowing,
      CommunityType.blocked => state.hasMoreBlocked,
      CommunityType.managed => state.hasMoreManaged,
    };

    if (!canGetNext) {
      logger.w('CommunitiesController - loadNextCommunityData - No more data to load');
      return;
    }

    final RelationshipSearchApiService relationshipSearchApiService = ref.read(relationshipSearchApiServiceProvider);
    final EndpointResponse response = switch (type) {
      CommunityType.connected => await relationshipSearchApiService.listConnectedRelationships(cursor: state.connectedPaginationCursor),
      CommunityType.followers => await relationshipSearchApiService.listFollowedRelationships(cursor: state.followerPaginationCursor),
      CommunityType.following => await relationshipSearchApiService.listFollowingRelationships(cursor: state.followingPaginationCursor),
      CommunityType.blocked => await relationshipSearchApiService.listBlockedRelationships(cursor: state.blockedPaginationCursor),
      CommunityType.managed => await relationshipSearchApiService.listManagedRelationships(cursor: state.managedPaginationCursor),
    };

    final Map<String, dynamic> data = response.data;
    final List<dynamic> relationships = (data.containsKey('relationships') ? data['relationships'] : []).map((dynamic relationship) => json.decodeSafe(relationship)).toList();
    final List<String> newRelationshipIds = [];

    for (final dynamic relationship in relationships) {
      try {
        final Relationship newRelationship = Relationship.fromJson(relationship);
        if (newRelationship.members.length != 2) {
          logger.e('requestNextTimelinePage() - Relationship has ${newRelationship.members.length} members, expected 2');
          continue;
        }

        final String memberId = newRelationship.members.firstWhere((RelationshipMember member) => member.memberId != userController.currentUser!.uid).memberId;
        if (memberId.isEmpty) {
          logger.e('requestNextTimelinePage() - Failed to get member id from relationship: $relationship');
          continue;
        }

        newRelationshipIds.add(memberId);
      } catch (ex) {
        logger.e('requestNextTimelinePage() - Failed to cache relationship: $relationship - ex: $ex');
      }
    }

    final String cursor = response.cursor ?? '';
    final String currentCursor = switch (type) {
      CommunityType.connected => state.connectedPaginationCursor,
      CommunityType.followers => state.followerPaginationCursor,
      CommunityType.following => state.followingPaginationCursor,
      CommunityType.blocked => state.blockedPaginationCursor,
      CommunityType.managed => state.managedPaginationCursor,
    };

    final bool hasMoreData = cursor.isNotEmpty && relationships.isNotEmpty && cursor != currentCursor;
    logger.i('CommunitiesController - loadNextCommunityData - hasMoreData: $hasMoreData, cursor: $cursor, newRelationshipIds: $newRelationshipIds');

    state = switch (type) {
      CommunityType.connected => state.copyWith(connectedPaginationCursor: cursor, hasMoreConnected: hasMoreData, connectedProfileIds: {...state.connectedProfileIds, ...newRelationshipIds}),
      CommunityType.followers => state.copyWith(followerPaginationCursor: cursor, hasMoreFollowers: hasMoreData, followerProfileIds: {...state.followerProfileIds, ...newRelationshipIds}),
      CommunityType.following => state.copyWith(followingPaginationCursor: cursor, hasMoreFollowing: hasMoreData, followingProfileIds: {...state.followingProfileIds, ...newRelationshipIds}),
      CommunityType.blocked => state.copyWith(blockedPaginationCursor: cursor, hasMoreBlocked: hasMoreData, blockedProfileIds: {...state.blockedProfileIds, ...newRelationshipIds}),
      CommunityType.managed => state.copyWith(managedPaginationCursor: cursor, hasMoreManaged: hasMoreData, managedProfileIds: {...state.managedProfileIds, ...newRelationshipIds}),
    };

    logger.d('CommunitiesController - loadNextCommunityData - Loaded next community data');
  }
}
