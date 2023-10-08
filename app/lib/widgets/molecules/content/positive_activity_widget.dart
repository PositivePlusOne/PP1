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

class PositiveActivityWidget extends StatefulHookConsumerWidget {
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
  ConsumerState<ConsumerStatefulWidget> createState() => PositiveActivityWidgetState();
}

class PositiveActivityWidgetState extends ConsumerState<PositiveActivityWidget> {
  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final bool isLiked = widget.currentProfileReactions.any((reaction) => reaction.kind == const ReactionType.like());
    final bool isBookmarked = widget.currentProfileReactions.any((reaction) => reaction.kind == const ReactionType.bookmark());

    final int totalLikes = widget.activityReactionStatistics?.counts["like"] ?? 0;
    final int totalComments = widget.activityReactionStatistics?.counts["comment"] ?? 0;

    final bool isRepost = widget.activity?.repostConfiguration?.targetActivityPublisherId.isNotEmpty ?? false;
    final Relationship? actualRelationship = isRepost ? widget.reposterRelationship : widget.targetRelationship;

    final ActivitySecurityConfigurationMode viewMode = widget.activity?.securityConfiguration?.viewMode ?? const ActivitySecurityConfigurationMode.disabled();
    final bool canView = viewMode.canActOnActivity(
      activity: widget.activity,
      currentProfile: widget.currentProfile,
      publisherRelationship: actualRelationship,
    );

    final String currentProfileId = widget.currentProfile?.flMeta?.id ?? '';
    final String publisherId = widget.activity?.publisherInformation?.publisherId ?? '';
    final bool isPublisher = currentProfileId == publisherId;

    final ActivitySecurityConfigurationMode shareMode = widget.activity?.securityConfiguration?.shareMode ?? const ActivitySecurityConfigurationMode.disabled();

    final bool canActShare = shareMode.canActOnActivity(
      activity: widget.activity,
      currentProfile: widget.currentProfile,
      publisherRelationship: actualRelationship,
    );

    if (isRepost) {
      return Column(
        children: <Widget>[
          ActivityPostHeadingWidget(
            flMetaData: widget.activity?.flMeta,
            isShared: widget.isShared,
            publisher: widget.reposterProfile,
            promotion: widget.activityPromotion,
            onOptions: () {
              widget.activity?.onPostOptionsSelected(
                context: context,
                targetProfile: widget.targetProfile,
                currentProfile: widget.currentProfile,
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
              activity: widget.activity,
              activityReactionStatistics: widget.activityReactionStatistics,
              activityPromotion: widget.activityPromotion,
              activityReactionFeedState: widget.activityReactionFeedState,
              targetProfile: widget.targetProfile,
              targetRelationship: widget.targetRelationship,
              currentProfile: widget.currentProfile,
              currentProfileReactions: widget.currentProfileReactions,
              reposterProfile: null,
              reposterRelationship: null,
              index: widget.index,
              isEnabled: widget.isEnabled,
              isFullscreen: widget.isFullscreen,
              targetFeed: widget.targetFeed,
              isShared: true,
            ),
          ),
          PositivePostActions(
            isLiked: isLiked,
            likes: totalLikes,
            likesEnabled: !isPublisher,
            onLike: (context) => widget.activity?.onPostLiked(
              context: context,
              currentProfile: widget.currentProfile,
              activity: widget.activity,
            ),
            shareEnabled: canActShare,
            onShare: (_) {},
            comments: totalComments,
            onComment: (_) {},
            bookmarked: isBookmarked,
            onBookmark: (context) => widget.activity?.onPostBookmarked(
              context: context,
              currentProfile: widget.currentProfile,
              reactionsFeedState: widget.activityReactionFeedState,
            ),
          ),
        ],
      );
    }

    return IgnorePointer(
      ignoring: !widget.isEnabled,
      child: Column(
        children: <Widget>[
          PositiveTapBehaviour(
            child: ActivityPostHeadingWidget(
              flMetaData: widget.activity?.flMeta,
              publisher: widget.targetProfile,
              promotion: widget.activityPromotion,
              onOptions: () => widget.activity?.onPostOptionsSelected(
                context: context,
                targetProfile: widget.targetProfile,
                currentProfile: widget.currentProfile,
              ),
              isShared: widget.isShared,
            ),
          ),
          if (canView) ...<Widget>[
            PositivePostLayoutWidget(
              postContent: widget.activity,
              publisherProfile: widget.targetProfile,
              publisherRelationship: widget.targetRelationship,
              promotion: widget.activityPromotion,
              isShortformPost: !widget.isFullscreen,
              sidePadding: widget.isShared ? kPaddingExtraSmall : kPaddingSmall,
              onLike: (context) => widget.activity?.onPostLiked(
                context: context,
                currentProfile: widget.currentProfile,
                activity: widget.activity,
              ),
              isLiked: isLiked,
              totalLikes: totalLikes,
              totalComments: totalComments,
              isBookmarked: isBookmarked,
              onBookmark: (context) => widget.activity?.onPostBookmarked(
                context: context,
                currentProfile: widget.currentProfile,
                reactionsFeedState: widget.activityReactionFeedState,
              ),
              isBusy: !widget.isEnabled,
              onPostPageRequested: widget.activity?.requestPostRoute,
              isShared: widget.isShared,
              onImageTap: (media) => widget.isFullscreen ? widget.activity?.requestFullscreenMedia(media) : widget.activity?.requestPostRoute(context),
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
