// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:app/gen/app_router.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/indicators/positive_circular_indicator.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:app/widgets/atoms/input/positive_search_field.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/home/vms/chat_view_model.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../helpers/brand_helpers.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/enumerations/positive_button_style.dart';
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
      bottomNavigationBar: PositiveNavigationBar(
        mediaQuery: mediaQuery,
        index: NavigationBarIndex.chat,
      ),
      headingWidgets: <Widget>[
        SliverPadding(
          padding: EdgeInsets.only(
            top: mediaQuery.padding.top + kPaddingSmall,
            // bottom: kPaddingSmall,
            left: kPaddingMedium,
            right: kPaddingMedium,
          ),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                PositiveButton(
                  colors: colors,
                  primaryColor: colors.teal,
                  onTapped: () async {
                    context.router.push(const ConnectionsListRoute());
                  },
                  label: 'Create Conversation',
                  tooltip: 'Create Conversation',
                  icon: UniconsLine.comment_edit,
                  style: PositiveButtonStyle.primary,
                  layout: PositiveButtonLayout.iconOnly,
                  size: PositiveButtonSize.medium,
                ),
                const SizedBox(width: kPaddingMedium),
                Expanded(
                  child: PositiveSearchField(
                    onSubmitted: chatViewModel.onSearchSubmitted,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (chatViewModelState.messageListController != null) ...<Widget>[
          SliverToBoxAdapter(
            child: StreamChannelListView(
              padding: const EdgeInsets.only(top: kPaddingMedium),
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
    final DesignTypographyModel typeography = ref.watch(designControllerProvider.select((value) => value.typography));
    final String? currentUseId = ref.watch(userControllerProvider.select((value) => value.user?.uid));

    return FutureBuilder<QueryMembersResponse>(
        future: channel.queryMembers(),
        builder: (context, snapshot) {
          const maxImages = 2;
          const maxNames = 3;

          final members = snapshot.data?.members.where((member) => member.user?.id != currentUseId) ?? [];
          final names = members.map((e) => "@${e.user?.name}");
          final images = members.map((e) => e.user?.image);

          return GestureDetector(
            onTap: () => ref.read(chatViewModelProvider.notifier).onChatChannelSelected(channel),
            child: Container(
              height: 70,
              margin: const EdgeInsets.symmetric(horizontal: kPaddingMedium, vertical: kPaddingExtraSmall),
              padding: const EdgeInsets.all(kPaddingSmall),
              decoration: BoxDecoration(
                color: colors.white,
                borderRadius: BorderRadius.circular(kBorderRadiusMassive),
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      ...images.take(maxImages).mapIndexed(
                            (index, image) => Padding(
                              padding: EdgeInsets.only(left: index * 25),
                              child: PositiveProfileCircularIndicator(
                                profile: Profile(profileImage: image ?? ""),
                                size: 50,
                              ),
                            ),
                          ),
                      if (images.length > maxImages)
                        Padding(
                          padding: const EdgeInsets.only(left: maxImages * 25),
                          child: PositiveCircularIndicator(
                            ringColor: colors.black,
                            borderThickness: kBorderThicknessSmall,
                            size: 50,
                            child: Center(
                              child: Text(
                                "+${images.length - maxImages}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: kPaddingSmall),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              names.take(maxNames).join(", ") + (names.length > maxNames ? ", +${names.length - maxNames} More" : ""),
                              style: typeography.styleTitle.copyWith(color: colors.colorGray7),
                            ),
                          ),
                        ),
                        const SizedBox(height: kPaddingExtraSmall),
                        FutureBuilder<ChannelState>(
                          future: channel.query(messagesPagination: const PaginationParams(limit: 1)),
                          builder: (context, snapshot) {
                            final messages = snapshot.data?.messages;

                            if (messages != null && messages.isEmpty) {
                              return const SizedBox();
                            }

                            final sender = messages?.first.user;
                            final senderName = sender?.id != currentUseId ? "You" : sender?.name ?? "";
                            final message = messages?.first.text?.replaceAll("\n", " ") ?? "";

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "$senderName: $message",
                                    overflow: TextOverflow.ellipsis,
                                    style: typeography.styleSubtext.copyWith(color: colors.colorGray3),
                                  ),
                                ),
                                const SizedBox(width: kPaddingSmall),
                                ChannelLastMessageDate(
                                  channel: channel,
                                  textStyle: typeography.styleSubtext.copyWith(color: colors.colorGray3),
                                )
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: kPaddingSmall),
                ],
              ),
            ),
          );
        });
  }
}
