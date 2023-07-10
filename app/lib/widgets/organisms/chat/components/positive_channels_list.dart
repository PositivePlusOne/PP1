// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/chat/channel_extra_data.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/stream_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/providers/events/connections/channels_updated_event.dart';
import 'package:app/providers/events/connections/relationship_updated_event.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/user/get_stream_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/organisms/chat/components/positive_channel_list_tile.dart';

class PositiveChannelsList extends StatefulHookConsumerWidget {
  const PositiveChannelsList({
    required this.channels,
    this.hideMessagelessConnections = false,
    this.hideSelfArchived = false,
    this.hideClosed = false,
    this.hideGroupChannels = false,
    this.channelSearchString = '',
    Key? key,
  }) : super(key: key);

  final List<Channel> channels;
  final bool hideMessagelessConnections;
  final bool hideSelfArchived;
  final bool hideClosed;
  final bool hideGroupChannels;

  final String channelSearchString;

  @override
  ConsumerState<PositiveChannelsList> createState() => _PositiveChannelsListState();
}

class _PositiveChannelsListState extends ConsumerState<PositiveChannelsList> {
  late final StreamSubscription<ChannelsUpdatedEvent> channelsUpdatedSubscription;
  late final StreamSubscription<RelationshipUpdatedEvent> relationshipUpdatedSubscription;

  @override
  void initState() {
    super.initState();
    setupListeners();
  }

  Future<void> setupListeners() async {
    final EventBus eventBus = ref.read(eventBusProvider);
    channelsUpdatedSubscription = eventBus.on<ChannelsUpdatedEvent>().listen((_) => setStateIfMounted());
    relationshipUpdatedSubscription = eventBus.on<RelationshipUpdatedEvent>().listen((_) => setStateIfMounted());
  }

  @override
  void dispose() {
    channelsUpdatedSubscription.cancel();
    relationshipUpdatedSubscription.cancel();
    super.dispose();
  }

  void onChannelsUpdated(ChannelsUpdatedEvent event) {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  void onRelationshipUpdated(RelationshipUpdatedEvent event) {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
    final GetStreamController getStreamController = ref.read(getStreamControllerProvider.notifier);
    final GetStreamControllerState getStreamControllerState = ref.read(getStreamControllerProvider);
    final String? currentUserId = getStreamController.currentUserId;

    if (currentUserId == null) {
      return const SliverToBoxAdapter();
    }

    List<Channel> allChannels = getStreamControllerState.channels.withValidRelationships.toList();
    if (widget.hideMessagelessConnections) {
      allChannels = allChannels.onlyMessages;
    }

    if (widget.hideSelfArchived) {
      allChannels = allChannels.removeSelfArchived;
    }

    if (widget.hideClosed) {
      allChannels = allChannels.removeClosed;
    }

    if (widget.hideGroupChannels) {
      allChannels = allChannels.onlyOneOnOneMessages;
    }

    if (widget.channelSearchString.isNotEmpty) {
      final List<Channel> matchedChannels = [];
      for (int i = allChannels.length - 1; i >= 0; i--) {
        final Channel channel = allChannels[i];
        final List<String> members = (channel.state?.members ?? []).map((member) => member.userId).nonNulls.toList();
        bool hasMatch = false;
        for (final String member in members) {
          final Profile? profile = cacheController.getFromCache(member);
          if (profile == null) {
            continue;
          }

          if (profile.matchesStringSearch(widget.channelSearchString)) {
            hasMatch = true;
            break;
          }
        }

        if (hasMatch) {
          matchedChannels.add(channel);
        }
      }

      allChannels.clear();
      allChannels.addAll(matchedChannels);
    }

    final int countWithModForSeparator = allChannels.length + (allChannels.length % 2);
    final int countWithSeparator = countWithModForSeparator + 1;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index % 2 == 1) {
            return const SizedBox(height: kPaddingMedium);
          }

          final int channelIndex = index ~/ 2;
          final Channel? channel = channelIndex < allChannels.length ? allChannels[channelIndex] : null;
          if (channel == null) {
            return const SizedBox.shrink();
          }

          return PositiveChannelListTile(
            channel: channel,
            isSelected: widget.channels.contains(channel),
          );
        },
        childCount: countWithSeparator,
      ),
    );
  }
}
