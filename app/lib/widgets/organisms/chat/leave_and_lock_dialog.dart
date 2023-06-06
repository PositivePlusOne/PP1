import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/content/conversation_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:unicons/unicons.dart';

import '../../../providers/system/design_controller.dart';

class LeaveAndLockDialog extends ConsumerWidget {
  final Channel channel;
  const LeaveAndLockDialog({required this.channel, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = AppLocalizations.of(context)!;
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    return PositiveDialog(
      title: locale.page_chat_lock_dialog_title,
      children: [
        Text(locale.page_chat_lock_dialog_desc, style: typography.styleSubtitle.copyWith(color: colors.white)),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          label: locale.page_chat_lock_dialog_title,
          primaryColor: colors.black,
          icon: UniconsLine.comment_block,
          onTapped: () async {
            await ref.read(conversationControllerProvider.notifier).lockConversation(
                  context: context,
                  channel: channel,
                );
            context.router.pop();
          },
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          label: locale.shared_actions_cancel,
          primaryColor: colors.black,
          icon: UniconsLine.comment_block,
          onTapped: () {
            context.router.pop();
          },
        ),
      ],
    );
  }
}
