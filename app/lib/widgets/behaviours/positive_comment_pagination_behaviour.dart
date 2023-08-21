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
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/common/endpoint_response.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/events/content/activities.dart';
import 'package:app/providers/events/content/comments.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/comment_api_service.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/molecules/content/positive_comment.dart';
import 'package:app/widgets/state/positive_comments_state.dart';
import '../../dtos/database/activities/comments.dart';
import '../../services/third_party.dart';
import '../atoms/indicators/positive_post_loading_indicator.dart';

class PositiveCommentPaginationBehaviour extends StatefulHookConsumerWidget {
  const PositiveCommentPaginationBehaviour({
    required this.activityId,
    required this.feed,
    required this.refreshController,
    this.commentMode,
    this.onPageLoaded,
    this.windowSize = 10,
    super.key,
  });

  final String activityId;
  final TargetFeed feed;

  final ActivitySecurityConfigurationMode? commentMode;

  final int windowSize;
  final RefreshController refreshController;

  final Function(Map<String, dynamic>)? onPageLoaded;

  static const String kWidgetKey = 'PositiveCommentPaginationBehaviour';

  @override
  ConsumerState<PositiveCommentPaginationBehaviour> createState() => _PositiveCommentPaginationBehaviourState();
}

class _PositiveCommentPaginationBehaviourState extends ConsumerState<PositiveCommentPaginationBehaviour> {
  late PositiveCommentsState commentState;

  StreamSubscription<CommentCreatedEvent>? _onCommentCreatedSubscription;
  StreamSubscription<CommentUpdatedEvent>? _onCommentUpdatedSubscription;
  StreamSubscription<CommentDeletedEvent>? _onCommentDeletedSubscription;

  String get expectedCacheKey => 'comments:${widget.activityId}';

  @override
  void initState() {
    super.initState();
    setupListeners();
    setupCommentsState();
  }

  @override
  void dispose() {
    disposeListeners();
    disposeCommentsState();
    super.dispose();
  }

  @override
  void didUpdateWidget(PositiveCommentPaginationBehaviour oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activityId != widget.activityId) {
      disposeCommentsState();
      setupCommentsState();
    }
  }

  Future<void> setupListeners() async {
    final EventBus eventBus = providerContainer.read(eventBusProvider);

    await _onCommentCreatedSubscription?.cancel();
    await _onCommentUpdatedSubscription?.cancel();
    await _onCommentDeletedSubscription?.cancel();

    _onCommentCreatedSubscription = eventBus.on<CommentCreatedEvent>().listen(onCommentCreated);
    _onCommentUpdatedSubscription = eventBus.on<CommentUpdatedEvent>().listen(onCommentUpdated);
    _onCommentDeletedSubscription = eventBus.on<CommentDeletedEvent>().listen(onCommentDeleted);
  }

  Future<void> disposeListeners() async {
    await _onCommentCreatedSubscription?.cancel();
    await _onCommentUpdatedSubscription?.cancel();
    await _onCommentDeletedSubscription?.cancel();
  }

  void disposeCommentsState() {
    commentState.pagingController.removePageRequestListener(requestNextPage);
  }

  void setupCommentsState() {
    final Logger logger = providerContainer.read(loggerProvider);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

    logger.d('setupCommentsState() - Loading state for ${widget.activityId}');
    final PositiveCommentsState? cachedFeedState = cacheController.getFromCache(expectedCacheKey);
    if (cachedFeedState != null) {
      logger.d('setupCommentsState() - Found cached state for ${widget.activityId}');
      commentState = cachedFeedState;
      commentState.pagingController.addPageRequestListener(requestNextPage);
      return;
    }

    logger.d('setupCommentsState() - No cached state for ${widget.activityId}. Creating new state.');
    final PagingController<String, Comment> pagingController = PagingController<String, Comment>(firstPageKey: '');
    pagingController.addPageRequestListener(requestNextPage);

    commentState = PositiveCommentsState(
      activityId: widget.activityId,
      pagingController: pagingController,
      currentPaginationKey: '',
    );
  }

  void saveCommentsState() {
    final Logger logger = providerContainer.read(loggerProvider);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

    logger.d('saveState() - Saving comments state for ${widget.activityId}');
    cacheController.addToCache(key: expectedCacheKey, value: commentState);
  }

  Future<void> requestNextPage(String pageKey) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final CommentApiService commentApiService = await providerContainer.read(commentApiServiceProvider.future);

    try {
      final EndpointResponse endpointResponse = await commentApiService.listCommentsForActivity(
        activityId: widget.activityId,
        feedID: "user",
        slugID: widget.feed.slug,
        cursor: commentState.currentPaginationKey,
      );

      final Map<String, dynamic> data = json.decodeSafe(endpointResponse.data);
      String next = data.containsKey('cursor') ? data['cursor'].toString() : '';

      // Check for weird backend loops (extra safety)
      if (next == commentState.currentPaginationKey) {
        next = '';
      }

      appendCommentPage(data, next);
      widget.onPageLoaded?.call(data);
      widget.refreshController.refreshCompleted();
    } catch (ex) {
      logger.e('requestNextTimelinePage() - ex: $ex');
      commentState.pagingController.error = ex;
      widget.refreshController.refreshFailed();
    } finally {
      saveCommentsState();
    }
  }

  void appendCommentPage(Map<String, dynamic> data, String nextPageKey) {
    final Logger logger = providerContainer.read(loggerProvider);
    final bool hasNext = nextPageKey.isNotEmpty && nextPageKey != commentState.currentPaginationKey;

    commentState.currentPaginationKey = nextPageKey;
    logger.i('requestNextTimelinePage() - hasNext: $hasNext - nextPageKey: $nextPageKey - currentPaginationKey: ${commentState.currentPaginationKey}');

    final List<Comment> newComments = [];
    final List<dynamic> comments = (data.containsKey('comments') ? data['comments'] : []).map((dynamic activity) => json.decodeSafe(activity)).toList();

    for (final dynamic activity in comments) {
      try {
        logger.d('requestNextTimelinePage() - parsing activity: $activity');
        final Comment newComment = Comment.fromJson(activity);
        final String commentId = newComment.flMeta?.id ?? '';

        if (commentId.isEmpty) {
          logger.e('requestNextTimelinePage() - Failed to parse activity: $activity');
          continue;
        }

        newComments.add(newComment);
      } catch (ex) {
        logger.e('requestNextTimelinePage() - Failed to parse activity: $activity - ex: $ex');
      }
    }

    logger.d('requestNextTimelinePage() - newComments: $newComments');

    if (!hasNext && mounted) {
      commentState.pagingController.appendLastPage(newComments);
    } else if (mounted) {
      commentState.pagingController.appendPage(newComments, nextPageKey);
    }

    saveCommentsState();
  }

  void onCommentCreated(CommentCreatedEvent event) {
    final Logger logger = providerContainer.read(loggerProvider);
    final Comment comment = event.comment;
    if (event.activityId == widget.activityId) {
      commentState.pagingController.itemList?.insert(0, comment);
      commentState.pagingController.itemList = commentState.pagingController.itemList;

      logger.d('onCommentCreated() - Added comment to state: ${widget.activityId} - comment: $comment');
      setStateIfMounted();
    }
  }

  void onCommentUpdated(CommentUpdatedEvent event) {
    final Logger logger = providerContainer.read(loggerProvider);
    final Comment comment = event.comment;
    if (event.activityId == widget.activityId) {
      final int index = commentState.pagingController.itemList?.indexWhere((element) => element.flMeta?.id == comment.flMeta?.id) ?? -1;
      if (index >= 0) {
        commentState.pagingController.itemList?[index] = comment;
        commentState.pagingController.itemList = commentState.pagingController.itemList;

        logger.d('onCommentUpdated() - Updated comment in state: ${widget.activityId} - comment: $comment');
        setStateIfMounted();
      }
    }
  }

  void onCommentDeleted(CommentDeletedEvent event) {
    final Logger logger = providerContainer.read(loggerProvider);
    if (event.activityId == widget.activityId) {
      final int index = commentState.pagingController.itemList?.indexWhere((element) => element.flMeta?.id == event.activityId) ?? -1;
      if (index >= 0) {
        commentState.pagingController.itemList?.removeAt(index);
        commentState.pagingController.itemList = commentState.pagingController.itemList;

        logger.d('onCommentDeleted() - Deleted comment in state');
        setStateIfMounted();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final DesignColorsModel colours = ref.watch(designControllerProvider.select((value) => value.colors));
    String commentShareType = "";

    if (widget.commentMode != null) {
      widget.commentMode!.when(
        public: () {
          commentShareType = localisations.shared_comment_type_generic_everyone;
        },
        followersAndConnections: () {
          commentShareType = localisations.shared_comment_type_generic_followers;
        },
        connections: () {
          commentShareType = localisations.shared_comment_type_generic_connections;
        },
        private: () {
          commentShareType = localisations.shared_comment_type_generic_me;
        },
      );
    }

    const Widget loadingIndicator = PositivePostLoadingIndicator();

    return MultiSliver(
      children: [
        //? Comments header
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(kBorderRadiusLarge)),
            ),
            padding: const EdgeInsets.all(kPaddingMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localisations.shared_comments,
                  style: typography.styleSubtitleBold.copyWith(color: colours.colorGray3),
                ),
                if (widget.commentMode != null)
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
                          commentShareType,
                          style: typography.styleButtonBold.copyWith(color: colours.colorGray6),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
        if (commentState.pagingController.itemList == null || commentState.pagingController.itemList!.isEmpty)
          Container(
            decoration: BoxDecoration(color: colours.white),
            child: Padding(
              padding: const EdgeInsets.all(kPaddingSmallMedium),
              child: Text(
                "Be the first to leave a comment",
                textAlign: TextAlign.left,
                style: typography.styleHeroMedium,
              ),
            ),
          ),
        //? comments listed
        if (commentState.pagingController.itemList != null || commentState.pagingController.itemList!.isNotEmpty)
          PagedSliverList.separated(
            shrinkWrapFirstPageIndicators: true,
            pagingController: commentState.pagingController,
            separatorBuilder: (_, __) => const SizedBox(height: kBorderThicknessMedium),
            builderDelegate: PagedChildBuilderDelegate<Comment>(
              animateTransitions: true,
              transitionDuration: kAnimationDurationRegular,
              itemBuilder: (_, comment, index) {
                return PositiveComment(comment: comment, isFirst: index == 0);
              },
              firstPageProgressIndicatorBuilder: (context) => loadingIndicator,
              newPageProgressIndicatorBuilder: (context) => loadingIndicator,
            ),
          ),
        //? Load additional comments?
        const SizedBox(
          height: kBorderThicknessMedium,
        ),
        Container(
          decoration: BoxDecoration(
            color: colours.white,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(kBorderRadiusLarge),
            ),
          ),
          height: kCommentFooter,
          alignment: Alignment.center,
          child: const PositiveLoadingIndicator(
            circleRadius: 5,
            width: 40,
          ),
        ),
      ],
    );
  }
}
