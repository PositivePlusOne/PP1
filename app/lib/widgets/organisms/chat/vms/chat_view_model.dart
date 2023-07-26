// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/services/api.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import 'package:app/dtos/database/chat/channel_extra_data.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/events/connections/channels_updated_event.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import 'package:app/providers/user/get_stream_controller.dart';
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
    verifyCurrentChannel();
    removeCurrentChannel();
    return true;
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

    log.d('ChatController: onChatChannelSelected');
    state = state.copyWith(
      currentChannel: channel,
      currentChannelExtraData: extraData,
    );

    try {
      getStreamController.forceChannelUpdate(channel);
    } catch (ex) {
      log.e('ChatController: onChatChannelSelected, error: $ex');
      return;
    }

    await appRouter.replaceAll([
      const ChatConversationsRoute(),
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
      final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
      final Profile? profile = cacheController.getFromCache(memberIds.first);
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
    final Channel channel = streamChatClient.channel(response.channel.type, id: response.channel.id, extraData: response.channel.extraData);
    final ChannelExtraData extraData = ChannelExtraData.fromJson(response.channel.extraData);
    getStreamController.forceChannelUpdate(channel);

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

    final channelResults = await streamChatClient.queryChannels(filter: Filter.equal('id', state.currentChannel!.id!)).first;
    if (channelResults.isNotEmpty) {
      await onChatChannelSelected(channelResults.first);
    }
  }

  void onCurrentChannelMemberSelected(String userId) {
    if (state.selectedMembers.contains(userId)) {
      state = state.copyWith(selectedMembers: state.selectedMembers.where((id) => id != userId).toList());
    } else {
      state = state.copyWith(selectedMembers: [...state.selectedMembers, userId]);
    }
  }

  void verifyCurrentChannel() {
    final logger = ref.read(loggerProvider);
    final GetStreamController getStreamController = ref.read(getStreamControllerProvider.notifier);

    logger.d('ChatViewModel.verifyCurrentChannel() - Checking if channel needs to be added to the cache');
    getStreamController.forceChannelUpdate(state.currentChannel!);
  }

  /// Used to desipher between creating and updating a channel
  void removeCurrentChannel() => state = state.copyWith(currentChannel: null, currentChannelExtraData: null);

  Future<void> onChannelSelected(Channel channel, {bool shouldPopDialog = false}) async {
    return onChatChannelSelected(channel);
  }

  Future<void> onChatIdSelected(String id, {bool shouldPopDialog = false}) async {
    final logger = ref.read(loggerProvider);
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final List<Channel> channelResults = await streamChatClient.queryChannels(filter: Filter.equal('id', id)).first;
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
      await getStreamController.createConversation(state.selectedMembers);
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
}
