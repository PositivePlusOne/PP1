// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import 'package:app/providers/user/messaging_controller.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../guards/stream_chat_wrapper.dart';
import '../../../helpers/brand_helpers.dart';
import '../../../providers/system/design_controller.dart';
import '../../../services/third_party.dart';
import '../../molecules/navigation/positive_app_bar.dart';
import '../../molecules/navigation/positive_navigation_bar.dart';
import 'components/empty_chat_list_placeholder.dart';

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

    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    final MediaQueryData mediaQuery = MediaQuery.of(context);

    if (channelListController == null) {
      return const Scaffold();
    }

    // final bool hasChannels = channelListController!.value.isSuccess && channelListController!.currentItems.isNotEmpty;

    final double decorationBoxSize = min(mediaQuery.size.height / 2, 400);

    return PositiveScaffold(
      appBar: PositiveAppBar(
        applyLeadingandTrailingPadding: true,
        safeAreaQueryData: mediaQuery,
        foregroundColor: colors.black,
        backgroundColor: colors.colorGray1,
      ),
      bottomNavigationBar: PositiveNavigationBar(
        mediaQuery: mediaQuery,
        index: 2,
      ),
      children: <Widget>[
        SliverToBoxAdapter(
          child: StreamChannelListView(
            controller: channelListController!,
            onChannelTap: messagingController.onChatChannelSelected,
            loadingBuilder: (_) => const EmptyChatListPlaceholder(),
            emptyBuilder: (_) => const EmptyChatListPlaceholder(),
            shrinkWrap: true,
          ),
        ),
        SliverFillRemaining(
          fillOverscroll: false,
          hasScrollBody: false,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: decorationBoxSize,
              ),
              child: Stack(
                children: <Widget>[
                  ...buildType3ScaffoldDecorations(colors),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
