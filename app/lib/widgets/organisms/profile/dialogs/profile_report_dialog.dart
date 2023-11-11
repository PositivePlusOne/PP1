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
import 'package:app/helpers/cache_helpers.dart';
import 'package:app/hooks/cache_hook.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/atoms/input/positive_text_field_dropdown.dart';
import 'package:app/widgets/organisms/account/dialogs/account_feedback_dialog.dart';
import 'package:app/widgets/organisms/account/vms/account_view_model.dart';
import '../../../../providers/system/design_controller.dart';

class ProfileReportDialog extends HookConsumerWidget {
  const ProfileReportDialog({
    required this.targetProfileId,
    required this.currentProfileId,
    this.blockAndReport = false,
    super.key,
  });

  final String targetProfileId;
  final String currentProfileId;
  final bool blockAndReport;

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

    final CacheController cacheController = ref.read(cacheControllerProvider);

    final Profile? currentProfile = cacheController.get(currentProfileId);
    final Profile? targetProfile = cacheController.get(targetProfileId);

    final List<String> expectedCacheKeys = buildExpectedCacheKeysForProfile(currentProfile, targetProfile ?? Profile.empty());
    useCacheHook(keys: expectedCacheKeys);

    final String profileDisplayName = targetProfile?.displayName.asHandle ?? '';
    final String continueButtonText = blockAndReport ? localizations.shared_profile_modal_action_block_report(profileDisplayName) : localizations.shared_profile_report_modal_title(profileDisplayName);

    return Column(
      children: <Widget>[
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
            reportee: targetProfile,
            reporter: currentProfile,
          ),
          icon: UniconsLine.exclamation_octagon,
          label: continueButtonText,
          forceIconPadding: (continueButtonText.length >= 25) ? true : false,
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
