// Dart imports:
import 'dart:async';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/user/relationship_controller.dart';
import '../../../../controllers/positive_chat_list_controller.dart';
import '../../../../gen/app_router.dart';
import '../../../../providers/events/positive_relationships_updated_event.dart';
import '../../../../services/third_party.dart';

part 'chat_view_model.freezed.dart';
part 'chat_view_model.g.dart';

@freezed
class ChatViewModelState with _$ChatViewModelState {
  const factory ChatViewModelState({
    PositiveChatListController? messageListController,
    @Default('') String conversationSearchText,
    @Default('') String peopleSearchText,
    Channel? currentChannel,
    DateTime? lastRelationshipsUpdated,
  }) = _ChatViewModelState;

  factory ChatViewModelState.initialState() => const ChatViewModelState();
}

@Riverpod(keepAlive: true)
class ChatViewModel extends _$ChatViewModel with LifecycleMixin {
  StreamSubscription<PositiveRelationshipsUpdatedEvent>? relationshipUpdatedSubscription;
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

  Future<void> createListControllers() async {
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final logger = ref.read(loggerProvider);
    logger.i('ChatViewModel.createListControllers()');

    final String userId = streamChatClient.state.currentUser?.id ?? '';
    if (userId.isEmpty) {
      logger.e('ChatViewModel.createListControllers(), userId is empty');
      return;
    }

    final PositiveChatListController messageListController = PositiveChatListController(
      client: streamChatClient,
      filter: Filter.and(
        <Filter>[
          Filter.in_(
            'members',
            [userId],
          ),
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
    );

    state = state.copyWith(
      messageListController: messageListController,
    );
  }

  Future<void> onRelationshipsUpdated(PositiveRelationshipsUpdatedEvent? event) async {
    final logger = ref.read(loggerProvider);
    logger.i('ChatViewModel.onRelationshipsUpdated()');
    state = state.copyWith(lastRelationshipsUpdated: DateTime.now());
  }

  Future<void> onChatChannelSelected(Channel channel) async {
    final log = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    log.d('ChatController: onChatChannelSelected');
    state = state.copyWith(currentChannel: channel);
    await appRouter.push(const ChatRoute());
  }
}
