// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/src/matcher/route_match.dart';
import 'package:collection/collection.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import 'package:app/dtos/database/chat/channel_extra_data.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/events/connections/channels_updated_event.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import 'package:app/providers/user/get_stream_controller.dart';
import 'package:app/services/api.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import 'package:app/widgets/organisms/chat/dialogs/add_to_conversation_dialog.dart';
import 'package:app/widgets/organisms/chat/dialogs/chat_actions_dialog.dart';
import '../../../../gen/app_router.dart';
import '../../../../services/third_party.dart';

part 'chat_view_model.freezed.dart';
part 'chat_view_model.g.dart';

@freezed
class ChatViewModelState with _$ChatViewModelState {
  const factory ChatViewModelState({
    // Chat List Properties
    DateTime? lastRelationshipsUpdated,
    DateTime? lastChannelsUpdated,
    @Default('') String searchQuery,

    // Current Conversation Properties
    DateTime? currentChannelLastUpdated,
    Channel? currentChannel,
    ChannelExtraData? currentChannelExtraData,
    @Default(<String>[]) List<String> selectedMembers,
    @Default(false) bool isBusy,
  }) = _ChatViewModelState;

  factory ChatViewModelState.initialState() => const ChatViewModelState();
}

@Riverpod(keepAlive: true)
class ChatViewModel extends _$ChatViewModel with LifecycleMixin {
  StreamSubscription<CacheKeyUpdatedEvent>? _cacheUpdatedSubscription;
  StreamSubscription<ChannelsUpdatedEvent>? _channelsUpdatedSubscription;

  @override
  ChatViewModelState build() {
    return ChatViewModelState.initialState();
  }

  Future<bool> onWillPopScope() async {
    onCurrentChannelPopped();

    final AppRouter router = ref.read(appRouterProvider);
    final logger = ref.read(loggerProvider);

    final RouteMatch route = router.current.route;
    if (route.name == ChatRoute.name) {
      logger.i("Pop chat page, pop Home page");
      return true;
    }

    logger.i("Pop chat page, push Home page");
    await router.replaceAll([const HomeRoute()]);

    return false;
  }

  @override
  void onFirstRender() {
    super.onFirstRender();

    setupListeners();
    resetPageData();
  }

  void notifyChannelUpdate(Channel channel) {
    final logger = ref.read(loggerProvider);
    if (state.currentChannel?.id != channel.id) {
      return;
    }

    logger.i('ChatViewModel.notifyChannelUpdate()');
    state = state.copyWith(currentChannel: channel);
  }

  void setSearchQuery(String query) {
    final logger = ref.read(loggerProvider);
    logger.i('ChatViewModel.setChatMembersSearchQuery()');

    state = state.copyWith(searchQuery: query);
  }

  void resetPageData() {
    final logger = ref.read(loggerProvider);
    logger.i('ChatViewModel.resetPageData()');

    state = state.copyWith(
      selectedMembers: [],
      searchQuery: '',
    );
  }

  void resetState() {
    final logger = ref.read(loggerProvider);
    logger.i('ChatViewModel.resetState()');
    state = ChatViewModelState.initialState();
  }

  List<Relationship> getCachedSourceBlockedMemberRelationships(List<Relationship> relationships) {
    final logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final String currentProfileId = profileController.currentProfileId ?? '';

    logger.i('ChatViewModel.getCachedBlockedMemberRelationships()');
    final List<Relationship> blockedRelationships = [];

    // Get members from the current channel
    if (currentProfileId.isNotEmpty) {
      for (final Relationship relationship in relationships) {
        final relationshipStates = relationship.relationshipStatesForEntity(currentProfileId);
        if (relationshipStates.contains(RelationshipState.sourceBlocked)) {
          blockedRelationships.add(relationship);
        }
      }
    }

    return blockedRelationships;
  }

  List<Relationship> getCachedTargetBlockedMemberRelationships(List<Relationship> relationships) {
    final logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final String currentProfileId = profileController.currentProfileId ?? '';

    logger.i('ChatViewModel.getCachedBlockedMemberRelationships()');
    final List<Relationship> blockedRelationships = [];

    // Get members from the current channel
    if (currentProfileId.isNotEmpty) {
      for (final Relationship relationship in relationships) {
        final relationshipStates = relationship.relationshipStatesForEntity(currentProfileId);
        if (relationshipStates.contains(RelationshipState.targetBlocked)) {
          blockedRelationships.add(relationship);
        }
      }
    }

    return blockedRelationships;
  }

  List<Relationship> getCachedMemberRelationships() {
    final CacheController cacheController = ref.read(cacheControllerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final String currentProfileId = profileController.currentProfileId ?? '';

    final List<Relationship> relationships = [];

    // Get members from the current channel
    if (currentProfileId.isNotEmpty && state.currentChannel?.state?.members != null) {
      for (final Member member in state.currentChannel!.state!.members) {
        if ((member.user?.id.isEmpty ?? true) || member.user?.id == currentProfileId) {
          continue;
        }

        final String relationshipId = [currentProfileId, member.user!.id].asGUID;
        final Relationship? relationship = cacheController.get(relationshipId);
        if (relationship != null) {
          relationships.add(relationship);
        }
      }
    }

    return relationships;
  }

  Future<void> setupListeners() async {
    final logger = ref.read(loggerProvider);
    final EventBus eventBus = ref.read(eventBusProvider);
    logger.i('ChatViewModel.setupListeners()');

    if (_cacheUpdatedSubscription != null || _channelsUpdatedSubscription != null) {
      logger.w('ChatViewModel.setupListeners(), listeners already setup');
      return;
    }

    await _cacheUpdatedSubscription?.cancel();
    _cacheUpdatedSubscription = eventBus.on<CacheKeyUpdatedEvent>().listen(onCacheKeyUpdatedEvent);

    await _channelsUpdatedSubscription?.cancel();
    _channelsUpdatedSubscription = eventBus.on<ChannelsUpdatedEvent>().listen(onChannelsUpdated);
  }

  void onCacheKeyUpdatedEvent(CacheKeyUpdatedEvent event) {
    final logger = ref.read(loggerProvider);

    if (event.value is! Relationship) {
      return;
    }

    logger.i('ChatViewModel.onRelationshipsUpdated()');
    state = state.copyWith(lastRelationshipsUpdated: DateTime.now());
  }

  void onChannelsUpdated(ChannelsUpdatedEvent? event) {
    final logger = ref.read(loggerProvider);

    logger.i('ChatViewModel.onChannelsUpdated()');
    state = state.copyWith(lastChannelsUpdated: DateTime.now());
  }

  Future<void> onChatChannelSelected(Channel channel) async {
    final log = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final ChannelExtraData extraData = ChannelExtraData.fromJson(channel.extraData);
    final GetStreamController getStreamController = ref.read(getStreamControllerProvider.notifier);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);

    try {
      await getStreamController.forceChannelUpdate(channel);
    } catch (ex) {
      log.e('ChatController: onChatChannelSelected, error: $ex');
      return;
    }

    log.d('ChatController: onChatChannelSelected');
    state = state.copyWith(currentChannel: channel, currentChannelExtraData: extraData);

    log.d('Marking channel as read');
    unawaited(channel.markRead());

    await analyticsController.trackEvent(AnalyticEvents.chatViewed, properties: {
      'channel_id': channel.id,
      'channel_type': channel.type,
    });

    final bool hasConversationsRoute = appRouter.stack.any((route) => route.name == ChatConversationsRoute.name);
    await appRouter.pushAll([
      if (!hasConversationsRoute) ...[
        const ChatConversationsRoute(),
      ],
      const ChatRoute(),
    ]);
  }

  Future<void> onAddMembersToChannel(BuildContext context, List<String> memberIds) async {
    final logger = ref.read(loggerProvider);
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final GetStreamController getStreamController = ref.read(getStreamControllerProvider.notifier);
    final AppRouter appRouter = ref.read(appRouterProvider);
    logger.i('ChatViewModel.onAddMembersToChannel()');

    if (state.currentChannel?.id == null || memberIds.isEmpty) {
      logger.e('ChatViewModel.onAddMembersToChannel(), currentChannel.id is null or memberIds is empty');
      return;
    }

    String serverMessageHeading = '';
    if (memberIds.length == 1) {
      final CacheController cacheController = ref.read(cacheControllerProvider);
      final Profile? profile = cacheController.get(memberIds.first);
      serverMessageHeading = profile == null ? localizations.page_connections_list_add_dialog_member_unknown : profile.displayName.asHandle;
    } else {
      serverMessageHeading = localizations.page_connections_list_add_dialog_members_multi(memberIds.length);
    }

    final AddMembersResponse response = await streamChatClient.addChannelMembers(
      state.currentChannel!.id!,
      state.currentChannel!.type,
      memberIds,
      message: Message(
        text: localizations.page_connections_list_add_dialog_members_system_join(serverMessageHeading),
        type: 'system',
        mentionedUsers: memberIds.map((id) => User(id: id)).toList(),
      ),
    );

    logger.i('ChatViewModel.onAddMembersToChannel(), response: $response');
    final Channel channelRequest = streamChatClient.channel(response.channel.type, id: response.channel.id, extraData: response.channel.extraData);
    final Channel? channel = await getStreamController.forceChannelUpdate(channelRequest);
    final ChannelExtraData extraData = ChannelExtraData.fromJson(response.channel.extraData);

    if (channel == null) {
      logger.e('ChatViewModel.onAddMembersToChannel(), channel is null');
      return;
    }

    state = state.copyWith(
      currentChannel: channel,
      currentChannelExtraData: extraData,
    );

    appRouter.removeUntil((route) => route.name == ChatRoute.name);
  }

  Future<void> onRemoveMembersFromChannel(BuildContext context) async {
    final logger = ref.read(loggerProvider);
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final GetStreamController getStreamController = ref.read(getStreamControllerProvider.notifier);
    final ConversationApiService conversationApiService = await ref.read(conversationApiServiceProvider.future);

    logger.i('ChatViewModel.onRemoveMembersFromChannel()');
    if (state.currentChannel?.id == null || profileController.currentProfileId == null) {
      logger.e('ChatViewModel.onRemoveMembersFromChannel(), currentChannel.id is null');
      return;
    }

    // See if any users will remain in the channel after the removal
    final Channel channel = streamChatClient.channel(state.currentChannel!.type, id: state.currentChannel!.id);
    final List<String> remainingMembers = state.selectedMembers.where((member) => member != profileController.currentProfileId).where((element) => element.isNotEmpty).toList();
    if (remainingMembers.isEmpty) {
      logger.i('ChatViewModel.onRemoveMembersFromChannel(), locking the conversation after');
      await getStreamController.lockConversation(context: context, channel: channel);
    } else {
      logger.i('ChatViewModel.onRemoveMembersFromChannel(), removing members from the conversation');
      await conversationApiService.archiveMembers(conversationId: channel.id!, members: state.selectedMembers);
    }

    final channelResults = await streamChatClient.queryChannels(filter: Filter.equal('id', state.currentChannel!.id!)).firstOrNull;
    if (channelResults?.isNotEmpty ?? false) {
      await onChatChannelSelected(channelResults!.first);
    }
  }

  void onCurrentChannelMemberSelected(String userId) {
    if (state.selectedMembers.contains(userId)) {
      state = state.copyWith(selectedMembers: state.selectedMembers.where((id) => id != userId).toList());
    } else {
      state = state.copyWith(selectedMembers: [...state.selectedMembers, userId]);
    }
  }

  void onCurrentChannelPopped() {
    final logger = ref.read(loggerProvider);
    final GetStreamController getStreamController = ref.read(getStreamControllerProvider.notifier);
    if (state.currentChannel == null) {
      logger.d('ChatViewModel.verifyCurrentChannel() - No channel to verify');
      return;
    }

    logger.d('ChatViewModel.verifyCurrentChannel() - Checking if channel needs to be added to the cache');
    getStreamController.forceChannelUpdate(state.currentChannel!);
    state = state.copyWith(currentChannel: null, currentChannelExtraData: null);
  }

  Future<void> onChannelSelected(Channel channel, {bool shouldPopDialog = false}) async {
    return onChatChannelSelected(channel);
  }

  Future<void> onChatIdSelected(String id, {bool shouldPopDialog = false}) async {
    final logger = ref.read(loggerProvider);
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final channels = streamChatClient.queryChannels(filter: Filter.equal('id', id));
    final List<Channel> channelResults = await channels.first;
    if (channelResults.length != 1) {
      logger.e('ChatViewModel.onChatIdSelected(), channelResults.length != 1');
      return;
    }

    await onChatChannelSelected(channelResults.first);
  }

  Future<void> onChatModalRequested(BuildContext context, String uid, Channel channel) async {
    await PositiveDialog.show(
      context: context,
      child: ChatActionsDialog(channel: channel),
    );
  }

  FutureOr<void> onCurrentChannelMembersConfirmed(BuildContext context) async {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final GetStreamController getStreamController = ref.read(getStreamControllerProvider.notifier);

    if (state.currentChannel == null) {
      try {
        state = state.copyWith(isBusy: true);
        await getStreamController.createConversation(state.selectedMembers);
      } finally {
        state = state.copyWith(isBusy: false);
      }
      return;
    }

    await PositiveDialog.show(
      title: localizations.page_connections_list_add_dialog_title,
      context: context,
      child: const AddToConversationDialog(),
    );
  }

  FutureOr<void> onCreateNewConversationSelected(BuildContext context) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    state = state.copyWith(
      currentChannelExtraData: null,
      currentChannel: null,
      searchQuery: '',
      selectedMembers: [],
    );

    await appRouter.push(const CreateConversationRoute());
  }

  static Relationship? getRelationshipForProfile(List<Relationship> relationships, Profile value) {
    final String? profileId = value.flMeta?.id;
    if (profileId == null) {
      return null;
    }

    return relationships.firstWhereOrNull((element) => element.members.length == 2 && element.members.any((m) => m.memberId == profileId));
  }

  Relationship? getRelationshipForMessage(Message message) {
    final String? profileId = message.user?.id;
    if (profileId == null) {
      return null;
    }

    final List<Relationship> relationships = getCachedMemberRelationships();
    return relationships.firstWhereOrNull((element) => element.members.length == 2 && element.members.any((m) => m.memberId == profileId));
  }
}
