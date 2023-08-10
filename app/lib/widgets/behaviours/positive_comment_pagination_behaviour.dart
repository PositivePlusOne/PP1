// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/dtos/database/common/endpoint_response.dart';
import 'package:app/main.dart';
import 'package:app/services/comment_api_service.dart';
import '../../dtos/database/activities/comments.dart';
import '../../dtos/system/design_colors_model.dart';
import '../../dtos/system/design_typography_model.dart';
import '../../providers/system/design_controller.dart';
import '../../services/third_party.dart';

class CommentsPaginationBehaviour extends StatefulHookConsumerWidget {
  const CommentsPaginationBehaviour({
    this.windowSize = 10,
    this.activityId = '',
    super.key,
  });

  final int windowSize;
  final String activityId;

  static const String kWidgetKey = 'CommentsPaginationBehaviour';

  @override
  ConsumerState<CommentsPaginationBehaviour> createState() => _CommentsPaginationBehaviourState();
}

class _CommentsPaginationBehaviourState extends ConsumerState<CommentsPaginationBehaviour> {
  final PagingController<String, Comment> pagingController = PagingController(firstPageKey: "");

  @override
  void initState() {
    super.initState();
    setupListeners();
  }

  @override
  void dispose() {
    disposeListeners();
    super.dispose();
  }

  Future<void> setupListeners() async {
    pagingController.addPageRequestListener(onRequestPage);
  }

  Future<void> disposeListeners() async {
    pagingController.removePageRequestListener(onRequestPage);
  }

  Future<void> onRequestPage(String pageKey) async {
    final Logger logger = ref.read(loggerProvider);

    if (widget.activityId.isEmpty) {
      pagingController.appendLastPage(<Comment>[]);
      return;
    }

    try {
      final CommentApiService apiService = await providerContainer.read(commentApiServiceProvider.future);
      final EndpointResponse response = await apiService.listCommentsForActivity(
        activityId: widget.activityId,
        cursor: pageKey,
      );

      final List<Comment> comments = (response.data['comments'] as List<dynamic>).map((dynamic e) => Comment.fromJson(e as Map<String, dynamic>)).toList();
      if (comments.isEmpty) {
        pagingController.appendLastPage(comments);
        return;
      }

      pagingController.appendPage(comments, response.cursor);
    } catch (e) {
      logger.e(e.toString());
      pagingController.error = e;
    }
  }

  @override
  Widget build(BuildContext context) {
    const Widget loadingIndicator = CircularProgressIndicator();
    return PagedSliverList.separated(
      pagingController: pagingController,
      separatorBuilder: (context, index) => const SizedBox(height: 10.0),
      builderDelegate: PagedChildBuilderDelegate<Comment>(
        animateTransitions: true,
        itemBuilder: buildItem,
        firstPageProgressIndicatorBuilder: (context) => loadingIndicator,
        newPageProgressIndicatorBuilder: (context) => loadingIndicator,
      ),
    );
  }

  Widget buildItem(BuildContext context, Comment item, int index) {
    final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = providerContainer.read(designControllerProvider.select((value) => value.typography));

    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: colors.white,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(item.senderId ?? '', style: typography.styleHeroSmall.copyWith(color: colors.black)),
                Text(item.content ?? '', style: typography.styleSubtitle.copyWith(color: colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
