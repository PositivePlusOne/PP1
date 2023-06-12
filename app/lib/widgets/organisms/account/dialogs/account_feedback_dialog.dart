// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fluent_validation/models/validation_result.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/database/feedback/feedback_type.dart';
import 'package:app/widgets/atoms/input/positive_text_field.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import 'package:app/widgets/organisms/account/vms/account_view_model.dart';
import '../../../../constants/design_constants.dart';
import '../../../../dtos/system/design_colors_model.dart';
import '../../../../dtos/system/design_typography_model.dart';
import '../../../../providers/system/design_controller.dart';
import '../../../atoms/buttons/enumerations/positive_button_style.dart';
import '../../../atoms/buttons/positive_button.dart';

class AccountFeedbackDialog extends ConsumerWidget {
  const AccountFeedbackDialog({super.key});

  static const int kFeedbackLineCount = 7;
  static const int kFeedbackMinimumLength = 10;
  static const int kFeedbackMaximumLength = 5000;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    // Get a new account vm provider by passing in the GenericFeedback type
    final AccountViewModelProvider viewModelProvider = accountViewModelProvider.call(const FeedbackType.genericFeedback());
    final AccountViewModel viewModel = ref.read(viewModelProvider.notifier);
    final AccountViewModelState state = ref.watch(viewModelProvider);

    final ValidationResult validationResults = viewModel.feedbackValidator.validate(state.feedback);
    final bool isValid = validationResults.hasError == false;

    return PositiveDialog(
      title: 'Provide Feedback',
      children: <Widget>[
        Text(
          'We are always looking for your feedback on improvements, nice to have and those pesky bugs in the app. Please complete the form below with any information you can provide',
          style: typography.styleSubtitle.copyWith(color: colors.white),
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveTextField(
          hintText: 'Feedback',
          minLines: AccountFeedbackDialog.kFeedbackLineCount,
          maxLines: AccountFeedbackDialog.kFeedbackLineCount,
          onTextChanged: viewModel.onFeedbackUpdated,
          isEnabled: !state.isBusy,
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          onTapped: () => viewModel.onFeedbackSubmitted(context),
          label: 'Provide Feedback',
          primaryColor: colors.white,
          style: PositiveButtonStyle.primary,
          isDisabled: !isValid || state.isBusy,
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          onTapped: () => Navigator.pop(context),
          label: 'Cancel',
          primaryColor: colors.black,
          style: PositiveButtonStyle.primary,
          isDisabled: state.isBusy,
        ),
      ],
    );
  }
}
