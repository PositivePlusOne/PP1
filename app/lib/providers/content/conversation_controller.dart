// Dart imports:

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/organisms/home/vms/chat_view_model.dart';

part 'conversation_controller.freezed.dart';

part 'conversation_controller.g.dart';

@freezed
class ConversationState with _$ConversationState {
  const factory ConversationState() = _ConversationState;
}

@riverpod
class ConversationController extends _$ConversationController {
  @override
  Future<ConversationState> build() async {
    return const ConversationState();
  }

  Future<void> sendSystemMessage({
    required String channelId,
    List<String>? mentionedUserIds,
    required String text,
  }) async {
    final userController = ref.read(userControllerProvider);
    final user = userController.user;
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    if (user?.uid == null) return;
    await firebaseFunctions.httpsCallable('conversation-sendEventMessage').call({
      "channelId": channelId,
      "text": text,
      "mentionedUsers": mentionedUserIds ?? [],
    });
  }

  Future<void> createConversation(List<String> memberIds) async {
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final res = await firebaseFunctions.httpsCallable('conversation-createConversation').call({'members': memberIds});

    if (res.data == null) throw Exception('Failed to create conversation');

    final conversationId = res.data as String;
    ref.read(chatViewModelProvider.notifier).onChatIdSelected(conversationId);
  }
}
