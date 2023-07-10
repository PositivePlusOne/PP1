// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:app/extensions/stream_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/events/connections/channels_updated_event.dart';
import 'package:app/providers/events/connections/relationship_updated_event.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logger/logger.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../services/third_party.dart';

void useChannelHook(List<Channel> channels) {
  return use(ChannelHook(channels: channels));
}

class ChannelHook extends Hook<void> {
  const ChannelHook({required this.channels});

  final List<Channel> channels;

  @override
  HookState<void, Hook<void>> createState() {
    return ChannelHookState();
  }
}

class ChannelHookState extends HookState<void, ChannelHook> {
  late final StreamSubscription<RelationshipUpdatedEvent> _relationshipUpdatedSubscription;
  late final StreamSubscription<ChannelsUpdatedEvent> _channelsUpdatedSubscription;

  @override
  void initHook() {
    super.initHook();
    setupListeners();
  }

  @override
  void dispose() {
    removeListeners();
    super.dispose();
  }

  void setupListeners() {
    final EventBus eventBus = providerContainer.read(eventBusProvider);
    _relationshipUpdatedSubscription = eventBus.on<RelationshipUpdatedEvent>().listen(onRelationshipUpdated);
    _channelsUpdatedSubscription = eventBus.on<ChannelsUpdatedEvent>().listen(onChannelsUpdated);
  }

  void removeListeners() {
    _relationshipUpdatedSubscription.cancel();
    _channelsUpdatedSubscription.cancel();
  }

  @override
  void build(BuildContext context) {}

  void onChannelsUpdated(ChannelsUpdatedEvent event) {
    final logger = providerContainer.read(loggerProvider);
    logger.d('[ChannelHook] onChannelsUpdated]');

    final List<String> members = event.channels.membersIds;
    checkMembersForUpdates(members);
  }

  void onRelationshipUpdated(RelationshipUpdatedEvent event) {
    final logger = providerContainer.read(loggerProvider);
    logger.d('[ChannelHook] onRelationshipUpdated]');

    final List<String> members = (event.relationship?.members ?? []).map((e) => e.memberId).nonNulls.toList();
    checkMembersForUpdates(members);
  }

  void checkMembersForUpdates(List<String> members) {
    final logger = providerContainer.read(loggerProvider);
    logger.d('[ChannelHook] checkMembersForUpdates]');

    final Set<String> channelMembers = hook.channels.membersIds.toSet();
    if (channelMembers.isEmpty || members.isEmpty) {
      return;
    }

    // Check if any matching set members are in the affected members set
    final bool isAffected = channelMembers.any((String member) => members.contains(member));
    if (isAffected) {
      setState(() {});
    }
  }
}
