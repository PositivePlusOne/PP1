// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/widgets/organisms/chat/vms/chat_view_model.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/providers/content/conversation_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/input/positive_search_field.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/profile/dialogs/add_to_conversation_dialog.dart';

@RoutePage()
class CreateConversationPage extends HookConsumerWidget {
  const CreateConversationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final ChatViewModel chatViewModel = ref.read(chatViewModelProvider.notifier);
    final ChatViewModelState chatViewModelState = ref.watch(chatViewModelProvider);
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final locale = AppLocalizations.of(context)!;

    useLifecycleHook(chatViewModel);

    return PositiveScaffold(
      decorations: [
        // Only show if no members
        ...buildType3ScaffoldDecorations(colors),
      ],
      headingWidgets: <Widget>[
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
                    hintText: locale.shared_search_people_hint,
                    onCancel: chatViewModel.resetChatMembersSearchQuery,
                    onChange: chatViewModel.setChatMembersSearchQuery,
                  ),
                ),
              ],
            ),
          ),
        ),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final connectedUsers = ref.watch(connectedUsersControllerProvider).value?.filteredUsers;
            if (connectedUsers?.isNotEmpty ?? false) {
              return SliverPadding(
                padding: const EdgeInsets.only(top: kPaddingMedium),
                sliver: CreateConversation(connectedUsers: connectedUsers!),
              );
            }

            return const SliverToBoxAdapter(
              child: EmptyCreateConversation(),
            );
          },
        ),
      ],
      footerWidgets: [
        PositiveButton(
          isDisabled: chatViewModelState.currentChannelSelectedMembers.isEmpty,
          colors: colors,
          style: PositiveButtonStyle.primary,
          label: chatViewModelState.currentChannel != null ? "Add to Conversation" : locale.page_chat_action_start_conversation,
          onTapped: () => chatViewModel.onCurrentChannelMembersConfirmed(context),
          size: PositiveButtonSize.large,
          primaryColor: colors.black,
        ),
      ],
    );
  }
}
