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
import 'package:app/widgets/organisms/profile/dialogs/add_to_conversation_dialog.dart';
import 'package:app/widgets/organisms/profile/dialogs/chat_actions_dialog.dart';
import '../../../../gen/app_router.dart';
import '../../../../providers/events/connections/relationship_updated_event.dart';
import '../../../../services/third_party.dart';

part 'chat_view_model.freezed.dart';
part 'chat_view_model.g.dart';

@freezed
class ChatViewModelState with _$ChatViewModelState {
  const factory ChatViewModelState({
    // TODO(ryan): These need to be excluded from chat eventually for performance reasons
    // Chat List Properties
    DateTime? lastRelationshipsUpdated,
    DateTime? lastChannelsUpdated,
    @Default('') String chatMemberSearchQuery,

    // Current Conversation Properties
    DateTime? lastChannelUpdated,
    Channel? currentChannel,
    ChannelExtraData? currentChannelExtraData,
    @Default(<String>[]) List<String> currentChannelSelectedMembers,
    @Default('') String currentChannelSearchQuery,
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

  void resetChatMembersSearchQuery() {
    final logger = ref.read(loggerProvider);
    logger.i('ChatViewModel.resetChatMembersSearchQuery()');

    state = state.copyWith(chatMemberSearchQuery: '');
  }

  void setChatMembersSearchQuery(String query) {
    final logger = ref.read(loggerProvider);
    logger.i('ChatViewModel.setChatMembersSearchQuery()');

    state = state.copyWith(chatMemberSearchQuery: query);
  }

  void resetPageData() {
    final logger = ref.read(loggerProvider);
    logger.i('ChatViewModel.resetPageData()');

    state = state.copyWith(
      currentChannelSelectedMembers: [],
      currentChannelSearchQuery: '',
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

  Future<void> onChatChannelSelected(Channel channel, {bool shouldPopDialog = false}) async {
    final log = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final ChannelExtraData extraData = ChannelExtraData.fromJson(channel.extraData);

    log.d('ChatController: onChatChannelSelected');
    state = state.copyWith(
      currentChannel: channel,
      currentChannelExtraData: extraData,
    );

    if (shouldPopDialog) {
      await appRouter.pop();
    }

    await appRouter.push(const ChatRoute());
  }

  Future<void> onAddMembersToChannel(List<String> memberIds) async {
    final logger = ref.read(loggerProvider);
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    logger.i('ChatViewModel.onAddMembersToChannel()');

    if (state.currentChannel == null) {
      logger.e('ChatViewModel.onAddMembersToChannel(), currentChannel is null');
      return;
    }

    if (state.currentChannel?.id == null) {
      logger.e('ChatViewModel.onAddMembersToChannel(), currentChannel.id is null');
      return;
    }

    await streamChatClient.addChannelMembers(
      state.currentChannel!.id!,
      state.currentChannel!.type,
      memberIds,
      message: Message(
        text: 'joined the conversation',
        type: 'system',
        mentionedUsers: memberIds.map((id) => User(id: id)).toList(),
      ),
    );

    final channelResults = await streamChatClient.queryChannels(filter: Filter.equal('id', state.currentChannel!.id!)).first;
    if (channelResults.isNotEmpty) {
      return onChatChannelSelected(channelResults.first);
    }
  }

  Future<void> onRemoveMembersFromChannel() async {
    final logger = ref.read(loggerProvider);
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    logger.i('ChatViewModel.onRemoveMembersFromChannel()');

    if (state.currentChannel == null) {
      logger.e('ChatViewModel.onRemoveMembersFromChannel(), currentChannel is null');
      return;
    }

    if (state.currentChannel?.id == null) {
      logger.e('ChatViewModel.onRemoveMembersFromChannel(), currentChannel.id is null');
      return;
    }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);

    await firebaseFunctions.httpsCallable('conversation-archiveMembers').call({
      "channelId": state.currentChannel!.id,
      "members": state.currentChannelSelectedMembers,
    });

    final channelResults = await streamChatClient.queryChannels(filter: Filter.equal('id', state.currentChannel!.id!)).first;
    if (channelResults.isNotEmpty) {
      return onChatChannelSelected(channelResults.first);
    }
  }

  void onCurrentChannelMemberSelected(String userId) {
    if (state.currentChannelSelectedMembers.contains(userId)) {
      state = state.copyWith(currentChannelSelectedMembers: state.currentChannelSelectedMembers.where((id) => id != userId).toList());
    } else {
      state = state.copyWith(currentChannelSelectedMembers: [...state.currentChannelSelectedMembers, userId]);
    }
  }

  /// Used to desipher between creating and updating a channel
  void removeCurrentChannel() => state = state.copyWith(currentChannel: null, currentChannelExtraData: null);

  Future<void> onChatIdSelected(String id, {bool shouldPopDialog = false}) async {
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final channelResults = await streamChatClient.queryChannels(filter: Filter.equal('id', id)).first;
    if (channelResults.isNotEmpty) {
      return onChatChannelSelected(channelResults.first, shouldPopDialog: shouldPopDialog);
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
      await getStreamController.createConversation(state.currentChannelSelectedMembers);
      return;
    }

    await PositiveDialog.show(
      title: localizations.page_connections_list_add_dialog_title,
      context: context,
      child: const AddToConversationDialog(),
    );
  }
}
