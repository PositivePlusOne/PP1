// Dart imports:
import 'dart:async';
import 'dart:collection';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/builders/relationship_search_filter_builder.dart';
import 'package:app/dtos/database/common/endpoint_response.dart';
import 'package:app/dtos/database/pagination/pagination.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/database/relationships/relationship_member.dart';
import 'package:app/extensions/future_extensions.dart';
import 'package:app/extensions/paging_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/relationship_search_api_service.dart';
import 'package:app/services/search_api_service.dart';
import 'package:app/widgets/state/positive_community_feed_state.dart';
import '../../services/third_party.dart';

part 'communities_controller.freezed.dart';
part 'communities_controller.g.dart';

@freezed
class CommunitiesControllerState with _$CommunitiesControllerState {
  const factory CommunitiesControllerState({
    required String currentUserId,
    required String currentProfileId,
    required CommunityType selectedCommunityType,
    @Default('') String searchQuery,
    @Default(false) bool isBusy,
  }) = _CommunitiesControllerState;

  factory CommunitiesControllerState.initialState({
    required String? currentProfileId,
    required String? currentUserId,
    bool isManagedProfile = false,
  }) {
    return CommunitiesControllerState(
      currentUserId: currentUserId ?? '',
      currentProfileId: currentProfileId ?? '',
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
  final TextEditingController searchController = TextEditingController();

  StreamSubscription<CacheKeyUpdatedEvent>? _cacheKeyUpdatedSubscription;

  Profile? getCurrentProfile() => ref.read(cacheControllerProvider).get(state.currentProfileId);

  @override
  CommunitiesControllerState build({
    required String? currentProfileId,
    required String? currentUserId,
    bool isManagedProfile = false,
  }) {
    return CommunitiesControllerState.initialState(
      currentProfileId: currentProfileId,
      currentUserId: currentUserId,
      isManagedProfile: isManagedProfile,
    );
  }

  @override
  void onFirstRender() {
    final Logger logger = ref.read(loggerProvider);
    logger.i('CommunitiesController - onFirstRender - First render');
    setupListeners();

    final Profile? currentProfile = getCurrentProfile();
    if (currentProfile == null) {
      logger.w('CommunitiesController - onFirstRender - Current profile is null');
      return;
    }

    final PositiveCommunityFeedState feedState = getCommunityFeedStateForType(
      communityType: state.selectedCommunityType,
      profile: currentProfile,
      searchQuery: state.searchQuery,
    );

    if (!feedState.hasPerformedInitialLoad) {
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

    final PositiveCommunityFeedState currentFeedState = getCurrentCommunityFeedState();
    currentFeedState.pagingController.addPageRequestListener((pageKey) => requestNextPage(pageKey, state.selectedCommunityType));
  }

  void teardownListeners() async {
    final PositiveCommunityFeedState currentFeedState = getCurrentCommunityFeedState();
    currentFeedState.pagingController.removePageRequestListener((pageKey) => requestNextPage(pageKey, state.selectedCommunityType));
  }

  void setSelectedCommunityType(dynamic value) {
    if (value is! CommunityType) {
      return;
    }

    if (value == state.selectedCommunityType) {
      return;
    }

    searchController.clear();
    state = state.copyWith(selectedCommunityType: value, searchQuery: '');

    // Check if the community type requires a page load
    final PositiveCommunityFeedState currentFeedState = getCurrentCommunityFeedState();
    final bool isExhaused = currentFeedState.pagingController.value.status == PagingStatus.completed;
    if (isExhaused) {
      return;
    }

    final String cursor = currentFeedState.currentPaginationKey;
    requestNextPage(cursor, state.selectedCommunityType);
  }

  Future<void> requestNextPage(String cursor, CommunityType communityType) => runWithMutex(() async {
        final Logger logger = ref.read(loggerProvider);
        final PositiveCommunityFeedState currentFeedState = getCurrentCommunityFeedState();
        final bool canLoadNext = currentFeedState.pagingController.value.status != PagingStatus.completed;
        if (!canLoadNext) {
          logger.d('No more pages to load: $communityType');
          return;
        }

        // Supported profiles are not paginated
        if (communityType == CommunityType.supported) {
          logger.e('Cannot load next page for supported profiles');
          return;
        }

        // For searches, we only load the first page
        final bool isSearch = state.searchQuery.isNotEmpty;
        final bool hasItems = currentFeedState.pagingController.itemList?.isNotEmpty ?? false;
        if (isSearch && hasItems) {
          logger.e('Cannot load next page for search results');
          return;
        }

        try {
          if (isSearch) {
            await loadNextSearchCommunityData(feedState: currentFeedState);
          } else {
            await loadNextInternalCommunityData(feedState: currentFeedState);
          }
        } catch (ex) {
          logger.e('Failed to load next page: $communityType - ex: $ex');
          currentFeedState.pagingController.error = ex;
        }
      });

  /// Called when a cache record is updated
  /// Checks if the record is a relationship, and attempts to mirror the change in the local state
  void onCacheRecordUpdated(CacheKeyUpdatedEvent event) {
    if (event.value is! Relationship) {
      return;
    }

    updateCommunityRelationship(event.value as Relationship);
  }

  PositiveCommunityFeedState getCurrentCommunityFeedState() {
    final Profile? currentProfile = getCurrentProfile();
    if (currentProfile == null) {
      return PositiveCommunityFeedState.buildNewState(
        communityType: state.selectedCommunityType,
        currentProfileId: '',
        searchQuery: '',
      );
    }

    return getCommunityFeedStateForType(
      communityType: state.selectedCommunityType,
      profile: currentProfile,
      searchQuery: state.searchQuery,
    );
  }

  PositiveCommunityFeedState getCommunityFeedStateForType({
    required CommunityType communityType,
    required Profile? profile,
    required String searchQuery,
  }) {
    final String currentProfileId = profile?.flMeta?.id ?? '';
    if (currentProfileId.isEmpty) {
      return PositiveCommunityFeedState.buildNewState(
        communityType: communityType,
        currentProfileId: currentProfileId,
        searchQuery: searchQuery,
      );
    }

    final String feedsCacheKey = PositiveCommunityFeedState.buildFeedCacheKey(currentProfileId, communityType, searchQuery);
    final CacheController cacheController = ref.read(cacheControllerProvider);

    final PositiveCommunityFeedState? cachedState = cacheController.get(feedsCacheKey);
    if (cachedState != null) {
      return cachedState;
    }

    final PositiveCommunityFeedState newState = PositiveCommunityFeedState.buildNewState(
      communityType: communityType,
      currentProfileId: currentProfileId,
      searchQuery: searchQuery,
    );

    cacheController.add(key: feedsCacheKey, value: newState);
    return newState;
  }

  void updateCommunityRelationship(Relationship relationship) {
    final String currentProfileId = getCurrentProfile()?.flMeta?.id ?? '';
    final List<RelationshipState> relationshipStates = relationship.relationshipStatesForEntity(currentProfileId).toList();
    if (relationshipStates.isEmpty) {
      return;
    }

    final String otherMemberId = relationship.members.firstWhere((RelationshipMember member) => member.memberId != currentProfileId).memberId;
    final Profile? currentProfile = getCurrentProfile();

    final PositiveCommunityFeedState connectionFeedState = getCommunityFeedStateForType(
      communityType: CommunityType.connected,
      profile: currentProfile,
      searchQuery: state.searchQuery,
    );

    final PositiveCommunityFeedState followerFeedState = getCommunityFeedStateForType(
      communityType: CommunityType.followers,
      profile: currentProfile,
      searchQuery: state.searchQuery,
    );

    final PositiveCommunityFeedState followingFeedState = getCommunityFeedStateForType(
      communityType: CommunityType.following,
      profile: currentProfile,
      searchQuery: state.searchQuery,
    );

    final PositiveCommunityFeedState blockedFeedState = getCommunityFeedStateForType(
      communityType: CommunityType.blocked,
      profile: currentProfile,
      searchQuery: state.searchQuery,
    );

    final PositiveCommunityFeedState managedFeedState = getCommunityFeedStateForType(
      communityType: CommunityType.managed,
      profile: currentProfile,
      searchQuery: state.searchQuery,
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

  void resetCommunityDataForType({
    required Profile? currentProfile,
    required CommunityType type,
    required String searchQuery,
  }) {
    final Logger logger = ref.read(loggerProvider);
    logger.i('CommunitiesController - resetCommunityDataForType - Resetting community data for type: $type');

    final PositiveCommunityFeedState feedState = getCommunityFeedStateForType(
      communityType: type,
      profile: currentProfile,
      searchQuery: searchQuery,
    );

    feedState.hasPerformedInitialLoad = false;
    feedState.currentPaginationKey = '';

    feedState.pagingController.refresh();
    saveFeedState(feedState);
  }

  Future<void> loadFirstWindowForAccountIfNeeded() async {
    final Logger logger = providerContainer.read(loggerProvider);
    final Profile? cachedProfile = getCurrentProfile();
    if (cachedProfile == null) {
      logger.e('CommunitiesController - loadFirstWindowForAccountIfNeeded - Cached profile is null');
      return;
    }

    final PositiveCommunityFeedState feedState = getCurrentCommunityFeedState();

    final bool hasLoadedInitialData = feedState.hasPerformedInitialLoad;
    if (hasLoadedInitialData) {
      logger.i('CommunitiesController - loadFirstWindowForAccountIfNeeded - Initial community data already loaded');
      return;
    }

    await loadInitialCommunityData();
  }

  Future<void> loadInitialCommunityData() async {
    final Logger logger = ref.read(loggerProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);
    logger.i('CommunitiesController - loadInitialCommunityData - Loading initial community data');

    if (userController.currentUser == null) {
      logger.w('CommunitiesController - loadInitialCommunityData - User is null');
      return;
    }

    final Profile? currentProfile = getCurrentProfile();
    final PositiveCommunityFeedState followingFeedState = getCommunityFeedStateForType(communityType: CommunityType.following, profile: currentProfile, searchQuery: '');
    final PositiveCommunityFeedState followersFeedState = getCommunityFeedStateForType(communityType: CommunityType.followers, profile: currentProfile, searchQuery: '');
    final PositiveCommunityFeedState blockedFeedState = getCommunityFeedStateForType(communityType: CommunityType.blocked, profile: currentProfile, searchQuery: '');
    final PositiveCommunityFeedState connectedFeedState = getCommunityFeedStateForType(communityType: CommunityType.connected, profile: currentProfile, searchQuery: '');
    final PositiveCommunityFeedState managedFeedState = getCommunityFeedStateForType(communityType: CommunityType.managed, profile: currentProfile, searchQuery: '');

    if (followingFeedState.hasPerformedInitialLoad) {
      logger.i('CommunitiesController - loadInitialCommunityData - Initial community data already loaded');
      return;
    }

    await Future.wait([
      loadNextInternalCommunityData(feedState: followingFeedState),
      loadNextInternalCommunityData(feedState: followersFeedState),
      loadNextInternalCommunityData(feedState: blockedFeedState),
      loadNextInternalCommunityData(feedState: connectedFeedState),
      loadNextInternalCommunityData(feedState: managedFeedState),
    ]);
  }

  Future<void> loadNextSearchCommunityData({
    required PositiveCommunityFeedState feedState,
  }) async {
    final Logger logger = ref.read(loggerProvider);
    final RelationshipSearchFilterBuilder filterBuilder = RelationshipSearchFilterBuilder();
    final Profile? currentProfile = getCurrentProfile();
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';
    final String searchQuery = state.searchQuery;

    if (currentProfile == null) {
      logger.w('CommunitiesController - loadNextSearchCommunityData - Current profile is null');
      return;
    }

    switch (feedState.communityType) {
      case CommunityType.connected:
        filterBuilder.addConnectedFilter(currentProfileId);
        filterBuilder.addFullyConnectedFilter();
        break;
      case CommunityType.followers:
        filterBuilder.addFollowerFilter(currentProfileId);
        break;
      case CommunityType.following:
        filterBuilder.addFollowingFilter(currentProfileId);
        break;
      case CommunityType.blocked:
        filterBuilder.addBlockedFilter(currentProfileId);
        break;
      case CommunityType.managed:
        filterBuilder.addManagedFilter(currentProfileId);
        break;
      default:
        throw Exception('CommunitiesController - loadNextSearchCommunityData - Unsupported community type: ${feedState.communityType}');
    }

    final SearchApiService searchApiService = await ref.read(searchApiServiceProvider.future);
    final UnmodifiableListView<String> filters = filterBuilder.filters;

    try {
      final SearchResult<Relationship> response = await searchApiService.search(
        query: searchQuery,
        index: "relationships",
        fromJson: (json) => Relationship.fromJson(json),
        facetFilters: filters,
        pagination: const Pagination(
          limit: 10,
        ),
      );

      logger.d('CommunitiesController - loadNextSearchCommunityData - Loaded next community data appending to page');
      appendToFeedState(
        currentProfile: currentProfile,
        feedState: feedState,
        relationships: response.results,
        cursor: response.cursor,
      );
    } catch (ex) {
      logger.e('CommunitiesController - loadNextSearchCommunityData - Failed to load community data - ex: $ex');
      feedState.pagingController.error = ex;
      return;
    } finally {
      saveFeedState(feedState);
    }
  }

  Future<void> loadNextInternalCommunityData({
    required PositiveCommunityFeedState feedState,
  }) async {
    final Logger logger = ref.read(loggerProvider);
    final Profile? currentProfile = getCurrentProfile();
    if (currentProfile == null) {
      logger.w('CommunitiesController - loadNextCommunityData - Current profile is null');
      return;
    }

    final bool canGetNext = feedState.pagingController.value.status != PagingStatus.completed;
    if (!canGetNext) {
      logger.w('CommunitiesController - loadNextCommunityData - No more data to load');
      return;
    }

    final bool isManagedProfile = currentProfile.isOrganisation;
    if (!isManagedProfile && CommunityType.managed == feedState.communityType) {
      logger.w('CommunitiesController - loadNextCommunityData - Cannot load managed community data for non-managed profile');
      return;
    }

    EndpointResponse? response;
    final PagingController<String, String> pagingController = feedState.pagingController;

    try {
      final RelationshipSearchApiService relationshipSearchApiService = ref.read(relationshipSearchApiServiceProvider);
      response = switch (feedState.communityType) {
        CommunityType.connected => await relationshipSearchApiService.listConnectedRelationships(cursor: feedState.currentPaginationKey),
        CommunityType.followers => await relationshipSearchApiService.listFollowedRelationships(cursor: feedState.currentPaginationKey),
        CommunityType.following => await relationshipSearchApiService.listFollowingRelationships(cursor: feedState.currentPaginationKey),
        CommunityType.blocked => await relationshipSearchApiService.listBlockedRelationships(cursor: feedState.currentPaginationKey),
        CommunityType.managed => await relationshipSearchApiService.listManagedRelationships(cursor: feedState.currentPaginationKey),
        _ => throw Exception('CommunitiesController - loadNextCommunityData - Unsupported community type: ${feedState.communityType}'),
      };

      final List relationshipRawData = (response.data.containsKey('relationships') && response.data['relationships'] is List<dynamic>) ? response.data['relationships'] as List<dynamic> : [];
      final List<Relationship> relationships = relationshipRawData.map((dynamic relationship) => Relationship.fromJson(relationship)).toList();

      appendToFeedState(
        currentProfile: currentProfile,
        feedState: feedState,
        relationships: relationships,
        cursor: response.cursor ?? '',
      );
    } catch (ex) {
      logger.e('CommunitiesController - loadNextCommunityData - Failed to load community data - ex: $ex');
      pagingController.error = ex;
      return;
    } finally {
      saveFeedState(feedState);
    }
  }

  void appendToFeedState({
    required Profile? currentProfile,
    required PositiveCommunityFeedState feedState,
    required List<Relationship> relationships,
    required String cursor,
  }) {
    final Logger logger = ref.read(loggerProvider);
    feedState.hasPerformedInitialLoad = true;

    final String currentProfileId = currentProfile?.flMeta?.id ?? '';
    final List<String> newRelationshipIds = [];

    for (final Relationship relationship in relationships) {
      try {
        final String memberId = relationship.members.firstWhere((RelationshipMember member) => member.memberId != currentProfileId).memberId;
        if (memberId.isEmpty) {
          logger.e('requestNextTimelinePage() - Failed to get member id from relationship: $relationship');
          continue;
        }

        newRelationshipIds.add(memberId);
      } catch (ex) {
        logger.e('requestNextTimelinePage() - Failed to cache relationship: $relationship - ex: $ex');
      }
    }

    final String currentCursor = feedState.currentPaginationKey;
    final bool hasMoreData = cursor.isNotEmpty && newRelationshipIds.isNotEmpty && cursor != currentCursor;

    // Remove all records we already have
    newRelationshipIds.removeWhere((String id) => feedState.pagingController.itemList?.contains(id) ?? false);

    if (hasMoreData) {
      feedState.pagingController.appendSafePage(newRelationshipIds, cursor);
    } else {
      feedState.pagingController.appendLastPage(newRelationshipIds);
    }

    logger.d('CommunitiesController - loadNextCommunityData - Appended next community data to page');
    feedState.currentPaginationKey = cursor;
  }

  void saveFeedState(PositiveCommunityFeedState feedState) {
    final CacheController cacheController = ref.read(cacheControllerProvider);
    final Logger logger = ref.read(loggerProvider);
    final String cacheKey = feedState.buildCacheKey();
    if (cacheKey.isEmpty) {
      logger.e('CommunitiesController - saveFeedState - Cache key is empty');
      return;
    }

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    feedState.pagingController.notifyListeners();
    cacheController.add(key: cacheKey, value: feedState);
  }

  Future<void> updateSearchQuery(String value) async {
    if (value == state.searchQuery) {
      return;
    }

    state = state.copyWith(searchQuery: value);
    final bool isSearch = state.searchQuery.isNotEmpty;

    //? The community feed state here is listened to by this controller already
    if (!isSearch) {
      return;
    }

    //? If a search, we load one window of data.
    //? We may change this in future, when cost of loading more data is lower or we have a better way to load more data

    final PositiveCommunityFeedState currentFeedState = getCommunityFeedStateForType(
      profile: getCurrentProfile(),
      communityType: state.selectedCommunityType,
      searchQuery: state.searchQuery,
    );

    //? Check if we have already loaded data for this search
    if (currentFeedState.hasPerformedInitialLoad) {
      return;
    }

    await requestNextPage('', state.selectedCommunityType);
  }
}
