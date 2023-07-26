// Dart imports:

// Dart imports:

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/widgets/organisms/post/vms/create_post_data_structures.dart';
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

  factory ActivitiesControllerState.initialState() => const ActivitiesControllerState(
        activities: {},
      );
}

@Riverpod(keepAlive: true)
class ActivitiesController extends _$ActivitiesController {
  @override
  ActivitiesControllerState build() {
    return ActivitiesControllerState.initialState();
  }

  Future<Activity> getActivity(String id, {bool skipCacheLookup = false}) async {
    final Logger logger = ref.read(loggerProvider);
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
    final ActivityApiService activityApiService = await ref.read(activityApiServiceProvider.future);

    logger.i('[Activities Service] - Loading activity: $id');
    if (!skipCacheLookup) {
      final Activity? cachedActivity = cacheController.getFromCache(id);
      if (cachedActivity != null) {
        logger.i('[Activities Service] - Activity found in cache: $id');
        return cachedActivity;
      }
    }

    logger.i('[Activities Service] - Parsing response');
    final Map<String, Object?> data = await activityApiService.getActivity(entryId: id);
    if (data.isEmpty) {
      throw Exception('Activity not found');
    }

    logger.i('[Activities Service] - Parsing activity: $id');
    final Activity activity = Activity.fromJson(data);

    return activity;
  }

  Future<Activity> postActivity({
    required ActivityData activityData,
    List<Media>? media,
  }) async {
    final Logger logger = ref.read(loggerProvider);
    logger.i('[Activities Service] - Posting activity');

    final ActivityApiService activityApiService = await ref.read(activityApiServiceProvider.future);
    return await activityApiService.postActivity(activityData: activityData);
  }

  Future<void> deleteActivity(String activityId) async {
    final Logger logger = ref.read(loggerProvider);
    logger.i('[Activities Service] - Deleting activity');

    final ActivityApiService activityApiService = await ref.read(activityApiServiceProvider.future);
    await activityApiService.deleteActivity(activityId: activityId);
  }

  Future<Activity> updateActivity({
    required ActivityData activityData,
    List<Media>? media,
  }) async {
    final Logger logger = ref.read(loggerProvider);
    logger.i('[Activities Service] - Updating activity');

    final ActivityApiService activityApiService = await ref.read(activityApiServiceProvider.future);
    return await activityApiService.updateActivity(activityData: activityData);
  }
}
