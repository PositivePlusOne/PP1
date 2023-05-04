// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/molecules/content/activity_widget.dart';
import '../../../../providers/events/activity_added_event.dart';
import '../../../../providers/user/get_stream_controller.dart';
import '../../../behaviours/positive_activity_fetch_behaviour.dart';
import '../../../molecules/content/activity_placeholder_widget.dart';

class FeedListBuilder extends StatefulHookConsumerWidget {
  const FeedListBuilder({
    required this.feed,
    required this.enrichmentFlags,
    this.shrinkWrap = false,
    super.key,
  });

  final EnrichmentFlags enrichmentFlags;
  final String feed;

  final bool shrinkWrap;

  static Widget wrapWithClient({
    required String feed,
    required EnrichmentFlags enrichmentFlags,
    required WidgetRef ref,
    bool shrinkWrap = false,
    Key? key,
  }) {
    return FeedProvider(
      bloc: FeedBloc(
        client: ref.read(streamFeedClientProvider),
      ),
      child: FeedListBuilder(
        feed: feed,
        enrichmentFlags: enrichmentFlags,
        shrinkWrap: shrinkWrap,
        key: key,
      ),
    );
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => FeedListBuilderState();
}

class FeedListBuilderState extends ConsumerState<FeedListBuilder> {
  late final StreamSubscription<bool> connectionStateSubscription;
  late final StreamSubscription<ActivityAddedEvent> activityAddedSubscription;

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

    //* Add listeners for new posts being added to this feed
    final EventBus eventBus = ref.read(eventBusProvider);
    activityAddedSubscription = eventBus.on<ActivityAddedEvent>().listen(onActivityAdded);
  }

  void onConnectionStateChanged(bool isConnected) {
    if (!mounted) {
      return;
    }

    _isConnected = isConnected;
    loadNextPage();
    setState(() {});
  }

  // TODO(ryan): Test if this is needed, it may be bidirectional
  void onActivityAdded(ActivityAddedEvent event) {
    if (!mounted) {
      return;
    }

    final log = ref.read(loggerProvider);
    final feedBloc = context.feedBloc;

    // ignore: invalid_use_of_visible_for_testing_member
    final activitiesManager = feedBloc.activitiesManager;
    activitiesManager.add(widget.feed, [event.activity]);
    log.i('Activity added: ${event.activity}');

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
        child: Text(error.toString()), // TODO(ryan): Something unknown user
      ),
      limit: 10,
      flags: widget.enrichmentFlags,
      feedBuilder: (BuildContext context, activities) {
        return ListView.separated(
          itemCount: activities.length,
          shrinkWrap: widget.shrinkWrap,
          physics: widget.shrinkWrap ? const NeverScrollableScrollPhysics() : null,
          padding: const EdgeInsets.symmetric(horizontal: kPaddingExtraSmall),
          separatorBuilder: (context, index) => const SizedBox(height: kPaddingMedium),
          itemBuilder: (context, index) {
            final rawActivity = activities[index];
            return PositiveActivityFetchBehaviour(
              activity: rawActivity,
              errorBuilder: (_) => const SizedBox(),
              placeholderBuilder: (_) => const ActivityPlaceholderWidget(),
              builder: (context, activity, {publisher}) => ActivityWidget(
                activity: activity,
                publisher: publisher,
              ),
            );
          },
        );
      },
    );
  }
}
