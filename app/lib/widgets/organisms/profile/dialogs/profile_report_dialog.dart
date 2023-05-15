import 'package:app/dtos/database/profile/profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/organisms/account/dialogs/account_feedback_dialog.dart';
import 'package:app/widgets/organisms/account/vms/account_view_model.dart';
import 'package:fluent_validation/fluent_validation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../providers/system/design_controller.dart';
import '../../../molecules/dialogs/positive_dialog.dart';

class ProfileReportDialog extends ConsumerWidget {
  const ProfileReportDialog({
    required this.profile,
    super.key,
  });

  final Profile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final AccountViewModel viewModel = ref.read(accountViewModelProvider.notifier);
    final AccountViewModelState state = ref.watch(accountViewModelProvider);

    final ValidationResult validationResults = viewModel.userFeedbackValidator.validate(state.feedback);
    final bool isValid = validationResults.hasError == false;

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return PositiveDialog(
      title: localizations.shared_profile_report_modal_title(profile.displayName),
      children: <Widget>[
        Text(
          localizations.shared_profile_report_modal_subtitle,
          style: typography.styleSubtitle.copyWith(color: colors.white),
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveTextField(
          hintText: localizations.shared_profile_report_modal_tooltip,
          minLines: AccountFeedbackDialog.kFeedbackLineCount,
          maxLines: AccountFeedbackDialog.kFeedbackLineCount,
          onTextChanged: viewModel.onFeedbackUpdated,
          isEnabled: !state.isBusy,
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          onTapped: () => viewModel.onFeedbackSubmitted(context),
          label: localizations.shared_profile_report_modal_title(profile.displayName),
          primaryColor: colors.white,
          style: PositiveButtonStyle.primary,
          isDisabled: !isValid || state.isBusy,
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          onTapped: () => Navigator.pop(context),
          label: localizations.shared_actions_cancel,
          primaryColor: colors.black,
          style: PositiveButtonStyle.primary,
          isDisabled: state.isBusy,
        ),
      ],
    );
  }
}
