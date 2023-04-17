// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:app/widgets/organisms/home/vms/chat_view_model.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../helpers/brand_helpers.dart';
import '../../../providers/system/design_controller.dart';
import '../../molecules/navigation/positive_app_bar.dart';
import '../../molecules/navigation/positive_navigation_bar.dart';
import 'components/empty_chat_list_placeholder.dart';
import 'components/stream_chat_wrapper.dart';

@RoutePage()
class ChatListPage extends ConsumerWidget with StreamChatWrapper {
  const ChatListPage({super.key});

  @override
  Widget get child => this;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ChatViewModel chatViewModel = ref.read(chatViewModelProvider.notifier);
    final ChatViewModelState chatViewModelState = ref.watch(chatViewModelProvider);

    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final MediaQueryData mediaQuery = MediaQuery.of(context);

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
      headingWidgets: <Widget>[
        if (chatViewModelState.messageListController != null) ...<Widget>[
          SliverToBoxAdapter(
            child: StreamChannelListView(
              controller: chatViewModelState.messageListController!,
              onChannelTap: chatViewModel.onChatChannelSelected,
              loadingBuilder: (_) => const EmptyChatListPlaceholder(),
              emptyBuilder: (_) => const EmptyChatListPlaceholder(),
              shrinkWrap: true,
            ),
          ),
        ] else ...<Widget>[
          const SliverToBoxAdapter(
            child: EmptyChatListPlaceholder(),
          ),
        ],
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
