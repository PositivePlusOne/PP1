// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

// Project imports:
import 'package:app/services/third_party.dart';
import '../../../../providers/user/get_stream_controller.dart';

class FeedListBuilder extends StatefulHookConsumerWidget {
  const FeedListBuilder({
    required this.feed,
    required this.enrichmentFlags,
    super.key,
  });

  final EnrichmentFlags enrichmentFlags;
  final String feed;

  static Widget wrapWithClient({
    required String feed,
    required EnrichmentFlags enrichmentFlags,
    required WidgetRef ref,
  }) {
    return FeedProvider(
      bloc: FeedBloc(
        client: ref.read(streamFeedClientProvider),
      ),
      child: FeedListBuilder(
        feed: feed,
        enrichmentFlags: enrichmentFlags,
      ),
    );
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedListBuilderState();
}

class _FeedListBuilderState extends ConsumerState<FeedListBuilder> {
  late final StreamSubscription<bool> connectionStateSubscription;

  bool _isPaginating = false;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    setupListeners();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadNextPage();
    });
  }

  void setupListeners() {
    final log = ref.read(loggerProvider);
    log.i('(FeedList) setupListeners');

    connectionStateSubscription = ref.read(getStreamControllerProvider.notifier).onConnectionStateChanged.stream.listen(onConnectionStateChanged);
    _isConnected = ref.read(streamChatClientProvider).wsConnectionStatus == ConnectionStatus.connected;
  }

  void onConnectionStateChanged(bool isConnected) {
    if (!mounted) {
      return;
    }

    _isConnected = isConnected;
    loadNextPage();
    setState(() {});
  }

  Future<void> loadNextPage() async {
    if (_isPaginating || !mounted || !_isConnected) {
      return;
    }

    final log = ref.read(loggerProvider);
    _isPaginating = true;

    // ignore: invalid_use_of_visible_for_testing_member
    final bool hasLoadedInitialWindow = context.feedBloc.activitiesManager.paginatedParams[widget.feed] != null;
    if (!hasLoadedInitialWindow) {
      log.i('Loading initial window');
      await context.feedBloc.refreshPaginatedEnrichedActivities(feedGroup: widget.feed);
      return;
    }

    try {
      await context.feedBloc.loadMoreEnrichedActivities(feedGroup: widget.feed);
      log.i('Loaded more activities');
    } catch (ex) {
      log.i('Error loading more activities: $ex');
    } finally {
      _isPaginating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = ref.read(streamFeedClientProvider);

    if (!_isConnected) {
      return const Center(child: Text('Connecting to Positive Plus One...'));
    }

    return FlatFeedCore(
      feedGroup: widget.feed,
      userId: client.currentUser!.id,
      loadingBuilder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
      emptyBuilder: (context) => const Center(child: Text('No activities')),
      errorBuilder: (context, error) => Center(
        child: Text(error.toString()),
      ),
      limit: 10,
      flags: widget.enrichmentFlags,
      feedBuilder: (BuildContext context, activities) {
        return ListView.separated(
          itemCount: activities.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final activity = activities[index];
            return ListTile(
              title: Text(activity.id ?? 'No ID'),
              subtitle: Text(activity.actor?.id ?? 'No Actor ID'),
            );
            // return ListActivityItem(
            //   activity: activities[index],
            //   feedGroup: _feedGroup,
            // );
          },
        );
      },
    );
  }
}
