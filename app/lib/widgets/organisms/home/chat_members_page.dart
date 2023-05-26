// Flutter imports:
import 'package:app/gen/app_router.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/content/connections_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/input/positive_search_field.dart';
import 'package:app/widgets/molecules/lists/connection_list_item.dart';
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
              separatorBuilder: (context, values, index) => const SizedBox(),
              itemBuilder: (context, items, index, defaultWidget) {
                return _Member(member: items[index]);
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

class _Member extends ConsumerWidget {
  final Member member;

  const _Member({required this.member});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extraData = member.user?.extraData ?? {};
    final ChatViewModel chatViewModel = ref.read(chatViewModelProvider.notifier);
    final interests = (extraData['interests'] as List?)?.map((e) => e as String).toList();
    final genders = (extraData['genders'] as List?)?.map((e) => e as String).toList();

    return Padding(
      padding: const EdgeInsets.only(
        left: kPaddingMedium,
        right: kPaddingMedium,
        bottom: kPaddingExtraSmall,
      ),
      child: ConnectionListItem(
        connectedUser: ConnectedUser(
          id: member.userId ?? '',
          profileImage: member.user?.image,
          displayName: member.user?.name ?? '',
          interests: interests,
          genders: genders,
          birthday: extraData['birthday'].toString(),
          locationName: extraData['locationName']?.toString(),
          hivStatus: extraData['hivStatus']?.toString(),
        ),
        onTap: () => chatViewModel.onSelectedMember(member.userId ?? ''),
        isSelected: chatViewModel.state.selectedMemberIds.contains(member.userId ?? ''),
      ),
    );
  }
}
