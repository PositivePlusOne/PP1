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
import 'package:app/providers/content/reactions_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:app/widgets/molecules/content/positive_post_actions.dart';
import 'package:app/widgets/molecules/content/post_options_dialog.dart';
import 'package:app/widgets/organisms/post/vms/create_post_data_structures.dart';
import 'package:app/widgets/organisms/profile/dialogs/profile_modal_dialog.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../providers/system/design_controller.dart';
import '../dialogs/positive_dialog.dart';

class PositiveActivityWidget extends HookConsumerWidget {
  PositiveActivityWidget({
    required this.targetFeed,
    this.activity,
    this.targetProfile,
    this.targetRelationship,
    this.targetReactionStatistics,
    this.currentProfile,
    this.resenderProfile,
    this.resenderRelationship,
    this.resenderReactionStatistics,
    this.index = -1,
    this.isEnabled = true,
    this.onImageTapped,
    this.isFullscreen = false,
    this.isShared = false,
    super.key,
  });

  final TargetFeed targetFeed;

  final Activity? activity;
  final Profile? targetProfile;

  final Relationship? targetRelationship;
  final ReactionStatistics? targetReactionStatistics;

  final Profile? currentProfile;

  final Profile? resenderProfile;
  final Relationship? resenderRelationship;
  final ReactionStatistics? resenderReactionStatistics;

  final int index;

  final bool isEnabled;
  final void Function(Media media)? onImageTapped;

  final bool isFullscreen;
  final bool isShared;

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

      return;
    }

    final logger = providerContainer.read(loggerProvider);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider);

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

    final Relationship relationship = cacheController.get(members.asGUID) ?? Relationship.empty(members);
    await PositiveDialog.show(
      context: context,
      useSafeArea: false,
      child: ProfileModalDialog(
        profile: publisher!,
        relationship: relationship,
        postID: activity.flMeta?.id ?? "",
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
    final CacheController cacheController = ref.read(cacheControllerProvider);
    final Logger logger = ref.read(loggerProvider);
    final String activityId = activity.flMeta?.id ?? '';

    if (profileController.currentProfileId == null || activityId.isEmpty) {
      return;
    }

    try {
      await activityController.deleteActivity(activityId);
      cacheController.remove(activityId);
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
    final ReactionsController reactionsController = providerContainer.read(reactionsControllerProvider.notifier);
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

      final bool isBookmarked = reactionsController.isActivityBookmarked(activityId, origin);
      if (isBookmarked) {
        await reactionsController.removeBookmarkActivity(origin: origin, activityId: activityId, uid: currentProfileId);
        ScaffoldMessenger.of(context).showSnackBar(
          PositiveGenericSnackBar(title: 'Post unbookmarked!', icon: UniconsLine.bookmark, backgroundColour: colours.purple),
        );
        return;
      }

      await reactionsController.bookmarkActivity(origin: origin, activityId: activityId);
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
    final ReactionsController reactionsController = providerContainer.read(reactionsControllerProvider.notifier);
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

      final bool isLiked = reactionsController.hasLikedActivity(activityId: activityId, uid: profileId, origin: origin);
      if (isLiked) {
        await reactionsController.unlikeActivity(origin: origin, activityId: activityId, uid: profileId);
        ScaffoldMessenger.of(context).showSnackBar(
          PositiveGenericSnackBar(title: 'Post unliked!', icon: UniconsLine.heart, backgroundColour: colours.purple),
        );
        return;
      }

      await reactionsController.likeActivity(origin: origin, activityId: activityId, uid: profileId);
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

    if (activity.generalConfiguration == null) {
      return;
    }

    await router.pop();
    await router.push(
      CreatePostRoute(
        activityData: ActivityData(
          activityID: activity.flMeta!.id,
          content: activity.generalConfiguration?.content ?? "",
          tags: activity.enrichmentConfiguration?.tags ?? const [],
          postType: PostType.getPostTypeFromActivity(activity),
          media: activity.media,
          commentPermissionMode: activity.securityConfiguration?.commentMode,
          visibilityMode: activity.securityConfiguration?.viewMode,
          allowSharing: activity.securityConfiguration?.shareMode == const ActivitySecurityConfigurationMode.public(),
          //! This is currently shared between ALL media!
          altText: activity.media.any((element) => element.altText.isNotEmpty) ? activity.media.firstWhere((element) => element.altText.isNotEmpty).altText : '',
        ),
        isEditPage: true,
      ),
    );
  }

  Future<void> onInternalHeaderTap(BuildContext context) async {
    if (onHeaderTapped != null) {
      onHeaderTapped!();
      return;
    }

    await requestPostRoute(context);
  }

  Future<void> requestPostRoute(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter router = ref.read(appRouterProvider);
    final PostRoute postRoute = PostRoute(
      activity: activity,
      feed: targetFeed ?? TargetFeed('user', activity.publisherInformation?.publisherId ?? ''),
    );

    // Check if we are already on the post page.
    if (router.current.name == PostRoute.name) {
      logger.i('Already on post ${activity.flMeta?.id}');
      return;
    }

    logger.i('Navigating to post ${activity.flMeta?.id}');
    await router.push(postRoute);
  }

  Future<void> onInternalMediaTap(Media media) async {
    if (onImageTapped != null) {
      onImageTapped!(media);
      return;
    }

    final Logger logger = ref.read(loggerProvider);
    final AppRouter router = ref.read(appRouterProvider);
    final PostRoute postRoute = PostRoute(
      activity: activity,
      feed: targetFeed ?? TargetFeed('user', activity.publisherInformation?.publisherId ?? ''),
    );

    logger.i('Navigating to post ${activity.flMeta?.id}');
    await router.push(postRoute);
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final CacheController cacheController = ref.read(cacheControllerProvider);

    Promotion? promotion;
    if (activity.enrichmentConfiguration?.promotionKey != null) {
      promotion = cacheController.get(activity.enrichmentConfiguration!.promotionKey);
    }

    final bool isLiked = reactionStatistics?.uniqueUserReactions["like"] == true;
    final bool isBookmarked = reactionStatistics?.uniqueUserReactions["bookmark"] == true;
    final bool isBusy = _isBookmarking || _isLiking || !isEnabled;

    final int totalLikes = reactionStatistics?.counts["like"] ?? 0;
    final int totalComments = reactionStatistics?.counts["comment"] ?? 0;

    final ActivitySecurityConfigurationMode viewMode = activity.securityConfiguration?.viewMode ?? const ActivitySecurityConfigurationMode.disabled();
    final bool canView = viewMode.canActOnActivity(activity.flMeta?.id ?? '');

    final String repostOriginalPublisherId = activity.generalConfiguration?.repostActivityPublisherId ?? '';
    final Profile? repostOriginalPublisher = repostOriginalPublisherId.isEmpty ? null : cacheController.get(repostOriginalPublisherId);
    final String repostOriginalActivityId = activity.generalConfiguration?.repostActivityId ?? '';
    final Activity? repostOriginalActivity = repostOriginalActivityId.isEmpty ? null : cacheController.get(repostOriginalActivityId);

    final String currentProfileId = ref.watch(profileControllerProvider.notifier.select((value) => value.currentProfileId)) ?? '';
    final String publisherId = activity.publisherInformation?.publisherId ?? '';
    final String activityID = activity.flMeta?.id ?? '';

    final ActivitySecurityConfigurationMode shareMode = activity.securityConfiguration?.shareMode ?? const ActivitySecurityConfigurationMode.disabled();

    final bool canActShare = shareMode.canActOnActivity(activityID, currentProfileId: currentProfileId);
    final bool isPublisher = currentProfileId == publisherId;
    final bool isRepost = repostOriginalPublisher != null && repostOriginalActivity != null;

    if (isRepost) {
      return Column(
        children: <Widget>[
          PositiveTapBehaviour(
            onTap: onInternalHeaderTap,
            child: ActivityPostHeadingWidget(
              flMetaData: activity.flMeta,
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
              index: index,
              isEnabled: isEnabled,
              isFullscreen: isFullscreen,
              targetFeed: TargetFeed.fromOrigin(repostOriginalActivity.publisherInformation?.originFeed ?? ''),
              isShared: true,
            ),
          ),
          PositivePostActions(
            isLiked: isLiked,
            likes: totalLikes,
            likesEnabled: !isBusy && !isPublisher,
            onLike: (context) => onPostLiked(context, activity),
            shareEnabled: !isBusy && canActShare,
            onShare: (_) {},
            comments: totalComments,
            commentsEnabled: !isBusy,
            onComment: (_) {},
            bookmarkEnabled: !isBusy,
            bookmarked: isBookmarked,
            onBookmark: (context) => onPostBookmarked(context, activity),
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
              flMetaData: activity.flMeta,
              publisher: publisher,
              promotion: promotion,
              onOptions: onPostOptionsSelected,
              isShared: isShared,
            ),
          ),
          if (canView) ...<Widget>[
            PositivePostLayoutWidget(
              postContent: activity,
              publisher: publisher,
              promotion: promotion,
              isShortformPost: !isFullscreen,
              sidePadding: isShared ? kPaddingExtraSmall : kPaddingSmall,
              onImageTap: onInternalMediaTap,
              onLike: (context) => onPostLiked(context, activity),
              isLiked: isLiked,
              totalLikes: totalLikes,
              totalComments: totalComments,
              isBookmarked: isBookmarked,
              onBookmark: (context) => onPostBookmarked(context, activity),
              isBusy: isBusy,
              origin: targetFeed != null ? TargetFeed.toOrigin(targetFeed!) : null,
              onPostPageRequested: requestPostRoute,
              isShared: isShared,
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
