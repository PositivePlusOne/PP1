// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/enrichment/promotions.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/activity_extensions.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:app/widgets/molecules/content/positive_post_actions.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../providers/system/design_controller.dart';

class PositiveActivityWidget extends HookConsumerWidget {
  const PositiveActivityWidget({
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

  final bool isFullscreen;
  final bool isShared;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
