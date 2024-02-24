// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:app/helpers/profile_helpers.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/annotations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/enrichment/promotions.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/helpers/cache_helpers.dart';
import 'package:app/hooks/cache_hook.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/content/promotions_controller.dart';
import 'package:app/providers/content/reactions_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/resources/resources.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/behaviours/positive_reaction_pagination_behaviour.dart';
import 'package:app/widgets/molecules/content/positive_activity_widget.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold_decoration.dart';
import 'package:app/widgets/organisms/post/post_comment_box.dart';
import 'package:app/widgets/organisms/post/vms/post_view_model.dart';
import 'package:app/widgets/state/positive_reactions_state.dart';

@RoutePage()
class PostPage extends HookConsumerWidget {
  const PostPage({
    required this.activityId,
    required this.feed,
    this.reactionId = '',
    this.promotionId = '',
    super.key,
  });

  final String activityId;
  final TargetFeed feed;

  final String reactionId;
  final String promotionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));

    final PostViewModelProvider provider = postViewModelProvider(activityId, feed);
    final PostViewModel viewModel = ref.read(provider.notifier);
    final PostViewModelState state = ref.watch(provider);

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final ProfileControllerState profileState = ref.watch(profileControllerProvider);

    final CacheController cacheController = ref.read(cacheControllerProvider);

    final Profile? currentProfile = profileState.currentProfile;
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';
    final bool isSignedOut = currentProfile == null;

    final Activity? activity = cacheController.get(activityId);
    final String activityOrigin = TargetFeed.toOrigin(feed);

    final String expectedReactionsKey = PositiveReactionsState.buildReactionsCacheKey(activityId: activityId, profileId: currentProfileId, activityOrigin: activityOrigin);
    PositiveReactionsState? reactionsState = cacheController.get(expectedReactionsKey);
    reactionsState ??= PositiveReactionsState.createNewFeedState(activityId: activityId, activityOrigin: activityOrigin, profileId: currentProfileId);

    final Promotion? promotion = cacheController.get(promotionId);

    final Profile? targetProfile = cacheController.get(activity?.publisherInformation?.publisherId);
    final Profile? reposterProfile = cacheController.get(activity?.repostConfiguration?.targetActivityPublisherId);

    final String expectedTargetRelationshipKey = [currentProfileId, targetProfile?.flMeta?.id ?? ''].asGUID;
    final Relationship? targetRelationship = cacheController.get(expectedTargetRelationshipKey);

    final String expectedReposterRelationshipKey = [currentProfileId, reposterProfile?.flMeta?.id ?? ''].asGUID;
    final Relationship? reposterRelationship = cacheController.get(expectedReposterRelationshipKey);

    final Activity? reposterActivity = cacheController.get(activity?.repostConfiguration?.targetActivityId);
    final String reposterActivityId = reposterActivity?.flMeta?.id ?? '';

    final PromotionsController promotionsController = ref.read(promotionsControllerProvider.notifier);
    final Promotion? reposterPromotion = promotionsController.getPromotionFromActivityId(activityId: reposterActivityId, promotionType: PromotionType.feed);

    final ReactionsController reactionsController = ref.read(reactionsControllerProvider.notifier);
    final String expectedReactionActivityStatisticsKey = reactionsController.buildExpectedStatisticsCacheKey(activityId: activityId);
    final ReactionStatistics? reactionActivityStatistics = cacheController.get(expectedReactionActivityStatisticsKey);

    final String expectedReactionRepostActivityStatisticsKey = reactionsController.buildExpectedStatisticsCacheKey(activityId: reposterActivity?.flMeta?.id ?? '');
    final ReactionStatistics? reactionRepostActivityStatistics = cacheController.get(expectedReactionRepostActivityStatisticsKey);

    final List<String> expectedUniqueReactionKeys = reactionsController.buildExpectedUniqueReactionKeysForActivityAndProfile(activity: activity, currentProfile: currentProfile);
    final List<Reaction> uniqueActivityReactions = cacheController.list(expectedUniqueReactionKeys);

    final List<String> expectedUniqueRepostReactionKeys = reactionsController.buildExpectedUniqueReactionKeysForActivityAndProfile(activity: reposterActivity, currentProfile: currentProfile);
    final List<Reaction> uniqueRepostActivityReactions = cacheController.list(expectedUniqueRepostReactionKeys);

    final List<String> expectedCacheKeys = buildExpectedCacheKeysFromObjects(currentProfile, [activity, reposterActivity, feed, reactionActivityStatistics, reactionRepostActivityStatistics, ...uniqueRepostActivityReactions, ...uniqueActivityReactions]).toList();

    useLifecycleHook(viewModel);
    useCacheHook(keys: expectedCacheKeys);

    final List<Widget> actions = [];

    if (currentProfile != null) {
      actions.addAll(buildCommonProfilePageActions());
    }

    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double maxSafePadding = max(mediaQuery.padding.bottom, mediaQuery.viewInsets.bottom);
    final double commentBoxSize = PostCommentBox.calculateHeight(mediaQuery);

    final bool commentsDisabled = activity?.securityConfiguration?.commentMode == const ActivitySecurityConfigurationMode.disabled();

    final bool canView = viewModel.checkCanView(
      activity: activity,
      currentProfile: currentProfile,
      publisherRelationship: targetRelationship,
    );

    final bool canComment = viewModel.checkCanComment(
      activity: activity,
      currentProfile: currentProfile,
      publisherRelationship: targetRelationship,
    );

    final List<PositiveScaffoldDecoration> decorations = canView ? [] : buildType3ScaffoldDecorations(colors);

    final Widget commentBox = Align(
      alignment: Alignment.bottomCenter,
      child: PostCommentBox(
        activity: activity,
        mediaQuery: mediaQuery,
        currentProfile: currentProfile,
        canSwitchProfile: viewModel.canSwitchProfile,
        onSwitchProfileRequested: () => viewModel.requestSwitchProfileDialog(
          context,
          mode: activity?.securityConfiguration?.commentMode,
          title: localizations.generic_organisation_actions_comment_as_title,
        ),
        commentTextController: viewModel.commentTextController,
        onCommentChanged: viewModel.onCommentTextChanged,
        onPostCommentRequested: (_) => viewModel.onPostCommentRequested(),
        isBusy: state.isBusy,
      ),
    );

    return PositiveScaffold(
      isBusy: state.isBusy,
      onWillPopScope: viewModel.onWillPopScope,
      physics: const AlwaysScrollableScrollPhysics(),
      onRefresh: () async => reactionsState?.requestRefresh(expectedReactionsKey),
      overlayWidgets: <Widget>[
        if (canComment && !commentsDisabled) commentBox,
        if (isSignedOut) ...<Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: maxSafePadding + kPaddingMedium,
                left: kPaddingMedium,
                right: kPaddingMedium,
              ),
              child: PositiveButton(
                colors: colors,
                primaryColor: colors.pink,
                label: localizations.shared_actions_sign_up,
                layout: PositiveButtonLayout.iconLeft,
                style: PositiveButtonStyle.primary,
                onTapped: viewModel.onRegisterRequested,
                iconWidgetBuilder: (Color color) => SvgPicture.asset(
                  SvgImages.logosCircular,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  height: PositiveButton.kButtonIconRadiusRegular,
                ),
              ),
            ),
          ),
        ],
      ],
      visibleComponents: const {
        PositiveScaffoldComponent.headingWidgets,
      },
      decorations: decorations,
      resizeToAvoidBottomInset: false,
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          horizontalPadding: kPaddingNone,
          appBarSpacing: kPaddingNone,
          appBarLeading: PositiveButton.appBarIcon(
            colors: colors,
            primaryColor: colors.black,
            icon: UniconsLine.angle_left_b,
            onTapped: () => viewModel.onWillPopScope(),
          ),
          appBarTrailing: <Widget>[
            for (final Widget actionWidget in actions) ...<Widget>[
              Align(
                alignment: Alignment.center,
                child: actionWidget,
              ),
            ],
          ],
          children: <Widget>[
            PositiveActivityWidget(
              currentProfile: currentProfile,
              activityPromotion: promotion,
              targetProfile: targetProfile,
              targetRelationship: targetRelationship,
              reposterProfile: reposterProfile,
              reposterRelationship: reposterRelationship,
              reposterActivity: reposterActivity,
              reposterPromotion: reposterPromotion,
              activityReactionStatistics: reactionActivityStatistics,
              activityProfileReactions: uniqueActivityReactions,
              reposterActivityProfileReactions: uniqueRepostActivityReactions,
              reposterReactionStatistics: reactionRepostActivityStatistics,
              activity: activity,
              targetFeed: feed,
              isFullscreen: true,
              isEnabled: !state.isBusy,
            ),
          ],
        ),
        if (canView) ...<Widget>[
          const SliverToBoxAdapter(child: SizedBox(height: kPaddingSmall)),
          SliverStack(
            children: <Widget>[
              SliverFillRemaining(
                fillOverscroll: true,
                hasScrollBody: false,
                child: Container(
                  color: canView ? colors.white : colors.transparent,
                  height: double.infinity,
                ),
              ),
              MultiSliver(
                pushPinnedChildren: true,
                children: <Widget>[
                  SliverToBoxAdapter(
                    child: ColoredBox(
                      color: colors.colorGray1,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            color: colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(kBorderRadiusMassive),
                            ),
                          ),
                          width: kPaddingMassive,
                          height: kPaddingExtraSmall,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(height: kPaddingExtraSmall, color: colors.colorGray1),
                  ),
                  PositiveReactionPaginationBehaviour(
                    kind: 'comment',
                    activity: activity,
                    publisherRelationship: targetRelationship,
                    reactionsState: reactionsState,
                    feed: feed,
                    reactionMode: activity?.securityConfiguration?.commentMode,
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: commentBoxSize)),
                ],
              ),
            ],
          ),
        ],
      ],
    );
  }
}
