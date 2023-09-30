// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:event_bus/event_bus.dart';
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
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/activity_extensions.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/extensions/paging_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/main.dart';
import 'package:app/providers/events/content/activity_events.dart';
import 'package:app/providers/events/content/reaction_events.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/reaction_api_service.dart';
import 'package:app/widgets/animations/positive_tile_entry_animation.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/atoms/pills/security_mode_pill.dart';
import 'package:app/widgets/molecules/content/positive_comment.dart';
import 'package:app/widgets/state/positive_reactions_state.dart';
import '../../services/third_party.dart';

class PositiveReactionPaginationBehaviour extends HookConsumerWidget {
  const PositiveReactionPaginationBehaviour({
    required this.reactionsState,
    required this.kind,
    required this.feed,
    this.activity,
    this.relationship,
    this.reactionMode,
    this.onPageLoaded,
    this.windowSize = 10,
    super.key,
  });

  final PositiveReactionsState reactionsState;
  final Activity? activity;
  final TargetFeed feed;
  final Relationship? relationship;
  final String kind;

  final ActivitySecurityConfigurationMode? reactionMode;

  final int windowSize;

  final Function(Map<String, dynamic>)? onPageLoaded;

  static const String kWidgetKey = 'PositiveReactionPaginationBehaviour';

  @override
  void initState() {
    super.initState();
    setupListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) => setupReactionsState());
  }

  @override
  void dispose() {
    disposeListeners();
    disposeReactionsState();
    super.dispose();
  }

  @override
  void didUpdateWidget(PositiveReactionPaginationBehaviour oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldactivityId != activityId) {
      disposeReactionsState();

      if (mounted) {
        setupReactionsState();
      }
    }
  }

  void disposeReactionsState() {
    reactionState?.pagingController.removePageRequestListener(requestNextPage);
  }

  void setupReactionsState() {
    final Logger logger = providerContainer.read(loggerProvider);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider);

    logger.d('setupReactionsState() - Loading state for ${activityId}');
    final PositiveReactionsState? cachedFeedState = cacheController.get(expectedCacheKey);
    if (cachedFeedState != null) {
      logger.d('setupReactionsState() - Found cached state for ${activityId}');
      reactionState = cachedFeedState;
      reactionState?.pagingController.addPageRequestListener(requestNextPage);
      setStateIfMounted();

      return;
    }

    logger.d('setupReactionsState() - No cached state for ${activityId}. Creating new state.');
    final PagingController<String, Reaction> pagingController = PagingController<String, Reaction>(firstPageKey: '');
    pagingController.addPageRequestListener(requestNextPage);

    reactionState = PositiveReactionsState(
      activityId: activityId,
      kind: kind,
      pagingController: pagingController,
      currentPaginationKey: '',
    );

    setStateIfMounted();
  }

  void saveReactionsState() {
    final Logger logger = providerContainer.read(loggerProvider);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider);

    if (reactionState?.pagingController.itemList?.isEmpty ?? true) {
      logger.d('saveState() - No reactions to save for ${activityId}');
      return;
    }

    logger.d('saveState() - Saving reactions state for ${activityId}');
    cacheController.add(key: expectedCacheKey, value: reactionState);
  }

  Future<void> requestNextPage(String pageKey) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final ReactionApiService reactionApiService = await providerContainer.read(reactionApiServiceProvider.future);

    if (!mounted) {
      logger.d('requestNextTimelinePage() - Not mounted');
      return;
    }

    try {
      final EndpointResponse endpointResponse = await reactionApiService.listReactionsForActivity(
        activityId: activityId,
        kind: kind,
        cursor: reactionState?.currentPaginationKey ?? '',
      );

      final Map<String, dynamic> data = json.decodeSafe(endpointResponse.data);
      String next = data.containsKey('cursor') ? data['cursor'].toString() : '';

      // Check for weird backend loops (extra safety)
      if (next == reactionState?.currentPaginationKey) {
        next = '';
      }

      appendReactionPage(data, next);
      onPageLoaded?.call(data);
    } catch (ex) {
      logger.e('requestNextTimelinePage() - ex: $ex');
      reactionsState.pagingController.error = ex;
    } finally {
      saveReactionsState();
    }
  }

  // Currently comments are the only reaction type supported.
  String buildCommentHeaderText(AppLocalizations localizations) {
    final ActivitySecurityConfigurationMode commentMode = activity.securityConfiguration?.commentMode ?? const ActivitySecurityConfigurationMode.disabled();
    final UserController userController = providerContainer.read(userControllerProvider.notifier);

    final bool loggedIn = userController.isUserLoggedIn;
    final bool isFollowing = relationship?.following ?? false;
    final bool isConnected = relationship?.isValidConnectedRelationship ?? false;
    final bool isBlocked = relationship?.blocked ?? false;

    if (isBlocked) {
      return localizations.post_comments_disabled_header;
    }

    late String commentHeaderText;

    commentMode.when(
      public: () => commentHeaderText = loggedIn ? localizations.post_comments_public_header : localizations.post_comments_signed_in_header,
      signedIn: () => commentHeaderText = loggedIn ? localizations.post_comments_public_header : localizations.post_comments_signed_in_header,
      followersAndConnections: () {
        if (loggedIn) {
          return commentHeaderText = (isFollowing || isConnected) ? localizations.post_comments_public_header : localizations.post_comments_followers_connections_header;
        } else {
          return commentHeaderText = localizations.post_comments_signed_in_followers_header;
        }
      },
      connections: () {
        if (loggedIn) {
          return commentHeaderText = (isFollowing || isConnected) ? localizations.post_comments_public_header : localizations.post_comments_connections_header;
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

    return MultiSliver(
      children: <Widget>[
        SliverToBoxAdapter(
          child: Container(
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
        ),
        if (commentsDisabled) ...<Widget>[
          SliverToBoxAdapter(child: commentPlaceholder),
        ],
        if (!commentsDisabled) ...<Widget>[
          PagedSliverList.separated(
            shrinkWrapFirstPageIndicators: true,
            pagingController: reactionsState.pagingController,
            separatorBuilder: (_, __) => const SizedBox(height: kBorderThicknessMedium),
            builderDelegate: PagedChildBuilderDelegate<Reaction>(
              animateTransitions: true,
              transitionDuration: kAnimationDurationRegular,
              itemBuilder: (_, reaction, index) => PositiveComment(comment: reaction, isFirst: index == 0),
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
