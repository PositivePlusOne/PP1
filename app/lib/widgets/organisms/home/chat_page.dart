// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import 'package:app/guards/stream_chat_wrapper.dart';
import 'package:app/providers/user/messaging_controller.dart';

class ChatPage extends ConsumerWidget with StreamChatWrapper {
  const ChatPage({super.key});

  @override
  Widget get wrapperChild => this;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MessagingControllerState state = ref.watch(messagingControllerProvider);
    if (state.currentChannel == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: const StreamChannelHeader(),
      body: Column(
        children: const <Widget>[
          Expanded(
            child: StreamMessageListView(),
          ),
          StreamMessageInput(),
        ],
      ),
    );
  }
}
