// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/activity_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/activities/activities_controller.dart';
import 'package:app/providers/events/content/activities.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:app/widgets/molecules/content/positive_post_layout_widget.dart';
import 'package:app/widgets/molecules/content/post_options_dialog.dart';
import 'package:app/widgets/organisms/post/vms/create_post_data_structures.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../providers/system/design_controller.dart';
import '../dialogs/positive_dialog.dart';
import 'activity_post_heading_widget.dart';

class PositiveActivityWidget extends StatefulHookConsumerWidget {
  const PositiveActivityWidget({
    required this.activity,
    this.targetFeed,
    this.index = -1,
    this.isEnabled = true,
    this.isFullscreen = false,
    this.onHeaderTapped,
    this.onImageTapped,
    super.key,
  });

  final Activity activity;
  final TargetFeed? targetFeed;
  final int index;

  final bool isEnabled;
  final void Function()? onHeaderTapped;
  final void Function(Media media)? onImageTapped;

  final bool isFullscreen;

  @override
  ConsumerState<PositiveActivityWidget> createState() => _PositiveActivityWidgetState();
}

class _PositiveActivityWidgetState extends ConsumerState<PositiveActivityWidget> {
  StreamSubscription<CacheKeyUpdatedEvent>? _cacheKeyUpdatedSubscription;

  final Set<RelationshipState> relationshipStates = <RelationshipState>{};
  Relationship? publisherRelationship;
  Profile? publisher;

  @override
  void initState() {
    super.initState();
    setupListeners();
    loadActivityData();
  }

  @override
  void didUpdateWidget(PositiveActivityWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.activity.flMeta?.id != widget.activity.flMeta?.id) {
      disposeListeners();
      setupListeners();
      loadActivityData();
    }
  }

  @override
  void dispose() {
    disposeListeners();
    super.dispose();
  }

  Future<void> setupListeners() async {
    final EventBus eventBus = ref.read(eventBusProvider);
    await _cacheKeyUpdatedSubscription?.cancel();
    _cacheKeyUpdatedSubscription = eventBus.on<CacheKeyUpdatedEvent>().listen(onCacheKeyUpdated);
  }

  Future<void> disposeListeners() async {
    await _cacheKeyUpdatedSubscription?.cancel();
  }

  void onCacheKeyUpdated(CacheKeyUpdatedEvent event) {
    final String activityId = widget.activity.flMeta?.id ?? '';
    final String publisherId = widget.activity.publisherInformation?.foreignKey ?? '';

    if (event.key.contains(activityId) || event.key.contains(publisherId)) {
      loadActivityData();
    }
  }

  void loadActivityData() {
    final Logger logger = providerContainer.read(loggerProvider);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);
    final UserController userController = providerContainer.read(userControllerProvider.notifier);

    publisherRelationship = null;
    publisher = null;
    relationshipStates.clear();

    logger.i('Loading activity information for ${widget.activity.flMeta?.id}');
    setStateIfMounted();

    // Load the publisher.
    final String publisherKey = widget.activity.publisherInformation?.foreignKey ?? '';
    if (publisherKey.isEmpty) {
      logger.w('Publisher key is empty for ${widget.activity.flMeta?.id}');
      return;
    }

    final Profile? publisherProfile = cacheController.getFromCache(publisherKey);
    if (publisherProfile == null) {
      logger.e('Publisher profile not found in cache for $publisherKey');
      return;
    }

    publisher = publisherProfile;
    logger.i('Loaded publisher profile for $publisherKey');

    if (userController.currentUser!.uid == publisherKey) {
      logger.i('Publisher is current user, skipping relationship load');
      return;
    }

    // Load the relationship.
    final Set<String> members = {userController.currentUser!.uid, publisherKey};
    if (members.length != 2) {
      logger.w('Invalid members for $publisherKey');
      return;
    }

    final Relationship? relationship = cacheController.getFromCache(members.asGUID);
    if (relationship == null) {
      logger.d('Relationship not found in cache for $relationship');
      return;
    }

    publisherRelationship = relationship;
    relationshipStates.addAll(relationship.relationshipStatesForEntity(userController.currentUser!.uid));

    logger.i('Loaded relationship for $relationship');
    setStateIfMounted();
  }

  bool get canDisplayActivity {
    final UserController userController = ref.read(userControllerProvider.notifier);
    if (publisher == null || publisherRelationship == null) {
      return false;
    }

    // If the publisher is the current user, we can always display the activity.
    if (userController.currentUser!.uid == publisher!.flMeta!.id) {
      return true;
    }

    final bool isBlocked = relationshipStates.contains(RelationshipState.sourceBlocked) || relationshipStates.contains(RelationshipState.targetBlocked);
    final bool isSourceHidden = relationshipStates.contains(RelationshipState.sourceHidden);

    return !isBlocked && !isSourceHidden;
  }

  Future<void> onPostOptionsSelected(BuildContext context) async {
    await PositiveDialog.show(
      title: '',
      context: context,
      backgroundOpacity: kOpacityQuarter,
      barrierOpacity: kOpacityBarrier,
      barrierDismissible: true,
      child: PostOptionsDialog(
        onEditPostSelected: () => onPostEdited(context),
        onDeletePostSelected: () => onPostDeleted(context),
      ),
    );
  }

  Future<void> onPostDeleted(BuildContext context) async {
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final AppRouter router = ref.read(appRouterProvider);

    await router.pop();
    await PositiveDialog.show(
      title: localisations.post_dialogue_delete_post,
      context: context,
      backgroundOpacity: kOpacityQuarter,
      barrierOpacity: kOpacityBarrier,
      barrierDismissible: true,
      child: PostDeleteConfirmDialog(
        onDeletePostConfirmed: () => onPostDeleteConfirmed(context),
      ),
    );
  }

  Future<void> onPostDeleteConfirmed(BuildContext context) async {
    final ActivitiesController activityController = ref.read(activitiesControllerProvider.notifier);
    final DesignColorsModel colours = providerContainer.read(designControllerProvider.select((value) => value.colors));
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final AppRouter router = ref.read(appRouterProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final EventBus eventBus = ref.read(eventBusProvider);
    final Logger logger = ref.read(loggerProvider);

    if (profileController.currentProfileId == null || widget.activity.flMeta == null || widget.activity.flMeta!.id == null) {
      return;
    }

    try {
      await activityController.deleteActivity(widget.activity.flMeta!.id!);
      final List<TargetFeed> targetFeeds = [
        TargetFeed('user', widget.activity.publisherInformation?.foreignKey ?? ''),
        TargetFeed('timeline', profileController.currentProfileId ?? ''),
        ...widget.activity.tagTargetFeeds,
      ];

      eventBus.fire(ActivityDeletedEvent(targets: targetFeeds, activityId: widget.activity.flMeta!.id!));
    } catch (e) {
      logger.e("Error deleting activity: $e");

      final PositiveGenericSnackBar snackBar = PositiveGenericSnackBar(
        title: localisations.post_dialogue_delete_post_fail,
        icon: UniconsLine.plus_circle,
        backgroundColour: colours.black,
      );

      if (router.navigatorKey.currentContext != null) {
        ScaffoldMessenger.of(router.navigatorKey.currentContext!).showSnackBar(snackBar);
      }

      await router.pop();
      return;
    }

    final PositiveGenericSnackBar snackBar = PositiveGenericSnackBar(
      title: localisations.post_dialogue_delete_post_success,
      icon: UniconsLine.file_times_alt,
      backgroundColour: colours.black,
    );

    if (router.navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(router.navigatorKey.currentContext!).showSnackBar(snackBar);
    }

    await router.pop();
  }

  Future<void> onPostEdited(BuildContext context) async {
    final AppRouter router = ref.read(appRouterProvider);

    if (widget.activity.generalConfiguration == null) {
      return;
    }

    await router.pop();
    await router.push(
      CreatePostRoute(
        activityData: ActivityData(
          activityID: widget.activity.flMeta!.id,
          content: widget.activity.generalConfiguration?.content ?? "",
          // altText: widget.activity.altText,
          tags: widget.activity.enrichmentConfiguration?.tags ?? const [],
          postType: PostType.getPostTypeFromActivity(widget.activity),
          media: widget.activity.media,
          // allowComments: widget.activity.allowComments,
          // allowSharing: widget.activity.allowSharing,
          // visibleTo: widget.activity.visibleTo,
        ),
        isEditPage: true,
      ),
    );
  }

  Future<void> onInternalHeaderTap() async {
    if (widget.onHeaderTapped != null) {
      widget.onHeaderTapped!();
      return;
    }

    final Logger logger = ref.read(loggerProvider);
    final AppRouter router = ref.read(appRouterProvider);
    final PostRoute postRoute = PostRoute(
      activity: widget.activity,
      feed: widget.targetFeed ?? TargetFeed('user', widget.activity.publisherInformation?.foreignKey ?? ''),
    );

    logger.i('Navigating to post ${widget.activity.flMeta?.id}');
    await router.push(postRoute);
  }

  Future<void> onInternalMediaTap(Media media) async {
    if (widget.onImageTapped != null) {
      widget.onImageTapped!(media);
      return;
    }

    final Logger logger = ref.read(loggerProvider);
    final AppRouter router = ref.read(appRouterProvider);
    final PostRoute postRoute = PostRoute(
      activity: widget.activity,
      feed: widget.targetFeed ?? TargetFeed('user', widget.activity.publisherInformation?.foreignKey ?? ''),
    );

    logger.i('Navigating to post ${widget.activity.flMeta?.id}');
    await router.push(postRoute);
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.isEnabled,
      child: Column(
        children: <Widget>[
          PositiveTapBehaviour(
            onTap: onInternalHeaderTap,
            child: ActivityPostHeadingWidget(
              activity: widget.activity,
              publisher: publisher,
              onOptions: onPostOptionsSelected,
            ),
          ),
          const SizedBox(height: kPaddingExtraSmall),
          PositivePostLayoutWidget(
            postContent: widget.activity,
            publisher: publisher,
            isShortformPost: !widget.isFullscreen,
            onImageTap: onInternalMediaTap,
          ),
        ],
      ),
    );
  }
}
