// Dart imports:
import 'dart:async';
import 'dart:collection';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/extensions/activity_extensions.dart';
import 'package:app/extensions/paging_extensions.dart';
import 'package:app/helpers/cache_helpers.dart';
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytic_properties.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/profiles/tags_controller.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import 'package:app/widgets/organisms/post/vms/create_post_data_structures.dart';
import 'package:app/widgets/state/positive_feed_state.dart';
import '../../services/api.dart';
import '../../services/third_party.dart';
import '../system/cache_controller.dart';

part 'activities_controller.freezed.dart';
part 'activities_controller.g.dart';

@freezed
class ActivitiesControllerState with _$ActivitiesControllerState {
  const factory ActivitiesControllerState({
    required Map<String, Activity> activities,
  }) = _ActivitiesControllerState;

  factory ActivitiesControllerState.initialState() => ActivitiesControllerState(
        activities: HashMap<String, Activity>(),
      );
}

@Riverpod(keepAlive: true)
class ActivitiesController extends _$ActivitiesController {
  StreamSubscription<CacheKeyUpdatedEvent>? _cacheKeyUpdatedSubscription;

  @override
  ActivitiesControllerState build() {
    return ActivitiesControllerState.initialState();
  }

  Future<void> setupListeners() async {
    final Logger logger = ref.read(loggerProvider);
    logger.i('[Activities Service] - Setting up listeners');

    final EventBus eventBus = ref.read(eventBusProvider);
    await _cacheKeyUpdatedSubscription?.cancel();
    _cacheKeyUpdatedSubscription = eventBus.on<CacheKeyUpdatedEvent>().listen(onCacheKeyUpdated);
  }

  void onCacheKeyUpdated(CacheKeyUpdatedEvent event) {
    if (event.value is! Activity) {
      return;
    }

    final Activity activity = event.value as Activity;
    final CacheKeyUpdatedEventType eventType = event.eventType;

    switch (eventType) {
      case CacheKeyUpdatedEventType.created:
        onCacheActivityCreated(activity);
        break;
      case CacheKeyUpdatedEventType.updated:
        onCacheActivityUpdated(activity);
        break;
      case CacheKeyUpdatedEventType.deleted:
        onCacheActivityDeleted(activity);
        break;
    }
  }

  Future<Activity> getActivity(String id, {bool skipCacheLookup = false}) async {
    final Logger logger = ref.read(loggerProvider);
    final CacheController cacheController = ref.read(cacheControllerProvider);
    final PostApiService postApiService = await ref.read(postApiServiceProvider.future);

    logger.i('[Activities Service] - Loading activity: $id');
    if (!skipCacheLookup) {
      final Activity? cachedActivity = cacheController.get(id);
      if (cachedActivity != null) {
        logger.i('[Activities Service] - Activity found in cache: $id');
        return cachedActivity;
      }
    }

    logger.i('[Activities Service] - Parsing response');
    final Map<String, Object?> data = await postApiService.getActivity(entryId: id);
    if (data.isEmpty) {
      throw Exception('Activity not found');
    }

    logger.i('[Activities Service] - Parsing activity: $id');
    final Activity activity = Activity.fromJson(data);

    return activity;
  }

  Future<Activity> postActivity({
    required ActivityData activityData,
    required Profile? currentProfile,
    List<Media>? media,
  }) async {
    final Logger logger = ref.read(loggerProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    logger.i('[Activities Service] - Posting activity');

    final PostApiService postApiService = await ref.read(postApiServiceProvider.future);
    final Activity activity = await postApiService.postActivity(
      activityData: activityData,
      reposterActivityId: activityData.reposterActivityID ?? '',
    );

    // Save any analytics
    await analyticsController.trackEvent(
      AnalyticEvents.postCreated,
      properties: generatePropertiesForPostSource(activity: activity),
    );

    // Add the tags to the users recent tags
    final TagsController tagsController = ref.read(tagsControllerProvider.notifier);
    final List<String> tags = activityData.tags ?? <String>[];
    tagsController.addTagsToRecentTags(tags: tags);

    // Add the activity to the feed state
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';
    activity.appendActivityToProfileFeeds(currentProfileId);

    logger.i('[Activities Service] - Feed state updated for profile: $currentProfileId - activity: $activity');
    return activity;
  }

  Future<void> deleteActivity({
    required Activity activity,
    required Profile? currentProfile,
  }) async {
    final Logger logger = ref.read(loggerProvider);
    final CacheController cacheController = ref.read(cacheControllerProvider);
    final String activityId = activity.flMeta?.id ?? '';

    logger.i('[Activities Service] - Deleting activity: $activityId');
    final PostApiService postApiService = await ref.read(postApiServiceProvider.future);
    await postApiService.deleteActivity(activityId: activityId);

    //* We can keep the activity in the cache for now, as this will prevent the UI from breaking
    //* cacheController.remove(activityId);
    //* But, lets remove it from the feed state
    final List<TargetFeed> feeds = buildTargetFeedsForActivity(activity: activity, currentProfile: currentProfile);
    final List<String> cacheKeys = feeds.map((e) => PositiveFeedState.buildFeedCacheKey(e)).toList();

    for (final String cacheKey in cacheKeys) {
      final PositiveFeedState? feedState = cacheController.get(cacheKey);
      if (feedState == null) {
        continue;
      }

      final PagingController<String, Activity> pagingController = feedState.pagingController;
      final List<Activity> currentItems = pagingController.itemList ?? <Activity>[];

      final int index = currentItems.indexWhere((element) => element.flMeta?.id == activityId);
      if (index >= 0) {
        currentItems.removeAt(index);
        pagingController.itemList = currentItems;
      }

      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      pagingController.notifyListeners();

      cacheController.add(key: cacheKey, value: feedState);
    }
  }

  Future<Activity> updateActivity({
    required ActivityData activityData,
    required Profile? currentProfile,
    List<Media>? media,
  }) async {
    final Logger logger = ref.read(loggerProvider);
    logger.i('[Activities Service] - Updating activity');

    final String currentProfileId = currentProfile?.flMeta?.id ?? '';
    final PostApiService postApiService = await ref.read(postApiServiceProvider.future);
    final Activity activity = await postApiService.updateActivity(activityData: activityData);

    // Add the tags to the users recent tags
    final TagsController tagsController = ref.read(tagsControllerProvider.notifier);
    tagsController.addTagsToRecentTags(tags: activityData.tags ?? <String>[]);

    // Add the activity to the feed state
    activity.appendActivityToProfileFeeds(currentProfileId);

    return activity;
  }

  PositiveFeedState getOrCreateFeedStateForOrigin({
    required String profileId,
    required TargetFeed feed,
  }) {
    final Logger logger = ref.read(loggerProvider);
    final String cacheKey = PositiveFeedState.buildFeedCacheKey(feed);
    final CacheController cacheController = ref.read(cacheControllerProvider);

    logger.i('[Activities Service] - Loading feed state for profile: $profileId - feed: $feed');
    final PositiveFeedState? cachedFeedState = cacheController.get(cacheKey);
    if (cachedFeedState != null) {
      logger.i('[Activities Service] - Feed state found in cache: $profileId - feed: $feed');
      return cachedFeedState;
    }

    final PagingController<String, Activity> pagingController = PagingController<String, Activity>(
      firstPageKey: '',
    );

    final PositiveFeedState feedState = PositiveFeedState(
      currentPaginationKey: '',
      feed: feed,
      profileId: profileId,
      pagingController: pagingController,
    );

    cacheController.add(key: cacheKey, value: feedState);
    logger.i('[Activities Service] - Feed state loaded: $feedState');

    return feedState;
  }

  Future<void> notifyPageKeyUpdated({
    required String profileId,
    required TargetFeed feed,
    required String pageKey,
    Duration delay = const Duration(seconds: 1), // Delay to allow the activities to be added to the cache
  }) async {
    final Logger logger = ref.read(loggerProvider);
    final String cacheKey = PositiveFeedState.buildFeedCacheKey(feed);
    final CacheController cacheController = ref.read(cacheControllerProvider);

    logger.d('[Activities Service] - Delaying feed state update for profile: $profileId - feed: $feed');
    await Future<void>.delayed(delay);

    logger.i('[Activities Service] - Updating feed state for profile: $profileId - feed: $feed');
    final PositiveFeedState feedState = getOrCreateFeedStateForOrigin(profileId: profileId, feed: feed);
    feedState.currentPaginationKey = pageKey;
    feedState.hasPerformedInitialLoad = true;

    feedState.pagingController.notifyPage(pageKey);

    cacheController.add(key: cacheKey, value: feedState);
    logger.i('[Activities Service] - Feed state updated: $feedState');
  }

  void notifyPageError({
    required String profileId,
    required TargetFeed feed,
    required Object error,
  }) {
    final Logger logger = ref.read(loggerProvider);
    final String cacheKey = PositiveFeedState.buildFeedCacheKey(feed);
    final CacheController cacheController = ref.read(cacheControllerProvider);

    logger.i('[Activities Service] - Updating feed state for profile: $profileId - feed: $feed');
    final PositiveFeedState feedState = getOrCreateFeedStateForOrigin(profileId: profileId, feed: feed);
    feedState.pagingController.error = error;

    cacheController.add(key: cacheKey, value: feedState);
    logger.i('[Activities Service] - Feed state updated: $feedState');
  }

  void onCacheActivityCreated(Activity activity) {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    final String currentProfileId = profileController.currentProfileId ?? '';
    final String originFeed = activity.publisherInformation?.originFeed ?? '';

    if (currentProfileId.isEmpty || originFeed.isEmpty) {
      return;
    }

    logger.i('[Activities Service] - Updating feed state for profile: $currentProfileId - activity: $activity');
    final CacheController cacheController = ref.read(cacheControllerProvider);

    final TargetFeed feed = TargetFeed.fromOrigin(originFeed);
    final String cacheKey = PositiveFeedState.buildFeedCacheKey(feed);

    final PositiveFeedState feedState = getOrCreateFeedStateForOrigin(
      profileId: currentProfileId,
      feed: TargetFeed.fromOrigin(originFeed),
    );

    final PagingController<String, Activity> pagingController = feedState.pagingController;
    final List<Activity> currentItems = pagingController.itemList ?? <Activity>[];

    currentItems.insert(0, activity);
    pagingController.itemList = currentItems;

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    pagingController.notifyListeners();

    logger.i('[Activities Service] - Feed state updated for profile: $currentProfileId - activity: $activity');
    cacheController.add(key: cacheKey, value: feedState);
  }

  void onCacheActivityUpdated(Activity activity) {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    final String currentProfileId = profileController.currentProfileId ?? '';
    final String originFeed = activity.publisherInformation?.originFeed ?? '';

    if (currentProfileId.isEmpty || originFeed.isEmpty) {
      return;
    }

    logger.i('[Activities Service] - Updating feed state for profile: $currentProfileId - activity: $activity');
    final CacheController cacheController = ref.read(cacheControllerProvider);
    final TargetFeed feed = TargetFeed.fromOrigin(originFeed);
    final String cacheKey = PositiveFeedState.buildFeedCacheKey(feed);

    final PositiveFeedState feedState = getOrCreateFeedStateForOrigin(
      profileId: currentProfileId,
      feed: TargetFeed.fromOrigin(originFeed),
    );

    final PagingController<String, Activity> pagingController = feedState.pagingController;
    final List<Activity> currentItems = pagingController.itemList ?? <Activity>[];

    final int index = currentItems.indexWhere((element) => element.flMeta?.id == activity.flMeta?.id);
    if (index >= 0) {
      currentItems[index] = activity;
      pagingController.itemList = currentItems;
    }

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    pagingController.notifyListeners();

    logger.i('[Activities Service] - Feed state updated for profile: $currentProfileId - activity: $activity');
    cacheController.add(key: cacheKey, value: feedState);
  }

  void onCacheActivityDeleted(Activity activity) {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    final String currentProfileId = profileController.currentProfileId ?? '';
    final String originFeed = activity.publisherInformation?.originFeed ?? '';

    if (currentProfileId.isEmpty || originFeed.isEmpty) {
      return;
    }

    logger.i('[Activities Service] - Updating feed state for profile: $currentProfileId - activity: $activity');
    final CacheController cacheController = ref.read(cacheControllerProvider);
    final TargetFeed feed = TargetFeed.fromOrigin(originFeed);
    final String cacheKey = PositiveFeedState.buildFeedCacheKey(feed);

    final PositiveFeedState feedState = getOrCreateFeedStateForOrigin(
      profileId: currentProfileId,
      feed: TargetFeed.fromOrigin(originFeed),
    );

    final PagingController<String, Activity> pagingController = feedState.pagingController;
    final List<Activity> currentItems = pagingController.itemList ?? <Activity>[];

    final int index = currentItems.indexWhere((element) => element.flMeta?.id == activity.flMeta?.id);
    if (index >= 0) {
      currentItems.removeAt(index);
      pagingController.itemList = currentItems;
    }

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    pagingController.notifyListeners();

    logger.i('[Activities Service] - Feed state updated for profile: $currentProfileId - activity: $activity');
    cacheController.add(key: cacheKey, value: feedState);
  }
}
