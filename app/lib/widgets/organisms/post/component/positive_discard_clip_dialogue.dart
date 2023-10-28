// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';

Future<bool> positiveDiscardClipDialogue({
  required BuildContext context,
  required DesignColorsModel colors,
  required DesignTypographyModel typography,
}) async {
  final AppLocalizations localizations = AppLocalizations.of(context)!;

  final bool result = await PositiveDialog.show(
        title: localizations.page_create_post_cancel_clip,
        context: context,
        child: Column(
          children: <Widget>[
            Text(
              localizations.page_create_post_cancel_clip_caption,
              style: typography.styleSubtitle.copyWith(color: colors.white),
            ),
            const SizedBox(height: kPaddingMedium),
            PositiveButton(
              colors: colors,
              onTapped: () => Navigator.pop(context, true),
              label: localizations.page_create_post_discard_clip,
              primaryColor: colors.black.withOpacity(kOpacityQuarter),
              style: PositiveButtonStyle.primary,
              icon: UniconsLine.trash_alt,
            ),
          ],
        ),
      ) ??
      false;

  return result;
}
