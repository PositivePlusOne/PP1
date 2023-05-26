// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import 'package:app/widgets/organisms/profile/dialogs/chat_actions_dialog.dart';
import '../../../../gen/app_router.dart';
import '../../../../providers/events/relationships_updated_event.dart';
import '../../../../services/third_party.dart';

part 'chat_view_model.freezed.dart';
part 'chat_view_model.g.dart';

@freezed
class ChatViewModelState with _$ChatViewModelState {
  const factory ChatViewModelState({
    @Default(<String>[]) List<String> selectedMemberIds,
    StreamChannelListController? messageListController,
    StreamMemberListController? memberListController,
    @Default('') String conversationSearchText,
    @Default('') String peopleSearchText,
    Channel? currentChannel,
    DateTime? lastRelationshipsUpdated,
  }) = _ChatViewModelState;

  factory ChatViewModelState.initialState() => const ChatViewModelState();
}

@Riverpod(keepAlive: true)
class ChatViewModel extends _$ChatViewModel with LifecycleMixin {
  StreamSubscription<RelationshipsUpdatedEvent>? relationshipUpdatedSubscription;
  StreamSubscription<ConnectionStatus>? connectionStatusSubscription;

  @override
  ChatViewModelState build() {
    return ChatViewModelState.initialState();
  }

  void resetState() {
    final logger = ref.read(loggerProvider);
    logger.i('ChatViewModel.resetState()');
    state = ChatViewModelState.initialState();
  }

  @override
  void onFirstRender() {
    super.onFirstRender();

    // Check if listeners are already setup
    if (relationshipUpdatedSubscription == null && connectionStatusSubscription == null) {
      setupListeners();
    }
  }

  Future<void> setupListeners() async {
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);

    await relationshipUpdatedSubscription?.cancel();
    relationshipUpdatedSubscription = relationshipController.positiveRelationshipsUpdatedController.stream.listen(onRelationshipsUpdated);

    await connectionStatusSubscription?.cancel();
    connectionStatusSubscription = ref.read(streamChatClientProvider).wsConnectionStatusStream.listen(onConnectionStatusChanged);

    await onConnectionStatusChanged(streamChatClient.wsConnectionStatus);
    await onRelationshipsUpdated(null);
  }

  Future<void> onConnectionStatusChanged(ConnectionStatus event) async {
    final logger = ref.read(loggerProvider);
    logger.i('ChatViewModel.onConnectionStatusChanged(), Connection status changed to $event');

    if (event != ConnectionStatus.connected) {
      resetState();
      return;
    }

    createListControllers();
  }

  Future<void> createListControllers({String? searchTerm}) async {
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final logger = ref.read(loggerProvider);
    logger.i('ChatViewModel.createListControllers()');

    final String userId = streamChatClient.state.currentUser?.id ?? '';
    if (userId.isEmpty) {
      logger.e('ChatViewModel.createListControllers(), userId is empty');
      return;
    }

    state = state.copyWith(
      messageListController: StreamChannelListController(
        client: streamChatClient,
        filter: Filter.and(
          <Filter>[
            if (searchTerm != null && searchTerm.isNotEmpty) Filter.autoComplete("member.user.name", searchTerm),
            Filter.in_(
              'members',
              [userId],
            ),
            //* Only show chats with messages
            Filter.greaterOrEqual(
              'last_message_at',
              '1900-01-01T00:00:00.00Z',
            ),
          ],
        ),
        channelStateSort: const [
          SortOption('last_message_at'),
        ],
        limit: 20,
      ),
    );
  }

  Future<void> onSearchSubmitted(String searchTerm) async => createListControllers(searchTerm: searchTerm);

  Future<void> onSearchMembersSubmitted(String searchTerm) async {
    final logger = ref.read(loggerProvider);
    logger.i('ChatViewModel.onSearchSubmitted()');

    if (state.currentChannel == null) {
      logger.e('ChatViewModel.onSearchSubmitted(), currentChannel is null');
      return;
    }

    final StreamMemberListController memberListController = StreamMemberListController(
      channel: state.currentChannel!,
      filter: searchTerm.isNotEmpty
          ? Filter.and(
              <Filter>[
                Filter.autoComplete("name", searchTerm),
              ],
            )
          : null,
    );

    state = state.copyWith(
      memberListController: memberListController,
    );
  }

  Future<void> onRelationshipsUpdated(RelationshipsUpdatedEvent? event) async {
    final logger = ref.read(loggerProvider);
    logger.i('ChatViewModel.onRelationshipsUpdated()');
    state = state.copyWith(lastRelationshipsUpdated: DateTime.now());
  }

  Future<void> onChatChannelSelected(Channel channel) async {
    final log = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    final StreamMemberListController memberListController = StreamMemberListController(channel: channel);

    log.d('ChatController: onChatChannelSelected');
    state = state.copyWith(
      memberListController: memberListController,
      currentChannel: channel,
    );
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

    await streamChatClient.removeChannelMembers(
      state.currentChannel!.id!,
      state.currentChannel!.type,
      state.selectedMemberIds,
    );

    final channelResults = await streamChatClient.queryChannels(filter: Filter.equal('id', state.currentChannel!.id!)).first;
    if (channelResults.isNotEmpty) {
      return onChatChannelSelected(channelResults.first);
    }
  }

  void onSelectedMember(String userId) {
    if (state.selectedMemberIds.contains(userId)) {
      state = state.copyWith(selectedMemberIds: state.selectedMemberIds.where((id) => id != userId).toList());
    } else {
      state = state.copyWith(selectedMemberIds: [...state.selectedMemberIds, userId]);
    }
  }

  /// Used to desipher between creating and updating a channel
  void removeCurrentChannel() => state = state.copyWith(currentChannel: null);

  Future<void> onChatIdSelected(String id) async {
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final channelResults = await streamChatClient.queryChannels(filter: Filter.equal('id', id)).first;
    if (channelResults.isNotEmpty) {
      return onChatChannelSelected(channelResults.first);
    }
  }

  Future<void> onChatModalRequested(BuildContext context, String uid) async {
    await PositiveDialog.show(
      context: context,
      dialog: const ChatActionsDialog(),
    );
  }
}
