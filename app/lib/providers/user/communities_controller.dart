// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/common/endpoint_response.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/database/relationships/relationship_member.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/extensions/paging_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/relationship_search_api_service.dart';
import 'package:app/widgets/state/positive_community_feed_state.dart';
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
  managed,
  supported;

  static const List<CommunityType> userProfileCommunityTypes = [CommunityType.followers, CommunityType.following, CommunityType.blocked, CommunityType.connected];
  static const List<CommunityType> managedProfileCommunityTypes = [CommunityType.followers, CommunityType.following, CommunityType.managed];

  // The community locales are inverted as the backend uses the opposite terminology
  String toLocale(bool isManagedProfile) {
    return switch (this) {
      CommunityType.followers => 'Followers',
      CommunityType.following => 'Following',
      CommunityType.blocked => 'Blocked',
      CommunityType.connected => 'Connections',
      CommunityType.managed => isManagedProfile ? 'Team Members' : 'Managed',
      CommunityType.supported => 'Profiles',
    };
  }
}

@Riverpod(keepAlive: true)
class CommunitiesController extends _$CommunitiesController with LifecycleMixin {
  StreamSubscription<CacheKeyUpdatedEvent>? _cacheKeyUpdatedSubscription;

  PositiveCommunityFeedState get communityFeedState => getCommunityFeedStateForType(
        communityType: state.selectedCommunityType,
        currentProfile: state.currentProfile,
      );

  bool get hasLoadedInitialData => communityFeedState.hasPerformedInitialLoad;

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

  @override
  void onFirstRender() {
    final Logger logger = ref.read(loggerProvider);
    logger.i('CommunitiesController - onFirstRender - First render');
    setupListeners();

    if (!hasLoadedInitialData) {
      logger.i('CommunitiesController - setupListeners - Loading initial community data');
      loadInitialCommunityData();
    }
  }

  Future<void> setupListeners() async {
    final EventBus eventBus = ref.read(eventBusProvider);
    final Logger logger = ref.read(loggerProvider);

    await _cacheKeyUpdatedSubscription?.cancel();
    _cacheKeyUpdatedSubscription = eventBus.on<CacheKeyUpdatedEvent>().listen(onCacheRecordUpdated);
    logger.i('CommunitiesController - setupListeners - User changes subscription setup');
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

  PositiveCommunityFeedState getCommunityFeedStateForType({
    required CommunityType communityType,
    required Profile? currentProfile,
  }) {
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final String currentProfileId = profileController.currentProfileId ?? '';

    final String feedsCacheKey = PositiveCommunityFeedState.buildFeedCacheKey(currentProfileId, communityType);
    final CacheController cacheController = ref.read(cacheControllerProvider);

    final PositiveCommunityFeedState? cachedState = cacheController.get(feedsCacheKey);
    if (cachedState != null) {
      return cachedState;
    }

    final PositiveCommunityFeedState newState = PositiveCommunityFeedState.buildNewState(
      communityType: communityType,
      currentProfileId: currentProfileId,
    );

    cacheController.add(key: feedsCacheKey, value: newState);
    return newState;
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

    final PositiveCommunityFeedState connectionFeedState = getCommunityFeedStateForType(
      communityType: CommunityType.connected,
      currentProfile: state.currentProfile,
    );

    final PositiveCommunityFeedState followerFeedState = getCommunityFeedStateForType(
      communityType: CommunityType.followers,
      currentProfile: state.currentProfile,
    );

    final PositiveCommunityFeedState followingFeedState = getCommunityFeedStateForType(
      communityType: CommunityType.following,
      currentProfile: state.currentProfile,
    );

    final PositiveCommunityFeedState blockedFeedState = getCommunityFeedStateForType(
      communityType: CommunityType.blocked,
      currentProfile: state.currentProfile,
    );

    final PositiveCommunityFeedState managedFeedState = getCommunityFeedStateForType(
      communityType: CommunityType.managed,
      currentProfile: state.currentProfile,
    );

    final bool hasConnectionId = (connectionFeedState.pagingController.value.itemList ?? []).contains(otherMemberId);
    final bool hasFollowerId = (followerFeedState.pagingController.value.itemList ?? []).contains(otherMemberId);
    final bool hasFollowingId = (followingFeedState.pagingController.value.itemList ?? []).contains(otherMemberId);
    final bool hasBlockedId = (blockedFeedState.pagingController.value.itemList ?? []).contains(otherMemberId);
    final bool hasManagedId = (managedFeedState.pagingController.value.itemList ?? []).contains(otherMemberId);

    if (relationshipStates.contains(RelationshipState.sourceConnected) && relationshipStates.contains(RelationshipState.targetConnected)) {
      if (!hasConnectionId) {
        connectionFeedState.pagingController.itemList = {...connectionFeedState.pagingController.itemList ?? <String>[], otherMemberId}.toList();
      }
    } else {
      if (hasConnectionId) {
        connectionFeedState.pagingController.itemList = {...connectionFeedState.pagingController.itemList ?? <String>[]}.where((element) => element != otherMemberId).toList();
      }
    }

    if (relationshipStates.contains(RelationshipState.sourceFollowed)) {
      if (!hasFollowerId) {
        followerFeedState.pagingController.itemList = {...followerFeedState.pagingController.itemList ?? <String>[], otherMemberId}.toList();
      }
    } else {
      if (hasFollowerId) {
        followerFeedState.pagingController.itemList = {...followerFeedState.pagingController.itemList ?? <String>[]}.where((element) => element != otherMemberId).toList();
      }
    }

    if (relationshipStates.contains(RelationshipState.targetFollowing)) {
      if (!hasFollowingId) {
        followingFeedState.pagingController.itemList = {...followingFeedState.pagingController.itemList ?? <String>[], otherMemberId}.toList();
      }
    } else {
      if (hasFollowingId) {
        followingFeedState.pagingController.itemList = {...followingFeedState.pagingController.itemList ?? <String>[]}.where((element) => element != otherMemberId).toList();
      }
    }

    if (relationshipStates.contains(RelationshipState.sourceBlocked)) {
      if (!hasBlockedId) {
        blockedFeedState.pagingController.itemList = {...blockedFeedState.pagingController.itemList ?? <String>[], otherMemberId}.toList();
      }
    } else {
      if (hasBlockedId) {
        blockedFeedState.pagingController.itemList = {...blockedFeedState.pagingController.itemList ?? <String>[]}.where((element) => element != otherMemberId).toList();
      }
    }

    if (relationshipStates.contains(RelationshipState.targetManaged)) {
      if (!hasManagedId) {
        managedFeedState.pagingController.itemList = {...managedFeedState.pagingController.itemList ?? <String>[], otherMemberId}.toList();
      }
    } else {
      if (hasManagedId) {
        managedFeedState.pagingController.itemList = {...managedFeedState.pagingController.itemList ?? <String>[]}.where((element) => element != otherMemberId).toList();
      }
    }
  }

  void resetCommunityDataForType({required CommunityType type}) {
    final Logger logger = ref.read(loggerProvider);
    logger.i('CommunitiesController - resetCommunityDataForType - Resetting community data for type: $type');

    final PositiveCommunityFeedState feedState = getCommunityFeedStateForType(
      communityType: type,
      currentProfile: state.currentProfile,
    );

    feedState.hasPerformedInitialLoad = false;
    feedState.currentPaginationKey = '';

    feedState.pagingController.refresh();
    saveFeedState(feedState);
  }

  static Future<void> loadFirstWindowForAllAccountsIfNeeded() async {
    final Logger logger = providerContainer.read(loggerProvider);
    final FirebaseAuth firebaseAuth = providerContainer.read(firebaseAuthProvider);
    final User? currentUser = firebaseAuth.currentUser;
    if (currentUser == null) {
      logger.e('CommunitiesController - loadFirstWindowForAllAccountsIfNeeded - Current user is null');
      return;
    }

    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final ProfileControllerState profileControllerState = providerContainer.read(profileControllerProvider);
    final Set<String> supportedProfileIds = profileControllerState.availableProfileIds;

    final List<Future<void>> futures = [];
    for (final String profileId in supportedProfileIds) {
      final Profile? profile = cacheController.get(profileId);
      if (profile == null) {
        logger.e('CommunitiesController - loadFirstWindowForAllAccountsIfNeeded - Profile is null for id: $profileId');
        continue;
      }

      await loadFirstWindowForAccountIfNeeded(
        currentProfile: profile,
        currentUser: currentUser,
      );
    }

    await Future.wait(futures);
  }

  static Future<void> loadFirstWindowForAccountIfNeeded({
    required Profile currentProfile,
    required User currentUser,
  }) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider);

    final CommunitiesControllerProvider provider = communitiesControllerProvider(currentProfile: currentProfile, currentUser: currentUser);
    final CommunitiesController communitiesController = providerContainer.read(provider.notifier);
    final Profile? cachedProfile = cacheController.get(currentProfile.flMeta?.id ?? '');
    if (cachedProfile == null) {
      logger.e('CommunitiesController - loadFirstWindowForAccountIfNeeded - Cached profile is null');
      return;
    }

    final bool hasLoadedInitialData = communitiesController.hasLoadedInitialData;
    if (hasLoadedInitialData) {
      logger.i('CommunitiesController - loadFirstWindowForAccountIfNeeded - Initial community data already loaded');
      return;
    }

    await communitiesController.loadInitialCommunityData();
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
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    final String currentProfileId = profileController.currentProfileId ?? '';
    if (currentProfileId.isEmpty) {
      logger.w('CommunitiesController - loadNextCommunityData - Current profile is null');
      return;
    }

    final PositiveCommunityFeedState feedState = getCommunityFeedStateForType(
      communityType: type,
      currentProfile: state.currentProfile,
    );

    final bool canGetNext = feedState.pagingController.value.status != PagingStatus.completed;
    if (!canGetNext) {
      logger.w('CommunitiesController - loadNextCommunityData - No more data to load');
      return;
    }

    final bool isManagedProfile = profileController.isCurrentManagedProfile;
    if (!isManagedProfile && CommunityType.managed == type) {
      logger.w('CommunitiesController - loadNextCommunityData - Cannot load managed community data for non-managed profile');
      return;
    }

    late final EndpointResponse response;
    final List<String> newRelationshipIds = [];

    try {
      final RelationshipSearchApiService relationshipSearchApiService = ref.read(relationshipSearchApiServiceProvider);
      response = switch (type) {
        CommunityType.connected => await relationshipSearchApiService.listConnectedRelationships(cursor: feedState.currentPaginationKey),
        CommunityType.followers => await relationshipSearchApiService.listFollowedRelationships(cursor: feedState.currentPaginationKey),
        CommunityType.following => await relationshipSearchApiService.listFollowingRelationships(cursor: feedState.currentPaginationKey),
        CommunityType.blocked => await relationshipSearchApiService.listBlockedRelationships(cursor: feedState.currentPaginationKey),
        CommunityType.managed => await relationshipSearchApiService.listManagedRelationships(cursor: feedState.currentPaginationKey),
        _ => throw Exception('CommunitiesController - loadNextCommunityData - Unsupported community type: $type'),
      };

      feedState.hasPerformedInitialLoad = true;

      final Map<String, dynamic> data = response.data;
      final List<dynamic> relationships = (data.containsKey('relationships') ? data['relationships'] : []).map((dynamic relationship) => json.decodeSafe(relationship)).toList();
      for (final dynamic relationship in relationships) {
        try {
          final Relationship newRelationship = Relationship.fromJson(relationship);
          if (newRelationship.members.length != 2) {
            logger.e('requestNextTimelinePage() - Relationship has ${newRelationship.members.length} members, expected 2');
            continue;
          }

          final String memberId = newRelationship.members.firstWhere((RelationshipMember member) => member.memberId != currentProfileId).memberId;
          if (memberId.isEmpty) {
            logger.e('requestNextTimelinePage() - Failed to get member id from relationship: $relationship');
            continue;
          }

          newRelationshipIds.add(memberId);
        } catch (ex) {
          logger.e('requestNextTimelinePage() - Failed to cache relationship: $relationship - ex: $ex');
        }
      }

      feedState.currentPaginationKey = response.cursor ?? '';
      saveFeedState(feedState);
    } catch (ex) {
      logger.e('CommunitiesController - loadNextCommunityData - Failed to load community data - ex: $ex');
      feedState.pagingController.error = ex;
      saveFeedState(feedState);
      return;
    }

    final String cursor = response.cursor ?? '';
    final String currentCursor = feedState.currentPaginationKey;
    final bool hasMoreData = cursor.isNotEmpty && newRelationshipIds.isNotEmpty && cursor != currentCursor;

    logger.d('CommunitiesController - loadNextCommunityData - Loaded next community data appending to page');
    final PagingController<String, String> pagingController = feedState.pagingController;

    // Remove all records that are already in the list
    newRelationshipIds.removeWhere((String id) => pagingController.itemList?.contains(id) ?? false);

    if (hasMoreData) {
      pagingController.appendSafePage(newRelationshipIds, cursor);
    } else {
      pagingController.appendLastPage(newRelationshipIds);
    }

    saveFeedState(feedState);
    logger.d('CommunitiesController - loadNextCommunityData - Appended next community data to page');

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    pagingController.notifyListeners();
  }

  void saveFeedState(PositiveCommunityFeedState feedState) {
    final CacheController cacheController = ref.read(cacheControllerProvider);
    final Logger logger = ref.read(loggerProvider);
    final String cacheKey = feedState.buildCacheKey();
    if (cacheKey.isEmpty) {
      logger.e('CommunitiesController - saveFeedState - Cache key is empty');
      return;
    }

    cacheController.add(key: cacheKey, value: feedState);
  }
}
