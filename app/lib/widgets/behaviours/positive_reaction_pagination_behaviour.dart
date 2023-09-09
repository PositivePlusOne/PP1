// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/common/endpoint_response.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/extensions/paging_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/main.dart';
import 'package:app/providers/events/content/activities.dart';
import 'package:app/providers/events/content/reactions.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/reaction_api_service.dart';
import 'package:app/widgets/animations/positive_tile_entry_animation.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/molecules/content/positive_comment.dart';
import 'package:app/widgets/state/positive_reactions_state.dart';
import '../../services/third_party.dart';

class PositiveReactionPaginationBehaviour extends StatefulHookConsumerWidget {
  const PositiveReactionPaginationBehaviour({
    required this.activityId,
    required this.kind,
    required this.feed,
    this.reactionMode,
    this.onPageLoaded,
    this.windowSize = 10,
    super.key,
  });

  final String activityId;
  final String kind;
  final TargetFeed feed;

  final ActivitySecurityConfigurationMode? reactionMode;

  final int windowSize;

  final Function(Map<String, dynamic>)? onPageLoaded;

  static const String kWidgetKey = 'PositiveReactionPaginationBehaviour';

  @override
  ConsumerState<PositiveReactionPaginationBehaviour> createState() => PositiveReactionPaginationBehaviourState();
}

class PositiveReactionPaginationBehaviourState extends ConsumerState<PositiveReactionPaginationBehaviour> {
  late PositiveReactionsState reactionState;

  StreamSubscription<ReactionCreatedEvent>? _onReactionCreatedSubscription;
  StreamSubscription<ReactionUpdatedEvent>? _onReactionUpdatedSubscription;
  StreamSubscription<ReactionDeletedEvent>? _onReactionDeletedSubscription;

  String get expectedCacheKey => buildCacheKey(widget.kind, widget.activityId);

  static String buildCacheKey(String kind, String activityId) {
    return 'reactions:$kind:$activityId';
  }

  Activity? get activity => ref.read(cacheControllerProvider.notifier).getFromCache(widget.activityId);

  @override
  void initState() {
    super.initState();
    setupListeners();
    setupReactionsState();
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
    if (oldWidget.activityId != widget.activityId) {
      disposeReactionsState();
      setupReactionsState();
    }
  }

  Future<void> setupListeners() async {
    final EventBus eventBus = providerContainer.read(eventBusProvider);

    await _onReactionCreatedSubscription?.cancel();
    await _onReactionUpdatedSubscription?.cancel();
    await _onReactionDeletedSubscription?.cancel();

    _onReactionCreatedSubscription = eventBus.on<ReactionCreatedEvent>().listen(onReactionCreated);
    _onReactionUpdatedSubscription = eventBus.on<ReactionUpdatedEvent>().listen(onReactionUpdated);
    _onReactionDeletedSubscription = eventBus.on<ReactionDeletedEvent>().listen(onReactionDeleted);
  }

  Future<void> disposeListeners() async {
    await _onReactionCreatedSubscription?.cancel();
    await _onReactionUpdatedSubscription?.cancel();
    await _onReactionDeletedSubscription?.cancel();
  }

  void disposeReactionsState() {
    reactionState.pagingController.removePageRequestListener(requestNextPage);
  }

  void setupReactionsState() {
    final Logger logger = providerContainer.read(loggerProvider);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

    logger.d('setupReactionsState() - Loading state for ${widget.activityId}');
    final PositiveReactionsState? cachedFeedState = cacheController.getFromCache(expectedCacheKey);
    if (cachedFeedState != null) {
      logger.d('setupReactionsState() - Found cached state for ${widget.activityId}');
      reactionState = cachedFeedState;
      reactionState.pagingController.addPageRequestListener(requestNextPage);
      return;
    }

    logger.d('setupReactionsState() - No cached state for ${widget.activityId}. Creating new state.');
    final PagingController<String, Reaction> pagingController = PagingController<String, Reaction>(firstPageKey: '');
    pagingController.addPageRequestListener(requestNextPage);

    reactionState = PositiveReactionsState(
      activityId: widget.activityId,
      kind: widget.kind,
      pagingController: pagingController,
      currentPaginationKey: '',
    );
  }

  void saveReactionsState() {
    final Logger logger = providerContainer.read(loggerProvider);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

    if (reactionState.pagingController.itemList?.isEmpty ?? true) {
      logger.d('saveState() - No reactions to save for ${widget.activityId}');
      return;
    }

    logger.d('saveState() - Saving reactions state for ${widget.activityId}');
    cacheController.addToCache(key: expectedCacheKey, value: reactionState);
  }

  Future<void> requestNextPage(String pageKey) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final ReactionApiService reactionApiService = await providerContainer.read(reactionApiServiceProvider.future);

    try {
      final EndpointResponse endpointResponse = await reactionApiService.listReactionsForActivity(
        activityId: widget.activityId,
        kind: widget.kind,
        cursor: reactionState.currentPaginationKey,
      );

      final Map<String, dynamic> data = json.decodeSafe(endpointResponse.data);
      String next = data.containsKey('cursor') ? data['cursor'].toString() : '';

      // Check for weird backend loops (extra safety)
      if (next == reactionState.currentPaginationKey) {
        next = '';
      }

      appendReactionPage(data, next);
      widget.onPageLoaded?.call(data);
    } catch (ex) {
      logger.e('requestNextTimelinePage() - ex: $ex');
      reactionState.pagingController.error = ex;
    } finally {
      saveReactionsState();
    }
  }

  void appendReactionPage(Map<String, dynamic> data, String nextPageKey) {
    final Logger logger = providerContainer.read(loggerProvider);
    final bool hasNext = nextPageKey.isNotEmpty && nextPageKey != reactionState.currentPaginationKey;

    reactionState.currentPaginationKey = nextPageKey;
    logger.i('requestNextTimelinePage() - hasNext: $hasNext - nextPageKey: $nextPageKey - currentPaginationKey: ${reactionState.currentPaginationKey}');

    final List<Reaction> newReactions = [];
    final List<dynamic> reactions = (data.containsKey('reactions') ? data['reactions'] : []).map((dynamic activity) => json.decodeSafe(activity)).toList();

    for (final dynamic reaction in reactions) {
      try {
        logger.d('requestNextTimelinePage() - parsing reaction: $reaction');
        final Reaction newReaction = Reaction.fromJson(reaction);
        final String reactionId = newReaction.flMeta?.id ?? '';

        if (reactionId.isEmpty) {
          logger.e('requestNextTimelinePage() - Failed to parse reaction: $reaction');
          continue;
        }

        newReactions.add(newReaction);
      } catch (ex) {
        logger.e('requestNextTimelinePage() - Failed to parse reaction: $reaction - ex: $ex');
      }
    }

    logger.d('requestNextTimelinePage() - newReactions: $newReactions');

    if (!hasNext && mounted) {
      reactionState.pagingController.appendSafeLastPage(newReactions);
    } else if (mounted) {
      reactionState.pagingController.appendSafePage(newReactions, nextPageKey);
    }

    saveReactionsState();
  }

  void onReactionCreated(ReactionCreatedEvent event) {
    final Logger logger = providerContainer.read(loggerProvider);
    final Reaction reaction = event.reaction;
    if (event.activityId == widget.activityId) {
      reactionState.pagingController.itemList?.insert(0, reaction);
      reactionState.pagingController.itemList = reactionState.pagingController.itemList;

      logger.d('onReactionCreated() - Added reaction to state: ${widget.activityId} - reaction: $reaction');
      setStateIfMounted();
    }
  }

  void onReactionUpdated(ReactionUpdatedEvent event) {
    final Logger logger = providerContainer.read(loggerProvider);
    final Reaction reaction = event.reaction;
    if (event.activityId == widget.activityId) {
      final int index = reactionState.pagingController.itemList?.indexWhere((element) => element.flMeta?.id == reaction.flMeta?.id) ?? -1;
      if (index >= 0) {
        reactionState.pagingController.itemList?[index] = reaction;
        reactionState.pagingController.itemList = reactionState.pagingController.itemList;

        logger.d('onReactionUpdated() - Updated reaction in state: ${widget.activityId} - reaction: $reaction');
        setStateIfMounted();
      }
    }
  }

  void onReactionDeleted(ReactionDeletedEvent event) {
    final Logger logger = providerContainer.read(loggerProvider);
    if (event.activityId == widget.activityId) {
      final int index = reactionState.pagingController.itemList?.indexWhere((element) => element.flMeta?.id == event.activityId) ?? -1;
      if (index >= 0) {
        reactionState.pagingController.itemList?.removeAt(index);
        reactionState.pagingController.itemList = reactionState.pagingController.itemList;

        logger.d('onReactionDeleted() - Deleted reaction in state');
        setStateIfMounted();
      }
    }
  }

  bool checkCanComment() {
    final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);

    final ActivitySecurityConfigurationMode commentMode = activity?.securityConfiguration?.commentMode ?? const ActivitySecurityConfigurationMode.disabled();
    final String publisherId = activity?.publisherInformation?.publisherId ?? '';
    final String currentUserId = profileController.currentProfileId ?? '';
    if (publisherId.isEmpty) {
      return false;
    }

    final bool isPublisher = publisherId == currentUserId;
    if (isPublisher) {
      return true;
    }

    final String relationshipGuid = [publisherId, currentUserId].asGUID;
    final Relationship? relationship = cacheController.getFromCache(relationshipGuid);
    final Set<RelationshipState> relationshipStates = relationship?.relationshipStatesForEntity(currentUserId) ?? {};
    final bool isConnected = relationshipStates.contains(RelationshipState.sourceConnected) && relationshipStates.contains(RelationshipState.targetConnected);
    final bool isFollowing = relationshipStates.contains(RelationshipState.sourceFollowed);

    return commentMode.when(
      public: () => true,
      signedIn: () => currentUserId.isNotEmpty,
      followersAndConnections: () => isConnected || isFollowing,
      connections: () => isConnected,
      private: () => isPublisher,
      disabled: () => false,
    );
  }

  // Currently comments are the only reaction type supported.
  String buildCommentHeaderText(AppLocalizations localizations) {
    final ActivitySecurityConfigurationMode commentMode = activity?.securityConfiguration?.commentMode ?? const ActivitySecurityConfigurationMode.disabled();
    final bool isDisabled = commentMode == const ActivitySecurityConfigurationMode.disabled();
    return isDisabled ? 'Comments are disabled for this post' : 'Be the first to leave a comment';
  }

  String buildCommentVisibilityPillText(AppLocalizations localizations) {
    final ActivitySecurityConfigurationMode reactionMode = widget.reactionMode ?? const ActivitySecurityConfigurationMode.disabled();
    return reactionMode.when(
      public: () => localizations.shared_reaction_type_generic_everyone,
      followersAndConnections: () => localizations.shared_reaction_type_generic_followers,
      connections: () => localizations.shared_reaction_type_generic_connections,
      signedIn: () => localizations.shared_reaction_type_generic_signed_in,
      private: () => localizations.shared_reaction_type_generic_me,
      disabled: () => localizations.shared_reaction_type_generic_disabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));

    final Widget loadingIndicator = Container(
      alignment: Alignment.center,
      color: colours.white,
      child: const PositiveLoadingIndicator(),
    );

    final Widget commentPlaceholder = ReactionPlaceholderWidget(headerText: buildCommentHeaderText(localizations));

    return MultiSliver(
      children: <Widget>[
        //? Reactions header
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
                  localizations.shared_comments_heading, //! This will need to be dynamic if we support listing more reaction types.
                  style: typography.styleSubtitleBold.copyWith(color: colours.colorGray3),
                ),
                if (widget.reactionMode != null)
                  Container(
                    decoration: BoxDecoration(
                      color: colours.colorGray1,
                      borderRadius: BorderRadius.circular(kBorderRadiusLarge),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: kPaddingSmall,
                      vertical: kPaddingExtraSmall,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          UniconsLine.comment_alt_notes,
                          size: kIconExtraSmall,
                          color: colours.colorGray6,
                        ),
                        const SizedBox(width: kPaddingExtraSmall),
                        Text(
                          buildCommentVisibilityPillText(localizations),
                          style: typography.styleButtonBold.copyWith(color: colours.colorGray6),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        //? reactions listed
        PagedSliverList.separated(
          shrinkWrapFirstPageIndicators: true,
          pagingController: reactionState.pagingController,
          separatorBuilder: (_, __) => const SizedBox(height: kBorderThicknessMedium),
          builderDelegate: PagedChildBuilderDelegate<Reaction>(
            animateTransitions: true,
            transitionDuration: kAnimationDurationRegular,
            itemBuilder: (_, reaction, index) {
              return PositiveComment(comment: reaction, isFirst: index == 0);
            },
            firstPageErrorIndicatorBuilder: (_) => const SizedBox.shrink(),
            newPageErrorIndicatorBuilder: (_) => const SizedBox.shrink(),
            noMoreItemsIndicatorBuilder: (_) => const SizedBox.shrink(),
            firstPageProgressIndicatorBuilder: (_) => loadingIndicator,
            newPageProgressIndicatorBuilder: (_) => loadingIndicator,
            noItemsFoundIndicatorBuilder: (_) => commentPlaceholder,
          ),
        ),
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
