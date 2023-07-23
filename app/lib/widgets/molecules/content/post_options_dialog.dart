// Flutter imports:
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:unicons/unicons.dart';
import '../../../../providers/system/design_controller.dart';

class PostOptionsDialog extends ConsumerStatefulWidget {
  const PostOptionsDialog({
    required this.onEditPostSelected,
    required this.onDeletePostSelected,
    super.key,
  });

  final VoidCallback onEditPostSelected;
  final VoidCallback onDeletePostSelected;

  @override
  PostOptionsDialogState createState() => PostOptionsDialogState();
}

class PostOptionsDialogState extends ConsumerState<PostOptionsDialog> {
  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        PositiveButton(
          colors: colours,
          onTapped: widget.onEditPostSelected,
          label: localizations.post_dialogue_edit_post,
          primaryColor: colours.black,
          iconColorOverride: colours.white,
          icon: UniconsLine.pen,
          style: PositiveButtonStyle.primary,
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colours,
          onTapped: widget.onDeletePostSelected,
          label: localizations.post_dialogue_delete_post,
          primaryColor: colours.black,
          iconColorOverride: colours.white,
          icon: UniconsLine.file_times_alt,
          style: PositiveButtonStyle.primary,
        ),
      ],
    );
  }
}

class PostDeleteConfirmDialog extends ConsumerStatefulWidget {
  const PostDeleteConfirmDialog({
    required this.onDeletePostConfirmed,
    super.key,
  });

  final VoidCallback onDeletePostConfirmed;

  @override
  PostDeleteConfirmDialogState createState() => PostDeleteConfirmDialogState();
}

class PostDeleteConfirmDialogState extends ConsumerState<PostDeleteConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    return Column(
      children: [
        Text(
          localizations.post_dialogue_delete_post_confirm,
          style: typography.styleSubtitle.copyWith(color: colours.white),
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colours,
          onTapped: widget.onDeletePostConfirmed,
          label: localizations.post_dialogue_delete_post,
          primaryColor: colours.black,
          iconColorOverride: colours.white,
          icon: UniconsLine.file_times_alt,
          style: PositiveButtonStyle.primary,
        ),
      ],
    );
  }
}
