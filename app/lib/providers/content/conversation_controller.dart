// Dart imports:

// Package imports:
import 'package:app/providers/user/get_stream_controller.dart';
import 'package:uuid/uuid.dart';

import 'package:app/providers/user/user_controller.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/organisms/home/vms/chat_view_model.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final userController = ref.read(userControllerProvider);
    final user = userController.user;
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    if (user?.uid == null) return;
    await firebaseFunctions.httpsCallable('conversation-sendEventMessage').call({
      "channelId": channelId,
      "text": text,
      "eventType": eventType?.toJson(),
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
    final locale = AppLocalizations.of(context)!;
    await channel.removeMembers([streamUser.id]);

    return sendSystemMessage(
      channelId: channel.id ?? "",
      eventType: SystemMessageType.userRemoved,
      text: locale.page_chat_leave_group_system_message(streamUser.id),
      mentionedUserIds: [streamUser.id],
    );
  }
}
