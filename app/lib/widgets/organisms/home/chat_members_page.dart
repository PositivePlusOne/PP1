// Flutter imports:
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/geo/positive_place.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/input/positive_search_field.dart';
import 'package:app/widgets/molecules/lists/positive_profile_chat_tile.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/home/vms/chat_view_model.dart';

@RoutePage()
class ChatMembersPage extends ConsumerWidget {
  const ChatMembersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = AppLocalizations.of(context)!;
    final ChatViewModel chatViewModel = ref.read(chatViewModelProvider.notifier);
    final ChatViewModelState chatViewModelState = ref.watch(chatViewModelProvider);
    final Channel channel = chatViewModelState.currentChannel!;
    final List<String> memberIds = channel.state!.members.map((e) => e.userId).nonNulls.toList();

    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    return PositiveScaffold(
      headingWidgets: [
        SliverPadding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + kPaddingSmall,
            // bottom: kPaddingSmall,
            left: kPaddingMedium,
            right: kPaddingMedium,
          ),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                PositiveButton(
                  colors: colors,
                  onTapped: () => context.router.pop(),
                  icon: UniconsLine.angle_left,
                  layout: PositiveButtonLayout.iconOnly,
                  size: PositiveButtonSize.medium,
                  primaryColor: colors.white,
                ),
                const SizedBox(width: kPaddingMedium),
                Expanded(
                  child: PositiveSearchField(
                    hintText: locale.page_chat_message_members_search_hint,
                    onSubmitted: chatViewModel.onSearchMembersSubmitted,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (chatViewModelState.memberListController != null)
          SliverToBoxAdapter(
            child: StreamMemberListView(
              padding: const EdgeInsets.only(top: kPaddingMedium),
              controller: chatViewModelState.memberListController!,
              separatorBuilder: (context, values, index) {
                return const SizedBox(height: kPaddingExtraSmall);
              },
              itemBuilder: (context, items, index, defaultWidget) {
                final List<String> memberIds = items.map((e) => e.userId).nonNulls.toList();
                return Padding(
                  padding: const EdgeInsets.only(left: kPaddingMedium, right: kPaddingMedium),
                  child: PositiveProfileChatTile(
                    members: memberIds,
                    onTap: () => chatViewModel.onSelectedMember(member.userId ?? ''),
                    isSelected: chatViewModel.state.selectedMemberIds.contains(member.userId ?? ''),
                  ),
                );
              },
              shrinkWrap: true,
            ),
          ),
      ],
      footerWidgets: [
        if (chatViewModelState.currentChannel?.ownCapabilities.contains("update-channel-members") ?? false)
          Column(
            children: [
              PositiveButton(
                colors: colors,
                primaryColor: colors.black,
                label: locale.page_chat_message_members_add_users,
                onTapped: () => context.router.push(const ConnectionsListRoute()),
              ),
              const SizedBox(height: kPaddingSmall),
              PositiveButton(
                colors: colors,
                primaryColor: colors.black,
                label: locale.page_chat_message_members_remove_users,
                isDisabled: chatViewModelState.selectedMemberIds.isEmpty,
                onTapped: () => chatViewModel.onRemoveMembersFromChannel(),
              ),
              const SizedBox(height: kPaddingSmall),
            ],
          ),
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          label: locale.page_chat_message_members_continue,
          onTapped: () => context.router.pop(),
        ),
      ],
    );
  }
}
