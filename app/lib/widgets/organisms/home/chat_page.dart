// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import 'components/stream_chat_wrapper.dart';

@RoutePage()
class ChatPage extends ConsumerWidget with StreamChatWrapper {
  const ChatPage({super.key});

  @override
  Widget get child => this;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      appBar: StreamChannelHeader(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamMessageListView(),
          ),
          StreamMessageInput(),
        ],
      ),
    );
  }
}
