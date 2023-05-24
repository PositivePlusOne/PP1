import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/input/positive_search_field.dart';
import 'package:app/widgets/organisms/home/vms/chat_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:unicons/unicons.dart';

@RoutePage()
class ChatMembersPage extends ConsumerWidget {
  const ChatMembersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ChatViewModel chatViewModel = ref.read(chatViewModelProvider.notifier);
    final ChatViewModelState chatViewModelState = ref.watch(chatViewModelProvider);
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));

    return Scaffold(
      // extendBody: true,
      backgroundColor: colors.colorGray1,
      appBar: AppBar(
        backgroundColor: colors.colorGray1,
        elevation: 0,
        leadingWidth: double.infinity,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: kPaddingMedium),
              child: PositiveButton(
                colors: colors,
                onTapped: () => context.router.pop(),
                icon: UniconsLine.angle_left,
                layout: PositiveButtonLayout.iconOnly,
                size: PositiveButtonSize.medium,
                primaryColor: colors.white,
              ),
            ),
            const SizedBox(width: kPaddingSmall),
            // const Expanded(
            //   child: _AvatarList(),
            // ),
            // const Spacer(),
            Expanded(
              child: PositiveSearchField(
                onSubmitted: (val) async {}, //TODO(andyrecitearch): implement searching members
              ),
            ),
            const SizedBox(width: kPaddingMedium),
          ],
        ),
      ),
      body: Column(
        children: [
          if (chatViewModelState.memberListController != null)
            Expanded(
              child: StreamMemberListView(
                controller: chatViewModelState.memberListController!,
                itemBuilder: (context, items, index, defaultWidget) {
                  // return Text(items[index].user?.name ?? "no name");
                  return _Member(member: items[index]);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _Member extends ConsumerWidget {
  final Member member;

  const _Member({required this.member});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(member.user?.extraData['profile'].toString() ?? "");
  }
}
