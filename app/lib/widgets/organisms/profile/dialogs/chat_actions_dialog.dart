// Flutter imports:
import 'dart:async';

import 'package:app/gen/app_router.dart';
import 'package:app/providers/content/conversation_controller.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';

class ChatActionsDialog extends ConsumerWidget {
  final Channel channel;
  const ChatActionsDialog({super.key, required this.channel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));

    return PositiveDialog(
      title: '',
      children: [
        PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          label: localizations.page_chat_message_actions_people,
          icon: UniconsLine.users_alt,
          onTapped: () {
            context.router.pop();
            context.router.push(const ChatMembersRoute());
          },
        ),
        if (!channel.isDistinct || true) ...[
          const SizedBox(height: kPaddingMedium),
          PositiveButton(
            colors: colors,
            primaryColor: colors.black,
            label: localizations.page_chat_message_actions_leave_lock,
            icon: UniconsLine.comment_block,
            onTapped: () {
              return ref.read(conversationControllerProvider.notifier).sendSystemMessage(channelId: channel.id ?? "", text: "System message");
            },
          ),
        ]
      ],
    );
  }
}
