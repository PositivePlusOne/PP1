// Dart imports:
import 'dart:async';

// Flutter imports:
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
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/events/connections/channels_updated_event.dart';
import 'package:app/providers/user/get_stream_controller.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import 'package:app/widgets/organisms/chat/dialogs/add_to_conversation_dialog.dart';
import 'package:app/widgets/organisms/chat/dialogs/chat_actions_dialog.dart';
import '../../../../gen/app_router.dart';
import '../../../../providers/events/connections/relationship_updated_event.dart';
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
  StreamSubscription<RelationshipUpdatedEvent>? relationshipUpdatedSubscription;
  StreamSubscription<ChannelsUpdatedEvent>? channelsUpdatedSubscription;

  @override
  ChatViewModelState build() {
    return ChatViewModelState.initialState();
  }

  Future<bool> onWillPopScope() async {
    removeCurrentChannel();
    return true;
  }

  @override
  void onFirstRender() {
    super.onFirstRender();

    setupListeners();
    resetPageData();
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
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
    final EventBus eventBus = ref.read(eventBusProvider);
    logger.i('ChatViewModel.setupListeners()');

    if (relationshipUpdatedSubscription != null || channelsUpdatedSubscription != null) {
      logger.w('ChatViewModel.setupListeners(), listeners already setup');
      return;
    }

    await relationshipUpdatedSubscription?.cancel();
    relationshipUpdatedSubscription = relationshipController.positiveRelationshipsUpdatedController.stream.listen(onRelationshipsUpdated);

    await channelsUpdatedSubscription?.cancel();
    channelsUpdatedSubscription = eventBus.on<ChannelsUpdatedEvent>().listen(onChannelsUpdated);
  }

  void onRelationshipsUpdated(RelationshipUpdatedEvent? event) {
    final logger = ref.read(loggerProvider);

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

    log.d('ChatController: onChatChannelSelected');
    state = state.copyWith(
      currentChannel: channel,
      currentChannelExtraData: extraData,
    );

    await appRouter.replaceAll([
      const ChatConversationsRoute(),
      const ChatRoute(),
    ]);
  }

  Future<void> onAddMembersToChannel(BuildContext context, List<String> memberIds) async {
    final logger = ref.read(loggerProvider);
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final GetStreamController getStreamController = ref.read(getStreamControllerProvider.notifier);
    final AppRouter appRouter = ref.read(appRouterProvider);
    logger.i('ChatViewModel.onAddMembersToChannel()');

    if (state.currentChannel?.id == null) {
      logger.e('ChatViewModel.onAddMembersToChannel(), currentChannel.id is null');
      return;
    }

    if (memberIds.isEmpty) {
      logger.e('ChatViewModel.onAddMembersToChannel(), memberIds is empty');
      return;
    }

    final AddMembersResponse response = await streamChatClient.addChannelMembers(
      state.currentChannel!.id!,
      state.currentChannel!.type,
      memberIds,
      message: Message(
        text: 'joined the conversation',
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
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);

    logger.i('ChatViewModel.onRemoveMembersFromChannel()');
    if (state.currentChannel == null) {
      logger.e('ChatViewModel.onRemoveMembersFromChannel(), currentChannel is null');
      return;
    }

    if (state.currentChannel?.id == null) {
      logger.e('ChatViewModel.onRemoveMembersFromChannel(), currentChannel.id is null');
      return;
    }

    await firebaseFunctions.httpsCallable('conversation-archiveMembers').call({
      "channelId": state.currentChannel!.id,
      "members": state.selectedMembers,
    });

    final channelResults = await streamChatClient.queryChannels(filter: Filter.equal('id', state.currentChannel!.id!)).first;
    if (channelResults.isNotEmpty) {
      return onChatChannelSelected(channelResults.first);
    }
  }

  void onCurrentChannelMemberSelected(String userId) {
    if (state.selectedMembers.contains(userId)) {
      state = state.copyWith(selectedMembers: state.selectedMembers.where((id) => id != userId).toList());
    } else {
      state = state.copyWith(selectedMembers: [...state.selectedMembers, userId]);
    }
  }

  /// Used to desipher between creating and updating a channel
  void removeCurrentChannel() => state = state.copyWith(currentChannel: null, currentChannelExtraData: null);

  Future<void> onChannelSelected(Channel channel, {bool shouldPopDialog = false}) async {
    return onChatChannelSelected(channel);
  }

  Future<void> onChatIdSelected(String id, {bool shouldPopDialog = false}) async {
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final channelResults = await streamChatClient.queryChannels(filter: Filter.equal('id', id)).first;
    if (channelResults.isNotEmpty) {
      return onChatChannelSelected(channelResults.first);
    }
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
