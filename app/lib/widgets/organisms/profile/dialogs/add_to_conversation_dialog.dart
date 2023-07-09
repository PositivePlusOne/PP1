// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/organisms/chat/vms/chat_view_model.dart';

class AddToConversationDialog extends StatefulHookConsumerWidget {
  const AddToConversationDialog({super.key});

  @override
  ConsumerState<AddToConversationDialog> createState() => _AddToConversationDialogState();
}

class _AddToConversationDialogState extends ConsumerState<AddToConversationDialog> {
  final List<Profile> selectedUsers = [];

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final ChatViewModel chatViewModel = ref.read(chatViewModelProvider.notifier);

    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: localizations.shared_actions_add, style: typography.styleBody),
              ...selectedUsers.map((user) => TextSpan(text: "@${user.displayName} ", style: typography.styleBody.copyWith(fontWeight: FontWeight.bold))).toList(),
              TextSpan(text: localizations.page_connections_list_add_dialog_members_trailing, style: typography.styleBody),
            ],
          ),
        ),
        const SizedBox(height: kPaddingMedium),
        Text(localizations.page_connections_list_add_dialog_description, style: typography.styleBody.copyWith(color: colors.white)),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          label: localizations.page_connections_list_add_dialog_title,
          icon: UniconsLine.user_plus,
          onTapped: () async {
            await chatViewModel.onAddMembersToChannel(selectedUsers.map((e) => e.id).toList());
          },
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          label: localizations.shared_actions_cancel,
          onTapped: () => context.router.pop(),
        ),
      ],
    );
  }
}
