// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/home/vms/chat_view_model.dart';
import 'package:unicons/unicons.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../helpers/brand_helpers.dart';
import '../../../providers/system/design_controller.dart';
import '../../molecules/navigation/positive_app_bar.dart';
import '../../molecules/navigation/positive_navigation_bar.dart';
import 'components/empty_chat_list_placeholder.dart';
import 'components/stream_chat_wrapper.dart';

@RoutePage()
class ChatConversationsPage extends HookConsumerWidget with StreamChatWrapper {
  const ChatConversationsPage({super.key});

  @override
  Widget get child => this;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ChatViewModel chatViewModel = ref.read(chatViewModelProvider.notifier);
    final ChatViewModelState chatViewModelState = ref.watch(chatViewModelProvider);

    useLifecycleHook(chatViewModel);

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
              separatorBuilder: (_, __, ___) => const SizedBox(),
              itemBuilder: (context, items, index, defaultWidget) {
                return _ConversationItem(channel: items[index]);
              },
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

class _ConversationItem extends ConsumerWidget {
  final Channel channel;
  const _ConversationItem({Key? key, required this.channel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: kPaddingMedium, vertical: kPaddingExtraSmall),
      padding: const EdgeInsets.all(kPaddingSmall),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(kBorderRadiusMassive),
      ),
      child: Row(
        children: [
          PositiveProfileCircularIndicator(
            profile: Profile(profileImage: channel.image ?? ""),
            size: 50,
          ),
          Text(channel.name ?? ""),
        ],
      ),
    );
  }
}
