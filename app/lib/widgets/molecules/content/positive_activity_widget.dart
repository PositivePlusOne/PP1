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
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:app/widgets/molecules/content/activity_post_heading_widget.dart';
import 'package:app/widgets/molecules/content/positive_post_actions.dart';
import 'package:app/widgets/molecules/content/positive_post_layout_widget.dart';
import 'package:app/widgets/state/positive_reactions_state.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../providers/system/design_controller.dart';

class PositiveActivityWidget extends HookConsumerWidget {
  const PositiveActivityWidget({
    required this.targetFeed,
    required this.activity,
    required this.activityReactionStatistics,
    required this.activityPromotion,
    required this.activityReactionFeedState,
    required this.targetProfile,
    required this.targetRelationship,
    required this.currentProfile,
    required this.currentProfileReactions,
    required this.reposterProfile,
    required this.reposterRelationship,
    this.index = -1,
    this.isEnabled = true,
    this.isFullscreen = false,
    this.isShared = false,
    super.key,
  });

  final TargetFeed targetFeed;

  final Activity? activity;
  final ReactionStatistics? activityReactionStatistics;
  final Promotion? activityPromotion;
  final PositiveReactionsState? activityReactionFeedState;

  final Profile? targetProfile;
  final Relationship? targetRelationship;

  final Profile? currentProfile;
  final List<Reaction> currentProfileReactions;

  final Profile? reposterProfile;
  final Relationship? reposterRelationship;

  final int index;

  final bool isEnabled;

  final bool isFullscreen;
  final bool isShared;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final bool isLiked = currentProfileReactions.any((reaction) => reaction.kind == const ReactionType.like());
    final bool isBookmarked = currentProfileReactions.any((reaction) => reaction.kind == const ReactionType.bookmark());

    final int totalLikes = activityReactionStatistics?.counts["like"] ?? 0;
    final int totalComments = activityReactionStatistics?.counts["comment"] ?? 0;

    final bool isRepost = activity?.repostConfiguration?.targetActivityPublisherId.isNotEmpty ?? false;
    final Relationship? actualRelationship = isRepost ? reposterRelationship : targetRelationship;

    final ActivitySecurityConfigurationMode viewMode = activity?.securityConfiguration?.viewMode ?? const ActivitySecurityConfigurationMode.disabled();
    final bool canView = viewMode.canActOnActivity(
      activity: activity,
      currentProfile: currentProfile,
      publisherRelationship: actualRelationship,
    );

    final String currentProfileId = currentProfile?.flMeta?.id ?? '';
    final String publisherId = activity?.publisherInformation?.publisherId ?? '';
    final bool isPublisher = currentProfileId == publisherId;

    final ActivitySecurityConfigurationMode shareMode = activity?.securityConfiguration?.shareMode ?? const ActivitySecurityConfigurationMode.disabled();

    final bool canActShare = shareMode.canActOnActivity(
      activity: activity,
      currentProfile: currentProfile,
      publisherRelationship: actualRelationship,
    );

    if (isRepost) {
      return Column(
        children: <Widget>[
          ActivityPostHeadingWidget(
            flMetaData: activity?.flMeta,
            isShared: isShared,
            publisher: reposterProfile,
            promotion: activityPromotion,
            onOptions: () {
              activity?.onPostOptionsSelected(
                context: context,
                targetProfile: targetProfile,
                currentProfile: currentProfile,
              );
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: kPaddingSmall),
            margin: const EdgeInsets.symmetric(horizontal: kPaddingExtraSmall, vertical: kPaddingSmall),
            decoration: BoxDecoration(
              color: colors.white,
              borderRadius: BorderRadius.circular(kBorderRadiusSmall),
            ),
            child: PositiveActivityWidget(
              activity: activity,
              activityReactionStatistics: activityReactionStatistics,
              activityPromotion: activityPromotion,
              activityReactionFeedState: activityReactionFeedState,
              targetProfile: targetProfile,
              targetRelationship: targetRelationship,
              currentProfile: currentProfile,
              currentProfileReactions: currentProfileReactions,
              reposterProfile: null,
              reposterRelationship: null,
              index: index,
              isEnabled: isEnabled,
              isFullscreen: isFullscreen,
              targetFeed: targetFeed,
              isShared: true,
            ),
          ),
          PositivePostActions(
            isLiked: isLiked,
            likes: totalLikes,
            likesEnabled: !isPublisher,
            onLike: (context) => activity?.onPostLiked(
              context: context,
              currentProfile: currentProfile,
              activity: activity,
            ),
            shareEnabled: canActShare,
            onShare: (_) {},
            comments: totalComments,
            onComment: (_) {},
            bookmarked: isBookmarked,
            onBookmark: (context) => activity?.onPostBookmarked(
              context: context,
              currentProfile: currentProfile,
              reactionsFeedState: activityReactionFeedState,
            ),
          ),
        ],
      );
    }

    return IgnorePointer(
      ignoring: !isEnabled,
      child: Column(
        children: <Widget>[
          PositiveTapBehaviour(
            child: ActivityPostHeadingWidget(
              flMetaData: activity?.flMeta,
              publisher: targetProfile,
              promotion: activityPromotion,
              onOptions: () => activity?.onPostOptionsSelected(
                context: context,
                targetProfile: targetProfile,
                currentProfile: currentProfile,
              ),
              isShared: isShared,
            ),
          ),
          if (canView) ...<Widget>[
            PositivePostLayoutWidget(
              postContent: activity,
              publisherProfile: targetProfile,
              publisherRelationship: targetRelationship,
              promotion: activityPromotion,
              isShortformPost: !isFullscreen,
              sidePadding: isShared ? kPaddingExtraSmall : kPaddingSmall,
              onLike: (context) => activity?.onPostLiked(
                context: context,
                currentProfile: currentProfile,
                activity: activity,
              ),
              isLiked: isLiked,
              totalLikes: totalLikes,
              totalComments: totalComments,
              isBookmarked: isBookmarked,
              onBookmark: (context) => activity?.onPostBookmarked(
                context: context,
                currentProfile: currentProfile,
                reactionsFeedState: activityReactionFeedState,
              ),
              isBusy: !isEnabled,
              onPostPageRequested: activity?.requestPostRoute,
              isShared: isShared,
              onImageTap: (media) => isFullscreen ? activity?.requestFullscreenMedia(media) : activity?.requestPostRoute(context),
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
