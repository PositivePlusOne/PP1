// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/database/enrichment/promotions.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/activity_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/content/activities_controller.dart';
import 'package:app/providers/events/content/activity_events.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import 'package:app/providers/user/communities_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:app/widgets/molecules/content/positive_post_actions.dart';
import 'package:app/widgets/molecules/content/positive_post_layout_widget.dart';
import 'package:app/widgets/molecules/content/post_options_dialog.dart';
import 'package:app/widgets/organisms/post/vms/create_post_data_structures.dart';
import 'package:app/widgets/organisms/profile/dialogs/profile_modal_dialog.dart';
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
    this.onHeaderTapped,
    this.onImageTapped,
    this.isFullscreen = false,
    this.isShared = false,
    super.key,
  });

  final Activity activity;
  final TargetFeed? targetFeed;
  final int index;

  final bool isEnabled;
  final void Function()? onHeaderTapped;
  final void Function(Media media)? onImageTapped;

  final bool isFullscreen;
  final bool isShared;

  @override
  ConsumerState<PositiveActivityWidget> createState() => _PositiveActivityWidgetState();
}

class _PositiveActivityWidgetState extends ConsumerState<PositiveActivityWidget> {
  StreamSubscription<CacheKeyUpdatedEvent>? _cacheKeyUpdatedSubscription;

  final Set<RelationshipState> relationshipStates = <RelationshipState>{};
  Relationship? publisherRelationship;
  ReactionStatistics? reactionStatistics;
  Profile? publisher;

  bool _isBookmarking = false;
  bool _isLiking = false;

  @override
  void initState() {
    super.initState();
    setupListeners();
    loadActivityData();
    fetchReactionStatistics();
  }

  @override
  void didUpdateWidget(PositiveActivityWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.activity.flMeta?.id != widget.activity.flMeta?.id) {
      disposeListeners();
      setupListeners();
      loadActivityData();
      fetchReactionStatistics();
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
    final String publisherId = widget.activity.publisherInformation?.publisherId ?? '';

    if (event.key.contains(activityId) || event.key.contains(publisherId)) {
      loadActivityData();
      fetchReactionStatistics();
    }
  }

  void loadActivityData() {
    final Logger logger = providerContainer.read(loggerProvider);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);

    publisherRelationship = null;
    publisher = null;
    relationshipStates.clear();

    logger.i('Loading activity information for ${widget.activity.flMeta?.id}');
    setStateIfMounted();

    // Load the publisher.
    final String publisherKey = widget.activity.publisherInformation?.publisherId ?? '';
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

    final String currentProfileId = profileController.currentProfileId ?? '';
    if (currentProfileId.isEmpty) {
      logger.w('[loadActivityData] Current profile id is empty');
      return;
    }

    if (currentProfileId == publisherKey) {
      logger.i('Publisher is current user, skipping relationship load');
      return;
    }

    // Load the relationship.
    final Set<String> members = {currentProfileId, publisherKey};
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
    relationshipStates.addAll(relationship.relationshipStatesForEntity(currentProfileId));

    logger.i('Loaded relationship for $relationship');
    setStateIfMounted();
  }

  void fetchReactionStatistics() {
    final Logger logger = providerContainer.read(loggerProvider);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);
    final ReactionStatistics requestStatistics = ReactionStatistics.fromActivity(
      widget.activity,
      widget.targetFeed ?? TargetFeed('user', widget.activity.publisherInformation?.publisherId ?? ''),
    );

    final String cacheKey = ReactionStatistics.buildCacheKey(requestStatistics);
    final ReactionStatistics? cachedStatistics = cacheController.getFromCache(cacheKey);
    if (cachedStatistics != null) {
      logger.i('Loaded reaction statistics from cache for ${widget.activity.flMeta?.id}');
      reactionStatistics = cachedStatistics;
      setStateIfMounted();
      return;
    }
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
    final UserController userController = ref.read(userControllerProvider.notifier);
    if (userController.currentUser!.uid == publisher!.flMeta!.id) {
      await PositiveDialog.show(
        title: '',
        context: context,
        barrierDismissible: true,
        child: PostOptionsDialog(
          onEditPostSelected: () => onPostEdited(context),
          onDeletePostSelected: () => onPostDeleted(context),
        ),
      );
    } else {
      final logger = providerContainer.read(loggerProvider);
      final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

      if (publisher == null) {
        return;
      }
      final FirebaseAuth auth = providerContainer.read(firebaseAuthProvider);
      final String uid = publisher!.flMeta?.id ?? '';

      logger.d('User profile modal requested: $uid');
      if (uid.isEmpty || auth.currentUser == null) {
        logger.w('User profile modal requested with empty uid');
        return;
      }

      final List<String> members = <String>[
        auth.currentUser?.uid ?? '',
        publisher!.flMeta?.id ?? '',
      ];

      final Relationship relationship = cacheController.getFromCache(members.asGUID) ?? Relationship.empty(members);
      await PositiveDialog.show(
        context: context,
        useSafeArea: false,
        child: ProfileModalDialog(
          profile: publisher!,
          relationship: relationship,
          postID: widget.activity.flMeta?.id ?? "",
          types: const {
            ProfileModalDialogOptionType.viewProfile,
            ProfileModalDialogOptionType.follow,
            ProfileModalDialogOptionType.connect,
            ProfileModalDialogOptionType.message,
            ProfileModalDialogOptionType.block,
            ProfileModalDialogOptionType.report,
            ProfileModalDialogOptionType.hidePosts,
            ProfileModalDialogOptionType.reportPost,
          },
        ),
      );
    }
  }

  Future<void> onPostDeleted(BuildContext context) async {
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final AppRouter router = ref.read(appRouterProvider);

    await router.pop();
    await PositiveDialog.show(
      title: localisations.post_dialogue_delete_post,
      context: context,
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
        TargetFeed('user', widget.activity.publisherInformation?.publisherId ?? ''),
        TargetFeed('timeline', profileController.currentProfileId ?? ''),
        ...widget.activity.tagTargetFeeds,
      ];

      eventBus.fire(ActivityDeletedEvent(targets: targetFeeds, activity: widget.activity));
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

  Future<void> onPostBookmarked(BuildContext context, Activity activity) async {
    final DesignColorsModel colours = providerContainer.read(designControllerProvider.select((value) => value.colors));
    final CommunitiesController communitiesController = providerContainer.read(communitiesControllerProvider.notifier);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);

    final String currentProfileId = profileController.currentProfileId ?? '';
    final String activityId = activity.flMeta?.id ?? '';
    final String origin = activity.publisherInformation?.originFeed ?? '';

    if (currentProfileId.isEmpty || activityId.isEmpty || origin.isEmpty) {
      throw Exception('Invalid activity or user');
    }

    try {
      _isBookmarking = true;
      setStateIfMounted();

      final bool isBookmarked = communitiesController.isActivityBookmarked(activityId, origin);
      if (isBookmarked) {
        await communitiesController.removeBookmarkActivity(origin: origin, activityId: activityId);
        ScaffoldMessenger.of(context).showSnackBar(
          PositiveGenericSnackBar(title: 'Post unbookmarked!', icon: UniconsLine.bookmark, backgroundColour: colours.purple),
        );
        return;
      }

      await communitiesController.bookmarkActivity(origin: origin, activityId: activityId);
      ScaffoldMessenger.of(context).showSnackBar(
        PositiveGenericSnackBar(title: 'Post bookmarked!', icon: UniconsLine.bookmark, backgroundColour: colours.purple),
      );
    } finally {
      _isBookmarking = false;
      setStateIfMounted();
    }
  }

  Future<void> onPostLiked(BuildContext context, Activity activity) async {
    final DesignColorsModel colours = providerContainer.read(designControllerProvider.select((value) => value.colors));
    final CommunitiesController communitiesController = providerContainer.read(communitiesControllerProvider.notifier);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);

    final String profileId = profileController.currentProfileId ?? '';
    final String activityId = activity.flMeta?.id ?? '';
    final String origin = activity.publisherInformation?.originFeed ?? '';

    if (profileId.isEmpty || activityId.isEmpty || origin.isEmpty) {
      throw Exception('Invalid activity or user');
    }

    try {
      _isLiking = true;
      setStateIfMounted();

      final bool isLiked = communitiesController.isActivityLiked(activityId, origin);
      if (isLiked) {
        await communitiesController.unlikeActivity(origin: origin, activityId: activityId);
        ScaffoldMessenger.of(context).showSnackBar(
          PositiveGenericSnackBar(title: 'Post unliked!', icon: UniconsLine.heart, backgroundColour: colours.purple),
        );
        return;
      }

      await communitiesController.likeActivity(origin: origin, activityId: activityId);
      ScaffoldMessenger.of(context).showSnackBar(
        PositiveGenericSnackBar(title: 'Post liked!', icon: UniconsLine.heart, backgroundColour: colours.purple),
      );
    } finally {
      _isLiking = false;
      setStateIfMounted();
    }
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
          tags: widget.activity.enrichmentConfiguration?.tags ?? const [],
          postType: PostType.getPostTypeFromActivity(widget.activity),
          media: widget.activity.media,
          commentPermissionMode: widget.activity.securityConfiguration?.commentMode,
          visibilityMode: widget.activity.securityConfiguration?.viewMode,
          allowSharing: widget.activity.securityConfiguration?.shareMode == const ActivitySecurityConfigurationMode.public(),
          //! This is currently shared between ALL media!
          altText: widget.activity.media.any((element) => element.altText.isNotEmpty) ? widget.activity.media.firstWhere((element) => element.altText.isNotEmpty).altText : '',
        ),
        isEditPage: true,
      ),
    );
  }

  Future<void> onInternalHeaderTap(BuildContext context) async {
    if (widget.onHeaderTapped != null) {
      widget.onHeaderTapped!();
      return;
    }

    await requestPostRoute(context);
  }

  Future<void> requestPostRoute(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter router = ref.read(appRouterProvider);
    final PostRoute postRoute = PostRoute(
      activity: widget.activity,
      feed: widget.targetFeed ?? TargetFeed('user', widget.activity.publisherInformation?.publisherId ?? ''),
    );

    // Check if we are already on the post page.
    if (router.current.name == PostRoute.name) {
      logger.i('Already on post ${widget.activity.flMeta?.id}');
      return;
    }

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
      feed: widget.targetFeed ?? TargetFeed('user', widget.activity.publisherInformation?.publisherId ?? ''),
    );

    logger.i('Navigating to post ${widget.activity.flMeta?.id}');
    await router.push(postRoute);
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);

    Promotion? promotion;
    if (widget.activity.enrichmentConfiguration?.promotionKey != null) {
      promotion = cacheController.getFromCache(widget.activity.enrichmentConfiguration!.promotionKey);
    }

    final bool isLiked = reactionStatistics?.uniqueUserReactions["like"] == true;
    final bool isBookmarked = reactionStatistics?.uniqueUserReactions["bookmark"] == true;
    final bool isBusy = _isBookmarking || _isLiking || !widget.isEnabled;

    final int totalLikes = reactionStatistics?.counts["like"] ?? 0;
    final int totalComments = reactionStatistics?.counts["comment"] ?? 0;

    final ActivitySecurityConfigurationMode viewMode = widget.activity.securityConfiguration?.viewMode ?? const ActivitySecurityConfigurationMode.disabled();
    final bool canView = viewMode.canActOnActivity(widget.activity.flMeta?.id ?? '');

    final String repostOriginalPublisherId = widget.activity.generalConfiguration?.repostActivityPublisherId ?? '';
    final Profile? repostOriginalPublisher = repostOriginalPublisherId.isEmpty ? null : cacheController.getFromCache(repostOriginalPublisherId);
    final String repostOriginalActivityId = widget.activity.generalConfiguration?.repostActivityId ?? '';
    final Activity? repostOriginalActivity = repostOriginalActivityId.isEmpty ? null : cacheController.getFromCache(repostOriginalActivityId);

    final String currentProfileId = ref.watch(profileControllerProvider.notifier.select((value) => value.currentProfileId)) ?? '';
    final String publisherId = widget.activity.publisherInformation?.publisherId ?? '';
    final String activityID = widget.activity.flMeta?.id ?? '';

    final ActivitySecurityConfigurationMode shareMode = widget.activity.securityConfiguration?.shareMode ?? const ActivitySecurityConfigurationMode.disabled();

    final bool canActShare = shareMode.canActOnActivity(activityID, currentProfileId: currentProfileId);
    final bool isPublisher = currentProfileId == publisherId;
    final bool isRepost = repostOriginalPublisher != null && repostOriginalActivity != null;

    if (isRepost) {
      return Column(
        children: <Widget>[
          PositiveTapBehaviour(
            onTap: onInternalHeaderTap,
            child: ActivityPostHeadingWidget(
              flMetaData: widget.activity.flMeta,
              publisher: publisher,
              onOptions: onPostOptionsSelected,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: kPaddingSmall),
            margin: const EdgeInsets.symmetric(horizontal: kPaddingExtraSmall, vertical: kPaddingSmall),
            decoration: BoxDecoration(
              color: colors.white,
              borderRadius: BorderRadius.circular(kBorderRadiusSmall),
            ),
            child: PositiveActivityWidget(
              activity: repostOriginalActivity,
              index: widget.index,
              isEnabled: widget.isEnabled,
              isFullscreen: widget.isFullscreen,
              targetFeed: TargetFeed.fromOrigin(repostOriginalActivity.publisherInformation?.originFeed ?? ''),
              isShared: true,
            ),
          ),
          PositivePostActions(
            isLiked: isLiked,
            likes: totalLikes,
            likesEnabled: !isBusy && !isPublisher,
            onLike: (context) => onPostLiked(context, widget.activity),
            shareEnabled: !isBusy && canActShare,
            onShare: (_) {},
            comments: totalComments,
            commentsEnabled: !isBusy,
            onComment: (_) {},
            bookmarkEnabled: !isBusy,
            bookmarked: isBookmarked,
            onBookmark: (context) => onPostBookmarked(context, widget.activity),
          ),
        ],
      );
    }

    return IgnorePointer(
      ignoring: isBusy,
      child: Column(
        children: <Widget>[
          PositiveTapBehaviour(
            onTap: onInternalHeaderTap,
            child: ActivityPostHeadingWidget(
              flMetaData: widget.activity.flMeta,
              publisher: publisher,
              promotion: promotion,
              onOptions: onPostOptionsSelected,
              isShared: widget.isShared,
            ),
          ),
          if (canView) ...<Widget>[
            PositivePostLayoutWidget(
              postContent: widget.activity,
              publisher: publisher,
              promotion: promotion,
              isShortformPost: !widget.isFullscreen,
              sidePadding: widget.isShared ? kPaddingExtraSmall : kPaddingSmall,
              onImageTap: onInternalMediaTap,
              onLike: (context) => onPostLiked(context, widget.activity),
              isLiked: isLiked,
              totalLikes: totalLikes,
              totalComments: totalComments,
              isBookmarked: isBookmarked,
              onBookmark: (context) => onPostBookmarked(context, widget.activity),
              isBusy: isBusy,
              origin: widget.targetFeed != null ? TargetFeed.toOrigin(widget.targetFeed!) : null,
              onPostPageRequested: requestPostRoute,
              isShared: widget.isShared,
            ),
          ] else ...<Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kPaddingMedium,
                vertical: kPaddingSmall,
              ),
              child: Text(
                'The author of this post has limited it\'s visibility. Why not explore some of their other content?',
                style: typography.styleBody.copyWith(color: colors.black),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
