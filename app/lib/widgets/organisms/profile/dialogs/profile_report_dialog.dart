// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart';
import 'package:fluent_validation/fluent_validation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/feedback/feedback_type.dart';
import 'package:app/dtos/database/feedback/report_type.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/atoms/input/positive_text_field_dropdown.dart';
import 'package:app/widgets/organisms/account/dialogs/account_feedback_dialog.dart';
import 'package:app/widgets/organisms/account/vms/account_view_model.dart';
import '../../../../providers/system/design_controller.dart';

class ProfileReportDialog extends ConsumerWidget {
  const ProfileReportDialog({
    required this.currentUserProfile,
    required this.targetProfile,
    super.key,
  });

  final Profile currentUserProfile;
  final Profile targetProfile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final AccountViewModelProvider viewModelProvider = accountViewModelProvider.call(const FeedbackType.userReport());
    final AccountViewModel viewModel = ref.read(viewModelProvider.notifier);
    final AccountViewModelState state = ref.watch(viewModelProvider);

    final ValidationResult validationResults = viewModel.feedbackValidator.validate(state.feedback);
    final bool isValid = validationResults.hasError == false;

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        Text(
          localizations.shared_profile_report_modal_subtitle,
          style: typography.styleSubtitle.copyWith(color: colors.white),
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveTextFieldDropdown(
          initialValue: const ReportType.unknown(),
          onValueChanged: (type) => viewModel.onReportTypeUpdated(type),
          values: ReportType.values.whereNot((element) => element == const ReportType.unknown()).toList(),
          isEnabled: !state.isBusy,
          placeholderStringBuilder: (value) => value.when(
            unknown: () => localizations.shared_report_placeholder_label,
            inappropriateContent: () => localizations.shared_report_types_inappropriate_content,
            harassment: () => localizations.shared_report_types_harassment,
            spam: () => localizations.shared_report_types_spam,
            other: () => localizations.shared_report_types_other,
          ),
          valueStringBuilder: (value) => value.when(
            unknown: () => localizations.shared_report_types_unknown,
            inappropriateContent: () => localizations.shared_report_types_inappropriate_content,
            harassment: () => localizations.shared_report_types_harassment,
            spam: () => localizations.shared_report_types_spam,
            other: () => localizations.shared_report_types_other,
          ),
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
          onTapped: () => viewModel.onFeedbackSubmitted(
            context,
            reportee: targetProfile,
            reporter: currentUserProfile,
          ),
          icon: UniconsLine.exclamation_octagon,
          label: localizations.shared_profile_report_modal_title(targetProfile.displayName.asHandle),
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
