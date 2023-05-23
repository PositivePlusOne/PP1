import 'dart:convert';

import 'package:app/extensions/future_extensions.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';

import '../../services/third_party.dart';

class PositiveFeedPaginationBehaviour extends StatefulHookConsumerWidget {
  const PositiveFeedPaginationBehaviour({
    required this.feed,
    required this.slug,
    this.windowSize = 10,
    super.key,
  });

  final String feed;
  final String slug;
  final int windowSize;

  static const String kWidgetKey = 'PositiveFeedPaginationBehaviour';

  @override
  ConsumerState<PositiveFeedPaginationBehaviour> createState() => _PositiveFeedPaginationBehaviourState();
}

class _PositiveFeedPaginationBehaviourState extends ConsumerState<PositiveFeedPaginationBehaviour> {
  late final PagingController<String, dynamic> pagingController;

  String currentPagingKey = '';

  @override
  void initState() {
    super.initState();
    setupListeners();
  }

  @override
  void didUpdateWidget(PositiveFeedPaginationBehaviour oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.feed != widget.feed || oldWidget.slug != widget.slug) {
      disposeListeners();
      setupListeners();
    }
  }

  @override
  void dispose() {
    disposeListeners();
    super.dispose();
  }

  void setupListeners() {
    pagingController = PagingController<String, dynamic>(firstPageKey: currentPagingKey);
    pagingController.addPageRequestListener(requestNextPage);
  }

  void disposeListeners() {
    pagingController.removePageRequestListener(requestNextPage);
    pagingController.dispose();
  }

  Future<void> requestNextPage(String pageKey) => runWithBackoff(() async {
        final Logger logger = ref.read(loggerProvider);
        final FirebaseFunctions functions = ref.read(firebaseFunctionsProvider);

        try {
          final HttpsCallableResult response = await functions.httpsCallable('stream-getFeedWindow').call({
            'feed': widget.feed,
            'options': {
              'slug': widget.slug,
              'windowLastActivityId': pageKey,
            },
          });

          final Map<String, dynamic> data = json.decodeSafe(response.data);

          logger.d('requestNextTimelinePage() - data: $data');
          final String next = data['next'];
          final List<dynamic> activities = data['activities'].map((dynamic activity) => activity as Map<String, dynamic>).toList();
          final bool hasNext = next.isNotEmpty && next != pageKey;

          logger.d('requestNextTimelinePage() - hasNext: $hasNext');
          final newActivities = activities.map((e) => json.encode(e)).toList();

          if (!hasNext) {
            pagingController.appendLastPage(newActivities);
          } else {
            pagingController.appendPage(newActivities, next);
          }
        } catch (ex) {
          logger.e('requestNextTimelinePage() - ex: $ex');
          pagingController.error = ex;
        }
      }, key: PositiveFeedPaginationBehaviour.kWidgetKey);

  @override
  Widget build(BuildContext context) {
    return PagedSliverList.separated(
      pagingController: pagingController,
      separatorBuilder: (context, index) => const Divider(),
      builderDelegate: PagedChildBuilderDelegate<dynamic>(
        itemBuilder: (context, item, index) => Card(
          child: Text(item.toString()),
        ),
      ),
    );
  }
}
