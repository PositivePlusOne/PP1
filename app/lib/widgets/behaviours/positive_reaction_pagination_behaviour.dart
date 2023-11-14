// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';
import 'package:sliver_tools/sliver_tools.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/common/endpoint_response.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/extensions/reaction_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/hooks/paging_controller_hook.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/reaction_api_service.dart';
import 'package:app/widgets/animations/positive_tile_entry_animation.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/atoms/pills/security_mode_pill.dart';
import 'package:app/widgets/behaviours/positive_feed_pagination_behaviour.dart';
import 'package:app/widgets/molecules/content/positive_comment.dart';
import 'package:app/widgets/state/positive_reactions_state.dart';
import '../../services/third_party.dart';

class PositiveReactionPaginationBehaviour extends HookConsumerWidget {
  const PositiveReactionPaginationBehaviour({
    required this.activity,
    required this.publisherRelationship,
    required this.reactionsState,
    required this.feed,
    required this.kind,
    this.reactionMode,
    this.windowSize = 10,
    super.key,
  });

  final Activity? activity;
  final Relationship? publisherRelationship;
  final PositiveReactionsState reactionsState;
  final TargetFeed feed;
  final String kind;

  final ActivitySecurityConfigurationMode? reactionMode;

  final int windowSize;

  static const String kWidgetKey = 'PositiveReactionPaginationBehaviour';

  void saveReactionsState() {
    final Logger logger = providerContainer.read(loggerProvider);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider);

    if (reactionsState.pagingController.value.error != null || reactionsState.pagingController.value.status == PagingStatus.loadingFirstPage) {
      logger.d('saveState() - Not saving reactions state as there is an error or it is loading');
      return;
    }

    logger.d('saveState() - Saving reactions state for $reactionsState');
    final String newCacheKey = reactionsState.buildCacheKey();
    cacheController.add(key: newCacheKey, value: reactionsState);
  }

  Future<void> requestNextPage(String pageKey) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final ReactionApiService reactionApiService = await providerContainer.read(reactionApiServiceProvider.future);

    try {
      final EndpointResponse endpointResponse = await reactionApiService.listReactionsForActivity(
        activityId: activity?.flMeta?.id ?? '',
        kind: kind,
        cursor: reactionsState.currentPaginationKey,
      );

      final Map<String, dynamic> data = json.decodeSafe(endpointResponse.data);
      String? next = data.containsKey('cursor') ? data['cursor'].toString() : '';

      // Check for weird backend loops (extra safety)
      // statistics:activity:96d5fc30-623c-11ee-9782-5f6680786a6f
      if (next == reactionsState.currentPaginationKey) {
        next = null;
      }

      appendReactionPageToState(data, next);
    } catch (ex) {
      logger.e('requestNextTimelinePage() - ex: $ex');
      reactionsState.pagingController.error = ex;
    } finally {
      saveReactionsState();
    }
  }

  void appendReactionPageToState(Map<String, dynamic> data, String? next) {
    final Logger logger = providerContainer.read(loggerProvider);

    final List<dynamic> reactions = data['reactions'] as List<dynamic>;
    final List<Reaction> reactionList = reactions.map((dynamic reaction) => Reaction.fromJson(reaction as Map<String, dynamic>)).toList();

    logger.d('appendReactionPageToState() - reactionList: $reactionList');

    reactionsState.pagingController.appendPage(reactionList, next);
  }

  // Currently comments are the only reaction type supported.
  String buildCommentHeaderText(AppLocalizations localizations) {
    final ActivitySecurityConfigurationMode commentMode = activity?.securityConfiguration?.commentMode ?? const ActivitySecurityConfigurationMode.disabled();
    final UserController userController = providerContainer.read(userControllerProvider.notifier);

    final bool loggedIn = userController.isUserLoggedIn;
    final bool isOwn = activity?.publisherInformation?.publisherId == userController.currentUser?.uid;
    final bool isFollowing = publisherRelationship?.following ?? false;
    final bool isConnected = publisherRelationship?.isValidConnectedRelationship ?? false;
    final bool isBlocked = publisherRelationship?.blocked ?? false;

    if (isBlocked) {
      return localizations.post_comments_disabled_header;
    }

    late String commentHeaderText;

    commentMode.when(
      public: () => commentHeaderText = loggedIn ? localizations.post_comments_public_header : localizations.post_comments_signed_in_header,
      signedIn: () => commentHeaderText = loggedIn ? localizations.post_comments_public_header : localizations.post_comments_signed_in_header,
      followersAndConnections: () {
        if (loggedIn) {
          return commentHeaderText = (isFollowing || isConnected || isOwn) ? localizations.post_comments_public_header : localizations.post_comments_followers_connections_header;
        } else {
          return commentHeaderText = localizations.post_comments_signed_in_followers_header;
        }
      },
      connections: () {
        if (loggedIn) {
          return commentHeaderText = (isFollowing || isConnected || isOwn) ? localizations.post_comments_public_header : localizations.post_comments_connections_header;
        } else {
          return commentHeaderText = localizations.post_comments_signed_in_connections_header;
        }
      },
      private: () => commentHeaderText = localizations.post_comments_private_header,
      disabled: () => commentHeaderText = localizations.post_comments_disabled_header,
    );

    return commentHeaderText;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));

    final Widget loadingIndicator = Container(
      alignment: Alignment.center,
      color: colours.white,
      child: const PositiveLoadingIndicator(),
    );

    final Widget commentPlaceholder = ReactionPlaceholderWidget(headerText: buildCommentHeaderText(localizations));
    final bool commentsDisabled = reactionMode == const ActivitySecurityConfigurationMode.disabled();

    final Profile? currentProfile = ref.watch(profileControllerProvider.select((value) => value.currentProfile));

    usePagingController(
      controller: reactionsState.pagingController,
      listener: requestNextPage,
    );

    return MultiSliver(
      children: <Widget>[
        SliverToBoxAdapter(
          child: Stack(
            children: <Widget>[
              Positioned.fill(child: ColoredBox(color: colours.colorGray1)),
              Container(
                decoration: BoxDecoration(
                  color: colours.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(kBorderRadiusLarge)),
                ),
                padding: const EdgeInsets.all(kPaddingMedium),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      localizations.shared_comments_heading,
                      style: typography.styleSubtitleBold.copyWith(color: colours.colorGray3),
                    ),
                    if (reactionMode != null) ...<Widget>[
                      SecurityModePill(reactionMode: reactionMode!),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        if (commentsDisabled) ...<Widget>[
          SliverToBoxAdapter(child: commentPlaceholder),
        ],
        if (!commentsDisabled) ...<Widget>[
          PagedSliverList.separated(
            shrinkWrapFirstPageIndicators: true,
            pagingController: reactionsState.pagingController,
            separatorBuilder: (_, __) => PositiveFeedPaginationBehaviour.buildVisualSeparator(
              context,
              // designed to have a very thin seperator of the grey
              color: colours.colorGray1,
              // without any padding
              vPadding: 0,
            ),
            builderDelegate: PagedChildBuilderDelegate<Reaction>(
              animateTransitions: true,
              transitionDuration: kAnimationDurationRegular,
              itemBuilder: (_, reaction, index) => PositiveComment(
                currentProfile: currentProfile,
                comment: reaction,
                isFirst: index == 0,
                onOptionSelected: (comment, publisherProfile) => comment.onReactionOptionsSelected(
                  context: context,
                  targetProfile: publisherProfile,
                  currentProfile: currentProfile,
                  reactionID: comment.flMeta?.id ?? "",
                  reactionFeedState: reactionsState,
                ),
              ),
              firstPageErrorIndicatorBuilder: (_) => const SizedBox.shrink(),
              newPageErrorIndicatorBuilder: (_) => const SizedBox.shrink(),
              noMoreItemsIndicatorBuilder: (_) => const SizedBox.shrink(),
              firstPageProgressIndicatorBuilder: (_) => loadingIndicator,
              newPageProgressIndicatorBuilder: (_) => loadingIndicator,
              noItemsFoundIndicatorBuilder: (_) => commentPlaceholder,
            ),
          ),
        ],
      ],
    );
  }
}

class ReactionPlaceholderWidget extends ConsumerWidget {
  const ReactionPlaceholderWidget({
    super.key,
    required this.headerText,
  });

  final String headerText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final DesignColorsModel colours = ref.watch(designControllerProvider.select((value) => value.colors));

    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final Size screenSize = mediaQueryData.size;

    return Container(
      decoration: BoxDecoration(color: colours.white),
      child: PositiveTileEntryAnimation(
        direction: AxisDirection.down,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: kPaddingMedium, right: kPaddingMedium, top: kPaddingSmallMedium),
              child: Text(
                headerText,
                textAlign: TextAlign.left,
                style: typography.styleHeroMedium,
              ),
            ),
            SizedBox(
              width: screenSize.width,
              height: screenSize.width,
              child: Stack(
                children: buildType5ScaffoldDecorations(colours),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
