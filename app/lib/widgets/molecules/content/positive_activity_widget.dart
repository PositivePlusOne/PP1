// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html2md/html2md.dart' as html2md;

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/dtos/database/enrichment/promotions.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/activity_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/providers/profiles/tags_controller.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:app/widgets/molecules/content/activity_post_heading_widget.dart';
import 'package:app/widgets/molecules/content/positive_post_actions.dart';
import 'package:app/widgets/molecules/content/positive_post_layout_widget.dart';
import 'package:app/widgets/organisms/development/vms/development_view_model.dart';
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
    required this.reposterPromotion,
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
  final Promotion? reposterPromotion;

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

  double get sidePadding => widget.isFullscreen ? 0.0 : (widget.isShared || widget.isFullscreen ? kPaddingExtraSmall : kPaddingSmall);

  Future<void> _onInternalLikeRequested({
    required BuildContext context,
    required AppRouter appRouter,
    bool useReposter = false,
  }) async {
    if (widget.activity == null) {
      return;
    }

    // Check if the post is from the current user
    // If so, go to the post reactions page
    final bool isPublisher = widget.activity?.publisherInformation?.publisherId == widget.currentProfile?.flMeta?.id;
    if (isPublisher) {
      await appRouter.push(PostReactionsRoute(
        activity: widget.activity!,
        reactionType: 'like',
        feed: widget.targetFeed,
      ));

      return;
    }

    try {
      if (isLiking) {
        return;
      }

      isLiking = true;
      if (useReposter) {
        await widget.reposterActivity?.onPostLiked(context: context, currentProfile: widget.currentProfile, activity: widget.reposterActivity);
      } else {
        await widget.activity?.onPostLiked(context: context, currentProfile: widget.currentProfile, activity: widget.activity);
      }
    } finally {
      isLiking = false;
    }
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
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final AppRouter appRouter = ref.read(appRouterProvider);

    final bool displayActivityIds = ref.watch(developmentViewModelProvider.select((value) => value.displaySelectablePostIDs));
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
    final Activity? focusActivity = widget.reposterActivity ?? widget.activity;

    final bool canView = viewMode.canActOnActivity(
      activity: focusActivity,
      currentProfile: widget.currentProfile,
      publisherRelationship: actualRelationship,
    );

    final ActivityGeneralConfigurationType postType = focusActivity?.generalConfiguration?.type ?? const ActivityGeneralConfigurationType.post();
    final String postTypeLocale = ActivityGeneralConfigurationType.toLocale(postType, localizations).toLowerCase();

    // Decide what error message to display if the user can't view the post
    String cannotDisplayErrorBody = localizations.shared_post_visibility_deleted(postTypeLocale);
    if (focusActivity?.hasContentToDisplay == true) {
      cannotDisplayErrorBody = localizations.shared_post_visibility_limited(postTypeLocale);
    }

    final Set<RelationshipState> relationshipStates = actualRelationship?.relationshipStatesForEntity(widget.currentProfile?.flMeta?.id ?? '') ?? {};
    final bool hasHidden = relationshipStates.contains(RelationshipState.sourceHidden);
    if (hasHidden) {
      cannotDisplayErrorBody = localizations.shared_post_visibility_hidden;
    }

    // Reposts are always shareable as they share a copy of the original post
    ActivitySecurityConfigurationMode shareMode = widget.activity?.securityConfiguration?.shareMode ?? const ActivitySecurityConfigurationMode.disabled();
    if (widget.reposterActivity != null) {
      shareMode = widget.reposterActivity?.securityConfiguration?.shareMode ?? const ActivitySecurityConfigurationMode.disabled();
    }

    final bool canActShare = shareMode.canActOnActivity(
      activity: focusActivity,
      currentProfile: widget.currentProfile,
      publisherRelationship: actualRelationship,
    );

    if (isRepost) {
      bool isRepostPublisher = widget.reposterActivity?.publisherInformation?.publisherId == widget.currentProfile?.flMeta?.id;
      return Column(
        children: <Widget>[
          PositiveTapBehaviour(
            onTap: (context) => widget.activity?.requestPostRoute(
              context: context,
              currentProfile: widget.currentProfile,
            ),
            child: ActivityPostHeadingWidget(
              publisher: widget.targetProfile,
              publisherRelationship: widget.targetRelationship,
              currentProfile: widget.currentProfile,
              origin: widget.activity?.repostConfiguration?.targetActivityOriginFeed ?? '',
              activity: widget.activity,
              padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium, vertical: kPaddingSuperSmall),
              isOptionsHidden: widget.isShared,
              tags: widget.activity?.enrichmentConfiguration?.tags ?? [],
              isRepost: isRepost,
              isShared: widget.isShared,
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
              activityPromotion: widget.reposterPromotion,
              activityProfileReactions: widget.reposterActivityProfileReactions,
              isEnabled: widget.isEnabled,
              isFullscreen: widget.isFullscreen,
              reposterProfile: null,
              reposterRelationship: null,
              reposterActivity: null,
              reposterReactionStatistics: null,
              reposterPromotion: null,
              reposterActivityProfileReactions: const [],
              isShared: true,
            ),
          ),
          buildMarkdownBodyWidget(targetActivity: widget.activity),
          PositivePostActions(
            bookmarkEnabled: false,
            bookmarked: false,
            comments: totalParentActivityComments,
            commentsEnabled: true,
            padding: EdgeInsets.symmetric(
              horizontal: kPaddingMedium + sidePadding,
              vertical: kPaddingExtraSmall,
            ),
            isLiked: isParentActivityLiked,
            likes: totalParentActivityLikes,
            likesEnabled: (!isLiking && !isRepostPublisher) || (isRepostPublisher && totalParentActivityLikes > 0),
            onBookmark: (context) => _onInternalBookmarkRequested(context: context),
            onComment: (context) => widget.activity?.requestPostRoute(
              context: context,
              currentProfile: widget.currentProfile,
            ),
            onLike: (context) => _onInternalLikeRequested(context: context, appRouter: appRouter),
            shareEnabled: canActShare,
            onShare: (context) => widget.reposterActivity?.share(context, widget.currentProfile) ?? widget.activity?.share(context, widget.currentProfile),
          ),
        ],
      );
    }

    final bool isActivityPublisher = widget.activity?.publisherInformation?.publisherId == widget.currentProfile?.flMeta?.id;
    return IgnorePointer(
      ignoring: !widget.isEnabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PositiveTapBehaviour(
            onTap: (_) => widget.activity?.requestPostRoute(
              context: context,
              currentProfile: widget.currentProfile,
              promotionId: widget.activityPromotion?.flMeta?.id ?? '',
            ),
            child: ActivityPostHeadingWidget(
              activity: widget.activity,
              padding: EdgeInsets.symmetric(horizontal: widget.isShared ? kPaddingSmall : kPaddingMedium, vertical: kPaddingSuperSmall),
              publisher: widget.targetProfile,
              publisherRelationship: widget.targetRelationship,
              origin: widget.activity?.publisherInformation?.originFeed ?? '',
              currentProfile: widget.currentProfile,
              promotion: widget.activityPromotion,
              tags: widget.activity?.enrichmentConfiguration?.tags ?? [],
              isShared: widget.isShared,
              onOptions: () => widget.activity?.onPostOptionsSelected(
                context: context,
                targetProfile: widget.targetProfile,
                currentProfile: widget.currentProfile,
              ),
              isOptionsHidden: widget.isShared,
            ),
          ),
          if (canView) ...<Widget>[
            PositivePostLayoutWidget(
              postContent: widget.activity,
              repostContent: widget.reposterActivity,
              markdownWidget: buildMarkdownBodyWidget(targetActivity: widget.activity),
              currentProfile: widget.currentProfile,
              publisherProfile: widget.targetProfile,
              publisherRelationship: widget.targetRelationship,
              promotion: widget.activityPromotion,
              tags: widget.activity?.enrichmentConfiguration?.tags ?? [],
              isShortformPost: !widget.isFullscreen,
              sidePadding: sidePadding,
              isLiked: isActivityLiked,
              totalLikes: totalLikes,
              likesEnabled: (!isLiking && !isActivityPublisher) || (isActivityPublisher && totalLikes > 0),
              onLike: (context) => _onInternalLikeRequested(context: context, appRouter: appRouter),
              onComment: (context) => widget.activity?.requestPostRoute(
                context: context,
                currentProfile: widget.currentProfile,
                promotionId: widget.activityPromotion?.flMeta?.id ?? '',
              ),
              totalComments: totalComments,
              isBookmarked: isBookmarked,
              onBookmark: (context) => _onInternalBookmarkRequested(context: context),
              bookmarkEnabled: !isBookmarking,
              isBusy: !widget.isEnabled,
              onPostPageRequested: (context) => widget.activity?.requestPostRoute(
                context: context,
                currentProfile: widget.currentProfile,
                promotionId: widget.activityPromotion?.flMeta?.id ?? '',
              ),
              isShared: widget.isShared,
              onShare: (context) => widget.isShared ? widget.reposterActivity?.share(context, widget.currentProfile) : widget.activity?.share(context, widget.currentProfile),
              onImageTap: (media) => widget.isFullscreen
                  ? widget.activity?.requestFullscreenMedia(media)
                  : widget.activity?.requestPostRoute(
                      context: context,
                      currentProfile: widget.currentProfile,
                      promotionId: widget.activityPromotion?.flMeta?.id ?? '',
                    ),
            ),
          ] else ...<Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium, vertical: kPaddingSmall),
              child: Text(
                cannotDisplayErrorBody,
                textAlign: TextAlign.left,
                style: typography.styleBody.copyWith(color: colors.black),
              ),
            ),
          ],
          if (displayActivityIds) ...<Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: kPaddingLarge,
                right: kPaddingLarge,
                top: kPaddingSmall,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SelectableText(
                  widget.activity?.flMeta?.id ?? '',
                  style: typography.styleSubtext.copyWith(color: colors.black, fontSize: 8.0),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  //* -=-=-=-=-=- Markdown body, displayed for video and posts -=-=-=-=-=- *\\
  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  Widget buildMarkdownBodyWidget({
    required Activity? targetActivity,
  }) {
    //? The current markdown_widget does NOT allow for the double space for newline as is standard for Markdown, instead opting to use \n, \r and oddly also \t as newline chars
    //? Due to this the newline characters need to be temporarally stripped as the html to markdown converter will replace them with double space
    //? in addition to this the markdown_widget also cannot identify hyperlinks unless they begin with http or www
    //? This causes links to break if they are after a newline/carriage as they begin with for example "nhttp"
    //? as a temporary solution we are adding a single whitespace character after newlines before hyperlinks

    String parsedMarkdown = html2md.convert(
      targetActivity?.generalConfiguration?.content.replaceAll("\n", ":Carriage Return:") ?? '',
    );
    parsedMarkdown = parsedMarkdown.replaceAll(":Carriage Return:", "\n");
    parsedMarkdown = parsedMarkdown.replaceAllMapped(RegExp("www.|https:|http:", caseSensitive: false), (match) => match.input.substring(match.start, match.end).toLowerCase());
    parsedMarkdown = parsedMarkdown.replaceAll(RegExp("\n(?=www.|http:|https:)", caseSensitive: false), "\n ");

    if (!widget.isFullscreen) {
      int lastIndex = 0;
      int removeFromCharacter = 0;
      //? Find the first few instances of carriage returns, new lines, or tabs, and record the position of the last one
      for (var i = 0; i < kMaximumNumberOfReturnsInFeedItem; i++) {
        lastIndex = parsedMarkdown.indexOf(RegExp('[\r\n\t]'), removeFromCharacter);
        if (lastIndex < 0) {
          break;
        } else {
          removeFromCharacter = (lastIndex + 1).clamp(0, parsedMarkdown.length - 1);
        }
      }
      //?  replace all carriage returns after the the removeFromCharacter point
      parsedMarkdown = parsedMarkdown.substring(0, removeFromCharacter) + parsedMarkdown.substring(removeFromCharacter).replaceAll(RegExp('[\r\n\t]'), ' ');
    }

    final TagsController tagsController = ref.read(tagsControllerProvider.notifier);
    final List<Tag> tags = tagsController.resolveTags(targetActivity?.enrichmentConfiguration?.tags ?? [], includePromotionTags: false);

    final double padding = kPaddingSmallMedium + sidePadding;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: buildMarkdownWidgetFromBody(
        parsedMarkdown,
        tags: tags,
        boldHandles: true,
        mentions: targetActivity?.enrichmentConfiguration?.mentions ?? [],
      ),
    );
  }
}
