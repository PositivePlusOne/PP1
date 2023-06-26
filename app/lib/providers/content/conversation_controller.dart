// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import 'package:app/services/third_party.dart';
import 'package:app/widgets/organisms/home/vms/chat_view_model.dart';

part 'conversation_controller.freezed.dart';
part 'conversation_controller.g.dart';

enum SystemMessageType {
  userRemoved("user_removed"),
  userAdded("user_added"),
  channelFrozen("channel_frozen"),
  channelUnfrozen("channel_unfrozen");

  final String eventType;

  const SystemMessageType(this.eventType);

  String toJson() {
    return eventType;
  }
}

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
    SystemMessageType? eventType,
  }) async {
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final user = firebaseAuth.currentUser;

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    if (user?.uid == null) return;
    await firebaseFunctions.httpsCallable('conversation-sendEventMessage').call({
      "channelId": channelId,
      "text": text,
      "eventType": eventType?.toJson(),
      "mentionedUsers": mentionedUserIds ?? [],
    });
  }

  Future<void> createConversation(List<String> memberIds, {bool shouldPopDialog = false}) async {
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final ChatViewModel chatViewModel = ref.read(chatViewModelProvider.notifier);

    final res = await firebaseFunctions.httpsCallable('conversation-createConversation').call({'members': memberIds});
    if (res.data == null) {
      throw Exception('Failed to create conversation');
    }

    final conversationId = res.data as String;
    await chatViewModel.onChatIdSelected(conversationId, shouldPopDialog: shouldPopDialog);
  }

  Future<void> lockConversation({required BuildContext context, required Channel channel}) async {
    final locale = AppLocalizations.of(context)!;
    try {
      final streamUser = StreamChat.of(context).currentUser!;
      final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
      final res = await firebaseFunctions.httpsCallable('conversation-freezeChannel').call(
        {
          'channelId': channel.id,
          'text': locale.page_chat_lock_group_system_message(streamUser.id),
          'userId': streamUser.id,
        },
      );
      if (res.data == null) throw Exception('Failed to freeze conversation');
    } catch (e) {
      print(e);
    }
  }

  Future<void> leaveConversation({
    required BuildContext context,
    required Channel channel,
  }) async {
    final streamUser = StreamChat.of(context).currentUser!;
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);

    await firebaseFunctions.httpsCallable('conversation-archiveMembers').call({
      "channelId": channel.id,
      "members": [streamUser.id],
    });
  }
}
