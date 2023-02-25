import 'package:app/providers/user/messaging_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../guards/stream_chat_wrapper.dart';
import '../../../services/third_party.dart';

class ChatListPage extends ConsumerStatefulWidget with StreamChatWrapper {
  const ChatListPage({super.key});

  @override
  ChatListPageState createState() => ChatListPageState();

  @override
  Widget get wrapperChild => this;
}

class ChatListPageState extends ConsumerState<ChatListPage> {
  StreamChannelListController? channelListController;

  @override
  void initState() {
    super.initState();
    setupListeners();
  }

  @override
  void dispose() {
    disposeListeners();
    super.dispose();
  }

  void setupListeners() {
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    if (streamChatClient.state.currentUser == null) {
      return;
    }

    channelListController = StreamChannelListController(
      client: StreamChat.of(context).client,
      filter: Filter.in_(
        'members',
        [streamChatClient.state.currentUser!.id],
      ),
      channelStateSort: const [
        SortOption('last_message_at'),
      ],
      limit: 20,
    );
  }

  void disposeListeners() {
    channelListController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MessagingController messagingController = ref.read(messagingControllerProvider.notifier);
    if (channelListController == null) {
      return const Scaffold();
    }

    return Scaffold(
      body: StreamChannelListView(
        controller: channelListController!,
        onChannelTap: messagingController.onChatChannelSelected,
      ),
    );
  }
}
