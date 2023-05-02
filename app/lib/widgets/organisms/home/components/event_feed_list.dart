// Flutter imports:
import 'dart:async';

import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

// Project imports:
import 'package:app/services/third_party.dart';
import '../../../../providers/user/get_stream_controller.dart';

class EventFeedList extends StatefulHookConsumerWidget {
  const EventFeedList({super.key});

  @override
  Widget get child => throw UnimplementedError();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EventFeedListState();
}

class _EventFeedListState extends ConsumerState<EventFeedList> {
  late final StreamSubscription<bool> connectionStateSubscription;

  final EnrichmentFlags _flags = EnrichmentFlags()
    ..withReactionCounts()
    ..withOwnReactions();

  bool _isPaginating = false;

  static const _feedGroup = 'event';

  @override
  void initState() {
    super.initState();
    setupListeners();
  }

  void setupListeners() {
    final log = ref.read(loggerProvider);
    log.i('(FeedList) setupListeners');
    connectionStateSubscription = ref.read(getStreamControllerProvider.notifier).onConnectionStateChanged.stream.listen(onConnectionStateChanged);
  }

  void onConnectionStateChanged(bool event) {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Future<void> _loadMore() async {
    // Ensure we're not already loading more activities.
    if (!_isPaginating) {
      _isPaginating = true;
      context.feedBloc.loadMoreEnrichedActivities(feedGroup: _feedGroup).whenComplete(() {
        _isPaginating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = ref.read(streamFeedClientProvider);

    if (client.currentUser == null) {
      return const Center(child: Text('Connecting to Positive Plus One...'));
    }

    return FeedProvider(
      bloc: FeedBloc(
        client: client,
      ),
      child: Consumer(
        builder: (_, __, ___) => FlatFeedCore(
          feedGroup: _feedGroup,
          userId: client.currentUser!.id,
          loadingBuilder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
          emptyBuilder: (context) => const Center(child: Text('No activities')),
          errorBuilder: (context, error) => Center(
            child: Text(error.toString()),
          ),
          limit: 10,
          flags: _flags,
          feedBuilder: (
            BuildContext context,
            activities,
          ) {
            return RefreshIndicator(
              onRefresh: () {
                return context.feedBloc.refreshPaginatedEnrichedActivities(
                  feedGroup: _feedGroup,
                  flags: _flags,
                );
              },
              child: ListView.separated(
                itemCount: activities.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  bool shouldLoadMore = activities.length - 3 == index;
                  if (shouldLoadMore) {
                    _loadMore();
                  }
                  return const SizedBox.shrink();
                  // return ListActivityItem(
                  //   activity: activities[index],
                  //   feedGroup: _feedGroup,
                  // );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
