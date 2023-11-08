// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import '../../../../providers/system/design_controller.dart';

class CommentOptionsDialog extends ConsumerStatefulWidget {
  const CommentOptionsDialog({
    required this.onDeleteCommentSelected,
    super.key,
  });

  final VoidCallback onDeleteCommentSelected;

  @override
  CommentOptionsDialogState createState() => CommentOptionsDialogState();
}

class CommentOptionsDialogState extends ConsumerState<CommentOptionsDialog> {
  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        PositiveButton(
          colors: colours,
          onTapped: widget.onDeleteCommentSelected,
          label: localizations.comment_dialogue_delete_comment,
          primaryColor: colours.black,
          iconColorOverride: colours.white,
          icon: UniconsLine.file_times_alt,
          style: PositiveButtonStyle.primary,
        ),
      ],
    );
  }
}

class CommentDeleteConfirmDialog extends ConsumerStatefulWidget {
  const CommentDeleteConfirmDialog({
    required this.onDeleteCommentConfirmed,
    super.key,
  });

  final VoidCallback onDeleteCommentConfirmed;

  @override
  CommentDeleteConfirmDialogState createState() => CommentDeleteConfirmDialogState();
}

class CommentDeleteConfirmDialogState extends ConsumerState<CommentDeleteConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    return Column(
      children: [
        Text(
          localizations.comment_dialogue_delete_comment_confirm,
          style: typography.styleSubtitle.copyWith(color: colours.white),
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colours,
          onTapped: widget.onDeleteCommentConfirmed,
          label: localizations.comment_dialogue_delete_comment,
          primaryColor: colours.black,
          iconColorOverride: colours.white,
          icon: UniconsLine.file_times_alt,
          style: PositiveButtonStyle.primary,
        ),
      ],
    );
  }
}
