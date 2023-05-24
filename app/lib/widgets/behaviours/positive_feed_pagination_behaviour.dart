// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/future_extensions.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/molecules/content/positive_activity_widget.dart';
import '../../services/third_party.dart';

class PositiveFeedPaginationBehaviour extends StatefulHookConsumerWidget {
  const PositiveFeedPaginationBehaviour({
    required this.feed,
    required this.slug,
    this.windowSize = 10,
    super.key,
  });

  final String feed;
  final String slug;
  final int windowSize;

  static const String kWidgetKey = 'PositiveFeedPaginationBehaviour';

  @override
  ConsumerState<PositiveFeedPaginationBehaviour> createState() => _PositiveFeedPaginationBehaviourState();
}

class _PositiveFeedPaginationBehaviourState extends ConsumerState<PositiveFeedPaginationBehaviour> {
  late final PagingController<String, Activity> pagingController;
  String currentPaginationKey = '';

  @override
  void initState() {
    super.initState();
    setupListeners();
  }

  @override
  void didUpdateWidget(PositiveFeedPaginationBehaviour oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.feed != widget.feed || oldWidget.slug != widget.slug) {
      disposeListeners();
      setupListeners();
    }
  }

  @override
  void dispose() {
    disposeListeners();
    super.dispose();
  }

  void setupListeners() {
    pagingController = PagingController<String, Activity>(firstPageKey: currentPaginationKey);
    pagingController.addPageRequestListener(requestNextPage);
  }

  void disposeListeners() {
    pagingController.removePageRequestListener(requestNextPage);
    pagingController.dispose();
  }

  Future<void> requestNextPage(String pageKey) async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseFunctions functions = ref.read(firebaseFunctionsProvider);

    try {
      final HttpsCallableResult response = await functions.httpsCallable('stream-getFeedWindow').call({
        'feed': widget.feed,
        'options': {
          'slug': widget.slug,
          'windowLastActivityId': pageKey,
        },
      });

      final Map<String, dynamic> data = json.decodeSafe(response.data);
      final String next = data.containsKey('next') ? data['next'].toString() : '';

      // The order of these is important, as we need to parse the relationship data before anything else.
      parseRelationshipData(data);
      parseProfileData(data);
      parseActivityData(data, next);
    } catch (ex) {
      logger.e('requestNextTimelinePage() - ex: $ex');
      if (mounted) {
        pagingController.error = ex;
      }
    }
  }

  void parseRelationshipData(Map<String, dynamic> data) {
    final Logger logger = ref.read(loggerProvider);
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);

    final List<dynamic> relationships = (data.containsKey('relationships') ? data['relationships'] : []).map((dynamic relationship) => relationship as Map<String, dynamic>).toList();
    final List<Relationship> newRelationships = [];

    for (final dynamic relationship in relationships) {
      try {
        logger.d('requestNextTimelinePage() - parsing relationship: $relationship');
        final Relationship newRelationship = Relationship.fromJson(relationship);
        final String relationshipId = newRelationship.flMeta?.id ?? '';
        if (relationshipId.isEmpty) {
          logger.e('requestNextTimelinePage() - Failed to parse relationship: $relationship');
          continue;
        }

        newRelationships.add(newRelationship);
        cacheController.addToCache(relationshipId, newRelationship);
      } catch (ex) {
        logger.e('requestNextTimelinePage() - Failed to parse relationship: $relationship - ex: $ex');
      }
    }
  }

  void parseProfileData(Map<String, dynamic> data) {
    final Logger logger = ref.read(loggerProvider);
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);

    final List<dynamic> profiles = (data.containsKey('users') ? data['users'] : []).map((dynamic profile) => profile as Map<String, dynamic>).toList();
    final List<Profile> newProfiles = [];

    for (final dynamic profile in profiles) {
      try {
        logger.d('requestNextTimelinePage() - parsing profile: $profile');
        final Profile newProfile = Profile.fromJson(profile);
        final String profileId = newProfile.flMeta?.id ?? '';
        if (profileId.isEmpty) {
          logger.e('requestNextTimelinePage() - Failed to parse profile: $profile');
          continue;
        }

        newProfiles.add(newProfile);
        cacheController.addToCache(profileId, newProfile);
      } catch (ex) {
        logger.e('requestNextTimelinePage() - Failed to parse profile: $profile - ex: $ex');
      }
    }
  }

  void parseActivityData(Map<String, dynamic> data, String nextPageKey) {
    final Logger logger = ref.read(loggerProvider);
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);

    final bool hasNext = nextPageKey.isNotEmpty && nextPageKey != currentPaginationKey;
    currentPaginationKey = nextPageKey;
    logger.i('requestNextTimelinePage() - hasNext: $hasNext - nextPageKey: $nextPageKey - currentPaginationKey: $currentPaginationKey');

    final List<Activity> newActivities = [];
    final List<dynamic> activities = (data.containsKey('activities') ? data['activities'] : []).map((dynamic activity) => activity as Map<String, dynamic>).toList();

    for (final dynamic activity in activities) {
      try {
        logger.d('requestNextTimelinePage() - parsing activity: $activity');
        final Activity newActivity = Activity.fromJson(activity);
        final String activityId = newActivity.flMeta?.id ?? '';
        if (activityId.isEmpty) {
          logger.e('requestNextTimelinePage() - Failed to parse activity: $activity');
          continue;
        }

        newActivities.add(newActivity);
        cacheController.addToCache(activityId, newActivity);
      } catch (ex) {
        logger.e('requestNextTimelinePage() - Failed to parse activity: $activity - ex: $ex');
      }
    }

    logger.d('requestNextTimelinePage() - newActivities: $newActivities');

    if (!hasNext && mounted) {
      pagingController.appendLastPage(newActivities);
    } else if (mounted) {
      pagingController.appendPage(newActivities, nextPageKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Center loadingIndicator = Center(child: PositiveLoadingIndicator());
    return PagedSliverList.separated(
      pagingController: pagingController,
      separatorBuilder: (context, index) => const Divider(),
      builderDelegate: PagedChildBuilderDelegate<Activity>(
        itemBuilder: (_, item, index) => PositiveActivityWidget(activity: item, index: index),
        firstPageProgressIndicatorBuilder: (context) => loadingIndicator,
        newPageProgressIndicatorBuilder: (context) => loadingIndicator,
      ),
    );
  }
}
