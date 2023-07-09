// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/providers/user/get_stream_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import '../../../providers/system/design_controller.dart';

class LeaveAndLockDialog extends StatefulHookConsumerWidget {
  final Channel channel;
  const LeaveAndLockDialog({required this.channel, super.key});

  @override
  ConsumerState<LeaveAndLockDialog> createState() => _LeaveAndLockDialogState();
}

class _LeaveAndLockDialogState extends ConsumerState<LeaveAndLockDialog> {
  bool _isBusy = false;
  bool get isBusy => _isBusy;

  Future<void> onActioned() async {
    final GetStreamController getStreamController = ref.read(getStreamControllerProvider.notifier);

    if (mounted) {
      setStateIfMounted(callback: () => _isBusy = true);
    }

    try {
      _isBusy = true;
      await getStreamController.lockConversation(context: context, channel: widget.channel);
      context.router.pop();
    } finally {
      setStateIfMounted(callback: () => _isBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    return Column(
      children: [
        Text(locale.page_chat_lock_dialog_desc, style: typography.styleSubtitle.copyWith(color: colors.white)),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          label: locale.page_chat_lock_dialog_title,
          primaryColor: colors.black,
          icon: UniconsLine.comment_block,
          isDisabled: isBusy,
          onTapped: onActioned,
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
