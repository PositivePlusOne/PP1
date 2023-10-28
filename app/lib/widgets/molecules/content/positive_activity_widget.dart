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
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:app/widgets/molecules/content/activity_post_heading_widget.dart';
import 'package:app/widgets/molecules/content/positive_post_actions.dart';
import 'package:app/widgets/molecules/content/positive_post_layout_widget.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../providers/system/design_controller.dart';

class PositiveActivityWidget extends StatefulHookConsumerWidget {
  const PositiveActivityWidget({
    required this.targetFeed,
    required this.activity,
    required this.activityReactionStatistics,
    required this.activityPromotion,
    required this.targetProfile,
    required this.targetRelationship,
    required this.currentProfile,
    required this.activityProfileReactions,
    required this.reposterActivityProfileReactions,
    required this.reposterProfile,
    required this.reposterRelationship,
    required this.reposterActivity,
    required this.reposterReactionStatistics,
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

  final Profile? targetProfile;
  final Relationship? targetRelationship;

  final Profile? currentProfile;
  final List<Reaction> activityProfileReactions;
  final List<Reaction> reposterActivityProfileReactions;

  final Profile? reposterProfile;
  final Relationship? reposterRelationship;

  final Activity? reposterActivity;
  final ReactionStatistics? reposterReactionStatistics;

  final int index;

  final bool isEnabled;

  final bool isFullscreen;
  final bool isShared;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => PositiveActivityWidgetState();
}

class PositiveActivityWidgetState extends ConsumerState<PositiveActivityWidget> {
  bool _isLiking = false;
  bool get isLiking => _isLiking;
  set isLiking(bool value) {
    _isLiking = value;
    setStateIfMounted();
  }

  bool _isBookmarking = false;
  bool get isBookmarking => _isBookmarking;
  set isBookmarking(bool value) {
    _isBookmarking = value;
    setStateIfMounted();
  }

  Future<void> _onInternalLikeRequested({
    required BuildContext context,
    bool useReposter = false,
  }) async {
    if (isLiking) {
      return;
    }

    isLiking = true;
    if (useReposter) {
      await widget.reposterActivity?.onPostLiked(context: context, currentProfile: widget.currentProfile, activity: widget.reposterActivity);
    } else {
      await widget.activity?.onPostLiked(context: context, currentProfile: widget.currentProfile, activity: widget.activity);
    }

    isLiking = false;
  }

  Future<void> _onInternalBookmarkRequested({
    required BuildContext context,
    bool useReposter = false,
  }) async {
    if (isBookmarking) {
      return;
    }

    isBookmarking = true;
    if (useReposter) {
      await widget.reposterActivity?.onPostBookmarked(context: context, currentProfile: widget.currentProfile);
    } else {
      await widget.activity?.onPostBookmarked(context: context, currentProfile: widget.currentProfile);
    }

    isBookmarking = false;
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final bool isRepost = widget.activity?.repostConfiguration?.targetActivityPublisherId.isNotEmpty ?? false;

    bool isActivityLiked = false;
    bool isBookmarked = false;
    int totalLikes = 0;
    int totalComments = 0;

    bool isParentActivityLiked = false;
    // bool isParentActivityBookmarked = false;
    int totalParentActivityLikes = 0;
    int totalParentActivityComments = 0;

    if (isRepost) {
      isActivityLiked = widget.reposterActivityProfileReactions.any((reaction) => reaction.kind == const ReactionType.like());
      isBookmarked = widget.reposterActivityProfileReactions.any((reaction) => reaction.kind == const ReactionType.bookmark());

      totalLikes = widget.reposterReactionStatistics?.counts["like"] ?? 0;
      totalComments = widget.reposterReactionStatistics?.counts["comment"] ?? 0;

      isParentActivityLiked = widget.activityProfileReactions.any((reaction) => reaction.kind == const ReactionType.like());
      // isParentActivityBookmarked = widget.activityProfileReactions.any((reaction) => reaction.kind == const ReactionType.bookmark());

      totalParentActivityLikes = widget.activityReactionStatistics?.counts["like"] ?? 0;
      totalParentActivityComments = widget.activityReactionStatistics?.counts["comment"] ?? 0;
    } else {
      isActivityLiked = widget.activityProfileReactions.any((reaction) => reaction.kind == const ReactionType.like());
      isBookmarked = widget.reposterActivityProfileReactions.any((reaction) => reaction.kind == const ReactionType.bookmark());

      totalLikes = widget.activityReactionStatistics?.counts["like"] ?? 0;
      totalComments = widget.activityReactionStatistics?.counts["comment"] ?? 0;
    }

    final Relationship? actualRelationship = isRepost ? widget.reposterRelationship : widget.targetRelationship;

    ActivitySecurityConfigurationMode viewMode = widget.activity?.securityConfiguration?.viewMode ?? const ActivitySecurityConfigurationMode.disabled();
    final bool canView = viewMode.canActOnActivity(
      activity: widget.reposterActivity ?? widget.activity,
      currentProfile: widget.currentProfile,
      publisherRelationship: actualRelationship,
    );

    ActivitySecurityConfigurationMode shareMode = widget.activity?.securityConfiguration?.shareMode ?? const ActivitySecurityConfigurationMode.disabled();
    final bool canActShare = shareMode.canActOnActivity(
      activity: widget.reposterActivity ?? widget.activity,
      currentProfile: widget.currentProfile,
      publisherRelationship: actualRelationship,
    );

    if (isRepost) {
      return Column(
        children: <Widget>[
          PositiveTapBehaviour(
            onTap: (context) => widget.activity?.requestPostRoute(
              context: context,
              currentProfile: widget.currentProfile,
            ),
            child: ActivityPostHeadingWidget(
              flMetaData: widget.activity?.flMeta,
              isShared: widget.isShared,
              publisher: widget.targetProfile,
              promotion: widget.activityPromotion,
              tags: widget.activity?.enrichmentConfiguration?.tags ?? [],
              onOptions: () => widget.activity?.onPostOptionsSelected(
                context: context,
                targetProfile: widget.targetProfile,
                currentProfile: widget.currentProfile,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: colors.white,
              borderRadius: BorderRadius.circular(kBorderRadiusMedium),
            ),
            margin: const EdgeInsets.all(kPaddingSmall),
            padding: const EdgeInsets.all(kPaddingSmall),
            child: PositiveActivityWidget(
              index: widget.index,
              currentProfile: widget.currentProfile,
              targetFeed: widget.targetFeed,
              targetProfile: widget.reposterProfile,
              targetRelationship: widget.reposterRelationship,
              activity: widget.reposterActivity,
              activityReactionStatistics: widget.reposterReactionStatistics,
              activityPromotion: null,
              activityProfileReactions: widget.reposterActivityProfileReactions,
              isEnabled: widget.isEnabled,
              isFullscreen: widget.isFullscreen,
              reposterProfile: null,
              reposterRelationship: null,
              reposterActivity: null,
              reposterReactionStatistics: null,
              reposterActivityProfileReactions: const [],
              isShared: true,
            ),
          ),
          PositivePostActions(
            bookmarkEnabled: false,
            bookmarked: false,
            comments: totalParentActivityComments,
            commentsEnabled: true,
            isLiked: isParentActivityLiked,
            likes: totalParentActivityLikes,
            likesEnabled: true,
            onBookmark: (context) => _onInternalBookmarkRequested(context: context, useReposter: true),
            onComment: (context) => widget.activity?.requestPostRoute(
              context: context,
              currentProfile: widget.currentProfile,
            ),
            onLike: (context) => _onInternalLikeRequested(context: context, useReposter: true),
            shareEnabled: canActShare,
            onShare: (context) => widget.reposterActivity?.share(context, widget.currentProfile),
          ),
        ],
      );
    }

    return IgnorePointer(
      ignoring: !widget.isEnabled,
      child: Column(
        children: <Widget>[
          PositiveTapBehaviour(
            onTap: (_) => widget.activity?.requestPostRoute(
              context: context,
              currentProfile: widget.currentProfile,
            ),
            child: ActivityPostHeadingWidget(
              flMetaData: widget.activity?.flMeta,
              publisher: widget.targetProfile,
              promotion: widget.activityPromotion,
              tags: widget.activity?.enrichmentConfiguration?.tags ?? [],
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
              currentProfile: widget.currentProfile,
              publisherProfile: widget.targetProfile,
              publisherRelationship: widget.targetRelationship,
              promotion: widget.activityPromotion,
              tags: widget.activity?.enrichmentConfiguration?.tags ?? [],
              isShortformPost: !widget.isFullscreen,
              sidePadding: widget.isShared ? kPaddingExtraSmall : kPaddingSmall,
              onLike: (context) => _onInternalLikeRequested(context: context),
              isLiked: isActivityLiked,
              onComment: (context) => widget.activity?.requestPostRoute(
                context: context,
                currentProfile: widget.currentProfile,
              ),
              totalLikes: totalLikes,
              likesEnabled: !isLiking,
              totalComments: totalComments,
              isBookmarked: isBookmarked,
              onBookmark: (context) => _onInternalBookmarkRequested(context: context),
              bookmarkEnabled: !isBookmarking,
              isBusy: !widget.isEnabled,
              onPostPageRequested: (context) => widget.activity?.requestPostRoute(context: context, currentProfile: widget.currentProfile),
              isShared: widget.isShared,
              onShare: (context) => widget.isShared ? widget.reposterActivity?.share(context, widget.currentProfile) : widget.activity?.share(context, widget.currentProfile),
              onImageTap: (media) => widget.isFullscreen
                  ? widget.activity?.requestFullscreenMedia(media)
                  : widget.activity?.requestPostRoute(
                      context: context,
                      currentProfile: widget.currentProfile,
                    ),
            ),
          ] else ...<Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: kPaddingMedium,
                right: kPaddingMedium,
                top: kPaddingSmall,
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
