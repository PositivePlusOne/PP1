// Dart imports:
import 'dart:async';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/user/relationship_controller.dart';
import '../../../../providers/events/positive_relationships_updated_event.dart';
import '../../../../services/third_party.dart';

part 'chat_view_model.freezed.dart';
part 'chat_view_model.g.dart';

@freezed
class ChatViewModelState with _$ChatViewModelState {
  const factory ChatViewModelState({
    @Default(false) bool isRefreshing,
    @Default([]) List<Channel> availableChannels,
  }) = _ChatViewModelState;

  factory ChatViewModelState.initialState() => const ChatViewModelState();
}

@Riverpod(keepAlive: true)
class ChatViewModel extends _$ChatViewModel with LifecycleMixin {
  StreamSubscription<PositiveRelationshipsUpdatedEvent>? relationshipUpdatedSubscription;

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

    setupListeners();
    onRelationshipsUpdated(null);
  }

  Future<void> setupListeners() async {
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);

    await relationshipUpdatedSubscription?.cancel();
    relationshipUpdatedSubscription = relationshipController.positiveRelationshipsUpdatedController.stream.listen(onRelationshipsUpdated);
  }

  void onRelationshipsUpdated(PositiveRelationshipsUpdatedEvent? event) {
    final logger = ref.read(loggerProvider);
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    logger.i('ChatViewModel.onRelationshipsUpdated(), Checking for channels to refresh...');

    if (streamChatClient.wsConnectionStatus != ConnectionStatus.connected) {
      logger.d('ChatViewModel.onRelationshipsUpdated(), StreamChatClient is not connected, skipping refresh.');
      resetState();
      return;
    }

    final List<Channel> availableChannels = <Channel>[];
    // TODO(ryan): Add logic for filtering channels based on relationships and profiles we have available
    state = state.copyWith(availableChannels: availableChannels);
  }
}
