// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/third_party.dart';
import '../../../../providers/user/get_stream_controller.dart';
import '../../../behaviours/positive_activity_fetch_behaviour.dart';

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
    final colors = ref.read(designControllerProvider.select((value) => value.colors));

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
          padding: const EdgeInsets.symmetric(horizontal: kPaddingExtraSmall),
          separatorBuilder: (context, index) => const SizedBox(height: kPaddingMedium),
          itemBuilder: (context, index) {
            final rawActivity = activities[index];
            return PositiveActivityFetchBehaviour(
              activityId: rawActivity.object ?? '',
              errorBuilder: (_) => const SizedBox(),
              placeholderBuilder: (_) => const ActivityPlaceholderWidget(),
              builder: (context, activity) => ListTile(
                title: Text(rawActivity.id.toString()),
                subtitle: Text(activity.toString()),
              ),
            );
          },
        );
      },
    );
  }
}

class ActivityPlaceholderWidget extends ConsumerWidget {
  const ActivityPlaceholderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            const SizedBox(width: kPaddingSmallMedium),
            Shimmer.fromColors(
              baseColor: colors.colorGray3,
              highlightColor: colors.colorGray1,
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: kPaddingSmall),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Shimmer.fromColors(
                  baseColor: colors.colorGray3,
                  highlightColor: colors.colorGray1,
                  child: Container(
                    height: 20.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: kPaddingExtraSmall),
                Shimmer.fromColors(
                  baseColor: colors.colorGray3,
                  highlightColor: colors.colorGray1,
                  child: Container(
                    height: 10.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: kPaddingSmall),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPaddingSmallMedium),
          child: Shimmer.fromColors(
            baseColor: colors.colorGray3,
            highlightColor: colors.colorGray1,
            child: Container(
              height: 10.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: kPaddingSmall),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPaddingSmallMedium),
          child: Shimmer.fromColors(
            baseColor: colors.colorGray3,
            highlightColor: colors.colorGray1,
            child: Container(
              height: 10.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
